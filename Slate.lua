--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║                         ███████╗██╗      █████╗ ████████╗███████╗ ║
    ║                         ██╔════╝██║     ██╔══██╗╚══██╔══╝██╔════╝ ║
    ║                         ███████╗██║     ███████║   ██║   █████╗   ║
    ║                         ╚════██║██║     ██╔══██║   ██║   ██╔══╝   ║
    ║                         ███████║███████╗██║  ██║   ██║   ███████╗ ║
    ║                         ╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ║
    ║                                                                   ║
    ║                      MONOCHROME UI FRAMEWORK                      ║
    ║            Next-Gen Black & White Interface for Luau / Roblox     ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

local Slate = {
    Version = "2.5.0",
    Build = "Release",
    Flags = {},
    Open = true,
    Windows = {},
    Themes = {},
    Icons = {},
    SelectedTheme = "Slate",
}

-- Services with Safe Cloneref Resolution
local function getService(name)
    local ok, svc = pcall(function()
        return game:GetService(name)
    end)
    if ok and svc then
        if type(cloneref) == "function" then
            local ok2, cloned = pcall(cloneref, svc)
            if ok2 and cloned then
                return cloned
            end
        end
        return svc
    end
    return nil
end

local TweenService = getService("TweenService")
local UserInputService = getService("UserInputService")
local RunService = getService("RunService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")
local HttpService = getService("HttpService")
local TextService = getService("TextService")
local GuiService = getService("GuiService")

local LocalPlayer = Players and Players.LocalPlayer

-- GUI Container Resolution
local function getGuiContainer()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    if type(get_hidden_gui) == "function" then
        local ok, hgui = pcall(get_hidden_gui)
        if ok and hgui then return hgui end
    end
    if CoreGui then
        return CoreGui
    end
    if LocalPlayer then
        return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end
    return game:GetService("StarterGui")
end

local function protectGui(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif type(protectgui) == "function" then
            protectgui(gui)
        end
    end)
end

-- ==============================================================================
-- THEMES (Monochrome & High Contrast Slate Palettes)
-- ==============================================================================

