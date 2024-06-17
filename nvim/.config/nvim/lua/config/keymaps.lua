-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Registers are specified using a single double quote just before the value of the register, for example, "_ represents the black hole register.

-- Variables.
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Exit insert mode with successive press of k,j.
keymap.set("i", "kj", "<Esc>", opts)

-- Do things without affecting the registers.
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment, decrement.
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards without affecting the default register.
keymap.set("n", "dq", 'vb"_d', opts)

-- Delete a word without affecting the default register.
keymap.set("n", "dw", '"_daw', opts)

-- Select all.
keymap.set("n", "<Leader>a", "gg<S-v>G")

-- Disable continuations.
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist.
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab.
keymap.set("n", "te", ":tabedit<Return>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window.
keymap.set("n", "sp", ":split<Return>", opts)
keymap.set("n", "vsp", ":vsplit<Return>", opts)

-- Move window.
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window.
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics.
-- keymap.set("n", "<C-j>", function()
-- 	vim.diagnostic.goto_next()
-- end, opts)
-- keymap.set("n", "<leader>r", function()
-- 	require("craftzdog.hsl").replaceHexWithHSL()
-- end)
-- keymap.set("n", "<leader>i", function()
-- 	require("craftzdog.lsp").toggleInlayHints()
-- end)

-- Inc-Rename.
keymap.set("n", "<leader>rn", ":IncRename ")

-- Noice.
keymap.set("n", ";n", ":Noice<Enter>")

-- Telescope.
keymap.set("n", ";m", ":Telescope<Enter>")

-- Go back (Last, quit).
keymap.set("n", ";q", ":q<Enter>")

-- Save.
keymap.set("n", ";w", ":w<Enter>")

-- Quit and save.
keymap.set("n", ";l", ":wq<Enter>")
