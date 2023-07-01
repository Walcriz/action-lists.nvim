# Action lists

A simple plugin that offers a straightforward solution to create groups of actions that can dynamically adapt based on filetypes

## Soft dependencies
[Dressing](https://github.com/stevearc/dressing.nvim) and [Telescope](https://github.com/nvim-telescope/telescope.nvim)

## Simple setup
```lua
require("action_lists").setup({
    lists = {
        simple = {
            actions = { -- Reserved.
                test = 'echo "test"'
                tsupdate = 'TSUpdate'
                lua = 'lua print("From lua!")'
            }
        }
    }
})
```

## Full setup example
```lua
require("action_lists").setup({
    lists = {
        multiple = {
            all = {
                actions = {
                    all = 'lua print("This can be ran from any file!")'
                }
            }
            go = {
                ft = { "go" },
                actions = {
                    run = 'lua print("This can only be ran from go files!")'
                }
            }
        },

        simple = {
            actions = { -- The action name is reserved and if used will ignore any other sub lists.
                test = 'echo "test"'
            }
        }
    }
})
```

## Open an action list
```vim
:OpenActionList <list>
```
