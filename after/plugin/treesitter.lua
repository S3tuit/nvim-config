local parsers = { "c", "html", "lua", "vim", "vimdoc", "query", "markdown", "sql", "markdown_inline", "yaml" }
local filetypes = { "c", "html", "lua", "vim", "vimdoc", "query", "markdown", "sql", "yaml" }

local ok, treesitter = pcall(require, "nvim-treesitter")
if ok and type(treesitter.install) == "function" then
	treesitter.setup({
		install_dir = vim.fn.stdpath("data") .. "/site",
	})

	local installed = treesitter.get_installed()
	local missing = vim.tbl_filter(function(parser)
		return not vim.tbl_contains(installed, parser)
	end, parsers)
	if #missing > 0 then
		treesitter.install(missing)
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})

	return
end

local ok_configs, configs = pcall(require, "nvim-treesitter.configs")
if not ok_configs then
	return
end

configs.setup({
	ensure_installed = parsers,
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})
