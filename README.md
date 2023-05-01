Welcome to my Neovim configuration!

This configuration is designed to be used with Neovim 0.5.0 or later.


On my day to day I use Neovim for C/C++, Python, and Lua development.

## Approach
### Lua first
Lua fist approach, with a almost no vimscript.
### Modularity
Plugin configurations are separated into their own files.
### Reasonable Minimalism
Only the necessary plugins are installed. But this config is still made for modern desktop machines.
Not minimalist enough for an embedded Linux editor.

## Main features
### Efficient code navigation
- Telescope for fuzzy finding files and grepping
- Uses Ripgrep for grepping

### LSP support
Language Server Protocol support for C/C++, Python, and Lua.
Very good for real time code linting/analysis and completion.

#### C/C++
Uses Clangd as LSP server.
Uses clang-tidy for code linting. As long as you have .clang-tidy config file in your project root, it will be used.
Can check many things, such as if you C++ is modern enough ;)

#### Python
Uses Pyright as LSP server.

#### Lua
Uses Sumneko as LSP server.
I use this doe 



