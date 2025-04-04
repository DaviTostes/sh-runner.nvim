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
    vim.cmd(size .. "split")
    vim.cmd("wincmd J") -- move to bottom
  elseif position == "top" then
    vim.cmd(size .. "topleft split")
    vim.cmd("wincmd K") -- move to top
  elseif position == "left" then
    vim.cmd(size .. "topleft vsplit")
    vim.cmd("wincmd H") -- move to left
  elseif position == "right" then
    vim.cmd(size .. "botright vsplit")
    vim.cmd("wincmd L") -- move to right
  else
    print("Invalid position: " .. position)
    return
  end
end

function M.run_shell_script(file_path, opts, ...)
  if not check_file(file_path) then
    return
  end

  local cmd = file_path .. " " .. ...

  local win_count = #vim.api.nvim_tabpage_list_wins(0)
  if win_count <= 1 then
    split_window(opts.position, opts.height)
  end

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

