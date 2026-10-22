-- lua/plugins/themes.lua
return {
  -- THE BEST
  -- { "LazyVim/LazyVim", opts = { colorscheme = "onedark" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "solarized-osaka-vivid" } },

  -- { "LazyVim/LazyVim", opts = { colorscheme = "material-darker" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "github_dark_high_contrast" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "doom-one" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "ayu-mirage" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "dracula" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "adwaita" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "cyberdream" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "dark2026" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "onedark" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "darcula" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "monokai-pro-classic" } },
  -- { "LazyVim/LazyVim", opts = { colorscheme = "monokai-pro-classic" } },
  -- {
  --   "Mofiqul/dracula.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("dracula").setup({ transparent_bg = false, italic_comment = false, show_end_of_buffer = false })
  --   end,
  -- },
  {
    "binhtran432k/dracula.nvim",
    priority = 1000,
    opts = {
      transparent = false,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  -- {
  --   "iruzo/matrix-nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.matrix_disable_background = true -- keep kitty transparency
  --     vim.g.matrix_italic = false
  --     vim.g.matrix_contrast = false
  --     vim.cmd.colorscheme("matrix")
  --   end,
  -- },

  {
    "iruzo/matrix-nvim",
    priority = 1000,
    config = function()
      vim.g.matrix_disable_background = true -- keep kitty transparency
      vim.g.matrix_italic = false
      vim.g.matrix_contrast = false

      local ALL_GREEN = false -- true = turn every hue green, not just the grays

      local function recolor(c, is_bg)
        local r, g, b = math.floor(c / 65536) % 256, math.floor(c / 256) % 256, c % 256
        if r == 0 and b <= g then
          return c
        end -- already green
        if not ALL_GREEN and (math.max(r, g, b) - math.min(r, g, b)) > 24 then
          return c
        end
        local l = r * 0.3 + g * 0.59 + b * 0.11
        if not is_bg and l < 40 then
          return c
        end -- keep near-black text (on green bars)
        local gv = is_bg and l * 0.6 or math.min(255, l * 1.1 + 25)
        gv = math.floor(gv)
        return gv * 256 + math.floor(gv * 0.2)
      end

      local keys = { "bold", "italic", "underline", "undercurl", "strikethrough", "reverse", "sp", "blend" }
      local function apply()
        if vim.g.colors_name ~= "matrix" then
          return
        end -- only touch highlights when matrix is active
        for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
          if not hl.link then
            local new = {}
            for _, k in ipairs(keys) do
              new[k] = hl[k]
            end
            if hl.fg then
              new.fg = recolor(hl.fg, false)
            end
            if hl.bg then
              new.bg = recolor(hl.bg, true)
            end
            vim.api.nvim_set_hl(0, name, new)
          end
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(apply)
        end,
      })
      -- catch plugins (neo-tree, bufferline) that define highlights after startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.defer_fn(apply, 50)
        end,
      })
    end,
  },

  { "dsclementsen/vim-visualstudiodark", priority = 1000 },

  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "classic",
        background_clear = {},
        override = function(c)
          return {
            Comment = { italic = false },
            Keyword = { italic = false },
            Conditional = { italic = false },
            Repeat = { italic = false },
            Type = { italic = false },
            StorageClass = { italic = false },
            Structure = { italic = false },
            Typedef = { italic = false },
            Identifier = { italic = false },
            Function = { italic = false },
          }
        end,
      })
    end,
  },

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = false, -- Matches your other non-transparent setups
  --     styles = {
  --       comments = { italic = false },
  --       keywords = { italic = false },
  --       functions = { italic = false },
  --       variables = { italic = false },
  --     },
  --   },
  -- },

  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true, -- was false
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
    },
  },

  -- Emacs Legendary Dark Themes
  { "miikanissi/modus-themes.nvim", priority = 1000 }, -- :colorscheme modus_vivendi
  { "NTBBloodbath/doom-one.nvim", priority = 1000 }, -- :colorscheme doom-one
  { "phha/zenburn.nvim", dependencies = { "rktjmp/lush.nvim" }, priority = 1000 }, -- :colorscheme zenburn

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          which_key = true,
          notify = true,
          noice = true,
          treesitter = true,
          indent_blankline = { enabled = false },
        },
      })
    end,
  },

  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = false,
        underline_links = false,
        disable_nvimtree_bg = true,
      })
    end,
  },

  -- 1. Midnight.nvim: Built exactly for this. It uses deep black bases
  -- with intentionally low-saturation accents to stop eye fatigue.
  { "dasupradyumna/midnight.nvim", priority = 1000 }, -- :colorscheme midnight

  -- 2. Luna.nvim: A legendary near-black scheme that relies heavily on
  -- crisp structural gray contrast rather than messy background tints.
  { "WTFox/luna.nvim", priority = 1000 }, -- :colorscheme luna

  -- 3. Darkbox.nvim: If you want to keep the retro-earthy vibe of gruvbox
  -- but want a strict, OLED-friendly, absolute #000000 backdrop.
  { "timmypidashev/darkbox.nvim", priority = 1000 }, -- :colorscheme darkbox

  -- 4. Dark Modern 2026: A brand new Neovim port that replicates the absolute latest
  -- near-black theme engine with punchy neon syntax token maps.
  { "D0nw0r/dark2026.nvim", priority = 1000 }, -- :colorscheme dark2026

  -- 5. Doric Themes: A stellar Neovim port bringing Protesilaos' (the Modus author)
  -- alternate ultra-minimalist Emacs themes right into Neovim.
  -- { "heymanh/doric-themes.nvim", priority = 1000 }, -- :colorscheme doric-dark (or doric-water)

  -- { "folke/tokyonight.nvim", priority = 1000 },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night", -- night = darkest, "storm" is a bit lighter
      transparent = false,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "shaunsingh/nord.nvim", priority = 1000 },
  { "EdenEast/nightfox.nvim", priority = 1000 },
  -- { "navarasu/onedark.nvim", priority = 1000 },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    init = function()
      vim.opt.fillchars:append({ vert = " " })
    end,
    opts = {
      style = "dark", -- dark, darker, cool, deep, warm, warmer
      transparent = true,
      term_colors = true,
      code_style = {
        comments = "none", -- removes the default italic comments
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
      lualine = { transparent = true },
      diagnostics = { darker = true, undercurl = true, background = false },
    },
  },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
  { "sainnhe/everforest", priority = 1000 },
  -- { "craftzdog/solarized-osaka.nvim", priority = 1000 },
  -- { "projekt0n/github-nvim-theme", priority = 1000 },
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      require("github-theme").setup({
        groups = {
          all = {
            WinSeparator = { fg = "bg1", bg = "bg1" },
            NeoTreeWinSeparator = { fg = "bg1", bg = "bg1" },
          },
        },
      })
    end,
  },
  { "AlexvZyl/nordic.nvim", priority = 1000 },
  { "uloco/bluloco.nvim", dependencies = { "rktjmp/shipwright.nvim" }, priority = 1000 },
  { "mcchrish/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" }, priority = 1000 },
  { "rmehri01/onenord.nvim", priority = 1000 },
  { "sainnhe/gruvbox-material", priority = 1000 },
  { "sainnhe/sonokai", priority = 1000 },
  { "sainnhe/edge", priority = 1000 },
  { "barrientosvctor/abyss.nvim", priority = 1000 },

  -- VS Code / JetBrains flavors
  { "lunarvim/darkplus.nvim", priority = 1000 }, -- :colorscheme darkplus
  { "tomasiser/vim-code-dark", priority = 1000 }, -- :colorscheme codedark
  { "doums/darcula", priority = 1000 }, -- :colorscheme darcula
  { "nickkadutskyi/jb.nvim", priority = 1000 }, -- :colorscheme jb

  -- One Dark / Atom family
  -- { "olimorris/onedarkpro.nvim", priority = 1000 }, -- onedark_vivid, onedark_dark, onelight
  { "Th3Whit3Wolf/one-nvim", priority = 1000 },

  -- Popular dark themes
  { "bluz71/vim-nightfly-colors", name = "nightfly", priority = 1000 },
  { "bluz71/vim-moonfly-colors", name = "moonfly", priority = 1000 },
  { "marko-cerovac/material.nvim", priority = 1000 },
  { "Shatur/neovim-ayu", priority = 1000 }, -- ayu-dark, ayu-mirage, ayu-light
  { "oxfist/night-owl.nvim", priority = 1000 },
  { "tiagovla/tokyodark.nvim", priority = 1000 },
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    opts = {
      transparent = true, -- was false
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
    },
  },
  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
  { "Everblush/nvim", name = "everblush", priority = 1000 },
  { "cocopon/iceberg.vim", priority = 1000 },
  { "frenzyexists/aquarium-vim", priority = 1000 },
  { "rafamadriz/neon", priority = 1000 },
  { "ray-x/aurora", priority = 1000 },
  { "yashguptaz/calvera-dark.nvim", priority = 1000 },
  { "mhartington/oceanic-next", priority = 1000 }, -- :colorscheme OceanicNext
  { "Yagua/nebulous.nvim", priority = 1000 },

  -- Warm / earthy
  { "savq/melange-nvim", priority = 1000 },
  { "ribru17/bamboo.nvim", priority = 1000 },
  { "xero/miasma.nvim", priority = 1000 },
  { "dgox16/oldworld.nvim", priority = 1000 },
  { "neanias/everforest-nvim", priority = 1000 },
  { "comfysage/evergarden", priority = 1000 },
  { "sho-87/kanagawa-paper.nvim", priority = 1000 },
  { "kvrohit/rasmus.nvim", priority = 1000 },

  -- Minimal / low-contrast
  { "datsfilipe/vesper.nvim", priority = 1000 },
  { "vague2k/vague.nvim", priority = 1000 },
  { "slugbyte/lackluster.nvim", priority = 1000 },
  { "wtfox/jellybeans.nvim", priority = 1000 },
  { "HoNamDuong/hybrid.nvim", priority = 1000 },
  { "ficcdaf/ashen.nvim", priority = 1000 },

  -- Vibrant / synthwave
  { "diegoulloao/neofusion.nvim", priority = 1000 },
  { "0xstepit/flow.nvim", priority = 1000 },
  { "zootedb0t/citruszest.nvim", priority = 1000 },
  { "polirritmico/monokai-nightasty.nvim", priority = 1000 },
  { "tanvirtin/monokai.nvim", priority = 1000 },

  -- Solarized / GNOME
  { "maxmx03/solarized.nvim", priority = 1000 },
  { "Mofiqul/adwaita.nvim", priority = 1000 },
}
