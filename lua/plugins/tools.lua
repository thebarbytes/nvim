-- lua/plugins/tools.lua
-- Git, encryption, terminal, file bookmarks.
return {
  -- Git: :G (or :Git) opens the status window; inside it, `-` stages/unstages,
  -- `cc` commits, `dv` shows a diff. Also :Git blame, :Git log, :Gdiffsplit.
  { "tpope/vim-fugitive", cmd = { "G", "Git" } },

  -- GnuPG: transparent encrypt/decrypt of .gpg / .asc / .pgp files on open and save.
  -- OPTIONS (set as vim.g.* variables below):
  --   GPGPreferArmor = 1       write ASCII-armored (text) output instead of binary
  --   GPGPreferSign = 0        1 = also sign when saving
  --   GPGDefaultRecipients     key IDs or emails to encrypt to
  --   GPGUseAgent = 1          use gpg-agent for the passphrase
  --   GPGExecutable = "gpg"    path to the gpg binary
  {
    "jamessan/vim-gnupg",
    init = function()
      vim.g.GPGPreferArmor = 1
      vim.g.GPGPreferSign = 0
      vim.g.GPGDefaultRecipients = { "zyruuuusan@gmail.com" }
    end,
  },

  -- Terminal: floating, numbered instances.
  -- NOTE: <D-...> is the Cmd/Super key. It only works in a GUI Neovim (like neovide) or a
  -- terminal that sends Super. If it doesn't trigger, switch these to <A-...> or <C-\> keys.
  --   <D-i>            toggle the main floating terminal
  --   <D-1> ... <D-4>  toggle floating terminals 1-4
  --   <A-h> / <A-v>    horizontal / vertical split terminal
  --
  -- OPTIONS YOU CAN ADD to `opts`:
  --   size = 20                                   height/width of split terminals
  --   float_opts = { border = "curved", width = 120, height = 30 }   "single" | "double" | "curved" | "shadow"
  --   shade_terminals = false                     don't darken the terminal background
  --   start_in_insert = true
  --   close_on_exit = true
  --   shell = "fish"                              use a different shell than $SHELL
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = { [[<D-i>]], [[<D-1>]], [[<D-2>]], [[<D-3>]], [[<D-4>]], "<A-h>", "<A-v>" },
    opts = {
      direction = "float", -- "float" | "horizontal" | "vertical" | "tab"
      open_mapping = [[<D-i>]],
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local map = vim.keymap.set
      for i = 1, 4 do
        map(
          "n",
          "<D-" .. i .. ">",
          "<cmd>" .. i .. "ToggleTerm direction=float<cr>",
          { desc = "Toggle float terminal " .. i }
        )
      end
      map("n", "<A-h>", "<cmd>ToggleTerm direction=horizontal<cr>")
      map("n", "<A-v>", "<cmd>ToggleTerm direction=vertical<cr>")
    end,
  },

  -- Harpoon: pin your most-used files and jump between them instantly.
  --   <leader>ha   add the current file        <leader>hh   open the harpoon menu
  --   <leader>1-4  jump to pinned file 1-4
  -- To pin more slots, add more <leader>5.. entries to `keys` and the map() list below.
  --
  -- OPTIONS: pass them to harpoon:setup({ settings = { ... } }):
  --   save_on_toggle = true       save the list whenever the menu closes
  --   sync_on_ui_close = true     sync the list to disk on menu close
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>ha", "<leader>hh", "<leader>1", "<leader>2", "<leader>3", "<leader>4" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      local map = vim.keymap.set
      map("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })
      map("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })
      map("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon file 1" })
      map("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon file 2" })
      map("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon file 3" })
      map("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file 4" })
    end,
  },
}
