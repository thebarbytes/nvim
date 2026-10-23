-- lua/plugins/themes.lua
-- To change the active theme, edit the colorscheme line in the first entry.
-- Try any theme without changing the file: :colorscheme <name>

-- ---------------------------------------------------------------------------
-- Miasma tweak: miasma draws squiggly (undercurl) lines in many places.
-- This swaps every squiggle for a style you choose, whatever the highlight group is.
--   "underline"  plain straight underline in the same color
--   "bg"         soft background tint in the same color (no underline)
--   "none"       no marking at all
-- BG_STRENGTH is how strong the tint is when the style is "bg" (0.0 to 1.0).
-- ---------------------------------------------------------------------------
local SQUIGGLE_STYLE = ""
local BG_STRENGTH = 0.25

-- Mixes two 0xRRGGBB colors; alpha = how much of `fg` shows through
local function blend(fg, bg, alpha)
  local function channel(shift)
    local f = bit.band(bit.rshift(fg, shift), 0xff)
    local b = bit.band(bit.rshift(bg, shift), 0xff)
    return math.floor(f * alpha + b * (1 - alpha) + 0.5)
  end
  return channel(16) * 65536 + channel(8) * 256 + channel(0)
end

local function remove_squiggles()
  -- Only touch highlights while miasma is the active theme
  if vim.g.colors_name ~= "miasma" then
    return
  end

  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
    if not hl.link and hl.undercurl then
      local new = vim.deepcopy(hl)
      new.undercurl = false
      local color = hl.sp or hl.fg

      if SQUIGGLE_STYLE == "underline" then
        new.underline = true
        new.sp = color
      elseif SQUIGGLE_STYLE == "bg" and color then
        new.bg = blend(color, normal.bg or 0x000000, BG_STRENGTH)
        new.sp = nil
      end -- "none": just drop the undercurl

      vim.api.nvim_set_hl(0, name, new)
    end
  end
end

return {
  -- Active theme (uncomment one line, comment the others)
  -- { "LazyVim/LazyVim", opts = { colorscheme = "miasma" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "forest-night" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "posterpole" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "onedark" } },

  {
    "xero/miasma.nvim",
    priority = 1000, -- load before everything else (it's the active theme)
    -- `init` runs at startup, so these hooks exist before any :colorscheme command.
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(remove_squiggles)
        end,
      })
      -- Catch plugins that define their highlights after startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.defer_fn(remove_squiggles, 50)
        end,
      })
    end,
  },

  -- Other themes: lazy.nvim only loads these when you run :colorscheme <name>
  { "adibhanna/forest-night.nvim", lazy = true }, -- :colorscheme forest-night

  {
    "ilof2/posterpole.nvim",
    lazy = true, -- :colorscheme posterpole
    config = function()
      require("posterpole").setup({
        -- options go here (see the plugin's README)
      })
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true, -- :colorscheme gruvbox
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

  { "timmypidashev/darkbox.nvim", lazy = true }, -- :colorscheme darkbox

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha", -- "latte" | "frappe" | "macchiato" | "mocha"
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
      style = "dark", -- dark, darker, cool, deep, warm, warmer
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
      style = "night", -- "storm" | "moon" | "night" | "day"
      transparent = false,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  { "rebelot/kanagawa.nvim", lazy = true }, -- :colorscheme kanagawa
}