Slate.Themes = {
    Slate = {
        Name = "Slate",
        WindowBg = Color3.fromRGB(13, 13, 15),
        WindowBgEnd = Color3.fromRGB(18, 18, 22),
        CardBg = Color3.fromRGB(22, 22, 26),
        CardBgHover = Color3.fromRGB(28, 28, 34),
        CardBgActive = Color3.fromRGB(34, 34, 42),
        SidebarBg = Color3.fromRGB(16, 16, 20),
        Border = Color3.fromRGB(42, 42, 48),
        BorderHover = Color3.fromRGB(70, 70, 80),
        BorderActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentText = Color3.fromRGB(15, 15, 18),
        AccentDim = Color3.fromRGB(200, 200, 205),
        Text = Color3.fromRGB(250, 250, 250),
        TextMuted = Color3.fromRGB(135, 135, 145),
        TextDim = Color3.fromRGB(90, 90, 100),
        ToggleTrackOff = Color3.fromRGB(28, 28, 34),
        ToggleTrackOn = Color3.fromRGB(255, 255, 255),
        ToggleKnobOff = Color3.fromRGB(140, 140, 150),
        ToggleKnobOn = Color3.fromRGB(15, 15, 18),
        SliderTrack = Color3.fromRGB(32, 32, 38),
        SliderFill = Color3.fromRGB(255, 255, 255),
        SliderFillEnd = Color3.fromRGB(200, 200, 210),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        Divider = Color3.fromRGB(38, 38, 44),
        NotificationBg = Color3.fromRGB(18, 18, 22),
        NotificationBorder = Color3.fromRGB(50, 50, 60),
        Success = Color3.fromRGB(255, 255, 255),
        Warning = Color3.fromRGB(220, 220, 225),
        Danger = Color3.fromRGB(180, 180, 190),
        CornerRadius = 10,
        ElementCornerRadius = 8,
    },
    Obsidian = {
        Name = "Obsidian",
        WindowBg = Color3.fromRGB(8, 8, 8),
        WindowBgEnd = Color3.fromRGB(14, 14, 14),
        CardBg = Color3.fromRGB(16, 16, 16),
        CardBgHover = Color3.fromRGB(24, 24, 24),
        CardBgActive = Color3.fromRGB(30, 30, 30),
        SidebarBg = Color3.fromRGB(11, 11, 11),
        Border = Color3.fromRGB(32, 32, 32),
        BorderHover = Color3.fromRGB(60, 60, 60),
        BorderActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentText = Color3.fromRGB(0, 0, 0),
        AccentDim = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(120, 120, 120),
        TextDim = Color3.fromRGB(75, 75, 75),
        ToggleTrackOff = Color3.fromRGB(22, 22, 22),
        ToggleTrackOn = Color3.fromRGB(255, 255, 255),
        ToggleKnobOff = Color3.fromRGB(100, 100, 100),
        ToggleKnobOn = Color3.fromRGB(10, 10, 10),
        SliderTrack = Color3.fromRGB(26, 26, 26),
        SliderFill = Color3.fromRGB(255, 255, 255),
        SliderFillEnd = Color3.fromRGB(180, 180, 180),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        Divider = Color3.fromRGB(28, 28, 28),
        NotificationBg = Color3.fromRGB(12, 12, 12),
        NotificationBorder = Color3.fromRGB(40, 40, 40),
        Success = Color3.fromRGB(255, 255, 255),
        Warning = Color3.fromRGB(200, 200, 200),
        Danger = Color3.fromRGB(160, 160, 160),
        CornerRadius = 8,
        ElementCornerRadius = 6,
    },
    Silver = {
        Name = "Silver",
        WindowBg = Color3.fromRGB(16, 17, 20),
        WindowBgEnd = Color3.fromRGB(24, 26, 30),
        CardBg = Color3.fromRGB(28, 30, 36),
        CardBgHover = Color3.fromRGB(36, 38, 46),
        CardBgActive = Color3.fromRGB(44, 48, 58),
        SidebarBg = Color3.fromRGB(20, 22, 26),
        Border = Color3.fromRGB(50, 55, 65),
        BorderHover = Color3.fromRGB(85, 95, 110),
        BorderActive = Color3.fromRGB(230, 235, 245),
        Accent = Color3.fromRGB(235, 240, 250),
        AccentText = Color3.fromRGB(20, 22, 28),
        AccentDim = Color3.fromRGB(190, 200, 215),
        Text = Color3.fromRGB(245, 248, 255),
        TextMuted = Color3.fromRGB(150, 160, 175),
        TextDim = Color3.fromRGB(100, 110, 125),
        ToggleTrackOff = Color3.fromRGB(35, 38, 45),
        ToggleTrackOn = Color3.fromRGB(230, 235, 245),
        ToggleKnobOff = Color3.fromRGB(160, 170, 185),
        ToggleKnobOn = Color3.fromRGB(20, 22, 28),
        SliderTrack = Color3.fromRGB(38, 42, 50),
        SliderFill = Color3.fromRGB(230, 235, 245),
        SliderFillEnd = Color3.fromRGB(180, 190, 210),
        SliderThumb = Color3.fromRGB(245, 248, 255),
        Divider = Color3.fromRGB(45, 50, 60),
        NotificationBg = Color3.fromRGB(22, 24, 28),
        NotificationBorder = Color3.fromRGB(60, 68, 80),
        Success = Color3.fromRGB(240, 245, 255),
        Warning = Color3.fromRGB(210, 220, 235),
        Danger = Color3.fromRGB(175, 185, 200),
        CornerRadius = 12,
        ElementCornerRadius = 8,
    },
    Ghost = {
        Name = "Ghost",
        WindowBg = Color3.fromRGB(5, 5, 6),
        WindowBgEnd = Color3.fromRGB(10, 10, 12),
        CardBg = Color3.fromRGB(14, 14, 16),
        CardBgHover = Color3.fromRGB(20, 20, 24),
        CardBgActive = Color3.fromRGB(26, 26, 32),
        SidebarBg = Color3.fromRGB(8, 8, 10),
        Border = Color3.fromRGB(28, 28, 34),
        BorderHover = Color3.fromRGB(55, 55, 65),
        BorderActive = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentText = Color3.fromRGB(5, 5, 6),
        AccentDim = Color3.fromRGB(170, 170, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(130, 130, 140),
        TextDim = Color3.fromRGB(80, 80, 90),
        ToggleTrackOff = Color3.fromRGB(20, 20, 24),
        ToggleTrackOn = Color3.fromRGB(255, 255, 255),
        ToggleKnobOff = Color3.fromRGB(120, 120, 130),
        ToggleKnobOn = Color3.fromRGB(5, 5, 6),
        SliderTrack = Color3.fromRGB(22, 22, 26),
        SliderFill = Color3.fromRGB(255, 255, 255),
        SliderFillEnd = Color3.fromRGB(160, 160, 170),
        SliderThumb = Color3.fromRGB(255, 255, 255),
        Divider = Color3.fromRGB(24, 24, 28),
        NotificationBg = Color3.fromRGB(10, 10, 12),
        NotificationBorder = Color3.fromRGB(36, 36, 44),
        Success = Color3.fromRGB(255, 255, 255),
        Warning = Color3.fromRGB(190, 190, 200),
        Danger = Color3.fromRGB(140, 140, 150),
        CornerRadius = 6,
        ElementCornerRadius = 5,
    }
}

function Slate:GetTheme()
    return Slate.Themes[Slate.SelectedTheme] or Slate.Themes.Slate
end

function Slate:RegisterTheme(themeName, themeData)
    Slate.Themes[themeName] = themeData
end

-- ==============================================================================
-- TWEEN / ANIMATION ENGINE
-- ==============================================================================

local function tween(object, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    duration = duration or 0.25
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local anim = TweenService:Create(object, tweenInfo, properties)
    anim:Play()
    return anim
end

local function spring(object, properties, speed, damping)
    speed = speed or 0.35
    local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local anim = TweenService:Create(object, tweenInfo, properties)
    anim:Play()
    return anim
end

-- ==============================================================================
-- LUCIDE / RAYFIELD ICON RESOLVER
-- ==============================================================================

local ICON_MAP_URL = "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua"
local cachedIconMap = nil

local function loadIconMap()
    if cachedIconMap ~= nil then return cachedIconMap end
    cachedIconMap = false
    if type(loadstring) == "function" and type(game.HttpGet) == "function" then
        pcall(function()
            local src = game:HttpGet(ICON_MAP_URL)
            local fn = loadstring(src)
            if type(fn) == "function" then
                local ok, map = pcall(fn)
                if ok and type(map) == "table" then
                    cachedIconMap = map
                end
            end
        end)
    end
    return cachedIconMap
end

function Slate:ResolveIcon(icon)
    if not icon or icon == "" or icon == 0 then return nil end
    if type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end
    if type(icon) == "string" then
        if string.match(icon, "^%d+$") then
            return "rbxassetid://" .. icon
        end
        if string.find(icon, "rbxassetid://") == 1 or string.sub(icon, 1, 4) == "http" then
            return icon
        end
        local map = loadIconMap()
        if type(map) == "table" then
            local sized = map["48px"] or map
            local found = sized[icon] or sized[string.lower(icon)]
            if found then
                if type(found) == "number" then
                    return "rbxassetid://" .. tostring(found)
                elseif type(found) == "string" then
                    return found
                elseif type(found) == "table" and (found.id or found.Id) then
                    return "rbxassetid://" .. tostring(found.id or found.Id)
                end
            end
        end
    end
    local defaultIcons = {
        home = "rbxassetid://93364949241311",
        settings = "rbxassetid://10734950309",
        user = "rbxassetid://10747373176",
        bell = "rbxassetid://125823673784681",
        search = "rbxassetid://10734975692",
        check = "rbxassetid://10709790644",
        cross = "rbxassetid://10747384394",
        chevron = "rbxassetid://10709790948",
        sliders = "rbxassetid://10734977012",
        code = "rbxassetid://10709810463",
        terminal = "rbxassetid://10734982144",
        key = "rbxassetid://10734952036",
        eye = "rbxassetid://10723346959",
        info = "rbxassetid://10723415903",
    }
    return defaultIcons[string.lower(tostring(icon))] or "rbxassetid://10734975692"
end

-- ==============================================================================
-- NOTIFICATION SYSTEM
-- ==============================================================================

local NotificationContainer = nil

local function getNotificationContainer()
    if NotificationContainer and NotificationContainer.Parent then
        return NotificationContainer
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SlateNotifications"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectGui(gui)
    gui.Parent = getGuiContainer()

    local frame = Instance.new("Frame")
    frame.Name = "Container"
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(1, -330, 0, 30)
    frame.Size = UDim2.new(0, 310, 1, -60)
    frame.Parent = gui

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)
    list.VerticalAlignment = Enum.VerticalAlignment.Top
    list.HorizontalAlignment = Enum.HorizontalAlignment.Right
    list.Parent = frame

    NotificationContainer = frame
    return frame
end

function Slate:Notify(options)
    options = options or {}
    local title = options.Title or options.name or "Notification"
    local content = options.Content or options.content or options.Description or ""
    local duration = options.Duration or options.duration or 4
    local icon = options.Icon or options.icon
    local theme = self:GetTheme()

    local container = getNotificationContainer()

    local card = Instance.new("Frame")
    card.Name = "Toast"
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = theme.NotificationBg
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, theme.CornerRadius)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.NotificationBorder
    stroke.Thickness = 1
    stroke.Parent = card

    local topGlow = Instance.new("Frame")
    topGlow.Name = "TopAccent"
    topGlow.Size = UDim2.new(1, 0, 0, 2)
    topGlow.Position = UDim2.new(0, 0, 0, 0)
    topGlow.BackgroundColor3 = theme.Accent
    topGlow.BorderSizePixel = 0
    topGlow.Parent = card

    local iconImage = nil
    local contentOffset = 16
    if icon then
        iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 20, 0, 20)
        iconImage.Position = UDim2.new(0, 14, 0, 14)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = Slate:ResolveIcon(icon)
        iconImage.ImageColor3 = theme.Accent
        iconImage.Parent = card
        contentOffset = 42
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -contentOffset - 16, 0, 20)
    titleLabel.Position = UDim2.new(0, contentOffset, 0, 14)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(1, -contentOffset - 16, 0, 0)
    descLabel.Position = UDim2.new(0, contentOffset, 0, 36)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = content
    descLabel.TextColor3 = theme.TextMuted
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = card

    local textBounds = TextService:GetTextSize(
        content,
        12,
        Enum.Font.Gotham,
        Vector2.new(310 - contentOffset - 16, 1000)
    )
    local targetHeight = math.max(60, 44 + textBounds.Y + 12)

    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "ProgressTrack"
    progressTrack.Size = UDim2.new(1, 0, 0, 2)
    progressTrack.Position = UDim2.new(0, 0, 1, -2)
    progressTrack.BackgroundColor3 = theme.Border
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card

    local progressBar = Instance.new("Frame")
    progressBar.Name = "Progress"
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = theme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressTrack

    spring(card, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.4)
    tween(progressBar, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        if card and card.Parent then
            local hideTween = tween(card, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, 0.3)
            stroke.Transparency = 1
            hideTween.Completed:Connect(function()
                card:Destroy()
            end)
        end
    end)
end

-- ==============================================================================
-- MAIN WINDOW BUILDER
-- ==============================================================================

