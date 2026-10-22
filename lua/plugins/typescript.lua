-- lua/plugins/typescript.lua
-- TypeScript / JavaScript tooling.
return {
  -- typescript-tools.nvim: lightweight native tsserver client.
  -- The built-in TS servers (ts_ls, tsserver, vtsls) are disabled in lsp.lua.
  --
  -- SETTINGS YOU CAN CHANGE (inside `settings`):
  --   tsserver_max_memory = 2048        MB of RAM tsserver may use ("auto" lets it decide)
  --   separate_diagnostic_server = true run a second server just for diagnostics (smoother typing, more RAM)
  --   publish_diagnostic_on = "change"  "insert_leave" (default here) or "change" (while typing)
  --   code_lens = "all"                 "off" | "all" | "implementations_only" | "references_only"
  --   complete_function_calls = true    auto-insert (...) after completing a function
  --   jsx_close_tag = { enable = true } auto-close JSX tags
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {
      -- Let prettier (conform, see formatting.lua) do the formatting, not tsserver
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

  -- ts-error-translator: turns raw TypeScript compiler errors into plain English
  -- (big readability win for Next.js / React). Works with no options.
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
