-- one place to decide indentation per filetype
-- width = spaces per level, tabs = true to indent with real tab characters
return {
  default = { width = 4, tabs = false },

  -- compact web stuff
  typescriptreact = { width = 2 }, -- .tsx
  javascriptreact = { width = 2 }, -- .jsx
  html = { width = 2 },
  css = { width = 2 },
  json = { width = 2 },
  yaml = { width = 2 },
  astro = { width = 2 },
  lua = { width = 2 },
  sh = { width = 2 },

  -- wider languages
  typescript = { width = 4 }, -- .ts only (not .tsx)
  javascript = { width = 4 }, -- .js only (not .jsx)
  c = { width = 4, tabs = true },
  cpp = { width = 4, tabs = true },
  python = { width = 4 },
  php = { width = 4 },
  rust = { width = 4 },
  java = { width = 4 },
  cs = { width = 4 },
}
