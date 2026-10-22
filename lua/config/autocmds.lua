-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
--     vim.api.nvim_set_hl(0, "Cursor", { fg = normal.bg, bg = normal.fg })
--     vim.api.nvim_set_hl(0, "lCursor", { fg = normal.bg, bg = normal.fg })
--   end,
-- })

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
--     local cur_fg = normal.bg or 0x000000
--     local cur_bg = normal.fg or 0xffffff
--     vim.api.nvim_set_hl(0, "Cursor", { fg = cur_fg, bg = cur_bg })
--     vim.api.nvim_set_hl(0, "lCursor", { fg = cur_fg, bg = cur_bg })
--
--     -- transparent backgrounds (keeps fg, drops bg)
--     local groups = {
--       "Normal",
--       "NormalNC",
--       "SignColumn",
--       "EndOfBuffer",
--       "LineNr",
--       "CursorLineNr",
--       "FoldColumn",
--       "WinSeparator",
--       "VertSplit",
--       "StatusLine",
--       "StatusLineNC",
--       "NeoTreeNormal",
--       "NeoTreeNormalNC",
--       "NeoTreeEndOfBuffer",
--       "NeoTreeWinSeparator",
--       "BufferLineFill",
--       "BufferLineBackground",
--       "TabLineFill",
--     }
--     for _, g in ipairs(groups) do
--       local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
--       hl.bg, hl.ctermbg = nil, nil
--       vim.api.nvim_set_hl(0, g, hl)
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    local cur_fg = normal.bg or 0x000000
    local cur_bg = normal.fg or 0xffffff
    vim.api.nvim_set_hl(0, "Cursor", { fg = cur_fg, bg = cur_bg })
    vim.api.nvim_set_hl(0, "lCursor", { fg = cur_fg, bg = cur_bg })

    -- transparent backgrounds (keeps fg, drops bg)
    local groups = {
      "Normal",
      "NormalNC",
      "SignColumn",
      "EndOfBuffer",
      "LineNr",
      "FoldColumn",
      "WinSeparator",
      "VertSplit",
      "StatusLine",
      "StatusLineNC",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "NeoTreeEndOfBuffer",
      "NeoTreeWinSeparator",
      "BufferLineFill",
      "BufferLineBackground",
      "TabLineFill",
    }

    -- Automatically inject all Lualine section/mode groups into the transparency wipe
    local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
    local sections = { "a", "b", "c", "x", "y", "z" }
    for _, mode in ipairs(modes) do
      for _, sec in ipairs(sections) do
        table.insert(groups, "lualine_" .. sec .. "_" .. mode)
      end
    end

    for _, g in ipairs(groups) do
      local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
      if hl and not vim.tbl_isempty(hl) then
        hl.bg, hl.ctermbg = nil, nil
        vim.api.nvim_set_hl(0, g, hl)
      end
    end
  end,
})

-- local cursor_colors = nil
--
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
--
--     -- remember real colors from the theme (before we clear the bg)
--     if normal.bg and normal.fg then
--       cursor_colors = { fg = normal.bg, bg = normal.fg }
--     end
--     if cursor_colors then
--       vim.api.nvim_set_hl(0, "Cursor", cursor_colors)
--       vim.api.nvim_set_hl(0, "lCursor", cursor_colors)
--     end
--
--     -- transparent backgrounds
--     local groups = {
--       "Normal",
--       "NormalNC",
--       "SignColumn",
--       "EndOfBuffer",
--       "LineNr",
--       "CursorLineNr",
--       "FoldColumn",
--       "WinSeparator",
--       "VertSplit",
--       "StatusLine",
--       "StatusLineNC",
--       "NeoTreeNormal",
--       "NeoTreeNormalNC",
--       "NeoTreeEndOfBuffer",
--       "NeoTreeWinSeparator",
--       "BufferLineFill",
--       "BufferLineBackground",
--       "TabLineFill",
--     }
--     for _, g in ipairs(groups) do
--       local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
--       hl.bg, hl.ctermbg = nil, nil
--       vim.api.nvim_set_hl(0, g, hl)
--     end
--   end,
-- })

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.cmd("doautocmd ColorScheme")
