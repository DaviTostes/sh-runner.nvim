local M = {}

local function check_file(file_path)
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.run_shell_script(file_path, ...)
  if not check_file(file_path) then
    return
  end

  local args = { ... }
  local cmd = file_path
  for _, arg in ipairs(args) do
    cmd = cmd .. " " .. arg
  end

  vim.cmd("vsplit")
  vim.cmd("wincmd L")

  vim.cmd("terminal bash " .. cmd)

  vim.cmd("stopinsert")
end

function M.setup(opts)
  opts = opts or {}

  local default_opts = {
    command_name = 'RunShell',
    position = 'right', -- 'right', 'left', 'top', 'bottom'
    debug = false
  }

  for k, v in pairs(default_opts) do
    if opts[k] == nil then
      opts[k] = v
    end
  end

  M.options = opts

  vim.api.nvim_create_user_command(
    opts.command_name,
    function(cmd_opts)
      local args = {}
      for i = 2, #cmd_opts.fargs do
        table.insert(args, cmd_opts.fargs[i])
      end
      M.run_shell_script(cmd_opts.fargs[1], unpack(args))
    end,
    {
      nargs = '+',
      complete = 'file',
      desc = 'Executes a shell file in a terminal'
    }
  )
end

return M
