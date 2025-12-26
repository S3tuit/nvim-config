require("s3tuit.remap")
require("s3tuit.set")
require("s3tuit.replall")

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- fuzzy finder
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', {
	['tag'] =
	'0.1.8'
})

-- color schema
Plug("rose-pine/neovim", { ['as'] = 'rose-pine' })

--
Plug('nvim-treesitter/nvim-treesitter', {
	['branch'] = 'master',
	['do'] =
	':TSUpdate'
})

-- nav between open files
Plug('nvim-lua/plenary.nvim')
Plug('ThePrimeagen/harpoon')

-- undo history
Plug('mbbill/undotree')

-- git integration
Plug('tpope/vim-fugitive')

-- LSP
vim.lsp.enable('luals')
vim.lsp.enable('cls')
vim.api.nvim_create_user_command('CclsRestart', function()
  vim.lsp.stop_client(vim.lsp.get_clients({ name = "ccls" }))
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return
  end
  vim.cmd('edit')
end, {})

-- for debugging
Plug('mfussenegger/nvim-dap')

vim.call('plug#end')

-- Color schemes should be loaded after plug#end().
vim.cmd('silent! colorscheme rose-pine')



-- Better popup behavior
vim.o.completeopt = "menu,menuone,noselect,preview,popup"
vim.o.shortmess = vim.o.shortmess .. "c" -- reduce "match x of y" noise
vim.opt.previewheight=12

-- AUTOCOMPLETE SETUP (START)
-- Helper: do we have a non-space char before the cursor?
local function has_words_before()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	if col == 0 then return false end
	local prev = vim.api.nvim_buf_get_text(0, line - 1, col - 1, line - 1, col, {})[1]
	return not prev:match("%s")
end

-- <Tab> behavior:
-- 1) if popup visible and an item is selected -> confirm it
-- 2) if popup visible and nothing selected yet -> move to next item
-- 3) if no popup and there is a word before cursor -> trigger LSP omni completion
-- 4) otherwise insert a literal tab
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		local selected = vim.fn.complete_info({ "selected" }).selected
		if selected ~= -1 then
			return vim.api.nvim_replace_termcodes("<C-y>", true, true, true) -- accept
		else
			return vim.api.nvim_replace_termcodes("<C-n>", true, true, true) -- select next
		end
	elseif has_words_before() then
		return vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true) -- trigger omni/LSP
	else
		return "\t"                                               -- literal Tab
	end
end, { expr = true, noremap = true, silent = true })
-- AUTOCOMPLETE SETUP (END)

-- SETUP DEBUGGER FOR C/C++
local dap = require('dap')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.expand("~/.local/share/cpptools/extension/debugAdapters/bin/OpenDebugAD7"),
  options = {
    detached = false,
  },
}

dap.configurations.c = {
  {
    name = "Launch C",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty-printing for gdb',
        ignoreFailures = true,
      },
    },
  },
}

dap.configurations.cpp = dap.configurations.c
-- END SETUP C/C++
