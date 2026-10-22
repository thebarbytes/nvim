# Neovim Keybindings Reference

Leader key is `<Space>`. This covers everything set in `config/keymaps.lua`
and `plugins/dev.lua`. For the full LazyVim default set (not listed here in
full since there are hundreds), run `:Telescope keymaps` or
`Snacks.picker.keymaps()` inside Neovim — see the bottom of this file for
the binding that opens that searchable list.

---

## General (`config/keymaps.lua`)

| Key         | Mode   | Action                             |
| ----------- | ------ | ---------------------------------- |
| `;`         | Normal | Same as `:` (quicker command mode) |
| `jk`        | Insert | Exit insert mode (same as `<Esc>`) |
| `<leader>h` | Normal | Clear search highlight             |
| `<leader>x` | Normal | Close current buffer               |
| `<leader>?` | Normal | Search all keymaps (Snacks picker) |

## LSP Management (custom, no LazyVim equivalent)

| Key          | Mode   | Action                                                       |
| ------------ | ------ | ------------------------------------------------------------ |
| `<leader>lX` | Normal | Stop **all** active LSP clients                              |
| `<leader>le` | Normal | Re-enable all configured LSP servers (reopen file to attach) |

## Line Editing

| Key     | Mode   | Action                 |
| ------- | ------ | ---------------------- |
| `<A-j>` | Normal | Move current line down |
| `<A-k>` | Normal | Move current line up   |
| `<A-j>` | Visual | Move selection down    |
| `<A-k>` | Visual | Move selection up      |

## Buffers

| Key         | Mode   | Action          |
| ----------- | ------ | --------------- |
| `<C-j>`     | Normal | Next buffer     |
| `<C-k>`     | Normal | Previous buffer |
| `<leader>x` | Normal | Close buffer    |

## Formatting

| Key         | Mode   | Action                              |
| ----------- | ------ | ----------------------------------- |
| `<leader>f` | Normal | Format buffer (conform.nvim, async) |

## Colorscheme

| Key          | Mode   | Action                                    |
| ------------ | ------ | ----------------------------------------- |
| `<leader>th` | Normal | Open colorscheme picker with live preview |

## Terminal

| Key       | Mode     | Action                                      |
| --------- | -------- | ------------------------------------------- |
| `<C-S-v>` | Terminal | Paste system clipboard into terminal buffer |

## Toggles

| Key          | Mode   | Action                            |
| ------------ | ------ | --------------------------------- |
| `<leader>n`  | Normal | Toggle line numbers (all windows) |
| `<leader>i`  | Normal | Toggle indent guides (IBL)        |
| `<leader>tl` | Normal | Toggle statusline (lualine)       |

## File Explorer (neo-tree)

| Key         | Mode   | Action                                   |
| ----------- | ------ | ---------------------------------------- |
| `<leader>e` | Normal | Toggle neo-tree explorer                 |
| `<leader>E` | Normal | Toggle neo-tree explorer (same as above) |

**Inside the neo-tree window** (plugin defaults, not custom-bound):

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<CR>` / `o` | Open file / expand folder       |
| `<BS>`       | Go up a directory               |
| `a`          | Add new file/folder             |
| `d`          | Delete                          |
| `r`          | Rename                          |
| `c`          | Copy (mark then paste with `p`) |
| `x`          | Cut (mark then paste with `p`)  |
| `p`          | Paste                           |
| `m`          | Move                            |
| `y`          | Copy path to clipboard          |
| `R`          | Refresh tree                    |
| `H`          | Toggle hidden files             |
| `?`          | Show all neo-tree keybinds      |

## Oil (directory-as-buffer file manager)

| Key         | Mode   | Action                       |
| ----------- | ------ | ---------------------------- |
| `<leader>o` | Normal | Open parent directory in Oil |

**Inside an Oil buffer:**

| Key                                | Action                        |
| ---------------------------------- | ----------------------------- |
| `<CR>`                             | Open file/folder under cursor |
| `-`                                | Go to parent directory        |
| `g?`                               | Show Oil help                 |
| Edit the buffer as text            | Rename, then `:w` to apply    |
| Delete a line, then `:w`           | Deletes that file             |
| Yank a line, paste elsewhere, `:w` | Copies file to new location   |
| Cut a line, paste elsewhere, `:w`  | Moves file to new location    |

## Leap (fast motion)

| Key | Mode                   | Action                            |
| --- | ---------------------- | --------------------------------- |
| `s` | Normal/Visual/Operator | Leap forward to any 2-char match  |
| `S` | Normal/Visual/Operator | Leap backward to any 2-char match |

## Surround (nvim-surround)

| Key                | Mode   | Action                                           |
| ------------------ | ------ | ------------------------------------------------ |
| `ys{motion}{char}` | Normal | Add surround (e.g. `ysiw"` wraps word in quotes) |
| `cs{old}{new}`     | Normal | Change surround (e.g. `cs"'` changes `"` to `'`) |
| `ds{char}`         | Normal | Delete surround (e.g. `ds"` removes quotes)      |
| `S{char}`          | Visual | Surround selection                               |

## Comment (Comment.nvim, JSX-aware)

