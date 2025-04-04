local M = {}

local function check_file(file_path)
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    return false
  end

  return true
end

local function split_window(position, size)
  if position == "bottom" then
    vim.cmd("botright split")
  elseif position == "top" then
    vim.cmd("topleft split")
  elseif position == "left" then
    vim.cmd("topleft vsplit")
  elseif position == "right" then
    vim.cmd("botright vsplit")
  else
    print("Invalid position: " .. position)
    return
  end
  vim.api.nvim_win_set_height(0, size)
end

function M.run_shell_script(file_path, opts, ...)
  if not check_file(file_path) then
    return
  end

  local cmd = file_path .. " " .. ...

  local win_count = #vim.api.nvim_tabpage_list_wins(0)
  if win_count <= 1 then
    split_window(opts.position, opts.size)
  end

  vim.cmd("terminal bash " .. cmd)

  vim.cmd("stopinsert")
end

function M.setup(opts)
  opts = opts or {}

  local default_opts = {
    command_name = 'RunShell',
    position = 'right', -- 'right', 'left', 'top', 'bottom'
    size = 20,
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
      M.run_shell_script(cmd_opts.fargs[1], M.options, unpack(args))
    end,
    {
      nargs = '+',
      complete = 'file',
      desc = 'Executes a shell file in a terminal'
    }
  )
end

return M

