-- lua/plugins/dev.lua
-- =============================================================================
-- All non-UI, dev-functionality plugins ported from the old init.lua.
-- Anything that changes the LOOK of LazyVim (theme, dashboard, statusline,
-- bufferline, notify/noice, indent-blankline, scrollbar, which-key, zen-mode)
-- is intentionally NOT here — LazyVim's defaults are kept for those.
-- =============================================================================

return {
  -- 1. Completely disable lualine so it doesn't run in the background
  { "nvim-lualine/lualine.nvim", enabled = false },

  -- 2. Install and configure mini.statusline
  {
    "nvim-mini/mini.statusline",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.statusline").setup({
        -- Use icons (requires a Nerd Font like JetBrains Mono)
        use_icons = true,

        -- Optional: customize content sections if you want a specific layout
        content = {
          active = function()
            local statusline = require("mini.statusline")

            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local diff = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
              "%<", -- Mark truncation point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment / start right alignment
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { location } },
            })
          end,
        },
      })
    end,
  },

  -- ===========================================================================
  -- WakaTime — time tracking. Key is read from ~/.wakatime.cfg.
  -- ===========================================================================
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     opts.window = {
  --       completion = cmp.config.window.bordered(),
  --       documentation = cmp.config.window.bordered(),
  --     }
  --   end,
  -- },

  -- ===========================================================================
  -- LSP — extra servers LazyVim/mason doesn't set up for you by default,
  -- using the same manual `cmd` paths you had before (bypasses mason install).
  -- ===========================================================================
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders=false",
          },
        },
        astro = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.npm-global/bin/astro-ls"), "--stdio" },
          init_options = {
            typescript = {
              tsdk = vim.fn.expand("$HOME/.npm-global/lib/node_modules/typescript/lib"),
            },
          },
        },
        pyright = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.npm-global/bin/pyright-langserver"), "--stdio" },
        },
        csharp_ls = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.dotnet/tools/csharp-ls") },
        },
        intelephense = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.npm-global/bin/intelephense"), "--stdio" },
        },
        tailwindcss = {
          mason = false,
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              telemetry = { enable = false },
            },
          },
        },
        asm_lsp = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.cargo/bin/asm-lsp") },
          filetypes = { "asm", "nasm", "masm" },
          init_options = { dialect = "nasm" },
        },
        neocmakelsp = {
          mason = false,
          cmd = { "neocmakelsp", "--stdio" },
          init_options = {
            format = { enable = true },
            scan_cmake_in_package = true,
          },
        },
        rust_analyzer = {
          mason = false,
          cmd = { vim.fn.expand("$HOME/.cargo/bin/rust-analyzer") },
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              cargo = { allFeatures = true },
              procMacro = { enable = true },
            },
          },
        },
        marksman = { mason = false },
        bashls = { mason = true },
      },
    },
  },

  -- Disable diagnostics for asm files (asm-lsp is noisy)
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "asm", "nasm", "masm" },
        callback = function()
          vim.diagnostic.enable(false, { bufnr = 0 })
        end,
      })
    end,
  },

  -- jdtls — Java (manual vim.lsp.start, same as old config)
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local root_dir = vim.fs.dirname(vim.fs.find({ ".git", "pom.xml", "build.gradle" }, { upward = true })[1])
          local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. vim.fn.fnamemodify(root_dir, ":p:h:t")
          vim.lsp.start({
            name = "jdtls",
            cmd = { "jdtls", "-data", workspace_dir },
            root_dir = root_dir,
          })
        end,
      })
    end,
  },

  -- ===========================================================================
  -- Inline diagnostics — floating-style boxes, replaces default virtual_text
  -- ===========================================================================
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    enabled = false,
    priority = 1000, -- load before other UI plugins that touch diagnostics
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern", -- try "classic", "minimal", "powerline", "ghost" too
        options = {
          show_source = false,
          throttle = 20,
          softwrap = 30, -- wraps long messages instead of letting them overflow
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- turn off LazyVim's default so they don't overlap
    end,
  },

  -- ===========================================================================
  -- TypeScript — lightweight native tsserver client, replaces ts_ls/typescript.nvim
  -- ===========================================================================
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        tsserver_max_memory = 2048,
        separate_diagnostic_server = false,
        publish_diagnostic_on = "insert_leave",
        code_lens = "off",
      },
    },
  },

  { "neovim/nvim-lspconfig", opts = { servers = { ts_ls = { enabled = false }, tsserver = { enabled = false } } } },

  -- ===========================================================================
  -- Formatting (conform.nvim) — override LazyVim's defaults with your setup
  -- ===========================================================================
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        -- clang_format = {
        --   prepend_args = {
        --     "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: ForIndentation}",
        --   },
        -- },
        clang_format = {
          prepend_args = function(_, ctx)
            local w = vim.bo[ctx.buf].shiftwidth
            local use_tabs = vim.bo[ctx.buf].expandtab and "Never" or "ForIndentation"
            return {
              ("--style={BasedOnStyle: LLVM, IndentWidth: %d, TabWidth: %d, UseTab: %s}"):format(w, w, use_tabs),
            }
          end,
        },
        asmfmt = {
          command = vim.fn.expand("$HOME/go/bin/asmfmt"),
        },
        -- prettier = {
        --   prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
        -- },
        prettier = {
          prepend_args = function(_, ctx)
            local w = tostring(vim.bo[ctx.buf].shiftwidth)
            local tabs = not vim.bo[ctx.buf].expandtab
            return { "--tab-width", w, "--use-tabs", tostring(tabs) }
          end,
        },
        php_cs_fixer = {
          command = vim.fn.expand("$HOME/.config/composer/vendor/bin/php-cs-fixer"),
          args = { "fix", "$FILENAME" },
        },
      },
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        rust = { "rustfmt" },
        asm = { "asmfmt" },
        nasm = { "asmfmt" },
        masm = { "asmfmt" },
        lua = { "stylua" },
        python = { "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        cmake = { "prettier" },
        php = { "php_cs_fixer" },
      },
    },
  },

  -- ===========================================================================
  -- Editing tools not in LazyVim by default
  -- ===========================================================================

  -- indent-blankline (ibl) — override LazyVim's default style
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = true,
    opts = {
      indent = { char = "▏" },
      -- indent = { char = "¦" },
      scope = { enabled = false },
      whitespace = { remove_blankline_trail = true },
    },
  },

  -- disable snacks' own explorer picker (neo-tree owns <leader>e / <leader>E now)
  -- + kill the animated current-scope indent highlight
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false }, -- remove this line, re-enable explorer
      picker = {
        sources = {
          explorer = {
            layout = {
              auto_hide = { "input" },
            },
          },
        },
      },
      indent = { enabled = false },
    },
  },

  -- ===========================================================================
  -- neo-tree — file explorer with git status + expand/collapse arrows.
  -- Bound to <leader>e AND <leader>E via the VeryLazy autocmd in keymaps.lua,
  -- which force-deletes LazyVim's default Snacks-explorer binds first so
  -- neither key falls back to netrw. No `keys` table here on purpose —
  -- that autocmd is the single source of truth for both keymaps.
  -- ===========================================================================
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
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- show filtered items grayed-out instead of hiding; set false to hide entirely
          hide_dotfiles = false, -- show .env, .gitignore, etc.
          hide_gitignored = false, -- show node_modules and other gitignored paths
          hide_by_name = {},
          never_show = {},
        },
      },
      default_component_configs = {
        --   indent = { with_expanders = true, expander_collapsed = ">", expander_expanded = "v" },
        indent = {
          with_markers = false,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Belt-and-suspenders: force off line numbers / signcolumn in the tree
      -- window specifically, so they never bleed in regardless of global toggles.
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

  -- ===========================================================================
  -- Oil — file manager as a buffer, for bulk renames/moves as plain text edits.
  -- Complements neo-tree: neo-tree's copy/cut/paste acts on the filesystem
  -- directly, Oil lets you edit a directory listing as text and save it.
  -- ===========================================================================
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    },
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
    },
  },

  -- Leap — fast motion
  {
    "https://codeberg.org/andyg/leap.nvim",
    keys = { "s", "S" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-back)")
    end,
  },

  -- nvim-surround (replaces LazyVim's default mini.surround)
  { "nvim-mini/mini.surround", enabled = true },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment.nvim + ts-context-commentstring (replaces LazyVim's default mini.comment)
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

  -- nvim-autopairs + cmp integration (replaces LazyVim's default mini.pairs)
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Auto close/rename HTML & JSX tags
  { "windwp/nvim-ts-autotag", opts = {} },

  -- Rainbow delimiters
  { "HiPhish/rainbow-delimiters.nvim", event = "BufReadPost" },

  -- Color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
      },
    },
  },

  -- Markdown renderer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      code = { sign = false, width = "block", right_pad = 4 },
      heading = { sign = false, backgrounds = {} },
    },
  },

  -- Highlight word under cursor (word only — cursorline itself stays LazyVim default)
  {
    "yamatsum/nvim-cursorline",
    event = "BufReadPost",
    opts = {
      cursorline = { enable = false },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    },
  },

  -- Bufferline
  -- {
  --   "akinsho/bufferline.nvim",
  --   opts = {
  --     -- source_selector = { winbar = false, statusline = false },
  --     options = {
  --       always_show_bufferline = true,
  --       show_buffer_icons = false,
  --     },
  --   },
  -- },
  -- {
  --   "akinsho/bufferline.nvim",
  --   opts = function(_, opts)
  --     opts.options = opts.options or {}
  --     opts.options.always_show_bufferline = true
  --     opts.options.show_buffer_icons = false
  --     opts.options.show_buffer_close_icons = false -- removes the x on each tab
  --     opts.options.separator_style = { "", "" } -- removes the line between tabs
  --     -- opts.options.separator_style = "slant"
  --     opts.options.indicator = { style = "none" } -- removes the bar on the active tab
  --     opts.options.offsets = {
  --       { filetype = "neo-tree", text = "", separator = false },
  --     }
  --   end,
  -- },
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   opts = {
  --     -- Enables the colorful VS Code style file icons
  --     color_icons = true,
  --     default = true,
  --   },
  -- },
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   dependencies = { "DaikyXendo/nvim-material-icon" },
  --   opts = function()
  --     return {
  --       override = require("nvim-material-icon").get_icons(),
  --       color_icons = true,
  --       default = true,
  --     }
  --   end,
  -- },
  {
    "nvim-tree/nvim-web-devicons",
    url = "https://github.com/DaikyXendo/nvim-material-icon",
    opts = {
      color_icons = true,
      default = true,
    },
  },
  {
    "Mirsmog/real-icons.nvim",
    build = ":RealIcons install",
    opts = {
      integrations = {
        neo_tree = true,
        bufferline = true,
        mini_statusline = true,
      },
    },
  },
  {
    "chikko80/error-lens.nvim",
    event = "BufRead",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    -- opts = {
    --     -- your options go here
    -- },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.show_buffer_icons = true
      opts.options.show_buffer_close_icons = false
      opts.options.separator_style = { "", "" }
      opts.options.indicator = { style = "none" }
      opts.options.offsets = {
        { filetype = "neo-tree", text = "", separator = false },
      }

      local bases = {
        "numbers",
        "diagnostic",
        "hint",
        "hint_diagnostic",
        "info",
        "info_diagnostic",
        "warning",
        "warning_diagnostic",
        "error",
        "error_diagnostic",
        "modified",
        "duplicate",
        "separator",
        "close_button",
        "pick",
        "buffer",
        "indicator",
      }
      local bare = {
        "fill",
        "background",
        "tab",
        "tab_selected",
        "tab_separator",
        "tab_separator_selected",
        "tab_close",
        "offset_separator",
        "trunc_marker",
        "numbers",
        "diagnostic",
        "hint",
        "hint_diagnostic",
        "info",
        "info_diagnostic",
        "warning",
        "warning_diagnostic",
        "error",
        "error_diagnostic",
        "modified",
        "duplicate",
        "separator",
        "close_button",
        "pick",
      }

      local hl = {}
      for _, name in ipairs(bare) do
        hl[name] = { bg = "NONE" }
      end
      for _, base in ipairs(bases) do
        hl[base .. "_visible"] = { bg = "NONE" }
        hl[base .. "_selected"] = { bg = "NONE", bold = true, italic = false }
      end
      hl.tab_selected = { bg = "NONE", bold = true, italic = false }
      hl.tab_separator_selected = { bg = "NONE" }

      opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, hl)
    end,
  },
  -- {
  --   "akinsho/bufferline.nvim",
  --   opts = function(_, opts)
  --     opts.options = opts.options or {}
  --     opts.options.always_show_bufferline = true
  --     opts.options.show_buffer_icons = true
  --     opts.options.show_buffer_close_icons = false
  --     opts.options.separator_style = { "", "" }
  --     opts.options.indicator = { style = "none" }
  --     opts.options.offsets = {
  --       { filetype = "neo-tree", text = "", separator = false },
  --     }
  --
  --     local selected_bg = "#44475a" -- dracula current line / selection
  --
  --     local bases = {
  --       "numbers",
  --       "diagnostic",
  --       "hint",
  --       "hint_diagnostic",
  --       "info",
  --       "info_diagnostic",
  --       "warning",
  --       "warning_diagnostic",
  --       "error",
  --       "error_diagnostic",
  --       "modified",
  --       "duplicate",
  --       "separator",
  --       "close_button",
  --       "pick",
  --       "buffer",
  --       "indicator",
  --     }
  --     local bare = {
  --       "fill",
  --       "background",
  --       "tab",
  --       "tab_selected",
  --       "tab_separator",
  --       "tab_separator_selected",
  --       "tab_close",
  --       "offset_separator",
  --       "trunc_marker",
  --       "numbers",
  --       "diagnostic",
  --       "hint",
  --       "hint_diagnostic",
  --       "info",
  --       "info_diagnostic",
  --       "warning",
  --       "warning_diagnostic",
  --       "error",
  --       "error_diagnostic",
  --       "modified",
  --       "duplicate",
  --       "separator",
  --       "close_button",
  --       "pick",
  --     }
  --
  --     local hl = {}
  --     for _, name in ipairs(bare) do
  --       hl[name] = { bg = "NONE" }
  --     end
  --     for _, base in ipairs(bases) do
  --       hl[base .. "_visible"] = { bg = "NONE" }
  --       hl[base .. "_selected"] = { bg = selected_bg }
  --     end
  --     hl.tab_selected = { bg = selected_bg }
  --     hl.tab_separator_selected = { bg = selected_bg }
  --
  --     opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, hl)
  --   end,
  -- },
  -- ===========================================================================
  -- Git
  -- ===========================================================================
  { "tpope/vim-fugitive", cmd = { "G", "Git" } },

  -- ===========================================================================
  -- GnuPG — transparent encrypt/decrypt of .gpg/.asc/.pgp files
  -- ===========================================================================
  {
    "jamessan/vim-gnupg",
    init = function()
      vim.g.GPGPreferArmor = 1
      vim.g.GPGPreferSign = 0
      vim.g.GPGDefaultRecipients = { "zyruuuusan@gmail.com" }
    end,
  },

  -- ===========================================================================
  -- Terminal — floating, numbered instances
  -- ===========================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = { [[<D-i>]], [[<D-1>]], [[<D-2>]], [[<D-3>]], [[<D-4>]], "<A-h>", "<A-v>" },
    opts = {
      direction = "float",
      open_mapping = [[<D-i>]],
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local map = vim.keymap.set
      for i = 1, 4 do
        map(
          "n",
          "<D-" .. i .. ">",
          "<cmd>" .. i .. "ToggleTerm direction=float<cr>",
          { desc = "Toggle float terminal " .. i }
        )
      end
      map("n", "<A-h>", "<cmd>ToggleTerm direction=horizontal<cr>")
      map("n", "<A-v>", "<cmd>ToggleTerm direction=vertical<cr>")
    end,
  },

  -- ===========================================================================
  -- Harpoon — quick file bookmarks
  -- ===========================================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>ha", "<leader>hh", "<leader>1", "<leader>2", "<leader>3", "<leader>4" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      local map = vim.keymap.set
      map("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })
      map("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })
      map("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon file 1" })
      map("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon file 2" })
      map("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon file 3" })
      map("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file 4" })
    end,
  },

  -- ===========================================================================
  -- Telescope file browser
  -- ===========================================================================
  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  --   keys = { "<leader>fe" },
  --   config = function()
  --     require("telescope").load_extension("file_browser")
  --     vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>")
  --   end,
  -- },

  -- ===========================================================================
  -- Treesitter textobjects — structural select/move (functions, components,
  -- parameters). MUST be branch = "main" to match LazyVim's main-branch
  -- nvim-treesitter; the old `nvim-treesitter.configs` API no longer exists,
  -- so select/move are wired as plain keymaps calling the plugin's modules.
  -- ===========================================================================
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
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

  -- ===========================================================================
  -- ts-error-translator — turns raw TypeScript compiler errors into plain
  -- English inline (huge readability win for Next.js/React work)
  -- ===========================================================================
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },

  -- ===========================================================================
  -- SchemaStore — JSON/YAML schema validation + autocomplete for
  -- package.json, tsconfig.json, next.config schemas, etc.
  -- ===========================================================================
  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    -- opts as a function defers require("schemastore") until this spec is
    -- actually merged/applied by lazy.nvim, instead of running the instant
    -- dev.lua is parsed (before SchemaStore.nvim is guaranteed installed).
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.jsonls = vim.tbl_deep_extend("force", opts.servers.jsonls or {}, {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" }, -- disabled: schemastore.nvim supplies these instead
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      return opts
    end,
  },
}