function Slate:CreateWindow(config)
    config = config or {}
    local Title = config.Title or config.Name or config.name or "Slate UI"
    local Subtitle = config.Subtitle or config.subtitle or "Monochrome Edition"
    local Size = config.Size or UDim2.fromOffset(620, 430)
    local ToggleKey = config.ToggleKey or config.toggleKey or Enum.KeyCode.RightControl
    local ThemeName = config.Theme or config.theme or "Slate"
    local AutoSave = config.AutoSave or (config.configuration and config.configuration.autoSave) or false
    local ConfigFileName = (config.configuration and config.configuration.fileName) or "SlateConfig"

    if Slate.Themes[ThemeName] then
        Slate.SelectedTheme = ThemeName
    end
    local theme = Slate:GetTheme()

    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Elements = {},
        Flags = {},
        Visible = true,
        ConfigFileName = ConfigFileName,
        Theme = theme,
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Slate_" .. (HttpService and HttpService:GenerateGUID(false):sub(1, 8) or "UI")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 100
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectGui(ScreenGui)
    ScreenGui.Parent = getGuiContainer()

    Window.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2)
    MainFrame.BackgroundColor3 = theme.WindowBg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, theme.CornerRadius)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = theme.Border
    MainStroke.Thickness = 1.2
    MainStroke.Parent = MainFrame

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.WindowBg),
        ColorSequenceKeypoint.new(1, theme.WindowBgEnd),
    })
    MainGradient.Rotation = 45
    MainGradient.Parent = MainFrame

    local TopAccent = Instance.new("Frame")
    TopAccent.Name = "AccentGlow"
    TopAccent.Size = UDim2.new(1, 0, 0, 2)
    TopAccent.Position = UDim2.new(0, 0, 0, 0)
    TopAccent.BackgroundColor3 = theme.Accent
    TopAccent.BorderSizePixel = 0
    TopAccent.ZIndex = 5
    TopAccent.Parent = MainFrame

    local TopAccentGradient = Instance.new("UIGradient")
    TopAccentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 90)),
        ColorSequenceKeypoint.new(0.5, theme.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 90)),
    })
    TopAccentGradient.Parent = TopAccent

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 48)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local LogoIcon = Instance.new("Frame")
    LogoIcon.Name = "LogoIcon"
    LogoIcon.Size = UDim2.new(0, 24, 0, 24)
    LogoIcon.Position = UDim2.new(0, 16, 0.5, -12)
    LogoIcon.BackgroundColor3 = theme.Accent
    LogoIcon.BorderSizePixel = 0
    LogoIcon.Parent = Header

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoIcon

    local LogoDot = Instance.new("Frame")
    LogoDot.Name = "Dot"
    LogoDot.Size = UDim2.new(0, 8, 0, 8)
    LogoDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    LogoDot.BackgroundColor3 = theme.WindowBg
    LogoDot.BorderSizePixel = 0
    LogoDot.Parent = LogoIcon

    local LogoDotCorner = Instance.new("UICorner")
    LogoDotCorner.CornerRadius = UDim.new(1, 0)
    LogoDotCorner.Parent = LogoDot

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Position = UDim2.new(0, 48, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 48, 0, 26)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = Subtitle
    SubtitleLabel.TextColor3 = theme.TextMuted
    SubtitleLabel.TextSize = 11
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header

    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "Controls"
    ControlsFrame.Size = UDim2.new(0, 70, 0, 32)
    ControlsFrame.Position = UDim2.new(1, -82, 0.5, -16)
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Parent = Header

    local function createHeaderButton(iconId, posX, callback)
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.Position = UDim2.new(0, posX, 0, 2)
        btn.BackgroundColor3 = theme.CardBg
        btn.BackgroundTransparency = 0.5
        btn.Image = iconId
        btn.ImageColor3 = theme.TextMuted
        btn.BorderSizePixel = 0
        btn.Parent = ControlsFrame

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Color = theme.Border
        s.Thickness = 1
        s.Parent = btn

        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundTransparency = 0, ImageColor3 = theme.Text }, 0.2)
            tween(s, { Color = theme.BorderHover }, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundTransparency = 0.5, ImageColor3 = theme.TextMuted }, 0.2)
            tween(s, { Color = theme.Border }, 0.2)
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createHeaderButton(Slate:ResolveIcon("sliders"), 0, function()
        Window:Toggle()
    end)

    createHeaderButton(Slate:ResolveIcon("cross"), 36, function()
        Window:Destroy()
    end)

    local HeaderDivider = Instance.new("Frame")
    HeaderDivider.Name = "Divider"
    HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
    HeaderDivider.Position = UDim2.new(0, 0, 0, 48)
    HeaderDivider.BackgroundColor3 = theme.Divider
    HeaderDivider.BorderSizePixel = 0
    HeaderDivider.Parent = MainFrame

    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, 0, 1, -49)
    Body.Position = UDim2.new(0, 0, 0, 49)
    Body.BackgroundTransparency = 1
    Body.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = theme.SidebarBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "Divider"
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.BackgroundColor3 = theme.Divider
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Sidebar

    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Size = UDim2.new(1, -20, 0, 30)
    SearchContainer.Position = UDim2.new(0, 10, 0, 10)
    SearchContainer.BackgroundColor3 = theme.CardBg
    SearchContainer.BorderSizePixel = 0
    SearchContainer.Parent = Sidebar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchContainer

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = theme.Border
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchContainer

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = Slate:ResolveIcon("search")
    SearchIcon.ImageColor3 = theme.TextDim
    SearchIcon.Parent = SearchContainer

    local SearchInput = Instance.new("TextBox")
    SearchInput.Name = "Input"
    SearchInput.Size = UDim2.new(1, -30, 1, 0)
    SearchInput.Position = UDim2.new(0, 26, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = "Search..."
    SearchInput.PlaceholderColor3 = theme.TextDim
    SearchInput.Text = ""
    SearchInput.TextColor3 = theme.Text
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchContainer

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, -12, 1, -52)
    TabList.Position = UDim2.new(0, 6, 0, 46)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = theme.Border
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabList

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -160, 1, 0)
    ContentContainer.Position = UDim2.new(0, 160, 0, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Body

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchInput.Text)
        for _, elem in pairs(Window.Elements) do
            if elem.Frame and elem.Name then
                if query == "" then
                    elem.Frame.Visible = true
                else
                    local match = string.find(string.lower(elem.Name), query, 1, true)
                    elem.Frame.Visible = (match ~= nil)
                end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            Window:Toggle()
        end
    end)

    function Window:Toggle()
        Window.Visible = not Window.Visible
        if Window.Visible then
            MainFrame.Visible = true
            spring(MainFrame, { Size = Size, BackgroundTransparency = 0 }, 0.35)
        else
            local hideAnim = tween(MainFrame, { Size = UDim2.new(0, Size.X.Offset, 0, 48) }, 0.25)
            hideAnim.Completed:Connect(function()
                if not Window.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end

    function Window:Destroy()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    function Window:Notify(options)
        Slate:Notify(options)
    end

    function Window:CreateTab(tabProps)
        tabProps = tabProps or {}
        local tabName = tabProps.Name or tabProps.name or "Tab"
        local tabIcon = tabProps.Icon or tabProps.icon

        local Tab = {
            Name = tabName,
            Window = Window,
            Elements = {},
        }

        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page_" .. tabName
        Page.Size = UDim2.new(1, -20, 1, -16)
        Page.Position = UDim2.new(0, 10, 0, 8)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = theme.Border
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = (#Window.Tabs == 0)
        Page.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingBottom = UDim.new(0, 12)
        PagePadding.PaddingTop = UDim.new(0, 4)
        PagePadding.PaddingLeft = UDim.new(0, 4)
        PagePadding.PaddingRight = UDim.new(0, 6)
        PagePadding.Parent = Page

        Tab.Page = Page

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabName
        TabButton.Size = UDim2.new(1, 0, 0, 34)
        TabButton.BackgroundColor3 = (#Window.Tabs == 0) and theme.CardBgActive or theme.SidebarBg
        TabButton.BackgroundTransparency = (#Window.Tabs == 0) and 0 or 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabList

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
        TabBtnCorner.Parent = TabButton

        local TabBtnStroke = Instance.new("UIStroke")
        TabBtnStroke.Color = (#Window.Tabs == 0) and theme.BorderHover or Color3.fromRGB(0, 0, 0)
        TabBtnStroke.Transparency = (#Window.Tabs == 0) and 0 or 1
        TabBtnStroke.Thickness = 1
        TabBtnStroke.Parent = TabButton

        local ActiveIndicator = Instance.new("Frame")
        ActiveIndicator.Name = "Indicator"
        ActiveIndicator.Size = UDim2.new(0, 3, 0, 16)
        ActiveIndicator.Position = UDim2.new(0, 4, 0.5, -8)
        ActiveIndicator.BackgroundColor3 = theme.Accent
        ActiveIndicator.BorderSizePixel = 0
        ActiveIndicator.Visible = (#Window.Tabs == 0)
        ActiveIndicator.Parent = TabButton

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = ActiveIndicator

        local tabIconOffset = 12
        if tabIcon then
            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = "Icon"
            iconImg.Size = UDim2.new(0, 16, 0, 16)
            iconImg.Position = UDim2.new(0, 12, 0.5, -8)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = Slate:ResolveIcon(tabIcon)
            iconImg.ImageColor3 = (#Window.Tabs == 0) and theme.Text or theme.TextMuted
            iconImg.Parent = TabButton
            tabIconOffset = 34
            Tab.IconImage = iconImg
        end

        local TabText = Instance.new("TextLabel")
        TabText.Name = "Title"
        TabText.Size = UDim2.new(1, -tabIconOffset - 8, 1, 0)
        TabText.Position = UDim2.new(0, tabIconOffset, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Font = Enum.Font.GothamMedium
        TabText.Text = tabName
        TabText.TextColor3 = (#Window.Tabs == 0) and theme.Text or theme.TextMuted
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton

        Tab.Button = TabButton
        Tab.TitleLabel = TabText
        Tab.Indicator = ActiveIndicator
        Tab.Stroke = TabBtnStroke

        function Tab:Select()
            for _, otherTab in ipairs(Window.Tabs) do
                otherTab.Page.Visible = false
                otherTab.Indicator.Visible = false
                tween(otherTab.Button, { BackgroundTransparency = 1 }, 0.2)
                otherTab.Stroke.Transparency = 1
                otherTab.TitleLabel.TextColor3 = theme.TextMuted
                if otherTab.IconImage then
                    otherTab.IconImage.ImageColor3 = theme.TextMuted
                end
            end
            Tab.Page.Visible = true
            Tab.Indicator.Visible = true
            tween(Tab.Button, { BackgroundTransparency = 0, BackgroundColor3 = theme.CardBgActive }, 0.2)
            Tab.Stroke.Transparency = 0
            Tab.TitleLabel.TextColor3 = theme.Text
            if Tab.IconImage then
                Tab.IconImage.ImageColor3 = theme.Text
            end
            Window.ActiveTab = Tab
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                tween(TabButton, { BackgroundTransparency = 0.5, BackgroundColor3 = theme.CardBgHover }, 0.2)
                Tab.TitleLabel.TextColor3 = theme.Text
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                tween(TabButton, { BackgroundTransparency = 1 }, 0.2)
                Tab.TitleLabel.TextColor3 = theme.TextMuted
            end
        end)

        if #Window.Tabs == 0 then
            Window.ActiveTab = Tab
        end

        table.insert(Window.Tabs, Tab)

        -- SECTION
        function Tab:CreateSection(sectionProps)
            local sName = type(sectionProps) == "string" and sectionProps or (sectionProps and (sectionProps.Name or sectionProps.name)) or "Section"

            local SecFrame = Instance.new("Frame")
            SecFrame.Name = "Section_" .. sName
            SecFrame.Size = UDim2.new(1, 0, 0, 24)
            SecFrame.BackgroundTransparency = 1
            SecFrame.Parent = Tab.Page

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Name = "Title"
            SecLabel.Size = UDim2.new(1, 0, 1, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.Text = string.upper(sName)
            SecLabel.TextColor3 = theme.TextDim
            SecLabel.TextSize = 10
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = SecFrame

            return SecFrame
        end

        function Tab:CreateDivider()
            local DivFrame = Instance.new("Frame")
            DivFrame.Name = "Divider"
            DivFrame.Size = UDim2.new(1, 0, 0, 1)
            DivFrame.BackgroundColor3 = theme.Divider
            DivFrame.BorderSizePixel = 0
            DivFrame.Parent = Tab.Page
            return DivFrame
        end

        -- TOGGLE
        function Tab:CreateToggle(toggleProps)
            toggleProps = toggleProps or {}
            local tName = toggleProps.Name or toggleProps.name or "Toggle"
            local tDesc = toggleProps.Description or toggleProps.description
            local tDefault = toggleProps.Default or toggleProps.CurrentValue or toggleProps.value or false
            local tFlag = toggleProps.Flag or toggleProps.flag
            local tCallback = toggleProps.Callback or toggleProps.callback or function() end

            local ToggleState = tDefault

            local cardHeight = tDesc and 50 or 38
            local Card = Instance.new("Frame")
            Card.Name = "Toggle_" .. tName
            Card.Size = UDim2.new(1, 0, 0, cardHeight)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -70, 0, 20)
            Title.Position = UDim2.new(0, 12, 0, tDesc and 6 or 9)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = tName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            if tDesc then
                local Desc = Instance.new("TextLabel")
                Desc.Name = "Description"
                Desc.Size = UDim2.new(1, -70, 0, 16)
                Desc.Position = UDim2.new(0, 12, 0, 26)
                Desc.BackgroundTransparency = 1
                Desc.Font = Enum.Font.Gotham
                Desc.Text = tDesc
                Desc.TextColor3 = theme.TextMuted
                Desc.TextSize = 11
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.Parent = Card
            end

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.Size = UDim2.new(0, 42, 0, 22)
            Track.Position = UDim2.new(1, -54, 0.5, -11)
            Track.BackgroundColor3 = ToggleState and theme.ToggleTrackOn or theme.ToggleTrackOff
            Track.BorderSizePixel = 0
            Track.Parent = Card

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local TrackStroke = Instance.new("UIStroke")
            TrackStroke.Color = ToggleState and theme.Accent or theme.Border
            TrackStroke.Thickness = 1
            TrackStroke.Parent = Track

            local Knob = Instance.new("Frame")
            Knob.Name = "Knob"
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = ToggleState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Knob.BackgroundColor3 = ToggleState and theme.ToggleKnobOn or theme.ToggleKnobOff
            Knob.BorderSizePixel = 0
            Knob.Parent = Track

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob

            local Hitbox = Instance.new("TextButton")
            Hitbox.Size = UDim2.new(1, 0, 1, 0)
            Hitbox.BackgroundTransparency = 1
            Hitbox.Text = ""
            Hitbox.Parent = Card

            local function SetState(val)
                ToggleState = val
                if tFlag then
                    Slate.Flags[tFlag] = ToggleState
                    Window.Flags[tFlag] = ToggleState
                end
                if ToggleState then
                    spring(Knob, { Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = theme.ToggleKnobOn }, 0.3)
                    tween(Track, { BackgroundColor3 = theme.ToggleTrackOn }, 0.2)
                    tween(TrackStroke, { Color = theme.Accent }, 0.2)
                else
                    spring(Knob, { Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = theme.ToggleKnobOff }, 0.3)
                    tween(Track, { BackgroundColor3 = theme.ToggleTrackOff }, 0.2)
                    tween(TrackStroke, { Color = theme.Border }, 0.2)
                end
                task.spawn(tCallback, ToggleState)
            end

            Hitbox.MouseButton1Click:Connect(function()
                SetState(not ToggleState)
            end)

            Hitbox.MouseEnter:Connect(function()
                tween(Card, { BackgroundColor3 = theme.CardBgHover }, 0.2)
                tween(Stroke, { Color = theme.BorderHover }, 0.2)
            end)

            Hitbox.MouseLeave:Connect(function()
                tween(Card, { BackgroundColor3 = theme.CardBg }, 0.2)
                tween(Stroke, { Color = theme.Border }, 0.2)
            end)

            if tFlag then
                Slate.Flags[tFlag] = ToggleState
                Window.Flags[tFlag] = ToggleState
            end

            local ToggleObject = {
                Frame = Card,
                Name = tName,
                Set = SetState,
                Get = function() return ToggleState end,
            }
            table.insert(Window.Elements, ToggleObject)
            return ToggleObject
        end

        -- SLIDER
        function Tab:CreateSlider(sliderProps)
            sliderProps = sliderProps or {}
            local sName = sliderProps.Name or sliderProps.name or "Slider"
            local sRange = sliderProps.Range or sliderProps.range or { 0, 100 }
            local sMin = sRange[1] or 0
            local sMax = sRange[2] or 100
            local sStep = sliderProps.Increment or sliderProps.increment or sliderProps.Step or 1
            local sSuffix = sliderProps.Suffix or sliderProps.suffix or ""
            local sDefault = sliderProps.Default or sliderProps.CurrentValue or sliderProps.value or sMin
            local sFlag = sliderProps.Flag or sliderProps.flag
            local sCallback = sliderProps.Callback or sliderProps.callback or function() end

            local CurrentValue = math.clamp(sDefault, sMin, sMax)

            local Card = Instance.new("Frame")
            Card.Name = "Slider_" .. sName
            Card.Size = UDim2.new(1, 0, 0, 48)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -90, 0, 20)
            Title.Position = UDim2.new(0, 12, 0, 6)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = sName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.Size = UDim2.new(0, 80, 0, 20)
            ValueLabel.Position = UDim2.new(1, -92, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(CurrentValue) .. sSuffix
            ValueLabel.TextColor3 = theme.Accent
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Card

            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 0, 32)
            Track.BackgroundColor3 = theme.SliderTrack
            Track.BorderSizePixel = 0
            Track.Parent = Card

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            local initialPercent = (CurrentValue - sMin) / (sMax - sMin)
            Fill.Size = UDim2.new(initialPercent, 0, 1, 0)
            Fill.BackgroundColor3 = theme.SliderFill
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local FillGradient = Instance.new("UIGradient")
            FillGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.SliderFillEnd),
                ColorSequenceKeypoint.new(1, theme.SliderFill),
            })
            FillGradient.Parent = Fill

            local Thumb = Instance.new("Frame")
            Thumb.Name = "Thumb"
            Thumb.Size = UDim2.new(0, 12, 0, 12)
            Thumb.Position = UDim2.new(initialPercent, -6, 0.5, -6)
            Thumb.BackgroundColor3 = theme.SliderThumb
            Thumb.BorderSizePixel = 0
            Thumb.Parent = Track

            local ThumbCorner = Instance.new("UICorner")
            ThumbCorner.CornerRadius = UDim.new(1, 0)
            ThumbCorner.Parent = Thumb

            local isDragging = false

            local function UpdateFromInput(input)
                local absPos = Track.AbsolutePosition.X
                local absSize = Track.AbsoluteSize.X
                local inputX = input.Position.X
                local percent = math.clamp((inputX - absPos) / absSize, 0, 1)

                local rawVal = sMin + (sMax - sMin) * percent
                local steppedVal = math.floor(rawVal / sStep + 0.5) * sStep
                steppedVal = math.clamp(steppedVal, sMin, sMax)

                CurrentValue = steppedVal
                ValueLabel.Text = tostring(CurrentValue) .. sSuffix

                local visualPercent = (CurrentValue - sMin) / (sMax - sMin)
                Fill.Size = UDim2.new(visualPercent, 0, 1, 0)
                Thumb.Position = UDim2.new(visualPercent, -6, 0.5, -6)

                if sFlag then
                    Slate.Flags[sFlag] = CurrentValue
                    Window.Flags[sFlag] = CurrentValue
                end
                task.spawn(sCallback, CurrentValue)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateFromInput(input)
                end
            end)

            Card.MouseEnter:Connect(function()
                tween(Card, { BackgroundColor3 = theme.CardBgHover }, 0.2)
                tween(Stroke, { Color = theme.BorderHover }, 0.2)
            end)

            Card.MouseLeave:Connect(function()
                tween(Card, { BackgroundColor3 = theme.CardBg }, 0.2)
                tween(Stroke, { Color = theme.Border }, 0.2)
            end)

            if sFlag then
                Slate.Flags[sFlag] = CurrentValue
                Window.Flags[sFlag] = CurrentValue
            end

            local SliderObject = {
                Frame = Card,
                Name = sName,
                Set = function(val)
                    CurrentValue = math.clamp(val, sMin, sMax)
                    local p = (CurrentValue - sMin) / (sMax - sMin)
                    ValueLabel.Text = tostring(CurrentValue) .. sSuffix
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Thumb.Position = UDim2.new(p, -6, 0.5, -6)
                    if sFlag then
                        Slate.Flags[sFlag] = CurrentValue
                        Window.Flags[sFlag] = CurrentValue
                    end
                    task.spawn(sCallback, CurrentValue)
                end,
                Get = function() return CurrentValue end,
            }
            table.insert(Window.Elements, SliderObject)
            return SliderObject
        end

        -- BUTTON
        function Tab:CreateButton(buttonProps)
            buttonProps = buttonProps or {}
            local bName = buttonProps.Name or buttonProps.name or "Button"
            local bIcon = buttonProps.Icon or buttonProps.icon
            local bCallback = buttonProps.Callback or buttonProps.callback or function() end

            local Card = Instance.new("TextButton")
            Card.Name = "Button_" .. bName
            Card.Size = UDim2.new(1, 0, 0, 36)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Text = ""
            Card.AutoButtonColor = false
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local textOffset = 14
            if bIcon then
                local iconImg = Instance.new("ImageLabel")
                iconImg.Name = "Icon"
                iconImg.Size = UDim2.new(0, 16, 0, 16)
                iconImg.Position = UDim2.new(0, 12, 0.5, -8)
                iconImg.BackgroundTransparency = 1
                iconImg.Image = Slate:ResolveIcon(bIcon)
                iconImg.ImageColor3 = theme.Accent
                iconImg.Parent = Card
                textOffset = 36
            end

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -textOffset - 30, 1, 0)
            Title.Position = UDim2.new(0, textOffset, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = bName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.new(0, 14, 0, 14)
            Arrow.Position = UDim2.new(1, -24, 0.5, -7)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = Slate:ResolveIcon("chevron")
            Arrow.ImageColor3 = theme.TextDim
            Arrow.Parent = Card

            Card.MouseButton1Down:Connect(function()
                spring(Card, { Size = UDim2.new(1, -4, 0, 34), BackgroundColor3 = theme.CardBgActive }, 0.15)
            end)

            Card.MouseButton1Up:Connect(function()
                spring(Card, { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.CardBgHover }, 0.2)
                task.spawn(bCallback)
            end)

            Card.MouseEnter:Connect(function()
                tween(Card, { BackgroundColor3 = theme.CardBgHover }, 0.2)
                tween(Stroke, { Color = theme.BorderHover }, 0.2)
                tween(Arrow, { ImageColor3 = theme.Accent }, 0.2)
            end)

            Card.MouseLeave:Connect(function()
                spring(Card, { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.CardBg }, 0.2)
                tween(Stroke, { Color = theme.Border }, 0.2)
                tween(Arrow, { ImageColor3 = theme.TextDim }, 0.2)
            end)

            local ButtonObject = {
                Frame = Card,
                Name = bName,
                SetCallback = function(fn) bCallback = fn end,
            }
            table.insert(Window.Elements, ButtonObject)
            return ButtonObject
        end

        -- DROPDOWN
        function Tab:CreateDropdown(dropdownProps)
            dropdownProps = dropdownProps or {}
            local dName = dropdownProps.Name or dropdownProps.name or "Dropdown"
            local dOptions = dropdownProps.Options or dropdownProps.options or {}
            local dMulti = dropdownProps.MultipleOptions or dropdownProps.multiSelect or false
            local dDefault = dropdownProps.Default or dropdownProps.CurrentOption or dropdownProps.value
            local dFlag = dropdownProps.Flag or dropdownProps.flag
            local dCallback = dropdownProps.Callback or dropdownProps.callback or function() end

            local Selected = dMulti and {} or (dDefault or dOptions[1] or "None")
            if dMulti and type(dDefault) == "table" then
                Selected = dDefault
            end

            local isExpanded = false

            local Card = Instance.new("Frame")
            Card.Name = "Dropdown_" .. dName
            Card.Size = UDim2.new(1, 0, 0, 40)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.ClipsDescendants = true
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local TopBar = Instance.new("TextButton")
            TopBar.Name = "TopBar"
            TopBar.Size = UDim2.new(1, 0, 0, 40)
            TopBar.BackgroundTransparency = 1
            TopBar.Text = ""
            TopBar.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(0.5, -12, 1, 0)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = dName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = TopBar

            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Name = "Selected"
            SelectedLabel.Size = UDim2.new(0.5, -34, 1, 0)
            SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Font = Enum.Font.Gotham
            SelectedLabel.Text = dMulti and table.concat(Selected, ", ") or tostring(Selected)
            SelectedLabel.TextColor3 = theme.TextMuted
            SelectedLabel.TextSize = 12
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
            SelectedLabel.Parent = TopBar

            local Chevron = Instance.new("ImageLabel")
            Chevron.Name = "Chevron"
            Chevron.Size = UDim2.new(0, 14, 0, 14)
            Chevron.Position = UDim2.new(1, -24, 0.5, -7)
            Chevron.BackgroundTransparency = 1
            Chevron.Image = Slate:ResolveIcon("chevron")
            Chevron.ImageColor3 = theme.TextMuted
            Chevron.Parent = TopBar

            local OptionsContainer = Instance.new("ScrollingFrame")
            OptionsContainer.Name = "Options"
            OptionsContainer.Size = UDim2.new(1, -16, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 8, 0, 44)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.ScrollBarThickness = 2
            OptionsContainer.ScrollBarImageColor3 = theme.Border
            OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            OptionsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
            OptionsContainer.Parent = Card

            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 4)
            OptionsLayout.Parent = OptionsContainer

            local function UpdateSelectedText()
                if dMulti then
                    SelectedLabel.Text = #Selected > 0 and table.concat(Selected, ", ") or "None"
                else
                    SelectedLabel.Text = tostring(Selected)
                end
            end

            local function RefreshOptions()
                for _, child in pairs(OptionsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, opt in ipairs(dOptions) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Name = "Option_" .. tostring(opt)
                    optBtn.Size = UDim2.new(1, 0, 0, 28)
                    optBtn.BackgroundColor3 = theme.SidebarBg
                    optBtn.BackgroundTransparency = 0.5
                    optBtn.BorderSizePixel = 0
                    optBtn.Text = ""
                    optBtn.AutoButtonColor = false
                    optBtn.Parent = OptionsContainer

                    local optCorner = Instance.new("UICorner")
                    optCorner.CornerRadius = UDim.new(0, 6)
                    optCorner.Parent = optBtn

                    local optText = Instance.new("TextLabel")
                    optText.Size = UDim2.new(1, -30, 1, 0)
                    optText.Position = UDim2.new(0, 10, 0, 0)
                    optText.BackgroundTransparency = 1
                    optText.Font = Enum.Font.Gotham
                    optText.Text = tostring(opt)
                    optText.TextColor3 = theme.Text
                    optText.TextSize = 12
                    optText.TextXAlignment = Enum.TextXAlignment.Left
                    optText.Parent = optBtn

                    local checkIcon = Instance.new("ImageLabel")
                    checkIcon.Size = UDim2.new(0, 12, 0, 12)
                    checkIcon.Position = UDim2.new(1, -20, 0.5, -6)
                    checkIcon.BackgroundTransparency = 1
                    checkIcon.Image = Slate:ResolveIcon("check")
                    checkIcon.ImageColor3 = theme.Accent
                    local isChosen = dMulti and table.find(Selected, opt) or (Selected == opt)
                    checkIcon.Visible = isChosen and true or false
                    checkIcon.Parent = optBtn

                    optBtn.MouseButton1Click:Connect(function()
                        if dMulti then
                            local idx = table.find(Selected, opt)
                            if idx then
                                table.remove(Selected, idx)
                                checkIcon.Visible = false
                            else
                                table.insert(Selected, opt)
                                checkIcon.Visible = true
                            end
                        else
                            Selected = opt
                            for _, b in pairs(OptionsContainer:GetChildren()) do
                                if b:IsA("TextButton") and b:FindFirstChildOfClass("ImageLabel") then
                                    b:FindFirstChildOfClass("ImageLabel").Visible = false
                                end
                            end
                            checkIcon.Visible = true
                        end
                        UpdateSelectedText()
                        if dFlag then
                            Slate.Flags[dFlag] = Selected
                            Window.Flags[dFlag] = Selected
                        end
                        task.spawn(dCallback, Selected)
                    end)
                end
            end

            RefreshOptions()

            local function ToggleDropdown()
                isExpanded = not isExpanded
                local optHeight = math.min(#dOptions * 32, 130)
                if isExpanded then
                    tween(Chevron, { Rotation = 180 }, 0.25)
                    OptionsContainer.Size = UDim2.new(1, -16, 0, optHeight)
                    spring(Card, { Size = UDim2.new(1, 0, 0, 48 + optHeight) }, 0.3)
                else
                    tween(Chevron, { Rotation = 0 }, 0.25)
                    local collapse = spring(Card, { Size = UDim2.new(1, 0, 0, 40) }, 0.25)
                    collapse.Completed:Connect(function()
                        if not isExpanded then
                            OptionsContainer.Size = UDim2.new(1, -16, 0, 0)
                        end
                    end)
                end
            end

            TopBar.MouseButton1Click:Connect(ToggleDropdown)

            if dFlag then
                Slate.Flags[dFlag] = Selected
                Window.Flags[dFlag] = Selected
            end

            local DropdownObject = {
                Frame = Card,
                Name = dName,
                Set = function(val)
                    Selected = val
                    UpdateSelectedText()
                    RefreshOptions()
                    if dFlag then
                        Slate.Flags[dFlag] = Selected
                        Window.Flags[dFlag] = Selected
                    end
                    task.spawn(dCallback, Selected)
                end,
                Refresh = function(newOptions)
                    dOptions = newOptions or {}
                    RefreshOptions()
                end,
                Get = function() return Selected end,
            }
            table.insert(Window.Elements, DropdownObject)
            return DropdownObject
        end

        -- INPUT
        function Tab:CreateInput(inputProps)
            inputProps = inputProps or {}
            local iName = inputProps.Name or inputProps.name or "Input"
            local iPlaceholder = inputProps.PlaceholderText or inputProps.placeholder or "Type here..."
            local iDefault = inputProps.Default or inputProps.CurrentValue or inputProps.value or ""
            local iClearOnEnter = inputProps.ClearTextOnFocus or false
            local iNumeric = inputProps.Numeric or false
            local iFlag = inputProps.Flag or inputProps.flag
            local iCallback = inputProps.Callback or inputProps.callback or function() end

            local CurrentText = iDefault

            local Card = Instance.new("Frame")
            Card.Name = "Input_" .. iName
            Card.Size = UDim2.new(1, 0, 0, 40)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(0.45, 0, 1, 0)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = iName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local InputBoxBg = Instance.new("Frame")
            InputBoxBg.Name = "InputBox"
            InputBoxBg.Size = UDim2.new(0.5, -8, 0, 26)
            InputBoxBg.Position = UDim2.new(0.5, 0, 0.5, -13)
            InputBoxBg.BackgroundColor3 = theme.SidebarBg
            InputBoxBg.BorderSizePixel = 0
            InputBoxBg.Parent = Card

            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 6)
            InputCorner.Parent = InputBoxBg

            local InputStroke = Instance.new("UIStroke")
            InputStroke.Color = theme.Border
            InputStroke.Thickness = 1
            InputStroke.Parent = InputBoxBg

            local TextBox = Instance.new("TextBox")
            TextBox.Name = "Box"
            TextBox.Size = UDim2.new(1, -16, 1, 0)
            TextBox.Position = UDim2.new(0, 8, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderText = iPlaceholder
            TextBox.PlaceholderColor3 = theme.TextDim
            TextBox.Text = CurrentText
            TextBox.TextColor3 = theme.Text
            TextBox.TextSize = 12
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.ClearTextOnFocus = iClearOnEnter
            TextBox.Parent = InputBoxBg

            TextBox.Focused:Connect(function()
                tween(InputStroke, { Color = theme.Accent }, 0.2)
            end)

            TextBox.FocusLost:Connect(function(enterPressed)
                tween(InputStroke, { Color = theme.Border }, 0.2)
                CurrentText = TextBox.Text
                if iNumeric then
                    local num = tonumber(CurrentText)
                    if num then
                        CurrentText = tostring(num)
                        TextBox.Text = CurrentText
                    else
                        CurrentText = ""
                        TextBox.Text = ""
                    end
                end
                if iFlag then
                    Slate.Flags[iFlag] = CurrentText
                    Window.Flags[iFlag] = CurrentText
                end
                task.spawn(iCallback, CurrentText)
            end)

            if iFlag then
                Slate.Flags[iFlag] = CurrentText
                Window.Flags[iFlag] = CurrentText
            end

            local InputObject = {
                Frame = Card,
                Name = iName,
                Set = function(val)
                    CurrentText = tostring(val)
                    TextBox.Text = CurrentText
                    if iFlag then
                        Slate.Flags[iFlag] = CurrentText
                        Window.Flags[iFlag] = CurrentText
                    end
                    task.spawn(iCallback, CurrentText)
                end,
                Get = function() return CurrentText end,
            }
            table.insert(Window.Elements, InputObject)
            return InputObject
        end

        -- KEYBIND
        function Tab:CreateKeybind(keybindProps)
            keybindProps = keybindProps or {}
            local kName = keybindProps.Name or keybindProps.name or "Keybind"
            local kDefault = keybindProps.Default or keybindProps.CurrentKeybind or keybindProps.key or Enum.KeyCode.E
            local kHold = keybindProps.HoldToInteract or false
            local kFlag = keybindProps.Flag or keybindProps.flag
            local kCallback = keybindProps.Callback or keybindProps.callback or function() end

            local CurrentKey = typeof(kDefault) == "EnumItem" and kDefault or Enum.KeyCode[tostring(kDefault)] or Enum.KeyCode.E
            local isBinding = false

            local Card = Instance.new("Frame")
            Card.Name = "Keybind_" .. kName
            Card.Size = UDim2.new(1, 0, 0, 40)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = kName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Name = "KeyButton"
            KeyBtn.Size = UDim2.new(0, 80, 0, 24)
            KeyBtn.Position = UDim2.new(1, -92, 0.5, -12)
            KeyBtn.BackgroundColor3 = theme.SidebarBg
            KeyBtn.BorderSizePixel = 0
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.Text = CurrentKey.Name
            KeyBtn.TextColor3 = theme.Accent
            KeyBtn.TextSize = 11
            KeyBtn.AutoButtonColor = false
            KeyBtn.Parent = Card

            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 6)
            KeyCorner.Parent = KeyBtn

            local KeyStroke = Instance.new("UIStroke")
            KeyStroke.Color = theme.Border
            KeyStroke.Thickness = 1
            KeyStroke.Parent = KeyBtn

            KeyBtn.MouseButton1Click:Connect(function()
                isBinding = true
                KeyBtn.Text = "..."
                tween(KeyStroke, { Color = theme.Accent }, 0.2)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if isBinding and not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode ~= Enum.KeyCode.Escape then
                            CurrentKey = input.KeyCode
                            KeyBtn.Text = CurrentKey.Name
                        else
                            KeyBtn.Text = CurrentKey.Name
                        end
                        isBinding = false
                        tween(KeyStroke, { Color = theme.Border }, 0.2)
                        if kFlag then
                            Slate.Flags[kFlag] = CurrentKey.Name
                            Window.Flags[kFlag] = CurrentKey.Name
                        end
                    end
                elseif not processed and input.KeyCode == CurrentKey then
                    if kHold then
                        task.spawn(kCallback, true)
                    else
                        task.spawn(kCallback)
                    end
                end
            end)

            if kHold then
                UserInputService.InputEnded:Connect(function(input, processed)
                    if not processed and input.KeyCode == CurrentKey then
                        task.spawn(kCallback, false)
                    end
                end)
            end

            if kFlag then
                Slate.Flags[kFlag] = CurrentKey.Name
                Window.Flags[kFlag] = CurrentKey.Name
            end

            local KeybindObject = {
                Frame = Card,
                Name = kName,
                Set = function(key)
                    CurrentKey = typeof(key) == "EnumItem" and key or Enum.KeyCode[tostring(key)]
                    KeyBtn.Text = CurrentKey.Name
                end,
                Get = function() return CurrentKey end,
            }
            table.insert(Window.Elements, KeybindObject)
            return KeybindObject
        end

        -- COLOR PICKER
        function Tab:CreateColorPicker(colorProps)
            colorProps = colorProps or {}
            local cName = colorProps.Name or colorProps.name or "Color Picker"
            local cDefault = colorProps.Default or colorProps.Color or Color3.fromRGB(255, 255, 255)
            local cFlag = colorProps.Flag or colorProps.flag
            local cCallback = colorProps.Callback or colorProps.callback or function() end

            local CurrentColor = cDefault

            local Card = Instance.new("Frame")
            Card.Name = "ColorPicker_" .. cName
            Card.Size = UDim2.new(1, 0, 0, 40)
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(0.6, 0, 1, 0)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = cName
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local Swatch = Instance.new("Frame")
            Swatch.Name = "Swatch"
            Swatch.Size = UDim2.new(0, 32, 0, 20)
            Swatch.Position = UDim2.new(1, -44, 0.5, -10)
            Swatch.BackgroundColor3 = CurrentColor
            Swatch.BorderSizePixel = 0
            Swatch.Parent = Card

            local SwatchCorner = Instance.new("UICorner")
            SwatchCorner.CornerRadius = UDim.new(0, 6)
            SwatchCorner.Parent = Swatch

            local SwatchStroke = Instance.new("UIStroke")
            SwatchStroke.Color = theme.Border
            SwatchStroke.Thickness = 1
            SwatchStroke.Parent = Swatch

            if cFlag then
                Slate.Flags[cFlag] = CurrentColor
                Window.Flags[cFlag] = CurrentColor
            end

            local ColorPickerObject = {
                Frame = Card,
                Name = cName,
                Set = function(col)
                    CurrentColor = col
                    Swatch.BackgroundColor3 = CurrentColor
                    if cFlag then
                        Slate.Flags[cFlag] = CurrentColor
                        Window.Flags[cFlag] = CurrentColor
                    end
                    task.spawn(cCallback, CurrentColor)
                end,
                Get = function() return CurrentColor end,
            }
            table.insert(Window.Elements, ColorPickerObject)
            return ColorPickerObject
        end

        -- PARAGRAPH
        function Tab:CreateParagraph(paraProps)
            paraProps = paraProps or {}
            local pTitle = paraProps.Title or paraProps.title or "Information"
            local pContent = paraProps.Content or paraProps.content or ""

            local Card = Instance.new("Frame")
            Card.Name = "Paragraph_" .. pTitle
            Card.BackgroundColor3 = theme.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = Tab.Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, theme.ElementCornerRadius)
            Corner.Parent = Card

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -24, 0, 20)
            Title.Position = UDim2.new(0, 12, 0, 8)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.Text = pTitle
            Title.TextColor3 = theme.Text
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Card

            local Content = Instance.new("TextLabel")
            Content.Name = "Content"
            Content.Size = UDim2.new(1, -24, 0, 0)
            Content.Position = UDim2.new(0, 12, 0, 30)
            Content.BackgroundTransparency = 1
            Content.Font = Enum.Font.Gotham
            Content.Text = pContent
            Content.TextColor3 = theme.TextMuted
            Content.TextSize = 12
            Content.TextWrapped = true
            Content.TextXAlignment = Enum.TextXAlignment.Left
            Content.TextYAlignment = Enum.TextYAlignment.Top
            Content.Parent = Card

            local textBounds = TextService:GetTextSize(
                pContent,
                12,
                Enum.Font.Gotham,
                Vector2.new(420, 1000)
            )
            Card.Size = UDim2.new(1, 0, 0, 38 + textBounds.Y + 12)

            return {
                Frame = Card,
                Set = function(newTitle, newContent)
                    Title.Text = newTitle or pTitle
                    Content.Text = newContent or pContent
                    local b = TextService:GetTextSize(Content.Text, 12, Enum.Font.Gotham, Vector2.new(420, 1000))
                    Card.Size = UDim2.new(1, 0, 0, 38 + b.Y + 12)
                end,
            }
        end

        return Tab
    end

    table.insert(Slate.Windows, Window)
    return Window
end

-- ==============================================================================
-- KEY SYSTEM PROMPT
-- ==============================================================================

function Slate:CreateKeyPrompt(keyConfig)
    keyConfig = keyConfig or {}
    local Title = keyConfig.Title or "Slate Verification"
    local Subtitle = keyConfig.Subtitle or "Enter your license key to continue"
    local KeyURL = keyConfig.KeyURL or keyConfig.keyUrl or ""
    local DiscordInvite = keyConfig.Discord or keyConfig.discord or ""
    local ValidateKey = keyConfig.Key or keyConfig.key or keyConfig.Validate or function(k) return true end
    local OnSuccess = keyConfig.Callback or function() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SlateKeyPrompt"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 10000
    protectGui(ScreenGui)
    ScreenGui.Parent = getGuiContainer()

    local theme = Slate:GetTheme()

    local Modal = Instance.new("Frame")
    Modal.Name = "Modal"
    Modal.Size = UDim2.new(0, 380, 0, 240)
    Modal.Position = UDim2.new(0.5, -190, 0.5, -120)
    Modal.BackgroundColor3 = theme.WindowBg
    Modal.BorderSizePixel = 0
    Modal.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Modal

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = theme.Border
    Stroke.Thickness = 1.2
    Stroke.Parent = Modal

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -32, 0, 24)
    TitleLabel.Position = UDim2.new(0, 16, 0, 16)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = Modal

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -32, 0, 18)
    SubLabel.Position = UDim2.new(0, 16, 0, 42)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.Text = Subtitle
    SubLabel.TextColor3 = theme.TextMuted
    SubLabel.TextSize = 12
    SubLabel.TextXAlignment = Enum.TextXAlignment.Center
    SubLabel.Parent = Modal

    local KeyInputBg = Instance.new("Frame")
    KeyInputBg.Size = UDim2.new(1, -40, 0, 36)
    KeyInputBg.Position = UDim2.new(0, 20, 0, 75)
    KeyInputBg.BackgroundColor3 = theme.CardBg
    KeyInputBg.BorderSizePixel = 0
    KeyInputBg.Parent = Modal

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInputBg

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = theme.Border
    InputStroke.Thickness = 1
    InputStroke.Parent = KeyInputBg

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -16, 1, 0)
    KeyBox.Position = UDim2.new(0, 8, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.PlaceholderText = "Paste key here..."
    KeyBox.PlaceholderColor3 = theme.TextDim
    KeyBox.Text = ""
    KeyBox.TextColor3 = theme.Text
    KeyBox.TextSize = 12
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = KeyInputBg

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 36)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 125)
    SubmitBtn.BackgroundColor3 = theme.Accent
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = theme.AccentText
    SubmitBtn.TextSize = 13
    SubmitBtn.AutoButtonColor = false
    SubmitBtn.Parent = Modal

    local SubBtnCorner = Instance.new("UICorner")
    SubBtnCorner.CornerRadius = UDim.new(0, 8)
    SubBtnCorner.Parent = SubmitBtn

    SubmitBtn.MouseButton1Click:Connect(function()
        local entered = KeyBox.Text
        local valid = false
        if type(ValidateKey) == "function" then
            valid = ValidateKey(entered)
        elseif type(ValidateKey) == "string" then
            valid = (entered == ValidateKey)
        end

        if valid then
            Slate:Notify({ Title = "Success", Content = "Key validated successfully!", Duration = 3 })
            ScreenGui:Destroy()
            task.spawn(OnSuccess)
        else
            Slate:Notify({ Title = "Error", Content = "Invalid key entered. Please try again.", Duration = 4 })
            tween(InputStroke, { Color = Color3.fromRGB(220, 80, 80) }, 0.2)
        end
    end)

    if KeyURL ~= "" or DiscordInvite ~= "" then
        local ActionsFrame = Instance.new("Frame")
        ActionsFrame.Size = UDim2.new(1, -40, 0, 30)
        ActionsFrame.Position = UDim2.new(0, 20, 0, 175)
        ActionsFrame.BackgroundTransparency = 1
        ActionsFrame.Parent = Modal

        if KeyURL ~= "" then
            local GetKeyBtn = Instance.new("TextButton")
            GetKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
            GetKeyBtn.BackgroundColor3 = theme.CardBg
            GetKeyBtn.BorderSizePixel = 0
            GetKeyBtn.Font = Enum.Font.GothamMedium
            GetKeyBtn.Text = "Get Key URL"
            GetKeyBtn.TextColor3 = theme.TextMuted
            GetKeyBtn.TextSize = 11
            GetKeyBtn.Parent = ActionsFrame

            local gkCorner = Instance.new("UICorner")
            gkCorner.CornerRadius = UDim.new(0, 6)
            gkCorner.Parent = GetKeyBtn

            GetKeyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(KeyURL)
                    Slate:Notify({ Title = "Copied", Content = "Key link copied to clipboard!", Duration = 3 })
                end
            end)
        end

        if DiscordInvite ~= "" then
            local DiscBtn = Instance.new("TextButton")
            DiscBtn.Size = UDim2.new(0.48, 0, 1, 0)
            DiscBtn.Position = UDim2.new(0.52, 0, 0, 0)
            DiscBtn.BackgroundColor3 = theme.CardBg
            DiscBtn.BorderSizePixel = 0
            DiscBtn.Font = Enum.Font.GothamMedium
            DiscBtn.Text = "Join Discord"
            DiscBtn.TextColor3 = theme.TextMuted
            DiscBtn.TextSize = 11
            DiscBtn.Parent = ActionsFrame

            local dcCorner = Instance.new("UICorner")
            dcCorner.CornerRadius = UDim.new(0, 6)
            dcCorner.Parent = DiscBtn

            DiscBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(DiscordInvite)
                    Slate:Notify({ Title = "Copied", Content = "Discord invite copied to clipboard!", Duration = 3 })
                end
            end)
        end
    end
end

return Slate
