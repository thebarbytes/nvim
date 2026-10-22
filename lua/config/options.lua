-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.guicursor = "i:blinkwait700-blinkon400-blinkoff250-hor20"
vim.opt.list = false
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus"
vim.opt.spell = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

if vim.g.neovide then
  -- THE BEST CHOICED FONTS
  -- vim.o.guifont = "GeistMono NF SemiBold:h6"
  -- vim.o.guifont = "GeistMono NF SemiBold:h7"
  vim.o.guifont = "Maple Mono NF SemiBold:h6"
  -- vim.o.guifont = "JetBrainsMono NF Semibold:h6"

  -- Font / text size
  -- vim.o.guifont = "Cascadia Mono:h8" -- adjust size after :h — Ctrl+Scroll zooms live too
  -- vim.o.guifont = "JetBrainsMono Nerd Font:h8"
  -- vim.o.guifont = "InputMono Nerd Font:h7"
  -- vim.o.guifont = "GoogleSansCode NF Medium:h7"
  -- vim.o.guifont = "MartianMono Nerd Font:h7"
  -- vim.o.guifont = "Iosevka NF Semibold:h8"
  -- vim.o.guifont = "Cascadia Code NF:h8"
  -- vim.o.guifont = "Hack Nerd Font Mono:h8"
  -- vim.o.guifont = "Hack Nerd Font:h7" -- good
  -- vim.o.guifont = "BlexMono Nerd Font:h8"
  -- vim.o.guifont = "0xProto Nerd Font:h7"
  -- vim.o.guifont = "GoogleSansCode Nerd Font:h8"

  vim.opt.linespace = 2

  -- Cursor animation & particle trail
  vim.g.neovide_cursor_vfx_mode = "" -- "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe"
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0

  -- Movement / scroll animation
  vim.g.neovide_position_animation_length = 0.15
  vim.g.neovide_scroll_animation_length = 0.3

  -- Transparency + blur (pairs with Hyprland blur)
  vim.g.neovide_opacity = 0.95
  vim.g.neovide_normal_opacity = 0.95
  vim.g.neovide_window_blurred = true

  -- Floating window blur (hover docs, completion menu, telescope)
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  -- Padding
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_padding_right = 0

  -- Text rendering
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_underline_stroke_scale = 1.5

  -- Window / session behavior
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_ime = true

  -- Performance (Ryzen 3 7320U — don't burn cycles when idle/unfocused)
  vim.g.neovide_no_idle = true
  vim.g.neovide_refresh_rate = 144 -- match your monitor's Hz
  vim.g.neovide_refresh_rate_idle = 5

  -- Fullscreen toggle
  vim.keymap.set("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { desc = "Toggle fullscreen" })

  -- Font zoom in/out (keyboard alternative to Ctrl+Scroll)
  local function resize_font(delta)
    local guifont = vim.o.guifont
    local name, size = guifont:match("^(.-):h(%d+)$")
    if name and size then
      size = tonumber(size) + delta
      if size < 4 then
        size = 4 -- floor so it doesn't vanish
      end
      vim.o.guifont = string.format("%s:h%d", name, size)
    end
  end

  vim.keymap.set({ "n", "i" }, "<C-=>", function()
    resize_font(1)
  end, { desc = "Zoom in" })
  vim.keymap.set({ "n", "i" }, "<C-->", function()
    resize_font(-1)
  end, { desc = "Zoom out" })
  vim.keymap.set({ "n", "i" }, "<C-0>", function()
    vim.o.guifont = "Iosevka NF Semibold:h8" -- reset to your default
  end, { desc = "Reset zoom" })
end

-- ============================================================================
-- Transparency: registered early so the very first frame is already clear
-- ============================================================================
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- cursor: invert the theme's bg/fg
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
      "CursorLine", -- removes the full-width line highlight
      "CursorLineNr",
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
      -- mini.statusline strips (mode blocks keep their color)
      "MiniStatuslineDevinfo",
      "MiniStatuslineFilename",
      "MiniStatuslineFileinfo",
      "MiniStatuslineInactive",
    }

    -- lualine section/mode groups (harmless if lualine is disabled)
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

-- mini.statusline defines its groups on VeryLazy, so clear them once more after that
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.defer_fn(function()
      vim.cmd("doautocmd ColorScheme")
    end, 50)
  end,
})

local indent = require("config.indent")

vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    local c = vim.tbl_extend("force", indent.default, indent[ev.match] or {})
    vim.bo[ev.buf].shiftwidth = c.width
    vim.bo[ev.buf].tabstop = c.width
    vim.bo[ev.buf].softtabstop = c.width
    vim.bo[ev.buf].expandtab = not c.tabs
  end,
})
