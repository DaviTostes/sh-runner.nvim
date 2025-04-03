# 🚀 nvim-sh-runner

Um plugin minimalista para Neovim que executa scripts shell em um terminal integrado de forma inteligente.

## ✨ Funcionalidades

- 💻 Execute scripts shell diretamente do Neovim com suporte a argumentos
- 🔄 Reutilização inteligente de terminais (sem criar múltiplos buffers)
- 🪟 Split automático com tamanho personalizável
- 🛠️ API Lua moderna e eficiente
- 🔍 Auto-completação de caminhos de arquivos
- 🚫 Verificação de existência de arquivos

## 📦 Instalação

### Usando [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'username/nvim-sh-runner'
```

### Usando [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'username/nvim-sh-runner',
  config = function()
    require('nvim-sh-runner').setup()
  end
}
```

### Usando [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'username/nvim-sh-runner'
```

## ⚙️ Configuração

O plugin funciona imediatamente após a instalação, sem necessidade de configuração adicional. No entanto, você pode personalizá-lo se desejar:

```lua
require('nvim-sh-runner').setup({
  -- Valores padrão mostrados abaixo
  terminal_height = 15,     -- Altura do split em linhas
  command_name = 'RunShell' -- Nome do comando
})
```

## 🚦 Uso

Execute qualquer script shell com argumentos usando o comando:

```
:RunShell /caminho/para/script.sh arg1 arg2 arg3
```

Exemplos:

```
:RunShell ./build.sh --release
:RunShell ~/scripts/deploy.sh staging --force
```

## 💡 Dicas de uso

- Mapeie o comando para uma tecla para acesso rápido:
  ```lua
  vim.keymap.set('n', '<leader>r', ':RunShell %<CR>', { noremap = true, silent = true })
  ```

- Use com arquivos temporários para execução rápida de código:
  ```lua
  vim.keymap.set('n', '<leader>R', ':write !sh<CR>', { noremap = true, silent = false })
  ```

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

1. Fork este repositório
2. Crie sua branch de recurso (`git checkout -b feature/amazing-feature`)
3. Commit suas alterações (`git commit -m 'Add some amazing feature'`)
4. Push para a branch (`git push origin feature/amazing-feature`)
5. Abra um Pull Request

## 📝 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

## 🙏 Agradecimentos

- Inspirado pelos workflows de desenvolvimento em terminal integrado
- Construído com 💙 para a comunidade Neovim

---

⭐ Não se esqueça de deixar uma estrela se você achou este plugin útil!
