local slate = loadstring(game:HttpGet("https://raw.githubusercontent.com/EORScopeZ/slatelib/main/Slate.lua"))()

local window = slate:CreateWindow({
    name = "slate",
    subtitle = "full showcase",
    icon = 136661212895058,
    theme = "Default",
    sidebarLayout = false,
})

local main_tab = window:CreateTab({
    name = "main",
    icon = "home",
})

local elements_tab = window:CreateTab({
    name = "elements",
    icon = "sparkle",
})

local display_tab = window:CreateTab({
    name = "display",
    icon = "chart-multiple",
})

local misc_tab = window:CreateTab({
    name = "misc",
    icon = "settings",
})

main_tab:CreateSection({
    name = "basic controls",
})

main_tab:CreateButton({
    name = "send notification",
    description = "triggers a popup notification",
    callback = function()
        window:Notify({
            title = "slate",
            content = "notification triggered",
            duration = 3,
        })
    end,
})

main_tab:CreateToggle({
    name = "auto farm",
    description = "enables automated farming",
    flag = "auto_farm",
    value = false,
    callback = function(val)
        print("auto farm:", val)
    end,
})

main_tab:CreateSlider({
    name = "speed multiplier",
    description = "adjust movement speed",
    flag = "speed_mult",
    range = {16, 200},
    increment = 1,
    value = 16,
    suffix = " studs/s",
    callback = function(val)
        print("speed:", val)
    end,
})

main_tab:CreateDropdown({
    name = "select target",
    description = "choose single target",
    flag = "target_select",
    options = {"closest", "lowest health", "highest priority", "random"},
    value = "closest",
    multiSelect = false,
    callback = function(val)
        print("selected target:", val)
    end,
})

main_tab:CreateDropdown({
    name = "filter options",
    description = "multi-select dropdown",
    flag = "filter_options",
    options = {"players", "npcs", "items", "chests"},
    value = {"players", "chests"},
    multiSelect = true,
    callback = function(val)
        print("selected filters:", table.concat(val, ", "))
    end,
})

elements_tab:CreateSection({
    name = "inputs & keys",
})

elements_tab:CreateInput({
    name = "player username",
    description = "target player by name",
    flag = "target_name",
    placeholder = "enter username...",
    value = "",
    clearOnFocus = false,
    callback = function(text)
        print("entered text:", text)
    end,
})

elements_tab:CreateInput({
    name = "teleport amount",
    description = "numeric input filter",
    flag = "tp_amount",
    placeholder = "100",
    value = "100",
    numeric = true,
    callback = function(val)
        print("amount:", val)
    end,
})

elements_tab:CreateKeybind({
    name = "menu keybind",
    description = "bind key to toggle feature",
    flag = "menu_bind",
    value = Enum.KeyCode.RightShift,
    hold = false,
    callback = function()
        print("keybind pressed")
    end,
})

elements_tab:CreateColorPicker({
    name = "esp color",
    description = "change highlight color",
    flag = "esp_color",
    color = Color3.fromRGB(255, 255, 255),
    alpha = 1,
    callback = function(col, a)
        print("color updated:", col, "alpha:", a)
    end,
})

display_tab:CreateSection({
    name = "data & progress",
})

local stat_box = display_tab:CreateStat({
    name = "coins earned",
    description = "session balance tracker",
    prefix = "$",
    suffix = " coins",
    value = 1250,
})

local progress_bar = display_tab:CreateProgress({
    name = "level progress",
    description = "current exp to next level",
    range = {0, 100},
    value = 65,
    showValue = true,
})

local console_box = display_tab:CreateConsole({
    name = "debug output",
    description = "live script logs",
    text = "system initialized.\nslate ui loaded successfully.",
    height = 120,
})

misc_tab:CreateSection({
    name = "dialogs & utilities",
})

misc_tab:CreateText({
    name = "status info",
    text = "slate ui framework is running smoothly.",
})

misc_tab:CreateDivider({
    text = "prompts",
    line = true,
})

misc_tab:CreateButton({
    name = "show toast",
    description = "displays bottom toast alert",
    callback = function()
        window:Toast({
            title = "alert",
            subtitle = "action completed successfully",
            duration = 3,
        })
    end,
})

misc_tab:CreateButton({
    name = "show popup modal",
    description = "displays interactive popup",
    callback = function()
        window:Popup({
            title = "confirm action",
            subtitle = "modal dialog",
            content = "are you sure you want to proceed?",
            options = {
                {
                    text = "confirm",
                    style = "Primary",
                    callback = function()
                        print("confirmed")
                    end,
                },
                {
                    text = "cancel",
                    style = "Secondary",
                    callback = function()
                        print("cancelled")
                    end,
                },
            },
        })
    end,
})

misc_tab:CreateButton({
    name = "add console log",
    description = "appends line to debug console",
    callback = function()
        console_box:Append("new log entry generated")
    end,
})
