-- lua/plugins/editor.lua
-- Editing behavior: motions, surround, comments, pairs, tags, textobjects.
return {
  -- Leap: jump anywhere on screen with `s` (forward) / `S` (backward) + 2 characters.
  -- OPTIONS: set them inside config, for example
  --   require("leap").opts.case_sensitive = true
  --   require("leap").opts.safe_labels = {}      -- disable the auto-jump on the first match
  -- NOTE: LazyVim's flash.nvim also binds s/S. If `s` ever behaves oddly, disable it with
  --   { "folke/flash.nvim", enabled = false },
  {
    "https://codeberg.org/andyg/leap.nvim",
    keys = { "s", "S" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-back)")
    end,
  },

  -- Surround: ysiw" (add), ds" (delete), cs"' (change), S" in visual mode.
  -- NOTE: this keeps LazyVim's mini.surround ENABLED next to nvim-surround.
  -- Set enabled = false if nvim-surround is meant to replace it.
  --
  -- OPTIONS YOU CAN ADD to `opts` (nvim-surround):
  --   keymaps = { normal = "ys", delete = "ds", change = "cs", visual = "S" }   rebind keys
  --   surrounds = { ... }       define your own pairs
  --   aliases = { ["b"] = ")" } short names for pairs
  --   highlight = { duration = 0 }
  { "nvim-mini/mini.surround", enabled = true },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Comments: gcc (toggle line), gc + motion (toggle block of lines), gbc (block comment).
  -- NOTE: same as above, mini.comment is kept ENABLED. Set false to replace it.
  -- Languages below get a custom comment style; add more to `languages`.
  --
  -- OPTIONS YOU CAN ADD to the Comment.setup({...}) call:
  --   padding = true                 space after the comment symbol
  --   sticky = true                  keep the cursor in place after commenting
  --   ignore = "^$"                  pattern of lines to skip (here: empty lines)
  --   toggler = { line = "gcc", block = "gbc" }
  --   opleader = { line = "gc", block = "gb" }
  { "nvim-mini/mini.comment", enabled = true },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = "VeryLazy",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          c = "// %s",
          cpp = "// %s",
          asm = "; %s",
          nasm = "; %s",
          masm = "; %s",
          rust = "// %s",
        },
      })
      require("Comment").setup({
        pre_hook = function(ctx)
          local cs = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
          return cs or vim.bo.commentstring
        end,
      })
    end,
  },

  -- Auto pairs: closes ( [ { " ' automatically (replaces LazyVim's mini.pairs).
  -- OPTIONS YOU CAN ADD to `opts`:
  --   disable_filetype = { "TelescopePrompt", "vim" }   where it stays off
  --   fast_wrap = {}                                    enable <M-e> to wrap text in a pair
  --   enable_check_bracket_line = false                 pair even if the line already has a closing bracket
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true }, -- use treesitter to decide when to pair
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Auto close/rename HTML & JSX tags. OPTIONS (inside `opts`):
  --   opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false }
  { "windwp/nvim-ts-autotag", opts = {} },

  -- Treesitter textobjects: structural select/move (functions, components, parameters).
  -- MUST be branch = "main" to match LazyVim's main-branch nvim-treesitter. The old
  -- `nvim-treesitter.configs` API no longer exists, so select/move are plain keymaps
  -- calling the plugin's modules.
  --
  -- KEYS (change the first string of any vim.keymap.set to rebind):
  --   af / if   around / inside function        ac / ic   class or component
  --   aa / ia   around / inside parameter
  --   ]f / [f   next / previous function        ]a / [a   next / previous parameter
  -- Other captures you can use in place of "@function.outer":
  --   @block.outer  @conditional.outer  @loop.outer  @call.outer  @comment.outer
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true }, -- jump forward to the next match if none is under the cursor
        move = { set_jumps = true }, -- record moves in the jumplist (use <C-o> to go back)
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select
      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end, { desc = "Select around function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inside function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end, { desc = "Select around class/component" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inside class/component" })
      vim.keymap.set({ "x", "o" }, "aa", function()
        select.select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select around parameter" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        select.select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select inside parameter" })

      -- Move
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "]a", function()
        move.goto_next_start("@parameter.inner", "textobjects")
      end, { desc = "Next parameter" })
      vim.keymap.set({ "n", "x", "o" }, "[a", function()
        move.goto_previous_start("@parameter.inner", "textobjects")
      end, { desc = "Previous parameter" })
    end,
  },
}
