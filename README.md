# slate ui

a modern, fast, and sleek monochrome ui library for roblox.

## installation

```lua
local slate = loadstring(game:HttpGet("https://raw.githubusercontent.com/EORScopeZ/slatelib/main/Slate.lua"))()
```

## creating a window

```lua
local window = slate:CreateWindow({
    name = "slate",
    subtitle = "ui library",
    icon = 136661212895058,
    theme = "Default",
    sidebarLayout = false,
})
```

- `name` title shown at the top of the window
- `subtitle` optional secondary text
- `icon` asset id or image path for logo
- `theme` visual style ("Default", "Rose", "Amethyst", "Cobalt", "Frost", "Ember")
- `sidebarLayout` set to `false` for top tabs or `true` for sidebar navigation

## creating tabs and sections

```lua
local tab = window:CreateTab({
    name = "general",
    icon = 136661212895058,
})

local section = tab:CreateSection({
    name = "controls",
})
```

## adding components

### button

```lua
local button = tab:CreateButton({
    name = "click me",
    description = "runs a function on click",
    callback = function()
        print("button clicked")
    end,
})
```

### toggle

```lua
local toggle = tab:CreateToggle({
    name = "auto farm",
    description = "enable or disable auto farming",
    flag = "auto_farm",
    value = false,
    callback = function(state)
        print("toggle:", state)
    end,
})
```

### slider

```lua
local slider = tab:CreateSlider({
    name = "walkspeed",
    description = "adjust movement speed",
    flag = "speed_val",
    range = {16, 250},
    increment = 1,
    value = 16,
    suffix = " studs/s",
    callback = function(val)
        print("speed:", val)
    end,
})
```

### dropdown

```lua
local dropdown = tab:CreateDropdown({
    name = "select target",
    description = "choose an option from list",
    flag = "target_mode",
    options = {"closest", "lowest hp", "random"},
    value = "closest",
    multiSelect = false,
    callback = function(selected)
        print("selected:", selected)
    end,
})
```

### text input

```lua
local input = tab:CreateInput({
    name = "player name",
    description = "enter player username",
    flag = "player_target",
    placeholder = "username...",
    value = "",
    numeric = false,
    clearOnFocus = false,
    callback = function(text)
        print("input:", text)
    end,
})
```

### keybind

```lua
local keybind = tab:CreateKeybind({
    name = "fly key",
    description = "press key to activate",
    flag = "fly_bind",
    value = Enum.KeyCode.E,
    hold = false,
    callback = function()
        print("key pressed")
    end,
})
```

### color picker

```lua
local color_picker = tab:CreateColorPicker({
    name = "accent color",
    description = "pick a custom color",
    flag = "accent_color",
    color = Color3.fromRGB(255, 255, 255),
    alpha = 1,
    callback = function(color, alpha)
        print("color:", color, "alpha:", alpha)
    end,
})
```

### stat display

```lua
local stat = tab:CreateStat({
    name = "coins",
    prefix = "$",
    suffix = " coins",
    value = 100,
})
```

### progress bar

```lua
local progress = tab:CreateProgress({
    name = "level progress",
    range = {0, 100},
    value = 45,
    showValue = true,
})
```

### console

```lua
local console = tab:CreateConsole({
    name = "logs",
    text = "system ready.",
    height = 120,
})
```

## modifying and adjusting components

you can dynamically update component values and settings at any time:

### updating values

```lua
toggle:Set(true)
slider:Set(100)
dropdown:Set("lowest hp")
dropdown:Set({"closest", "random"})
input:Set("new target")
keybind:Set(Enum.KeyCode.F)
color_picker:Set(Color3.fromRGB(0, 170, 255))
stat:Set(2500)
progress:Set(80)
progress:SetText("level 5 (80%)")
console:Append("new log message")
console:Clear()
```

### updating dropdown options

```lua
dropdown:Refresh({"mob 1", "mob 2", "mob 3"})
dropdown:Add("mob 4")
dropdown:Remove("mob 1")
```

### locking and unlocking

lock any component to disable interaction or unlock it when needed:

```lua
button:Lock("disabled during combat")
button:Unlock()

toggle:Lock("feature unavailable")
toggle:Unlock()
```

### reordering elements

move elements around dynamically inside their tab:

```lua
button:MoveToTop()
button:MoveToBottom()
button:MoveUp()
button:MoveDown()
button:MoveTo(2)
```

## notifications, toasts & popups

### notification

```lua
window:Notify({
    title = "slate",
    content = "feature activated successfully",
    duration = 3,
})
```

### toast

```lua
window:Toast({
    title = "saved",
    subtitle = "config saved to disk",
    duration = 2.5,
})
```

### popup modal

```lua
window:Popup({
    title = "warning",
    subtitle = "action required",
    content = "do you want to reset all settings to default?",
    options = {
        {
            text = "yes",
            style = "Primary",
            callback = function()
                print("reset confirmed")
            end,
        },
        {
            text = "no",
            style = "Secondary",
            callback = function()
                print("cancelled")
            end,
        },
    },
})
```

## window controls & themes

```lua
window:ChangeTheme("Rose")
window:Hide()
window:Show()
window:ToggleHide()
window:Save("default_config")
window:Load("default_config")
window:Unload()
```
