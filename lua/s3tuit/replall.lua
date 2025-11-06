local function escape_pat(s, delim)
  s = s:gsub("\\", "\\\\")
  s = s:gsub(vim.pesc(delim), "\\" .. delim)
  return s
end

local function escape_repl(s, delim)
  s = s:gsub("\\", "\\\\")
  s = s:gsub("&", "\\&")
  s = s:gsub(vim.pesc(delim), "\\" .. delim)
  return s
end

vim.api.nvim_create_user_command("Replall", function(opts)
  if #opts.fargs ~= 2 then
    vim.notify("Usage: :GrepAll {old_text} {new_text}", vim.log.levels.ERROR)
    return
  end

  old = opts.fargs[1]
  local new = opts.fargs[2]

  local delim = (old:find("/", 1, true) or new:find("/", 1, true)) and "#" or "/"

  -- Fill quickfix using current :grepprg
  vim.cmd("silent grep " .. vim.fn.shellescape(old))

  if vim.tbl_isempty(vim.fn.getqflist()) then
    vim.notify("No matches for: " .. old, vim.log.levels.INFO)
    return
  end

  local pat  = escape_pat(old, delim)
  local repl = escape_repl(new, delim)
  local cmd = string.format("cfdo %%s%s\\V%s%s%s%sgc | update", delim, pat, delim, repl, delim)
  vim.cmd(cmd)
end, {
  nargs = "+",           -- allow one or more; enforced exactly 2 above
  complete = nil,       
})
