vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- basic autoclose
map('i', '"', '""<Left>', opts)
map('i', "'", "''<Left>", opts)
map('i', '(', '()<Left>', opts)
map('i', '[', '[]<Left>', opts)
map('i', '{', '{}<Left>', opts)

-- block on Enter
map('i', '{<CR>', '{<CR>}<Esc>O', opts)
map('i', '{;<CR>', '{<CR>};<Esc>O', opts)  
