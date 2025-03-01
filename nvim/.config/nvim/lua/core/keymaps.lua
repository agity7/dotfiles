-- Variables.
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Set leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General Keymaps (not using any leader).
keymap.set("i", "kj", "<Esc>", opts)                        -- Exit insert mode with successive press of k,j.
keymap.set("n", "x", '"_x', opts)                           -- Do things without affecting the registers.
keymap.set("n", "+", "<C-a>", opts)                         -- Increment.
keymap.set("n", "-", "<C-x>", opts)                         -- Decrement.
keymap.set("n", "dq", 'vb"_d', opts)                        -- Delete a word backwards without affecting the default register.
keymap.set("n", "dw", '"_daw', opts)                        -- Delete a word without affecting the default register.
keymap.set("n", "te", ":tabedit<Return>")                   -- New tab.
keymap.set("n", "H", ":tabprev<CR>", opts)                  -- Go to the previous tab
keymap.set("n", "L", ":tabnext<CR>", opts)                  -- Go to the next tab
keymap.set("n", "n", "nzzzv", opts)                         -- Find next and center.
keymap.set("n", "N", "Nzzzv", opts)                         -- Find previous and center.
keymap.set("n", "sp", ":split<Return>", opts)               -- Horizontal split.
keymap.set("n", "vsp", ":vsplit<Return>", opts)             -- Vertical split.
keymap.set("n", "<Up>", ":resize -2<CR>", opts)             -- Resize window (up).
keymap.set("n", "<Down>", ":resize +2<CR>", opts)           -- Resize window (down).
keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)  -- Resize window (left).
keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts) -- Resize window (right).
keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)             -- Navigate to split (up).
keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)             -- Navigate to split (down).
keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)             -- Navigate to split (left).
keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)             -- Navigate to split (right).
keymap.set("n", "<C-m>", "<C-i>", opts)                     -- Jumplist (forward).

-- Keymaps using the main Leader.
keymap.set("n", "<Leader>p", '"0p', opts) -- Paste from yank register.
keymap.set("n", "<Leader>P", '"0P', opts)
keymap.set("v", "<Leader>p", '"0p', opts)
keymap.set("n", "<Leader>c", '"_c', opts) -- Change without affecting register.
keymap.set("n", "<Leader>C", '"_C', opts)
keymap.set("v", "<Leader>c", '"_c', opts)
keymap.set("v", "<Leader>C", '"_C', opts)
keymap.set("n", "<Leader>d", '"_d', opts) -- Delete without affecting register.
keymap.set("n", "<Leader>D", '"_D', opts)
keymap.set("v", "<Leader>d", '"_d', opts)
keymap.set("v", "<Leader>D", '"_D', opts)
keymap.set("n", "<Leader>a", "gg<S-v>G", opts)     -- Select all.
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)    -- Disable continuations.
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)
keymap.set("n", "<Leader>rn", ":IncRename ", opts) -- Incremental rename.

-- Keymaps using the secondary Leader (;).
keymap.set("n", ";.", vim.diagnostic.open_float, opts)           -- Open diagnostics.
keymap.set("n", ";n", ":Noice<Enter>", opts)                     -- Noice command.
keymap.set("n", ";m", ":Telescope<Enter>", opts)                 -- Open Telescope.
keymap.set("n", ";q", ":q<Enter>", opts)                         -- Quit.
keymap.set("n", ";w", ":w<Enter>", opts)                         -- Save.
keymap.set("n", ";l", ":wq<Enter>", opts)                        -- Save and quit.
keymap.set("n", ";[", ":Neotree toggle position=left<CR>", opts) -- Toggle Neotree.
keymap.set("n", ";c", ":Codeium Chat<Enter>", opts)              --Open Codeium Chat.
keymap.set("i", ";,", function()
	require("cmp").complete()
end, opts) -- Trigger completion explicitly in insert mode.
keymap.set("n", ";,", function()
	require("cmp").complete()
end, opts) -- Trigger completion explicitly in normal mode.

-- Spectre Keymaps.
keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search selected text",
})
keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search in current file",
})
