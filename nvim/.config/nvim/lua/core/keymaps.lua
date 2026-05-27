-- Variables.
local km = vim.keymap
local op = { noremap = true, silent = true }
-- Leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = ";"
-- No leader.
km.set("i", "kj", "<Esc>", op) -- Exit insert mode.
km.set("n", "x", '"_x', op) -- Delete character without affecting registers.
km.set("n", "+", "<C-a>", op) -- Increment number.
km.set("n", "-", "<C-x>", op) -- Decrement number.
km.set("n", "dq", 'vb"_d', op) -- Delete backwards without affecting registers.
km.set("n", "dw", '"_daw', op) -- Delete word without affecting registers.
km.set("n", "te", "<cmd>tabedit<CR>", op) -- Open new tab.
km.set("n", "H", "<cmd>tabprev<CR>", op) -- Previous tab.
km.set("n", "L", "<cmd>tabnext<CR>", op) -- Next tab.
km.set("n", "n", "nzzzv", op) -- Next search result and center.
km.set("n", "N", "Nzzzv", op) -- Previous search result and center.
km.set("n", "sp", "<cmd>split<CR>", op) -- Horizontal split.
km.set("n", "vsp", "<cmd>vsplit<CR>", op) -- Vertical split.
km.set("n", "<Up>", "<cmd>resize -2<CR>", op) -- Resize window up.
km.set("n", "<Down>", "<cmd>resize +2<CR>", op) -- Resize window down.
km.set("n", "<Left>", "<cmd>vertical resize -2<CR>", op) -- Resize window left.
km.set("n", "<Right>", "<cmd>vertical resize +2<CR>", op) -- Resize window right.
km.set("n", "<C-k>", "<cmd>wincmd k<CR>", op) -- Move to upper split.
km.set("n", "<C-j>", "<cmd>wincmd j<CR>", op) -- Move to lower split.
km.set("n", "<C-h>", "<cmd>wincmd h<CR>", op) -- Move to left split.
km.set("n", "<C-l>", "<cmd>wincmd l<CR>", op) -- Move to right split.
-- Main leader.
km.set("n", "<leader>p", '"0p', op) -- Paste after cursor from yank register.
km.set("n", "<leader>P", '"0P', op) -- Paste before cursor from yank register.
km.set("v", "<leader>p", '"0p', op) -- Paste selection from yank register.
km.set("n", "<leader>c", '"_c', op) -- Change without affecting registers.
km.set("n", "<leader>C", '"_C', op) -- Change to end of line without affecting registers.
km.set("v", "<leader>c", '"_c', op) -- Change selection without affecting registers.
km.set("v", "<leader>C", '"_C', op) -- Change selection without affecting registers.
km.set("n", "<leader>d", '"_d', op) -- Delete without affecting registers.
km.set("n", "<leader>D", '"_D', op) -- Delete to end of line without affecting registers.
km.set("v", "<leader>d", '"_d', op) -- Delete selection without affecting registers.
km.set("v", "<leader>D", '"_D', op) -- Delete selection without affecting registers.
km.set("n", "<leader>a", "ggVG", op) -- Select all.
km.set("n", "<leader>o", "o<Esc>^Da", op) -- Open line without continuation.
km.set("n", "<leader>O", "O<Esc>^Da", op) -- Open line above without continuation.
km.set("n", "<leader>rn", "<cmd>IncRename ", op) -- Incremental rename.
-- Local leader.
km.set("n", "<localleader>.", vim.diagnostic.open_float, op) -- Open diagnostics.
km.set("n", "<localleader>n", "<cmd>Noice<CR>", op) -- Open Noice.
km.set("n", "<localleader>m", "<cmd>Telescope<CR>", op) -- Open Telescope.
km.set("n", "<localleader>q", "<cmd>q<CR>", op) -- Quit.
km.set("n", "<localleader>w", "<cmd>w<CR>", op) -- Save.
km.set("n", "<localleader>l", "<cmd>wq<CR>", op) -- Save and quit.
km.set("n", "<localleader>[", "<cmd>Neotree toggle position=left<CR>", op) -- Toggle Neotree.
km.set("i", "<localleader>,", function()
	require("cmp").complete()
end, op) -- Trigger completion.
-- Spectre.
km.set("n", "<leader>ss", function()
	require("spectre").toggle()
end, { desc = "Toggle Spectre" })
km.set("n", "<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search word" })
km.set("v", "<leader>sv", function()
	require("spectre").open_visual()
end, { desc = "Search visual" })
km.set("n", "<leader>sf", function()
	require("spectre").open_file_search({ select_word = true })
end, { desc = "Search file" })
-- Telescope.
km.set("n", "<localleader>f", function()
	require("telescope.builtin").find_files({ hidden = true })
end, op) -- Find files.
km.set("n", "<localleader>r", function()
	require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
end, op) -- Ripgrep project.
km.set("n", "<localleader>b", function()
	require("telescope.builtin").buffers()
end, op) -- Find buffers.
