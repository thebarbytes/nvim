-- lua/plugins/diagnostics.lua
-- Styled inline diagnostics. Currently OFF: set enabled = true to try it.
-- When on, it replaces LazyVim's default end-of-line virtual_text.
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    enabled = false,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern", -- try "classic", "minimal", "powerline", "ghost" too
        options = {
          show_source = false,
          throttle = 20,
          softwrap = 30, -- wraps long messages instead of letting them overflow
        },
      })

      -- Turn off the built-in end-of-line text so the two don't overlap
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
