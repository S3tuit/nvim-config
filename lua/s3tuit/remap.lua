vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- in visual mode, 'x' will delete the text and send it into black hole
-- register, i.e. don't yank it
vim.keymap.set("x", "x", '"_d', { noremap = true, silent = true })

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
