-- lua/plugins/formatting.lua
-- Formatting with conform.nvim; merges on top of LazyVim's defaults.
--
-- USING IT
--   <leader>cf        format the current file / selection
--   <leader>uf        toggle format-on-save (all files)
--   <leader>uF        toggle format-on-save (this buffer only)
--   :ConformInfo      shows which formatters apply to the current file and whether they're installed
--
-- OPTIONS YOU CAN CHANGE
--   formatters_by_ft   filetype -> list of formatters, run in order
--                      { "prettierd", "prettier", stop_after_first = true } = use the first one that exists
--   formatters.<name>  per-formatter overrides:
--                        command       path to the executable
--                        args          replace the arguments entirely
--                        prepend_args  add arguments before the defaults (string list or function)
--                        append_args   add arguments after the defaults
--                        condition     function returning false to skip it for a file
local home = vim.env.HOME

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        -- Follows the buffer's own shiftwidth / expandtab, so indent settings
        -- from options.lua / indent.lua apply here too
        clang_format = {
          prepend_args = function(_, ctx)
            local w = vim.bo[ctx.buf].shiftwidth
            local use_tabs = vim.bo[ctx.buf].expandtab and "Never" or "ForIndentation"
            -- Change BasedOnStyle to Google, Mozilla, WebKit, etc. for a different base style
            return {
              ("--style={BasedOnStyle: LLVM, IndentWidth: %d, TabWidth: %d, UseTab: %s}"):format(w, w, use_tabs),
            }
          end,
        },
        -- Same idea for prettier. Extra flags you can add to the list:
        --   "--single-quote", "--no-semi", "--print-width", "100", "--trailing-comma", "all"
        prettier = {
          prepend_args = function(_, ctx)
            local w = tostring(vim.bo[ctx.buf].shiftwidth)
            local tabs = not vim.bo[ctx.buf].expandtab
            return { "--tab-width", w, "--use-tabs", tostring(tabs) }
          end,
        },
        asmfmt = {
          command = home .. "/go/bin/asmfmt",
        },
        php_cs_fixer = {
          command = home .. "/.config/composer/vendor/bin/php-cs-fixer",
          args = { "fix", "$FILENAME" },
        },
      },

      -- Add a language by adding a line here. Install the formatter first
      -- (pacman, npm, cargo...), then confirm with :ConformInfo.
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        rust = { "rustfmt" },
        asm = { "asmfmt" },
        nasm = { "asmfmt" },
        masm = { "asmfmt" },
        lua = { "stylua" },
        python = { "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        php = { "php_cs_fixer" },
        -- cmake removed: prettier can't format CMake (neocmakelsp formats it instead)
      },
    },
  },
}