| Key          | Mode   | Action                         |
| ------------ | ------ | ------------------------------ |
| `gcc`        | Normal | Toggle line comment            |
| `gbc`        | Normal | Toggle block comment           |
| `gc{motion}` | Normal | Comment a motion (e.g. `gcap`) |
| `gc`         | Visual | Comment selection              |

## Treesitter Textobjects (custom-wired, `main` branch API)

Requires the parser for that language to be installed
(`:TSInstall <lang>` if missing — see note at the bottom).

**Select** (use with `v`, `d`, `y`, `c`, etc. — e.g. `vaf`, `daf`, `yaf`):

| Key  | Selects                            |
| ---- | ---------------------------------- |
| `af` | Around function (signature + body) |
| `if` | Inside function (body only)        |
| `ac` | Around class/component             |
| `ic` | Inside class/component             |
| `aa` | Around parameter/argument          |
| `ia` | Inside parameter/argument          |

**Move:**

| Key  | Action                          |
| ---- | ------------------------------- |
| `]f` | Jump to next function start     |
| `[f` | Jump to previous function start |
| `]a` | Jump to next parameter          |
| `[a` | Jump to previous parameter      |

## Harpoon (quick file bookmarks)

| Key          | Mode   | Action                           |
| ------------ | ------ | -------------------------------- |
| `<leader>ha` | Normal | Add current file to Harpoon list |
| `<leader>hh` | Normal | Toggle Harpoon quick menu        |
| `<leader>1`  | Normal | Jump to Harpoon file 1           |
| `<leader>2`  | Normal | Jump to Harpoon file 2           |
| `<leader>3`  | Normal | Jump to Harpoon file 3           |
| `<leader>4`  | Normal | Jump to Harpoon file 4           |

## Terminal (toggleterm)

| Key             | Mode   | Action                         |
| --------------- | ------ | ------------------------------ |
| `<D-i>` (Cmd+i) | Normal | Toggle floating terminal 1     |
| `<D-1>`         | Normal | Toggle floating terminal 1     |
| `<D-2>`         | Normal | Toggle floating terminal 2     |
| `<D-3>`         | Normal | Toggle floating terminal 3     |
| `<D-4>`         | Normal | Toggle floating terminal 4     |
| `<A-h>`         | Normal | Open horizontal terminal split |
| `<A-v>`         | Normal | Open vertical terminal split   |

## Git (vim-fugitive)

| Command       | Action                               |
| ------------- | ------------------------------------ |
| `:G`          | Open fugitive status/summary         |
| `:Git <args>` | Run any git command through fugitive |

## GnuPG (vim-gnupg)

Transparent — no keybinds. Opening a `.gpg`/`.asc`/`.pgp` file automatically
prompts to decrypt; saving automatically re-encrypts.

---

## Useful Commands (not bound to keys, type these directly)

| Command                        | Action                                                           |
| ------------------------------ | ---------------------------------------------------------------- |
| `:Neotree show`                | Force-open neo-tree regardless of keymap state                   |
| `:Oil`                         | Open Oil in current file's directory                             |
| `:ToggleTerm`                  | Open a toggleterm instance                                       |
| `:G` / `:Git`                  | Fugitive git commands                                            |
| `:Lazy`                        | Plugin manager UI (install/update/health)                        |
| `:Lazy sync`                   | Install/update/clean all plugins                                 |
| `:Lazy reload <plugin>`        | Reload a single plugin's spec                                    |
| `:Mason`                       | LSP/formatter/tool installer UI                                  |
| `:LspInfo`                     | Show attached LSP clients for current buffer                     |
| `:checkhealth nvim-treesitter` | Show installed Treesitter parsers                                |
| `:TSInstall <lang>`            | Install a Treesitter parser (e.g. `cpp`, `rust`, `php`)          |
| `:TSUpdate`                    | Update all installed Treesitter parsers                          |
| `:IBLToggle`                   | Toggle indent guides (also bound to `<leader>i`)                 |
| `:checkhealth neo-tree`        | neo-tree self-diagnostic                                         |
| `:WhichKey`                    | Show the full which-key binding tree (not just contextual popup) |
| `Snacks.picker.keymaps()`      | Searchable list of every active keymap (bound to `<leader>?`)    |

---

## Notes

- **Treesitter parsers are per-language and must be installed once.** LazyVim
  ships several by default (bash, c, html, javascript, json, lua, markdown,
  python, toml, tsx, typescript, vim, xml, yaml). Anything else — including
  **cpp**, rust, php, java, c_sharp — needs a manual
  `:TSInstall <lang>` the first time you open that filetype, or add it to
  `ensure_installed` in an `nvim-treesitter` opts block so it installs
  automatically on every machine.
- **`<leader>e` / `<leader>E`** are force-rebound in `config/keymaps.lua` to
  override LazyVim's default Snacks-explorer binding. This must stay as
  plain top-level code in that file (not wrapped in a `VeryLazy` autocmd),
  since `keymaps.lua` itself already loads on the `VeryLazy` event.
- **This file is not exhaustive of LazyVim's built-in defaults** (window
  navigation, `<leader>f` file-finding pickers, `<leader>g` git pickers,
  etc.). For the complete list including those, use `<leader>?` inside
  Neovim rather than relying on this document.
