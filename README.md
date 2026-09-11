# slate ui

a modern, fast, and sleek monochrome ui library for roblox.

## installation

load slate directly using loadstring:

```lua
local slate = loadstring(game:HttpGet("https://raw.githubusercontent.com/EORScopeZ/slatelib/main/Slate.lua"))()
```

## quick start

```lua
local slate = loadstring(game:HttpGet("https://raw.githubusercontent.com/EORScopeZ/slatelib/main/Slate.lua"))()

local window = slate:CreateWindow({
    name = "slate",
    subtitle = "ui library",
    icon = 136661212895058,
    theme = "Default",
    sidebarLayout = false,
})

local tab = window:CreateTab({
    name = "home",
    icon = 136661212895058,
})

tab:CreateSection({
    name = "controls",
})

tab:CreateButton({
    name = "click me",
    description = "a simple button",
    callback = function()
        window:Notify({
            title = "slate",
            content = "button clicked",
            duration = 3,
        })
    end,
})

tab:CreateToggle({
    name = "auto farm",
    description = "toggle feature on or off",
    flag = "auto_farm",
    value = false,
    callback = function(val)
        print("toggle:", val)
    end,
})
```

## components

- tabs (top navigation or sidebar)
- sections & dividers
- buttons & toggles
- sliders & dropdowns
- text inputs & keybinds
- color pickers
- stat counters & progress bars
- interactive console
- notifications, toasts & popups
