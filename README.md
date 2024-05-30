# nvim-reset

nvim-reset is a Neovim plugin that allows you to disable all default keymaps in Neovim with a single command.

## Features

- Disables all default keymaps in Neovim
- Customizable ignore list to exclude specific keymaps from being reset

## Requirements

- Neovim 0.10.0 or later

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "ryoppippi/nvim-reset",
  opts = {}
}
```

## Configuration

You can customize the behavior of nvim-reset by passing options to the `setup` function. Here's an example configuration:

```lua
{
  "ryoppippi/nvim-reset",
  opts = {
    create_plugin_keymap = false,
    ignore_maps = {
      {
        mode = "n",
        lhs = "<leader>f"
      },
      {
        mode = {"i", "v"},
        lhs = "<C-s>"
      }
    }
  }
}
```

In this example, the `ignore_maps` option is used to specify keymaps that should not be reset. The `mode` can be either a single mode string or a table of mode strings, and `lhs` represents the left-hand side of the keymap.

When `create_plugin_keymap` is set to `true`, nvim-reset will create a keymap that can be used to reset keymaps like `<Plug>-NvimReset-[[mode]]-[[lhs]]`.

*You must call `setup` function before configuring your own keymaps. Otherwise, your keymaps will be reset.*

## Usage

Once you have installed and configured nvim-reset, it will automatically reset all default keymaps in Neovim, excluding any keymaps specified in the `ignore_list`.

## License

This plugin is released under the [MIT License](https://opensource.org/licenses/MIT).

## Author

[ryoppippi](https://github.com/ryoppippi)
