vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- in visual mode, 'x' will delete the text and send it into black hole
-- register, i.e. don't yank it
vim.keymap.set("x", "x", '"_d', { noremap = true, silent = true })

-- insert breakpoint for debugging
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end)

-- start debug
vim.keymap.set("n", "<F5>", function() require("dap").continue() end)

-- debug shortcuts
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)
vim.keymap.set("n", "<F6>",  function() require("dap").terminate() end)

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
