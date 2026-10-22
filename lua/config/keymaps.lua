-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "; as :" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>x", function()
  if vim.bo.filetype == "neo-tree" then
    return
  end
  local listed = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #listed <= 1 then
    local old = vim.api.nvim_get_current_buf()
    vim.cmd("enew")
    Snacks.bufdelete({ buf = old })
  else
    Snacks.bufdelete()
  end
end, { desc = "Close buffer (keep splits)" })

-- LSP client management (no LazyVim equivalent)
map("n", "<leader>lX", function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    vim.notify("No active LSP clients", vim.log.levels.WARN)
    return
  end
  for _, client in ipairs(clients) do
    vim.lsp.enable(client.name, false)
    vim.lsp.stop_client(client.id)
  end
  vim.notify("Disabled all LSP clients", vim.log.levels.INFO)
end, { desc = "Stop ALL LSP clients" })

map("n", "<leader>le", function()
  local servers = {
    "clangd",
    "pyright",
    "rust_analyzer",
    "tailwindcss",
    "lua_ls",
    "asm_lsp",
    "intelephense",
    "csharp_ls",
    "neocmakelsp",
  }
  for _, name in ipairs(servers) do
    vim.lsp.enable(name, true)
  end
  vim.notify("Re-enabled LSP servers, reopen file to attach", vim.log.levels.INFO)
end, { desc = "Re-enable all LSP servers" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Buffer navigation (overrides LazyVim's default window nav on these two keys)
map("n", "<C-j>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-k>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Format (global fallback via conform.nvim)
map("n", "<leader>f", function()
  require("conform").format({
    async = true,
    lsp_fallback = false,
    timeout_ms = 5000,
  })
end, { desc = "Format buffer" })

-- Colorscheme picker
map("n", "<leader>th", function()
  require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "Pick colorscheme" })

-- Paste clipboard content while inside :terminal (toggleterm etc.)
map("t", "<C-S-v>", function()
  local reg = vim.fn.getreg("+")
  vim.api.nvim_paste(reg, false, -1)
end, { desc = "Paste clipboard into terminal" })

-- Toggle line numbers across all windows
local numbers_enabled = true
local function set_all_windows_number(state)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_win_call(win, function()
      if vim.bo.filetype ~= "neo-tree" then
        vim.opt_local.number = state
      end
    end)
  end
end
map("n", "<leader>n", function()
  numbers_enabled = not numbers_enabled
  set_all_windows_number(numbers_enabled)
end, { desc = "Toggle line numbers (all windows)" })

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      vim.opt_local.number = numbers_enabled
    end
  end,
})

-- Toggle indent guides
map("n", "<leader>i", "<cmd>IBLToggle<cr>", { desc = "Toggle indent guides" })

-- Toggle statusline (lualine)
local statusline_hidden = false
map("n", "<leader>tl", function()
  statusline_hidden = not statusline_hidden
  require("lualine").hide({ place = { "statusline" }, unhide = not statusline_hidden })
  vim.o.laststatus = statusline_hidden and 0 or 3
end, { desc = "Toggle statusline" })
-- local statusline_hidden = false
-- map("n", "<leader>tl", function()
--   statusline_hidden = not statusline_hidden
--   require("lualine").hide({ place = { "statusline" }, unhide = not statusline_hidden })
-- end, { desc = "Toggle statusline" })

-- Force neo-tree to own both <leader>e and <leader>E, overriding LazyVim's
-- default Snacks-explorer binds. This file (config/keymaps.lua) is already
-- loaded BY LazyVim on the VeryLazy event, so LazyVim's own defaults are
-- guaranteed to exist by the time we get here — no extra autocmd needed
-- (wrapping this in another "VeryLazy" autocmd would wait for a second
-- event that never fires, since we're already inside the first one).
pcall(vim.keymap.del, "n", "<leader>e")
pcall(vim.keymap.del, "n", "<leader>E")
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer (neo-tree)" })
map("n", "<leader>E", "<cmd>Neotree toggle<cr>", { desc = "Explorer (neo-tree)" })

map("n", "<leader>?", function()
  Snacks.picker.keymaps()
end, { desc = "Search all keymaps" })
