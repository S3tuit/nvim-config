--[[
This is a helper function that, given two arguments, performs a conditional
replace for the whole project of the old pattern (first argument) with
the new pattern (last argument). The function does not perform auto
escaping. The delimiter used depends on the input, if '/' is not present
in the inputs, it gets used, else '#'.

Example:

:Replall \(vim\|vi\) miv

expands to:

:silent vimgrep /\(vim\|vi\)/ **/*
:cfdo %s/\(vim\|vi\)/miv/sgc | update
--]]

vim.api.nvim_create_user_command("Replall", function(opts)
  if #opts.fargs ~= 2 then
    vim.notify("Usage: :Replall {old_pattern} {new_pattern}", vim.log.levels.ERROR)
    return
  end

  local old = opts.fargs[1]
  local new = opts.fargs[2]

  -- Choose a delimiter that’s not in the patterns (no automatic escaping)
  local delim = (old:find("/", 1, true) or new:find("/", 1, true)) and "#" or "/"

  -- 1) Fill quickfix with all matches in project using vimgrep
  -- You are responsible for escaping {old} as a Vim regex.
  local vimgrep_cmd = string.format("silent vimgrep %s%s%s **/*", delim, old, delim)
  vim.cmd(vimgrep_cmd)

  if vim.tbl_isempty(vim.fn.getqflist()) then
    vim.notify("No matches for pattern: " .. old, vim.log.levels.INFO)
    return
  end

  -- 2) Apply substitution in all files from quickfix
  -- Again: {old} and {new} are used as-is, no \V, no extra escaping.
  local sub_cmd = string.format("cfdo %%s%s%s%s%s%sgc | update", delim, old, delim, new, delim)
  vim.cmd(sub_cmd)
end, {
  nargs = "+",           -- allow one or more; enforced exactly 2 above
  complete = nil,
  })
