local ok, render_markdown = pcall(require, "render-markdown")
if not ok then
	return
end

render_markdown.setup({
	file_types = { "markdown" },
})

vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown toggle<CR>", {
	desc = "Toggle markdown rendering",
	silent = true,
})

vim.api.nvim_create_user_command("MarkdownView", function()
	vim.cmd("RenderMarkdown toggle")
end, {
	desc = "Toggle rendered markdown view",
})
