if vim.g.loaded_nvim_sh_runner == 1 then
  return
end
vim.g.loaded_nvim_sh_runner = 1

-- Inicializa o plugin
require('sh-runner').setup()
