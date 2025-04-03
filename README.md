# 🚀 sh-runner

A minimalist Neovim plugin that intelligently runs shell scripts in an integrated terminal.

## ✨ Features

- 💻 Run shell scripts directly from Neovim with argument support
- 🔄 Smart terminal reuse (no multiple buffer creation)
- 🪟 Automatic split with customizable size
- 🛠️ Modern and efficient Lua API
- 🔍 File path auto-completion
- 🚫 File existence verification

## 📦 Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'username/nvim-sh-runner'
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'username/nvim-sh-runner',
  config = function()
    require('nvim-sh-runner').setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'username/nvim-sh-runner'
```

## ⚙️ Configuration

The plugin works immediately after installation with no additional configuration needed. However, you can customize it if desired:

```lua
require('nvim-sh-runner').setup({
  -- Default values shown below
  terminal_height = 15,     -- Split height in lines
  command_name = 'RunShell' -- Command name
})
```

## 🚦 Usage

Run any shell script with arguments using the command:

```
:RunShell /path/to/script.sh arg1 arg2 arg3
```

Examples:

```
:RunShell ./build.sh --release
:RunShell ~/scripts/deploy.sh staging --force
```

## 💡 Usage Tips

- Map the command to a key for quick access:
  ```lua
  vim.keymap.set('n', '<leader>r', ':RunShell %<CR>', { noremap = true, silent = true })
  ```

- Use with temporary files for quick code execution:
  ```lua
  vim.keymap.set('n', '<leader>R', ':write !sh<CR>', { noremap = true, silent = false })
  ```

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🙏 Acknowledgements

- Inspired by integrated terminal development workflows
- Built with 💙 for the Neovim community

---

⭐ Don't forget to star this repository if you found this plugin useful!
