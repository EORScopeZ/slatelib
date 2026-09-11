--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                         SLATE UI LIBRARY                          ║
    ║                         EXAMPLE SCRIPT                            ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

-- Load Slate UI Library (Direct require or HttpGet)
local Slate = loadfile and loadfile("Slate.lua")() or require(script.Parent.Slate)

-- Create Window with Black & White Slate theme
local Window = Slate:CreateWindow({
    Title = "Slate",
    Subtitle = "Monochrome Edition",
    Size = UDim2.fromOffset(640, 440),
    ToggleKey = Enum.KeyCode.RightControl,
    Theme = "Slate", -- "Slate", "Obsidian", "Silver", "Ghost"
    AutoSave = true,
    configuration = {
        fileName = "SlateDemoConfig"
    }
})

-- Welcome Notification
Slate:Notify({
    Title = "Slate Initialized",
    Content = "Welcome to Slate UI Framework. Press RightControl to toggle visibility.",
    Duration = 4,
    Icon = "bell"
})

-- ==============================================================================
-- TAB 1: MAIN / COMBAT
-- ==============================================================================
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "home"
})

MainTab:CreateSection("Combat & Mechanics")

local AutoParryToggle = MainTab:CreateToggle({
    Name = "Auto Parry",
    Description = "Automatically timing parry actions based on target velocity.",
    Default = true,
    Flag = "AutoParry",
    Callback = function(state)
        print("[Slate] Auto Parry:", state)
    end
})

local SilentAimToggle = MainTab:CreateToggle({
    Name = "Silent Aim",
    Default = false,
    Flag = "SilentAim",
    Callback = function(state)
        print("[Slate] Silent Aim:", state)
    end
})

local FOVSlider = MainTab:CreateSlider({
    Name = "Field Of View",
    Range = { 70, 120 },
    Increment = 1,
    Default = 90,
    Suffix = "°",
    Flag = "FOVValue",
    Callback = function(val)
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = val
        end
    end
})

local WalkSpeedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = { 16, 150 },
    Increment = 2,
    Default = 16,
    Suffix = " studs/s",
    Flag = "WalkSpeed",
    Callback = function(val)
        local lp = game:GetService("Players").LocalPlayer
        if lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = val
        end
    end
})

MainTab:CreateDivider()
MainTab:CreateSection("Actions")

MainTab:CreateButton({
    Name = "Trigger Instant Dash",
    Icon = "terminal",
    Callback = function()
        Slate:Notify({
            Title = "Action Executed",
            Content = "Instant Dash successfully fired.",
            Duration = 2.5,
            Icon = "check"
        })
    end
})

-- ==============================================================================
-- TAB 2: VISUALS / ESP
-- ==============================================================================
local VisualsTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "eye"
})

VisualsTab:CreateSection("ESP Options")

VisualsTab:CreateToggle({
    Name = "Box ESP",
    Description = "Render high-contrast 2D bounding boxes on targets.",
    Default = true,
    Flag = "BoxESP",
    Callback = function(state)
        print("[Slate] Box ESP:", state)
    end
})

VisualsTab:CreateToggle({
    Name = "Tracer Lines",
    Default = false,
    Flag = "Tracers",
    Callback = function(state)
        print("[Slate] Tracers:", state)
    end
})

VisualsTab:CreateColorPicker({
    Name = "ESP Accent Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(color)
        print("[Slate] New ESP Color:", color)
    end
})

-- ==============================================================================
-- TAB 3: SETTINGS & CONFIG
-- ==============================================================================
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings"
})

SettingsTab:CreateSection("Configuration")

SettingsTab:CreateDropdown({
    Name = "Theme Preset",
    Options = { "Slate", "Obsidian", "Silver", "Ghost" },
    Default = "Slate",
    Flag = "SelectedTheme",
    Callback = function(selectedTheme)
        Slate.SelectedTheme = selectedTheme
        Slate:Notify({
            Title = "Theme Changed",
            Content = "Applied monochrome theme: " .. tostring(selectedTheme),
            Duration = 3,
            Icon = "check"
        })
    end
})

SettingsTab:CreateKeybind({
    Name = "Menu Toggle Key",
    Default = Enum.KeyCode.RightControl,
    Flag = "MenuToggleKey",
    Callback = function()
        print("[Slate] Menu keybind triggered")
    end
})

SettingsTab:CreateInput({
    Name = "Custom Tag Label",
    PlaceholderText = "Enter custom prefix...",
    Default = "Slate VIP",
    Flag = "CustomTag",
    Callback = function(text)
        print("[Slate] Custom Tag set to:", text)
    end
})

SettingsTab:CreateParagraph({
    Title = "About Slate UI",
    Content = "Slate is a modern, ultra-clean monochrome UI library built for Luau / Roblox with refined spring physics, black & white aesthetics, responsive search, and lightweight memory footprint."
})
