return {
  -- Turn off LazyVim's default statusline so mini.statusline is the only one
  { "nvim-lualine/lualine.nvim", enabled = false },

  {
    "nvim-mini/mini.statusline",
    event = "VeryLazy",
    opts = {
      use_icons = true,
      content = {
        active = function()
          local sl = require("mini.statusline")

          -- Each section: bigger trunc_width = hides sooner on narrow windows
          local mode, mode_hl = sl.section_mode({ trunc_width = 120 })
          local git = sl.section_git({ trunc_width = 40 })
          local diff = sl.section_diff({ trunc_width = 75 })
          local diagnostics = sl.section_diagnostics({ trunc_width = 75 })
          local lsp = sl.section_lsp({ trunc_width = 75 }) -- optional: shows attached LSP
          local filename = sl.section_filename({ trunc_width = 140 })
          local fileinfo = sl.section_fileinfo({ trunc_width = 120 })
          local search = sl.section_searchcount({ trunc_width = 75 }) -- optional: 3/12 while searching
          local location = sl.section_location({ trunc_width = 75 })

          -- Custom section example: current folder name
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

          return sl.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
            "%<", -- truncation point when the window is narrow
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- everything below goes on the right side
            { hl = "MiniStatuslineFileinfo", strings = { search, cwd, fileinfo } },
            { hl = mode_hl, strings = { location } },
          })
        end,
      },
    },
  },
}
