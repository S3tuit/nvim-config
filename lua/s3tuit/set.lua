
--line num
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.textwidth = 0

local wrap_group = vim.api.nvim_create_augroup("WrapByFiletype", { clear = true })
local function set_wrap_for_filetype(args)
  local filetype = vim.bo[args.buf].filetype
  vim.wo.wrap = filetype ~= "python" and filetype ~= "c"
end

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  group = wrap_group,
  callback = set_wrap_for_filetype,
})

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

--Clipboard
--yank to system clipboard
vim.opt.clipboard = "unnamedplus"
