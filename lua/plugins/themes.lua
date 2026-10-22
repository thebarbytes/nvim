-- lua/plugins/themes.lua
-- To change the active theme, edit the colorscheme line in the first entry.
return {
  -- Active theme
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- load before everything else
    opts = {
      contrast = "hard", -- "hard", "soft" or "" (default)
      transparent_mode = false,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
    },
  },

  -- Other themes: lazy.nvim only loads these when you run :colorscheme <name>
  { "timmypidashev/darkbox.nvim", lazy = true }, -- :colorscheme darkbox

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        which_key = true,
        notify = true,
        noice = true,
        treesitter = true,
        indent_blankline = { enabled = false },
      },
    },
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    init = function()
      -- hide the vertical split line between windows (applies to every theme)
      vim.opt.fillchars:append({ vert = " " })
    end,
    opts = {
      style = "dark",
      transparent = true,
      term_colors = true,
      code_style = {
        comments = "none",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      lualine = { transparent = true },
      diagnostics = { darker = true, undercurl = true, background = false },
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  { "rebelot/kanagawa.nvim", lazy = true }, -- :colorscheme kanagawa
}
