-- lua/plugins/lsp.lua
-- Language servers (what gives you autocomplete, go-to-definition, diagnostics).
--
-- HOW TO ADD A SERVER
--   Add `servername = {}` to `servers` below. LazyVim installs it through mason.
--   Server names are lspconfig names (:help lspconfig-all lists them).
--
-- PER-SERVER OPTIONS YOU CAN CHANGE
--   mason = false     don't let mason install it; it must already exist on your system
--   enabled = false   turn the server off completely
--   cmd = { ... }     the command that launches the server (use for custom paths)
--   filetypes = {..}  which file types attach this server
--   settings = {..}   config the server reads while running (see that server's docs)
--   init_options = {} config the server reads once at startup
--   root_dir = ...    how the project root is found (rarely needed)
--
-- CHECK WHAT'S ATTACHED:  open a file, then run :checkhealth vim.lsp
local home = vim.env.HOME

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript is handled by typescript-tools.nvim (see typescript.lua),
        -- so every built-in TS server stays off to avoid two servers per file.
        -- (tsserver is the old name of ts_ls.)
        ts_ls = { enabled = false },
        tsserver = { enabled = false },
        vtsls = { enabled = false },

        -- C / C++ (clangd comes with Arch's `clang` package)
        -- Other clangd flags you can add: "-j=4" (threads), "--pch-storage=memory",
        -- "--query-driver=/usr/bin/*" (for cross compilers)
        clangd = {
          mason = false,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never", -- "iwyu" to auto-insert includes
            "--completion-style=detailed", -- or "bundled"
            "--function-arg-placeholders=false", -- true = fill in (arg1, arg2) after completing
          },
        },

        -- Web
        astro = {
          mason = false,
          cmd = { home .. "/.npm-global/bin/astro-ls", "--stdio" },
          init_options = {
            typescript = {
              tsdk = home .. "/.npm-global/lib/node_modules/typescript/lib",
            },
          },
        },
        tailwindcss = {
          mason = false,
          cmd = { home .. "/.npm-global/bin/tailwindcss-language-server", "--stdio" },
        },
        intelephense = {
          mason = false,
          cmd = { home .. "/.npm-global/bin/intelephense", "--stdio" },
        },

        -- Python
        pyright = {
          mason = false,
          cmd = { home .. "/.npm-global/bin/pyright-langserver", "--stdio" },
          -- settings = { python = { analysis = { typeCheckingMode = "basic" } } }, -- "off" | "basic" | "strict"
        },

        -- C#
        csharp_ls = {
          mason = false,
          cmd = { home .. "/.dotnet/tools/csharp-ls" },
        },

        -- Lua (system package from pacman)
        lua_ls = {
          mason = false,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } }, -- add more known globals here
              telemetry = { enable = false },
            },
          },
        },

        -- Assembly
        asm_lsp = {
          mason = false,
          cmd = { home .. "/.cargo/bin/asm-lsp" },
          filetypes = { "asm", "nasm", "masm" },
          init_options = { dialect = "nasm" }, -- the assembler dialect the server assumes
        },

        -- CMake
        neocmakelsp = {
          mason = false,
          cmd = { "neocmakelsp", "--stdio" },
          init_options = {
            format = { enable = true },
            scan_cmake_in_package = true,
          },
        },

        -- Rust
        rust_analyzer = {
          mason = false,
          cmd = { home .. "/.cargo/bin/rust-analyzer" },
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check = { command = "clippy" }, -- "check" for faster, less strict output
              cargo = { allFeatures = true },
              procMacro = { enable = true },
            },
          },
        },

        -- Markdown (system package from pacman)
        marksman = { mason = false },

        -- Bash (installed through mason, the default)
        bashls = {},
      },
    },

    init = function()
      -- Disable diagnostics for asm files (asm-lsp is noisy).
      -- Add more filetypes to `pattern` to silence other languages the same way.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "asm", "nasm", "masm" },
        callback = function()
          vim.diagnostic.enable(false, { bufnr = 0 })
        end,
      })

      -- Java: start jdtls (system package from pacman), one workspace per project.
      -- Add more project markers to the list below if your projects use other build files.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          -- Project root = nearest folder with one of these markers,
          -- or the file's own folder if none is found
          local root_dir = vim.fs.root(args.buf, {
            ".git",
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            "settings.gradle",
          }) or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))

          local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. vim.fn.fnamemodify(root_dir, ":p:h:t")

          vim.lsp.start({
            name = "jdtls",
            cmd = { "jdtls", "-data", workspace_dir },
            root_dir = root_dir,
          })
        end,
      })
    end,
  },

  -- JSON/YAML schema validation + autocomplete (package.json, tsconfig.json, ...).
  -- This is a separate spec because `opts` is a function here: it defers
  -- require("schemastore") until the plugin is installed and loaded.
  -- To limit which schemas load: schemastore.json.schemas({ select = { "package.json" } })
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.jsonls = vim.tbl_deep_extend("force", opts.servers.jsonls or {}, {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" }, -- disabled: schemastore.nvim supplies these instead
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      return opts
    end,
  },
}
