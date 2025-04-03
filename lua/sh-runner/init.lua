-- nvim-sh-runner.lua
-- Plugin para executar scripts shell em um terminal do Neovim

local M = {}

-- Terminal buffer ID global para rastrear se já existe um terminal
local terminal_bufnr = nil

-- Função para verificar se um buffer existe
local function buffer_exists(bufnr)
  if bufnr == nil then
    return false
  end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.fn.bufexists(bufnr) == 1
end

-- Função para verificar se o arquivo existe e é executável
local function check_file(file_path)
  -- Verificar existência
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("Arquivo não encontrado: " .. file_path, vim.log.levels.ERROR)
    return false
  end
  
  -- Em sistemas Unix, verificar se é executável
  if vim.fn.has("unix") == 1 then
    local permissions = vim.fn.getfperm(file_path)
    if not permissions:match("x") then
      vim.notify("Aviso: O arquivo não tem permissão de execução. Adicionando permissão...", vim.log.levels.WARN)
      vim.fn.system("chmod +x " .. vim.fn.shellescape(file_path))
    end
  end
  
  return true
end

-- Função principal para executar o arquivo shell
function M.run_shell_script(file_path, ...)
  if not check_file(file_path) then
    return
  end
  
  -- Construir o comando com argumentos
  local args = {...}
  local cmd = vim.fn.shellescape(file_path)
  for _, arg in ipairs(args) do
    cmd = cmd .. " " .. vim.fn.shellescape(arg)
  end
  
  -- Verificar se o terminal já existe
  if buffer_exists(terminal_bufnr) then
    -- Terminal existe, enviar comando para o terminal existente
    local chan_id = vim.api.nvim_buf_get_var(terminal_bufnr, "terminal_job_id")
    vim.api.nvim_chan_send(chan_id, "clear && " .. cmd .. "\n")
    
    -- Focar na janela que contém o terminal
    for _, win in pairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  else
    -- Criar novo terminal em um split vertical à direita
    vim.cmd("vsplit")
    vim.cmd("wincmd L") -- Move para o extremo direito
    
    -- Abrir terminal e executar o comando
    vim.cmd("terminal bash" .. cmd)
    
    -- Obter o buffer do terminal recém-criado
    terminal_bufnr = vim.api.nvim_get_current_buf()
  end
  
  -- Entrar no modo normal para permitir rolagem e navegação
  vim.cmd("stopinsert")
end

-- Configuração do plugin com opções
function M.setup(opts)
  opts = opts or {}
  
  -- Definir valores padrão para opções
  local default_opts = {
    command_name = 'RunShell',
    position = 'right', -- 'right', 'left', 'top', 'bottom'
    debug = false       -- Mostrar mensagens de debug
  }
  
  -- Mesclar opções fornecidas com valores padrão
  for k, v in pairs(default_opts) do
    if opts[k] == nil then
      opts[k] = v
    end
  end
  
  -- Salvar opções globalmente
  M.options = opts
  
  -- Registrar comando no Neovim
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
      desc = 'Executa um arquivo shell com argumentos em um terminal'
    }
  )
end

return M
