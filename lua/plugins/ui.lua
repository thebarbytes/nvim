-- lua/plugins/ui.lua
-- Visual tweaks: indent guides, highlighters, icons, bufferline.
-- (Colorschemes are in themes.lua, the bottom bar is in your statusline file.)
return {
  -- Indent guides (ibl). snacks' own indent is disabled in explorer.lua.
  -- OPTIONS YOU CAN CHANGE:
  --   indent.char = "▏"        other styles: "│" "┊" "¦" "┆"
  --   indent.tab_char = "▏"    separate character for tab indents
  --   scope.enabled = true     highlight the current block's guide
  --   scope.show_start = false hide the underline at the start of the scope
  --   exclude = { filetypes = { "help", "dashboard" } }   where guides stay off
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = true,
    opts = {
      indent = { char = "▏" },
      scope = { enabled = false },
      whitespace = { remove_blankline_trail = true },
    },
  },

  -- Rainbow delimiters: colors matching brackets by nesting level.
  -- OPTIONS: set the global table before it loads, for example
  --   vim.g.rainbow_delimiters = { highlight = { "RainbowDelimiterRed", "RainbowDelimiterBlue" } }
  { "HiPhish/rainbow-delimiters.nvim", event = "BufReadPost" },

  -- Color highlighter: shows #fff, rgb(), and Tailwind classes in their own color.
  -- OPTIONS YOU CAN CHANGE:
  --   filetypes = { "*", "!lazy" }       "*" = every filetype; "!name" excludes one
  --   mode = "background"                "background" | "foreground" | "virtualtext"
  --   names = false                      stop "red", "blue", ... from being colored
  --   tailwind = true                    true | "normal" | "lsp" | "both"
  --   Each of RGB, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, css, css_fn turns one color format on/off
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

  -- Markdown renderer: prettier headings, code blocks, bullets in the buffer.
  -- OPTIONS YOU CAN CHANGE:
  --   heading = { icons = { "󰲡 ", "󰲣 " }, backgrounds = {} }   heading icons / background colors
  --   code = { sign = false, width = "block", left_pad = 2, right_pad = 4, border = "thin" }
  --   bullet = { icons = { "●", "○" } }
  --   checkbox = { unchecked = { icon = "󰄱 " }, checked = { icon = "󰱒 " } }
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      code = { sign = false, width = "block", right_pad = 4 },
      heading = { sign = false, backgrounds = {} },
    },
  },

  -- Highlight other occurrences of the word under the cursor (word only; the
  -- cursorline itself stays LazyVim's default).
  -- OPTIONS YOU CAN CHANGE:
  --   cursorword.min_length = 3                    shortest word that gets highlighted
  --   cursorword.hl = { underline = true }         or { bg = "#333333" } for a background instead
  --   cursorline = { enable = true, timeout = 1000, number = false }   the plugin's own cursorline
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

  -- Icons: nvim-web-devicons is pointed at the nvim-material-icon fork (drop-in swap).
  -- OPTIONS YOU CAN CHANGE:
  --   color_icons = true      false = all icons in one color
  --   default = true          show a default icon for unknown file types
  --   override = { ... }      custom icon per filetype / extension
  {
    "nvim-tree/nvim-web-devicons",
    url = "https://github.com/DaikyXendo/nvim-material-icon",
    opts = {
      color_icons = true,
      default = true,
    },
  },
  -- real-icons: real-looking file icons. `build` downloads its icon set once.
  -- `integrations` picks where it applies: turn any to false to keep the old icons there.
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

  -- Error lens: shows diagnostic text at the end of the line.
  -- No setup call here, so it runs with its defaults. To customize, add `opts = { ... }`
  -- (see the plugin's README for the current keys).
  {
    "chikko80/error-lens.nvim",
    event = "BufRead",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },

  -- Bufferline: the tab bar at the top. Here it's minimal with fully transparent tabs.
  -- OPTIONS YOU CAN CHANGE (inside opts.options):
  --   always_show_bufferline = true    false = hide the bar when only one buffer is open
  --   show_buffer_icons = true         file icon on each tab
  --   show_buffer_close_icons = false  the x on each tab
  --   separator_style = { "", "" }     "slant" | "slope" | "thick" | "thin" | { "", "" } (none)
  --   indicator = { style = "none" }   "icon" | "underline" | "none" (mark on the active tab)
  --   diagnostics = "nvim_lsp"         show error counts on tabs
  --   max_name_length = 18, truncate_names = true
  --   offsets                          space reserved next to side panels (neo-tree here)
  -- COLORS: the lists below make every state transparent (bg = "NONE").
  --   To give the selected tab a color, change `_selected` to { bg = "#44475a" }.
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.show_buffer_icons = true
      opts.options.show_buffer_close_icons = false -- removes the x on each tab
      opts.options.separator_style = { "", "" } -- removes the line between tabs
      opts.options.indicator = { style = "none" } -- removes the bar on the active tab
      opts.options.offsets = {
        { filetype = "neo-tree", text = "", separator = false },
      }

      -- Highlight groups that get a _visible / _selected variant
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
      -- Highlight groups used as-is
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
}
