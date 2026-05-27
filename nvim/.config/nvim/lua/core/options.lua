local o = vim.opt
o.number = true
o.relativenumber = true
o.wrap = false
o.mouse = "a"
o.autoindent = true
o.ignorecase = true
o.smartcase = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.scrolloff = 4
o.sidescrolloff = 8
o.cursorline = false
o.splitbelow = true
o.splitright = true
o.hlsearch = true
o.showmode = false
o.termguicolors = true
o.whichwrap = "bs<>[]hl"
o.numberwidth = 4
o.swapfile = false
o.smartindent = true
o.showtabline = 2
o.backspace = "indent,eol,start"
o.pumheight = 10
o.conceallevel = 0
o.signcolumn = "yes"
o.fileencoding = "utf-8"
o.cmdheight = 1
o.updatetime = 250
o.timeoutlen = 300
o.backup = false
o.writebackup = false
o.undofile = true
o.completeopt = { "menu", "menuone", "noinsert" }
o.clipboard = "unnamedplus"
o.shortmess:append("c")
o.iskeyword:append("-")
o.formatoptions:remove({ "c", "r", "o" })
o.runtimepath:remove("/usr/share/vim/vimfiles")
