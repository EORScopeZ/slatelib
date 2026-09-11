# ⬛ Slate UI Framework

> A next-generation, high-performance **Black & White** monochrome UI framework for Roblox & Luau. Forked and refined from the Rayfield Gen2 architecture with 10x smoother spring physics, ultra-sleek monochrome aesthetics, integrated search filtering, and comprehensive executor compatibility.

---

## ✨ Features

- 🖤 **Monochrome Slate Aesthetics**: Deep obsidian dark backgrounds, crisp pure white typography, platinum borders, and glowing active accents.
- ⚡ **Enhanced Spring Animations**: Ultra-smooth quart and spring tween curves for toggles, dropdown accordions, sliders, and modal transitions.
- 🔍 **Live Search Filter**: Instant element filtering across tabs right in the sidebar.
- 🎛️ **Full Component Suite**:
  - **Toggles**: Fluid pill tracks with sliding knobs and flag synchronization.
  - **Sliders**: Precise click & drag seeking with step increments, live labels, and custom suffixes (`°`, `%`, ` studs/s`).
  - **Dropdowns**: Expandable single-select and multi-select lists with instant updates.
  - **Buttons**: Micro-scale click feedback, hover glow, and icon integration.
  - **Inputs / TextBoxes**: Custom focus glow, numeric filters, and submit callbacks.
  - **Keybinds**: Interactive key capture supporting toggle or hold triggers.
  - **Color Pickers**: Modern color swatch with real-time RGB/Hex synchronization.
  - **Notifications / Toasts**: Floating animated cards with timer bars and Lucide icons.
  - **Key System**: Built-in license key prompt with direct clipboard copy buttons for URLs and Discord invites.
- 🎨 **4 Built-in Themes**: `Slate` (Default), `Obsidian` (Deep Pitch Black), `Silver` (Frosted Gray & Platinum), `Ghost` (Minimalist Wireframe).
- 🛡️ **Universal Executor & Studio Support**: Safe GUI resolution (`gethui`, `get_hidden_gui`, `CoreGui`, `PlayerGui`) with `cloneref` protection.

---

## 🚀 Quick Start

### Loadstring Execution
```lua
local Slate = loadstring(game:HttpGet("https://raw.githubusercontent.com/EORScopeZ/slatelib/main/Slate.lua"))()

local Window = Slate:CreateWindow({
    Title = "Slate",
    Subtitle = "Monochrome Edition",
    Size = UDim2.fromOffset(620, 430),
    ToggleKey = Enum.KeyCode.RightControl,
    Theme = "Slate", -- "Slate" | "Obsidian" | "Silver" | "Ghost"
})
```

---

## 📖 Component API

### Creating Tabs
```lua
local Tab = Window:CreateTab({
    Name = "Combat",
    Icon = "home", -- Icon name or rbxassetid
})
```

### Sections & Dividers
```lua
Tab:CreateSection("Mechanics")
Tab:CreateDivider()
```

### Toggles
```lua
local Toggle = Tab:CreateToggle({
    Name = "Auto Parry",
    Description = "Automatically triggers parry upon projectile detection.",
    Default = true,
    Flag = "AutoParry",
    Callback = function(state)
        print("Auto Parry is now:", state)
    end
})

-- Update state programmatically:
Toggle:Set(false)
```

### Sliders
```lua
local Slider = Tab:CreateSlider({
    Name = "Field Of View",
    Range = { 70, 120 },
    Increment = 1,
    Default = 90,
    Suffix = "°",
    Flag = "FOV",
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- Update value programmatically:
Slider:Set(100)
```

### Dropdowns
```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Target Mode",
    Options = { "Closest", "Lowest HP", "Highest Priority" },
    Default = "Closest",
    MultipleOptions = false,
    Flag = "TargetMode",
    Callback = function(selected)
        print("Selected target mode:", selected)
    end
})
```

### Color Picker
```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Accent Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "UI такоеAccent",
    Callback = function(color)
        print("Selected Color:", color)
    end
})
```

### Notifications
```lua
Slate:Notify({
    Title = "Settings Saved",
    Content = "Your configuration profile was applied successfully.",
    Duration = 3.5,
    Icon = "check"
})
```

### Key System Prompt
```lua
Slate:CreateKeyPrompt({
    Title = "Slate Access",
    Subtitle = "Enter your activation key",
    KeyURL = "https://example.com/getkey",
    Discord = "https://discord.gg/yourserver",
    Key = "SLATE-2026-PREMIUM", -- Or validation function: function(key) return key == "MYKEY" end
    Callback = function()
        print("Key validated successfully! Initializing main script...")
    end
})
```

---

## 🎨 Themes

| Theme Name | Description |
|---|---|
| `Slate` | Default modern dark charcoal background (`rgb(13,13,15)`) with crisp pure white accents. |
| `Obsidian` | Ultra-deep pitch black (`rgb(8,8,8)`) high contrast layout. |
| `Silver` | Sleek metallic frosted platinum & slate styling. |
| `Ghost` | Ultra-minimalist dark wireframe aesthetic. |
