# Action lists

A simple plugin that offers a straightforward solution to create lists of actions that can dynamically adapt based on filetypes

## Soft dependencies
[Dressing](https://github.com/stevearc/dressing.nvim) and [Telescope](https://github.com/nvim-telescope/telescope.nvim)

## Setup
```lua
require("action_lists").setup({
    lists = {
        simple = { -- A simple list of actions that can be used from any file
            actions = { -- Actions can have any name that can be used in lua tables
                test = 'echo "test"',
                tsupdate = 'TSUpdate',
                lua = 'lua print("From lua!")',

                func = function() -- Action Lists also supports functions
                    print("Hello from a function")
                end,

                -- You can also have actions with spaces in them
                ["Action with space"] = 'echo "Action with space"',
            },
        },

        multiple = { -- A dynamic action list that contains sub lists
            all = { -- Sub list that can be used from any file
                actions = {
                    all = 'lua print("This can be ran from any file!")',
                },
            },
            go = { -- Sub list that only can be used from go files
                ft = { "go" },
                actions = {
                    run = 'lua print("This can only be ran from go files!")',
                },
            },
        },
    },
})
```

## Open an action list
```vim
:OpenActionList <list>

" For example
:OpenActionList simple
```
