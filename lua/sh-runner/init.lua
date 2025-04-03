-- sh-runner.lua
-- Plugin para executar scripts shell em um terminal do Neovim

local M = {}

local terminal_bufnr = nil

local function buffer_exists(bufnr)
  if bufnr == nil then
    return false
  end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.fn.bufexists(bufnr) == 1
end

function M.run_shell_script(file_path, ...)
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("Arquivo não encontrado: " .. file_path, vim.log.levels.ERROR)
    return
  end

  local args = { ... }
  local cmd = file_path
  for _, arg in ipairs(args) do
    cmd = cmd .. " " .. arg
  end

  if buffer_exists(terminal_bufnr) then
    local chan_id = vim.api.nvim_buf_get_var(terminal_bufnr, "terminal_job_id")
    vim.api.nvim_chan_send(chan_id, "clear && " .. cmd .. "\n")

    for _, win in pairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  else
    vim.cmd("split")
    vim.cmd("resize 15")
    vim.cmd("terminal " .. cmd)

    terminal_bufnr = vim.api.nvim_get_current_buf()
  end

  vim.cmd("stopinsert")
end

function M.setup()
  vim.api.nvim_create_user_command(
    'RunShell',
    function(opts)
      local args = {}
      for i = 2, #opts.fargs do
        table.insert(args, opts.fargs[i])
      end
      M.run_shell_script(opts.fargs[1], unpack(args))
    end,
    {
      nargs = '+',
      complete = 'file',
      desc = 'Executa um arquivo shell com argumentos em um terminal'
    }
  )
end

return M
