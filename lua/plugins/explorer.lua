-- lua/plugins/explorer.lua
-- File navigation: neo-tree (sidebar), oil (directory as a buffer), snacks overrides.
return {
  -- snacks.nvim: LazyVim ships it for the picker, notifications, dashboard, etc.
  -- Here the snacks explorer and animated indent guides are switched off.
  -- Other snacks modules you can toggle the same way: dashboard, notifier, scroll,
  -- words, bigfile, statuscolumn (e.g. `scroll = { enabled = false }`)
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false }, -- remove this line to re-enable the snacks explorer
      picker = {
        sources = {
          explorer = {
            layout = {
              auto_hide = { "input" },
            },
          },
        },
      },
      indent = { enabled = false }, -- indent-blankline in ui.lua is used instead
    },
  },

  -- neo-tree: file explorer with git status and expand/collapse arrows.
  -- Bound to <leader>e AND <leader>E in the VeryLazy autocmd in config/keymaps.lua,
  -- which removes LazyVim's default Snacks-explorer binds first. There is no `keys`
  -- table here on purpose: that autocmd is the single source of truth.
  --
  -- OPTIONS YOU CAN ADD to `opts` below:
  --   close_if_last_window = true            quit nvim when the tree is the last window
  --   window = { position = "left", width = 30 }   "left" | "right" | "float", and its width
  --   window = { mappings = { ["<space>"] = "none" } }   unbind or rebind keys inside the tree
  --   default_component_configs = { git_status = { symbols = { ... } } }   git icons
  --   filesystem = { filtered_items = { hide_by_name = { "node_modules" } } }
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    opts = {
      filesystem = {
        follow_current_file = { enabled = true }, -- highlight the file you're editing
        use_libuv_file_watcher = true, -- auto-refresh when files change on disk
        filtered_items = {
          visible = true, -- show filtered items grayed-out instead of hiding; false hides entirely
          hide_dotfiles = false, -- show .env, .gitignore, etc.
          hide_gitignored = false, -- show node_modules and other gitignored paths
          hide_by_name = {},
          never_show = {},
        },
      },
      default_component_configs = {
        indent = {
          with_markers = false, -- true = draw indent guide lines in the tree
          -- with_expanders = true, expander_collapsed = ">", expander_expanded = "v", -- custom arrows
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Force off line numbers / signcolumn in the tree window specifically,
      -- so they never bleed in regardless of global toggles.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.wo.number = false
          vim.wo.relativenumber = false
          vim.wo.signcolumn = "no"
        end,
      })
    end,
  },

  -- Oil: edit a directory as a text buffer (bulk renames/moves, save to apply).
  -- Complements neo-tree, which acts on the filesystem directly. Open with <leader>o.
  --
  -- OPTIONS YOU CAN ADD to `opts`:
  --   default_file_explorer = true            use Oil instead of netrw when opening a folder
  --   delete_to_trash = true                  send deletes to the trash instead of removing
  --   skip_confirm_for_simple_edits = true    no confirmation prompt for simple changes
  --   columns = { "icon", "permissions", "size", "mtime" }   what to show per file
  --   float = { padding = 2 }                 settings for the floating window (:Oil --float)
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true }, -- show dotfiles
      keymaps = {
        ["<C-h>"] = false, -- keep window navigation
        ["<C-l>"] = false,
      },
    },
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
  },
}
