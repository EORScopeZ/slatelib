-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.utility.variables)
local image = require(script.utility.image)
local locale = require(script.utility.locale)
local constants = require(script.utility.constants)
local types = require(script.types)

-- re-export public types so consumers can annotate against Rayfield.Window etc
export type Theme = types.Theme
export type Translator = types.Translator
export type Translations = types.Translations
export type WindowConfiguration = types.WindowConfiguration

export type WindowProps = types.WindowProps
export type TabProps = types.TabProps
export type TagProps = types.TagProps
export type SectionProps = types.SectionProps
export type GroupProps = types.GroupProps
export type ButtonProps = types.ButtonProps
export type ToggleProps = types.ToggleProps
export type SliderProps = types.SliderProps
export type DropdownProps = types.DropdownProps
export type InputProps = types.InputProps
export type KeybindProps = types.KeybindProps
export type ColorPickerProps = types.ColorPickerProps
export type StatProps = types.StatProps
export type ProgressProps = types.ProgressProps
export type ConsoleProps = types.ConsoleProps
export type TextProps = types.TextProps
export type DividerProps = types.DividerProps
export type NotifyProps = types.NotifyProps
export type ToastProps = types.ToastProps
export type PopupBox = types.PopupBox
export type PopupOption = types.PopupOption
export type PopupProps = types.PopupProps

export type Moveable = types.Moveable
export type Lockable = types.Lockable
export type Window = types.Window
export type Tab = types.Tab
export type Group = types.Group
export type Button = types.Button
export type Toggle = types.Toggle
export type Slider = types.Slider
export type Dropdown = types.Dropdown
export type Input = types.Input
export type Keybind = types.Keybind
export type ColorPicker = types.ColorPicker
export type Stat = types.Stat
export type Progress = types.Progress
export type Console = types.Console
export type Section = types.Section
export type TabSection = types.TabSection
export type Text = types.Text
export type Divider = types.Divider
export type Tag = types.Tag
export type Popup = types.Popup
export type Slate = types.Rayfield
export type Rayfield = types.Rayfield

-- the components are untyped luau, so this is where the window module meets the public contract
type WindowModule = { new: (types.WindowProps) -> types.Window }

local slate = {} :: Slate

local function createBanner()
    local ui = Instance.new("ScreenGui")
    ui.Name = variables.httpService:GenerateGUID(false)
    ui.ClipToDeviceSafeArea = false
    ui.DisplayOrder = constants.displayOrder.banner
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false
    ui.Enabled = true
    ui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
    ui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.Parent = variables.guiContainer

    local banner = Instance.new("ImageLabel")
    banner.Name = "Banner"
    banner.AnchorPoint = Vector2.new(0.5, 0.5)
    banner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    banner.BackgroundTransparency = 1
    banner.BorderColor3 = Color3.fromRGB(0, 0, 0)
    banner.BorderSizePixel = 0
    banner.Image = image.resolve(constants.icons.banner)
    banner.Position = UDim2.fromScale(0.5, 0.5)
    banner.Size = UDim2.fromOffset(262, 60)
    banner.Parent = ui

    return ui
end

function slate:CreateWindow(properties: types.WindowProps): types.Window
    local banner = createBanner()
    local window: types.Window? -- forward declared so the settle callback below can reach it
    -- preload can settle before the window is built; hold the notify until it is
    local queuedNotify: (() -> ())?

    if variables.secureMode then
        -- cache icons locally so secureMode doesnt leak asset ids. non-blocking: whats already on
        -- disk applies now, the rest download in the background and rebind once ready. if any never
        -- cache, tell the dev once - on screen only, secure mode stays off the console
        image.preload(function(failed)
            if failed <= 0 then
                return
            end
            local function notify()
                if not window or window.unloaded then
                    return
                end
                window:Notify({
                    title = locale.resolve("Secure mode"),
                    content = if failed == 1
                        then locale.resolve("An asset couldn't be cached and won't appear.")
                        else locale.resolve("Some assets couldn't be cached and won't appear."),
                })
            end
            if window then
                notify()
            else
                queuedNotify = notify
            end
        end)
    end

    -- the banner is only torn down once the window is up, so a throw in here (bad props) would
    -- otherwise strand it in the gui container for the rest of the session
    local made, result = pcall(function()
        return (require(script.components.window) :: WindowModule).new(properties)
    end)
    if not made then
        banner:Destroy()
        error(result, 0)
    end

    local built = result :: types.Window
    window = built

    if queuedNotify then
        task.spawn(queuedNotify)
        queuedNotify = nil
    end

    if variables.secureMode then
        -- secure mode renders the fallback up front (variables.brandFont), then downloads the real
        -- brand faces off the main thread and swaps them in once ready, so startup never blocks
        task.spawn(function()
            local body = variables.fontManager:loadFont(constants.fontAsset, Enum.FontWeight.Medium)
            local title = variables.fontManager:loadFont(constants.fontAsset, Enum.FontWeight.SemiBold)
            -- the download can outlast the window; dont swap into one thats been unloaded
            if
                not built.unloaded
                and body
                and title
                and body ~= variables.fallbackFont
                and title ~= variables.fallbackFont
            then
                built:ChangeTheme({ Font = body, TitleFont = title })
            end
        end)
    end

    task.spawn(function()
        task.wait(0.5)

        banner:Destroy()

        task.wait(0.5)
        -- the window can be unloaded inside this delay; showing it then would fire
        -- saved-config callbacks and build toasts on destroyed instances
        if not built.unloaded then
            built:Show()
        end
    end)

    return built
end

return slate

end)() end,
    [3] = function()local wax,script,require=ImportGlobals(3)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Action = {}
Action.__index = Action
Action.__type = "Action"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local log = require(utility.log)
local hapticEngine = require(utility.HapticEngine)

function Action.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        name = properties.name or properties.Name or "Action",
        icon = assert(properties.icon or properties.Icon, "Missing argument (Icon expected)"),
        callback = assert(properties.callback or properties.Callback, "Missing argument (Function expected)"),
        linkedTab = properties.linkedTab or properties.LinkedTab,
    }, Action)

    self.action = self.window:Create("Frame", {
        Name = self.name,
        BorderSizePixel = 0,

        LayoutOrder = -(properties.order or 0),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,

        Parent = self.window.actionContainer,
    })

    self.iconLabel = self.window:Create("ImageLabel", {
        -- Configurables
        Image = self.icon,

        Size = UDim2.fromOffset(20, 20),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,

        -- Animation
        ImageTransparency = 1, -- In = 0.6

        Parent = self.action,
    }, { ImageColor3 = "ActionColor" })

    self.interact = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextTransparency = 1,

        Parent = self.action,
    })

    -- drop the icon back to its resting brightness, unless this action opens a tab that's
    -- currently selected (the settings cog stays lit while its page is open), or it reports
    -- itself lit some other way (the search action while the field is open)
    local function settleIcon()
        if not self.window:_settled() then
            return -- mid reveal/hide: those repaint the icons themselves, dont fight them
        end
        if self.linkedTab and self.window.selectedTab == self.linkedTab then
            return
        end
        if self.isLit and self:isLit() then
            return
        end
        variables.tweenService
            :Create(
                self.iconLabel,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { ImageTransparency = 0.6 }
            )
            :Play()
    end

    self.window:Connect(self.interact.MouseButton1Click, function()
        hapticEngine.click()
        task.spawn(function()
            local success, result = pcall(self.callback)
            if not success then
                log.warn(
                    `Rayfield encountered an error, with the callback for a {self.__type} component named '{self.name}':`
                )
                log.print(result)
            end
            -- undo the hover brighten now (the callback has run, so selectedTab is up to date),
            -- otherwise the icon stays lit until the mouse happens to move off it
            settleIcon()
        end)
    end)

    self.window:Connect(self.interact.MouseEnter, function()
        if not self.window:_interactive() then
            return -- window still revealing/hiding: dont light up mid-animation
        end
        variables.tweenService
            :Create(
                self.iconLabel,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { ImageTransparency = 0.2 }
            )
            :Play()
    end)

    self.window:Connect(self.interact.MouseLeave, settleIcon)

    return self
end

return Action

end)() end,
    [4] = function()local wax,script,require=ImportGlobals(4)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Button = {}
Button.__index = Button
Button.__type = "Button"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

function Button.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Button",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        compact = tab.compact or false, -- true when the host is a Row

        callback = properties.callback or properties.Callback or function() end,
    }, Button)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end

    -- Descriptions don't belong on a compact row element.
    if self.description and not self.compact then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    return self
end

-- callback + red error-flash, shared by both layouts
function Button:_runCallback()
    self.window:_runGuarded(self, self.callback)
end

-- full-width: title/icon left, width-bounce on press
function Button:_buildFull()
    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 43),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)

    self.container = self.window:Create("Frame", {
        BorderSizePixel = 0,

        Parent = self.main,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
    })

    self.containerLayout = self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animations
            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(250, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.interact = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextTransparency = 1,

        Parent = self.main,
    })

    self.window:_wireElementHover(self)

    -- press: ghost the stroke + squeeze the width around the callback
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }
            )
            :Play()
        variables.tweenService
            :Create(
                self.main,
                TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { Size = UDim2.new(1, -26, 0, 43) }
            )
            :Play()

        self:_runCallback()

        task.wait(0.11)

        variables.tweenService
            :Create(
                self.main,
                TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { Size = UDim2.new(1, -20, 0, 43) }
            )
            :Play()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = self.window.theme.ElementStrokeTransparency }
            )
            :Play()
    end)
end

-- compact (row): content-sized, centred icon+title, no width-bounce
function Button:_buildCompact()
    local window = self.window

    self.main, self.stroke, self.interact = window:_buildCompactRow(self.tab, self.name)
    self.hoverOverlay = self.interact

    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),

        Parent = self.interact,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),

        Parent = self.interact,
    })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,

            ImageTransparency = 1, -- In = 0

            Parent = self.interact,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,

        TextTransparency = 1, -- In = 0

        Parent = self.interact,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- grows to its text, shrinks + ellipsizes when the row's tight
    window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    self.window:_wireElementHover(self)

    -- press: ghost the stroke around the callback
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }
            )
            :Play()

        self:_runCallback()

        task.wait(0.11)

        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = self.window.theme.ElementStrokeTransparency }
            )
            :Play()
    end)
end

function Button:_setShown(shown, animate)
    if shown then
        self.window:_revealCommon(self, animate)
    else
        self.window:_hideCommon(self, animate)
    end
end

-- Room the compact button needs before its label would clip: side padding + icon
-- (and its gap) if shown + the title text. A horizontal group uses this to wrap.
function Button:_minWidth()
    local w = 32 -- interact padding, 16 each side
    if self.icon then
        w += 22 -- 16 icon + 6 gap to title
    end
    -- measure what actually renders: the title shows the translated string
    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))
    return w
end

moveable(Button)
lockable(Button)

return Button

end)() end,
    [5] = function()local wax,script,require=ImportGlobals(5)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Window furniture: the collapsed "Show" face main wears while hidden (window.collapsed*
-- fields), plus the first-open new-user check. The welcome greeting itself is just a toast now.

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local filesystem = require(utility.filesystem)
local constants = require(utility.constants)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

local chrome = {}

-- How far the cursor may travel before a press on the collapsed pill counts as a drag rather
-- than a click. Small enough that a deliberate tap always opens, big enough to survive a
-- shaky finger on a phone.
local dragThreshold = 5

-- The face main wears once collapsed: an icon + "name"/"Tap to show", drawn straight onto
-- the window frame itself. main already carries the pill's background (its own WindowColor
-- gradient reads the same as the old standalone pill), so shrinking main IS becoming the
-- pill - nothing to hand off to, nothing to swap.
function chrome.buildCollapsedFace(window)
    local iconOnly = window.showIconOnly

    window.collapsedIcon = window:Create("ImageLabel", {
        Name = "CollapsedIcon",
        AnchorPoint = if iconOnly then Vector2.new(0.5, 0.5) else Vector2.new(0, 0.5),
        Position = if iconOnly then UDim2.fromScale(0.5, 0.5) else UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        -- raw value: Create routes Image through image.resolve (concat would double the prefix)
        Image = window.showIcon,
        ZIndex = constants.zIndex.restoreContent,

        ImageTransparency = 1, -- shown = 0, set by chrome.setCollapsedShown

        Parent = window.main,
    }, { ImageColor3 = "TitlingColor" })

    window:Create("UICorner", {
        Parent = window.collapsedIcon,
    }, { CornerRadius = "PillCornerRadius" })

    local textContainer = window:Create("Frame", {
        Name = "CollapsedText",
        Visible = not iconOnly,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 50, 0.5, 0),
        Size = UDim2.new(1, -60, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = constants.zIndex.restoreContent,

        Parent = window.main,
    })

    window:Create("UIListLayout", {
        Padding = UDim.new(0, 1),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = textContainer,
    })

    window.collapsedTitle = window:Create("TextLabel", {
        Name = "Title",
        Text = window.showName,
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        FontFace = variables.brandFont(Enum.FontWeight.Medium),
        RichText = true,
        TextSize = 16,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = constants.zIndex.restoreContent,

        TextTransparency = 1, -- shown = 0, set by chrome.setCollapsedShown

        Parent = textContainer,
    }, { TextColor3 = "TitlingColor" })

    window.collapsedSubtitle = window:Create("TextLabel", {
        Name = "Subtitle",
        Text = locale.t("Tap to show"),
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        FontFace = variables.brandFont(Enum.FontWeight.Medium),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.restoreContent,

        TextTransparency = 1, -- shown = 0.5, set by chrome.setCollapsedShown

        Parent = textContainer,
    }, { TextColor3 = "TitlingColor" })

    -- covers the whole window but only takes clicks while collapsed - Window:Hide/Show flip
    -- Visible as the morph starts/settles so it can never eat a click mid-animation or while
    -- the window is fully open. Active alone doesn't stop a GuiButton from still receiving
    -- clicks here, so Visible is what actually keeps it out of hit-testing.
    window.collapsedInteract = window:Create("TextButton", {
        Name = "CollapsedInteract",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextTransparency = 1,
        Visible = false,
        ZIndex = constants.zIndex.restoreInteract,

        Parent = window.main,
    })

    chrome.bindCollapsedDrag(window)
end

-- Drag the collapsed pill around. A press only counts as a click if the cursor barely moved -
-- past dragThreshold it was a drag, and the window stays shut.
function chrome.bindCollapsedDrag(window)
    local uis = variables.userInputService
    local dragging, moved = false, false
    local grabOffset, grabMouse = Vector2.zero, Vector2.zero

    -- main.Position sits in a space shifted from AbsolutePosition by the gui inset, even though
    -- the ScreenGui ignores it - add it back or the pill jumps on the first move
    local function insetOffset()
        if window.screenGui and window.screenGui.IgnoreGuiInset then
            return variables.guiService:GetGuiInset()
        end
        return Vector2.zero
    end

    window:Connect(window.collapsedInteract.InputBegan, function(input, processed)
        if processed or not window.hidden or window.animating then
            return
        end
        local inputType = input.UserInputType.Name
        if inputType ~= "MouseButton1" and inputType ~= "Touch" then
            return
        end

        dragging, moved = true, false
        grabMouse = uis:GetMouseLocation()
        grabOffset = window.main.AbsolutePosition + window.main.AbsoluteSize * window.main.AnchorPoint - grabMouse
    end)

    window:Connect(uis.InputEnded, function(input)
        local inputType = input.UserInputType.Name
        if inputType ~= "MouseButton1" and inputType ~= "Touch" then
            return
        end
        if not dragging then
            return
        end
        dragging = false

        if moved then
            window._collapsedPosition = window.main.Position -- stay where it was put
            return
        end

        hapticEngine.click()
        window:ToggleHide()
    end)

    -- a release that never arrives (alt-tab with the button down) would otherwise leave the
    -- pill stuck to the cursor
    window:Connect(uis.WindowFocusReleased, function()
        dragging = false
    end)

    window:Connect(variables.runService.RenderStepped, function()
        if not dragging then
            return
        end
        if not window.hidden or window.animating then
            dragging = false -- the grab went stale under us
            return
        end

        local mouse = uis:GetMouseLocation()
        if not moved and (mouse - grabMouse).Magnitude < dragThreshold then
            return -- still inside the slop: it might yet be a click
        end
        moved = true

        local target = mouse + grabOffset + insetOffset()
        window.main.Position = UDim2.fromOffset(target.X, target.Y)
    end)
end

function chrome.isNewUser()
    local localPlayer = variables.localPlayer
    if not localPlayer then
        return false
    end

    -- No filesystem available - just show the banner every launch.
    if typeof(filesystem.isfile) ~= "function" or typeof(filesystem.writefile) ~= "function" then
        return true
    end

    local path = variables.fileSystemManager:getPath("lastuser.txt")
    local currentId = tostring(localPlayer.UserId)
    local isNew = true

    pcall(function()
        if filesystem.isfile(path) then
            isNew = filesystem.readfile(path) ~= currentId
        end
    end)

    pcall(function()
        filesystem.writefile(path, currentId)
    end)

    return isNew
end

-- Fade the collapsed face (icon + labels) in or out as main morphs into/out of the pill.
-- When tweenInfo is nil the values snap instantly.
function chrome.setCollapsedShown(window, shown, tweenInfo)
    local targets = {
        [window.collapsedIcon] = { ImageTransparency = if shown then 0 else 1 },
    }

    if not window.showIconOnly then
        targets[window.collapsedTitle] = { TextTransparency = if shown then 0 else 1 }
        targets[window.collapsedSubtitle] = { TextTransparency = if shown then 0.5 else 1 }
    end

    for instance, props in targets do
        if tweenInfo then
            variables.tweenService:Create(instance, tweenInfo, props):Play()
        else
            for property, value in props do
                instance[property] = value
            end
        end
    end
end

return chrome

end)() end,
    [6] = function()local wax,script,require=ImportGlobals(6)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local ColorPicker = {}
ColorPicker.__index = ColorPicker
ColorPicker.__type = "ColorPicker"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local constants = require(utility.constants)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

-- Full hue wheel top (red) to bottom (back to red) for the vertical hue bar.
local hueSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
})

-- Layout. The card is one frame that grows from a header row into the full picker; every
-- offset below is measured from the card's own top-left, no inner padding frame.
local headerHeight = 41
local contentY = 52 -- picker controls start just under the header
local mapSize = Vector2.new(150, 120)
local hueX = 184 -- map left (20) + 150 + 14 gap
local hueWidth = 10
-- big gap so the two handles (which overhang their bars by ~6px each, more when held) never touch
local alphaX = 214 -- hue right (194) + 20 gap
local alphaWidth = 10
local rightX = 240 -- alpha right (224) + 16 gap: left edge of the wide preview/field column
local alphaFieldWidth = 62 -- the alpha % input, sits right of the hex field
local fieldGap = 8
-- below this element width the preview + fields cant sit beside the map/bars without getting
-- too narrow, so they reflow to a full-width row under the map (see _applyLayout)
local narrowWidth = 400

-- Per-mode geometry for the bits that move between layouts. map + hue + alpha stay top-left in
-- both. "open" rects are where the preview morphs to and where the hex + alpha fields sit;
-- "height" is the card's open height. The preview morphs between its closed pill and this rect.
local layoutSpec = {
    wide = {
        height = 190,
        previewPos = UDim2.new(1, -20, 0, contentY + 39),
        previewSize = UDim2.new(1, -(rightX + 20), 0, 78),
        hexPos = UDim2.new(0, rightX, 0, contentY + 90),
        hexSize = UDim2.new(1, -(rightX + 20 + alphaFieldWidth + fieldGap), 0, 30),
        alphaFieldPos = UDim2.new(1, -(20 + alphaFieldWidth), 0, contentY + 90),
        alphaFieldSize = UDim2.new(0, alphaFieldWidth, 0, 30),
    },
    narrow = {
        height = 296,
        previewPos = UDim2.new(1, -20, 0, contentY + mapSize.Y + 40),
        previewSize = UDim2.new(1, -40, 0, 56),
        hexPos = UDim2.new(0, 20, 0, contentY + mapSize.Y + 78),
        hexSize = UDim2.new(1, -(40 + alphaFieldWidth + fieldGap), 0, 30),
        alphaFieldPos = UDim2.new(1, -(20 + alphaFieldWidth), 0, contentY + mapSize.Y + 78),
        alphaFieldSize = UDim2.new(0, alphaFieldWidth, 0, 30),
    },
}

-- The preview is a single frame that morphs between the closed header pill and the mode's open
-- rect. AnchorPoint stays (1, 0.5) so only pos/size tween.
local previewClosedPos = UDim2.new(1, -16, 0, headerHeight / 2)
local previewClosedSize = UDim2.fromOffset(40, 22)

local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local followInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
-- short enough to track the mouse tightly, long enough that the cursor glides instead of
-- snapping. this is the "animated" feel a hard snap lost.
local dragInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local heldInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function clamp01(n)
    return math.clamp(n, 0, 1)
end

local function clampByte(n)
    return math.clamp(math.round(n), 0, 255)
end

-- named colours accepted by the smart field
local namedColors = {
    black = Color3.fromRGB(0, 0, 0),
    white = Color3.fromRGB(255, 255, 255),
    red = Color3.fromRGB(255, 0, 0),
    green = Color3.fromRGB(0, 255, 0),
    blue = Color3.fromRGB(0, 0, 255),
    yellow = Color3.fromRGB(255, 255, 0),
    cyan = Color3.fromRGB(0, 255, 255),
    magenta = Color3.fromRGB(255, 0, 255),
    orange = Color3.fromRGB(255, 165, 0),
    purple = Color3.fromRGB(128, 0, 128),
    pink = Color3.fromRGB(255, 105, 180),
    brown = Color3.fromRGB(139, 69, 19),
    gray = Color3.fromRGB(128, 128, 128),
    grey = Color3.fromRGB(128, 128, 128),
}

-- hsl -> Color3 (h/s/l all 0..1). hsv has a built-in, hsl doesnt.
local function hslToColor(h, s, l)
    if s <= 0 then
        return Color3.new(l, l, l)
    end
    local function hue2(p, q, t)
        t = t % 1
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        elseif t < 1 / 2 then
            return q
        elseif t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end
    local q = if l < 0.5 then l * (1 + s) else l + s - l * s
    local p = 2 * l - q
    return Color3.new(hue2(p, q, h + 1 / 3), hue2(p, q, h), hue2(p, q, h - 1 / 3))
end

-- pull every number (ints or floats) out of a string, in order
local function numbersIn(s)
    local out = {}
    for n in s:gmatch("[%d%.]+") do
        table.insert(out, tonumber(n))
    end
    return out
end

-- Smart, forgiving colour parse. Handles hex (#fff, ffffff, 0xffffff), rgb (rgb(...),
-- "255,0,0", "255 0 0"), hsv/hsb, hsl, plain 0..1 float triplets, and named colours.
-- Returns a Color3 or nil.
local function parseColor(input)
    if typeof(input) ~= "string" then
        return nil
    end
    local s = (input:lower():match("^%s*(.-)%s*$")) or ""
    if s == "" then
        return nil
    end

    if namedColors[s] then
        return namedColors[s]
    end

    local model = s:match("^(%a+)")
    local nums = numbersIn(s)

    if (model == "hsv" or model == "hsb") and #nums >= 3 then
        local h = (nums[1] % 360) / 360
        local sat = if nums[2] > 1 then nums[2] / 100 else nums[2]
        local v = if nums[3] > 1 then nums[3] / 100 else nums[3]
        return Color3.fromHSV(h, clamp01(sat), clamp01(v))
    end

    if model == "hsl" and #nums >= 3 then
        local h = (nums[1] % 360) / 360
        local sat = if nums[2] > 1 then nums[2] / 100 else nums[2]
        local l = if nums[3] > 1 then nums[3] / 100 else nums[3]
        return hslToColor(h, clamp01(sat), clamp01(l))
    end

    if (model == "rgb" or model == "rgba") and #nums >= 3 then
        return Color3.fromRGB(clampByte(nums[1]), clampByte(nums[2]), clampByte(nums[3]))
    end

    -- hex: with or without # / 0x, 3 or 6 digits
    local hex = s:match("^#?(%x%x%x%x%x%x)$") or s:match("^#?(%x%x%x)$") or s:match("^0x(%x%x%x%x%x%x)$")
    if hex then
        local ok, color = pcall(Color3.fromHex, hex)
        if ok then
            return color
        end
    end

    -- bare triplet, no model word: 0..1 floats read as raw channels, otherwise 0..255
    if #nums >= 3 and not model then
        if nums[1] <= 1 and nums[2] <= 1 and nums[3] <= 1 then
            return Color3.new(clamp01(nums[1]), clamp01(nums[2]), clamp01(nums[3]))
        end
        return Color3.fromRGB(clampByte(nums[1]), clampByte(nums[2]), clampByte(nums[3]))
    end

    return nil
end

-- accept a Color3, or anything parseColor understands, or fall back to the given default
local function coerceColor(value, fallback)
    if typeof(value) == "Color3" then
        return value
    end
    if typeof(value) == "string" then
        return parseColor(value) or fallback
    end
    return fallback
end

function ColorPicker.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Color Picker",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,

        callback = properties.callback or properties.Callback or function() end,

        _isOpen = false,
    }, ColorPicker)

    self.value = coerceColor(
        properties.color or properties.Color or properties.value or properties.Value or properties.default,
        Color3.fromRGB(255, 255, 255)
    )

    -- hue is kept alongside sat/val so dragging into a grey (where hue is undefined) doesnt
    -- lose the colour you were on, same as the classic pickers
    self.hue, self.sat, self.val = self.value:ToHSV()

    -- alpha (0..1). the callback gets it as a second arg; opacity of the preview + alpha slider
    local a = properties.alpha or properties.Alpha
    self.alpha = if type(a) == "number" then clamp01(a) else 1

    self.flag = properties.flag
        or properties.Flag
        or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)
    self.window:_registerControl(self)

    -- One card that grows from the header row into the full picker. No clip: the controls
    -- below the header just sit fully transparent while collapsed, so nothing shows through.
    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, headerHeight),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)

    self:_buildHeader()
    self:_buildPicker()

    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        if self._isOpen then
            self:_close()
        else
            self:_open()
        end
    end)

    -- Hover: brighten stroke + title + overlay, but not while open (the picker's the focus then)
    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if self._isOpen or not self.window:_interactive() then
            return
        end
        local theme = self.window.theme
        variables.tweenService
            :Create(self.stroke, fadeInfo, {
                Transparency = theme.ElementStrokeHoverTransparency,
                Color = theme.ElementStrokeHover,
            })
            :Play()
        variables.tweenService:Create(self.title, fadeInfo, { TextColor3 = theme.ElementTextHoverColor }):Play()
        variables.tweenService:Create(self.hoverOverlay, fadeInfo, { BackgroundTransparency = 0.97 }):Play()
    end)

    self.window:ConnectFor(self, self.main.MouseLeave, function()
        local theme = self.window.theme
        variables.tweenService
            :Create(
                self.stroke,
                fadeInfo,
                { Transparency = theme.ElementStrokeTransparency, Color = theme.ElementStroke }
            )
            :Play()
        variables.tweenService:Create(self.title, fadeInfo, { TextColor3 = theme.ContentColor }):Play()
        variables.tweenService:Create(self.hoverOverlay, fadeInfo, { BackgroundTransparency = 1 }):Play()
    end)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    -- establish the picker's hidden state once, from the single visibility list
    self:_applyPickerVisibility(false, false)
    self:_setControlsVisible(false) -- and keep the collapsed controls out of input entirely

    -- pick wide/narrow from the real width and keep it in sync as that width changes (the
    -- column resolves a frame after we build, and the window can be resized). Ignore the
    -- transient widths swept while the window animates/hides, same as the slider.
    self.window:ConnectFor(self, self.main:GetPropertyChangedSignal("AbsoluteSize"), function()
        -- hasShownOnce: the initial layout pass happens while the window is still hidden,
        -- and blocking it would freeze the width-0 layout mode (same fix as the slider)
        if self.window.animating or (self.window.hidden and self.window.hasShownOnce) then
            return
        end
        self:_applyLayout()
    end)
    self:_applyLayout()

    self:_render("instant")

    return self
end

-- Header row: icon + title on the left, the morphing colour preview on the right.
function ColorPicker:_buildHeader()
    self.container = self.window:Create("Frame", {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0, headerHeight / 2),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,

            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- The colour preview. Starts as the header pill; on open it morphs (pos + size) into the
    -- big swatch. No stroke - it reads as pure colour.
    self.preview = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = previewClosedPos,
        Size = previewClosedSize,
        BackgroundColor3 = self.value,
        BorderSizePixel = 0,
        ZIndex = 3,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.preview,
    })

    -- Soft glow behind the preview, tinted to the colour. Its transparency tracks alpha
    -- (0.6 solid -> 1 fully clear). One shadow follows the preview through the mini<->full morph.
    self.previewShadow = self.window:CreateGlow(self.preview, self.value, 20, 1)

    -- Shown centred on the (open) preview once alpha reaches 0, since the swatch is fully clear
    -- then: an icon + "Invisible" so it doesnt just look empty.
    self.invisibleGroup = self.window:Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.preview,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.invisibleGroup,
    })

    self.invisibleIcon = self.window:Create("ImageLabel", {
        Image = constants.icons.colorpicker,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        ImageTransparency = 1, -- fades in near alpha 0

        Parent = self.invisibleGroup,
    }, { ImageColor3 = "ContentColor" })

    self.invisibleText = self.window:Create("TextLabel", {
        Text = locale.t("Invisible"),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        LayoutOrder = 1,
        ZIndex = 5,

        TextTransparency = 1, -- fades in near alpha 0

        Parent = self.invisibleGroup,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- Covers only the header, so drags on the map/hue below dont toggle the card.
    self.interact = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 10,

        Parent = self.main,
    })
end

-- Sat/val field, built from gradients (no image asset): a hue-tinted Frame with a white
-- left->right saturation gradient and a black top->bottom value gradient layered on top. Each
-- layer rounds its own corners so nothing needs clipping (which would clip the cursor).
function ColorPicker:_buildMap()
    self.map = self.window:Create("Frame", {
        Position = UDim2.fromOffset(20, contentY),
        Size = UDim2.fromOffset(mapSize.X, mapSize.Y),
        BackgroundColor3 = Color3.fromHSV(self.hue, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.main,
    })

    self.window:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.map })

    self.mapStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- Open = 0.9

        Parent = self.map,
    })

    -- saturation: white on the left, fading to the bare hue on the right
    self.satOverlay = self.window:Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 3,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.map,
    })
    self.window:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.satOverlay })
    self.window:Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.satOverlay,
    })

    -- value: transparent at the top, fading to black at the bottom
    self.valOverlay = self.window:Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 4,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.map,
    })
    self.window:Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.valOverlay })
    self.window:Create("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Parent = self.valOverlay,
    })
end

-- The picker guts: sat/val map, hue bar and an editable hex field, all sitting under the
-- header. They're fully transparent while collapsed and fade in on open.
function ColorPicker:_buildPicker()
    self:_buildMap()

    self.satCursor = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 6,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.map,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.satCursor,
    })

    self.satCursorStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1, -- Open = 0 (solid white)

        Parent = self.satCursor,
    })

    self.mapInteract = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 7,

        Parent = self.map,
    })

    -- Hue bar: vertical spectrum with a round handle tracking self.hue.
    self.hueBar = self.window:Create("Frame", {
        Position = UDim2.fromOffset(hueX, contentY),
        Size = UDim2.fromOffset(hueWidth, mapSize.Y),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.main,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.hueBar,
    })

    self.window:Create("UIGradient", {
        Color = hueSequence,
        Rotation = 90,

        Parent = self.hueBar,
    })

    self.hueHandle = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(hueWidth + 8, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 4,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.hueBar,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.hueHandle,
    })

    self.hueHandleStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1, -- Open = 0 (solid white)

        Parent = self.hueHandle,
    })

    self.hueInteract = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        -- pad the hit area sideways so the thin bar is easy to grab
        Size = UDim2.new(1, 16, 1, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 6,

        Parent = self.hueBar,
    })

    -- Alpha bar: the colour fading top(opaque)->bottom(transparent). The bar's own transparency
    -- gradient does the fade (0 at top -> 1 at bottom), so the card shows through as it clears.
    -- The round handle tracks self.alpha.
    self.alphaBar = self.window:Create("Frame", {
        Position = UDim2.fromOffset(alphaX, contentY),
        Size = UDim2.fromOffset(alphaWidth, mapSize.Y),
        BackgroundColor3 = self.value,
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- Open = 0 (then the gradient fades it down its length)

        Parent = self.main,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.alphaBar,
    })

    self.alphaGradient = self.window:Create("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.alphaBar,
    })

    self.alphaHandle = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(alphaWidth + 8, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 4,

        BackgroundTransparency = 1, -- Open = 0

        Parent = self.alphaBar,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.alphaHandle,
    })

    self.alphaHandleStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1, -- Open = 0 (solid white)

        Parent = self.alphaHandle,
    })

    self.alphaInteract = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 16, 1, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = "",
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 6,

        Parent = self.alphaBar,
    })

    -- Hex field under the big preview.
    self.hexBox = self.window:Create("Frame", {
        Position = UDim2.new(0, rightX, 0, contentY + 90),
        Size = UDim2.new(1, -(rightX + 20), 0, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- Open = 0.9

        Parent = self.main,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.hexBox,
    })

    self.hexBoxStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- Open = 0.85

        Parent = self.hexBox,
    })

    self.hexInput = self.window:Create("TextBox", {
        Text = "#" .. self.value:ToHex():upper(),
        PlaceholderText = locale.t("Smart Input"),
        Size = UDim2.new(1, -14, 1, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 3,

        TextTransparency = 1, -- Open = 0.4

        Parent = self.hexBox,
    }, { TextColor3 = "ContentColor", FontFace = "Font", PlaceholderColor3 = "PlaceholderColor" })

    -- Alpha % field, sits right of the hex field. Same styling as hexBox.
    self.alphaBox = self.window:Create("Frame", {
        Position = UDim2.new(0, rightX, 0, contentY + 90),
        Size = UDim2.fromOffset(alphaFieldWidth, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- Open = 0.9

        Parent = self.main,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = self.alphaBox,
    })

    self.alphaBoxStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- Open = 0.85

        Parent = self.alphaBox,
    })

    self.alphaInput = self.window:Create("TextBox", {
        Text = tostring(math.round(self.alpha * 100)) .. "%",
        PlaceholderText = "100%",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 3,

        TextTransparency = 1, -- Open = 0.4

        Parent = self.alphaBox,
    }, { TextColor3 = "ContentColor", FontFace = "Font", PlaceholderColor3 = "PlaceholderColor" })

    self.window:ConnectFor(self, self.mapInteract.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            self:_beginDrag("sat", input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)

    self.window:ConnectFor(self, self.hueInteract.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            self:_beginDrag("hue", input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)

    self.window:ConnectFor(self, self.alphaInteract.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            self:_beginDrag("alpha", input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)

    self.window:ConnectFor(self, variables.userInputService.InputEnded, function(input)
        if
            (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
            and self._drag
        then
            self:_endDrag()
        end
    end)

    -- commit the field on enter/click-away, parsing whatever format they typed. anything
    -- unrecognised just snaps back to the current colour.
    self.window:ConnectFor(self, self.hexInput.FocusLost, function()
        local color = parseColor(self.hexInput.Text)
        if color then
            self:Set(color)
        else
            self.hexInput.Text = "#" .. self.value:ToHex():upper()
        end
    end)

    -- alpha field: take the first number as a percent, clamp 0..100, else snap back
    self.window:ConnectFor(self, self.alphaInput.FocusLost, function()
        local n = tonumber((self.alphaInput.Text:gsub("[^%d%.]", "")))
        if n then
            self:SetAlpha(clamp01(n / 100))
        else
            self.alphaInput.Text = tostring(math.round(self.alpha * 100)) .. "%"
        end
    end)
end

-- start following the mouse for the given region ("sat" or "hue"). Mirrors the slider: one
-- RenderStepped loop that self-terminates if the window unloads mid-drag. For a mouse drag
-- it also bails the moment the button is up, so a dropped InputEnded cant leave it running.
function ColorPicker:_beginDrag(region, isMouse)
    -- the interacts stay visible through the close fade, so a click landing in that window
    -- would drag a picker thats already shut
    if not self._isOpen then
        return
    end
    self._drag = region
    self._dragIsMouse = isMouse
    self:_setHeld(region)
    self:_pump()

    if self._dragConnection then
        self._dragConnection:Disconnect()
        self._dragConnection = nil
    end

    self._dragConnection = variables.runService.RenderStepped:Connect(function()
        local mouseReleased = self._dragIsMouse
            and not variables.userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if self.window.unloaded or not self._drag or mouseReleased then
            if mouseReleased then
                self:_endDrag()
                return
            end
            if self._dragConnection then
                self._dragConnection:Disconnect()
                self._dragConnection = nil
            end
            return
        end
        self:_pump()
    end)
end

function ColorPicker:_endDrag()
    self._drag = nil
    self:_setHeld(nil)
    if self._dragConnection then
        self._dragConnection:Disconnect()
        self._dragConnection = nil
    end

    self.window:_persist(self)
end

-- grow only the grabbed control a touch while dragging, so it reads as a press (same idea as
-- the slider handle swelling when held). region is "sat"/"hue"/"alpha" while held, nil on release.
function ColorPicker:_setHeld(region)
    local satSize = if region == "sat" then UDim2.fromOffset(16, 16) else UDim2.fromOffset(12, 12)
    local hueSize = if region == "hue" then UDim2.fromOffset(hueWidth + 12, 10) else UDim2.fromOffset(hueWidth + 8, 8)
    local alphaSize = if region == "alpha"
        then UDim2.fromOffset(alphaWidth + 12, 10)
        else UDim2.fromOffset(alphaWidth + 8, 8)
    variables.tweenService:Create(self.satCursor, heldInfo, { Size = satSize }):Play()
    variables.tweenService:Create(self.hueHandle, heldInfo, { Size = hueSize }):Play()
    variables.tweenService:Create(self.alphaHandle, heldInfo, { Size = alphaSize }):Play()
end

-- Mouse in AbsolutePosition space. GetMouseLocation() sits one gui-inset below where
-- AbsolutePosition measures from (verified in play: GetGuiObjectsAtPosition lines up with
-- AbsolutePosition, and GetMouseLocation is +inset.Y off it), so subtract the inset. Only Y
-- matters here since the inset is vertical, but subtract both to be safe.
function ColorPicker:_mouseLocation()
    local mouse = variables.userInputService:GetMouseLocation()
    local screenGui = self.window.screenGui
    if screenGui and screenGui.IgnoreGuiInset then
        return mouse - variables.guiService:GetGuiInset()
    end
    return mouse
end

-- read the mouse for the active region, update the stored channels and repaint
function ColorPicker:_pump()
    -- the branches below mutate these in place
    local prevHue, prevSat, prevVal, prevAlpha = self.hue, self.sat, self.val, self.alpha

    if self._drag == "sat" then
        local size = self.map.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then
            return
        end
        local mouse = self:_mouseLocation()
        self.sat = clamp01((mouse.X - self.map.AbsolutePosition.X) / size.X)
        self.val = 1 - clamp01((mouse.Y - self.map.AbsolutePosition.Y) / size.Y)
    elseif self._drag == "hue" then
        local height = self.hueBar.AbsoluteSize.Y
        if height <= 0 then
            return
        end
        local mouse = self:_mouseLocation()
        self.hue = clamp01((mouse.Y - self.hueBar.AbsolutePosition.Y) / height)
    elseif self._drag == "alpha" then
        local height = self.alphaBar.AbsoluteSize.Y
        if height <= 0 then
            return
        end
        local mouse = self:_mouseLocation()
        -- top of the bar is fully opaque (alpha 1), bottom is clear (alpha 0)
        self.alpha = 1 - clamp01((mouse.Y - self.alphaBar.AbsolutePosition.Y) / height)
    else
        return
    end

    -- held but stationary: nothing moved, so dont re-render and hammer the callback every frame.
    -- compare the channels, not the colour they make: at val 0 (or sat 0) every hue is the same
    -- black, so a colour check would freeze the handles for the whole drag.
    if self.hue == prevHue and self.sat == prevSat and self.val == prevVal and self.alpha == prevAlpha then
        return
    end

    self.value = Color3.fromHSV(self.hue, self.sat, self.val)
    self:_render("drag")
    self:_fireCallback()
end

-- paint every surface from the current hue/sat/val/alpha.
-- mode "instant": everything snaps (initial build / Set while collapsed).
-- mode "drag":    map tint + cursors glide on a short tween so they track the mouse smoothly.
-- mode "animate": everything eases on the slower tween (a discrete Set while the picker's open).
-- Cursors/handles are tinted to the colour under them; the preview shows the colour at its alpha.
function ColorPicker:_render(mode)
    local mapHue = Color3.fromHSV(self.hue, 1, 1)
    local satPos = UDim2.new(self.sat, 0, 1 - self.val, 0)
    local huePos = UDim2.new(0.5, 0, self.hue, 0)
    local alphaPos = UDim2.new(0.5, 0, 1 - self.alpha, 0)
    local previewT = 1 - self.alpha -- preview opacity tracks alpha
    local shadowT = 1 - 0.4 * self.alpha -- 0.6 (solid) at full alpha -> 1 (gone) at zero alpha

    if mode == "instant" then
        self.map.BackgroundColor3 = mapHue
        self.satCursor.Position, self.satCursor.BackgroundColor3 = satPos, self.value
        self.hueHandle.Position, self.hueHandle.BackgroundColor3 = huePos, mapHue
        self.alphaBar.BackgroundColor3 = self.value
        self.alphaHandle.Position, self.alphaHandle.BackgroundColor3 = alphaPos, self.value
        self.preview.BackgroundColor3 = self.value
        self.previewShadow.Color = self.value
        if not self.window.hidden then
            self.preview.BackgroundTransparency = previewT
            self.previewShadow.Transparency = shadowT
        end
    else
        local moveInfo = if mode == "drag" then dragInfo else followInfo
        variables.tweenService:Create(self.map, moveInfo, { BackgroundColor3 = mapHue }):Play()
        variables.tweenService
            :Create(self.satCursor, moveInfo, { Position = satPos, BackgroundColor3 = self.value })
            :Play()
        variables.tweenService:Create(self.hueHandle, moveInfo, { Position = huePos, BackgroundColor3 = mapHue }):Play()
        variables.tweenService
            :Create(self.alphaHandle, moveInfo, { Position = alphaPos, BackgroundColor3 = self.value })
            :Play()
        -- the preview + its glow morph colour and opacity together on the softer follow tween
        variables.tweenService:Create(self.alphaBar, followInfo, { BackgroundColor3 = self.value }):Play()
        local previewGoal = { BackgroundColor3 = self.value }
        local shadowGoal = { Color = self.value }
        if not self.window.hidden then
            previewGoal.BackgroundTransparency = previewT
            shadowGoal.Transparency = shadowT
        end
        variables.tweenService:Create(self.preview, followInfo, previewGoal):Play()
        variables.tweenService:Create(self.previewShadow, followInfo, shadowGoal):Play()
    end

    -- dont fight the user while they're typing in a field
    if not self.hexInput:IsFocused() then
        self.hexInput.Text = "#" .. self.value:ToHex():upper()
    end
    if not self.alphaInput:IsFocused() then
        self.alphaInput.Text = tostring(math.round(self.alpha * 100)) .. "%"
    end

    self:_renderInvisible(mode ~= "instant")
end

-- Fade the "Invisible" overlay in as alpha nears 0 (only on the open preview - it wouldnt fit
-- the header pill). Fully in at alpha 0, gone by ~12% alpha.
function ColorPicker:_renderInvisible(animate)
    local inv = 0
    if self._isOpen and not self.window.hidden then
        inv = clamp01((0.12 - self.alpha) / 0.12)
    end
    local t = 1 - inv
    if animate then
        variables.tweenService:Create(self.invisibleIcon, fadeInfo, { ImageTransparency = t }):Play()
        variables.tweenService:Create(self.invisibleText, fadeInfo, { TextTransparency = t }):Play()
    else
        self.invisibleIcon.ImageTransparency = t
        self.invisibleText.TextTransparency = t
    end
end

function ColorPicker:_fireCallback()
    self.window:_runGuarded(self, self.callback, self.value, self.alpha)
end

function ColorPicker:_open()
    if self._isOpen then
        return
    end
    self._isOpen = true
    self:_setControlsVisible(true) -- back into input before they fade in

    if self._outsideClickConn then
        self.window:Disconnect(self._outsideClickConn)
    end
    self._outsideClickConn = self.window:Connect(variables.userInputService.InputBegan, function(input)
        if
            input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end
        local pos = input.Position
        local mainPos = self.main.AbsolutePosition
        local mainSize = self.main.AbsoluteSize
        if
            pos.X < mainPos.X
            or pos.X > mainPos.X + mainSize.X
            or pos.Y < mainPos.Y
            or pos.Y > mainPos.Y + mainSize.Y
        then
            self:_close()
        end
    end)

    variables.tweenService:Create(self.main, openInfo, { Size = UDim2.new(1, -20, 0, self._openHeight) }):Play()
    -- the header pill morphs out into the big swatch as the card grows
    variables.tweenService
        :Create(self.preview, openInfo, { Position = self._previewOpenPos, Size = self._previewOpenSize })
        :Play()
    self:_applyPickerVisibility(true, true)
    self:_renderInvisible(true)
end

function ColorPicker:_close()
    if not self._isOpen then
        return
    end
    self._isOpen = false

    if self._outsideClickConn then
        self.window:Disconnect(self._outsideClickConn)
        self._outsideClickConn = nil
    end

    -- a drag in progress shouldnt keep running once the picker is gone
    if self._drag then
        self:_endDrag()
    end
    if self.hexInput:IsFocused() then
        self.hexInput:ReleaseFocus()
    end
    if self.alphaInput:IsFocused() then
        self.alphaInput:ReleaseFocus()
    end

    self:_applyPickerVisibility(false, true)
    self:_renderInvisible(true)
    variables.tweenService
        :Create(self.preview, openInfo, { Position = previewClosedPos, Size = previewClosedSize })
        :Play()
    variables.tweenService:Create(self.main, openInfo, { Size = UDim2.new(1, -20, 0, headerHeight) }):Play()

    -- once the controls have faded, drop them out of input so a transparent field below the
    -- collapsed header cant grab the cursor
    task.delay(fadeInfo.Time, function()
        if not self._isOpen then
            self:_setControlsVisible(false)
        end
    end)
end

-- One source of truth for the picker controls' shown/hidden transparencies. Used both to hide
-- them instantly at build and to fade them on open/close, so every control is listed in exactly
-- one place - adding one cant re-introduce the bleed-through we'd get from a stray opaque fill
-- (there's no clip). The card height + preview morph animate separately.
function ColorPicker:_applyPickerVisibility(open, animate)
    local set = {
        [self.map] = { BackgroundTransparency = if open then 0 else 1 },
        [self.satOverlay] = { BackgroundTransparency = if open then 0 else 1 },
        [self.valOverlay] = { BackgroundTransparency = if open then 0 else 1 },
        [self.mapStroke] = { Transparency = if open then 0.9 else 1 },
        [self.satCursor] = { BackgroundTransparency = if open then 0 else 1 },
        [self.satCursorStroke] = { Transparency = if open then 0 else 1 },
        [self.hueBar] = { BackgroundTransparency = if open then 0 else 1 },
        [self.hueHandle] = { BackgroundTransparency = if open then 0 else 1 },
        [self.hueHandleStroke] = { Transparency = if open then 0 else 1 },
        [self.alphaBar] = { BackgroundTransparency = if open then 0 else 1 },
        [self.alphaHandle] = { BackgroundTransparency = if open then 0 else 1 },
        [self.alphaHandleStroke] = { Transparency = if open then 0 else 1 },
        [self.hexBox] = { BackgroundTransparency = if open then 0.9 else 1 },
        [self.hexBoxStroke] = { Transparency = if open then 0.85 else 1 },
        [self.hexInput] = { TextTransparency = if open then 0.4 else 1 },
        [self.alphaBox] = { BackgroundTransparency = if open then 0.9 else 1 },
        [self.alphaBoxStroke] = { Transparency = if open then 0.85 else 1 },
        [self.alphaInput] = { TextTransparency = if open then 0.4 else 1 },
    }

    for instance, props in set do
        if animate then
            variables.tweenService:Create(instance, fadeInfo, props):Play()
        else
            for prop, value in props do
                instance[prop] = value
            end
        end
    end
end

-- The picker controls sit below the header even while collapsed (the card doesnt clip), so a
-- transparent TextBox or button down there would still catch the cursor and clicks. Toggling the
-- top control frames off drops the whole cluster out of input when closed. The preview pill is
-- separate, so it stays.
function ColorPicker:_setControlsVisible(visible)
    for _, frame in { self.map, self.hueBar, self.alphaBar, self.hexBox, self.alphaBox } do
        frame.Visible = visible
    end
end

-- Pick side-by-side (wide) vs stacked (narrow) from the real width and apply the mode's
-- geometry. map + hue stay top-left in both; only the preview's open rect, the hex field and
-- the open height change. Re-tweens live if the mode flips while open.
function ColorPicker:_applyLayout()
    local width = self.main.AbsoluteSize.X
    local mode = if width > 0 and width < narrowWidth then "narrow" else "wide"
    if mode == self._layoutMode then
        return
    end
    self._layoutMode = mode

    local l = layoutSpec[mode]
    self._openHeight = l.height
    self._previewOpenPos = l.previewPos
    self._previewOpenSize = l.previewSize
    self.hexBox.Position = l.hexPos
    self.hexBox.Size = l.hexSize
    self.alphaBox.Position = l.alphaFieldPos
    self.alphaBox.Size = l.alphaFieldSize

    if self._isOpen then
        variables.tweenService:Create(self.main, openInfo, { Size = UDim2.new(1, -20, 0, self._openHeight) }):Play()
        variables.tweenService
            :Create(self.preview, openInfo, { Position = self._previewOpenPos, Size = self._previewOpenSize })
            :Play()
    end
end

function ColorPicker:Set(color, skipCallback)
    self.value = coerceColor(color, self.value)
    self.hue, self.sat, self.val = self.value:ToHSV()
    -- ease the cursors only when the picker is open, otherwise theres nothing on screen to move
    self:_render(if self._isOpen then "animate" else "instant")

    if not skipCallback then
        self:_fireCallback()
        self.window:_persist(self)
    end
end

function ColorPicker:SetAlpha(alpha, skipCallback)
    self.alpha = clamp01(if type(alpha) == "number" then alpha else self.alpha)
    self:_render(if self._isOpen then "animate" else "instant")

    if not skipCallback then
        self:_fireCallback()
        self.window:_persist(self)
    end
end

-- Persistence: RRGGBB plus an alpha byte (AA) so alpha round-trips.
function ColorPicker:_serialize()
    return self.value:ToHex() .. string.format("%02x", math.clamp(math.round((self.alpha or 1) * 255), 0, 255))
end

-- Restore colour + alpha from that hex. Old 6-char configs (no alpha byte) still load. Alpha is
-- set silently first so the Set fires the callback just once, with the final colour and alpha.
function ColorPicker:_deserialize(raw)
    local hex = tostring(raw)
    local alpha = nil
    if #hex >= 8 then
        alpha = (tonumber(hex:sub(7, 8), 16) or 255) / 255
        hex = hex:sub(1, 6)
    end

    -- resolve the colour before applying anything: fromHex throws on a malformed string, and
    -- an alpha set first would stick while the colour fell back to the default
    local ok, color = pcall(Color3.fromHex, hex)
    if not ok then
        return
    end
    if alpha then
        self:SetAlpha(alpha, true)
    end
    self:Set(color)
end

function ColorPicker:_setShown(shown, animate)
    local w = self.window
    if shown then
        w:_revealCommon(self, animate)
        -- the preview shows the colour at its alpha, so its opacity tracks alpha even in the header
        w:_reveal(self.preview, { BackgroundTransparency = 1 - self.alpha }, animate)
        w:_reveal(self.previewShadow, { Transparency = 1 - 0.4 * self.alpha }, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.preview, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.previewShadow, { Transparency = 1 }, animate)
        -- if the window hides while we're open, collapse so we dont reopen mid-air
        if self._isOpen then
            self:_close()
        end
    end
end

moveable(ColorPicker)
lockable(ColorPicker)

return ColorPicker

end)() end,
    [7] = function()local wax,script,require=ImportGlobals(7)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- A monospaced block for code or log output. It holds the height it's given and scrolls inside
-- itself, so a console that fills up doesn't push the rest of the page down the screen.
--
-- One label per line, not one label for the whole body: a single auto-sized label inside a
-- fixed-height scroller gets clamped to one viewport, and the canvas then has nothing to
-- scroll. A row each keeps every label short enough that its own height is never the thing
-- being clamped, and the list layout measures the canvas for us.

local Console = {}
Console.__index = Console
Console.__type = "Console"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local moveable = require(utility.moveable)
local locale = require(utility.locale)

local defaultHeight = 120
local minHeight = 48
local titleHeight = 24 -- the row the name sits on, when there is one
local padding = 17
local textPadding = 12 -- inside the panel; log output sits close to its edge
local textSize = 12
local lineHeight = 1.25 -- dense, the way a real log reads

-- How many lines the block keeps. Past this the oldest roll off the top, so a console left
-- running all session cant grow without end.
local defaultMaxLines = 200

-- Monospace, so columns line up. Not the brand font: this is output, not copy.
local monoFont = Font.fromEnum(Enum.Font.Code)

function Console.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name,
        description = properties.description or properties.Description,

        height = math.max(tonumber(properties.height or properties.Height) or defaultHeight, minHeight),
        -- a log pins itself to the newest line; a code sample stays where you left it
        follow = properties.follow or properties.Follow or false,
        maxLines = math.max(tonumber(properties.maxLines or properties.MaxLines) or defaultMaxLines, 1),

        lines = {},
        -- Pooled and recycled in a ring. Appending at capacity rewrites one label and gives it
        -- the next LayoutOrder, so a line costs the same whether the buffer holds ten or a
        -- thousand - rewriting every row on every append is what makes a console crawl.
        lineLabels = {},
        head = 1, -- the pooled label holding the oldest line
        nextOrder = 1,
        textDirty = true,
    }, Console)

    self:_build()
    self:_setLines(properties.text or properties.Text or "")

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    return self
end

-- The body as one string. Built on demand: joining every line on each append would put an O(n)
-- cost on the one path that has to stay cheap.
function Console:Get(): string
    if self.textDirty then
        self.text = table.concat(self.lines, "\n")
        self.textDirty = false
    end
    return self.text
end

-- Split a body into lines and keep only the newest maxLines of them.
function Console:_setLines(text)
    text = if type(text) == "string" then text else tostring(text)

    table.clear(self.lines)
    if text ~= "" then
        for line in string.gmatch(text .. "\n", "([^\n]*)\n") do
            table.insert(self.lines, line)
        end
    end
    self:_trim()
    self:_flush()
end

-- Drop from the front until the buffer fits. table.move rather than repeated table.remove, so
-- a burst of output doesn't turn into a quadratic shuffle.
function Console:_trim()
    local excess = #self.lines - self.maxLines
    if excess <= 0 then
        return
    end
    table.move(self.lines, excess + 1, #self.lines, 1)
    for index = #self.lines, #self.lines - excess + 1, -1 do
        self.lines[index] = nil
    end
end

-- A row for a line. Created once and then recycled; the pool never exceeds maxLines.
function Console:_makeLabel()
    return self.window:Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        FontFace = monoFont,
        TextSize = textSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LineHeight = lineHeight,
        RichText = false, -- it's output; angle brackets are text, not markup

        -- a line added after the reveal comes in at whatever the rest are already at
        TextTransparency = self._textTransparency or 1,

        Parent = self.scroll,
    }, { TextColor3 = "ContentColor" })
end

-- a blank line still has to take a row, and an empty label collapses to nothing
local function rowText(line: string): string
    return if line == "" then " " else line
end

-- Rebuild every row from the buffer. Only the paths that replace the whole body use this;
-- Append has its own O(1) route below.
function Console:_flush()
    self.textDirty = true

    for index, line in self.lines do
        local label = self.lineLabels[index]
        if not label then
            label = self:_makeLabel()
            self.lineLabels[index] = label
        end
        label.LayoutOrder = index
        label.Text = rowText(line)
        label.Visible = true
    end

    for index = #self.lines + 1, #self.lineLabels do
        self.lineLabels[index].Visible = false
    end

    self.head = 1
    self.nextOrder = #self.lines + 1
    self:_follow()
end

-- One line, one label write. At capacity the oldest row is recycled into the newest position
-- rather than every row shuffling up, so the cost doesn't grow with the buffer.
function Console:_pushLine(line: string)
    self.textDirty = true

    if #self.lines < self.maxLines then
        table.insert(self.lines, line)
        local index = #self.lines
        local label = self.lineLabels[index]
        if not label then
            label = self:_makeLabel()
            self.lineLabels[index] = label
        end
        label.LayoutOrder = self.nextOrder
        label.Text = rowText(line)
        label.Visible = true
        self.nextOrder += 1
        return
    end

    -- full: drop the oldest line and hand its row to the newest one. table.move rather than
    -- table.remove so the shift is one bulk copy instead of a per-element slide.
    table.move(self.lines, 2, #self.lines, 1)
    self.lines[#self.lines] = line

    local label = self.lineLabels[self.head]
    label.LayoutOrder = self.nextOrder
    label.Text = rowText(line)
    label.Visible = true

    self.nextOrder += 1
    self.head = (self.head % #self.lineLabels) + 1
end

function Console:_build()
    local top = if self.name then titleHeight else 0

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, self.height + top + padding * 2),
        BorderSizePixel = 0,
        Name = self.name or "Console",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)

    if self.name then
        self.container = self.window:Create("Frame", {
            Size = UDim2.new(1, -padding * 2, 0, 16),
            Position = UDim2.new(0, padding, 0, padding),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Parent = self.main,
        })

        self.title = self.window:Create("TextLabel", {
            Text = locale.t(self.name),

            Size = UDim2.fromScale(1, 1),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,

            -- Animation
            TextTransparency = 1, -- In = 0

            Parent = self.container,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })
    end

    -- The inset panel the text scrolls inside. Darker than the element it sits on, the way a
    -- terminal reads against the window around it.
    self.panel = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -padding),
        Size = UDim2.new(1, -padding * 2, 0, self.height),
        BorderSizePixel = 0,
        ClipsDescendants = true,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    }, { BackgroundColor3 = "StatBackground" })

    self.window:Create("UICorner", {
        Parent = self.panel,
    }, { CornerRadius = "ElementCornerRadius" })

    self.panelStroke = self.window:Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

        -- Animation
        Transparency = 1, -- In = 0.9

        Parent = self.panel,
    }, { Color = "SurfaceStroke" })

    self.scroll = self.window:Create("ScrollingFrame", {
        Size = UDim2.new(1, -textPadding * 2, 1, -textPadding * 2),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,

        Parent = self.panel,
    })

    -- the layout is what measures the canvas, so the rows themselves can stay simple
    self.scrollLayout = self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.scroll,
    })

    self:_watchCanvas()
end

-- Pin to the bottom. Asking for a position past the end is fine: Roblox clamps it to the real
-- maximum, which saves working out the viewport height ourselves.
function Console:_pin()
    local scroll = self.scroll
    if not scroll or not scroll.Parent then
        return
    end
    scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y)
end

function Console:_follow()
    if not self.follow then
        return
    end
    self:_pin()
    task.defer(function()
        self:_pin()
    end)
end

-- The canvas only settles a frame or two after the rows change, so pinning once on Append is a
-- race. The layout's content size is the thing that actually moves, so follow that instead.
function Console:_watchCanvas()
    self.window:ConnectFor(self, self.scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if self.follow then
            self:_pin()
        end
    end)
end

-- Replace the whole body.
function Console:Set(text)
    self:_setLines(text)
end

-- Add a line to the end, the way a console does. Once the buffer is full the oldest line rolls
-- off the top, so what you see is always the newest output.
function Console:Append(line)
    line = if type(line) == "string" then line else tostring(line)
    for part in string.gmatch(line .. "\n", "([^\n]*)\n") do
        self:_pushLine(part)
    end
    self:_follow()
end

function Console:Clear()
    table.clear(self.lines)
    self:_flush()
end

-- Put the body on the clipboard, where the executor gives us one. Returns whether it landed.
function Console:Copy(): boolean
    local clipboard = (getgenv and getgenv().setclipboard) or setclipboard
    if typeof(clipboard) ~= "function" then
        return false
    end
    return (pcall(clipboard, self:Get()))
end

-- Change how tall the block stands. The panel takes the height; the element grows around it.
function Console:SetHeight(height)
    self.height = math.max(tonumber(height) or defaultHeight, minHeight)
    local top = if self.name then titleHeight else 0
    self.panel.Size = UDim2.new(1, -padding * 2, 0, self.height)
    self.main.Size = UDim2.new(1, -20, 0, self.height + top + padding * 2)
end

function Console:_setShown(shown, animate)
    local w = self.window

    -- no icon and (usually) no title, so the shared reveal doesn't fit; drive the parts directly
    w:_reveal(self.main, { BackgroundTransparency = if shown then w.theme.ElementTransparency or 0 else 1 }, animate)
    w:_reveal(self.stroke, { Transparency = if shown then w.theme.ElementStrokeTransparency else 1 }, animate)
    w:_reveal(self.panel, { BackgroundTransparency = if shown then 0 else 1 }, animate)
    w:_reveal(self.panelStroke, { Transparency = if shown then 0.9 else 1 }, animate)

    self._textTransparency = if shown then 0.15 else 1
    for _, label in self.lineLabels do
        w:_reveal(label, { TextTransparency = self._textTransparency }, animate)
    end

    if self.title then
        w:_reveal(self.title, { TextTransparency = if shown then 0 else 1 }, animate)
    end
    if self.descriptor then
        w:_reveal(self.descriptor.titleLabel, { TextTransparency = if shown then 0.7 else 1 }, animate)
    end
end

function Console:Remove()
    if self.descriptor then
        self.descriptor:Remove()
    end
    self.main:Destroy()
end

moveable(Console)

return Console

end)() end,
    [8] = function()local wax,script,require=ImportGlobals(8)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Descriptor = {}
Descriptor.__index = Descriptor
Descriptor.__type = "Descriptor"

local locale = require(script.Parent.Parent.utility.locale)

function Descriptor.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        description = properties.description or properties.Description or "",
    }, Descriptor)

    self.main = self.window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 0),

        Parent = self.tab.tabPage,
    })

    self.window:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.main,
    })

    self.titleLabel = self.window:Create("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        RichText = true,
        Size = UDim2.new(1, -90, 0, 0),
        Text = locale.t(self.description),
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,

        -- Animation
        TextTransparency = 1, -- In = 0.7

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- Bottom spacing
    self.window:Create("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Size = UDim2.fromOffset(0, 15),
        Parent = self.main,
    })

    return self
end

return Descriptor

end)() end,
    [9] = function()local wax,script,require=ImportGlobals(9)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- A rule across the page. A Section groups by naming what follows it, so breaking a page into
-- parts meant giving every part a heading whether it wanted one or not. This breaks without
-- saying anything, takes a word in the middle when there is one worth saying, and with no line
-- at all is simply room, which nothing else offered either.

local Divider = {}
Divider.__index = Divider
Divider.__type = "Divider"

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)

local lineThickness = 1
local defaultSpacing = 12
local labelGap = 10
local labelHeight = 14
local textSize = 12

-- Faint on purpose. A rule is there to be noticed only when looked for; anything heavier reads
-- as a border and starts competing with the element strokes either side of it.
local lineShown = 0.88
local labelShown = 0.55

function Divider.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local spacing = properties.spacing or properties.Spacing
    local text = properties.text or properties.Text

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        text = if text ~= nil then tostring(text) else "",
        spacing = if type(spacing) == "number" then math.max(spacing, 0) else defaultSpacing,
        -- no rule is a divider that only takes room, which is the other thing people reach a
        -- divider for and the only way to get it
        line = properties.line ~= false and properties.Line ~= false,
    }, Divider)

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -40, 0, 0),
        BorderSizePixel = 0,
        Name = "Divider",
        BackgroundTransparency = 1,

        Parent = self.tab.tabPage,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, labelGap),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,

        Parent = self.main,
    })

    if self.line then
        self.left = self:_buildHalf(1)
    end

    if self.text ~= "" then
        self:_buildLabel()
    end

    self:_applyHeight()

    return self
end

-- One side of the rule. The halves share whatever the label leaves, so the line stays centred
-- whatever the word in the middle is.
function Divider:_buildHalf(order)
    local rule = self.window:Create("Frame", {
        Size = UDim2.new(0, 0, 0, lineThickness),
        BorderSizePixel = 0,
        LayoutOrder = order,

        -- Animation
        BackgroundTransparency = 1, -- In = lineShown

        Parent = self.main,
    }, { BackgroundColor3 = "ContentColor" })

    self.window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill,

        Parent = rule,
    })

    return rule
end

-- The word in the middle and the far half it splits the rule into, built the first time one is
-- wanted. A plain rule is a single span with nothing to write to, so a divider that gains a
-- word later grows the parts then rather than every rule carrying ones it never shows.
function Divider:_buildLabel()
    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.text),
        Size = UDim2.fromOffset(0, labelHeight),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = textSize,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 2,

        -- Animation
        TextTransparency = 1, -- In = labelShown

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    if self.line then
        self.right = self:_buildHalf(3)
    end
end

-- Spacing is the room above and below, so the height is that twice over plus whatever sits
-- between: a label if there is one, the rule if not, nothing at all on a spacer.
function Divider:_applyHeight()
    local content = if self.text ~= "" then labelHeight elseif self.line then lineThickness else 0
    self.main.Size = UDim2.new(1, -40, 0, self.spacing * 2 + content)
end

-- Swap the word in the middle, or clear it with "". A divider built without one builds its
-- label here on the first call, so this always lands.
--
-- It rebinds rather than writing the label directly: the window remembers the source each
-- localised property was built from and re-resolves them all on SetLocale, so a direct write
-- would be undone by the next language change.
function Divider:Set(text)
    self.text = if text ~= nil then tostring(text) else ""

    if self.text ~= "" and not self.title then
        self:_buildLabel()

        -- built after the page was revealed, so it has to be brought in on its own or it stays
        -- fully transparent
        if not self.window.hidden then
            self:_setShown(true, true)
        end
    end

    -- nothing to write to only when there is nothing to write, which is the state asked for
    if self.title then
        self.window:_bindLocale(self.title, "Text", self.text)

        -- clearing the word closes the rule back up. The halves sit either side of the label
        -- with a gap between them, so hiding the label alone leaves that gap in the middle of
        -- the line. The layout skips what it cannot see, so dropping the far half leaves the
        -- near one filling the width on its own, which is the plain rule again.
        local named = self.text ~= ""
        self.title.Visible = named
        if self.right then
            self.right.Visible = named
        end
    end

    self:_applyHeight()
end

function Divider:_setShown(shown, animate)
    local w = self.window
    local ruleTransparency = if shown then lineShown else 1

    w:_reveal(self.left, { BackgroundTransparency = ruleTransparency }, animate)
    w:_reveal(self.right, { BackgroundTransparency = ruleTransparency }, animate)
    w:_reveal(self.title, { TextTransparency = if shown then labelShown else 1 }, animate)
end

moveable(Divider)

return Divider

end)() end,
    [10] = function()local wax,script,require=ImportGlobals(10)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Drag = {}
Drag.__index = Drag
Drag.__type = "Drag"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local constants = require(utility.constants)

function Drag.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
    }, Drag)

    -- Drag Point
    self.drag = self.window:Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(150, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        -- hangs under the window's bottom edge; derived from the real size so it's right on the
        -- first open too (Show/minimise recompute the same way against self.size)
        Position = UDim2.new(0.5, 0, 0.5, self.window.size.Y.Offset / 2 + 15),
        ZIndex = constants.zIndex.drag,

        -- Animation
        Visible = false, -- In = true

        Parent = self.window.screenGui,
    })

    self.dragCosmetic = self.window:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.3),
        ZIndex = constants.zIndex.drag,

        -- Animation
        BackgroundTransparency = 1, -- In = 0.7
        Size = UDim2.fromOffset(0, 4), -- In = 100, 4

        Parent = self.drag,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 20),

        Parent = self.dragCosmetic,
    })

    -- White glow behind the drag bar
    self.window:CreateGlow(self.dragCosmetic, Color3.fromRGB(255, 255, 255), 10, 0.5)

    self.dragInteract = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        TextTransparency = 1,
        ZIndex = constants.zIndex.drag,

        Parent = self.drag,
    })

    local dragging = false
    local relative = nil

    -- main.Position offsets live in a space shifted from AbsolutePosition by the gui inset,
    -- even though the ScreenGui ignores inset. so the drag target has to add the inset back
    -- or the window lands ~inset px too high (measured in play: without it, jumps up ~58px).
    local offset = Vector2.zero
    local screenGui = self.window.screenGui

    if screenGui and screenGui.IgnoreGuiInset then
        offset = variables.guiService:GetGuiInset()
    end

    local function getPosition()
        local mouseLocation = variables.userInputService and variables.userInputService:GetMouseLocation()
            or Vector2.new(0, 0)
        local validRelative = relative or Vector2.new(0, 0)
        local validOffset = offset or Vector2.new(0, 0)

        return mouseLocation + validRelative + validOffset
    end

    -- main sits at the cursor target, the drag bar hangs under its bottom edge
    local function getTargets()
        local position = getPosition()
        local x, y = position.X, position.Y

        -- keepOnScreen: clamp the centre so it cant be pulled off screen
        if self.window.settings and self.window.settings.keepOnScreen then
            local size = self.window.main.AbsoluteSize
            local screen = self.window.screenGui.AbsoluteSize
            local margin = 8
            local halfX, halfY = size.X / 2, size.Y / 2
            -- math.max in case the window is bigger than the screen
            x = math.clamp(x, halfX + margin, math.max(halfX + margin, screen.X - halfX - margin))
            y = math.clamp(y, halfY + margin, math.max(halfY + margin, screen.Y - halfY - margin))
        end

        local mainTarget = UDim2.fromOffset(x, y)
        local dragTarget = UDim2.fromOffset(x, y + (self.window.main.Size.Y.Offset / 2 + 15))
        return mainTarget, dragTarget
    end

    self.window:Connect(self.drag.MouseEnter, function()
        if not dragging and not self.window.hidden then
            variables.tweenService
                :Create(
                    self.dragCosmetic,
                    TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4) }
                )
                :Play()
        end
    end)

    self.window:Connect(self.drag.MouseLeave, function()
        if not dragging and not self.window.hidden then
            variables.tweenService
                :Create(
                    self.dragCosmetic,
                    TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    { BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4) }
                )
                :Play()
        end
    end)

    -- Letting go, however it happens: the button coming up, the client losing focus, or the
    -- window going away out from under the grab. Only settle the bar back into line when
    -- theres something to look at, otherwise theres a tween to fight.
    local function releaseDrag()
        if not dragging then
            return
        end
        dragging = false

        if not self.window:_interactive() then
            return
        end

        variables.tweenService
            :Create(
                self.dragCosmetic,
                TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7 }
            )
            :Play()

        -- main lags while dragging, so settle both into line on release
        local settle = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local mainTarget, dragTarget = getTargets()
        variables.tweenService:Create(self.window.main, settle, { Position = mainTarget }):Play()
        variables.tweenService:Create(self.drag, settle, { Position = dragTarget }):Play()
    end

    self.window:Connect(self.dragInteract.InputBegan, function(input, processed)
        if processed then
            return
        end

        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            -- a grab started mid-reveal would fight the tween thats still moving the window
            if not self.window:_interactive() then
                return
            end

            dragging = true

            -- refetch in case the inset changed (e.g. topbar toggled) since construction
            if screenGui and screenGui.IgnoreGuiInset then
                offset = variables.guiService:GetGuiInset()
            end

            relative = self.window.main.AbsolutePosition
                + self.window.main.AbsoluteSize * self.window.main.AnchorPoint
                - variables.userInputService:GetMouseLocation()
            if not self.window.hidden then
                variables.tweenService
                    :Create(
                        self.dragCosmetic,
                        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        { Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0 }
                    )
                    :Play()
            end
        end
    end)

    self.window:Connect(variables.userInputService.InputEnded, function(input)
        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            releaseDrag()
        end
    end)

    -- alt-tabbing with the button still down never delivers InputEnded, so without this the
    -- grab stays armed and the window snaps to the cursor the moment youre back
    self.window:Connect(variables.userInputService.WindowFocusReleased, releaseDrag)

    -- exponential smoothing per frame instead of a new tween each frame. constant is the
    -- fraction of the gap left after 1s, so smaller = snappier. main lags, the bar tracks tight
    local mainRemaining = 1e-7
    local barRemaining = 1e-60

    self.window:Connect(variables.runService.RenderStepped, function(dt)
        if not dragging then
            return
        end

        -- hidden or mid-animation means the grab went stale under us, so drop it here rather
        -- than let it wake up later and yank the window to wherever the cursor drifted
        if not self.window:_interactive() then
            releaseDrag()
            return
        end

        local mainTarget, dragTarget = getTargets()

        self.window.main.Position = self.window.main.Position:Lerp(mainTarget, 1 - mainRemaining ^ dt)
        self.drag.Position = self.drag.Position:Lerp(dragTarget, 1 - barRemaining ^ dt)
    end)

    return self
end

return Drag

end)() end,
    [11] = function()local wax,script,require=ImportGlobals(11)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Dropdown = {}
Dropdown.__index = Dropdown
Dropdown.__type = "Dropdown"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local image = require(utility.image)
local constants = require(utility.constants)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)
local windowSizing = require(utility.windowSizing)
local lockable = require(utility.lockable)

local chevronIcon = constants.icons.chevron
local checkIcon = constants.icons.check
local dotIcon = constants.icons.dot
local searchIconAsset = constants.icons.search

-- Per-corner radii: an option's edge is rounded when nothing sits next to it, sharp otherwise
local roundRadius = UDim.new(0, 12)
local flatRadius = UDim.new(0, 7)

local searchCollapsedHeight = 30
local searchExpandedHeight = 38

-- Option row geometry. The open height is added up from these, so a cap written as a bare
-- number cant drift out of step with the rows its meant to be counting.
local optionHeight = 38
local optionGap = 5
local listPadding = 2 -- above and below the rows, so the first and last strokes clear the clip

-- Everything the card owes around its rows: the header pill it sits under, the gap between
-- them, and its own padding.
local headerHeight = 41
local headerGap = 6
local cardPaddingTop = 7
local cardPaddingBottom = 6
local cardPadding = cardPaddingTop + cardPaddingBottom

-- Most rows we'll ever show at once. Past this the list scrolls rather than the card growing.
local maxVisibleOptions = 4

-- The row of bulk actions a multi-select card carries above its list.
local actionsHeight = 22
local hintTween = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local hoverTween = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- How visible the scrollbar is while there is list left to reach. Faint on purpose: it is there
-- to say the list carries on, not to be furniture.
local scrollbarShown = 0.4
local searchTween = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local function dedupStrings(arr)
    local seen = {}
    local out = {}
    for _, v in arr do
        if typeof(v) == "string" and not seen[v] then
            seen[v] = true
            table.insert(out, v)
        end
    end
    return out
end

local function normalizeValue(value, multi)
    if value == nil then
        return {}
    end
    if typeof(value) == "string" then
        return { value }
    end
    if typeof(value) == "table" then
        local out = dedupStrings(value)
        if not multi and #out > 1 then
            return { out[1] }
        end
        return out
    end
    return {}
end

-- The visible selection is always the intent narrowed to options that currently exist.
local function intersectWithOptions(value, options)
    local out = {}
    for _, v in value do
        if table.find(options, v) then
            table.insert(out, v)
        end
    end
    return out
end

local function sameSelection(a, b)
    if #a ~= #b then
        return false
    end
    for _, v in a do
        if not table.find(b, v) then
            return false
        end
    end
    return true
end

function Dropdown.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local options = properties.options or properties.Options or {}
    local multiSelect = properties.multiSelect or properties.MultiSelect or properties.MultipleOptions or false

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Dropdown",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState, -- dont save config for this element if true.

        flag = properties.flag
            or properties.Flag
            or (
                not (properties.forgetState or properties.ForgetState or tab.forgetState)
                    and functions.deriveFlagFromName(properties.name or properties.Name or "Dropdown")
                or nil
            ),

        callback = properties.callback or properties.Callback or function() end,

        options = dedupStrings(options),
        multiSelect = multiSelect,
        placeholderText = locale.resolve(properties.placeholder or properties.Placeholder or "None"),
        value = normalizeValue(
            properties.value or properties.Value or properties.currentOption or properties.CurrentOption,
            multiSelect
        ),

        _isOpen = false,
        _optionFrames = {},
    }, Dropdown)

    -- Remember the full intent so a selection survives options that only load later (via
    -- Refresh), while self.value stays narrowed to options that currently exist.
    self._desiredValue = self.value
    self.value = intersectWithOptions(self.value, self.options)

    -- Register as a saveable control if flagged
    self.window:_registerControl(self)

    -- Outer wrapper: transparent, just holds the two cards and animates its height
    -- open <-> closed. It does not clip: a UIStroke is drawn outside the frame it belongs to,
    -- and both cards fill this exactly, so a clip here takes the border off both of them. The
    -- options card cant overflow it anyway, since its height is this one's less the header.
    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundTransparency = 1,

        Parent = self.tab.tabPage,
    })

    -- Header card: the always-visible pill (icon + title + selected value + chevron)
    self.top = self.window:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 41),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        ZIndex = 1,

        Parent = self.main,
    }, { BackgroundTransparency = "ElementTransparency" })

    -- the same stroke every other element gets. The panel below keeps the tinted one, so the
    -- card only stops matching its neighbours once it's actually open.
    self.stroke = self.window:StyleElementBody(self.top)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.top)
    self.flashTarget = self.top -- main is a transparent wrapper, so the error-flash tints the pill

    self.container = self.window:Create("Frame", {
        BorderSizePixel = 0,

        Parent = self.top,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 5,
    })

    self.containerLayout = self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animation
            ImageTransparency = 1, -- In = 0

            ZIndex = 5,
            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        -- Configurables
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(150, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0

        ZIndex = 5,
        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.selectedLabel = self.window:Create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -41, 0.5, 0),
        Size = UDim2.fromOffset(168, 15),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextWrapped = true,

        -- Animation
        TextTransparency = 1, -- In = 0.5

        ZIndex = 5,
        Parent = self.top,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.chevron = self.window:Create("ImageLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Image = "rbxassetid://" .. tostring(chevronIcon),
        Rotation = 180,

        -- Animation
        ImageTransparency = 1, -- In = 0.5

        ZIndex = 5,
        Parent = self.top,
    }, { ImageColor3 = "ContentColor" })

    -- Covers only the header, so option clicks in the open panel below don't hit it.
    self.interact = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 41),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        Text = "",
        TextTransparency = 1,
        ZIndex = 10,
        AutoButtonColor = false,

        Parent = self.main,
    })

    -- Options card: a second (full-width) pill below the header, revealed as the wrapper
    -- grows. Anchored to the wrapper's bottom (top edge sits 6px under the header), and it
    -- clips its own contents: collapsed it is zero height, so the search bar and the list are
    -- cut off here while its own border still draws outside it, like every other element's.
    self.panel = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, -(headerHeight + headerGap)),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 1,

        BackgroundTransparency = 1, -- Open = ElementTransparency

        Parent = self.main,
    })

    self.panelStroke = self.window:StyleElementPanel(self.panel)

    -- The card stacks the search bar over the list. The search bar is always present in
    -- the layout (it just grows/shrinks), so the gap under it is stable; the list is a
    -- flex-fill item, so it takes whatever height is left and slides down as search grows.
    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.panel,
    })

    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, cardPaddingTop),
        PaddingBottom = UDim.new(0, cardPaddingBottom),

        Parent = self.panel,
    })

    self:_buildSearch()
    self:_buildActions()

    self.list = self.window:Create("ScrollingFrame", {
        Active = true,
        Size = UDim2.new(1, 0, 0, 0), -- height comes from the UIFlexItem below
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ScrollBarImageColor3 = Color3.fromRGB(240, 240, 240),
        ScrollBarThickness = 3,
        ScrollBarImageTransparency = 1, -- _syncScrollHint shows it while theres more below
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 3,
        ZIndex = 1,

        Parent = self.panel,
    })

    self.window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill,

        Parent = self.list,
    })

    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal("CanvasPosition"), function()
        self:_syncScrollHint()
    end)
    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
        self:_syncScrollHint()
    end)

    -- the card opens on a tween, so the list is still its collapsed height when _open asks. Its
    -- window height is the other half of "is there more below", and without watching it the
    -- scrollbar stays hidden until something else happens to trigger a sync.
    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal("AbsoluteWindowSize"), function()
        self:_syncScrollHint()
    end)

    self.listLayout = self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,

        Parent = self.list,
    })

    -- top as well as bottom: the list clips, and a row's stroke is drawn outside it, so the
    -- first row lost its top border to the clip edge without this
    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, listPadding),
        PaddingBottom = UDim.new(0, listPadding),

        Parent = self.list,
    })

    -- Said when a search matches nothing. Without it the card is a search box over an empty
    -- space, which reads as broken rather than as no matches.
    self.emptyLabel = self.window:Create("TextLabel", {
        Name = "Empty",
        Size = UDim2.new(1, -12, 0, optionHeight),
        BackgroundTransparency = 1,
        Text = locale.t("No matches"),
        TextSize = 14,
        TextTransparency = 0.55,
        Visible = false,
        LayoutOrder = 1,

        Parent = self.list,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    local function isOptionSelected(name)
        return table.find(self.value, name) ~= nil
    end

    local function renderOptionState(data, animate)
        local selected = isOptionSelected(data.name)
        local bgT = if self._isOpen then (selected and 0.9 or 0.95) else 1
        local titleT = if self._isOpen then (selected and 0 or 0.3) else 1
        -- Selected shows a bright check; unselected shows a faint dot
        local iconT = if self._isOpen then (selected and 0 or 0.7) else 1
        local strokeT = if self._isOpen then (selected and 0.85 or 0.93) else 1

        image.assign(data.checkIcon, "Image", if selected then checkIcon else dotIcon)

        if animate then
            local info = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            variables.tweenService:Create(data.frame, info, { BackgroundTransparency = bgT }):Play()
            variables.tweenService:Create(data.title, info, { TextTransparency = titleT }):Play()
            variables.tweenService:Create(data.checkIcon, info, { ImageTransparency = iconT }):Play()
            variables.tweenService:Create(data.stroke, info, { Transparency = strokeT }):Play()
        else
            data.frame.BackgroundTransparency = bgT
            data.title.TextTransparency = titleT
            data.checkIcon.ImageTransparency = iconT
            data.stroke.Transparency = strokeT
        end
    end

    local function updateSelectedLabel()
        if self.multiSelect then
            local n = #self.value
            if n == 0 then
                self.selectedLabel.Text = self.placeholderText
            elseif n == 1 then
                self.selectedLabel.Text = self.value[1]
            else
                self.selectedLabel.Text = locale.resolve("Various")
            end
        else
            self.selectedLabel.Text = self.value[1] or self.placeholderText
        end
    end

    self._renderOptionState = renderOptionState
    self._updateSelectedLabel = updateSelectedLabel

    local function buildOption(optionName)
        local frame = self.window:Create("Frame", {
            Size = UDim2.new(1, -12, 0, optionHeight),
            BorderSizePixel = 0,
            -- set explicitly: the list sorts on LayoutOrder, and a reused row has to be able to
            -- take a new position without relying on the order it happened to be created in
            LayoutOrder = #self._optionFrames + 1,

            BackgroundTransparency = 1,

            Parent = self.list,
        }, { BackgroundColor3 = "DropdownHighlight" })

        -- Radius is driven by adjacency in _updateCorners (7 flat / 12 rounded)
        local corner = self.window:Create("UICorner", {
            CornerRadius = flatRadius,
            Parent = frame,
        })

        -- Subtle stroke, only shown on the selected option
        local optionStroke = self.window:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 1, -- selected = 0.85
            Parent = frame,
        })

        local interact = self.window:Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextTransparency = 1,
            ZIndex = 50,
            Parent = frame,
        })

        local container = self.window:Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(170, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = frame,
        })

        self.window:Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = container,
        })

        local checkIcon = self.window:Create("ImageLabel", {
            Image = "rbxassetid://" .. tostring(checkIcon),
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            ZIndex = 5,
            Parent = container,
        }, { ImageColor3 = "ContentColor" })

        local title = self.window:Create("TextLabel", {
            Text = optionName,
            Size = UDim2.fromOffset(170, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,
            TextTransparency = 1,
            ZIndex = 5,
            Parent = container,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })

        local data = {
            name = optionName,
            frame = frame,
            interact = interact,
            title = title,
            checkIcon = checkIcon,
            container = container,
            stroke = optionStroke,
            corner = corner,
            -- tracked per option so a rebuild tears them down with the frame
            connections = {},
        }

        table.insert(
            data.connections,
            self.window:ConnectFor(self, frame.MouseEnter, function()
                if not self._isOpen or not self.window:_interactive() then
                    return
                end
                if isOptionSelected(data.name) then
                    return
                end
                variables.tweenService
                    :Create(
                        frame,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { BackgroundTransparency = 0.9 }
                    )
                    :Play()
                variables.tweenService
                    :Create(
                        title,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { TextTransparency = 0.15 }
                    )
                    :Play()
            end)
        )

        table.insert(
            data.connections,
            self.window:ConnectFor(self, frame.MouseLeave, function()
                if not self._isOpen then
                    return
                end
                if isOptionSelected(data.name) then
                    return
                end
                variables.tweenService
                    :Create(
                        frame,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { BackgroundTransparency = 0.95 }
                    )
                    :Play()
                variables.tweenService
                    :Create(
                        title,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { TextTransparency = 0.3 }
                    )
                    :Play()
            end)
        )

        table.insert(
            data.connections,
            self.window:ConnectFor(self, interact.MouseButton1Click, function()
                -- options stay visible through the close tween; a click mid-fade must not land
                if not self._isOpen then
                    return
                end
                hapticEngine.click()
                local sel = isOptionSelected(data.name)

                if not self.multiSelect then
                    if sel then
                        self:_close()
                        return
                    end
                    table.clear(self.value)
                    table.insert(self.value, data.name)
                else
                    if sel then
                        local idx = table.find(self.value, data.name)
                        if idx then
                            table.remove(self.value, idx)
                        end
                    else
                        table.insert(self.value, data.name)
                    end
                end

                -- the visible selection is now the player's intent; a later Refresh must build
                -- on this, not revert to whatever was restored before they touched it
                self._desiredValue = table.clone(self.value)

                for _, d in self._optionFrames do
                    renderOptionState(d, true)
                end

                updateSelectedLabel()

                self.window:_runGuarded(self, self.callback, self:_callbackValue())
                self.window:_persist(self)

                if not self.multiSelect then
                    task.wait(0.1)
                    self:_close()
                end
            end)
        )

        return data
    end

    self._buildOption = buildOption

    for _, opt in self.options do
        local data = buildOption(opt)
        table.insert(self._optionFrames, data)
    end

    updateSelectedLabel()
    self:_updateCorners()

    -- Function
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        if self._isOpen then
            self:_close()
        else
            self:_open()
        end
    end)

    -- Hover feedback: overlay, title and stroke, the same lift Window:_wireElementHover gives
    -- every other element, colour included.
    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if self._isOpen or not self.window:_interactive() then
            return
        end
        variables.tweenService
            :Create(self.title, hoverTween, { TextColor3 = self.window.theme.ElementTextHoverColor })
            :Play()
        variables.tweenService:Create(self.hoverOverlay, hoverTween, { BackgroundTransparency = 0.97 }):Play()
        variables.tweenService
            :Create(self.stroke, hoverTween, {
                Transparency = self.window.theme.ElementStrokeHoverTransparency,
                Color = self.window.theme.ElementStrokeHover,
            })
            :Play()
    end)

    self.window:ConnectFor(self, self.main.MouseLeave, function()
        variables.tweenService:Create(self.title, hoverTween, { TextColor3 = self.window.theme.ContentColor }):Play()
        variables.tweenService:Create(self.hoverOverlay, hoverTween, { BackgroundTransparency = 1 }):Play()
        variables.tweenService
            :Create(self.stroke, hoverTween, {
                Transparency = self.window.theme.ElementStrokeTransparency,
                Color = self.window.theme.ElementStroke,
            })
            :Play()
    end)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    return self
end

-- Search bar: collapsed it's just the icon (centred, no bar); tapping expands it into a
-- full field. It's always in the card's layout - only its height/fills animate - so the
-- list below just flexes down as it grows.
-- what the dev's callback receives. multiSelect hands out a copy: the live table is our
-- selection state, and a dev who keeps or mutates it would corrupt the dropdown.
function Dropdown:_callbackValue()
    if self.multiSelect then
        return table.clone(self.value)
    end
    return self.value[1]
end

function Dropdown:_buildSearch()
    self._searchOpen = false

    self.searchbar = self.window:Create("Frame", {
        Name = "Search",
        Size = UDim2.new(1, -12, 0, searchCollapsedHeight),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1, -- expanded = 0.92
        LayoutOrder = 1,
        ClipsDescendants = false,
        ZIndex = 1,

        Parent = self.panel,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self.searchbar,
    })

    self.searchStroke = self.window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- expanded = 0.86
        Parent = self.searchbar,
    })

    self.searchShadow = self.window:CreateGlow(self.searchbar, Color3.fromRGB(255, 255, 255), 20, 1) -- expanded = 0.92

    -- Full-bar tap target: expands the bar while it's collapsed. Kept above the option
    -- hit-targets (ZIndex 50) so taps here never bleed through to an option under them.
    self.searchToggle = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextTransparency = 1,
        ZIndex = 51,
        Parent = self.searchbar,
    })

    self.searchInput = self.window:Create("TextBox", {
        Text = "",
        PlaceholderText = locale.t("Search..."),
        Size = UDim2.new(1, -58, 0, 16),
        Position = UDim2.new(0, 44, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        TextEditable = false, -- enabled on expand
        Interactable = false, -- collapsed: let taps fall through to the toggle
        ZIndex = 52,

        TextTransparency = 1, -- expanded = 0.3

        Parent = self.searchbar,
    }, { TextColor3 = "ContentColor", FontFace = "Font", PlaceholderColor3 = "PlaceholderColor" })

    self.searchIcon = self.window:Create("ImageButton", {
        Image = "rbxassetid://" .. tostring(searchIconAsset),
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(0, 24, 0.5, 0), -- left-aligned (centre at x=24, edge at 14)
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        AutoButtonColor = false,
        ZIndex = 53,

        ImageTransparency = 1, -- In = 0.5

        Parent = self.searchbar,
    }, { ImageColor3 = "ContentColor" })

    self.window:ConnectFor(self, self.searchToggle.MouseButton1Click, function()
        if not self._searchOpen then
            self:_expandSearch()
        end
    end)
    self.window:ConnectFor(self, self.searchIcon.MouseButton1Click, function()
        if self._searchOpen then
            self:_collapseSearch()
        else
            self:_expandSearch()
        end
    end)
    self.window:ConnectFor(self, self.searchInput:GetPropertyChangedSignal("Text"), function()
        self:_applyFilter(self.searchInput.Text)
    end)
    self.window:ConnectFor(self, self.searchInput.FocusLost, function()
        if self.searchInput.Text == "" then
            self:_collapseSearch()
        end
    end)
end

function Dropdown:_expandSearch()
    if self._searchOpen then
        return
    end
    self._searchOpen = true
    self.searchInput.TextEditable = true
    self.searchInput.Interactable = true

    variables.tweenService
        :Create(
            self.searchbar,
            searchTween,
            { Size = UDim2.new(1, -12, 0, searchExpandedHeight), BackgroundTransparency = 0.92 }
        )
        :Play()
    variables.tweenService:Create(self.searchStroke, searchTween, { Transparency = 0.86 }):Play()
    variables.tweenService:Create(self.searchShadow, searchTween, { Transparency = 0.92 }):Play()
    variables.tweenService:Create(self.searchInput, searchTween, { TextTransparency = 0.3 }):Play()

    self:_resizeToOptions() -- the bar is taller now, so the card owes it the difference
    self.searchInput:CaptureFocus()
end

function Dropdown:_collapseSearch()
    if not self._searchOpen then
        return
    end
    self._searchOpen = false
    self.searchInput.TextEditable = false
    self.searchInput.Interactable = false
    self.searchInput:ReleaseFocus()
    self.searchInput.Text = "" -- fires the filter, showing everything again

    variables.tweenService
        :Create(
            self.searchbar,
            searchTween,
            { Size = UDim2.new(1, -12, 0, searchCollapsedHeight), BackgroundTransparency = 1 }
        )
        :Play()
    variables.tweenService:Create(self.searchStroke, searchTween, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.searchShadow, searchTween, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.searchInput, searchTween, { TextTransparency = 1 }):Play()

    self:_resizeToOptions()
end

function Dropdown:_applyFilter(query)
    query = string.lower(query or "")
    local shown = 0
    for _, data in self._optionFrames do
        local visible = query == "" or string.find(string.lower(data.name), query, 1, true) ~= nil
        data.frame.Visible = visible
        if visible then
            shown += 1
        end
    end

    -- only a search that found nothing gets told so. A dropdown built with no options, or one
    -- emptied by Refresh, is a list waiting to be filled rather than a failed search.
    self.emptyLabel.Visible = shown == 0 and query ~= ""
    self:_updateCorners()
    self:_resizeToOptions()
    self:_syncScrollHint()
end

-- Show the scrollbar only while there is list left to reach. Measured rather than assumed: a
-- filter can take a list that was scrolling down to two rows that arent.
function Dropdown:_syncScrollHint()
    -- a list that has not been laid out yet has nothing to measure, and nothing to hide either
    local canvasSize, windowSize, at =
        self.list.AbsoluteCanvasSize, self.list.AbsoluteWindowSize, self.list.CanvasPosition
    if not canvasSize or not windowSize or not at then
        return
    end

    local more = self._isOpen and windowSize.Y > 0 and canvasSize.Y - (at.Y + windowSize.Y) > 1

    variables.tweenService
        :Create(self.list, hintTween, { ScrollBarImageTransparency = if more then scrollbarShown else 1 })
        :Play()
end

-- Every option the search is currently letting through, which is what a bulk action applies to:
-- selecting all of a filtered list should not quietly take the ones it is hiding as well.
function Dropdown:_visibleOptions(): { string }
    local names = {}
    for _, data in self._optionFrames do
        if data.frame.Visible then
            table.insert(names, data.name)
        end
    end
    return names
end

function Dropdown:_buildActions()
    if not self.multiSelect then
        return -- one choice at a time has nothing to select all of
    end

    self.actions = self.window:Create("Frame", {
        Name = "Actions",
        Size = UDim2.new(1, -12, 0, actionsHeight),
        BackgroundTransparency = 1,
        LayoutOrder = 2,

        Parent = self.panel,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.actions,
    })

    local function action(label: string, order: number, apply: () -> ())
        local button = self.window:Create("TextButton", {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, actionsHeight),
            BackgroundTransparency = 1,
            Text = locale.t(label),
            TextSize = 13,
            TextTransparency = 0.45, -- hovered = 0.15
            LayoutOrder = order,

            Parent = self.actions,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })

        self.window:ConnectFor(self, button.MouseEnter, function()
            variables.tweenService:Create(button, hintTween, { TextTransparency = 0.15 }):Play()
        end)
        self.window:ConnectFor(self, button.MouseLeave, function()
            variables.tweenService:Create(button, hintTween, { TextTransparency = 0.45 }):Play()
        end)
        self.window:ConnectFor(self, button.MouseButton1Click, function()
            apply()
            self:_afterBulkChange()
        end)

        return button
    end

    -- Both act on what the search is showing and leave the rest of the selection alone. Taking
    -- the visible list wholesale would drop every hidden pick, so a filter would quietly unselect
    -- what it was hiding, which is worse than not being able to select at all.
    action("Select all", 1, function()
        local shown = self:_visibleOptions()
        for _, name in shown do
            if not table.find(self.value, name) then
                table.insert(self.value, name)
            end
        end
    end)
    action("Clear", 2, function()
        local shown = self:_visibleOptions()
        for index = #self.value, 1, -1 do
            if table.find(shown, self.value[index]) then
                table.remove(self.value, index)
            end
        end
    end)
end

-- The tail every bulk action shares: repaint the rows, say what is selected, tell the dev, save.
function Dropdown:_afterBulkChange()
    -- the selection the player just made is the intent now, the same as a click on a row. Without
    -- this a later Refresh rebuilds from the old intent and undoes the whole bulk change.
    self._desiredValue = table.clone(self.value)

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end
    self:_updateSelectedLabel()
    self:_updateCorners()
    self.window:_runGuarded(self, self.callback, self:_callbackValue())
    self.window:_persist(self)
    hapticEngine.click()
end

-- match the panel to whats visible. only while open: closed height is the header alone.
function Dropdown:_resizeToOptions()
    if not self._isOpen then
        return
    end
    variables.tweenService:Create(self.main, searchTween, { Size = UDim2.new(1, -20, 0, self:_openHeight()) }):Play()
end

-- Per-corner rounding: an option's top corners round off only when nothing sits above it,
-- and its bottom corners only when nothing sits below - so a run of options reads as one
-- grouped block with rounded outer edges and sharp seams (a lone option is fully rounded).
-- Runs over the currently VISIBLE options, so it re-groups correctly while searching.
function Dropdown:_updateCorners()
    local visible = {}
    for _, data in self._optionFrames do
        if data.frame.Visible then
            table.insert(visible, data)
        end
    end

    for i, data in visible do
        local topR = if i == 1 then roundRadius else flatRadius
        local botR = if i == #visible then roundRadius else flatRadius
        data.corner.TopLeftRadius = topR
        data.corner.TopRightRadius = topR
        data.corner.BottomLeftRadius = botR
        data.corner.BottomRightRadius = botR
    end
end

local function listHeight(count: number): number
    return count * optionHeight + math.max(0, count - 1) * optionGap + listPadding * 2
end

-- How many rows a given slice of list fits, at least one: a card with no room to show an
-- option is not a dropdown.
local function rowsThatFit(space: number): number
    return math.max(math.floor((space - listPadding * 2 + optionGap) / (optionHeight + optionGap)), 1)
end

-- The height the page can show. The window keeps its own size current with the screen, the
-- elements frame is that less the chrome above it, and the tab page fills it - so this is the
-- page's height without waiting on a layout pass to measure one.
function Dropdown:_pageHeight(): number
    local size = self.window.size
    return windowSizing.pageHeight(size and size.Y.Offset, self.window.layout.mode)
end

-- Open height sized to the options on screen (header + search + paddings + rows), so a search
-- filter or an Add/Remove while open grows and shrinks the card to fit. Capped at whichever
-- comes first: four rows, or what the page can actually show - a card taller than the page it
-- sits on cant be scrolled into view, it just runs off both ends.
function Dropdown:_openHeight()
    local n = 0
    for _, data in self._optionFrames do
        if data.frame.Visible then
            n += 1
        end
    end

    -- the search bar grows when it takes focus, so the card owes it the difference. Without
    -- that the list is pushed down and its last row goes over the card's own edge.
    local searchHeight = if self._searchOpen then searchExpandedHeight else searchCollapsedHeight
    local overhead = headerHeight
        + headerGap
        + cardPadding
        + searchHeight
        + optionGap
        + (if self.actions then actionsHeight + optionGap else 0)

    local available = self:_pageHeight()
    -- a search that matches nothing still has a line to say so, so one row is the floor
    local rows = math.min(math.max(n, 1), maxVisibleOptions, rowsThatFit(available - overhead))

    return math.min(overhead + listHeight(rows), available)
end

function Dropdown:_open()
    if self._isOpen then
        return
    end
    self._isOpen = true

    if self._outsideClickConn then
        self.window:Disconnect(self._outsideClickConn)
    end
    self._outsideClickConn = self.window:Connect(variables.userInputService.InputBegan, function(input)
        if
            input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local pos = input.Position
        local mainPos = self.main.AbsolutePosition
        local mainSize = self.main.AbsoluteSize
        if
            pos.X < mainPos.X
            or pos.X > mainPos.X + mainSize.X
            or pos.Y < mainPos.Y
            or pos.Y > mainPos.Y + mainSize.Y
        then
            self:_close()
        end
    end)

    variables.tweenService
        :Create(
            self.main,
            TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Size = UDim2.new(1, -20, 0, self:_openHeight()) }
        )
        :Play()
    variables.tweenService
        :Create(
            self.chevron,
            TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Rotation = 0 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.panel,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundTransparency = self.window.theme.ElementTransparency or 0 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.panelStroke,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Transparency = self.window.theme.ElementStrokeTransparency }
        )
        :Play()
    variables.tweenService
        :Create(
            self.searchIcon,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { ImageTransparency = 0.5 }
        )
        :Play()

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end

    self:_syncScrollHint()
    self:_bringIntoView()
end

-- A card low down a page opens into whatever is below the fold, and the options it just showed
-- are off screen. Rather than flip it above the header, which only moves the problem to the top
-- edge, the page comes to it: scroll just far enough that the open card ends inside the view.
function Dropdown:_bringIntoView()
    local page = self.tab and self.tab.tabPage
    if not page then
        return
    end

    -- a page that has not been laid out has no view to fit anything into yet
    local view, at, pageAt, cardAt =
        page.AbsoluteWindowSize, page.CanvasPosition, page.AbsolutePosition, self.main.AbsolutePosition
    if not view or not at or not pageAt or not cardAt or view.Y <= 0 then
        return
    end

    -- measured against the canvas, not the screen, so it does not matter where the window is
    local top = cardAt.Y - pageAt.Y + at.Y
    local bottom = top + self:_openHeight()
    local overflow = bottom - (at.Y + view.Y)
    if overflow <= 0 then
        return -- it already ends inside the view
    end

    -- never past the card's own top. The open height is capped to the page (_openHeight), so
    -- the card always fits once it's scrolled to, and this only ever trims the 8px of room.
    local target = math.min(at.Y + overflow + 8, top)
    variables.tweenService
        :Create(page, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(at.X, target),
        })
        :Play()
end

function Dropdown:_close()
    if not self._isOpen then
        return
    end
    self._isOpen = false

    if self._outsideClickConn then
        self.window:Disconnect(self._outsideClickConn)
        self._outsideClickConn = nil
    end

    self:_collapseSearch()
    self:_syncScrollHint()

    variables.tweenService
        :Create(
            self.chevron,
            TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Rotation = 180 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.panel,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundTransparency = 1 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.panelStroke,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Transparency = 1 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.searchIcon,
            TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { ImageTransparency = 1 }
        )
        :Play()

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end

    variables.tweenService
        :Create(
            self.main,
            TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Size = UDim2.new(1, -20, 0, 41) }
        )
        :Play()
end

-- tear an option down through the window registries, so rebuild churn doesnt leak tracked
-- instances (which would slow ChangeTheme forever) or dead connections
function Dropdown:_destroyOption(data)
    if data.connections then
        for _, connection in data.connections do
            local idx = table.find(self.connections, connection)
            if idx then
                table.remove(self.connections, idx)
            end
            self.window:Disconnect(connection)
        end
        data.connections = nil
    end
    self.window:DestroySubtree(data.frame)
end

-- re-derive the visible selection from the full intent: an option that loads now (or
-- comes back) re-selects, one that's genuinely gone drops out. self.value only ever holds
-- real options, so the saved config never carries a stale selection across sessions.
function Dropdown:_deriveSelection()
    local previous = self.value
    self.value = intersectWithOptions(self._desiredValue or self.value, self.options)
    return not sameSelection(self.value, previous)
end

-- Put every row's LayoutOrder back in step with its index. Removing from the middle leaves
-- gaps, and a later Add takes its order from the row count, so without this a new option can
-- land in a gap rather than at the end.
function Dropdown:_reindexOptions()
    for index, data in self._optionFrames do
        data.frame.LayoutOrder = index
    end
end

-- Point an existing row at a different option. Everything that reads the option reads
-- data.name, so this is the whole of it; the row keeps its instances and its connections.
function Dropdown:_rebindOption(data, name, index)
    data.name = name
    data.title.Text = name
    data.frame.LayoutOrder = index
end

-- Tear down every row from `first` on, in one pass. One at a time means re-walking the
-- window's whole instance list per row, which is what makes a big shrink expensive.
function Dropdown:_destroyOptionsFrom(first)
    local roots, connections = {}, {}

    for index = #self._optionFrames, first, -1 do
        local data = self._optionFrames[index]
        table.insert(roots, data.frame)
        if data.connections then
            table.move(data.connections, 1, #data.connections, #connections + 1, connections)
            data.connections = nil
        end
        self._optionFrames[index] = nil
    end

    self.window:DisconnectMany(self, connections)
    self.window:DestroySubtrees(roots)
end

function Dropdown:Refresh(newOptions)
    self.options = dedupStrings(newOptions or {})

    local selectionChanged = self:_deriveSelection()

    -- Rows are reused rather than torn down and rebuilt. Rebuilding a long list is the
    -- expensive part by a wide margin, and it is pure waste when the row that would be
    -- destroyed is identical to the one about to take its place.
    local existing = #self._optionFrames
    local wanted = #self.options

    for index = 1, math.min(existing, wanted) do
        self:_rebindOption(self._optionFrames[index], self.options[index], index)
    end

    for index = existing + 1, wanted do
        local data = self._buildOption(self.options[index])
        data.frame.LayoutOrder = index
        table.insert(self._optionFrames, data)
    end

    if wanted < existing then
        self:_destroyOptionsFrom(wanted + 1)
    end

    -- every row, reused or new: its selection may have moved, and a reused one may have been
    -- left mid-hover. Closed paints exactly what a freshly built row starts at, so this is
    -- right either way round.
    for _, data in self._optionFrames do
        self._renderOptionState(data, false)
    end

    self._updateSelectedLabel()
    -- reconcile with any active search (also refreshes corners); empty query shows all
    self:_applyFilter(if self._searchOpen then self.searchInput.Text else "")

    -- the visible selection changed (options arrived or dropped): tell the dev and save it
    if selectionChanged then
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end
end

function Dropdown:Add(option)
    if typeof(option) ~= "string" or option == "" then
        return
    end
    if table.find(self.options, option) then
        return
    end

    table.insert(self.options, option)
    local data = self._buildOption(option)
    table.insert(self._optionFrames, data)

    -- the new option may satisfy pending intent from an earlier Set or config load
    local selectionChanged = self:_deriveSelection()

    if self._isOpen then
        self._renderOptionState(data, true)
    end

    -- reconcile with any active search rather than showing an option the query excludes,
    -- and resize for the new row (also refreshes corners)
    self:_applyFilter(if self._searchOpen then self.searchInput.Text else "")

    -- the visible selection changed (the pending option arrived): tell the dev and save it
    if selectionChanged then
        self._updateSelectedLabel()
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end
end

function Dropdown:Remove(option)
    local idx = table.find(self.options, option)
    if not idx then
        return
    end

    table.remove(self.options, idx)

    for i, data in self._optionFrames do
        if data.name == option then
            self:_destroyOption(data)
            table.remove(self._optionFrames, i)
            self:_reindexOptions()
            break
        end
    end

    -- drop the removed option from the pending intent too, but leave intent for options
    -- that just aren't present right now so they can still restore later
    if self._desiredValue then
        local desiredIdx = table.find(self._desiredValue, option)
        if desiredIdx then
            table.remove(self._desiredValue, desiredIdx)
        end
    end

    local valueIdx = table.find(self.value, option)
    if valueIdx then
        table.remove(self.value, valueIdx)
        self._updateSelectedLabel()
        -- removing a selected option changes the selection; surface and save that
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end

    -- one row shorter; resize and re-corner around whats left
    self:_applyFilter(if self._searchOpen then self.searchInput.Text else "")
end

function Dropdown:Set(value, skipCallback)
    local newValue = normalizeValue(value, self.multiSelect)
    -- keep the full request so options that arrive later can restore it (see Refresh)
    self._desiredValue = newValue
    self.value = intersectWithOptions(newValue, self.options)

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end
    self._updateSelectedLabel()

    if not skipCallback then
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self) -- skipCallback means apply quietly, so dont autosave either
    end
end

function Dropdown:_setShown(shown, animate)
    -- Custom reveal: main is a transparent wrapper, so reveal the header card (self.top)
    -- rather than main. The options card fades in on open, not here.
    local w = self.window
    w:_reveal(self.stroke, { Transparency = if shown then w.theme.ElementStrokeTransparency else 1 }, animate)
    w:_reveal(self.title, { TextTransparency = if shown then 0 else 1 }, animate)
    w:_reveal(self.top, { BackgroundTransparency = if shown then (w.theme.ElementTransparency or 0) else 1 }, animate)
    if self.iconLabel then
        w:_reveal(self.iconLabel, { ImageTransparency = if shown then 0 else 1 }, animate)
    end
    if self.descriptor then
        w:_reveal(self.descriptor.titleLabel, { TextTransparency = if shown then 0.7 else 1 }, animate)
    end
    w:_reveal(self.selectedLabel, { TextTransparency = if shown then 0.5 else 1 }, animate)
    w:_reveal(self.chevron, { ImageTransparency = if shown then 0.5 else 1 }, animate)

    -- if the window hides while we're open, collapse so we dont reopen mid-air
    if not shown and self._isOpen then
        self:_close()
    end
end

function Dropdown:MoveTo(index)
    self.tab:_moveElement(self, index)
end

function Dropdown:MoveToTop()
    self.tab:_moveElement(self, 1)
end

function Dropdown:MoveToBottom()
    self.tab:_moveElement(self, #self.tab.elements)
end

function Dropdown:MoveUp()
    local idx = table.find(self.tab.elements, self)
    if idx then
        self.tab:_moveElement(self, idx - 1)
    end
end

function Dropdown:MoveDown()
    local idx = table.find(self.tab.elements, self)
    if idx then
        self.tab:_moveElement(self, idx + 1)
    end
end

lockable(Dropdown)

return Dropdown

end)() end,
    [12] = function()local wax,script,require=ImportGlobals(12)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Group = {}
Group.__index = Group
Group.__type = "Group"

-- A layout container. Lays its children along one axis and nests, so a row of columns
-- gives you a grid. A row wraps when it runs out of width instead of shrinking forever.
-- Mimics the Tab fields components read (window, tabPage, elements, compact, direction,
-- _moveElement) so the exact same element code builds inside it, and flags still register
-- on window.controls through the nesting.
--
-- row    -> children build compact and share the width, wrapping to new rows as needed
-- column -> children build full width, stacked top to bottom, and also take the full-only
--           elements (dropdown, section, text, divider)
-- The public API calls these "row"/"column"; "horizontal"/"vertical" work too.

local moveable = require(script.Parent.Parent.utility.moveable)
local log = require(script.Parent.Parent.utility.log)
local assignOrder = require(script.Parent.Parent.utility.ordering)

local elementPadding = 8

-- these render fine side by side in a row: the compact builds (button/toggle/stat) and
-- the slider (it reflows to its narrow layout). dropdown/section/text/divider stay full-only.
local compactCapable = {
    button = true,
    toggle = true,
    stat = true,
    slider = true,
}

function Group.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local dir = string.lower(properties.direction or properties.Direction or "row")
    local vertical = dir == "column" or dir == "vertical"
    local horizontal = not vertical
    local direction = if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"), -- host: a Tab or a parent Group
        window = tab.window,
        direction = direction,
        compact = horizontal, -- row children pack side by side
        forgetState = tab.forgetState, -- inherit the host's config-persistence stance
        elements = {},
    }, Group)

    -- if our host is a row we're a column, so we hand our width to its flex
    local nestedInRow = tab.direction == Enum.FillDirection.Horizontal

    self.main = self.window:Create("Frame", {
        Name = "Group",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        -- row matches a normal element's inset (1,-20). column is full width so its
        -- full-build children (1,-20) line up with the rest of the tab.
        Size = if horizontal then UDim2.new(1, -20, 0, 0) else UDim2.new(1, 0, 0, 0),

        Parent = self.tab.tabPage,
    })

    if nestedInRow then
        -- let the parent row divide its width between columns
        self.main.Size = UDim2.new(0, 0, 0, 0)
        self.window:Create("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Fill,
            Parent = self.main,
        })
    end

    -- children parent here
    self.tabPage = self.main

    self.layout = self.window:Create("UIListLayout", {
        FillDirection = direction,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, elementPadding),
        VerticalAlignment = if horizontal then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Top,
        HorizontalAlignment = if horizontal then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center,

        Parent = self.main,
    })

    return self
end

function Group:_add(componentName, properties)
    if self.compact and not compactCapable[componentName] then
        log.warn(
            `Rayfield: a row only holds compact elements (button/toggle/stat/slider), ignoring '{componentName}'. Use a column for it.`
        )
        return nil
    end

    local element = require(script.Parent[componentName]).new(self, properties)
    table.insert(self.elements, element)
    assignOrder(element, #self.elements * 10)
    self.window:_restoreLate(element)

    if self.compact then
        self:_wrapChild(element)
    end
    self:_reflowRow() -- a leaf landing in a row of columns has to widen the gap back out

    -- same as Tab:_register: elements added after Window:Show must be revealed here
    -- or they stay fully transparent
    if not self.window.hidden then
        element:_setShown(true, true)
    end

    return element
end

-- Padding is one property for the whole row, so it has to suit whatever the row ends up
-- holding. Columns carry their own 10px side margin (the 1,-20), so where two meet the gutter
-- is 10+10=20, twice the 10px outer margin - pull them together by one margin's worth to match.
-- Leaves carry no margin, so the same pull would just overlap them: a row holding any leaf
-- keeps the leaf gap and lets the columns sit a touch wider apart.
function Group:_reflowRow()
    if self.direction ~= Enum.FillDirection.Horizontal then
        return
    end

    local onlyGroups = #self.elements > 0
    for _, element in self.elements do
        if element.__type ~= "Group" then
            onlyGroups = false
            break
        end
    end

    self.layout.Padding = if onlyGroups then UDim.new(0, -10) else UDim.new(0, elementPadding)
end

-- A row wraps instead of shrinking forever. Each child is frozen to the width it actually
-- needs (element:_minWidth counts its icon, text, control + padding), so the row breaks on
-- real bounds, and HorizontalFlex grows each row's items to fill it.
function Group:_wrapChild(element)
    self.layout.Wraps = true
    self.layout.HorizontalFlex = Enum.UIFlexAlignment.Fill

    -- tells a width-owning element (the slider) that we drive its width now, so its own
    -- reflow stops fighting us. plain compact elements ignore the flag.
    element._widthManaged = true

    local minWidth = if element._minWidth then element:_minWidth() else 0
    if minWidth > 0 then
        element.main.AutomaticSize = Enum.AutomaticSize.None
        element.main.Size = UDim2.new(0, minWidth, element.main.Size.Y.Scale, element.main.Size.Y.Offset)
    end
end

function Group:CreateButton(properties)
    return self:_add("button", properties)
end
function Group:CreateToggle(properties)
    return self:_add("toggle", properties)
end
function Group:CreateSwitch(properties)
    return self:_add("toggle", properties)
end
function Group:CreateStat(properties)
    return self:_add("stat", properties)
end
function Group:CreateSlider(properties)
    return self:_add("slider", properties)
end
function Group:CreateDropdown(properties)
    return self:_add("dropdown", properties)
end
function Group:CreateSection(properties)
    return self:_add("section", properties)
end
function Group:CreateText(properties)
    return self:_add("text", properties)
end
function Group:CreateDivider(properties)
    return self:_add("divider", properties)
end

-- a nested group: a column (for a grid) or another row inside this one
function Group:_addGroup(properties)
    properties = if typeof(properties) == "table" then table.clone(properties) else {}

    -- adapt a row that's about to hold columns instead of compact leaves:
    if self.direction == Enum.FillDirection.Horizontal then
        -- top-align, not centre: a column growing (e.g. a dropdown opening) must push down,
        -- not re-centre and shove the other column around.
        self.layout.VerticalAlignment = Enum.VerticalAlignment.Top
        -- full width (unless we're ourselves a nested column sharing a parent's flex) so
        -- column content lines up with the tab's normal elements instead of sitting 10px in.
        if self.tab.direction ~= Enum.FillDirection.Horizontal then
            self.main.Size = UDim2.new(1, 0, 0, 0)
        end
    end

    local group = Group.new(self, properties)
    table.insert(self.elements, group)
    group.main.LayoutOrder = #self.elements * 10
    self:_reflowRow()
    return group
end

function Group:CreateGroup(properties)
    return self:_addGroup(properties)
end

-- reorder a child within this group
function Group:_moveElement(element, targetIndex)
    local idx = table.find(self.elements, element)
    if not idx then
        return
    end
    table.remove(self.elements, idx)
    targetIndex = math.clamp(targetIndex, 1, #self.elements + 1)
    table.insert(self.elements, targetIndex, element)
    for i, el in self.elements do
        assignOrder(el, i * 10)
    end
end

-- children live in group.elements, not tab.elements, so forward the reveal down.
-- nested groups forward it again, so a whole grid reveals in one call.
function Group:_setShown(shown, animate)
    for _, el in self.elements do
        el:_setShown(shown, animate)
    end
end

-- same reason: forward a runtime theme refresh down to the children (nested groups recurse).
function Group:_refreshTheme()
    for _, el in self.elements do
        if el._refreshTheme then
            el:_refreshTheme()
        end
    end
end

-- reorder the group within its host
moveable(Group)

return Group

end)() end,
    [13] = function()local wax,script,require=ImportGlobals(13)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Input = {}
Input.__index = Input
Input.__type = "Input"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local constants = require(utility.constants)
local hapticEngine = require(utility.HapticEngine)

local resizeInfo = constants.pillResizeInfo
-- text is muted at rest, opaque while typing
local focusInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Parse a simple exponent expression like "5^3" → 125. Falls back to tonumber for
-- plain numbers and scientific notation ("9e9" → 9000000000).
local function parseExp(text)
    local a, b = text:match("^([%d%.%-]+)%^([%d%.%-]+)$")
    if a and b then
        local na, nb = tonumber(a), tonumber(b)
        if na and nb then
            return na ^ nb
        end
    end
    return tonumber(text)
end

function Input.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Input",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        placeholder = properties.placeholder or properties.Placeholder or "",
        numeric = properties.numeric or properties.Numeric or false, -- strip anything not a number
        clearOnFocus = properties.clearOnFocus or properties.ClearOnFocus or false,

        callback = properties.callback or properties.Callback or function() end,
    }, Input)

    self.value =
        tostring(properties.value or properties.Value or properties.currentValue or properties.CurrentValue or "")

    self.flag = properties.flag
        or properties.Flag
        or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)
    self.window:_registerControl(self)

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)

    -- Left: title (+ icon)
    self.container = self.window:Create("Frame", {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,

            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- Right: the field. A faint white pill pinned to the right that hugs its text.
    self.box = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0, 20),
        Size = UDim2.fromOffset(85, 30),
        BorderSizePixel = 0,

        BackgroundTransparency = 1, -- In = FieldTransparency

        Parent = self.main,
    }, { BackgroundColor3 = "FieldBackground" })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.box,
    })

    self.boxStroke = self.window:Create("UIStroke", {
        Transparency = 1, -- In = 0.85

        Parent = self.box,
    }, { Color = "SurfaceStroke" })

    -- glow behind the box, invisible until a set flashes it green/red
    self.glow = self.window:CreateGlow(self.box, "FieldGlow", 20, 1)
    self._glowIdle = 1 -- glow hidden at rest (used by the set-result flash)

    self.input = self.window:Create("TextBox", {
        Text = self.value,
        PlaceholderText = locale.t(self.placeholder),
        Size = UDim2.new(1, -15, 0, 15),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ClearTextOnFocus = self.clearOnFocus,

        TextTransparency = 1, -- In = 0.6

        Parent = self.box,
    }, { TextColor3 = "ContentColor", FontFace = "Font", PlaceholderColor3 = "PlaceholderColor" })

    -- resize to hug the text; numeric mode also strips non-number chars as they're typed
    self.window:ConnectFor(self, self.input:GetPropertyChangedSignal("Text"), function()
        if self.numeric then
            local cleaned = (self.input.Text:gsub("[^%d%.%-eE%^]", ""))
            if cleaned ~= self.input.Text then
                self.input.Text = cleaned
                return -- the reassignment re-fires this, we size on that pass
            end
        end
        self:_sizeBox(true)
    end)

    -- opaque while the field is focused, back to muted when you click away
    self.window:ConnectFor(self, self.input.Focused, function()
        variables.tweenService:Create(self.input, focusInfo, { TextTransparency = 0 }):Play()
    end)

    -- commit on focus loss (enter or click away)
    self.window:ConnectFor(self, self.input.FocusLost, function()
        variables.tweenService:Create(self.input, focusInfo, { TextTransparency = 0.6 }):Play()
        -- clearOnFocus blanks the box on focus, so a click in and straight back out would
        -- commit "" over a good value. nothing typed means nothing to commit.
        if self.clearOnFocus and self.input.Text == "" and self.value ~= "" then
            self.input.Text = self.value
            return
        end
        if self.input.Text == self.value then
            return -- unchanged: dont re-fire the devs callback for a stray click
        end
        self:_commit(self.input.Text)
    end)

    self.window:_wireElementHover(self)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    self:_sizeBox(false) -- initial hug, no animation

    return self
end

-- width the pill needs to hug its text (placeholder when empty), floored so it stays a
-- readable pill and capped so a long value can't run over the title
function Input:_sizeBox(animate)
    local shown = self.input.Text ~= "" and self.input.Text or self.placeholder
    local width = math.clamp(functions.textWidth(self.window.theme.Font, 15, shown) + 30, 70, 220)
    if animate then
        variables.tweenService:Create(self.box, resizeInfo, { Size = UDim2.fromOffset(width, 30) }):Play()
    else
        self.box.Size = UDim2.fromOffset(width, 30)
    end
end

-- store + fire the callback + autosave, shared by typing and :Set. silent skips the
-- callback/persist/flash so config loads restore quietly.
function Input:_commit(text, silent)
    text = tostring(text)
    if self.numeric then
        local n = parseExp(text)
        if not n or n ~= n or n == math.huge or n == -math.huge then
            -- invalid or non-finite number: revert the textbox to the previous value
            if self.input.Text ~= self.value then
                self.input.Text = self.value
            end
            return
        end
        text = tostring(n)
    end

    local changed = text ~= self.value
    self.value = text
    if self.input.Text ~= text then
        self.input.Text = text
    end

    if not silent then
        self.window:_runGuarded(self, self.callback, text)
        self.window:_persist(self)
        -- green flash to confirm the value landed (only when it actually changed, and not while a
        -- config restore is applying every field at once)
        if changed and not self.window._loading then
            hapticEngine.click()
            self.window:_flashResult(self, true)
        end
    end
end

function Input:Set(value, skipCallback)
    self:_commit(value, skipCallback)
end

function Input:_setShown(shown, animate)
    local w = self.window
    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.box, { BackgroundTransparency = w.theme.FieldTransparency }, animate)
        w:_reveal(self.boxStroke, { Transparency = 0.85 }, animate)
        w:_reveal(self.input, { TextTransparency = 0.6 }, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.box, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.boxStroke, { Transparency = 1 }, animate)
        w:_reveal(self.input, { TextTransparency = 1 }, animate)
    end
end

-- Re-apply the field's theme-driven fill transparency on a runtime ChangeTheme (its colour
-- rides a themeProperty). Called on the visible tab only, so the field is shown.
function Input:_refreshTheme()
    variables.tweenService
        :Create(
            self.box,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundTransparency = self.window.theme.FieldTransparency }
        )
        :Play()
end

moveable(Input)
lockable(Input)

return Input

end)() end,
    [14] = function()local wax,script,require=ImportGlobals(14)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Keybind = {}
Keybind.__index = Keybind
Keybind.__type = "Keybind"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local constants = require(utility.constants)
local hapticEngine = require(utility.HapticEngine)
local enums = require(utility.enums)
local log = require(utility.log)

local resizeInfo = constants.pillResizeInfo
local recordInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- shorter labels for the mouse buttons (KeyCodes already read fine)
local mouseNames = {
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
}

local function keyName(value)
    if typeof(value) ~= "EnumItem" or value == Enum.KeyCode.Unknown then
        return "None"
    end
    return mouseNames[value] or value.Name
end

-- accept an EnumItem, a KeyCode name, or a mouse button name, fall back to unbound.
-- mouse buttons bind like any other key, so a string has to reach them too.
local function coerceKey(value)
    if typeof(value) == "EnumItem" then
        return value
    end
    if type(value) == "string" then
        local ok, key = pcall(function()
            return Enum.KeyCode[value]
        end)
        if ok and key then
            return key
        end
        local mouseOk, button = pcall(function()
            return Enum.UserInputType[value]
        end)
        if mouseOk and button and mouseNames[button] then
            return button
        end
    end
    return Enum.KeyCode.Unknown
end

function Keybind.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Keybind",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,

        -- the settings' menu-toggle keybind. it drives settings.toggleKeybind, so its clash
        -- check runs the other way: reject keys an element keybind already owns.
        isMenuToggle = properties.isMenuToggle or properties.IsMenuToggle or false,

        -- fires when the bound key is pressed (or, in hold mode, with true/false)
        callback = properties.callback or properties.Callback or function() end,
        -- fires when the binding changes (rebind or :Set), gets the new key
        onChanged = properties.onChanged or properties.OnChanged or function() end,

        -- hold mode: callback(true) once the key survives holdThreshold, callback(false) on release.
        -- the threshold means a quick accidental tap fires nothing.
        hold = properties.hold or properties.Hold or false,
        holdThreshold = properties.holdThreshold or properties.HoldThreshold or 0.2,

        recording = false,
    }, Keybind)

    self.value = coerceKey(properties.value or properties.Value or properties.default or properties.Default)

    self.flag = properties.flag
        or properties.Flag
        or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)
    self.window:_registerControl(self)

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)

    -- Left: title (+ icon)
    self.container = self.window:Create("Frame", {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,

            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- Right: the key box. A faint white pill pinned right that hugs the key name.
    self.box = self.window:Create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0, 20),
        Size = UDim2.fromOffset(40, 30),
        AutoButtonColor = false,
        Text = "",
        BorderSizePixel = 0,

        BackgroundTransparency = 1, -- In = FieldTransparency

        Parent = self.main,
    }, { BackgroundColor3 = "FieldBackground" })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.box,
    })

    self.boxStroke = self.window:Create("UIStroke", {
        Transparency = 1, -- In = 0.85

        Parent = self.box,
    }, { Color = "SurfaceStroke" })

    -- soft white glow behind the box: 0.9 idle, 0.7 while recording
    self.glow = self.window:CreateGlow(self.box, "FieldGlow", 20, 1)
    self._glowIdle = 0.9 -- glow Transparency at rest (used by the set-result flash)

    self.keyLabel = self.window:Create("TextLabel", {
        Text = keyName(self.value),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 2,

        TextTransparency = 1, -- In = 0.6

        Parent = self.box,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.window:ConnectFor(self, self.box.MouseButton1Click, function()
        hapticEngine.click()
        if self.recording then
            self:_stopRecording()
        else
            self:_startRecording()
        end
    end)

    -- one persistent listener: captures the next key while recording, otherwise fires the
    -- callback when the bound key is pressed. `processed` is Roblox's gameProcessedEvent, true
    -- when the input was already consumed (typing in a box, core UI), so we skip it either way
    -- and keybinds never go off mid-type.
    self.window:ConnectFor(self, variables.userInputService.InputBegan, function(input, processed)
        if processed then
            return
        end
        if self.recording then
            self:_capture(input)
            return
        end
        -- another keybind is mid-rebind: the key being pressed is meant for it, dont let it
        -- also trigger us
        if self.window._recordingKeybind then
            return
        end
        if self:_matches(input) then
            if self.hold then
                self:_beginHold(input)
            else
                self.window:_runGuarded(self, self.callback, self.value)
            end
        end
    end)

    self.window:_wireElementHover(self)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    self:_sizeBox(false) -- initial hug, no animation

    return self
end

-- width the box needs to hug the current label, floored so a single key still reads as a pill
function Keybind:_sizeBox(animate)
    local width = math.clamp(functions.textWidth(self.window.theme.Font, 15, self.keyLabel.Text) + 28, 40, 200)
    if animate then
        variables.tweenService:Create(self.box, resizeInfo, { Size = UDim2.fromOffset(width, 30) }):Play()
    else
        self.box.Size = UDim2.fromOffset(width, 30)
    end
end

-- deepen the glow, light the label fully and prompt for a key
function Keybind:_startRecording()
    -- only one keybind records at a time; cancel whoever was listening before us
    local current = self.window._recordingKeybind
    if current and current ~= self then
        current:_stopRecording()
    end
    self.recording = true
    self.window._recordingKeybind = self -- window skips its toggle key while we listen
    self.keyLabel.Text = locale.resolve("Recording")
    self:_sizeBox(true)
    variables.tweenService:Create(self.glow, recordInfo, { Transparency = 0.7 }):Play()
    variables.tweenService:Create(self.keyLabel, recordInfo, { TextTransparency = 0 }):Play()
end

-- revert the glow + label and relabel to whatever value we ended up with
function Keybind:_stopRecording()
    self.recording = false
    -- clear next frame, not now: the key that stops us (a toggle-key clash) is still being
    -- dispatched, and the window's toggle listener may run after us. keep the flag up so it
    -- still bails instead of hiding the window on the same press.
    if self.window._recordingKeybind == self then
        local window = self.window
        task.defer(function()
            if window._recordingKeybind == self then
                window._recordingKeybind = nil
            end
        end)
    end
    self.keyLabel.Text = keyName(self.value)
    self:_sizeBox(true)
    variables.tweenService:Create(self.glow, recordInfo, { Transparency = 0.9 }):Play()
    variables.tweenService:Create(self.keyLabel, recordInfo, { TextTransparency = 0.6 }):Play()
end

-- capture the next input while recording. Esc cancels, Backspace clears, MB1 is the click
-- that opened us so it's ignored
function Keybind:_capture(input)
    local key
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape then
            self:_stopRecording()
            return
        end
        if input.KeyCode == Enum.KeyCode.Backspace then
            self:_bind(Enum.KeyCode.Unknown)
            return
        end
        key = input.KeyCode
    elseif
        input.UserInputType == Enum.UserInputType.MouseButton2
        or input.UserInputType == Enum.UserInputType.MouseButton3
    then
        key = input.UserInputType
    end
    if not key then
        return
    end

    if self.isMenuToggle then
        -- the menu toggle cant land on a key an element keybind already owns, else that press
        -- would both fire the element and open/close the window. bail and keep the old binding.
        local clash = self.window:_keybindUsing(key, self)
        if clash then
            self.window:Notify({
                title = locale.resolve("Keybind unavailable"),
                content = string.format(
                    locale.resolve("%s is bound to %s. Kept %s."),
                    keyName(key),
                    clash.name,
                    keyName(self.value)
                ),
            })
            self:_stopRecording()
            self.window:_flashResult(self, false) -- red: rejected
            return
        end
    elseif key == self.window.settings.toggleKeybind then
        -- an element keybind cant clash with the menu toggle key, same double-fire problem the
        -- other way round. bail, tell them, and keep the old binding.
        self.window:Notify({
            title = locale.resolve("Keybind unavailable"),
            content = string.format(
                locale.resolve("%s is the menu toggle key. Kept %s."),
                keyName(key),
                keyName(self.value)
            ),
        })
        self:_stopRecording()
        self.window:_flashResult(self, false) -- red: rejected
        return
    end

    self:_bind(key)
end

-- commit a new binding from the user: store, relabel, notify + autosave
function Keybind:_bind(key)
    self.value = key
    self:_stopRecording()
    self.window:_runGuarded(self, self.onChanged, key)
    self.window:_persist(self)

    self.window:_flashResult(self, true) -- green: bound
end

-- does this input match the bound key (either a KeyCode or a mouse button)
function Keybind:_matches(input)
    local v = self.value
    if typeof(v) ~= "EnumItem" or v == Enum.KeyCode.Unknown then
        return false
    end
    if v.EnumType == Enum.KeyCode then
        return input.KeyCode == v
    elseif v.EnumType == Enum.UserInputType then
        return input.UserInputType == v
    end
    return false
end

-- hold mode: arm after holdThreshold (a quick tap never counts), fire callback(true) then
-- callback(false) once, edge-triggered off this exact press ending.
function Keybind:_beginHold(input)
    if self._holding or self._holdPress then
        return -- already tracking a hold
    end
    local press = {}
    self._holdPress = press

    -- match the release against the exact key that started this hold, not self.value, so a
    -- rebind mid-hold still lets the original key release and fire callback(false).
    local heldKeyCode = input.KeyCode
    local heldInputType = input.UserInputType

    task.delay(self.holdThreshold, function()
        if self._holdPress ~= press then
            return -- released (or rebound) before it armed
        end
        self._holding = true
        self.window:_runGuarded(self, self.callback, true)
    end)

    -- release edge off the global InputEnded (robust to synthetic input, where the original
    -- InputObject's state doesnt always transition). filed on the element so Tab:Remove drops it
    -- and a release cant fire the callback against a torn-down keybind.
    local conn
    conn = self.window:ConnectFor(self, variables.userInputService.InputEnded, function(ended)
        local released = if heldKeyCode ~= Enum.KeyCode.Unknown
            then ended.KeyCode == heldKeyCode
            else ended.UserInputType == heldInputType
        if not released then
            return
        end
        -- ConnectFor files it on our list too, so drop it there or repeated holds pile up
        if self.connections then
            local index = table.find(self.connections, conn)
            if index then
                table.remove(self.connections, index)
            end
        end
        self.window:Disconnect(conn)
        if self._holdPress == press then
            self._holdPress = nil
        end
        if self._holding then
            self._holding = false
            self.window:_runGuarded(self, self.callback, false)
        end
    end)
end

function Keybind:Set(value, skipChanged)
    local key = coerceKey(value)

    -- same clash rules as interactive capture: a shared bind double-fires, so refuse it and
    -- keep the current one. covers programmatic sets and config restores alike.
    if key ~= Enum.KeyCode.Unknown then
        if self.isMenuToggle then
            local clash = self.window:_keybindUsing(key, self)
            if clash then
                log.warn(
                    "Rayfield: "
                        .. keyName(key)
                        .. " is bound to '"
                        .. tostring(clash.name)
                        .. "'; kept "
                        .. keyName(self.value)
                )
                return
            end
        elseif key == self.window.settings.toggleKeybind then
            log.warn("Rayfield: " .. keyName(key) .. " is the menu toggle key; kept " .. keyName(self.value))
            return
        end
    end

    self.value = key
    if self.recording then
        self:_stopRecording() -- also relabels + resizes for us
    else
        self.keyLabel.Text = keyName(self.value)
        self:_sizeBox(true)
    end

    if not skipChanged then
        self.window:_runGuarded(self, self.onChanged, self.value)
        self.window:_persist(self)
    end
end

-- Persistence: store the enum type + value so any bound KeyCode or mouse button round-trips.
function Keybind:_serialize()
    return { tostring(self.value.EnumType), self.value.Value }
end

function Keybind:_deserialize(raw)
    -- the saved type is tostring(EnumType), e.g. "Enum.KeyCode", so strip the prefix before lookup
    local enumName = tostring(raw[1]):gsub("^Enum%.", "")
    local enumOk, enumType = pcall(function()
        return Enum[enumName]
    end)
    if not enumOk or not enumType then
        return
    end

    local item = enums.itemFromValue(enumType, raw[2])
    if item then
        self:Set(item)
    end
end

function Keybind:_setShown(shown, animate)
    local w = self.window
    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.box, { BackgroundTransparency = w.theme.FieldTransparency }, animate)
        w:_reveal(self.boxStroke, { Transparency = 0.85 }, animate)
        w:_reveal(self.keyLabel, { TextTransparency = 0.6 }, animate)
        w:_reveal(self.glow, { Transparency = 0.9 }, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.box, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.boxStroke, { Transparency = 1 }, animate)
        w:_reveal(self.keyLabel, { TextTransparency = 1 }, animate)
        w:_reveal(self.glow, { Transparency = 1 }, animate)
    end
end

-- Re-apply the box's theme-driven fill transparency on a runtime ChangeTheme (its colour rides
-- a themeProperty). Called on the visible tab only, so the box is shown.
function Keybind:_refreshTheme()
    variables.tweenService
        :Create(
            self.box,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { BackgroundTransparency = self.window.theme.FieldTransparency }
        )
        :Play()
end

moveable(Keybind)
lockable(Keybind)

return Keybind

end)() end,
    [15] = function()local wax,script,require=ImportGlobals(15)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Notification = {}
Notification.__index = Notification
Notification.__type = "Notification"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local hapticEngine = require(utility.HapticEngine)

-- Timings/easings copied from Rayfield Gen1 (all Exponential, Out).
local growInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- bg + stroke
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- title/icon/desc/shadow
-- entry: card slides in from the right as the slot opens
local swipeInInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
-- exit "scale": shrink width + collapse height while it fades
local shrinkInfo = TweenInfo.new(0.9, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local offscreenRight = UDim2.new(0.5, 360, 0.5, 0)
local centred = UDim2.new(0.5, 0, 0.5, 0)

-- Roughly what fits in the 800px stack. Past this the oldest is retired early rather than
-- left to march off the top of the screen still running its own dwell loop.
local maxLive = 6

-- Gap between stacked notifications. Applied INSIDE each notification (as top
-- padding on the outer frame) rather than on the container's UIListLayout, so
-- removing one collapses its gap with it instead of dropping an external gap
-- and making the notifications above jump up.
local stackPadding = 8

-- Auto duration from content length, clamped to a sensible window (Gen1-style)
local function autoDuration(content)
    return math.clamp(#content * 0.06 + 3, 3, 9)
end

function Notification.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        title = properties.title or properties.Title or "Notification",
        content = properties.content or properties.Content or "",
        icon = properties.icon or properties.Icon,
        _hovered = false,
        _dismissed = false,
    }, Notification)

    self.duration = properties.duration or properties.Duration or autoDuration(self.content)

    local hasIcon = self.icon ~= nil and self.icon ~= 0 and self.icon ~= ""

    -- Outer frame: the stack layout item. Invisible itself; only its height is
    -- animated (grow in / collapse the gap on exit).
    self.main = self.window:Create("Frame", {
        Name = "Notification",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.notification,

        Parent = self.window.notifications,
    })

    -- Inter-notification gap lives here (not on the stack layout) so it collapses
    -- with the card and its neighbours don't jump when it's removed.
    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, stackPadding),

        Parent = self.main,
    })

    -- Inner body: the visible card. Centred so the exit width-shrink pulls in
    -- symmetrically from both sides.
    self.body = self.window:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 1, 0),
        Position = offscreenRight, -- starts off to the right; _show slides it in
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true, -- receives input for click-to-dismiss
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.notification,

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    })

    self.window:Create("UIGradient", {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),

        Parent = self.body,
    }, { Color = { "WindowColor", functions.toColorSequence } })

    self.window:Create("UICorner", {
        Parent = self.body,
    }, { CornerRadius = "CornerRoundness" })

    self.stroke = self.window:Create("UIStroke", {
        Transparency = 1, -- In = 0.95

        Parent = self.body,
    }, { Color = "SurfaceStroke" })

    self.shadow = self.window:CreateGlow(self.body, "ShadowColor", 20, 1) -- In = 0.6

    -- Horizontal insets; vertical padding comes from centering the row in the grown height
    self.window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),

        Parent = self.body,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 14),

        Parent = self.body,
    })

    if hasIcon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(24, 24),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = constants.zIndex.notification,

            -- Animation
            ImageTransparency = 1, -- In = 0

            Parent = self.body,
        }, { ImageColor3 = "ContentColor" })
    end

    -- Text column fills the row minus icon + padding (container is 300 wide)
    self.container = self.window:Create("Frame", {
        Size = UDim2.fromOffset(hasIcon and 222 or 260, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.notification,

        Parent = self.body,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),

        Parent = self.container,
    })

    self.titleLabel = self.window:Create("TextLabel", {
        Text = self.title,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = constants.zIndex.notification,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "TitleFont" })

    if self.content ~= "" then
        self.descriptionLabel = self.window:Create("TextLabel", {
            Text = self.content,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            TextSize = 15,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            LayoutOrder = 2,
            ZIndex = constants.zIndex.notification,

            -- Animation
            TextTransparency = 1, -- In = 0.35

            Parent = self.container,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })
    end

    -- Newest sits at the bottom of the (bottom-anchored) stack
    self.window._notificationCount = (self.window._notificationCount or 0) + 1
    self.main.LayoutOrder = self.window._notificationCount

    -- a callback that notifies in a loop would stack cards forever, so retire the oldest once
    -- theres more than the stack can show
    local live = self.window._liveNotifications
    if not live then
        live = {}
        self.window._liveNotifications = live
    end
    table.insert(live, self)
    while #live > maxLive do
        local oldest = table.remove(live, 1)
        if oldest and oldest ~= self then
            task.spawn(oldest._dismiss, oldest)
        end
    end

    -- tracked so _dismiss can drop them; notifications come and go so we cant let their
    -- connections/instances sit in the window lists until Unload
    self._connections = {
        self.window:Connect(self.body.MouseEnter, function()
            self._hovered = true
        end),
        self.window:Connect(self.body.MouseLeave, function()
            self._hovered = false
        end),
        self.window:Connect(self.body.InputBegan, function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                self:_dismiss()
            end
        end),
    }

    task.spawn(function()
        self:_show()
    end)

    return self
end

-- Height the card needs, measured without rendering (so nothing flickers into
-- the stack before it's ready to animate).
function Notification:_measure()
    local colWidth = self.iconLabel and 222 or 260

    local contentH = functions.textHeight(self.window.theme.TitleFont, 16, self.title, colWidth)
    if self.descriptionLabel then
        contentH = contentH + 4 + functions.textHeight(self.window.theme.Font, 15, self.content, colWidth)
    end

    return math.max(contentH, self.iconLabel and 24 or 0) + 28
end

-- Enter: grow the height, then stagger the fades (Gen1 timing).
function Notification:_show()
    -- All sizing done before anything is visible: outer is height 0 and the body
    -- is fully transparent until the grow tween starts, so there's no flicker.
    -- +stackPadding because the outer's top padding holds the inter-card gap.
    local target = self:_measure() + stackPadding
    if self._dismissed or not self.main.Parent then
        return -- evicted mid-measure; dont replay the entrance over the exit
    end

    hapticEngine.notify()

    -- Open the slot and slide the card in from the right (body starts off-right), fading as it comes
    variables.tweenService:Create(self.main, growInfo, { Size = UDim2.new(1, 0, 0, target) }):Play()
    variables.tweenService:Create(self.body, swipeInInfo, { Position = centred }):Play()
    variables.tweenService:Create(self.body, fadeLong, { BackgroundTransparency = 0 }):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, { TextTransparency = 0 }):Play()
    variables.tweenService:Create(self.stroke, fadeLong, { Transparency = 0.95 }):Play()
    variables.tweenService:Create(self.shadow, fadeShort, { Transparency = 0.6 }):Play()

    task.wait(0.05)
    if self._dismissed or not self.main.Parent then
        return -- dismissed mid-stagger; dont fight the exit fade
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, { ImageTransparency = 0 }):Play()
    end

    task.wait(0.05)
    if self._dismissed or not self.main.Parent then
        return
    end
    if self.descriptionLabel then
        variables.tweenService:Create(self.descriptionLabel, fadeShort, { TextTransparency = 0.35 }):Play()
    end

    -- Dwell, pausing while hovered
    local elapsed = 0
    while elapsed < self.duration and not self._dismissed and self.main.Parent do
        local dt = task.wait()
        if not self._hovered then
            elapsed += dt
        end
    end

    self:_dismiss()
end

-- Exit: fade out while the card shrinks (width + height) - Gen1's exit.
function Notification:_dismiss()
    if self._dismissed then
        return
    end
    self._dismissed = true

    local live = self.window._liveNotifications
    local index = live and table.find(live, self)
    if live and index then
        table.remove(live, index)
    end

    if not self.main.Parent then
        return
    end

    -- Fade everything out (runs during the shrink -> "goes transparent as it scales")
    variables.tweenService:Create(self.body, fadeLong, { BackgroundTransparency = 1 }):Play()
    variables.tweenService:Create(self.stroke, fadeLong, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.shadow, fadeShort, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, { TextTransparency = 1 }):Play()
    if self.descriptionLabel then
        variables.tweenService:Create(self.descriptionLabel, fadeShort, { TextTransparency = 1 }):Play()
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, { ImageTransparency = 1 }):Play()
    end

    -- Shrink: narrow the card (width -90) and collapse the slot (height 0) together
    variables.tweenService:Create(self.body, shrinkInfo, { Size = UDim2.new(1, -90, 1, 0) }):Play()
    local collapse = variables.tweenService:Create(self.main, shrinkInfo, { Size = UDim2.new(1, 0, 0, 0) })
    collapse:Play()
    collapse.Completed:Wait()

    if not self.main.Parent then
        return
    end

    for _, connection in self._connections do
        self.window:Disconnect(connection)
    end
    self.window:DestroySubtree(self.main)
end

return Notification

end)() end,
    [16] = function()local wax,script,require=ImportGlobals(16)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Popup: a modal that dims the screen and floats a card in the centre. Modular by design -
-- give it a title and buttons for a choice dialog, or a list of boxes for a changelog. Built
-- from the window's own gradient/corner/stroke/shadow so it reads as part of the same UI.

local Popup = {}
Popup.__index = Popup
Popup.__type = "Popup"

-- Utility
local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local locale = require(utility.locale)
local log = require(utility.log)
local hapticEngine = require(utility.HapticEngine)

-- Timings (Exponential Out, matching the notification/toast feel).
local enterInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- card rise-in
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- fill + stroke
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- content + shadow
local backdropInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Card metrics.
local cardWidth = 400
local sidePadding = 22
local topPadding = 24
local bottomPadding = 22
local regionGap = 16 -- between header, content and footer
local innerWidth = cardWidth - sidePadding * 2

local titleSize = 18
local subtitleSize = 14
local contentSize = 15
local headerIconSize = 16
local headerIconGap = 12 -- icon to title-column
local maxContentHeight = 300 -- content region scrolls past this
-- the content scrolls, so it clips its children; this inset keeps box strokes off the edge
local contentInset = 4
local contentWidth = innerWidth - contentInset * 2

-- Box (changelog card) metrics.
local boxSidePad = 16
local boxVerticalPad = 13
local boxIconSize = 20
local boxIconGap = 10
local boxTitleSize = 15
local boxDescSize = 14
local boxGap = 8
local boxWidthInset = 10 -- boxes sit a touch narrower so they clear the scrollbar

-- Footer buttons.
local buttonHeight = 40
local buttonGap = 8
local buttonCorner = UDim.new(1, 0) -- pill
local buttonTextSize = 16

local backdropShown = 0.5 -- how dark the dim gets

-- Open popups, oldest first. Escape only ever closes the last one so two stacked popups dont
-- both vanish on a single press. A popup torn down some other way (its window went with it)
-- never runs Close, so entries are pruned by liveness rather than trusted to remove themselves.
local stack = {}

-- The Escape press that just closed a popup. Every open popup listens to the same InputBegan
-- and closing the top one synchronously makes the next one topmost, so without this a single
-- press would fall through the whole stack.
local consumedEscape = nil

-- Drop entries whose popup is gone. A popup torn down with its window never runs Close, so
-- liveness is the only thing that can be trusted here.
local function pruneStack()
    for index = #stack, 1, -1 do
        local open = stack[index]
        if open._closed or not open.screenGui.Parent then
            table.remove(stack, index)
        end
    end
end

local function topmost(popup)
    pruneStack()
    return stack[#stack] == popup
end

function Popup.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        title = properties.title or properties.Title or "Popup",
        subtitle = properties.subtitle or properties.Subtitle,
        content = properties.content or properties.Content,
        icon = properties.icon or properties.Icon,
        boxes = properties.boxes or properties.Boxes,
        options = properties.options or properties.Options,
        -- click the dim or press Escape to close (no callback fires). On by default.
        dismissable = if properties.dismissable ~= nil
            then properties.dismissable
            elseif properties.Dismissable ~= nil then properties.Dismissable
            else true,
        _reveal = {}, -- { instance, prop, to } fadeables, tweened in on show and out on close
        _connections = {},
        _closed = false,
    }, Popup)

    -- default to a single dismiss button so a bare popup still closes
    if not self.options or #self.options == 0 then
        self.options = { { text = "Okay" } }
    end

    self:_build()
    -- prune on the way in as well as on Escape: a window unloaded with popups open leaves
    -- dead entries behind, and nothing else would clear them until the next Escape
    pruneStack()
    table.insert(stack, self) -- built, so it has a screenGui for the liveness prune

    task.spawn(function()
        self:_show()
    end)

    return self
end

-- Register a transparency-driven instance so _show can fade it in (to `to`) and _dismiss can
-- fade it back out (to 1). Every fadeable funnels here so the two directions stay in sync.
function Popup:_fade(instance, prop, to)
    table.insert(self._reveal, { instance = instance, prop = prop, to = to })
    return instance
end

function Popup:_build()
    local window = self.window
    local hasIcon = self.icon ~= nil and self.icon ~= 0 and self.icon ~= ""

    -- Own ScreenGui so the modal sits above the window, toasts and notifications alike.
    self.screenGui = window:Create("ScreenGui", {
        Name = variables.httpService:GenerateGUID(false),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Enabled = true,
        DisplayOrder = constants.displayOrder.popup,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,

        Parent = variables.guiContainer,
    })

    -- Dim backdrop, also the click-to-dismiss surface and the input sink for everything below.
    -- A plain Active frame, not a button - it only needs to swallow input, so a frame is the
    -- right primitive.
    self.backdrop = window:Create("Frame", {
        Name = "Backdrop",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Active = true,

        BackgroundTransparency = 1, -- shown = backdropShown

        Parent = self.screenGui,
    })
    self:_fade(self.backdrop, "BackgroundTransparency", backdropShown)

    -- Card: the window's own look (white base + gradient + rounded corner + stroke + glow).
    self.card = window:Create("Frame", {
        Name = "Card",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 14), -- drifts up to centre on show
        Size = UDim2.fromOffset(cardWidth, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true, -- clicks on the card never reach the backdrop
        BorderSizePixel = 0,

        BackgroundTransparency = 1, -- shown = 0

        Parent = self.screenGui,
    })
    self:_fade(self.card, "BackgroundTransparency", 0)

    window:Create("UIGradient", {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),

        Parent = self.card,
    }, { Color = { "WindowColor", functions.toColorSequence } })

    window:Create("UICorner", {
        Parent = self.card,
    }, { CornerRadius = "CornerRoundness" })

    self.cardStroke = window:Create("UIStroke", {
        Transparency = 1, -- shown = 0.95

        Parent = self.card,
    }, { Color = "SurfaceStroke" })
    self:_fade(self.cardStroke, "Transparency", 0.95)

    self.cardShadow = window:CreateGlow(self.card, "ShadowColor", 26, 1) -- shown = 0.55
    self:_fade(self.cardShadow, "Transparency", 0.55)

    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, sidePadding),
        PaddingRight = UDim.new(0, sidePadding),
        PaddingTop = UDim.new(0, topPadding),
        PaddingBottom = UDim.new(0, bottomPadding),

        Parent = self.card,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, regionGap),

        Parent = self.card,
    })

    -- Pre-measure like the notifications do, then lock the card to a fixed height. Otherwise the
    -- card grows a few pixels a moment after it shows, as the brand font's glyphs finish loading
    -- and AutomaticSize re-measures the text - reads as the font "settling" after the reveal.
    local headerHeight = self:_measureHeader(hasIcon)
    self:_buildHeader(hasIcon, headerHeight)
    local contentHeight = self:_buildContent()
    self:_buildFooter()

    local regions = 2 + (contentHeight > 0 and 1 or 0) -- header, footer, and content if present
    local cardHeight = topPadding
        + headerHeight
        + contentHeight
        + buttonHeight
        + bottomPadding
        + regionGap * (regions - 1)
    self.card.Size = UDim2.fromOffset(cardWidth, cardHeight)
    self.card.AutomaticSize = Enum.AutomaticSize.None

    -- dismiss surfaces
    if self.dismissable then
        table.insert(
            self._connections,
            window:Connect(self.backdrop.InputBegan, function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    self:Close()
                end
            end)
        )
        table.insert(
            self._connections,
            window:Connect(variables.userInputService.InputBegan, function(input, processed)
                if not processed and input.KeyCode == Enum.KeyCode.Escape and topmost(self) then
                    if input == consumedEscape then
                        return
                    end
                    consumedEscape = input
                    self:Close()
                end
            end)
        )
    end
end

function Popup:_buildHeader(hasIcon, headerHeight)
    local window = self.window

    local header = window:Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        LayoutOrder = 1,

        Parent = self.card,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, headerIconGap),

        Parent = header,
    })

    if hasIcon then
        self:_fade(
            window:Create("ImageLabel", {
                Image = self.icon,
                Size = UDim2.fromOffset(headerIconSize, headerIconSize),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,

                ImageTransparency = 1, -- shown = 0

                Parent = header,
            }, { ImageColor3 = "TitlingColor" }),
            "ImageTransparency",
            0
        )
    end

    local textColumn = window:Create("Frame", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, hasIcon and -(headerIconSize + headerIconGap) or 0, 0, self._columnH),
        LayoutOrder = 2,

        Parent = header,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),

        Parent = textColumn,
    })

    self:_fade(
        window:Create("TextLabel", {
            Text = locale.t(self.title),
            Size = UDim2.new(1, 0, 0, self._titleH),
            BackgroundTransparency = 1,
            TextSize = titleSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,

            TextTransparency = 1, -- shown = 0

            Parent = textColumn,
        }, { TextColor3 = "TitlingColor", FontFace = "Font" }),
        "TextTransparency",
        0
    )

    if self.subtitle and self.subtitle ~= "" then
        self:_fade(
            window:Create("TextLabel", {
                Text = locale.t(self.subtitle),
                Size = UDim2.new(1, 0, 0, self._subH),
                BackgroundTransparency = 1,
                TextSize = subtitleSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,

                TextTransparency = 1, -- shown = 0.55

                Parent = textColumn,
            }, { TextColor3 = "TitlingColor", FontFace = "Font" }),
            "TextTransparency",
            0.55
        )
    end
end

-- The middle region: a paragraph, a list of boxes, or nothing. Whichever it is, it lives in a
-- scrolling frame capped at maxContentHeight so a long changelog scrolls instead of running off.
function Popup:_buildContent()
    if (not self.content or self.content == "") and (not self.boxes or #self.boxes == 0) then
        return 0 -- title + buttons only (a plain confirm dialog)
    end

    local window = self.window
    local measured = if self.boxes and #self.boxes > 0 then self:_measureBoxes() else self:_measureText()
    local viewHeight = math.min(measured, maxContentHeight) + contentInset * 2

    local content = window:Create("ScrollingFrame", {
        Name = "Content",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, viewHeight),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 2,

        ScrollBarImageTransparency = 1, -- shown = 0.8, fades in with the rest

        Parent = self.card,
    })
    self:_fade(content, "ScrollBarImageTransparency", 0.8)

    -- the scroll clips, so pad the region to keep box strokes off the edge
    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, contentInset),
        PaddingRight = UDim.new(0, contentInset),
        PaddingTop = UDim.new(0, contentInset),
        PaddingBottom = UDim.new(0, contentInset),

        Parent = content,
    })

    if self.boxes and #self.boxes > 0 then
        window:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, boxGap),

            Parent = content,
        })
        for index, box in self.boxes do
            self:_buildBox(content, box, index)
        end
    else
        self:_fade(
            window:Create("TextLabel", {
                Text = locale.t(self.content),
                Size = UDim2.new(1, 0, 0, measured),
                BackgroundTransparency = 1,
                TextSize = contentSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,

                TextTransparency = 1, -- shown = 0.5

                Parent = content,
            }, { TextColor3 = "ContentColor", FontFace = "Font" }),
            "TextTransparency",
            0.5
        )
    end

    return viewHeight
end

-- One changelog box: a card in the element-panel style (gradient stroke sheen), icon optional,
-- a semibold title and a softer description.
function Popup:_buildBox(parent, box, order)
    local window = self.window
    box = if typeof(box) == "table" then box else { title = tostring(box) }
    local hasIcon = box.icon ~= nil and box.icon ~= 0 and box.icon ~= ""
    local frameH, titleH, descH, columnH = self:_measureBox(box)

    local frame = window:Create("Frame", {
        Name = "Box",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -boxWidthInset, 0, frameH),
        LayoutOrder = order,

        BackgroundTransparency = 1, -- shown = 0

        Parent = parent,
    })
    self:_fade(frame, "BackgroundTransparency", 0)

    local stroke = window:StyleElementPanel(frame)
    self:_fade(stroke, "Transparency", window.theme.ElementStrokeTransparency)

    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, boxSidePad),
        PaddingRight = UDim.new(0, boxSidePad),
        PaddingTop = UDim.new(0, boxVerticalPad),
        PaddingBottom = UDim.new(0, boxVerticalPad),

        Parent = frame,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, boxIconGap),

        Parent = frame,
    })

    if hasIcon then
        self:_fade(
            window:Create("ImageLabel", {
                Image = box.icon,
                Size = UDim2.fromOffset(boxIconSize, boxIconSize),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,

                ImageTransparency = 1, -- shown = 0

                Parent = frame,
            }, { ImageColor3 = "ContentColor" }),
            "ImageTransparency",
            0
        )
    end

    local textColumn = window:Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, hasIcon and -(boxIconSize + boxIconGap) or 0, 0, columnH),
        LayoutOrder = 2,

        Parent = frame,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),

        Parent = textColumn,
    })

    self:_fade(
        window:Create("TextLabel", {
            Text = locale.t(box.title or box.Title or ""),
            Size = UDim2.new(1, 0, 0, titleH),
            BackgroundTransparency = 1,
            TextSize = boxTitleSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,

            TextTransparency = 1, -- shown = 0

            Parent = textColumn,
        }, { TextColor3 = "ContentColor", FontFace = "TitleFont" }),
        "TextTransparency",
        0
    )

    local description = box.description or box.Description
    if description and description ~= "" then
        self:_fade(
            window:Create("TextLabel", {
                Text = locale.t(description),
                Size = UDim2.new(1, 0, 0, descH),
                BackgroundTransparency = 1,
                TextSize = boxDescSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                LayoutOrder = 2,

                TextTransparency = 1, -- shown = 0.65

                Parent = textColumn,
            }, { TextColor3 = "ContentColor", FontFace = "Font" }),
            "TextTransparency",
            0.65
        )
    end
end

function Popup:_buildFooter()
    local window = self.window

    local footer = window:Create("Frame", {
        Name = "Footer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, buttonHeight),
        LayoutOrder = 3,

        Parent = self.card,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill, -- buttons share the row evenly
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, buttonGap),

        Parent = footer,
    })

    for index, option in self.options do
        self:_buildButton(footer, option, index)
    end
end

-- One footer button. Neutral matches the element body; "primary" and "danger" tint it green/red
-- the way the library flags a good or destructive action.
function Popup:_buildButton(parent, option, order)
    local window = self.window
    option = if typeof(option) == "table" then option else { text = tostring(option) }
    local style = option.style or option.Style or "neutral"
    local label = option.text or option.Text or option.name or option.Name or "Okay"
    local callback = option.callback or option.Callback

    -- flat fills so hover just tweens the colour (no overlay). neutral takes a faint white edge
    -- so it recedes; the accents carry their own colour and a bolder edge.
    local restColor, hoverColor, edgeColor, strokeShown
    if style == "primary" then
        restColor, hoverColor, edgeColor, strokeShown =
            window.theme.AccentColor, window.theme.AccentStroke, window.theme.AccentStroke, 0.1
    elseif style == "danger" then
        restColor, hoverColor, edgeColor, strokeShown =
            window.theme.ErrorColor, window.theme.ErrorStrokeColor, window.theme.ErrorStrokeColor, 0
    else
        restColor, hoverColor, edgeColor, strokeShown =
            window.theme.NeutralButton, window.theme.NeutralButtonHover, window.theme.NeutralButtonStroke, 0.85
    end

    local button = window:Create("Frame", {
        Name = "Button",
        BackgroundColor3 = restColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, buttonHeight),
        LayoutOrder = order,

        BackgroundTransparency = 1, -- shown = 0

        Parent = parent,
    })
    self:_fade(button, "BackgroundTransparency", 0)

    window:Create("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = button })
    window:Create("UICorner", { CornerRadius = buttonCorner, Parent = button })

    local stroke = window:Create("UIStroke", {
        Color = edgeColor,
        Transparency = 1, -- shown = strokeShown

        Parent = button,
    })
    self:_fade(stroke, "Transparency", strokeShown)

    self:_fade(
        window:Create("TextLabel", {
            Text = locale.t(label),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            TextSize = buttonTextSize,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd,

            -- adaptive: black or white by the fill's luminance, so every style stays readable
            TextColor3 = functions.contrastText(restColor),
            TextTransparency = 1, -- shown = 0

            Parent = button,
        }, { FontFace = "Font" }),
        "TextTransparency",
        0
    )

    local interact = window:Create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,

        Parent = button,
    })

    local hoverInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    table.insert(
        self._connections,
        window:Connect(interact.MouseEnter, function()
            if self._closed then
                return
            end
            variables.tweenService:Create(button, hoverInfo, { BackgroundColor3 = hoverColor }):Play()
        end)
    )
    table.insert(
        self._connections,
        window:Connect(interact.MouseLeave, function()
            variables.tweenService:Create(button, hoverInfo, { BackgroundColor3 = restColor }):Play()
        end)
    )

    table.insert(
        self._connections,
        window:Connect(interact.MouseButton1Click, function()
            if self._closed then
                return
            end
            hapticEngine.click()
            -- press feel: ghost the stroke, then run the callback and close
            variables.tweenService:Create(stroke, hoverInfo, { Transparency = 1 }):Play()
            if callback then
                task.spawn(function()
                    local ok, err = pcall(callback)
                    if not ok then
                        log.warn("Rayfield: popup button '" .. label .. "' callback errored:")
                        log.print(err)
                    end
                end)
            end
            self:Close()
        end)
    )
end

-- Measure the header parts once and stash them, so both the card height and the header's own
-- fixed layout use the same numbers. Everything is sized off these, so nothing re-measures on
-- screen once the font's glyphs land. Returns the header row height.
function Popup:_measureHeader(hasIcon)
    local textWidth = innerWidth - (if hasIcon then headerIconSize + headerIconGap else 0)
    self._titleH = functions.textHeight(self.window.theme.Font, titleSize, locale.resolve(self.title), textWidth)
    self._subH = if self.subtitle and self.subtitle ~= ""
        then functions.textHeight(self.window.theme.Font, subtitleSize, locale.resolve(self.subtitle), textWidth)
        else 0
    self._columnH = self._titleH + (if self._subH > 0 then 3 + self._subH else 0)
    return math.max(self._columnH, if hasIcon then headerIconSize else 0)
end

-- Height a paragraph needs at the content region's width.
function Popup:_measureText()
    -- measure what actually renders: the label shows the translated string
    return functions.textHeight(self.window.theme.Font, contentSize, locale.resolve(self.content), contentWidth)
end

-- Every measurement one box needs: its frame height (content + padding), its title and
-- description text heights, and the text column height. Both the card sizing and the box build
-- read from here, so a box is built at a fixed size rather than auto-sizing (which re-measures).
function Popup:_measureBox(box)
    box = if typeof(box) == "table" then box else { title = tostring(box) }
    local hasIcon = box.icon ~= nil and box.icon ~= 0 and box.icon ~= ""
    local textWidth = contentWidth - boxWidthInset - boxSidePad * 2 - (if hasIcon then boxIconSize + boxIconGap else 0)

    local titleH = functions.textHeight(
        self.window.theme.TitleFont,
        boxTitleSize,
        locale.resolve(box.title or box.Title or ""),
        textWidth
    )
    local descH = 0
    local description = box.description or box.Description
    if description and description ~= "" then
        descH = functions.textHeight(self.window.theme.Font, boxDescSize, locale.resolve(description), textWidth)
    end

    local columnH = titleH + (if descH > 0 then 3 + descH else 0)
    local frameH = math.max(columnH, if hasIcon then boxIconSize else 0) + boxVerticalPad * 2
    return frameH, titleH, descH, columnH
end

-- Total height every box stacks to, so the content region knows when to start scrolling.
function Popup:_measureBoxes()
    local total = 0
    for index, box in self.boxes do
        total += (self:_measureBox(box))
        if index < #self.boxes then
            total += boxGap
        end
    end
    return total
end

-- Enter: darken the backdrop, drift the card up into place and fade everything in. No UIScale -
-- scaling the card scales its text, which reads as the font size settling after the reveal.
function Popup:_show()
    if not self.screenGui.Parent then
        return
    end

    hapticEngine.notify()

    variables.tweenService:Create(self.card, enterInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()

    for _, entry in self._reveal do
        local info = if entry.instance == self.backdrop then backdropInfo else fadeLong
        variables.tweenService:Create(entry.instance, info, { [entry.prop] = entry.to }):Play()
    end
end

-- Exit: fade everything back out while the card drifts down a touch, then tear it all down.
function Popup:Close()
    if self._closed then
        return
    end
    self._closed = true

    local index = table.find(stack, self)
    if index then
        table.remove(stack, index)
    end

    for _, connection in self._connections do
        self.window:Disconnect(connection)
    end
    self._connections = {}

    if not self.screenGui.Parent then
        return
    end

    variables.tweenService:Create(self.card, fadeShort, { Position = UDim2.new(0.5, 0, 0.5, 10) }):Play()

    for _, entry in self._reveal do
        variables.tweenService:Create(entry.instance, fadeShort, { [entry.prop] = 1 }):Play()
    end

    task.delay(fadeShort.Time, function()
        self.window:DestroySubtree(self.screenGui)
    end)
end

return Popup

end)() end,
    [17] = function()local wax,script,require=ImportGlobals(17)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- A progress bar: a title with a readout beside it and a filled track underneath. Read-only,
-- so it carries no flag and saves nothing. It takes a range the way the slider does, and it
-- borrows the slider's track wholesale - same SliderBackground, same SliderProgress fill, same
-- accent glow - so the two read as one family and a theme for one already fits the other.

local Progress = {}
Progress.__index = Progress
Progress.__type = "Progress"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local locale = require(utility.locale)

local rowHeight = 60
local trackHeight = 8
local inset = 20 -- left and right, matching the other elements' content inset

-- Stepped bars run a little thinner than a continuous one, so a row of them doesn't read as
-- heavy as a single solid track.
local stepHeight = 6
local stepGap = 6

local titleSize = 16
local readoutSize = 14
local readoutTransparency = 0.4

local fillInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- The slider's fill gradient, so a filled track looks the same in both elements.
local fillTransparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(1, 0),
})

-- The waiting sweep: the fill grows out from the left edge and empties back into it, over and
-- over. Roblox repeats and reverses it natively, so there is no loop of ours to run, nothing to
-- cancel by hand, and nothing left running once the window goes. It also never leaves the
-- track, so the fill's rounded ends are never clipped square against the track's own corner.
local sweepSeconds = 0.9
local sweepInfo = TweenInfo.new(sweepSeconds, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, -1, true)

local function finite(value: unknown): number?
    local number = tonumber(value)
    if number == nil or number ~= number or math.abs(number) == math.huge then
        return nil
    end
    return number
end

function Progress.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    -- steps: the track becomes that many segments, and unless a range says otherwise the value
    -- counts them, so Set(3) on a 5-step bar means three done.
    local steps = finite(properties.steps or properties.Steps)
    steps = if steps and steps >= 2 then math.floor(steps) else nil

    local range = properties.range or properties.Range
    local min = finite(range and range[1]) or 0
    local max = finite(range and range[2]) or steps or 1
    if min > max then
        min, max = max, min
    end

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Progress",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,

        min = min,
        max = max,
        steps = steps,
        value = 0, -- settled by the Set below, once the range is in place

        -- a readout of your own, or a formatter for it; without either it's a percentage
        text = properties.text or properties.Text,
        format = properties.format or properties.Format,
        showValue = if properties.showValue == nil then true else properties.showValue == true,
        indeterminate = properties.indeterminate or properties.Indeterminate or false,
    }, Progress)

    self.value = self:_clamp(finite(properties.value or properties.Value) or min)

    self:_build()

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    return self
end

function Progress:_clamp(value: number): number
    return math.clamp(finite(value) or self.min, self.min, self.max)
end

-- Where the value sits in its range, 0 to 1. An empty range is a full bar, not a divide by zero.
function Progress:_ratio(): number
    local span = self.max - self.min
    if span <= 0 then
        return 1
    end
    return (self.value - self.min) / span
end

-- How many segments are filled at the current value.
function Progress:_filledSteps(): number
    local count = self.steps :: number
    return math.clamp(math.round(self:_ratio() * count), 0, count)
end

function Progress:_readout(): string
    if self.text then
        return locale.resolve(self.text)
    end
    if self.format then
        local ok, formatted = pcall(self.format, self.value, self.min, self.max)
        if ok and type(formatted) == "string" then
            return formatted
        end
    end
    -- a stepped bar counts its stages; a continuous one is a percentage
    if self.steps then
        return string.format("%d/%d", self:_filledSteps(), self.steps)
    end
    return string.format("%d%%", math.round(self:_ratio() * 100))
end

function Progress:_build()
    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, rowHeight),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)

    -- Title row: name left, readout hard right, both centred on the same line
    self.container = self.window:Create("Frame", {
        Size = UDim2.new(0, 170, 0, titleSize),
        Position = UDim2.new(0, inset, 0, 20),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animation
            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(250, titleSize),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = titleSize,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.readout = self.window:Create("TextLabel", {
        Text = self:_readout(),

        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -inset, 0, 20),
        Size = UDim2.fromOffset(50, readoutSize),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = readoutSize,
        TextXAlignment = Enum.TextXAlignment.Right,
        Visible = self.showValue,

        -- Animation
        TextTransparency = 1, -- In = readoutTransparency

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    if self.steps then
        self:_buildSteps()
        return
    end

    -- Track, sized and coloured exactly like the slider's. No ClipsDescendants: the fill is
    -- kept inside the track by its own geometry instead, so its rounded ends stay round -
    -- a rectangular clip would square them off against the track's rounded corner.
    self.track = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -inset * 2, 0, trackHeight),
        BorderSizePixel = 0,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    }, { BackgroundColor3 = "SliderBackground" })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = self.track,
    })

    self.fill = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromScale(if self.indeterminate then 0 else self:_ratio(), 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.track,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = self.fill,
    })

    self.window:Create("UIGradient", {
        Offset = Vector2.new(0, 0.5),
        Rotation = 2,
        Transparency = fillTransparency,

        Parent = self.fill,
    }, { Color = { "SliderProgress", functions.toColorSequence } })

    self.fillGlow = self.window:CreateGlow(self.fill, "AccentColor", 20, 1)

    if self.indeterminate then
        self:_startSweep()
    end
end

-- A row of segments in place of the track. Each fills whole, so the bar reads as a count of
-- stages rather than a distance travelled.
function Progress:_buildSteps()
    local count = self.steps :: number

    self.track = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -17),
        Size = UDim2.new(1, -inset * 2, 0, stepHeight),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, stepGap),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.track,
    })

    self.stepFrames = {}
    for index = 1, count do
        -- the scale share, less this segment's cut of the gaps, so the row lands exactly full
        local segment = self.window:Create("Frame", {
            Size = UDim2.new(1 / count, -(stepGap * (count - 1)) / count, 1, 0),
            BorderSizePixel = 0,
            LayoutOrder = index,
            -- no literal colour: Create applies the theme first and plain properties second, so
            -- a white here would paint straight over SliderBackground and the empty segments
            -- would read white in every theme

            BackgroundTransparency = 1, -- In = 0

            Parent = self.track,
        }, { BackgroundColor3 = "SliderBackground" })

        self.window:Create("UICorner", {
            CornerRadius = UDim.new(1, 0),

            Parent = segment,
        })

        -- the filled face, laid over the empty one and faded in once its stage is reached
        local fill = self.window:Create("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 2,

            BackgroundTransparency = 1, -- In = 0 once this stage is reached

            Parent = segment,
        })

        self.window:Create("UICorner", {
            CornerRadius = UDim.new(1, 0),

            Parent = fill,
        })

        -- no transparency ramp here: the slider fades its fill in over a long track, but across
        -- a segment this short the same ramp just washes it out to white
        self.window:Create("UIGradient", {
            Rotation = 90,

            Parent = fill,
        }, { Color = { "SliderProgress", functions.toColorSequence } })

        table.insert(self.stepFrames, { segment = segment, fill = fill })
    end
end

-- With no value to show, the fill grows from the left edge and empties back into it.
function Progress:_startSweep()
    if self._sweep or self.steps then
        return -- already sweeping, and a row of stages has nothing to sweep
    end

    self.fill.AnchorPoint = Vector2.new(0, 0.5)
    self.fill.Position = UDim2.fromScale(0, 0.5)
    self.fill.Size = UDim2.fromScale(0, 1)

    self._sweep = variables.tweenService:Create(self.fill, sweepInfo, { Size = UDim2.fromScale(1, 1) })
    self._sweep:Play()
end

function Progress:_stopSweep()
    if not self._sweep then
        return
    end
    self._sweep:Cancel()
    self._sweep = nil
    self.fill.AnchorPoint = Vector2.new(0, 0.5)
    self.fill.Position = UDim2.fromScale(0, 0.5)
end

function Progress:_render(animate: boolean?)
    self.readout.Text = self:_readout()

    if self.steps then
        -- while hidden every face is transparent; _setShown paints the right ones on the way in
        if not self._shown then
            return
        end
        local filled = self:_filledSteps()
        for index, step in self.stepFrames do
            local target = if index <= filled then 0 else 1
            if animate == false then
                step.fill.BackgroundTransparency = target
            else
                variables.tweenService:Create(step.fill, fillInfo, { BackgroundTransparency = target }):Play()
            end
        end
        return
    end

    local size = UDim2.fromScale(self:_ratio(), 1)
    if animate == false then
        self.fill.Size = size
    else
        variables.tweenService:Create(self.fill, fillInfo, { Size = size }):Play()
    end
end

-- Set the value. Outside the range it's clamped; anything that isn't a number reads as the floor.
function Progress:Set(value)
    self.value = self:_clamp(value)

    if self.indeterminate then
        self.indeterminate = false
        self:_stopSweep()
    end

    self:_render()
end

function Progress:Get(): number
    return self.value
end

-- Where the value sits in its range, 0 to 1.
function Progress:GetPercentage(): number
    return self:_ratio()
end

-- Move the range. The value comes with it, clamped into whatever the new range allows.
function Progress:SetRange(min, max)
    min = finite(min) or self.min
    max = finite(max) or self.max
    if min > max then
        min, max = max, min
    end

    self.min, self.max = min, max
    self.value = self:_clamp(self.value)
    self:_render()
end

-- Replace the readout with your own line, or pass nil to go back to the formatter/percentage.
function Progress:SetText(text)
    self.text = text
    self.readout.Text = self:_readout()
end

-- Swap between a real value and the waiting sweep.
function Progress:SetIndeterminate(state)
    state = state == true
    if state == self.indeterminate then
        return
    end
    self.indeterminate = state

    if state then
        self:_startSweep()
    else
        self:_stopSweep()
        self:_render(false)
    end
end

function Progress:_setShown(shown, animate)
    local w = self.window

    self._shown = shown
    w:_reveal(self.readout, { TextTransparency = if shown then readoutTransparency else 1 }, animate)

    if shown then
        w:_revealCommon(self, animate)
    else
        w:_hideCommon(self, animate)
    end

    if self.steps then
        local filled = self:_filledSteps()
        for index, step in self.stepFrames do
            w:_reveal(step.segment, { BackgroundTransparency = if shown then 0 else 1 }, animate)
            w:_reveal(step.fill, { BackgroundTransparency = if shown and index <= filled then 0 else 1 }, animate)
        end
        return
    end

    w:_reveal(self.track, { BackgroundTransparency = if shown then 0 else 1 }, animate)
    w:_reveal(self.fill, { BackgroundTransparency = if shown then 0 else 1 }, animate)
    w:_reveal(self.fillGlow, { Transparency = if shown then w.theme.AccentGlow else 1 }, animate)
end

function Progress:Remove()
    self:_stopSweep()
    if self.descriptor then
        self.descriptor:Remove()
    end
    self.main:Destroy()
end

moveable(Progress)

return Progress

end)() end,
    [18] = function()local wax,script,require=ImportGlobals(18)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Search: a pill that takes over the tab strip and searches every page at once. The Search
-- action toggles it; while open the tab selector hides and every content tab's elements are
-- gathered into one results page, filtered live by name. Closing puts everything back exactly
-- where it was. Values ported from the RF2 design (Window.Search).

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local constants = require(utility.constants)
local locale = require(utility.locale)
local action = require(script.Parent.action)

local search = {}

-- crossfade between the tab strip and the search pill, and the search parts fading in/out
local swapInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- resting/lit brightness for the Search action icon, matching the other topbar actions
local iconRest = 0.6
local iconLit = 0.2

-- The searchable text for one unit: a leaf's own name, or every descendant leaf name joined
-- so a group matches when any child inside it does.
local function unitText(unit)
    if unit.__type == "Group" then
        local parts = {}
        local function walk(group)
            for _, child in group.elements do
                if child.__type == "Group" then
                    walk(child)
                elseif child.name then
                    table.insert(parts, child.name)
                end
            end
        end
        walk(unit)
        return table.concat(parts, "\n")
    end
    return unit.name or ""
end

-- Every top-level element across the real content pages (the settings page and other
-- neglected tabs aren't pages you search). Sections are headers, so skip them.
local function collectUnits(window)
    local units = {}
    for _, tab in window.tabs do
        if tab.neglectSelector then
            continue
        end
        for _, element in tab.elements do
            if element.__type ~= "Section" then
                table.insert(units, element)
            end
        end
    end
    return units
end

-- Fade the pill's fill, stroke, shadow, icon and field in or out together.
local function setPillShown(window, shown, info)
    variables.tweenService
        :Create(window.searchPill, info, {
            BackgroundTransparency = if shown then 0.9 else 1,
        })
        :Play()
    variables.tweenService:Create(window.searchStroke, info, { Transparency = if shown then 0.85 else 1 }):Play()
    variables.tweenService:Create(window.searchShadow, info, { Transparency = if shown then 0.92 else 1 }):Play()
    variables.tweenService:Create(window.searchIcon, info, { ImageTransparency = if shown then 0.65 else 1 }):Play()
    variables.tweenService:Create(window.searchInput, info, { TextTransparency = if shown then 0.2 else 1 }):Play()
end

-- Show/hide the content tab pills as the strip swaps with the search field. The sidebar rail
-- isn't in the field's way, so it stays put and keeps showing where you were.
local function setTabsShown(window, shown, info)
    if window.layout.mode == "sidebar" then
        return
    end
    for _, tab in window.tabs do
        if not tab.neglectSelector and tab.topbarItem then
            tab:_applyVisual(
                if shown then (if window.selectedTab == tab then "selected" else "unselected") else "hidden",
                info
            )
        end
    end
end

-- Toggle each unit's visibility against the query. Empty query shows everything, so the
-- open field doubles as a browse-all-pages view.
local function applyFilter(window, query)
    query = string.lower(query or "")
    local anyVisible = false
    for _, entry in window._searchUnits do
        local match = query == "" or string.find(entry.text, query, 1, true) ~= nil
        entry.unit.main.Visible = match
        if entry.unit.descriptor then
            entry.unit.descriptor.main.Visible = match
        end
        anyVisible = anyVisible or match
    end
    window.searchEmpty.Visible = not anyVisible and query ~= ""
end

-- Pull every unit into the results page, remembering where each came from, and lay them out
-- grouped by page in creation order.
local function gatherUnits(window)
    window._searchUnits = {}
    local order = 0
    for _, unit in collectUnits(window) do
        order += 1
        local main = unit.main
        table.insert(window._searchUnits, {
            unit = unit,
            text = string.lower(unitText(unit)),
            homeParent = main.Parent,
            homeOrder = main.LayoutOrder,
            descOrder = unit.descriptor and unit.descriptor.main.LayoutOrder,
        })

        main.LayoutOrder = order * 10
        main.Parent = window.searchPage
        main.Visible = true
        if unit.descriptor then
            unit.descriptor.main.LayoutOrder = order * 10 + 1
            unit.descriptor.main.Parent = window.searchPage
            unit.descriptor.main.Visible = true
        end
    end
end

-- Put every unit back in the tab it came from, at its original order. Guards a unit whose
-- element was removed mid-search (its frame is gone).
local function restoreUnits(window)
    for _, entry in window._searchUnits do
        local unit = entry.unit
        if unit.main and unit.main.Parent then
            unit.main.LayoutOrder = entry.homeOrder
            unit.main.Parent = entry.homeParent
            unit.main.Visible = true
        end
        if unit.descriptor and unit.descriptor.main and unit.descriptor.main.Parent then
            unit.descriptor.main.LayoutOrder = entry.descOrder
            unit.descriptor.main.Parent = entry.homeParent
            unit.descriptor.main.Visible = true
        end
    end
    window._searchUnits = {}
end

function search.open(window)
    -- minimised: the results page would render outside the collapsed bar and steal focus
    if window._searching or window.minimised or not window:_interactive() then
        return
    end
    window._searching = true

    gatherUnits(window)
    applyFilter(window, "")
    window:_jumpTo(window.searchPage)

    -- strip swaps for the field
    setTabsShown(window, false, swapInfo)
    task.delay(swapInfo.Time, function()
        if window._searching and window.layout.mode ~= "sidebar" then
            window.tabList.Visible = false
        end
    end)

    window.searchPill.Visible = true
    setPillShown(window, true, swapInfo)
    window.searchInput:CaptureFocus()

    variables.tweenService:Create(window.searchAction.iconLabel, swapInfo, { ImageTransparency = iconLit }):Play()
end

-- config.showTabs: fade the tab strip back in (false when the caller hides the window).
-- config.jumpTo: the page to slide back to, or false to leave navigation to the caller.
function search.close(window, config)
    if not window._searching then
        return
    end
    config = config or {}
    window._searching = false

    window.searchInput.Text = ""
    window.searchInput:ReleaseFocus()
    window.searchEmpty.Visible = false

    restoreUnits(window)
    local target = if config.jumpTo == nil then window.selectedTab and window.selectedTab.tabPage else config.jumpTo
    if target then
        window:_jumpTo(target)
    end

    setPillShown(window, false, swapInfo)
    task.delay(swapInfo.Time, function()
        if not window._searching then
            window.searchPill.Visible = false
        end
    end)

    if config.showTabs then
        window.tabList.Visible = true
        setTabsShown(window, true, swapInfo)
    end

    variables.tweenService:Create(window.searchAction.iconLabel, swapInfo, { ImageTransparency = iconRest }):Play()
end

function search.toggle(window)
    if window._searching then
        search.close(window, { showTabs = true })
    else
        search.open(window)
    end
end

-- Keep the field in step with the rail: it sits over the card, so it's as wide as the card is.
function search.railWidth(window, width)
    if window.searchPill then
        window.searchPill.Size = UDim2.new(1, -(width + 30), 0, 35)
    end
end

function search.build(window)
    window._searching = false

    -- Results page: a page like a tab's, holding whatever the search gathers.
    window.searchPage = window:Create("ScrollingFrame", {
        Name = "Search",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 2000, -- sits after every tab page

        Parent = window.elements,
    })

    window:Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = window.searchPage,
    })

    -- under a sidebar the field floats over the top of the card rather than replacing a strip,
    -- so the results start below where it lands instead of under it
    window:Create("UIPadding", {
        PaddingTop = UDim.new(0, if window.layout.mode == "sidebar" then 53 else 10),
        PaddingBottom = UDim.new(0, 33),

        Parent = window.searchPage,
    })

    -- Empty state, floated over the content area rather than in the results list so it centres
    -- cleanly. Only shown when a query matches nothing.
    window.searchEmpty = window:Create("TextLabel", {
        Name = "NoResults",
        Text = locale.t("No results"),
        FontFace = variables.brandFont(Enum.FontWeight.Medium),
        TextSize = 15,
        TextTransparency = 0.6,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.55, 0),
        Size = UDim2.fromOffset(200, 20),
        Visible = false,
        ZIndex = 3,

        Parent = window.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- Search pill: takes the tab strip's row, or the head of the content card when the tabs
    -- are down the side. Ported from Window.Search.
    local sidebarLayout = window.layout.mode == "sidebar"
    -- the strip's own row in the top layout; a hair inside the card's top edge in the sidebar,
    -- where search.railWidth keeps the width in step with the rail as it collapses
    local top = if sidebarLayout then window.layout.chromeHeight + 8 else window.layout.tabStripTop + 1

    window.searchPill = window:Create("Frame", {
        Name = "SearchBar",
        AnchorPoint = Vector2.new(if sidebarLayout then 1 else 0.5, 0),
        Position = UDim2.new(if sidebarLayout then 1 else 0.5, if sidebarLayout then -15 else 0, 0, top),
        Size = UDim2.new(1, if sidebarLayout then -(window.layout.railWidth + 30) else -35, 0, 35),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 10,

        BackgroundTransparency = 1, -- shown = 0.9
        Visible = false,

        Parent = window.main,
    })

    window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = window.searchPill,
    })

    window.searchStroke = window:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,

        Transparency = 1, -- shown = 0.85

        Parent = window.searchPill,
    })

    window.searchShadow = window:Create("UIShadow", {
        BlurRadius = UDim.new(0, 20),
        Color = Color3.fromRGB(255, 255, 255),
        ZIndex = -1,

        Transparency = 1, -- shown = 0.92

        Parent = window.searchPill,
    })

    window.searchIcon = window:Create("ImageLabel", {
        Image = "rbxassetid://" .. tostring(constants.icons.search),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 1),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        ZIndex = 10,

        ImageTransparency = 1, -- shown = 0.65

        Parent = window.searchPill,
    }, { ImageColor3 = "ContentColor" })

    window.searchInput = window:Create("TextBox", {
        Text = "",
        PlaceholderText = locale.t("Search all pages"),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 40, 0.5, 0),
        Size = UDim2.new(1, -110, 0, 18),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        ZIndex = 10,

        TextTransparency = 1, -- shown = 0.2

        Parent = window.searchPill,
    }, { TextColor3 = "ContentColor", FontFace = "Font", PlaceholderColor3 = "PlaceholderColor" })

    window:Connect(window.searchInput:GetPropertyChangedSignal("Text"), function()
        if window._searching then
            applyFilter(window, window.searchInput.Text)
        end
    end)

    -- Search action: last in the row (leftmost), toggles the field.
    window.searchAction = action.new(window, {
        name = "Search",
        icon = constants.icons.search,
        order = 4,

        callback = function()
            search.toggle(window)
        end,
    })
    -- keep the icon lit while the field is open, the way the settings cog stays lit on its page
    window.searchAction.isLit = function()
        return window._searching
    end
end

return search

end)() end,
    [19] = function()local wax,script,require=ImportGlobals(19)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Section = {}
Section.__index = Section
Section.__type = "Section"

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)

function Section.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Section",
        icon = properties.icon or properties.Icon,
    }, Section)

    -- first element in a tab shouldn't get extra space above it, only sections that
    -- follow something. this section isn't registered yet so an empty list means first.
    local topSpace = if #self.tab.elements == 0 then 0 else 13

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -40, 0, 20 + topSpace),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    })

    if topSpace > 0 then
        self.window:Create("UIPadding", {
            PaddingTop = UDim.new(0, topSpace),
            Parent = self.main,
        })
    end

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.main,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animation
            ImageTransparency = 1, -- In = 0.65

            Parent = self.main,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        -- Configurables
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(0, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 15,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0.6

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    return self
end

function Section:_setShown(shown, animate)
    local w = self.window
    w:_reveal(self.title, { TextTransparency = if shown then 0.6 else 1 }, animate)
    if self.iconLabel then
        w:_reveal(self.iconLabel, { ImageTransparency = if shown then 0.65 else 1 }, animate)
    end
end

moveable(Section)

return Section

end)() end,
    [20] = function()local wax,script,require=ImportGlobals(20)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- The sidebar layout's rail: a scrolling column of tab rows down the left, with the signed-in
-- player at its base. The rail owns its own width, so it also sizes what that width displaces -
-- the content card and the fade over it. Values ported from RF2-Sidebar.Window.Sidebar.

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local image = require(utility.image)
local locale = require(utility.locale)
local tabSelector = require(script.Parent.tabSelector)
local search = require(script.Parent.search)

local sidebar = {}

-- The profile line's resting brightness, matching the topbar's title over subtitle.
local nameTransparency = 0
local subtitleTransparency = 0.7
local avatarPlateTransparency = 0.95

-- Settling the profile in or out from the settings switch. Quint Out, like every other
-- settle in the window.
local settleInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Whether this window has a profile block to show at all: sidebar layout, a real player, and
-- the user hasn't turned it off.
local function profileVisible(window)
    return window.layout.mode == "sidebar"
        and window.profile ~= nil
        and window.settings.showProfile
        and variables.localPlayer ~= nil
end

local function buildProfile(window, layout)
    local player = variables.localPlayer
    if not player then
        return -- no player to show (Studio server view, or a headless run)
    end

    window.profile = window:Create("Frame", {
        Name = "Profile",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.new(1, 0, 0, layout.footerHeight),
        BackgroundTransparency = 1,

        Parent = window.sidebar,
    })

    window.profileContainer = window:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, layout.rowInset, 0.5, 0),
        Size = UDim2.new(1, -layout.rowInset, 1, 0),
        BackgroundTransparency = 1,

        Parent = window.profile,
    })

    window.profileLayout = window:Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = window.profileContainer,
    })

    -- headshots resolve to a local getcustomasset file in secure mode, fetched async, so it can
    -- land after this builds - hence the onReady that fills it in once it's there
    window.profileAvatar = window:Create("ImageLabel", {
        Name = "Avatar",
        Image = image.avatar(player.UserId, function(uri)
            if window.profileAvatar and not window.unloaded then
                image.assign(window.profileAvatar, "Image", uri)
            end
        end),
        Size = UDim2.fromOffset(layout.avatarSize, layout.avatarSize),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,

        -- Animation
        BackgroundTransparency = 1, -- In = 0.95
        ImageTransparency = 1, -- In = 0

        Parent = window.profileContainer,
    })

    window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = window.profileAvatar,
    })

    window.profileLabels = window:Create("Frame", {
        Size = UDim2.fromOffset(50, layout.avatarSize),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        LayoutOrder = 1,

        Parent = window.profileContainer,
    })

    window:Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = window.profileLabels,
    })

    window.profileName = window:Create("TextLabel", {
        Text = player.DisplayName,
        Size = UDim2.fromOffset(50, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = window.profileLabels,
    }, { TextColor3 = "TitlingColor", FontFace = "Font" })

    -- The dev's line under the name. Nothing set means the name stands on its own rather than
    -- inventing a second line to fill the space.
    window.profileSubtitle = window:Create("TextLabel", {
        Text = "",
        Size = UDim2.fromOffset(50, 14),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Visible = false,

        -- Animation
        TextTransparency = 1, -- In = 0.7

        Parent = window.profileLabels,
    }, { TextColor3 = "TitlingColor", FontFace = "Font" })
end

-- Build the rail and hand back the scrolling frame the tab rows live in. The window keeps it
-- as `tabList`, the same name the top strip uses, so everything downstream is layout-blind.
function sidebar.build(window, layout)
    window.sidebar = window:Create("Frame", {
        Name = "Sidebar",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(0, layout.railWidth, 1, -layout.chromeHeight),
        BackgroundTransparency = 1,

        Visible = false, -- In = true

        Parent = window.main,
    })

    window.tabList = window:Create("ScrollingFrame", {
        Name = "Tabs",
        Active = true,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ClipsDescendants = true,

        Parent = window.sidebar,
    })

    -- the scroller clips, and the selected row's stroke and glow reach past its own box, so
    -- the column is inset the way a tab page insets its elements
    window:Create("UIPadding", {
        PaddingTop = UDim.new(0, layout.railPadding),
        PaddingBottom = UDim.new(0, layout.railPadding),

        Parent = window.tabList,
    })

    window.tabListLayout = window:Create("UIListLayout", {
        Padding = UDim.new(0, layout.rowSpacing),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = window.tabList,
    })

    buildProfile(window, layout)
    sidebar.reflowProfile(window)
end

-- Give the rows back the height the profile isn't using (and vice versa), so a hidden profile
-- leaves no dead strip at the base of the rail.
function sidebar.reflowProfile(window)
    local layout = window.layout
    local shown = profileVisible(window)

    if window.profile then
        window.profile.Visible = shown
    end
    window.tabList.Size = UDim2.new(1, 0, 1, if shown then -layout.footerHeight else 0)
end

-- Take the rail's width, and size what it displaces with it. The card and its fade start where
-- the rail ends, so all three move together or the seam shows.
function sidebar.applyWidth(window, width)
    local layout = window.layout

    window.sidebar.Size = UDim2.new(0, width, 1, -layout.chromeHeight)
    window.elements.Size = UDim2.new(1, -width, 1, -layout.chromeHeight)
    window.bottomFade.Size = UDim2.new(1, -width, layout.fadeSize.Y.Scale, layout.fadeSize.Y.Offset)
    search.railWidth(window, width)

    local collapsed = width < (layout.railWidth :: number)
    for _, tab in window.tabs do
        if not tab.neglectSelector then
            tabSelector.setRowCollapsed(tab, collapsed, layout)
        end
    end

    if window.profileContainer then
        window.profileContainer.Position = UDim2.new(0, if collapsed then 0 else layout.rowInset, 0.5, 0)
        window.profileContainer.Size = UDim2.new(1, if collapsed then 0 else -layout.rowInset, 1, 0)
        window.profileLayout.HorizontalAlignment = if collapsed
            then Enum.HorizontalAlignment.Center
            else Enum.HorizontalAlignment.Left
        window.profileLabels.Visible = not collapsed
    end
end

-- Fade the profile with the rest of the window's chrome. Nil tweenInfo snaps.
function sidebar.setProfileShown(window, shown, tweenInfo)
    if not window.profile or not window.profile.Visible then
        return
    end

    local targets = {
        [window.profileAvatar] = {
            ImageTransparency = if shown then 0 else 1,
            BackgroundTransparency = if shown then avatarPlateTransparency else 1,
        },
        [window.profileName] = { TextTransparency = if shown then nameTransparency else 1 },
        [window.profileSubtitle] = { TextTransparency = if shown then subtitleTransparency else 1 },
    }

    for instance, properties in targets do
        if tweenInfo then
            variables.tweenService:Create(instance, tweenInfo, properties):Play()
        else
            for property, value in properties do
                instance[property] = value
            end
        end
    end
end

-- Flip the profile on or off from settings. It fades out before it goes, and the rows only take
-- its height once it's actually gone, so neither end of the switch snaps.
function sidebar.setProfileEnabled(window, enabled)
    if not window.profile then
        window.settings.showProfile = enabled
        return
    end

    if enabled then
        window.settings.showProfile = true
        sidebar.reflowProfile(window)
        sidebar.setProfileShown(window, true, settleInfo)
        return
    end

    -- still on for the length of the fade, so setProfileShown has something to animate
    sidebar.setProfileShown(window, false, settleInfo)
    task.delay(settleInfo.Time, function()
        if window.unloaded or window.settings.showProfile then
            return -- turned back on mid-fade
        end
        sidebar.reflowProfile(window)
    end)
    window.settings.showProfile = false
end

-- Set the line under the player's name. Empty (or nil) drops the line entirely.
function sidebar.setSubtitle(window, text)
    if not window.profileSubtitle then
        return
    end

    local resolved = if type(text) == "string" and text ~= "" then locale.resolve(text) else nil
    window.profileSubtitle.Text = resolved or ""
    window.profileSubtitle.Visible = resolved ~= nil
end

return sidebar

end)() end,
    [21] = function()local wax,script,require=ImportGlobals(21)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Slider = {}
Slider.__index = Slider
Slider.__type = "Slider"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local odometer = require(utility.odometer)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

-- Decimal places implied by an increment (0.1 -> 1, 0.25 -> 2, 1 -> 0). Used so
-- the readout formats mid-roll floats to the same precision as landed values.
-- Checks against the nearest whole number at each scale so float error can't
-- inflate the count (0.07 * 10 is 0.7000000000000001, still 2 decimals).
local function decimalsOf(step)
    local decimals = 0
    while decimals < 6 do
        local scaled = step * 10 ^ decimals
        if math.abs(scaled - math.round(scaled)) < 1e-9 then
            break
        end
        decimals += 1
    end
    return decimals
end

-- snap onto the increment grid anchored at range[1], so both endpoints stay reachable
-- (a zero-anchored grid cant express range = {0.5, 2.5} with increment 1)
local function snapTo(range, increment, value)
    local snapped = range[1] + math.round((value - range[1]) / increment) * increment
    return math.clamp(snapped, range[1], range[2])
end

local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local heldInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local followInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Below this element width we reflow to the stacked layout (title/value on top, full-width
-- track under it) so the slider stays usable in a narrow column or small window instead of
-- overlapping. Sits well below a full-width slider (~435) - including the slightly narrower
-- width it has before the window's intro grow finishes - and well above a grid column (~180),
-- so those two cases land cleanly on either side and open/close transients never straddle it.
local narrowWidth = 300

-- The pill's two sizes: at rest, and while it's held. Where the pill sits depends on how wide it
-- currently is, so the sizes live next to the geometry that reads them.
local handleRest = Vector2.new(35, 20)
local handleHeld = Vector2.new(41, 22)

-- Where the fill ends, and where the pill sits on the end of it.
--
-- The fill used to run to a plain fraction of the track with the pill hanging off its edge by a
-- fixed amount. That puts the pill outside the track at both ends: past the end at the top of the
-- range, and before the start at the bottom, where the fill has no width at all. A full-width
-- slider has enough margin either side to hide it. A grid column does not, and the pill draws over
-- the card beside it.
--
-- Both are inset by the pill instead, and by half of it where the fill is concerned. At the top of
-- the range the fill is the whole track, so the bar reads as full with the pill on the end of it.
-- At the bottom the fill reaches the middle of the pill, so the pill has green behind its left half
-- and nothing pokes out beside it. The pill lands inside the track at both ends, which is the point.
--
-- How far the two of them reach past the fill's fraction of the track: the whole pill at the bottom
-- of the range, none of it at the top. Whole pixels, because a UDim offset is, and they split this
-- one number between them rather than each halving the pill on its own - rounded apart they'd land
-- a pixel out and hang the pill over the end after all.
-- The pill's centre rides the fill's edge and maps straight onto the track, so at either end
-- half of it hangs past the track the way the design has it. Scale rather than pixels: the fill
-- and the pill read the same ratio, so they can't round apart and drift by a pixel.
local function fillSize(ratio: number): UDim2
    return UDim2.new(ratio, 0, 1, 0)
end

-- The pill sits centred on the fill's leading edge, and it lives inside the fill, so it tracks
-- the value without a position of its own: the fill resizes and carries it. Centred means half
-- of it is past the fill, which at either end of the range is half a pill past the track.
local function handleOffset(): UDim2
    return UDim2.new(1, 0, 0.5, 0)
end

-- The pointer maps over the whole track, because the pill's centre does too. Clamping covers
-- the ends, where half the pill sits past the track.
local function ratioFromPointer(x: number, left: number, travel: number): number
    return math.clamp((x - left) / travel, 0, 1)
end

function Slider.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Slider",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,

        range = properties.range or properties.Range or { 0, 100 },
        increment = properties.increment or properties.Increment or 1,
        suffix = properties.suffix or properties.Suffix or "",

        callback = properties.callback or properties.Callback or function() end,

        dragging = false,
        minimal = properties.minimal or properties.Minimal or false, -- track only, no name/value

        -- Where the pill is headed, which is where it already sits outside a drag
        _handleWidth = handleRest.X,
    }, Slider)

    -- catch a malformed range up front, before the clamp/snap math throws something cryptic
    assert(
        typeof(self.range) == "table" and typeof(self.range[1]) == "number" and typeof(self.range[2]) == "number",
        "A slider range needs two numbers, like { 0, 100 }."
    )

    -- keep range ascending and increment positive so the clamp/snap math stays sane
    if self.range[1] > self.range[2] then
        self.range = { self.range[2], self.range[1] }
    end
    if self.increment <= 0 then
        self.increment = 1
    end

    self.value = if (properties.value or properties.Value) ~= nil
        then (properties.value or properties.Value)
        elseif (properties.currentValue or properties.CurrentValue) ~= nil then (
            properties.currentValue or properties.CurrentValue
        )
        else self.range[1]

    -- snap + clamp the starting value the same way Set does, so the stored value
    -- and the bar never disagree (and a bad initial value can't be saved)
    self.value = snapTo(self.range, self.increment, self.value)

    self._decimals = decimalsOf(self.increment)

    self.flag = properties.flag
        or properties.Flag
        or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)
    self.window:_registerControl(self)

    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 65),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        BackgroundTransparency = 1,

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)
    self._lastValue = self.value

    -- minimal is just the track (built below); skip the whole title/value block
    if not self.minimal then
        self:_buildLabel()
    end

    -- Right: the track
    self.track = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(222, 14),
        BorderSizePixel = 0,
        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    }, { BackgroundColor3 = "SliderBackground" })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 13),

        Parent = self.track,
    })

    self.progress = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1, -- In = 0

        Parent = self.track,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(0, 13),

        Parent = self.progress,
    })

    self.window:Create("UIGradient", {
        Offset = Vector2.new(0, 0.5),
        Rotation = 2,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0),
        }),

        Parent = self.progress,
    }, { Color = { "SliderProgress", functions.toColorSequence } })

    -- Green glow behind the filled progress (revealed on show)
    self.progressGlow = self.window:CreateGlow(self.progress, "AccentColor", 20, 1)

    -- Handle blob: solid white at rest, ghosts + grows a stroke while held
    self.handle = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = handleOffset(), -- rides the fill's edge, see fillSize
        Size = UDim2.fromOffset(handleRest.X, handleRest.Y),
        BorderSizePixel = 0,
        ZIndex = 50,
        BackgroundTransparency = 1, -- In = 0

        Parent = self.progress,
    }, { BackgroundColor3 = "SliderHandle" })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = self.handle,
    })

    -- White glow behind the drag handle (revealed on show)
    self.handleGlow = self.window:CreateGlow(self.handle, Color3.fromRGB(255, 255, 255), 10, 1)

    self.handleStroke = self.window:Create("UIStroke", {
        Transparency = 1, -- 0.6 while held

        Parent = self.handle,
    }, { Color = "SliderStroke" })

    self.interact = self.window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextTransparency = 1,
        ZIndex = 10,

        Parent = self.track,
    })

    -- Subtle hover on the slider track itself, not the whole element row
    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if not self.window:_interactive() then
            return -- window still revealing/hiding: dont light up mid-animation
        end
        variables.tweenService
            :Create(self.track, tweenInfo, { BackgroundColor3 = self.window.theme.SliderBackgroundHover })
            :Play()
    end)

    self.window:ConnectFor(self, self.main.MouseLeave, function()
        variables.tweenService
            :Create(self.track, tweenInfo, { BackgroundColor3 = self.window.theme.SliderBackground })
            :Play()
    end)

    self.window:ConnectFor(self, self.interact.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            hapticEngine.click() -- one tick on grab, not per drag frame
            self.dragging = true
            self:_setHeld(true)
            self:_updateFromMouse()

            -- drop any stale follow first, in case InputBegan fires again before InputEnded
            if self._dragConnection then
                self._dragConnection:Disconnect()
                self._dragConnection = nil
            end

            -- Only run the per-frame follow while actually dragging. Self-terminates if the
            -- window unloads mid-drag, since InputEnded won't fire to clean us up then.
            self._dragConnection = variables.runService.RenderStepped:Connect(function()
                if self.window.unloaded or not self.dragging then
                    if self._dragConnection then
                        self._dragConnection:Disconnect()
                        self._dragConnection = nil
                    end
                    return
                end
                self:_updateFromMouse()
            end)
        end
    end)

    self.window:ConnectFor(self, variables.userInputService.InputEnded, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            self:_endDrag()
        end
    end)

    -- releasing the button outside the Roblox window never fires InputEnded, so treat
    -- losing focus as letting go too - otherwise the slider sticks to the cursor forever
    self.window:ConnectFor(self, variables.userInputService.WindowFocusReleased, function()
        self:_endDrag()
    end)

    if self.description and not self.minimal then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    -- pick wide vs stacked from the real width, and keep it in sync if that width changes
    -- (column resolves its size a frame after we build, and windows can be small)
    self.window:ConnectFor(self, self.main:GetPropertyChangedSignal("AbsoluteSize"), function()
        -- Ignore the transient widths the window sweeps through as it collapses/grows on
        -- hide/show/minimise, so the slider just keeps the mode it settled on while visible.
        -- The one time we DO want a hidden-window reflow is the initial layout pass before the
        -- first open (the element sizes to its real/column width while the window's still
        -- hidden) - so only block hidden reflows once the window has been shown at least once.
        if self.window.animating or (self.window.hidden and self.window.hasShownOnce) then
            return
        end
        self:_applyLayout()
    end)
    self:_applyLayout()

    if self.minimal then
        -- bare: no title/value, keep the compact 41px height so it lines up with
        -- buttons/toggles/stats, and let the track fill the bar
        self.main.Size = UDim2.new(1, -20, 0, 41)
        self.track.AnchorPoint = Vector2.new(0.5, 0.5)
        self.track.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.track.Size = UDim2.new(1, -30, 0, 14)
    end

    self:_renderProgress()

    return self
end

-- The title + value block: the left column in the wide layout, the top row in the narrow
-- one. A minimal slider skips this entirely and shows only the track.
function Slider:_buildLabel()
    -- Left: title (+ icon) stacked over the value
    self.container = self.window:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 20, 0.5, 0),
        Size = UDim2.fromOffset(170, 33),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.main,
    })

    self.containerLayout = self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.container,
    })

    self.titleContainer = self.window:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,

        Parent = self.container,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.titleContainer,
    })

    -- narrow layout puts title + value on one row; this fills the title so the value
    -- gets pushed to the right. wide layout sets it back to None (title over value).
    self.titleFlex = self.window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.None,
        Parent = self.titleContainer,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,

            -- Animation
            ImageTransparency = 1, -- In = 0

            Parent = self.titleContainer,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.new(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, -- ellipsize instead of wrapping when the column's tight
        RichText = true,
        LayoutOrder = 1,
        ZIndex = 5,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = self.titleContainer,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- shrink to share the title row with the icon when space is tight
    self.window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    -- Odometer readout: host frame in place of the old label; the odometer lays
    -- its per-digit reels out inside it, left-aligned under the title.
    self.valueHost = self.window:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 6,
        LayoutOrder = 1, -- sits under the title (wide) / right of it (narrow)

        Parent = self.container,
    })

    self.valueOdo = odometer.new(self.window, self.valueHost, {
        textSize = 15,
        alignment = Enum.HorizontalAlignment.Left,
        transparency = 1, -- revealed to 0.3 on show
        duration = 0.28, -- snappy roll on :Set; drag snaps instead (stays glued to the handle)
    })
    self.valueOdo:snap(self:_format(self.value))
end

-- Set the element height, keeping the width alone when a horizontal group owns it
-- (_widthManaged): there the stack freezes us to _minWidth and wraps, so we must not
-- stomp the X it set. Standalone we take the usual full width.
function Slider:_setMainHeight(height)
    if self._widthManaged then
        self.main.Size = UDim2.new(self.main.Size.X.Scale, self.main.Size.X.Offset, 0, height)
    else
        self.main.Size = UDim2.new(1, -20, 0, height)
    end
end

-- wide: title over value on the left, fixed track on the right.
-- narrow: title + value share the top row (value pushed right), full-width track below.
-- Chosen from the slider's real width, so a slider in a narrow column (a grid) stacks while a
-- full-width one stays wide. The AbsoluteSize handler that calls this ignores the transient
-- widths the window sweeps through as it opens/closes, so this only ever runs on a settled
-- width (see the guard where it's connected).
function Slider:_applyLayout()
    if self.minimal then
        return -- bare mode has a fixed slim layout, nothing to reflow
    end
    local width = self.main.AbsoluteSize.X
    local mode = if width > 0 and width < narrowWidth then "narrow" else "wide"
    if self._layoutMode == mode then
        return
    end
    self._layoutMode = mode

    if mode == "narrow" then
        self:_setMainHeight(70)

        self.container.AnchorPoint = Vector2.new(0, 0)
        self.container.Position = UDim2.new(0, 20, 0, 14)
        self.container.Size = UDim2.new(1, -40, 0, 16)
        self.containerLayout.FillDirection = Enum.FillDirection.Horizontal
        self.titleFlex.FlexMode = Enum.UIFlexMode.Fill -- title grows, value hugs the right
        self.valueHost.AutomaticSize = Enum.AutomaticSize.X
        self.valueHost.Size = UDim2.new(0, 0, 0, 16)

        self.track.AnchorPoint = Vector2.new(0.5, 1)
        self.track.Position = UDim2.new(0.5, 0, 1, -14)
        self.track.Size = UDim2.new(1, -30, 0, 14)
    else
        self:_setMainHeight(65)

        self.container.AnchorPoint = Vector2.new(0, 0.5)
        self.container.Position = UDim2.new(0, 20, 0.5, 0)
        self.container.Size = UDim2.new(0, 170, 0, 33)
        self.containerLayout.FillDirection = Enum.FillDirection.Vertical
        self.titleFlex.FlexMode = Enum.UIFlexMode.None
        self.valueHost.AutomaticSize = Enum.AutomaticSize.None
        self.valueHost.Size = UDim2.new(1, 0, 0, 16)

        self.track.AnchorPoint = Vector2.new(1, 0.5)
        self.track.Position = UDim2.new(1, -15, 0.5, 0)
        self.track.Size = UDim2.new(0, 222, 0, 14)
    end
end

function Slider:_format(value)
    local text = string.format("%." .. self._decimals .. "f", value)
    if self.suffix ~= "" then
        return text .. " " .. self.suffix
    end
    return text
end

-- The one place the track's width and the pill's are read together: how far the pill insets the
-- fill and the pointer, and the room its centre has left to travel. The fill, the pill and the
-- pointer mapping all take these, so they can't come to different answers about the same two
-- numbers. A track too narrow to hold the pill has no travel to give, and neither has one that
-- hasn't been laid out yet - _updateFromMouse turns both away below rather than map onto nothing,
-- which is why neither the fill, the pill nor the pointer needs a guard of its own.
--
-- Travel is the whole track: the pill's centre reaches both ends and half of it hangs past.
function Slider:_pillTravel()
    return math.max(self.track.AbsoluteSize.X, 0)
end

function Slider:_renderProgress(info)
    local span = self.range[2] - self.range[1]
    local ratio = if span ~= 0 then math.clamp((self.value - self.range[1]) / span, 0, 1) else 0

    local size = fillSize(ratio)
    if info then
        variables.tweenService:Create(self.progress, info, { Size = size }):Play()
    else
        self.progress.Size = size
    end
end

function Slider:_updateFromMouse()
    local travel = self:_pillTravel()
    if travel <= 0 then
        return
    end

    local ratio =
        ratioFromPointer(variables.userInputService:GetMouseLocation().X, self.track.AbsolutePosition.X, travel)
    local value = snapTo(self.range, self.increment, self.range[1] + ratio * (self.range[2] - self.range[1]))

    if value ~= self.value then
        self.value = value
        if self.valueOdo then
            self.valueOdo:snap(self:_format(value)) -- glued to the handle: no roll mid-drag
        end
        self._lastValue = value
        self:_renderProgress(followInfo)
        self:_fireCallback(value)
    end
end

-- shared release path: InputEnded and window focus loss both land here
function Slider:_endDrag()
    if not self.dragging then
        return
    end
    self.dragging = false
    self:_setHeld(false)

    if self._dragConnection then
        self._dragConnection:Disconnect()
        self._dragConnection = nil
    end

    self.window:_persist(self)
end

-- Two tweens run over the pill during a drag: this one growing it, and the one _renderProgress
-- starts to follow the value. Roblox cancels an earlier tween when a later one takes the same
-- property, so if both wrote Position the first drag update would kill the grow halfway and leave
-- the pill at an in-between size. They're split by property instead: the held state owns Size and
-- the transparencies, _renderProgress owns Position and the fill. Handing the move over here keeps
-- that true while still putting the pill where its new width wants it.
function Slider:_setHeld(held)
    -- the press already fires with dragging true (the flag is set before the value lands), so
    -- only the release needs a call of its own: it's the one that says the gesture is over.
    -- _endDrag guards on self.dragging, so this can only follow a real drag.
    if not held then
        self:_fireCallback(self.value)
    end

    local target = if held then handleHeld else handleRest
    self._handleWidth = target.X

    variables.tweenService
        :Create(self.handle, heldInfo, {
            Size = UDim2.fromOffset(target.X, target.Y),
            BackgroundTransparency = if held then 0.7 else 0,
        })
        :Play()
    variables.tweenService:Create(self.handleStroke, heldInfo, { Transparency = if held then 0.6 else 1 }):Play()
    self:_renderProgress(heldInfo)
end

-- pcall + debounced error-flash via Window:_runGuarded (fires every drag frame). The second
-- argument says whether the handle is still down, so a callback can show a preview while the
-- value is moving and commit once it settles.
function Slider:_fireCallback(value)
    self.window:_runGuarded(self, self.callback, value, self.dragging == true)
end

function Slider:Set(value, skipCallback)
    value = snapTo(self.range, self.increment, value)
    self.value = value
    if self.valueOdo then
        self.valueOdo:to(self:_format(value), value >= (self._lastValue or value))
    end
    self._lastValue = value
    self:_renderProgress(tweenInfo)

    if not skipCallback then
        self:_fireCallback(value)
        self.window:_persist(self)
    end
end

-- glows delayed so they don't float in before the bar during the window-open fade
local sliderGlowReveal = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0.35)

function Slider:_setShown(shown, animate)
    local w = self.window
    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.track, { BackgroundTransparency = 0 }, animate)
        w:_reveal(self.progress, { BackgroundTransparency = 0 }, animate)
        w:_reveal(self.handle, { BackgroundTransparency = 0 }, animate)
        if self.valueOdo then
            self.valueOdo:reveal(0.3, animate)
        end
        -- soften the accent bloom on light themes (AccentGlow) but never below the default 0.55
        w:_reveal(self.progressGlow, { Transparency = math.max(0.55, w.theme.AccentGlow) }, animate, sliderGlowReveal)
        w:_reveal(self.handleGlow, { Transparency = 0.8 }, animate, sliderGlowReveal)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.track, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.progress, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.handle, { BackgroundTransparency = 1 }, animate)
        if self.valueOdo then
            self.valueOdo:reveal(1, animate)
        end
        w:_reveal(self.progressGlow, { Transparency = 1 }, animate, sliderGlowReveal)
        w:_reveal(self.handleGlow, { Transparency = 1 }, animate, sliderGlowReveal)
    end
end

-- Re-apply the accent glow strength on a runtime ChangeTheme (fill/handle/track ride
-- themeProperties). Called on the visible tab only.
function Slider:_refreshTheme()
    variables.tweenService
        :Create(
            self.progressGlow,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Transparency = math.max(0.55, self.window.theme.AccentGlow) }
        )
        :Play()
end

-- Room the slider needs in a row: its narrow layout puts title + value on the top row,
-- so that has to fit, and we floor it so the track underneath stays draggable.
function Slider:_minWidth()
    if self.minimal then
        return 100 -- a slim bar: side padding + a usable minimum track
    end
    local w = 40 -- container inset, 20 each side
    if self.icon then
        w += 22 -- 16 icon + 6 gap
    end
    -- measure what actually renders: the title shows the translated string
    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))
    w += 12 -- gap before the value
    w += functions.textWidth(self.window.theme.Font, 15, self:_format(self.value))
    return math.max(w, 160)
end

moveable(Slider)
lockable(Slider)

return Slider

end)() end,
    [22] = function()local wax,script,require=ImportGlobals(22)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Statistic = {}
Statistic.__index = Statistic
Statistic.__type = "Statistic"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local odometer = require(utility.odometer)
local moveable = require(utility.moveable)
local constants = require(utility.constants)
local locale = require(utility.locale)
local log = require(utility.log)

-- Accent gradients per direction (fill drives the card + glow, stroke is the brighter edge)
local accents = constants.statAccents

local accentTransparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(1, 0),
})

local compactHeight = 41

local accentTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential)

-- UIShadow glows take one colour, so the halo uses the brightest stop of the direction's fill.
local function glowColor(accent)
    return accent.fill.Keypoints[1].Value
end

local function formatPct(pct)
    if pct > 0 then
        return string.format("+%.1f%%", pct)
    elseif pct < 0 then
        return string.format("%.1f%%", pct)
    else
        return "0%"
    end
end

local function formatValue(value)
    if typeof(value) ~= "number" then
        return tostring(value)
    end
    -- round (matching formatChange) and format without exponent notation so huge
    -- values don't render as "1e+20"
    local rounded = math.round(math.abs(value))
    local s = string.format("%.0f", rounded)
    local result = s:reverse():gsub("%d%d%d", "%0,"):reverse()
    if result:sub(1, 1) == "," then
        result = result:sub(2)
    end
    -- no "-0": a negative that rounds to zero shows plain 0
    return if value < 0 and rounded ~= 0 then "-" .. result else result
end

local function formatChange(delta)
    -- sign follows the rounded value, so a delta that rounds to zero shows plain 0
    local rounded = math.round(delta)
    if rounded > 0 then
        return "+" .. formatValue(rounded)
    elseif rounded < 0 then
        return formatValue(rounded)
    else
        return "0"
    end
end

function Statistic.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Statistic",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,

        value = if (properties.value or properties.Value) ~= nil then (properties.value or properties.Value) else 0,
        -- did we start with a real value, or is the displayed number just a placeholder?
        -- the first Set on a placeholder establishes the baseline instead of showing a change
        _hasValue = (properties.value or properties.Value) ~= nil,

        numberEasing = if (properties.numberEasing ~= nil)
            then properties.numberEasing
            elseif properties.NumberEasing ~= nil then properties.NumberEasing
            else true,

        changeMode = properties.changeMode or properties.ChangeMode or "percentage", -- "percentage" | "absolute"
        changeBaseline = properties.changeBaseline or properties.ChangeBaseline or "previous",

        prefix = properties.prefix or properties.Prefix or "",
        suffix = properties.suffix or properties.Suffix or "",

        -- 41px single-readout card. config opt-in, forced on in a row. only room for
        -- one number, so `display` picks value or % change.
        compact = properties.compact or properties.Compact or tab.compact or false,
        display = (properties.display or properties.Display or "value"), -- "value" | "change"

        _initialValue = if (properties.value or properties.Value) ~= nil
            then (properties.value or properties.Value)
            else nil,
        _lastChange = 0,
    }, Statistic)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end

    if self.description then
        if self.compact then
            log.warn(`Rayfield: a compact stat has no room for a description, ignoring it on '{self.name}'.`)
        else
            self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
        end
    end

    return self
end

-- full 90px card: title, value bottom-left, % change bottom-right
function Statistic:_buildFull()
    local window = self.window

    self.main = window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 90),
        BorderSizePixel = 0,
        Name = self.name,
        ZIndex = 5,

        BackgroundTransparency = 1,

        Parent = self.tab.tabPage,
    }, { BackgroundColor3 = "StatBackground", BackgroundTransparency = "ElementTransparency" })

    window:Create("UICorner", {
        Parent = self.main,
    }, { CornerRadius = "ElementCornerRadius" })

    self.stroke = window:Create("UIStroke", {
        Transparency = 1, -- Animation In = 0
        Color = Color3.fromRGB(255, 255, 255),

        Parent = self.main,
    }, { Transparency = "ElementStrokeTransparency" })

    self.strokeGradient = window:Create("UIGradient", {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.stroke,
        Transparency = accentTransparency,

        Parent = self.stroke,
    })

    self.titleContainer = window:Create("Frame", {
        Size = UDim2.new(1, -40, 0, 32),
        Position = UDim2.fromOffset(20, 15),
        BorderSizePixel = 0,
        LayoutOrder = -1,
        BackgroundTransparency = 1,
        ZIndex = 5,

        Parent = self.main,
    })

    self.gradientContainer = window:Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromOffset(0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1, -- In 0
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,

        Parent = self.main,
    })

    -- Soft accent halo behind the card. UIShadow (no image) is our glow standard; its colour
    -- follows the stat direction and it reveals from hidden to 0.7 like the rest of the card.
    self.glow = window:CreateGlow(self.main, glowColor(accents.neutral), 13, 1)

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(300, 19),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        ZIndex = 10,

        TextTransparency = 1, -- In = 0

        Parent = self.titleContainer,
    }, { TextColor3 = "ContentColor", FontFace = "TitleFont" })

    self.mainGradient = window:Create("UIGradient", {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.fill,
        Transparency = accentTransparency,

        Parent = self.gradientContainer,
    })

    window:Create("UICorner", {
        Parent = self.gradientContainer,
    }, { CornerRadius = "ElementCornerRadius" })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(32, 32),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 10,

            ImageTransparency = 1, -- In = 0

            Parent = self.titleContainer,
        }, { ImageColor3 = "ContentColor" })
    end

    self.containerLayout = window:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.titleContainer,
    })

    -- Value (bottom-left) + change (bottom-right) odometer readouts.
    self.valueHost = window:Create("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 20, 1, -15),
        Size = UDim2.fromOffset(200, 20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,

        Parent = self.main,
    })

    self.changeHost = window:Create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -15),
        Size = UDim2.fromOffset(200, 15),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,

        Parent = self.main,
    })

    self.valueOdo = odometer.new(window, self.valueHost, {
        textSize = 20,
        alignment = Enum.HorizontalAlignment.Left,
        transparency = 1, -- revealed to 0 on show
    })
    self.valueOdo:snap(self:_formatValue(self.value))

    self.changeOdo = odometer.new(window, self.changeHost, {
        textSize = 15,
        alignment = Enum.HorizontalAlignment.Right,
        transparency = 1,
    })
    self.changeOdo:snap(self:_formatChange(0))

    self._accentGradients = { self.strokeGradient, self.mainGradient }
end

-- compact 41px card: icon+title left, one readout right. accent gradient sits on
-- the card (the flexed child), not a separate overlay
function Statistic:_buildCompact()
    local window = self.window

    -- in a row it's content-sized and flexes; standalone it's full-width, no flex item
    local inRow = self.tab.compact or false

    self.main = window:Create("Frame", {
        Name = self.name,
        Size = if inRow then UDim2.fromOffset(0, compactHeight) else UDim2.new(1, -20, 0, compactHeight),
        AutomaticSize = if inRow then Enum.AutomaticSize.X else Enum.AutomaticSize.None,
        ClipsDescendants = true,
        BorderSizePixel = 0,
        ZIndex = 5,

        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = self.tab.tabPage,
    }, { BackgroundColor3 = "StatBackground", BackgroundTransparency = "ElementTransparency" })

    window:Create("UICorner", {
        Parent = self.main,
    }, { CornerRadius = "ElementCornerRadius" })

    self.stroke = window:Create("UIStroke", {
        Transparency = 1, -- In = ElementStrokeTransparency
        Color = Color3.fromRGB(255, 255, 255),

        Parent = self.main,
    }, { Transparency = "ElementStrokeTransparency" })

    self.strokeGradient = window:Create("UIGradient", {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.stroke,
        Transparency = accentTransparency,

        Parent = self.stroke,
    })

    if inRow then
        window:Create("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Fill,
            Parent = self.main,
        })
    end

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,

        Parent = self.main,
    })

    -- accent surface + content: white base + accent gradient, title left, readout right
    self.card = window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, compactHeight),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 5,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    })

    window:Create("UICorner", {
        Parent = self.card,
    }, { CornerRadius = "ElementCornerRadius" })

    self.mainGradient = window:Create("UIGradient", {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.fill,
        Transparency = accentTransparency,

        Parent = self.card,
    })

    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),

        Parent = self.card,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        Padding = UDim.new(0, 10),

        Parent = self.card,
    })

    -- icon + title (left)
    self.titleContainer = window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        ZIndex = 6,

        Parent = self.card,
    })

    -- title gives up room to the readout when tight
    window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.titleContainer,
    })

    window:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.titleContainer,
    })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(20, 20), -- smaller than the full 32
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 6,

            ImageTransparency = 1, -- In = 0

            Parent = self.titleContainer,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        ZIndex = 6,

        TextTransparency = 1, -- In = 0

        Parent = self.titleContainer,
    }, { TextColor3 = "ContentColor", FontFace = "Font" }) -- Medium, like the other row elements

    -- grows to its text, shrinks + ellipsizes when tight
    window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    -- single readout (right)
    self.readoutHost = window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 18),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        ZIndex = 6,

        Parent = self.card,
    })

    self.readoutOdo = odometer.new(window, self.readoutHost, {
        textSize = 17,
        alignment = Enum.HorizontalAlignment.Right,
        transparency = 1,
    })
    self.readoutOdo:snap(self.display == "change" and self:_formatChange(0) or self:_formatValue(self.value))

    self._accentGradients = { self.strokeGradient, self.mainGradient }
end

function Statistic:_setAccent(key, direction)
    local accent = accents[key]
    self.strokeGradient.Color = accent.stroke
    self.mainGradient.Color = accent.fill
    if self.glow then
        self.glow.Color = glowColor(accent)
    end

    -- Subtle rotation + offset shift to give the gradient a bit of life
    local rotation = if direction == 1 then 14 elseif direction == -1 then -10 else 2
    local offset = if direction == 1
        then Vector2.new(0.04, 0.5)
        elseif direction == -1 then Vector2.new(-0.04, 0.5)
        else Vector2.new(0, 0.5)
    for _, gradient in self._accentGradients do
        variables.tweenService:Create(gradient, accentTweenInfo, { Rotation = rotation, Offset = offset }):Play()
    end
end

function Statistic:_formatValue(value)
    return self.prefix .. formatValue(value) .. self.suffix
end

function Statistic:_formatChange(delta)
    if self.changeMode == "absolute" then
        return formatChange(delta)
    else
        return formatPct(delta)
    end
end

-- Put a value on a readout: rolls when number easing is on and there's a previous number to
-- roll from, snaps otherwise. Both card shapes and ResetBaseline go through here.
function Statistic:_showValue(odo, value, previousValue, hasNoHistory)
    if self.numberEasing and not hasNoHistory then
        odo:to(self:_formatValue(value), value >= previousValue)
    else
        odo:snap(self:_formatValue(value))
    end
end

-- full: roll value + change independently
function Statistic:_updateFullReadouts(value, previousValue, targetChange, noChange, infinityText, hasNoHistory)
    self:_showValue(self.valueOdo, value, previousValue, hasNoHistory)

    if infinityText then
        self.changeOdo:snap(infinityText)
        self._lastChange = 0
    elseif self.numberEasing and not noChange then
        self.changeOdo:to(self:_formatChange(targetChange), targetChange >= self._lastChange)
        self._lastChange = targetChange
    else
        self.changeOdo:snap(self:_formatChange(targetChange or 0))
        self._lastChange = targetChange or 0
    end
end

-- compact: roll the one readout
function Statistic:_updateCompactReadout(value, previousValue, targetChange, noChange, infinityText, hasNoHistory)
    if self.display == "change" then
        if infinityText then
            self.readoutOdo:snap(infinityText)
            self._lastChange = 0
        elseif self.numberEasing and not noChange then
            self.readoutOdo:to(self:_formatChange(targetChange), targetChange >= self._lastChange)
            self._lastChange = targetChange
        else
            self.readoutOdo:snap(self:_formatChange(targetChange or 0))
            self._lastChange = targetChange or 0
        end
    else -- "value"
        self:_showValue(self.readoutOdo, value, previousValue, hasNoHistory)
    end
end

function Statistic:Set(value)
    assert(typeof(value) == "number", "Statistic:Set() - value must be a number, got " .. typeof(value))

    local previousValue = self.value
    local hasNoHistory = not self._hasValue
    self.value = value
    self._hasValue = true

    if hasNoHistory then
        self._initialValue = value
    end

    local refValue = if self.changeBaseline == "initial" then self._initialValue else previousValue
    local noChange = hasNoHistory or refValue == value

    -- Determine target change, accent, and direction
    local targetChange, infinityText, accentKey, direction
    if noChange then
        targetChange = 0
        accentKey = "neutral"
        direction = 0
    elseif refValue == 0 then
        local sign = if value > 0 then "+" else "-"
        local suffix = if self.changeMode == "percentage" then "∞%" else "∞"
        infinityText = sign .. suffix
        accentKey = if value > 0 then "positive" else "negative"
        direction = if value > 0 then 1 else -1
    elseif self.changeMode == "percentage" then
        targetChange = ((value - refValue) / math.abs(refValue)) * 100
        direction = if targetChange > 0 then 1 elseif targetChange < 0 then -1 else 0
        accentKey = if direction == 1 then "positive" elseif direction == -1 then "negative" else "neutral"
    else
        targetChange = value - refValue
        direction = if targetChange > 0 then 1 elseif targetChange < 0 then -1 else 0
        accentKey = if direction == 1 then "positive" elseif direction == -1 then "negative" else "neutral"
    end

    self:_setAccent(accentKey, direction)

    if self.compact then
        self:_updateCompactReadout(value, previousValue, targetChange, noChange, infinityText, hasNoHistory)
    else
        self:_updateFullReadouts(value, previousValue, targetChange, noChange, infinityText, hasNoHistory)
    end
end

function Statistic:ResetBaseline(newBaseline)
    local previousValue = self.value
    local hasNoHistory = not self._hasValue
    local baseline = if typeof(newBaseline) == "number" then newBaseline else self.value
    self._initialValue = baseline
    self.value = baseline
    self._hasValue = true
    self._lastChange = 0

    -- change readout drops back to 0; the value readout follows the new baseline
    if self.compact then
        if self.display == "change" then
            self.readoutOdo:snap(self:_formatChange(0))
        else
            self:_showValue(self.readoutOdo, baseline, previousValue, hasNoHistory)
        end
    else
        self.changeOdo:snap(self:_formatChange(0))
        self:_showValue(self.valueOdo, baseline, previousValue, hasNoHistory)
    end

    self:_setAccent("neutral", 0)
end

function Statistic:_setShown(shown, animate)
    local w = self.window

    if self.compact then
        w:_reveal(
            self.main,
            { BackgroundTransparency = if shown then (self.window.theme.ElementTransparency or 0) else 1 },
            animate
        )
        w:_reveal(
            self.stroke,
            { Transparency = if shown then self.window.theme.ElementStrokeTransparency else 1 },
            animate
        )
        w:_reveal(self.card, { BackgroundTransparency = if shown then 0 else 1 }, animate)
        w:_reveal(self.title, { TextTransparency = if shown then 0 else 1 }, animate)
        if self.iconLabel then
            w:_reveal(self.iconLabel, { ImageTransparency = if shown then 0 else 1 }, animate)
        end
        self.readoutOdo:reveal(if shown then 0 else 1, animate)
        return
    end

    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.gradientContainer, { BackgroundTransparency = 0 }, animate)
        w:_reveal(self.glow, { Transparency = 0.82 }, animate)
        self.valueOdo:reveal(0, animate)
        self.changeOdo:reveal(0, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.gradientContainer, { BackgroundTransparency = 1 }, animate)
        w:_reveal(self.glow, { Transparency = 1 }, animate)
        self.valueOdo:reveal(1, animate)
        self.changeOdo:reveal(1, animate)
    end
end

-- Room the compact card needs: padding + icon (and gap) if shown + title text + the gap
-- to the readout + the readout number itself. Lets a horizontal group wrap sensibly.
function Statistic:_minWidth()
    local w = 30 + 10 -- 15+15 card padding, 10 gap between title and readout
    if self.icon then
        w += 26 -- 20 icon + 6 gap
    end
    -- measure what actually renders: the title shows the translated string
    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))
    local readout = if self.display == "change" then self:_formatChange(0) else self:_formatValue(self.value)
    w += functions.textWidth(self.window.theme.Font, 17, readout)
    return w
end

moveable(Statistic)

return Statistic

end)() end,
    [23] = function()local wax,script,require=ImportGlobals(23)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Tab = {}
Tab.__index = Tab
Tab.__type = "Tab"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local assignOrder = require(utility.ordering)
local hapticEngine = require(utility.HapticEngine)
local search = require(script.Parent.search)
local tabSelector = require(script.Parent.tabSelector)

-- Walk a tab or group's children (groups nest) and tear each element down: drop its flag from
-- the window registry and disconnect every connection it owns, so nothing outlives the
-- instances we're about to destroy.
local function teardownElements(window, elements)
    for _, element in elements do
        if element.__type == "Group" then
            teardownElements(window, element.elements)
        else
            window:_unregisterControl(element)
        end

        -- persistent connections filed via window:ConnectFor
        if element.connections then
            for _, connection in element.connections do
                window:Disconnect(connection)
            end
            element.connections = nil
        end

        -- transient, self-managed connections that may still be live if removed mid-interaction
        if element._dragConnection then
            element._dragConnection:Disconnect()
            element._dragConnection = nil
        end
        -- a keybind removed mid-rebind would otherwise leave the window skipping its toggle
        -- key (and every keybind bailing) forever
        if window._recordingKeybind == element then
            window._recordingKeybind = nil
        end
        if element._outsideClickConn then
            window:Disconnect(element._outsideClickConn)
            element._outsideClickConn = nil
        end
    end
end

local selectTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local hoverTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Tab.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        name = properties.name or properties.Name,
        icon = properties.icon or properties.Icon,
        neglectSelector = properties.neglectSelector or properties.NeglectSelector or false,
        customOrder = properties.customOrder or properties.CustomOrder or 0,
        -- when true, controls on this tab default to not persisting to config (the settings tab)
        forgetState = properties.forgetState or properties.ForgetState or false,

        elements = {},
        connections = {}, -- tracked so Remove can drop them without waiting for Unload
    }, Tab)

    -- a tab needs at least one of a name or an icon to show in the selector
    assert(self.name or self.icon, "A tab needs a name or an icon.")

    -- Allow for tabs to be hidden from the tab selector, for Rayfield Settings.
    if not self.neglectSelector then
        tabSelector.build(self, self.window.layout)
    end

    -- Tab Page
    self.tabPage = self.window:Create("ScrollingFrame", {
        Name = self.name,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,

        LayoutOrder = self.customOrder or 0,

        Parent = self.window.elements,
    })

    self.tabPageLayout = self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.tabPage,
    })

    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 33),

        Parent = self.tabPage,
    })

    if not self.neglectSelector then
        table.insert(
            self.connections,
            self.window:Connect(self.topbarItemInteract.MouseButton1Click, function()
                hapticEngine.click()
                self:Select()
            end)
        )

        table.insert(
            self.connections,
            self.window:Connect(self.topbarItemInteract.MouseEnter, function()
                if not self.window:_interactive() then
                    return -- window still revealing/hiding: dont light up mid-animation
                end
                if self.window.selectedTab ~= self then
                    self:_applyVisual("hover", hoverTweenInfo)
                    self:_spinGradients() -- little gradient sweep, same as the intro flourish
                end
            end)
        )

        table.insert(
            self.connections,
            self.window:Connect(self.topbarItemInteract.MouseLeave, function()
                if self.window.selectedTab ~= self then
                    self:_applyVisual("unselected", hoverTweenInfo)
                end
            end)
        )
    end

    -- Auto-select is handled by Window:CreateTab after insertion

    return self
end

function Tab:_applyVisual(stateName, tweenInfo)
    if self.neglectSelector or not self.topbarItem then
        return
    end

    local state = tabSelector.states[self.window.layout.mode][stateName]
    if not state then
        return
    end

    tabSelector.applyVisual(self, state, tweenInfo)
end

-- Flourish: spin the pill's fill + stroke gradients one full turn back to their resting 90deg.
-- Used staggered per tab on the first reveal, and again when hovering an unselected tab.
function Tab:_spinGradients()
    if self.neglectSelector then
        return
    end

    local spinInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    for _, gradient in { self.topbarItemGradient, self.topbarItemStrokeGradient } do
        gradient.Rotation = 90 - 360 -- one full turn shy of rest, so the tween lands clockwise on 90
        variables.tweenService:Create(gradient, spinInfo, { Rotation = 90 }):Play()
    end
end

function Tab:Select(noAnimation)
    -- selecting a tab (e.g. via the settings action) leaves search: bring the strip back,
    -- but let the navigation below pick the page.
    if self.window._searching then
        search.close(self.window, { showTabs = true, jumpTo = false })
    end

    self.window.selectedTab = self
    self.window:_jumpTo(self.tabPage)

    -- noAnimation = initial selection, the pill is still hidden and the window reveal shows it.
    -- a dev calling Navigate/Select before the first Show() hits the same case even without
    -- passing it explicitly - a tween played now would resolve while main is invisible, so the
    -- icon it targets would just pop straight to its end state the moment the window appears
    local skipAnimation = noAnimation or not self.window:_interactive()

    if not self.neglectSelector and not skipAnimation then
        self:_applyVisual("selected", selectTweenInfo)
    end

    for _, tab in self.window.tabs do
        if tab ~= self.window.selectedTab then
            tab:Deselect(skipAnimation)
        end
    end

    if self ~= self.window.rfSettings and self.window.settingsAction and not skipAnimation then
        variables.tweenService
            :Create(
                self.window.settingsAction.iconLabel,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { ImageTransparency = 0.6 }
            )
            :Play()
    end
end

function Tab:Deselect(noAnimation)
    if not self.neglectSelector and not noAnimation then
        self:_applyVisual("unselected", selectTweenInfo)
    end
end

-- shared tail for every CreateX: track it, order it, and reveal it if the window is
-- already open. without this, elements added after Window:Show stay fully transparent.
function Tab:_register(element)
    table.insert(self.elements, element)
    assignOrder(element, #self.elements * 10)
    self.window:_restoreLate(element)

    if not self.window.hidden then
        element:_setShown(true, true)
    end

    return element
end

-- Button
function Tab:CreateButton(properties)
    return self:_register(require(script.Parent.button).new(self, properties))
end

-- Switch/Toggle
function Tab:CreateToggle(properties)
    return self:_register(require(script.Parent.toggle).new(self, properties))
end

function Tab:CreateSwitch(properties)
    return self:CreateToggle(properties)
end

-- Section
function Tab:CreateSection(properties)
    return self:_register(require(script.Parent.section).new(self, properties))
end

-- Text (a title, a body, or both)
function Tab:CreateText(properties)
    return self:_register(require(script.Parent.text).new(self, properties))
end

-- Divider
function Tab:CreateDivider(properties)
    return self:_register(require(script.Parent.divider).new(self, properties))
end

-- Stat
-- Progress bar
function Tab:CreateProgress(properties)
    return self:_register(require(script.Parent.progress).new(self, properties))
end

-- Console / code block
function Tab:CreateConsole(properties)
    return self:_register(require(script.Parent.console).new(self, properties))
end

function Tab:CreateStat(properties)
    return self:_register(require(script.Parent.stat).new(self, properties))
end

-- Slider
function Tab:CreateSlider(properties)
    return self:_register(require(script.Parent.slider).new(self, properties))
end

-- Dropdown
function Tab:CreateDropdown(properties)
    return self:_register(require(script.Parent.dropdown).new(self, properties))
end

-- Input
function Tab:CreateInput(properties)
    return self:_register(require(script.Parent.input).new(self, properties))
end

-- Keybind
function Tab:CreateKeybind(properties)
    return self:_register(require(script.Parent.keybind).new(self, properties))
end

-- Color picker
function Tab:CreateColorPicker(properties)
    return self:_register(require(script.Parent.colorpicker).new(self, properties))
end

-- Group (layout container). A row that wraps by default; pass direction="column" for a
-- column. Nest a row of columns for a grid. Add elements via group:CreateX.
function Tab:CreateGroup(properties)
    return self:_register(require(script.Parent.group).new(self, properties))
end

function Tab:_moveElement(element, targetIndex)
    local idx = table.find(self.elements, element)
    if not idx then
        return
    end
    table.remove(self.elements, idx)
    targetIndex = math.clamp(targetIndex, 1, #self.elements + 1)
    table.insert(self.elements, targetIndex, element)
    for i, el in self.elements do
        assignOrder(el, i * 10)
    end
end

function Tab:Remove()
    local window = self.window

    -- search reparents elements into its results page; close it first so this tabs
    -- units go home before their page is destroyed under them
    if window._searching then
        search.close(window, { showTabs = true, jumpTo = window.selectedTab and window.selectedTab.tabPage })
    end

    local idx = table.find(window.tabs, self)
    if idx then
        table.remove(window.tabs, idx)
    end

    -- If this was the active tab, hand selection to the next visible tab
    if window.selectedTab == self then
        window.selectedTab = nil
        for _, tab in ipairs(window.tabs) do
            if not tab.neglectSelector then
                tab:Select()
                break
            end
        end
    end

    -- Tear every element down (flags + connections) so nothing points at, or fires on, what
    -- we're about to destroy. Groups nest, so walk their children too.
    teardownElements(window, self.elements)

    -- Tear down the UI; nil the refs so _applyVisual (which guards on self.topbarItem)
    -- no-ops instead of touching a destroyed instance.
    for _, connection in self.connections do
        window:Disconnect(connection)
    end
    self.connections = {}

    if self.topbarItem then
        window:DestroySubtree(self.topbarItem)
    end
    if self.tabPage then
        window:DestroySubtree(self.tabPage)
    end
    self.topbarItem = nil
    self.tabPage = nil
    self.elements = {}
end

return Tab

end)() end,
    [24] = function()local wax,script,require=ImportGlobals(24)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- A heading in the sidebar rail, grouping the tab rows under it. Same shape and props as the
-- section in a tab's element list, so a dev who has used one already knows this one.
--
-- The rail only exists in the sidebar layout, so this builds nothing under the top strip.

local TabSection = {}
TabSection.__index = TabSection
TabSection.__type = "TabSection"

local locale = require(script.Parent.Parent.utility.locale)
local log = require(script.Parent.Parent.utility.log)

-- Sections sit further in than the rows they label, so the heading reads as a heading rather
-- than a row that lost its pill. Rows inset by layout.rowInset a side, these by this.
local sectionInset = 20

-- Clearance above a section that follows something. The rail's own list spacing already
-- separates it from the row above; this is the extra that makes it read as a new group.
local spacingAbove = 6

-- And under every section, so the first row beneath it isn't sat tight against the heading.
local spacingBelow = 3

-- Whether anything is already sitting above this one in the rail. The settings tab never gets
-- a row, so it doesn't count, and a section that follows only another section still does.
local function anythingAbove(window)
    for _, tab in window.tabs do
        if not tab.neglectSelector then
            return true
        end
    end
    return #window.tabSections > 0
end

function TabSection.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        name = properties.name or properties.Name or "Section",
        icon = properties.icon or properties.Icon,
    }, TabSection)

    -- the top strip has no rail to head, so there's nowhere to put this. say so once and hand
    -- back a handle that does nothing, rather than half-building something invisible.
    if window.layout.mode ~= "sidebar" then
        if not window._warnedTabSection then
            window._warnedTabSection = true
            log.warn("Rayfield: Window:CreateSection needs the sidebar layout; it does nothing on the top strip.")
        end
        self.inert = true
        return self
    end

    -- height comes from the content and the padding, not a number picked to match them
    self.main = window:Create("Frame", {
        Name = self.name,
        Size = UDim2.new(1, -sectionInset * 2, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Visible = false, -- In = true

        Parent = window.tabList,
    })

    self.padding = window:Create("UIPadding", {
        PaddingTop = UDim.new(0, if anythingAbove(window) then spacingAbove else 0),
        PaddingBottom = UDim.new(0, spacingBelow),

        Parent = self.main,
    })

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,

        Parent = self.main,
    })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 0,

            -- Animation
            ImageTransparency = 1, -- In = 0.65

            Parent = self.main,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),

        Size = UDim2.fromOffset(0, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextWrapped = true,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0.6

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    return self
end

-- Fade with the rows around it. Visible is left alone here, the same way a row's is, so a
-- collapse can fade the rail out before it stops drawing it.
function TabSection:_setShown(shown, animate)
    if not self.main then
        return -- never built (top strip), or already removed
    end
    local w = self.window
    w:_reveal(self.title, { TextTransparency = if shown then 0.6 else 1 }, animate)
    if self.iconLabel then
        w:_reveal(self.iconLabel, { ImageTransparency = if shown then 0.65 else 1 }, animate)
    end
end

function TabSection:_setVisible(visible)
    if self.main then
        self.main.Visible = visible
    end
end

function TabSection:Remove()
    local index = table.find(self.window.tabSections, self)
    if index then
        table.remove(self.window.tabSections, index)
    end
    self.window:DestroySubtree(self.main)
    self.main = nil
end

return TabSection

end)() end,
    [25] = function()local wax,script,require=ImportGlobals(25)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- The thing you click to change tab. A pill in the top strip, a row in the sidebar rail -
-- different shapes, same parts under the same names, so Tab drives either one without knowing
-- which it built. Both read TabBackground/TabStroke/TabColor, so a theme written for one
-- layout already fits the other.

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local locale = require(utility.locale)

local tabSelector = {}

-- A tab needs a name or an icon, not both, so an icon rail has to have something to show for a
-- tab that only has a name. Its first letter stands in - the same thing an avatar or a
-- workspace switcher falls back to. utf8, not string.sub: a name can start with a multi-byte
-- character and half of one renders as nothing.
local function initialOf(name: string?): string
    if type(name) ~= "string" or name == "" then
        return "?"
    end
    local afterFirst = utf8.offset(name, 2)
    local first = if afterFirst then string.sub(name, 1, afterFirst - 1) else name
    return string.upper(first)
end

-- Transparencies per state. The gradients stay put; selection is only ever transparency. A
-- state with no shadow entry leaves the shadow alone, which is how the pill (which has none)
-- and the rail row (which does) share one apply path.
tabSelector.states = {
    top = {
        selected = { background = 0, stroke = 0, content = 0 },
        hover = { background = 0.4, stroke = 0.3, content = 0.3 },
        unselected = { background = 0.8, stroke = 0.65, content = 0.5 },
        hidden = { background = 1, stroke = 1, content = 1 },
    },
    -- the rail row sits on the window rather than on a strip, so its selected fill is lighter
    -- and an unselected row is bare text. Ported from RF2-Sidebar.Window.Sidebar.Options.
    sidebar = {
        selected = { background = 0.4, stroke = 0.5, content = 0, shadow = 0.8 },
        hover = { background = 0.7, stroke = 0.8, content = 0.3, shadow = 1 },
        unselected = { background = 1, stroke = 1, content = 0.5, shadow = 1 },
        hidden = { background = 1, stroke = 1, content = 1, shadow = 1 },
    },
}

-- Fill + stroke gradients, identical on both shapes. Split out so neither builder restates it.
local function addGradients(tab, host, stroke)
    tab.topbarItemGradient = tab.window:Create("UIGradient", {
        Rotation = 90,

        Parent = host,
    }, { Color = { "TabBackground", functions.toColorSequence } })

    tab.topbarItemStrokeGradient = tab.window:Create("UIGradient", {
        Rotation = 90,

        Parent = stroke,
    }, { Color = { "TabStroke", functions.toColorSequence } })
end

local function addContent(tab, iconSize, withInitial)
    -- stands in for the icon while the rail is collapsed; hidden the rest of the time. Only the
    -- rail ever collapses, so the pill has no use for one.
    if withInitial and not tab.icon then
        tab.topbarItemInitial = tab.window:Create("TextLabel", {
            Text = initialOf(tab.name),

            Size = UDim2.fromOffset(iconSize, iconSize),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = iconSize - 4,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            Visible = false,

            -- Animation
            TextTransparency = 1, -- In = 0 / 0.5

            Parent = tab.topbarItemContainer,
        }, { TextColor3 = "TabColor", FontFace = "Font" })
    end

    if tab.icon then
        tab.topbarItemIcon = tab.window:Create("ImageLabel", {
            -- Configurables
            -- raw value: Create routes Image through image.resolve, which already handles
            -- numbers and rbxassetid strings (concat here would double the prefix)
            Image = tab.icon,

            Size = UDim2.fromOffset(iconSize, iconSize),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animation
            ImageTransparency = 1, -- In = 0 / 0.5

            Parent = tab.topbarItemContainer,
        }, { ImageColor3 = "TabColor" })
    end

    if tab.name then
        tab.topbarItemTitle = tab.window:Create("TextLabel", {
            -- Configurables
            Text = locale.t(tab.name), -- tab name

            Size = UDim2.fromOffset(0, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = 16,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,

            -- Animation
            TextTransparency = 1, -- In = 0 / 0.5

            Parent = tab.topbarItemContainer,
        }, { TextColor3 = "TabColor", FontFace = "Font" })
    end
end

-- A pill in the horizontal strip: hugs its own content and grows with the label.
local function buildPill(tab)
    tab.topbarItem = tab.window:Create("Frame", {
        Name = tab.name,
        Size = UDim2.fromOffset(0, 34), -- min size, grows with content
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,

        -- Animation
        BackgroundTransparency = 1, -- In = 0 / 0.8
        Visible = false, -- In = true

        LayoutOrder = tab.customOrder or 0,

        Parent = tab.window.tabList,
    })

    tab.topbarItemInteract = tab.window:Create("TextButton", {
        Active = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = "",
        TextTransparency = 1,

        Parent = tab.topbarItem,
    })

    tab.window:Create("UICorner", {
        Parent = tab.topbarItem,
    }, { CornerRadius = "PillCornerRadius" })

    tab.topbarItemStroke = tab.window:Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),

        -- Animation
        Transparency = 1, -- In = 0 / 0.5

        Parent = tab.topbarItem,
    })

    addGradients(tab, tab.topbarItem, tab.topbarItemStroke)

    tab.topbarItemContainer = tab.window:Create("Frame", {
        Size = UDim2.fromOffset(0, 34),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Parent = tab.topbarItem,
    })

    tab.window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 13),
        PaddingRight = UDim.new(0, 14),

        Parent = tab.topbarItemContainer,
    })

    tab.topbarItemLayout = tab.window:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = tab.topbarItemContainer,
    })

    addContent(tab, 16, false)
end

-- A row in the sidebar rail: the width of the rail, icon then label, left aligned.
local function buildRow(tab, layout)
    tab.topbarItem = tab.window:Create("Frame", {
        Name = tab.name,
        Size = UDim2.new(1, -layout.rowInset * 2, 0, layout.rowHeight),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,

        -- Animation
        BackgroundTransparency = 1, -- In = 0.4 / 1
        Visible = false, -- In = true

        LayoutOrder = tab.customOrder or 0,

        Parent = tab.window.tabList,
    })

    tab.topbarItemInteract = tab.window:Create("TextButton", {
        Active = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = "",
        TextTransparency = 1,

        Parent = tab.topbarItem,
    })

    tab.window:Create("UICorner", {
        CornerRadius = UDim.new(0, layout.rowCornerRadius),

        Parent = tab.topbarItem,
    })

    tab.topbarItemStroke = tab.window:Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),

        -- Animation
        Transparency = 1, -- In = 0.5

        Parent = tab.topbarItem,
    })

    addGradients(tab, tab.topbarItem, tab.topbarItemStroke)

    -- lifts the selected row off the rail. Offset upward so the light reads as coming from
    -- above, the same direction the window's own shadow falls, and the spread pulls the glow
    -- wide and shallow so it hugs the row rather than pooling under it.
    tab.topbarItemShadow = tab.window:Create("UIShadow", {
        BlurRadius = UDim.new(0, 20),
        Color = Color3.fromRGB(255, 255, 255),
        Offset = UDim2.new(0, 0, 0, -15),
        Spread = UDim2.new(0, 10, 0, -30),
        ZIndex = -1,

        -- Animation
        Transparency = 1, -- In = 0.8

        Parent = tab.topbarItem,
    })

    tab.topbarItemContainer = tab.window:Create("Frame", {
        Size = UDim2.new(1, -layout.rowPadding, 0, 24),
        Position = UDim2.new(0, layout.rowPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,

        Parent = tab.topbarItem,
    })

    tab.topbarItemLayout = tab.window:Create("UIListLayout", {
        Padding = UDim.new(0, layout.rowContentSpacing),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = tab.topbarItemContainer,
    })

    addContent(tab, layout.rowIconSize, true)
end

function tabSelector.build(tab, layout)
    if layout.mode == "sidebar" then
        buildRow(tab, layout)
    else
        buildPill(tab)
    end
end

-- Drop the row's label so the rail reads as icons only, or put it back. Snaps rather than
-- tweens: this follows a window resize, which snaps too, so animating it would only ever
-- trail the edge it is meant to sit inside.
function tabSelector.setRowCollapsed(tab, collapsed, layout)
    if layout.mode ~= "sidebar" or not tab.topbarItem then
        return
    end

    if tab.topbarItemTitle then
        tab.topbarItemTitle.Visible = not collapsed
    end
    -- a tab with no icon shows its initial in the icon's place, so the row is never blank
    if tab.topbarItemInitial then
        tab.topbarItemInitial.Visible = collapsed
    end
    local inset = if collapsed then 0 else layout.rowPadding
    tab.topbarItemContainer.Size = UDim2.new(1, -inset, 0, 24)
    tab.topbarItemContainer.Position = UDim2.new(0, inset, 0.5, 0)
    tab.topbarItemLayout.HorizontalAlignment = if collapsed
        then Enum.HorizontalAlignment.Center
        else Enum.HorizontalAlignment.Left
end

-- Apply one state's transparencies to whatever parts this selector actually has.
function tabSelector.applyVisual(tab, state, tweenInfo)
    local targets = {
        [tab.topbarItem] = { BackgroundTransparency = state.background },
        [tab.topbarItemStroke] = { Transparency = state.stroke },
    }

    if tab.topbarItemIcon then
        targets[tab.topbarItemIcon] = { ImageTransparency = state.content }
    end
    if tab.topbarItemTitle then
        targets[tab.topbarItemTitle] = { TextTransparency = state.content }
    end
    if tab.topbarItemInitial then
        targets[tab.topbarItemInitial] = { TextTransparency = state.content }
    end
    if tab.topbarItemShadow and state.shadow then
        targets[tab.topbarItemShadow] = { Transparency = state.shadow }
    end

    for instance, properties in targets do
        if tweenInfo then
            variables.tweenService:Create(instance, tweenInfo, properties):Play()
        else
            for property, value in properties do
                instance[property] = value
            end
        end
    end
end

return tabSelector

end)() end,
    [26] = function()local wax,script,require=ImportGlobals(26)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Tag = {}
Tag.__index = Tag
Tag.__type = "Tag"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local image = require(utility.image)

local defaultColor = Color3.fromRGB(255, 175, 15)
local setTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Tag.new(window, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        text = properties.text or properties.Text or properties.title or properties.Title,
        icon = properties.icon or properties.Icon,
        color = properties.color or properties.Color or defaultColor,
    }, Tag)

    assert(self.icon or (self.text and self.text ~= ""), "A Tag requires an icon, text, or both.")

    self.main = self.window:Create("Frame", {
        Name = "Tag",
        Size = UDim2.fromOffset(10, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = self.color,
        BorderSizePixel = 0,
        LayoutOrder = properties.order or properties.Order or 0,

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.window.tagContainer,
    })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = self.main,
    })

    self.window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.main,
    })

    local contrast = functions.contrastColor(self.color)

    self.iconLabel = self.window:Create("ImageLabel", {
        Name = "Icon",
        Image = self.icon or "",
        ImageColor3 = contrast,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Visible = self.icon ~= nil,
        ZIndex = 5,

        -- Animation
        ImageTransparency = 1, -- In = 0

        Parent = self.main,
    })

    self.title = self.window:Create("TextLabel", {
        Name = "Title",
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(10, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = self.text or "",
        TextColor3 = contrast,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        RichText = true,
        Visible = self.text ~= nil and self.text ~= "",
        LayoutOrder = 1,
        ZIndex = 5,

        -- Animation
        TextTransparency = 1, -- In = 0

        Parent = self.main,
    }, { FontFace = "Font" })

    self.window.tagContainer.Visible = true

    -- if the window's already up, fade in now; otherwise its show handles it
    if not self.window.hidden then
        self:_setShown(true, setTweenInfo)
    end

    return self
end

-- animate is a boolean like every other element's _setShown, or a TweenInfo when a caller
-- (the window's show/hide) wants its own timing. true uses the tag's default fade.
function Tag:_setShown(shown, animate)
    local target = if shown then 0 else 1
    local info = if typeof(animate) == "TweenInfo" then animate elseif animate then setTweenInfo else nil
    if info then
        variables.tweenService:Create(self.main, info, { BackgroundTransparency = target }):Play()
        variables.tweenService:Create(self.iconLabel, info, { ImageTransparency = target }):Play()
        variables.tweenService:Create(self.title, info, { TextTransparency = target }):Play()
    else
        self.main.BackgroundTransparency = target
        self.iconLabel.ImageTransparency = target
        self.title.TextTransparency = target
    end
end

function Tag:SetColor(color)
    self.color = color
    local contrast = functions.contrastColor(color)
    variables.tweenService:Create(self.main, setTweenInfo, { BackgroundColor3 = color }):Play()
    variables.tweenService:Create(self.iconLabel, setTweenInfo, { ImageColor3 = contrast }):Play()
    variables.tweenService:Create(self.title, setTweenInfo, { TextColor3 = contrast }):Play()
end

function Tag:SetText(text)
    self.text = text
    self.title.Text = text or ""
    self.title.Visible = text ~= nil and text ~= ""
end

function Tag:SetIcon(icon)
    self.icon = icon
    image.assign(self.iconLabel, "Image", icon)
    self.iconLabel.Visible = icon ~= nil
end

function Tag:Set(properties)
    if properties.color or properties.Color then
        self:SetColor(properties.color or properties.Color)
    end
    if properties.text or properties.Text or properties.title or properties.Title then
        self:SetText(properties.text or properties.Text or properties.title or properties.Title)
    end
    if properties.icon ~= nil or properties.Icon ~= nil then
        self:SetIcon(properties.icon or properties.Icon)
    end
end

function Tag:Remove()
    -- through the window so the tracked instances and theme entries go with it
    self.window:DestroySubtree(self.main)
    local idx = table.find(self.window.tags, self)
    if idx then
        table.remove(self.window.tags, idx)
    end
    if #self.window.tags == 0 then
        self.window.tagContainer.Visible = false
    end
end

return Tag

end)() end,
    [27] = function()local wax,script,require=ImportGlobals(27)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Copy on a page: a title, a body, or both, on a card of its own. A Section names what follows
-- it and a description belongs to the element above it, so anything that simply needs to say
-- something had nowhere to go.

local Text = {}
Text.__index = Text
Text.__type = "Text"

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)

local titleSize = 16
local bodySize = 14

-- the body sits back from the title, the way a description does under an element name
local bodyShown = 0.45

function Text.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = tostring(properties.name or properties.Name or ""),
        text = tostring(properties.text or properties.Text or ""),
        icon = properties.icon or properties.Icon,
    }, Text)

    -- the card grows with its copy rather than being given a height, since the whole point of
    -- it is text of a length nobody knows in advance
    self.main = self.window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        Name = if self.name ~= "" then self.name else "Text",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        -- Animation
        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = self.window:StyleElementBody(self.main)

    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.main,
    })

    -- the title and its icon share a row so they sit on one line above the body
    self.titleRow = self.window:Create("Frame", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        LayoutOrder = 1,

        Parent = self.main,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,

        Parent = self.titleRow,
    })

    if self.icon then
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            -- Animation
            ImageTransparency = 1, -- In = 0, with the rest of the shared set

            Parent = self.titleRow,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = self.window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.new(1, if self.icon then -22 else 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        RichText = true,
        TextSize = titleSize,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,

        -- Animation
        TextTransparency = 1, -- In = 0, with the rest of the shared set

        Parent = self.titleRow,
    }, { TextColor3 = "TitlingColor", FontFace = "Font" })

    self.body = self.window:Create("TextLabel", {
        Text = locale.t(self.text),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        RichText = true,
        TextSize = bodySize,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,

        -- Animation
        TextTransparency = 1, -- In = bodyShown

        Parent = self.main,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self:_applyPresence()

    return self
end

-- Hide what isn't there, row and all. A hidden child costs the layout nothing, but a visible
-- row holding an empty label still spends its 6px of padding, which is what left a body on its
-- own sitting 20 from the top of the card and 14 from the bottom.
function Text:_applyPresence()
    self.titleRow.Visible = self.name ~= "" or self.icon ~= nil
    self.body.Visible = self.text ~= ""
end

-- Swap the body. It rebinds rather than writing the label directly: the window remembers the
-- source each localised property was built from and re-resolves them all on SetLocale, so a
-- direct write would be undone by the next language change, replaced by a translation of the
-- copy this element no longer shows.
function Text:Set(text)
    self.text = tostring(text)
    self.window:_bindLocale(self.body, "Text", self.text)
    self:_applyPresence()
end

-- Swap the title, on the same terms.
function Text:SetTitle(title)
    self.name = tostring(title)
    self.window:_bindLocale(self.title, "Text", self.name)
    self:_applyPresence()
end

function Text:_setShown(shown, animate)
    -- the card, its stroke, the title and the icon are the shared set every element has
    if shown then
        self.window:_revealCommon(self, animate)
    else
        self.window:_hideCommon(self, animate)
    end

    self.window:_reveal(self.body, { TextTransparency = if shown then bodyShown else 1 }, animate)
end

moveable(Text)

return Text

end)() end,
    [28] = function()local wax,script,require=ImportGlobals(28)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Toast = {}
Toast.__index = Toast
Toast.__type = "Toast"

-- Utility
local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local image = require(utility.image)
local hapticEngine = require(utility.HapticEngine)

-- Timings (Exponential Out, matching the notification feel).
local slideInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- entry travel
local growInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- slot open/close
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- fill + stroke
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- content + shadow
local shrinkInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) -- exit scale

local iconSize = 24 -- a glyph icon
local avatarSize = 32 -- a user headshot (matches the old "signed in as" card)
local leftPadding = 18 -- inside the pill, before the icon/text
local rightPadding = 18 -- trailing room after the text
-- the avatar (profile-chip) variant sits its headshot closer to the edge like the old card
-- and gives the text extra trailing room
local avatarLeftPadding = 10
local avatarRightPadding = 28
local iconGap = 12 -- icon to text
local stackPadding = 8 -- gap between stacked toasts (lives inside each, so it collapses on exit)
local MIN_WIDTH, MAX_WIDTH = 140, 320

-- Roughly what a stack can show. Past this the oldest is retired early rather than left to
-- march offscreen still running its own dwell loop.
local maxLive = 6

-- how far above its slot the pill starts, so it flies in from off the top of the screen
local offscreenAbove = UDim2.new(0.5, 0, 0.5, -180)
local offscreenBelow = UDim2.new(0.5, 0, 0.5, 180)
local centred = UDim2.new(0.5, 0, 0.5, 0)

-- Auto duration from the text length, clamped to a sensible window (matches notifications).
local function autoDuration(text)
    return math.clamp(#text * 0.06 + 3, 3, 9)
end

-- Accept a bare asset id (number) or any ready image string (rbxassetid/rbxthumb/http).
local function resolveImage(icon)
    if type(icon) == "number" then
        return "rbxassetid://" .. tostring(icon)
    end
    return icon
end

function Toast.new(window, properties, container)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        window = assert(window, "Missing argument #1 (Window expected)"),
        title = properties.title or properties.Title or "",
        subtitle = properties.subtitle or properties.Subtitle,
        icon = properties.icon or properties.Icon,
        -- a user id: shows that user's headshot as a larger, edge-hugging avatar (the profile
        -- chip look). takes precedence over icon.
        avatar = properties.avatar or properties.Avatar,
        -- floor the pill width (content is left-aligned, so the slack becomes right-hand room);
        -- the welcome toast uses this to match the old license card, others just hug
        minWidth = properties.minWidth or properties.MinWidth,
        -- put the subtitle line above the title (for label-over-value toasts like "Signed in
        -- as" / name); default is the usual title-on-top
        subtitleAbove = properties.subtitleAbove or properties.SubtitleAbove or false,
        position = properties.position or "Top",
        _hovered = false,
        _dismissed = false,
    }, Toast)

    self.duration = properties.duration or properties.Duration or autoDuration(self.title .. (self.subtitle or ""))

    -- an avatar is a bigger, edge-hugging headshot with roomier trailing padding; a plain icon
    -- is the compact glyph. these drive both the build below and _measure.
    local hasAvatar = self.avatar ~= nil and self.avatar ~= 0
    local hasIcon = hasAvatar or (self.icon ~= nil and self.icon ~= 0 and self.icon ~= "")
    -- headshots resolve to a local getcustomasset file in secure mode, fetched async - so it may
    -- land after the toast builds, hence the onReady that fills the icon in once it's ready
    self._iconImage = if hasAvatar
        then image.avatar(self.avatar, function(uri)
            -- a slow fetch can land after the toast is gone; dont write to a dead label
            if self.iconLabel and not self._dismissed and self.main.Parent then
                image.assign(self.iconLabel, "Image", uri)
            end
        end)
        elseif hasIcon then resolveImage(self.icon)
        else nil
    self._iconSize = if hasAvatar then avatarSize else iconSize
    self._leftPad = if hasAvatar then avatarLeftPadding else leftPadding
    self._rightPad = if hasAvatar then avatarRightPadding else rightPadding
    self._minWidth = math.clamp(self.minWidth or 0, MIN_WIDTH, MAX_WIDTH)
    local hasSubtitle = self.subtitle ~= nil and self.subtitle ~= ""

    -- Outer frame: the stack item. Invisible; only its height animates (open the slot on
    -- entry, collapse it on exit so neighbours slide up into the gap).
    self.main = self.window:Create("Frame", {
        Name = "Toast",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.toast,

        Parent = container or self.window.toasts,
    })

    -- inter-toast gap lives here (not on the stack layout) so it collapses with the card
    self.window:Create("UIPadding", {
        PaddingTop = UDim.new(0, stackPadding),

        Parent = self.main,
    })

    -- Inner body: the visible pill. Centred so the exit width-shrink pulls in symmetrically.
    self.body = self.window:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 1, 0),
        Position = if self.position == "Bottom" then offscreenBelow else offscreenAbove,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true, -- takes clicks for click-to-dismiss
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.toast,

        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    })

    self.window:Create("UIGradient", {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),

        Parent = self.body,
    }, { Color = { "WindowColor", functions.toColorSequence } })

    self.window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),

        Parent = self.body,
    })

    self.stroke = self.window:Create("UIStroke", {
        Transparency = 1, -- In = 0.9

        Parent = self.body,
    }, { Color = "SurfaceStroke" })

    self.shadow = self.window:CreateGlow(self.body, "ShadowColor", 20, 1) -- In = 0.6

    self.window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, self._leftPad),
        PaddingRight = UDim.new(0, self._rightPad),

        Parent = self.body,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, iconGap),

        Parent = self.body,
    })

    if hasIcon then
        -- glyph icons follow the theme's content colour; an avatar headshot stays untinted so the
        -- photo isn't recoloured. circular to suit both
        self.iconLabel = self.window:Create("ImageLabel", {
            Image = self._iconImage,
            Size = UDim2.fromOffset(self._iconSize, self._iconSize),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = constants.zIndex.toastContent,

            BackgroundTransparency = 1, -- In = 0.95 (a faint plate behind avatars)
            ImageTransparency = 1, -- In = 0

            Parent = self.body,
        }, if hasAvatar then nil else { ImageColor3 = "ContentColor" })

        self.window:Create("UICorner", {
            CornerRadius = UDim.new(1, 0),

            Parent = self.iconLabel,
        })
    end

    -- text column hugs its content; the body's AutomaticSize is off (we tween its width) so
    -- this fixed height keeps the row centred
    self.container = self.window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, hasSubtitle and 32 or 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.toastContent,

        Parent = self.body,
    })

    self.window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1),

        Parent = self.container,
    })

    -- the semibold title rides the theme so it tracks secure mode's brand swap and a dev's
    -- fallbackFont; the measure below reads the same key so the hug-width always matches
    self.titleLabel = self.window:Create("TextLabel", {
        Text = self.title,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = if self.subtitleAbove then 2 else 1,
        ZIndex = constants.zIndex.toastContent,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "TitleFont" })

    if hasSubtitle then
        self.subtitleLabel = self.window:Create("TextLabel", {
            Text = self.subtitle,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 14),
            BackgroundTransparency = 1,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = if self.subtitleAbove then 1 else 2,
            ZIndex = constants.zIndex.toastContent,

            TextTransparency = 1, -- In = 0.5

            Parent = self.container,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })
    end

    -- Newest on top: the container is top-anchored, so a smaller LayoutOrder sorts higher.
    self.window._toastCount = (self.window._toastCount or 0) + 1
    self.main.LayoutOrder = -self.window._toastCount

    -- a callback that toasts in a loop would stack pills forever, so retire the oldest once
    -- theres more than the stack can show. top and bottom stacks count separately
    local stacks = self.window._liveToasts
    if not stacks then
        stacks = {}
        self.window._liveToasts = stacks
    end
    local live = stacks[self.main.Parent]
    if not live then
        live = {}
        stacks[self.main.Parent] = live
    end
    self._live = live
    table.insert(live, self)
    while #live > maxLive do
        local oldest = table.remove(live, 1)
        if oldest and oldest ~= self then
            task.spawn(oldest._dismiss, oldest)
        end
    end

    self._connections = {
        self.window:Connect(self.body.MouseEnter, function()
            self._hovered = true
        end),
        self.window:Connect(self.body.MouseLeave, function()
            self._hovered = false
        end),
        self.window:Connect(self.body.InputBegan, function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                self:_dismiss()
            end
        end),
    }

    task.spawn(function()
        self:_show()
    end)

    return self
end

-- Width the pill needs to hug its content, measured without rendering so it grows into place
-- rather than snapping wide first. Height is fixed by line count (icon dictates the minimum).
function Toast:_measure()
    local titleWidth = functions.textWidth(self.window.theme.TitleFont, 16, self.title)
    local subtitleWidth = if self.subtitleLabel
        then functions.textWidth(self.window.theme.Font, 14, self.subtitle)
        else 0
    local textWidth = math.max(titleWidth, subtitleWidth)

    local left = if self.iconLabel then self._leftPad + self._iconSize + iconGap else self._leftPad
    local width = math.clamp(left + textWidth + self._rightPad, self._minWidth, MAX_WIDTH)

    -- past the cap the labels stop hugging: pin them to the text column and truncate, so long
    -- text ends in an ellipsis instead of spilling past the pill edge
    if left + textWidth + self._rightPad > MAX_WIDTH then
        local column = MAX_WIDTH - left - self._rightPad
        for _, label in { self.titleLabel, self.subtitleLabel } do
            if label then
                label.AutomaticSize = Enum.AutomaticSize.None
                label.TextTruncate = Enum.TextTruncate.AtEnd
                label.Size = UDim2.fromOffset(column, label.Size.Y.Offset)
            end
        end
    end

    local textHeight = if self.subtitleLabel then 16 + 1 + 14 else 16
    local height = math.max(textHeight, if self.iconLabel then self._iconSize else 0) + 18

    return width, height
end

-- Enter: open the slot to full height while the pill drops in from above and fades, staggering
-- the content the way a notification does.
function Toast:_show()
    if not self.main.Parent then
        return
    end

    hapticEngine.notify()

    local width, height = self:_measure()
    if self._dismissed or not self.main.Parent then
        return -- evicted mid-measure; dont replay the entrance over the exit
    end
    self.main.Size = UDim2.new(0, width, 0, 0)

    -- +stackPadding because the outer's top padding holds the inter-toast gap
    variables.tweenService:Create(self.main, growInfo, { Size = UDim2.new(0, width, 0, height + stackPadding) }):Play()
    variables.tweenService:Create(self.body, slideInfo, { Position = centred }):Play()
    variables.tweenService:Create(self.body, fadeLong, { BackgroundTransparency = 0 }):Play()
    variables.tweenService:Create(self.stroke, fadeLong, { Transparency = 0.9 }):Play()
    variables.tweenService:Create(self.shadow, fadeShort, { Transparency = 0.6 }):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, { TextTransparency = 0 }):Play()

    task.wait(0.05)
    if self._dismissed or not self.main.Parent then
        return -- dismissed mid-stagger; dont fight the exit fade
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, { BackgroundTransparency = 0.95 }):Play()
        variables.tweenService:Create(self.iconLabel, fadeShort, { ImageTransparency = 0 }):Play()
    end

    task.wait(0.05)
    if self._dismissed or not self.main.Parent then
        return
    end
    if self.subtitleLabel then
        variables.tweenService:Create(self.subtitleLabel, fadeShort, { TextTransparency = 0.5 }):Play()
    end

    -- Dwell, pausing while hovered.
    local elapsed = 0
    while elapsed < self.duration and not self._dismissed and self.main.Parent do
        local dt = task.wait()
        if not self._hovered then
            elapsed += dt
        end
    end

    self:_dismiss()
end

-- Exit: fade out while the pill shrinks (width + height collapse) - the notification exit.
function Toast:_dismiss()
    if self._dismissed then
        return
    end
    self._dismissed = true

    local live = self._live
    local index = live and table.find(live, self)
    if live and index then
        table.remove(live, index)
    end

    if not self.main.Parent then
        return
    end

    variables.tweenService:Create(self.body, fadeLong, { BackgroundTransparency = 1 }):Play()
    variables.tweenService:Create(self.stroke, fadeLong, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.shadow, fadeShort, { Transparency = 1 }):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, { TextTransparency = 1 }):Play()
    if self.subtitleLabel then
        variables.tweenService:Create(self.subtitleLabel, fadeShort, { TextTransparency = 1 }):Play()
    end
    if self.iconLabel then
        variables.tweenService
            :Create(self.iconLabel, fadeShort, { ImageTransparency = 1, BackgroundTransparency = 1 })
            :Play()
    end

    variables.tweenService:Create(self.body, shrinkInfo, { Size = UDim2.new(1, -60, 1, 0) }):Play()
    local collapse =
        variables.tweenService:Create(self.main, shrinkInfo, { Size = UDim2.new(0, self.main.Size.X.Offset, 0, 0) })
    collapse:Play()
    collapse.Completed:Wait()

    if not self.main.Parent then
        return
    end

    for _, connection in self._connections do
        self.window:Disconnect(connection)
    end
    self.window:DestroySubtree(self.main)
end

return Toast

end)() end,
    [29] = function()local wax,script,require=ImportGlobals(29)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local Toggle = {}
Toggle.__index = Toggle
Toggle.__type = "Toggle"

-- Utility
local utility = script.Parent.Parent.utility

-- Variables
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

function Toggle.new(tab, properties)
    properties = if typeof(properties) == "table" then properties else {}

    local self = setmetatable({
        tab = assert(tab, "Missing argument #1 (Tab expected)"),
        window = tab.window,
        name = properties.name or properties.Name or "Switch",
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState, -- dont save config for this element if true.
        compact = tab.compact or false, -- true when the host is a Row

        flag = properties.flag
            or properties.Flag
            or (
                not (properties.forgetState or properties.ForgetState or tab.forgetState)
                    and functions.deriveFlagFromName(properties.name or properties.Name or "Switch")
                or nil
            ),

        callback = properties.callback or properties.Callback or function() end,

        value = if (properties.value or properties.Value) ~= nil then (properties.value or properties.Value) else false,
    }, Toggle)

    -- register as a saveable control if flagged (works in a row too)
    self.window:_registerControl(self)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end

    if self.description and not self.compact then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, { description = self.description })
    end

    return self
end

-- the pill switch. same in both layouts; caller places it (pinned right / flex item)
function Toggle:_buildSwitch(parent)
    local window = self.window

    self.functionContainer = window:Create("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(50, 21),

        BackgroundTransparency = 1, -- In = ToggleTrackTransparency

        Parent = parent,
    }, { BackgroundColor3 = "ToggleTrack" })

    window:Create("UICorner", {
        CornerRadius = UDim.new(0, 15),
        Parent = self.functionContainer,
    })

    self.containerStroke = window:Create("UIStroke", {
        Transparency = 1, -- In = 0.85
        Parent = self.functionContainer,
    }, { Color = "SurfaceStroke" })

    self.indicator = window:Create("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(25, 17),
        Position = self.value and UDim2.new(1, -28, 0.5, 0) or UDim2.new(1, -47, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.value and self.window.theme.AccentColor or self.window.theme.ToggleKnobOff,

        BackgroundTransparency = 1, -- In = 0.8

        Parent = self.functionContainer,
    })

    window:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = self.indicator,
    })

    self.indicatorStroke = window:Create("UIStroke", {
        Color = self.value and self.window.theme.AccentStroke or Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- In = 0.7
        Parent = self.indicator,
    })

    -- Accent glow behind the selector; hidden until on (gated by Transparency: 1 hidden, AccentGlow shown)
    self.indicatorGlow = window:CreateGlow(self.indicator, "AccentColor", 20, 1)

    -- Dark wash over the switch for light themes (hidden on dark themes via DarkToggleOverlay).
    self.overlay = window:Create("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        BackgroundTransparency = 1, -- In = 0

        Parent = self.functionContainer,
    }, { Visible = "DarkToggleOverlay" })

    window:Create("UICorner", {
        CornerRadius = UDim.new(0, 15),
        Parent = self.overlay,
    })

    self.overlayGradient = window:Create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.35),
        }),

        Parent = self.overlay,
    })

    return self.functionContainer
end

-- flip, animate, run callback (error-flash on fail), autosave. press anim is per-layout
function Toggle:_performToggle()
    hapticEngine.click()
    self.value = not self.value
    self:_animateIndicator()

    self.window:_runGuarded(self, self.callback, self.value)
    self.window:_persist(self)
end

-- full-width: title/icon left, pill pinned right, width-bounce
function Toggle:_buildFull()
    local window = self.window

    self.main = window:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),

        BackgroundTransparency = 1,

        Parent = self.tab.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    self.stroke = window:StyleElementBody(self.main)
    self.hoverOverlay = window:CreateHoverOverlay(self.main)

    self.container = window:Create("Frame", {
        BorderSizePixel = 0,

        Parent = self.main,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
    })

    self.containerLayout = window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,

            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(250, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    self.interact = window:Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(1, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        TextTransparency = 1,
        ZIndex = 10,

        Parent = self.main,
    })

    -- pill pinned to the right edge
    self:_buildSwitch(self.main)
    self.functionContainer.Position = UDim2.new(1, -15, 0, 20)
    self.functionContainer.AnchorPoint = Vector2.new(1, 0.5)

    self.window:_wireElementHover(self)

    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }
            )
            :Play()
        variables.tweenService
            :Create(
                self.main,
                TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { Size = UDim2.new(1, -26, 0, 41) }
            )
            :Play()

        self:_performToggle()

        task.wait(0.11)

        variables.tweenService
            :Create(
                self.main,
                TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { Size = UDim2.new(1, -20, 0, 41) }
            )
            :Play()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = self.window.theme.ElementStrokeTransparency }
            )
            :Play()
    end)
end

-- compact (row): title left, pill right (SpaceBetween)
function Toggle:_buildCompact()
    local window = self.window

    -- interact sits at ZIndex 10 so the switch pill layers cleanly over the row (see button.luau)
    self.main, self.stroke, self.interact = window:_buildCompactRow(self.tab, self.name, 10)
    self.hoverOverlay = self.interact

    window:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),

        Parent = self.interact,
    })

    -- title left, pill right
    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        Padding = UDim.new(0, 10),

        Parent = self.interact,
    })

    self.container = window:Create("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,

        Parent = self.interact,
    })

    -- text gives up room to the pill when tight
    window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.container,
    })

    window:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,

        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = window:Create("ImageLabel", {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,

            ImageTransparency = 1, -- In = 0

            Parent = self.container,
        }, { ImageColor3 = "ContentColor" })
    end

    self.title = window:Create("TextLabel", {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,

        TextTransparency = 1, -- In = 0

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    -- grows to its text, shrinks + ellipsizes when tight
    window:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    -- pill as the right-hand flex item
    self:_buildSwitch(self.interact)
    self.functionContainer.LayoutOrder = 1

    self.window:_wireElementHover(self)

    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = 1 }
            )
            :Play()

        self:_performToggle()

        task.wait(0.11)

        variables.tweenService
            :Create(
                self.stroke,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Transparency = self.window.theme.ElementStrokeTransparency }
            )
            :Play()
    end)
end

function Toggle:_animateIndicator()
    local info = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    if self.indicatorGlow then
        variables.tweenService
            :Create(self.indicatorGlow, info, { Transparency = self.value and self.window.theme.AccentGlow or 1 })
            :Play()
    end
    if self.value then
        variables.tweenService
            :Create(self.indicator, info, {
                Position = UDim2.new(1, -28, 0.5, 0),
                BackgroundColor3 = self.window.theme.AccentColor,
                BackgroundTransparency = 0,
            })
            :Play()
        variables.tweenService
            :Create(self.indicatorStroke, info, { Color = self.window.theme.AccentStroke, Transparency = 0 })
            :Play()
    else
        variables.tweenService
            :Create(self.indicator, info, {
                Position = UDim2.new(1, -47, 0.5, 0),
                BackgroundColor3 = self.window.theme.ToggleKnobOff,
                BackgroundTransparency = self.window.theme.ToggleKnobOffTransparency,
            })
            :Play()
        variables.tweenService
            :Create(self.indicatorStroke, info, { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.7 })
            :Play()
    end
end

local toggleReveal = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
-- glow delayed so it doesn't bleed through the fill fade-in on window open
local toggleGlowReveal = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0.35)

function Toggle:_setShown(shown, animate)
    local w = self.window
    if shown then
        w:_revealCommon(self, animate)
        -- carry the state colours here too, so revealing on a tab switch also picks up the theme
        w:_reveal(self.indicator, {
            BackgroundColor3 = self.value and w.theme.AccentColor or w.theme.ToggleKnobOff,
            BackgroundTransparency = self.value and 0 or w.theme.ToggleKnobOffTransparency,
        }, animate, toggleReveal)
        w:_reveal(self.indicatorStroke, {
            Color = self.value and w.theme.AccentStroke or Color3.fromRGB(255, 255, 255),
            Transparency = self.value and 0 or 0.7,
        }, animate, toggleReveal)
        w:_reveal(
            self.indicatorGlow,
            { Transparency = self.value and w.theme.AccentGlow or 1 },
            animate,
            toggleGlowReveal
        )
        w:_reveal(self.overlay, { BackgroundTransparency = 0 }, animate, toggleReveal)
        w:_reveal(self.containerStroke, { Transparency = 0.85 }, animate, toggleReveal)
        w:_reveal(
            self.functionContainer,
            { BackgroundTransparency = w.theme.ToggleTrackTransparency },
            animate,
            toggleReveal
        )
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.indicator, { BackgroundTransparency = 1 }, animate, toggleReveal)
        w:_reveal(self.indicatorStroke, { Transparency = 1 }, animate, toggleReveal)
        w:_reveal(self.indicatorGlow, { Transparency = 1 }, animate, toggleGlowReveal)
        w:_reveal(self.overlay, { BackgroundTransparency = 1 }, animate, toggleReveal)
        w:_reveal(self.containerStroke, { Transparency = 1 }, animate, toggleReveal)
        w:_reveal(self.functionContainer, { BackgroundTransparency = 1 }, animate, toggleReveal)
    end
end

-- Re-apply the visuals that aren't plain themeProperties (the knob's state colour + the reveal
-- transparencies) so a runtime ChangeTheme reaches the switch. Called on the visible tab only.
function Toggle:_refreshTheme()
    local t = self.window.theme
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local ts = variables.tweenService
    ts:Create(self.functionContainer, info, { BackgroundTransparency = t.ToggleTrackTransparency }):Play()
    ts:Create(self.indicator, info, {
        BackgroundColor3 = self.value and t.AccentColor or t.ToggleKnobOff,
        BackgroundTransparency = self.value and 0 or t.ToggleKnobOffTransparency,
    }):Play()
    ts:Create(self.indicatorStroke, info, {
        Color = self.value and t.AccentStroke or Color3.fromRGB(255, 255, 255),
    }):Play()
    if self.indicatorGlow then
        ts:Create(self.indicatorGlow, info, { Transparency = self.value and t.AccentGlow or 1 }):Play()
    end
end

-- Room the compact toggle needs: side padding + icon (and gap) if shown + title text
-- + the gap to the pill + the pill itself. Lets a horizontal group wrap sensibly.
function Toggle:_minWidth()
    local w = 30 + 10 + 50 -- 15+15 padding, 10 gap to pill, 50 pill
    if self.icon then
        w += 21 -- 16 icon + 5 gap
    end
    -- measure what actually renders: the title shows the translated string
    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))
    return w
end

moveable(Toggle)
lockable(Toggle)

function Toggle:Set(value, skipCallback)
    local changed = self.value ~= value
    self.value = value

    if changed then
        self:_animateIndicator()
    end

    -- fire even when unchanged: config load calls Set and relies on the callback to apply
    if not skipCallback then
        self.window:_runGuarded(self, self.callback, self.value)
        self.window:_persist(self) -- skipCallback means apply quietly, so dont autosave either
    end
end

return Toggle

end)() end,
    [30] = function()local wax,script,require=ImportGlobals(30)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Utility
local utility = script.Parent.Parent.utility
local image = require(utility.image)
local functions = require(utility.functions)
local persistence = require(utility.persistence)
local constants = require(utility.constants)
local locale = require(utility.locale)
local log = require(utility.log)
local hapticEngine = require(utility.HapticEngine)
local windowSizing = require(utility.windowSizing)
local layouts = require(utility.layouts)
local chrome = require(script.Parent.chrome)
local search = require(script.Parent.search)
local sidebar = require(script.Parent.sidebar)

-- Variables
local variables = require(utility.variables)

-- Themes
local themes = script.Parent.Parent.themes

-- Module
local Window = {}
Window.__index = Window

-- Default entrance-reveal tween (elements override with their own where needed)
local revealInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- The collapsed "pill" main morphs into on Hide, top-anchored the way the old standalone
-- restore button used to sit. showIconOnly trades the label for a round badge.
local collapsedSize = UDim2.fromOffset(185, 50)
local collapsedIconSize = UDim2.fromOffset(50, 50)
local collapsedTop = UDim2.new(0.5, 0, 0, 20)
local topToastOpenPosition = UDim2.new(0.5, 0, 0, 12)
local topToastClosedPosition = UDim2.new(0.5, 0, 0, collapsedTop.Y.Offset + collapsedSize.Y.Offset + 12)
local topToastMoveInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Width of the top-centre toast stack container. Toasts hug their own content and centre
-- within it, so this just needs to be at least the toast's own max width.
local maxToastWidth = 320

-- Standard element row height, shared by the compact button/toggle scaffold.
local compactRowHeight = 41

-- A locked element just dims: light enough that you can still read what it was, heavy enough
-- that it reads as out of reach. Nothing is laid over the top - a panel covering the row hides
-- the very thing you are being told is locked. The reason goes in the description underneath,
-- where there is nothing to compete with it.
local lockScrimTransparency = 0.55
local lockedDescriptionTransparency = 0.55

-- How the tab selector arrives on first reveal: a quick ripple, capped so a long tab list
-- doesn't turn the entrance into a queue.
local tabStagger = 0.04
local maxStaggeredTabs = 8

-- How often the backstop re-checks the fit, for anything the viewport signal misses.
local viewportReconcileInterval = 2

-- The size the current screen calls for, for this window's layout. Everything downstream (the
-- reveal target, drag clamp, collapse) reads self.size, so it all inherits whatever this returns.
local function fitWindowSize(mode): UDim2
    local camera = variables.workspace.CurrentCamera
    return windowSizing.fit(camera and camera.ViewportSize, mode)
end

-- Per-corner radii are newer than the oldest clients Rayfield runs on, so a shape that only
-- rounds some of its corners has to check before it asks. Everything still gets a radius on a
-- client without them, just the same one on all four.
local cornerNames = { "TopLeftRadius", "TopRightRadius", "BottomLeftRadius", "BottomRightRadius" }

local perCornerSupported = (function()
    return (
        pcall(function()
            local probe = Instance.new("UICorner")
            probe.TopLeftRadius = UDim.new(0, 1)
            probe:Destroy()
        end)
    )
end)()

-- Resolve the sidebarLayout property: tabs down the left instead of across the top.
local function resolveLayout(value)
    return if value then layouts.sidebar else layouts.top
end

-- Keys that drive a UIGradient and so want a ColorSequence. A dev may pass a plain Color3 for
-- any of these and we widen it to a flat sequence, so a theme reads the same either way.
local gradientKeys = {
    WindowColor = true,
    ElementGradient = true,
    ElementStrokeGradient = true,
    TabBackground = true,
    TabStroke = true,
    SliderProgress = true,
}

local function coerceThemeValue(key, value)
    if gradientKeys[key] and typeof(value) == "Color3" then
        return ColorSequence.new(value)
    end
    return value
end

local function firstColor(value)
    return if typeof(value) == "ColorSequence" then value.Keypoints[1].Value else value
end

local function setTopToastPosition(window, animate)
    local container = window._toastsTop
    if not container then
        return
    end

    local target = if window._collapsedShown then topToastClosedPosition else topToastOpenPosition
    if not animate or container.Position == target then
        container.Position = target
        return
    end

    variables.tweenService:Create(container, topToastMoveInfo, { Position = target }):Play()
end

-- A subtle raised edge for a fill: lighten a dark fill, darken a light one.
local function edgeShade(color, amount)
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
    local target = if luminance > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)
    return color:Lerp(target, amount)
end

-- Give a custom theme sensible strokes for free: when it recolours a surface but leaves the
-- matching stroke unset, derive one from the fill so a colours-only theme still reads coherently.
local function deriveStrokes(resolved, overrides)
    if overrides.ElementGradient then
        local fill = firstColor(resolved.ElementGradient)
        if overrides.ElementStroke == nil then
            resolved.ElementStroke = edgeShade(fill, 0.28)
        end
        if overrides.ElementStrokeGradient == nil then
            resolved.ElementStrokeGradient = ColorSequence.new(edgeShade(fill, 0.4))
        end
        if overrides.ElementStrokeHover == nil then
            resolved.ElementStrokeHover = edgeShade(fill, 0.52)
        end
    end
    if overrides.TabBackground and overrides.TabStroke == nil then
        resolved.TabStroke = ColorSequence.new(edgeShade(firstColor(resolved.TabBackground), 0.4))
    end
end

-- Resolve a theme arg to its raw key set: a table is taken as-is (partial is fine), a known
-- name is required, anything else falls back to default. Read-only - callers never mutate it,
-- so the require()-cached module stays clean for other windows.
local function themeOverrides(value)
    if typeof(value) == "table" then
        return value
    elseif typeof(value) == "string" then
        local named = themes:FindFirstChild(string.lower(value))
        if named then
            return require(named)
        end
        -- a typo'd name shouldnt crash the menu; warn and fall back so the UI still builds
        log.warn("Rayfield: unknown theme '" .. value .. "', using default")
    elseif value ~= nil then
        log.warn("Rayfield: invalid theme (expected a built-in name or a theme table), using default")
    end
    return require(themes["default"])
end

-- A complete theme for first paint: default filled in with the given overrides, so a partial
-- custom theme only needs the keys it wants to change and the rest fall back to default.
local function resolveTheme(value)
    local resolved = table.clone(require(themes["default"]))
    local overrides = themeOverrides(value)
    for key, override in overrides do
        resolved[key] = coerceThemeValue(key, override)
    end
    -- only a hand-written table gets derived strokes; a named built-in ships its own.
    if typeof(value) == "table" then
        deriveStrokes(resolved, overrides)
    end

    -- theme modules call brandFont at first require and are cached from then on, so a
    -- fallbackFont set afterwards would never reach them. recompute against the current
    -- stand-in, unless the dev named a font themselves.
    local userTable = if typeof(value) == "table" then value else nil
    if not (userTable and (userTable.Font or userTable.font)) then
        resolved.Font = variables.brandFont(Enum.FontWeight.Medium)
    end
    if not (userTable and (userTable.TitleFont or userTable.titleFont)) then
        resolved.TitleFont = variables.brandFont(Enum.FontWeight.SemiBold)
    end

    return resolved
end

function Window.new(properties)
    properties = if typeof(properties) == "table" then properties else {}

    -- Localization is global to the running UI: a dev translator (if any) and the active locale
    -- live on the locale module. Default the locale to the player's language unless the dev pins
    -- one. Set before any label is built so the first render is already in the right language.
    if properties.translations or properties.Translations then
        locale.register(properties.translations or properties.Translations)
    end
    if properties.translator or properties.Translator then
        locale.translator = properties.translator or properties.Translator
    end
    locale.setActive(properties.locale or properties.Locale or locale.detect())

    -- a dev can pick the stand-in font shown while the brand font downloads in secure mode; set it
    -- before resolveTheme below so the theme's brandFont picks it up
    local fallbackFont = properties.fallbackFont or properties.FallbackFont
    if fallbackFont then
        variables.setFallbackFont(fallbackFont)
    end

    -- the layout decides the window's whole shape, so it has to settle before the first fit
    local layout = resolveLayout(properties.sidebarLayout or properties.SidebarLayout)

    local self = setmetatable({
        name = properties.name or properties.Name or "Slate Window",
        subheading = properties.subtitle or properties.Subtitle,
        layout = layout,
        size = fitWindowSize(layout.mode),
        instances = {},
        connections = {},

        icon = properties.icon or properties.Icon or constants.icons.slate,
        showName = properties.showName or properties.ShowName or "Slate",
        showIcon = properties.showIcon or properties.ShowIcon or constants.icons.slate,
        -- collapse to a round badge rather than an icon-and-label pill
        showIconOnly = properties.showIconOnly or properties.ShowIconOnly or false,
        -- the line under the player's name in the sidebar's profile block
        profileText = properties.profile or properties.Profile,

        themeProperties = {},
        localeProperties = {},
        tabs = {},
        tabSections = {},
        tags = {},
        selectedTab = nil,
        theme = resolveTheme(properties.theme or properties.Theme),

        controls = {},

        configuration = (function()
            local cfg = properties.configuration or properties.Configuration
            if not cfg then
                return {}
            end
            return {
                autoSave = cfg.autoSave or cfg.AutoSave,
                autoLoad = cfg.autoLoad or cfg.AutoLoad,
                fileName = cfg.fileName or cfg.FileName,
                customFolder = cfg.customFolder or cfg.CustomFolder,
            }
        end)(),
    }, Window)

    -- Public, always-live view of every saved control, keyed by flag. Reading returns the
    -- control's current value; assigning routes through its Set so the UI and callback fire.
    self.Flags = setmetatable({}, {
        __index = function(_, flag)
            local control = self.controls[flag]
            return control and control.value
        end,
        __newindex = function(_, flag, value)
            local control = self.controls[flag]
            if not control then
                log.warn("Rayfield: no flag '" .. tostring(flag) .. "' to set")
                return
            end
            control:Set(value)
        end,
        __iter = function()
            local flag
            return function()
                local control
                flag, control = next(self.controls, flag)
                if flag then
                    return flag, control.value
                end
                return nil
            end
        end,
    })

    -- Defaults before anything is built: the sidebar rail reads showProfile as it lays out, and
    -- LoadSettings lands on top of these once the UI exists.
    self.settings = {
        toggleKeybind = Enum.KeyCode.K,
        mouseOverride = true, -- free the cursor while the menu is open (for FPS games that lock it)
        keepOnScreen = true, -- clamp the drag so the window cant be pulled off screen
        welcomeToast = true, -- the "signed in as" toast on first open for a new/changed account
        haptics = true, -- buzzes on presses and notifications; silent where the device has none
        showProfile = true, -- the player chip at the base of the sidebar rail
    }

    -- Rayfield Gen2 Screen
    self.screenGui = self:Create("ScreenGui", {
        Name = variables.httpService:GenerateGUID(false),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Enabled = true,
        DisplayOrder = constants.displayOrder.window,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,

        Parent = variables.guiContainer,
    })

    -- Window
    self.main = self:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Name = self.name,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        -- Animations
        Size = UDim2.fromOffset((self.size.X.Offset - 50), 0),
        BackgroundTransparency = 1, -- In = 0
        Visible = false, -- In == true

        Parent = self.screenGui,
    })

    self.drag = require(script.Parent.drag).new(self)

    self.windowCorner = self:Create("UICorner", {

        Parent = self.main,
    }, { CornerRadius = "CornerRoundness" })

    self.windowStroke = self:Create("UIStroke", {
        -- Animations
        Transparency = 1, -- In = 0.95

        Parent = self.main,
    }, { Color = "SurfaceStroke" })

    self.windowGradient = self:Create("UIGradient", {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),

        Parent = self.main,
    }, { Color = { "WindowColor", functions.toColorSequence } })

    -- Bottom fade - gradient overlay so elements scroll out softly at the base of the content.
    -- Sized and anchored to whatever the layout gives the content: the full window under top
    -- tabs, the card alone beside a sidebar.
    self.bottomFade = self:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.fromScale(1, 1),
        Size = self.layout.fadeSize,
        ZIndex = constants.zIndex.bottomFade,

        -- Animation
        BackgroundTransparency = 1, -- In = 0

        Parent = self.main,
    })

    self.bottomFadeCorner = self:_roundCorners(self.bottomFade, self.layout.fadeCorners)

    self.bottomFadeGradient = self:Create("UIGradient", {
        Rotation = 270,
        Offset = Vector2.new(0, 0.2),
        Transparency = self.layout.fadeTransparency,

        Parent = self.bottomFade,
    }, {
        -- Track the window's colour at its base (keypoint 0 sits at the bottom under Rotation 270)
        -- so elements dissolve into the window instead of a fixed dark smudge on light themes.
        Color = {
            "WindowColor",
            function(color)
                return ColorSequence.new(functions.toColorSequence(color).Keypoints[1].Value)
            end,
        },
    })

    -- Topbar
    self.topbar = self:Create("Frame", {

        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, self.layout.topbarHeight),
        -- Active so empty topbar space can catch input directly - tabs/actions/search sit on
        -- top and still get first pick, this is just the backdrop becoming a drag handle
        Active = true,

        Parent = self.main,
    })

    self.topContainer = self:Create("Frame", {
        Size = UDim2.new(0, 300, 0, 24),
        Position = UDim2.new(0, 25, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,

        Parent = self.topbar,
    })

    self.topContainerLayout = self:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.topContainer,
    })

    self.titleContainer = self:Create("Frame", {
        Size = UDim2.fromOffset(50, 24),
        Position = UDim2.new(0, 25, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        LayoutOrder = 1,

        Parent = self.topContainer,
    })

    self.titleContainerLayout = self:Create("UIListLayout", {
        Padding = UDim.new(0, 3),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.titleContainer,
    })

    if self.name then
        self.title = self:Create("TextLabel", {
            -- Configurables
            Text = locale.t(self.name), -- window name

            FontFace = variables.brandFont(Enum.FontWeight.Medium),

            Size = UDim2.fromOffset(50, 20),
            AutomaticSize = Enum.AutomaticSize.X,

            BackgroundTransparency = 1,
            TextSize = 20,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,

            -- Animations
            TextTransparency = 1, -- In = 0

            Parent = self.titleContainer,
        }, { FontFace = "Font", TextColor3 = "TitlingColor" })
    end

    if self.icon then
        self.topbarIcon = self:Create("ImageLabel", {
            Image = self.icon,

            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(32, 32),

            -- Animation
            ImageTransparency = 1, -- In = 0

            Parent = self.topContainer,
        }, { ImageColor3 = "TitlingColor" })
    end

    if self.subheading then
        self.subtitle = self:Create("TextLabel", {
            -- Configurables
            Text = locale.t(self.subheading), -- window name

            Size = UDim2.fromOffset(50, 12),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,

            -- Animations
            TextTransparency = 1, -- In = 0.7

            Parent = self.titleContainer,
        }, { TextColor3 = "TitlingColor", FontFace = "Font" })
    end

    self.tagContainer = self:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 25, 0.5, 0),
        Size = UDim2.fromOffset(50, 24),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Visible = false,

        Parent = self.topContainer,
    })

    self.tagContainerLayout = self:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.tagContainer,
    })

    -- Shadow (Transparency 1 here, tweened to 0.6 on show)
    self.windowShadow = self:CreateGlow(self.main, "ShadowColor", 20, 1)

    -- Elements Preparation

    -- Anchored bottom-right in both layouts: under top tabs it fills the width, beside a
    -- sidebar it gives the rail its slice off the left and becomes a card in the corner.
    self.elements = self:Create("Frame", {
        Size = UDim2.new(1, 0, 1, -self.layout.chromeHeight),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true,

        Parent = self.main,
    })

    if self.layout.mode == "sidebar" then
        self.elementsCorner = self:_roundCorners(self.elements, self.layout.cardCorners)

        self.elementsStroke = self:Create("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

            -- Animation
            Transparency = 1, -- In = 0

            Parent = self.elements,
        }, { Color = "SurfaceStroke" })

        -- the rim is the gradient's job: a diagonal sweep that's brightest at the top-left
        -- corner and gone by the bottom-right, where the window's own stroke already runs
        self:Create("UIGradient", {
            Rotation = self.layout.cardStrokeRotation,
            Transparency = self.layout.cardStrokeTransparency,

            Parent = self.elementsStroke,
        })
    end

    self.elementsLayout = self:Create("UIPageLayout", {
        Padding = UDim.new(0, 0),
        FillDirection = self.layout.pageDirection,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,

        -- Tabs switch via the topbar only. Kill the built-in input so scrolling a long page
        -- (or a nudge on a controller) never flips to another tab under you.
        ScrollWheelInputEnabled = false,
        GamepadInputEnabled = false,
        TouchInputEnabled = false,

        EasingStyle = Enum.EasingStyle.Exponential,
        TweenTime = 0.4,

        Parent = self.elements,
    })

    -- Tabs Preparation. Either shape is `tabList` from here on, so nothing downstream has to
    -- know which one it got.
    if self.layout.mode == "sidebar" then
        sidebar.build(self, self.layout)
        sidebar.applyWidth(self, layouts.railWidthFor(self.layout, self.size.X.Offset))
    else
        self.tabList = self:Create("ScrollingFrame", {
            Name = "Tabs",
            Active = true,
            Size = UDim2.new(1, 0, 0, self.layout.tabStripHeight),
            Position = UDim2.new(0.5, 0, 0, self.layout.tabStripTop),
            AnchorPoint = Vector2.new(0.5, 0),

            BackgroundTransparency = 1,
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
            ScrollingDirection = Enum.ScrollingDirection.X,

            Parent = self.main,
        })

        self.tabListLayout = self:Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,

            Parent = self.tabList,
        })

        self:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 22),
            PaddingRight = UDim.new(0, 10),

            Parent = self.tabList,
        })
    end

    -- Actions
    self.actionContainer = self:Create("Frame", {

        AnchorPoint = Vector2.new(1, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 24),
        Position = UDim2.new(1, -20, 0.5, 0),
        BackgroundTransparency = 1,

        Parent = self.topbar,
    })

    self.actionsListLayout = self:Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,

        Parent = self.actionContainer,
    })

    self.rfSettings = self:CreateTab({
        name = "Slate Settings",
        customOrder = 1000,

        neglectSelector = true,
        -- everything here is ephemeral: these controls persist to rayfield.rfld via SaveSettings,
        -- never the user's config. children inherit this, so none of them opt out individually.
        forgetState = true,
    })

    require(script.Parent.action).new(self, {
        name = "Close",
        icon = constants.icons.close,
        order = 1,

        callback = function()
            self:ToggleHide()
        end,
    })

    self.minimiseAction = require(script.Parent.action).new(self, {
        name = "Minimise",
        icon = constants.icons.minimise,
        order = 2,

        callback = function()
            self:ToggleMinimise()
        end,
    })

    self.settingsAction = require(script.Parent.action).new(self, {
        name = "Settings",
        icon = constants.icons.settings,
        order = 3,
        linkedTab = self.rfSettings,

        callback = function()
            self.rfSettings:Select()
        end,
    })

    search.build(self)
    -- the field is built after the rail, so hand it the width the rail actually settled on
    self:_applyRailWidth()

    self.unloaded = false
    self.minimised = false
    self.hidden = true
    self.animating = false
    self._revealing = false
    self.hasShownOnce = false
    self._collapsedShown = false

    -- saved settings land after the rail was built against the defaults, so let it settle again
    self:LoadSettings()
    if self.layout.mode == "sidebar" then
        sidebar.reflowProfile(self)
        sidebar.setSubtitle(self, self.profileText)
    end
    hapticEngine.setContainer(self.screenGui) -- effects live with the interface, not the workspace
    hapticEngine.setEnabled(self.settings.haptics) -- honour a saved off before any interaction
    chrome.buildCollapsedFace(self)
    self:_bindKeybind()
    self:_bindMouseOverride()
    self:_bindTopbarDrag()
    self:_watchViewport()
    self:_buildSettingsUI()

    self:_syncLiveAnimation()

    return self
end

-- start or stop the gradient drift to match the current theme. called on build and on every
-- ChangeTheme, so switching into or out of an animated theme takes effect either way.
function Window:_syncLiveAnimation()
    if not self.theme.LiveAnimation then
        self._liveAnimating = false -- the running loop sees this and stops after its current leg
        return
    end
    if self._liveAnimating then
        return -- already drifting
    end

    self._liveAnimating = true
    -- generation stamp: an old loop parked in Completed:Wait() through a static->animated
    -- swap wakes up stale and exits, instead of drifting alongside the new loop
    self._liveGeneration = (self._liveGeneration or 0) + 1
    local generation = self._liveGeneration
    task.spawn(function()
        local out = true
        local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        while self._liveGeneration == generation and self._liveAnimating and not self.unloaded do
            local tweenW = variables.tweenService:Create(self.windowGradient, tweenInfo, {
                Offset = Vector2.new(if out then 0.4 else -0.2, 0),
                Rotation = (if out then 220 else 280),
            })

            self._liveTween = tweenW
            tweenW:Play()
            tweenW.Completed:Wait()
            out = not out
        end
        if self._liveGeneration == generation then
            self._liveAnimating = false
            self._liveTween = nil
        end
    end)
end

function Window:ChangeTheme(theme)
    -- A named theme fully switches: resolve against default so keys it omits reset rather than
    -- lingering from the previous theme. A partial table just overrides the keys it names.
    local overrides = if typeof(theme) == "table" then theme else resolveTheme(theme)
    for name, value in overrides do
        self.theme[name] = coerceThemeValue(name, value)
    end
    -- match the constructor: a hand-written table gets derived strokes for the keys it changes
    if typeof(theme) == "table" then
        deriveStrokes(self.theme, overrides)
    end

    for instance, properties in self.themeProperties do
        for property, value in properties do
            local targetValue = if typeof(value) == "table" then value[2](self.theme[value[1]]) else self.theme[value]

            if typeof(targetValue) == "Color3" or typeof(targetValue) == "number" then
                variables.tweenService
                    :Create(
                        instance,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        { [property] = targetValue }
                    )
                    :Play()
            else
                instance[property] = targetValue
            end
        end
    end

    -- themeProperties above only carry plain colours; reveal-driven transparencies and state
    -- colours (the toggle knob, field fills, glows) aren't, so refresh the elements to reach
    -- them on a live swap. Every tab's elements stay shown (just page-clipped), settings
    -- included, so refresh them all; groups forward the call to their children.
    if self.hidden then
        -- a hidden window has nothing to animate into, so defer the refresh to the next Show
        -- rather than dropping it and reopening with the old themes state colours
        self._themeRefreshPending = true
    else
        self:_refreshElementThemes()
    end

    self:_syncLiveAnimation()
end

function Window:_refreshElementThemes()
    for _, tab in self.tabs do
        for _, element in tab.elements do
            if element._refreshTheme then
                element:_refreshTheme()
            end
        end
    end
end

function Window:CreateTab(properties)
    assert(not self.unloaded, "Cannot create a tab on an unloaded window.")
    local newTab = require(script.Parent.tab).new(self, properties)

    table.insert(self.tabs, newTab)

    if not newTab.neglectSelector then
        local isFirstVisible = true
        for _, tab in self.tabs do
            if tab ~= newTab and not tab.neglectSelector then
                isFirstVisible = false
                break
            end
        end
        if isFirstVisible then
            newTab:Select(true)
        end

        -- a tab built after the window is already open reveals its pill right away, the
        -- same way _register shows late elements. hidden/minimised windows reveal on restore.
        if not self.hidden and not self.minimised then
            newTab.topbarItem.Visible = true
            newTab:_applyVisual(
                if self.selectedTab == newTab then "selected" else "unselected",
                TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            )
        end
    end

    return newTab
end

-- A heading in the sidebar rail. Same props as a tab's CreateSection, and it groups the tab
-- rows created after it the way that one groups elements. Sidebar layout only.
function Window:CreateSection(properties)
    assert(not self.unloaded, "Cannot create a section on an unloaded window.")
    local section = require(script.Parent.tabSection).new(self, properties)
    table.insert(self.tabSections, section)

    -- built after the window is already open: reveal it now, the same way a late tab reveals
    -- its row rather than waiting for the next open
    if not section.inert and not self.hidden and not self.minimised then
        section:_setVisible(true)
        section:_setShown(true, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
    end

    return section
end

-- Sections ride with the rows they label, so every path that fades or hides the rail's rows
-- says the same thing to them.
function Window:_setTabSectionsShown(shown, tweenInfo)
    for _, section in self.tabSections do
        section:_setShown(shown, tweenInfo)
    end
end

function Window:_setTabSectionsVisible(visible)
    for _, section in self.tabSections do
        section:_setVisible(visible)
    end
end

function Window:CreateTag(properties)
    assert(not self.unloaded, "Cannot create a tag on an unloaded window.")
    local newTag = require(script.Parent.tag).new(self, properties)
    table.insert(self.tags, newTag)
    return newTag
end

-- Register a saveable control under its flag. Keeps flags unique so two same-named
-- elements dont clobber each other's saved value. Updates control.flag to the key we
-- actually stored under and returns it.
function Window:_registerControl(control)
    if not control.flag or control.flag == "" or control.forgetState then
        return
    end

    local flag = control.flag
    if self.controls[flag] then
        local n = 2
        while self.controls[flag .. n] do
            n += 1
        end
        flag = flag .. n
        log.warn(
            "Rayfield: duplicate config flag '"
                .. control.flag
                .. "', saving this one as '"
                .. flag
                .. "'. Set a unique flag to keep it stable across sessions."
        )
    end

    control.flag = flag
    self.controls[flag] = control
    return flag
end

-- Restore an element built after the config was already loaded. autoLoad only fires once on
-- first Show, so without this a late element (one built after a remote fetch, say) keeps its
-- default and the next autosave writes that default over the saved value.
-- Called from the CreateX tails once the element is fully built, since _registerControl runs
-- mid-construction and :Set would touch instances that dont exist yet.
function Window:_restoreLate(element)
    if not self._loadedConfig or not element.flag or element.forgetState then
        return
    end

    local wasLoading = self._loading
    self._loading = true -- dont autosave the value we just read back
    persistence.applyTo(element, self._loadedConfig[element.flag])
    self._loading = wasLoading
end

-- Autosave a control's value after an interactive or programmatic change, when the window is
-- set to autoSave and the control opts into persistence. Every Set/commit path funnels here so
-- persistence stays uniform across elements.
function Window:_persist(control)
    -- _loading: a config restore fires every control's callback, but must not autosave back over
    -- the file it's reading (or storm Save once per control)
    if control.flag and not control.forgetState and self.configuration.autoSave and not self._loading then
        task.spawn(self.Save, self)
    end
end

-- Drop a control from the flag registry when its element is removed, so Save/Load and the
-- Flags view never touch a destroyed instance.
function Window:_unregisterControl(control)
    if control.flag and self.controls[control.flag] == control then
        self.controls[control.flag] = nil
    end
end

-- find a keybind element currently bound to `key`, skipping `exclude` and unbound keys. lets
-- the menu-toggle keybind refuse a key an element keybind already owns. keybinds only live at
-- tab level (groups dont hold them), so a scan over each tab's elements catches them all.
function Window:_keybindUsing(key, exclude)
    if typeof(key) ~= "EnumItem" or key == Enum.KeyCode.Unknown then
        return nil
    end
    for _, tab in self.tabs do
        for _, element in tab.elements do
            if element ~= exclude and element.__type == "Keybind" and element.value == key then
                return element
            end
        end
    end
    return nil
end

function Window:Notify(properties)
    if self.unloaded then
        return -- nothing to parent into once the ScreenGui is gone
    end
    if not self.notifications then
        self.notifications = self:Create("Frame", {
            Name = "Notifications",
            Size = UDim2.new(0, 300, 0, 800),
            Position = UDim2.new(1, -20, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,

            Parent = self.screenGui,
        })

        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            -- No padding here: the gap lives inside each notification so removing
            -- one doesn't drop an external gap and jolt the stack.
            Padding = UDim.new(0, 0),

            Parent = self.notifications,
        })
    end

    return require(script.Parent.notification).new(self, properties)
end

-- Top-centre / bottom-centre toast stack. Like Notify but for brief, centred messages that drop
-- in from the top (or rise from the bottom) of the screen (newest on top). Each toast takes
-- { title, subtitle?, icon?, duration?, position? }.
function Window:Toast(properties)
    if self.unloaded then
        return
    end

    -- both casings and any case for the value, like every other toast property
    properties = if typeof(properties) == "table" then properties else {}
    local position = properties.position or properties.Position or "Top"
    local isTop = typeof(position) ~= "string" or position:lower() ~= "bottom"
    properties.position = if isTop then "Top" else "Bottom"
    local containerKey = if isTop then "_toastsTop" else "_toastsBottom"
    local container = self[containerKey]

    if not container then
        container = self:Create("Frame", {
            Name = "Toasts",
            Size = UDim2.new(0, maxToastWidth, 1, -24),
            Position = if isTop then topToastOpenPosition else UDim2.new(0.5, 0, 1, -12),
            AnchorPoint = if isTop then Vector2.new(0.5, 0) else Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            ZIndex = constants.zIndex.toast,

            Parent = self.screenGui,
        })

        self:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = if isTop then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            -- gap lives inside each toast so removing one collapses its gap with it
            Padding = UDim.new(0, 0),

            Parent = container,
        })

        self[containerKey] = container

        -- the pill may already hold the top slot, so let the one rule place it rather than
        -- restating it here. nothing's been on screen yet, so there's nothing to move
        if isTop then
            setTopToastPosition(self, false)
        end
    end

    return require(script.Parent.toast).new(self, properties, container)
end

-- Centred modal over a dimmed backdrop. Takes { title, subtitle?, icon?, content?, boxes?,
-- options?, dismissable? } - give it options for a choice dialog, or boxes for a changelog.
-- Returns the popup handle (call :Close() to dismiss it yourself).
function Window:Popup(properties)
    if self.unloaded then
        return
    end
    return require(script.Parent.popup).new(self, properties)
end

function Window:Hide()
    -- idempotent: a second Hide while collapsed would capture the pill spot as the
    -- restore position and teleport the window there on the next Show
    if self.animating or self.hidden then
        return
    end

    -- drop out of search first so we grow back into the normal tab view on next show. tabList
    -- stays hidden here since the collapse hides it anyway; Show re-enables it.
    if self._searching then
        search.close(self, { showTabs = false, jumpTo = self.selectedTab and self.selectedTab.tabPage })
    end

    -- a keybind left recording would capture the next keypress against an invisible UI and
    -- eat the toggle key
    if self._recordingKeybind then
        self._recordingKeybind:_stopRecording()
    end

    self.animating = true
    self._revealing = true
    self.hidden = true
    self.collapsedInteract.Visible = false -- re-shown once the collapse settles, below

    -- closing while minimised closes properly rather than leaving a stale minimised state -
    -- Show always grows back to the full (non-minimised) layout, so the flag and icon need
    -- to agree with that
    if self.minimised then
        self.minimised = false
        image.assign(self.minimiseAction.iconLabel, "Image", constants.icons.minimise) -- back to the minimise icon
    end

    -- remember where the window sat so Show grows it back to the same spot
    self._restorePosition = self.main.Position

    local home, size = self:_collapsedRect()

    local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    -- one continuous move for the whole collapse: size and position tween together on the
    -- same curve so they stay perfectly in sync, no seam between separate legs
    local moveInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local cornerInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local faceInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- shrink the drag bar back down the same way it grows in on first reveal, instead of
    -- just cutting it
    variables.tweenService
        :Create(self.drag.dragCosmetic, fadeInfo, { Size = UDim2.fromOffset(0, 4), BackgroundTransparency = 1 })
        :Play()
    task.delay(0.18, function()
        if not self.hidden then
            return
        end
        self.drag.drag.Visible = false
    end)

    -- fade the window's own chrome out; main keeps its own background/gradient/corner the
    -- whole time, it just reshapes underneath - there's nothing to hand off to
    self:_fadeSurfaces(false, fadeInfo)

    if self.title then
        variables.tweenService:Create(self.title, fadeInfo, { TextTransparency = 1 }):Play()
    end
    if self.subtitle then
        variables.tweenService:Create(self.subtitle, fadeInfo, { TextTransparency = 1 }):Play()
    end
    if self.topbarIcon then
        variables.tweenService:Create(self.topbarIcon, fadeInfo, { ImageTransparency = 1 }):Play()
    end

    for _, action in ipairs(self.actionContainer:GetChildren()) do
        if action:IsA("Frame") then
            variables.tweenService:Create(action.ImageLabel, fadeInfo, { ImageTransparency = 1 }):Play()
        end
    end

    for _, tag in self.tags do
        tag:_setShown(false, fadeInfo)
    end

    for _, tab in pairs(self.tabs) do
        if not tab.neglectSelector and tab.topbarItem then
            tab:_applyVisual("hidden", fadeInfo)
        end
    end
    self:_setTabSectionsShown(false, fadeInfo)

    self:_fadeSelectedElementsOut()

    -- collapse into the pill in one continuous move - size and position tweened together
    -- so they stay perfectly in sync throughout
    local collapse = variables.tweenService:Create(self.main, moveInfo, { Size = size, Position = home })
    collapse.Completed:Connect(function()
        -- any end to the collapse settles it, cancelled included. a tween that stops early
        -- still has to hand input back, or the pill sits dead and Show can never run again
        if self.unloaded or not self.hidden then
            return
        end

        -- The pill now occupies the top-centre slot. Move the stack only when the frame says
        -- the collapse is complete, so this cannot drift from the animation that creates it.
        self._collapsedShown = true
        setTopToastPosition(self, true)
        self.collapsedInteract.Visible = true
        self.animating = false
        self._revealing = false
    end)
    collapse:Play()
    variables.tweenService:Create(self.windowCorner, cornerInfo, { CornerRadius = UDim.new(1, 0) }):Play()

    -- once the chrome's faded, drop it and the scrolling content so nothing squashes/pokes
    -- out as the frame shrinks around it, then bring the collapsed face up over the top
    task.delay(0.18, function()
        if not self.hidden then
            return
        end
        self.topbar.Visible = false
        self:_setContentVisible(false)

        chrome.setCollapsedShown(self, true, faceInfo)
    end)
end

function Window:ToggleHide()
    if self.animating then
        return
    end
    if self.hidden then
        self:Show()
    else
        self:Hide()
    end
end

function Window:ToggleMinimise()
    if self.animating or self.hidden then
        return
    end

    -- minimising drops out of search back to the tab view first, so it grows back normally
    if self._searching then
        search.close(self, { showTabs = true })
    end

    self.animating = true

    local sizeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    if self.minimised then
        self.minimised = false
        image.assign(self.minimiseAction.iconLabel, "Image", constants.icons.minimise) -- back to the minimise icon

        variables.tweenService:Create(self.main, sizeInfo, { Size = self.size }):Play()
        self:_fadeSurfaces(true, fadeInfo)

        variables.tweenService
            :Create(self.drag.drag, sizeInfo, {
                Position = UDim2.new(
                    self.main.Position.X.Scale,
                    self.main.Position.X.Offset,
                    self.main.Position.Y.Scale,
                    self.main.Position.Y.Offset + self.size.Y.Offset / 2 + 15
                ),
            })
            :Play()

        -- once the window's grown back, fade the content and tab pills in rather than
        -- snapping them visible
        task.delay(0.2, function()
            if self.minimised or self.hidden then
                return -- re-minimised or hidden mid animation
            end
            self:_setContentVisible(true)

            for _, tab in pairs(self.tabs) do
                if not tab.neglectSelector and tab.topbarItem then
                    tab.topbarItem.Visible = true
                    tab:_applyVisual(if self.selectedTab == tab then "selected" else "unselected", fadeInfo)
                end
            end
            self:_setTabSectionsVisible(true)
            self:_setTabSectionsShown(true, fadeInfo)

            self:_revealElements(0.035, 0.4)
        end)

        task.delay(0.5, function()
            self.animating = false
        end)
    else
        self.minimised = true
        image.assign(self.minimiseAction.iconLabel, "Image", constants.icons.maximise) -- maximise icon while minimised

        -- fade the content + tab pills out instead of cutting them, then hide them once faded
        -- so they don't sit clipped under the collapsed bar
        self:_fadeSelectedElementsOut()
        for _, tab in pairs(self.tabs) do
            if not tab.neglectSelector and tab.topbarItem then
                tab:_applyVisual("hidden", fadeInfo)
            end
        end
        self:_setTabSectionsShown(false, fadeInfo)

        task.delay(0.3, function()
            if not self.minimised then
                return -- restored mid animation
            end
            self:_setContentVisible(false)
            for _, tab in pairs(self.tabs) do
                if not tab.neglectSelector and tab.topbarItem then
                    tab.topbarItem.Visible = false
                end
            end
            self:_setTabSectionsVisible(false)
        end)

        self:_fadeSurfaces(false, fadeInfo)
        variables.tweenService
            :Create(self.main, sizeInfo, { Size = UDim2.fromOffset(self.size.X.Offset, self.layout.topbarHeight) })
            :Play()

        variables.tweenService
            :Create(self.drag.drag, sizeInfo, {
                Position = UDim2.new(
                    self.main.Position.X.Scale,
                    self.main.Position.X.Offset,
                    self.main.Position.Y.Scale,
                    self.main.Position.Y.Offset + self.layout.topbarHeight / 2 + 15
                ),
            })
            :Play()

        task.delay(0.5, function()
            self.animating = false
        end)
    end
end

-- Park the drag bar under the window's bottom edge, matching whichever positioning the window
-- itself uses so a centred window stays centred and a dragged one stays where it was left.
function Window:_syncDragBar()
    local bar = self.drag and self.drag.drag
    if not bar then
        return
    end
    local position = self.main.Position
    local below = self.size.Y.Offset / 2 + 15
    bar.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + below)
end

-- Pull a dragged window back on screen after a re-fit, the same way a drag clamps. A window
-- parked near an edge would otherwise end up half off it when the viewport shrinks underneath.
-- Where a position ends up once the current size has to fit on the current screen. Returns it
-- unchanged when theres nothing to do, so callers can compare.
function Window:_clampedPosition(position: UDim2): UDim2
    if not self.settings or not self.settings.keepOnScreen then
        return position
    end
    -- untouched windows sit on scale and are centred, so theyre on screen by construction -
    -- clamping would only freeze them to offsets and stop them recentring later
    if position.X.Scale ~= 0 or position.Y.Scale ~= 0 then
        return position
    end

    local screen = self.screenGui.AbsoluteSize
    local halfX, halfY = self.size.X.Offset / 2, self.size.Y.Offset / 2
    local margin = 8
    -- math.max in case the window is bigger than the screen
    local x = math.clamp(position.X.Offset, halfX + margin, math.max(halfX + margin, screen.X - halfX - margin))
    local y = math.clamp(position.Y.Offset, halfY + margin, math.max(halfY + margin, screen.Y - halfY - margin))
    if x == position.X.Offset and y == position.Y.Offset then
        return position
    end
    return UDim2.fromOffset(x, y)
end

function Window:_clampToScreen()
    self.main.Position = self:_clampedPosition(self.main.Position)
end

-- Take the size the current screen calls for. Only a live window is resized on the spot;
-- hidden, minimised or mid-animation ones just bank the size and pick it up on their next
-- show, so a rotation cant yank a collapsed pill back open.
function Window:_applyWindowSize()
    if self.unloaded then
        return
    end

    local size = fitWindowSize(self.layout.mode)
    local changed = size ~= self.size
    self.size = size

    -- the rail is sized off main, so setting it now is right whether main resizes on the spot
    -- below or grows into the banked size on its next show
    self:_applyRailWidth()

    -- a window mid-animation is already tweening toward the old size, so bank the change and
    -- let the reconcile apply it once the tween is done rather than fighting it
    if self.hidden or self.minimised or self.animating or self._revealing then
        self._pendingResize = self._pendingResize or changed
        return
    end

    if not changed and not self._pendingResize then
        return
    end
    self._pendingResize = false

    self.main.Size = size
    self:_clampToScreen()
    self:_syncDragBar()
end

-- The rail keeps its labels while there's width to spare and drops to icons when there isn't,
-- so the content card never pays for them. No-op outside the sidebar layout.
function Window:_applyRailWidth()
    if self.layout.mode ~= "sidebar" then
        return
    end
    sidebar.applyWidth(self, layouts.railWidthFor(self.layout, self.size.X.Offset))
end

-- Follow the screen. The property signal is the fast path, but CurrentCamera gets swapped
-- (respawn, or a game replacing it) and a listener bound to the old camera dies silently, so
-- rebind on the swap and keep a slow reconcile behind it as the backstop.
function Window:_watchViewport()
    local cameraConnection: RBXScriptConnection? = nil
    local pending = false

    local function request()
        -- a rotation fires a burst of intermediate sizes, so settle on the last one
        if pending then
            return
        end
        pending = true
        task.defer(function()
            pending = false
            self:_applyWindowSize()
        end)
    end

    local function bind()
        if cameraConnection then
            self:Disconnect(cameraConnection)
            cameraConnection = nil
        end
        local camera = variables.workspace.CurrentCamera
        if camera then
            cameraConnection = self:Connect(camera:GetPropertyChangedSignal("ViewportSize"), request)
        end
        request()
    end

    self:Connect(variables.workspace:GetPropertyChangedSignal("CurrentCamera"), bind)
    bind()

    -- Backstop for anything the signals miss. Heartbeat rather than a wait loop so it rides the
    -- normal connection cleanup and cant spin if the scheduler hands back a wait that never yields.
    local sinceReconcile = 0
    self:Connect(variables.runService.Heartbeat, function(delta: number)
        sinceReconcile += delta
        if sinceReconcile < viewportReconcileInterval then
            return
        end
        sinceReconcile = 0
        self:_applyWindowSize()
    end)
end

function Window:_bindKeybind()
    self:Connect(variables.userInputService.InputBegan, function(input, processed)
        if processed or self._recordingKeybind then
            return -- a keybind element is mid-rebind, dont eat its capture
        end
        if input.KeyCode == self.settings.toggleKeybind or input.UserInputType == self.settings.toggleKeybind then
            self:ToggleHide()
        end
    end)
end

function Window:_bindMouseOverride()
    local uis = variables.userInputService

    local function active()
        return self.settings.mouseOverride and not self.hidden and not self.minimised
    end

    local function free()
        if not active() then
            return
        end
        -- hands off while the right button is held: thats the camera panning in third person,
        -- and it needs to lock the mouse to do it. we free again the moment it lets go.
        if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            return
        end
        if uis.MouseBehavior ~= Enum.MouseBehavior.Default then
            uis.MouseBehavior = Enum.MouseBehavior.Default
        end
        if not uis.MouseIconEnabled then
            uis.MouseIconEnabled = true
        end
    end

    -- react to the game re-locking instead of racing it each frame. it sets LockCenter, we set
    -- it back, so we always get the last word. same deal if it hides the mouse icon.
    self:Connect(uis:GetPropertyChangedSignal("MouseBehavior"), free)
    self:Connect(uis:GetPropertyChangedSignal("MouseIconEnabled"), free)

    -- right-release doesnt always flip MouseBehavior back (so the signals above wouldnt fire),
    -- so re-free explicitly once the pan ends
    self:Connect(uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            free()
        end
    end)

    -- Show calls this on open to free the cursor immediately (the signals above only fire on change)
    self._freeMouse = free
end

-- Grabbing the topbar drags the whole window too, its own separate handle from the bar
-- underneath - tracks the cursor 1:1 with no lag, unlike the bars own deliberate smoothing, and
-- the bar just glues to wherever main currently is each frame so it never drifts off on its own
function Window:_bindTopbarDrag()
    local uis = variables.userInputService
    local dragging = false
    local relative = Vector2.zero

    -- main.Position lives in a space shifted from AbsolutePosition by the gui inset, even
    -- though the ScreenGui ignores it - add it back or the window jumps on the first move
    local offset = Vector2.zero
    if self.screenGui and self.screenGui.IgnoreGuiInset then
        offset = variables.guiService:GetGuiInset()
    end

    local function getTarget()
        local position = uis:GetMouseLocation() + relative + offset
        local x, y = position.X, position.Y

        if self.settings and self.settings.keepOnScreen then
            local size = self.main.AbsoluteSize
            local screen = self.screenGui.AbsoluteSize
            local margin = 8
            local halfX, halfY = size.X / 2, size.Y / 2
            x = math.clamp(x, halfX + margin, math.max(halfX + margin, screen.X - halfX - margin))
            y = math.clamp(y, halfY + margin, math.max(halfY + margin, screen.Y - halfY - margin))
        end

        return UDim2.fromOffset(x, y)
    end

    -- Global ZIndexBehavior still delivers InputBegan to an Active ancestor even when a child
    -- button covers that exact pixel, so checking the event alone isnt enough - a press over the
    -- tabs or the actions has to be rejected by where it actually landed, not just left to bubble
    local function overInteractiveChild(x, y)
        for _, region in { self.tabList, self.actionContainer } do
            local position, size = region.AbsolutePosition, region.AbsoluteSize
            if x >= position.X and x <= position.X + size.X and y >= position.Y and y <= position.Y + size.Y then
                return true
            end
        end
        return false
    end

    self:Connect(self.topbar.InputBegan, function(input, processed)
        if processed then
            return
        end

        local inputType = input.UserInputType.Name
        if inputType ~= "MouseButton1" and inputType ~= "Touch" then
            return
        end

        if overInteractiveChild(input.Position.X, input.Position.Y) then
            return
        end

        -- a grab started mid-reveal would fight the tween thats still moving the window
        if not self:_interactive() then
            return
        end

        dragging = true

        if self.screenGui and self.screenGui.IgnoreGuiInset then
            offset = variables.guiService:GetGuiInset()
        end

        relative = self.main.AbsolutePosition + self.main.AbsoluteSize * self.main.AnchorPoint - uis:GetMouseLocation()
    end)

    self:Connect(uis.InputEnded, function(input)
        local inputType = input.UserInputType.Name
        if inputType == "MouseButton1" or inputType == "Touch" then
            dragging = false
        end
    end)

    -- alt-tabbing with the button still down never delivers InputEnded, so without this the
    -- grab stays armed and the window snaps to the cursor the moment youre back
    self:Connect(uis.WindowFocusReleased, function()
        dragging = false
    end)

    self:Connect(variables.runService.RenderStepped, function()
        if not dragging then
            return
        end

        -- hidden or mid-animation means the grab went stale under us, so drop it here rather
        -- than let it wake up later and yank the window to wherever the cursor drifted
        if not self:_interactive() then
            dragging = false
            return
        end

        self.main.Position = getTarget()

        if self.drag and self.drag.drag then
            local mainPosition = self.main.Position
            self.drag.drag.Position = UDim2.new(
                mainPosition.X.Scale,
                mainPosition.X.Offset,
                mainPosition.Y.Scale,
                mainPosition.Y.Offset + (self.main.Size.Y.Offset / 2 + 15)
            )
        end
    end)
end

function Window:_buildSettingsUI()
    self.rfSettings:CreateSection({ name = "General" })

    self.rfSettings:CreateKeybind({
        name = "Toggle Keybind",
        icon = constants.icons.search,
        value = self.settings.toggleKeybind,
        isMenuToggle = true, -- reject keys already owned by an element keybind
        onChanged = function(key)
            self.settings.toggleKeybind = key
            self:SaveSettings()
        end,
    })

    self.rfSettings:CreateToggle({
        name = "Unlock cursor while open",
        description = "Unlocks the cursor while the menu is open so you can configure in FPS games that lock it.",
        value = self.settings.mouseOverride,
        callback = function(state)
            self.settings.mouseOverride = state
            self:SaveSettings()
        end,
    })

    self.rfSettings:CreateToggle({
        name = "Welcome toast",
        description = "Shows a 'Signed in as' toast the first time you open the menu on a new account.",
        value = self.settings.welcomeToast,
        callback = function(state)
            self.settings.welcomeToast = state
            self:SaveSettings()
        end,
    })

    self.rfSettings:CreateToggle({
        name = "Haptics",
        description = "A subtle tap as you interact, on devices that support haptics.",
        value = self.settings.haptics,
        callback = function(state)
            self.settings.haptics = state
            hapticEngine.setEnabled(state)
            self:SaveSettings()
        end,
    })

    self.rfSettings:CreateSection({ name = "Window" })

    -- only the sidebar layout has somewhere to put a profile, so only it offers the switch
    if self.layout.mode == "sidebar" and self.profile then
        self.rfSettings:CreateToggle({
            name = "Show profile",
            description = "Shows your avatar and name at the base of the sidebar. Turn it off to keep "
                .. "them out of a stream or a screenshot.",
            value = self.settings.showProfile,
            callback = function(state)
                sidebar.setProfileEnabled(self, state)
                self:SaveSettings()
            end,
        })
    end

    self.rfSettings:CreateToggle({
        name = "Keep window on screen",
        description = "Stops the window being dragged off the edge of the screen and lost.",
        value = self.settings.keepOnScreen,
        callback = function(state)
            self.settings.keepOnScreen = state
            self:SaveSettings()
        end,
    })

    self.rfSettings:CreateButton({
        name = "Reset Window Position",
        callback = function()
            variables.tweenService
                :Create(self.main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                })
                :Play()
            variables.tweenService
                :Create(self.drag.drag, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0.5, self.size.Y.Offset / 2 + 15),
                })
                :Play()
        end,
    })

    -- Configurations: save the current setup under a name and switch between saved ones.
    -- Only shown once the developer opts into config saving.
    if next(self.configuration) ~= nil then
        self.rfSettings:CreateSection({ name = "Configurations" })

        local selected = self:ListConfigs()[1]
        local configDropdown, nameInput

        local function refreshConfigs()
            local names = self:ListConfigs()
            configDropdown:Refresh(names)
            if selected and not table.find(names, selected) then
                selected = names[1]
            end
            if selected then
                configDropdown:Set(selected, true)
            end
        end

        configDropdown = self.rfSettings:CreateDropdown({
            name = "Saved Configurations",
            icon = constants.icons.config,
            options = self:ListConfigs(),
            value = selected,
            placeholder = "No saved configurations",
            callback = function(value)
                selected = value
            end,
        })

        nameInput = self.rfSettings:CreateInput({
            name = "Configuration Name",
            description = "Name a new configuration, or leave blank to overwrite the selected one.",
            placeholder = "e.g. PvP Loadout",
            clearOnFocus = false,
        })

        local actions = self.rfSettings:CreateGroup()

        actions:CreateButton({
            name = "Save",
            icon = constants.icons.config,
            callback = function()
                local name = nameInput.value
                if name == "" then
                    name = selected
                end
                if not name or name == "" then
                    self:Toast({ title = locale.resolve("Name your configuration first") })
                    return
                end
                if self:Save(name) then
                    nameInput:Set("")
                    selected = name
                    refreshConfigs()
                    self:Toast({
                        title = locale.resolve("Saved configuration"),
                        subtitle = name,
                        icon = constants.icons.config,
                    })
                else
                    self:Toast({ title = locale.resolve("Couldn't save configuration"), subtitle = name })
                end
            end,
        })

        actions:CreateButton({
            name = "Load",
            callback = function()
                if not selected or selected == "" then
                    self:Toast({ title = locale.resolve("Pick a configuration to load") })
                    return
                end
                if self:_applyNamedConfig(selected) then
                    self:Toast({ title = locale.resolve("Loaded configuration"), subtitle = selected })
                else
                    self:Toast({ title = locale.resolve("Couldn't load configuration"), subtitle = selected })
                end
            end,
        })

        actions:CreateButton({
            name = "Delete",
            callback = function()
                local deleting = selected
                if not deleting or deleting == "" then
                    self:Toast({ title = locale.resolve("Pick a configuration to delete") })
                    return
                end
                if self:DeleteConfig(deleting) then
                    refreshConfigs()
                    self:Toast({ title = locale.resolve("Deleted configuration"), subtitle = deleting })
                else
                    self:Toast({ title = locale.resolve("Couldn't delete configuration"), subtitle = deleting })
                end
            end,
        })
    end
end

-- The line under the player's name in the sidebar's profile block ("Premium", a rank, a tier).
-- Pass nil or "" to drop it and leave the name on its own. No-op in the top-tab layout, which
-- has no profile block to put it in.
function Window:SetProfile(text)
    self.profileText = text
    sidebar.setSubtitle(self, text)
end

function Window:SaveSettings()
    return persistence.saveSettings(self)
end

function Window:LoadSettings()
    return persistence.loadSettings(self)
end

-- Round a shape's corners to the theme's radius. `corners` names the ones that take it and
-- squares the rest; omit it and the whole shape is rounded, which is the single themed radius
-- the top layout has always used.
function Window:_roundCorners(parent, corners)
    if not corners or not perCornerSupported then
        return self:Create("UICorner", {
            Parent = parent,
        }, { CornerRadius = "CornerRoundness" })
    end

    local properties = { Parent = parent }
    local themed = {}
    for _, name in cornerNames do
        properties[name] = UDim.new(0, 0)
    end
    for _, name in corners do
        properties[name] = nil -- the theme sets this one, so dont square it first
        themed[name] = "CornerRoundness"
    end

    return self:Create("UICorner", properties, themed)
end

-- Lock or unlock one element. It dims, it stops taking input, and its callback wont fire (see
-- _runGuarded). `reason` replaces the element's description while it's locked, so the UI can
-- say why without covering the element up to do it.
function Window:_setElementLocked(element, locked, reason)
    locked = locked == true
    -- locked starts out nil, so compare against a real boolean: `nil == false` is false, and
    -- Unlock on an element that was never locked would otherwise build a scrim just to fade it
    -- straight back out. A fresh reason on an already-locked element is still worth applying.
    local wasLocked = element.locked == true
    if wasLocked == locked and not (locked and reason) then
        return
    end
    element.locked = locked

    if not element.lockScrim then
        self:_buildLockScrim(element)
    end

    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if locked then
        element.lockScrim.Visible = true
    end
    variables.tweenService
        :Create(element.lockScrim, info, {
            BackgroundTransparency = if locked then lockScrimTransparency else 1,
        })
        :Play()
    if not locked then
        task.delay(info.Time, function()
            if not element.locked and element.lockScrim then
                element.lockScrim.Visible = false -- out of hit-testing once it has faded
            end
        end)
    end

    -- say why in the description, and put the element's own back when it unlocks
    local descriptor = element.descriptor
    if not descriptor then
        return
    end

    if locked then
        -- `or`, not plain assignment: re-locking with a new reason must not remember the old
        -- reason as though it were the element's own description
        element._descriptionBefore = element._descriptionBefore or descriptor.titleLabel.Text
        descriptor.titleLabel.Text = locale.resolve(reason or "This element is locked.")
    elseif element._descriptionBefore then
        descriptor.titleLabel.Text = element._descriptionBefore
        element._descriptionBefore = nil
    end

    variables.tweenService
        :Create(descriptor.titleLabel, info, {
            TextTransparency = if locked then lockedDescriptionTransparency else 0.7,
        })
        :Play()
end

-- The scrim: a sheet of the window's own colour over the element, dimming it. It carries
-- nothing itself - it's the dimming and the description that say what's happened. It is an
-- Active button, so it swallows anything aimed at the element underneath rather than leaving
-- each element to check a flag on every input path.
function Window:_buildLockScrim(element)
    element.lockScrim = self:Create("TextButton", {
        Name = "ElementLock",
        Active = true,
        AutoButtonColor = false,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = "",
        TextTransparency = 1,
        ZIndex = constants.zIndex.elementLock,
        Visible = false,

        -- no literal BackgroundColor3 here: Create applies the theme first and plain properties
        -- second, so setting it both ways would paint straight over the themed colour
        BackgroundTransparency = 1, -- In = lockScrimTransparency

        Parent = element.main,
    }, { BackgroundColor3 = { "WindowColor", firstColor } })

    self:Create("UICorner", {
        Parent = element.lockScrim,
    }, { CornerRadius = "ElementCornerRadius" })
end

-- Show or hide everything below the topbar in one go: the content area and the tab selector,
-- whichever shape it is. Kept together so a collapse can never leave a rail floating over a pill.
function Window:_setContentVisible(visible)
    self.elements.Visible = visible
    self.tabList.Visible = visible
    if self.sidebar then
        self.sidebar.Visible = visible
    end
end

-- The window's own surfaces: shadow, rim, the fade over the content, and (sidebar) the content
-- card and the profile chip. These come and go together every time the window opens or collapses.
function Window:_fadeSurfaces(shown, fadeInfo)
    local targets = {
        [self.windowShadow] = { Transparency = if shown then 0.6 else 1 },
        [self.windowStroke] = { Transparency = if shown then 0.95 else 1 },
        [self.bottomFade] = { BackgroundTransparency = if shown then 0 else 1 },
    }

    if self.elementsStroke then
        targets[self.elements] = {
            BackgroundTransparency = if shown then self.layout.cardTransparency else 1,
        }
        targets[self.elementsStroke] = { Transparency = if shown then 0 else 1 }
    end

    for instance, properties in targets do
        if fadeInfo then
            variables.tweenService:Create(instance, fadeInfo, properties):Play()
        else
            for property, value in properties do
                instance[property] = value
            end
        end
    end

    sidebar.setProfileShown(self, shown, fadeInfo)
end

-- Fade the open tab's elements out - the only ones actually on screen, since the page
-- navigation keeps the other tabs' elements invisible. Shared by Hide and minimise.
function Window:_fadeSelectedElementsOut()
    if self.selectedTab then
        for _, element in ipairs(self.selectedTab.elements) do
            element:_setShown(false, true)
        end
    end
end

-- Reveal the open tab's elements with a quick top-to-bottom stagger, but only for the ones
-- actually within the scroll viewport - whatever's scrolled off (above or below) just snaps in,
-- since nobody's looking at it. So reopening a page scrolled halfway down animates from where
-- you left off, not from the very top. Everything is measured live off the scrolling frame's
-- real viewport + each element's real position, so it's correct at any window size, any scroll.
-- Other tabs snap ready off-screen too. `budget` caps how long the stagger runs before the
-- remaining on-screen elements come in together, so a tall viewport doesn't crawl.
function Window:_revealElements(perElementDelay, budget)
    for _, tab in pairs(self.tabs) do
        if tab ~= self.selectedTab then
            for _, element in ipairs(tab.elements) do
                element:_setShown(true, false)
            end
        end
    end

    local tab = self.selectedTab
    if not tab then
        return
    end

    local page = tab.tabPage
    local viewTop = page.AbsolutePosition.Y
    local viewBottom = viewTop + page.AbsoluteWindowSize.Y

    local maxStaggered = math.floor(budget / perElementDelay)
    local staggered = 0
    for _, element in ipairs(tab.elements) do
        local top = element.main.AbsolutePosition.Y
        local onScreen = (top + element.main.AbsoluteSize.Y) > viewTop and top < viewBottom
        if onScreen then
            element:_setShown(true, true)
            staggered += 1
            if staggered <= maxStaggered then
                task.wait(perElementDelay)
            end
        else
            element:_setShown(true, false) -- off-screen: no point animating what isn't visible
        end
    end
end

function Window:Show()
    -- idempotent: replaying the restore on a visible window teleports it to a stale position
    if self.animating or not self.hidden then
        return
    end
    self.animating = true
    self._revealing = true

    -- autoLoad reflects the saved config once, on first open. Re-loading on every show would
    -- wipe any changes the user made and closed without saving. a load that throws must not
    -- strand animating=true, or the window could never open again.
    if self.configuration.autoLoad and not self._autoLoaded then
        self._autoLoaded = true
        local ok, err = pcall(self.Load, self)
        if not ok then
            log.warn("Rayfield: Failed to load configuration - " .. tostring(err))
        end
    end

    self.hidden = false
    self.minimised = false

    -- a ChangeTheme landed while we were collapsed; apply it before anything fades back in
    if self._themeRefreshPending then
        self._themeRefreshPending = false
        self:_refreshElementThemes()
    end

    self.collapsedInteract.Visible = false -- first thing on click: stop it eating any more input

    if self._freeMouse then
        self._freeMouse()
    end

    if self.hasShownOnce then
        self:_quickRestore()
    else
        self.hasShownOnce = true
        self:_firstShow()
    end
end

function Window:_quickRestore()
    -- the screen can have changed while we were hidden, so where it sat may no longer fit
    local target = self:_clampedPosition(self._restorePosition or UDim2.new(0.5, 0, 0.5, 0))
    self._restorePosition = target

    local growInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local cornerInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local fadeInfo = TweenInfo.new(0.28, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    -- Phase 1: nothing but the pill morphing back into the window frame. The collapsed face
    -- fades off, main grows + un-rounds. No chrome, no content - so you never see the topbar,
    -- tabs or bottom fade floating over a frame that isn't a window yet.
    chrome.setCollapsedShown(self, false, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
    local restore = variables.tweenService:Create(self.main, growInfo, { Size = self.size, Position = target })
    restore.Completed:Connect(function()
        if self.hidden or self.unloaded then
            return
        end

        -- The restored frame has cleared the pill's slot. Its own completion is the single
        -- clock for moving the toast stack back, regardless of how this motion is implemented.
        self._collapsedShown = false
        setTopToastPosition(self, true)
    end)
    restore:Play()
    variables.tweenService:Create(self.windowCorner, cornerInfo, { CornerRadius = self.theme.CornerRoundness }):Play()

    -- Phase 2: once the frame actually reads as a window, fade its chrome in and stagger the
    -- open tab's elements. Other tabs snap ready off-screen - nobody's looking, so no animation.
    task.delay(0.22, function()
        self.topbar.Visible = true
        self:_setContentVisible(true)

        self:_fadeSurfaces(true, fadeInfo)

        if self.topbarIcon then
            variables.tweenService:Create(self.topbarIcon, fadeInfo, { ImageTransparency = 0 }):Play()
        end
        if self.title then
            variables.tweenService:Create(self.title, fadeInfo, { TextTransparency = 0 }):Play()
        end
        if self.subtitle then
            variables.tweenService:Create(self.subtitle, fadeInfo, { TextTransparency = 0.7 }):Play()
        end

        for _, action in ipairs(self.actionContainer:GetChildren()) do
            if action:IsA("Frame") then
                variables.tweenService:Create(action.ImageLabel, fadeInfo, { ImageTransparency = 0.6 }):Play()
            end
        end

        -- if we were hidden with the settings page open, bring its cog back lit (its open
        -- state) rather than the default resting brightness the loop above just set
        if self.settingsAction and self.selectedTab == self.rfSettings then
            variables.tweenService:Create(self.settingsAction.iconLabel, fadeInfo, { ImageTransparency = 0.2 }):Play()
        end

        for _, tag in self.tags do
            tag:_setShown(true, fadeInfo)
        end

        for _, tab in pairs(self.tabs) do
            if not tab.neglectSelector and tab.topbarItem then
                tab.topbarItem.Visible = true
                tab:_applyVisual(if self.selectedTab == tab then "selected" else "unselected", fadeInfo)
            end
        end
        self:_setTabSectionsVisible(true)
        self:_setTabSectionsShown(true, fadeInfo)

        self:_revealElements(0.035, 0.4)
    end)

    -- Drag handle grows in with the chrome, same width sweep it uses on first reveal. Position
    -- is recalculated against the full restored size - if the window was minimised (a shorter
    -- bar-hang offset) before hiding, it would otherwise reappear at the old, wrong height.
    task.delay(0.22, function()
        self.drag.drag.Position =
            UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset + self.size.Y.Offset / 2 + 15)
        self.drag.dragCosmetic.Size = UDim2.fromOffset(0, 4)
        self.drag.dragCosmetic.BackgroundTransparency = 1
        self.drag.drag.Visible = true
        variables.tweenService
            :Create(self.drag.dragCosmetic, growInfo, { Size = UDim2.fromOffset(100, 4), BackgroundTransparency = 0.7 })
            :Play()
    end)

    task.delay(0.6, function()
        self.animating = false
        self._revealing = false
    end)
end

function Window:_firstShow()
    -- Intro animation
    self:_setContentVisible(true)

    self.drag.drag.Visible = false
    self.main.Visible = true
    variables.tweenService
        :Create(
            self.main,
            TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
            { BackgroundTransparency = 0, Size = self.size }
        )
        :Play()
    task.wait(0.85) -- let the frame actually read as a window before anything shows on top of it
    self:_fadeSurfaces(true, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
    task.wait(0.3)

    if self.icon then
        variables.tweenService
            :Create(
                self.topbarIcon,
                TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { ImageTransparency = 0 }
            )
            :Play()
    end
    if self.title then
        variables.tweenService
            :Create(
                self.title,
                TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { TextTransparency = 0 }
            )
            :Play()
    end
    task.wait(0.1)
    if self.subtitle then
        variables.tweenService
            :Create(
                self.subtitle,
                TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                { TextTransparency = 0.7 }
            )
            :Play()
    end

    for _, action in ipairs(self.actionContainer:GetChildren()) do
        if action:IsA("Frame") then
            task.wait(0.02)
            variables.tweenService
                :Create(
                    action.ImageLabel,
                    TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
                    { ImageTransparency = 0.6 }
                )
                :Play()
        end
    end

    for _, tag in self.tags do
        tag:_setShown(true, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
    end

    task.wait(0.2)

    -- Stagger the selector in, but on a budget: past a handful of tabs the rest arrive
    -- together rather than making a long list crawl in one at a time.
    task.spawn(function()
        local info = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        -- headings arrive together, ahead of the stagger: a row shouldn't land under a
        -- heading that hasn't turned up yet
        self:_setTabSectionsVisible(true)
        self:_setTabSectionsShown(true, info)

        local staggered = 0
        for _, tab in pairs(self.tabs) do
            if not tab.neglectSelector then
                tab.topbarItem.Visible = true
                tab:_applyVisual(if self.selectedTab == tab then "selected" else "unselected", info)
                tab:_spinGradients()

                staggered += 1
                if staggered <= maxStaggeredTabs then
                    task.wait(tabStagger)
                end
            end
        end
    end)

    self:_revealElements(0.03, 2)

    task.wait(1)

    -- the fit can change between construction and now (a late camera banks a new size), so
    -- re-derive the bar's spot rather than trusting the construction-time position
    self:_syncDragBar()
    self.drag.drag.Visible = true
    variables.tweenService
        :Create(
            self.drag.dragCosmetic,
            TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.7 }
        )
        :Play()
    variables.tweenService
        :Create(
            self.drag.dragCosmetic,
            TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(100, 4) }
        )
        :Play()

    self.animating = false
    self._revealing = false

    -- Welcome the user once if this is a new/changed account on this device (unless they've
    -- turned it off in settings). Just a toast now - the profile chip is a toast like any other.
    local localPlayer = variables.localPlayer
    if localPlayer and self.settings.welcomeToast and chrome.isNewUser() then
        self:Toast({
            title = localPlayer.DisplayName,
            subtitle = locale.resolve("Signed in as"),
            subtitleAbove = true, -- reads "Signed in as" / name, label over value
            avatar = localPlayer.UserId,
            minWidth = 220, -- match the old license card's width for that roomy right-hand space
        })
    end
end

function Window:GetPath()
    return persistence.getPath(self)
end

-- name saves to a specific config; omit it to save the default file.
function Window:Save(name)
    if name ~= nil and (type(name) ~= "string" or name == "") then
        return false
    end
    return persistence.save(self, name)
end

-- name loads a specific config; omit it to load the default file.
function Window:Load(name)
    if name ~= nil and (type(name) ~= "string" or name == "") then
        return false
    end
    return persistence.load(self, name)
end

-- Load a named config and make it the live state autoLoad restores next session. Loading only
-- applies to the running UI; writing it back to the default file is what carries it across
-- sessions, so the config manager can pick a config once and have it stick.
function Window:_applyNamedConfig(name)
    if not self:Load(name) then
        return false
    end
    -- promotion means the default file becomes this config, unbuilt elements included; repoint
    -- the carry-forward so Save doesnt drop flags for elements that havent registered yet
    local _, defaultPath = persistence.getPath(self)
    self._loadedConfigPath = defaultPath
    self:Save()
    return true
end

function Window:ListConfigs()
    return persistence.list(self)
end

function Window:DeleteConfig(name)
    return persistence.delete(self, name)
end

-- Read a flag's current value, or nil if nothing is registered under it.
function Window:Get(flag)
    local control = self.controls[flag]
    return control and control.value
end

-- Set a flag's value, routing through the control so the UI updates and the callback fires.
-- Returns false if no control is registered under the flag.
function Window:Set(flag, value)
    local control = self.controls[flag]
    if not control then
        return false
    end
    control:Set(value)
    return true
end

-- Jump to a tab by handle, name, or its page instance. No-ops on an unknown tab rather
-- than handing JumpTo something it cant resolve.
-- Move the page view only. Tab:Select owns the selection state and the pill, and calls this
-- for the scroll; nothing else should jump pages without going through it.
function Window:_jumpTo(page)
    if page then
        self.elementsLayout:JumpTo(page)
    end
end

-- Go to a tab, by name or by the tab itself. Routes through Tab:Select so the selection,
-- the pill and the page all agree; jumping the page alone would leave the wrong tab lit and
-- the reveal animations pointed at the wrong elements.
function Window:Navigate(tab)
    if tab == nil then
        return
    end

    local target
    for _, candidate in self.tabs do
        -- by name, by the tab itself, or by the page instance a caller held onto
        if candidate == tab or candidate.name == tab or candidate.tabPage == tab then
            target = candidate
            break
        end
    end

    if not target then
        return
    end
    target:Select()
end

function Window:Create(className, properties, themeProperties)
    assert(typeof(className) == "string", "Invalid argument #1 (string expected)")
    local instance = Instance.new(className)

    -- Themed properties apply first so animation start-states in `properties` (e.g. a hidden
    -- BackgroundTransparency = 1) still win at build; the theme value is the reveal target.
    if themeProperties and self.theme then
        for property, value in themeProperties do
            instance[property] = (
                if typeof(value) == "table" then value[2](self.theme[value[1]]) else self.theme[value]
            )
        end

        self.themeProperties[instance] = themeProperties
    end

    if properties then
        for property, value in properties do
            if locale.isToken(value) then
                self:_bindLocale(instance, property, locale.sourceOf(value))
            else
                image.assign(instance, property, value)
            end
        end
    end

    table.insert(self.instances, instance)
    return instance
end

-- Bind instance[property] to a source string: set it to the active locale's form now and remember
-- it so SetLocale can re-resolve in place without rebuilding anything. Mirrors how themeProperties
-- lets ChangeTheme re-apply themed values later.
function Window:_bindLocale(instance, property, source)
    instance[property] = locale.resolve(source)

    local entries = self.localeProperties[instance]
    if not entries then
        entries = {}
        self.localeProperties[instance] = entries
    end
    entries[property] = source
end

-- Swap every localized label to `localeId` in place. Element values, slider readouts and other
-- data aren't copy, so they're untouched. AutomaticSize reflows widths for us; the few manually
-- measured labels (toasts) are transient enough not to need a re-measure.
function Window:SetLocale(localeId)
    locale.setActive(localeId)
    for instance, entries in self.localeProperties do
        for property, source in entries do
            instance[property] = locale.resolve(source)
        end
    end
end

-- Swap the dev translation hook (source, localeId) -> string?. Follow with SetLocale (or pass the
-- same locale back) to re-resolve everything already on screen through the new hook.
function Window:SetTranslator(translator)
    locale.translator = translator
end

-- Merge more translation tables in at runtime ({ [localeId] = { [source] = translated } }) and
-- re-apply the active locale, so a language pack added after the UI is built lands immediately.
function Window:RegisterTranslations(tables)
    locale.register(tables)
    self:SetLocale(locale.current)
end

-- Soft glow behind a GuiObject via a native UIShadow (no image). ZIndex -1 keeps it behind.
-- `color` is a Color3 for a fixed glow, or a theme key (string) for a shadow that tracks the
-- theme and re-tints on ChangeTheme - a ColorSequence key resolves to its first keypoint.
function Window:CreateGlow(parent, color, blur, transparency)
    local properties = {
        BlurRadius = UDim.new(0, blur),
        Transparency = transparency,
        ZIndex = -1,

        Parent = parent,
    }

    if typeof(color) == "string" then
        return self:Create("UIShadow", properties, {
            Color = {
                color,
                function(value)
                    return if typeof(value) == "ColorSequence" then value.Keypoints[1].Value else value
                end,
            },
        })
    end

    properties.Color = color
    return self:Create("UIShadow", properties)
end

-- Flash an element's inset box + glow to signal a set landed: green for a good set, red for a
-- rejected one, then settle back to the box's idle look. green/red are our universal accents.
-- The element supplies `box`, an optional `glow`, and its idle transparencies (_boxIdle/_glowIdle).
function Window:_flashResult(element, ok)
    local box = element.box
    if not box then
        return
    end
    local glow = element.glow
    local stroke = element.boxStroke
    local fill = ok and constants.accent.on or self.theme.ErrorColor
    local edge = ok and constants.accent.onStroke or self.theme.ErrorStrokeColor
    local inInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local outInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- a quick coloured pulse: box fill tints (transparency untouched), edge + glow brighten
    variables.tweenService:Create(box, inInfo, { BackgroundColor3 = fill }):Play()
    if stroke then
        variables.tweenService:Create(stroke, inInfo, { Color = edge, Transparency = 0.4 }):Play()
    end
    if glow then
        variables.tweenService:Create(glow, inInfo, { Color = edge, Transparency = 0.6 }):Play()
    end

    -- token so a quick re-set restarts the flash instead of an old revert cutting it short
    element._flashToken = (element._flashToken or 0) + 1
    local token = element._flashToken
    task.delay(0.22, function()
        if element._flashToken ~= token then
            return
        end
        variables.tweenService:Create(box, outInfo, { BackgroundColor3 = self.theme.FieldBackground }):Play()
        if stroke then
            variables.tweenService
                :Create(stroke, outInfo, { Color = self.theme.SurfaceStroke, Transparency = 0.85 })
                :Play()
        end
        if glow then
            variables.tweenService
                :Create(glow, outInfo, { Color = self.theme.FieldGlow, Transparency = element._glowIdle or 1 })
                :Play()
        end
    end)
end

-- Additive white hover-brighten overlay filling an element (fill colour comes from the gradient).
-- Tween its BackgroundTransparency 1 -> ~0.97 on hover.
function Window:CreateHoverOverlay(parent)
    local overlay = self:Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 1,

        Parent = parent,
    })

    self:Create("UICorner", {
        Parent = overlay,
    }, { CornerRadius = "ElementCornerRadius" })

    return overlay
end

-- hover: brighten stroke + title (+ overlay). shared by button/toggle
function Window:_wireElementHover(element)
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local theme = self.theme

    self:ConnectFor(element, element.main.MouseEnter, function()
        if not self:_interactive() then
            return -- window still revealing/hiding: dont light up mid-animation
        end
        variables.tweenService
            :Create(
                element.stroke,
                info,
                { Transparency = theme.ElementStrokeHoverTransparency, Color = theme.ElementStrokeHover }
            )
            :Play()
        variables.tweenService:Create(element.title, info, { TextColor3 = theme.ElementTextHoverColor }):Play()
        if element.hoverOverlay then
            variables.tweenService:Create(element.hoverOverlay, info, { BackgroundTransparency = 0.97 }):Play()
        end
    end)

    self:ConnectFor(element, element.main.MouseLeave, function()
        variables.tweenService
            :Create(
                element.stroke,
                info,
                { Transparency = theme.ElementStrokeTransparency, Color = theme.ElementStroke }
            )
            :Play()
        variables.tweenService:Create(element.title, info, { TextColor3 = theme.ContentColor }):Play()
        if element.hoverOverlay then
            variables.tweenService:Create(element.hoverOverlay, info, { BackgroundTransparency = 1 }):Play()
        end
    end)
end

-- run a callback with the red error-flash on failure, debounced via element._errored so a
-- slider firing every frame flashes once. shared by every interactive element. elements whose
-- `main` is a transparent wrapper (the dropdown) set `flashTarget` to the frame to tint.
function Window:_runGuarded(element, fn, ...)
    -- a locked element fires nothing. This is the one place every element's callback goes
    -- through, so locking here is what makes the lock real rather than cosmetic.
    if element.locked then
        return
    end

    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(function()
            return fn(table.unpack(args, 1, args.n))
        end)
        if ok or element._errored then
            return
        end
        element._errored = true

        local flashFrame = element.flashTarget or element.main
        local quickOut = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        variables.tweenService:Create(flashFrame, quickOut, { BackgroundColor3 = self.theme.ErrorColor }):Play()
        variables.tweenService:Create(element.stroke, quickOut, { Color = self.theme.ErrorStrokeColor }):Play()
        -- minimal elements build without a label, and the flash must survive that
        if element.title then
            element.title.Text = locale.resolve("Error, log recorded in console.")
        end

        log.warn(
            `Rayfield encountered an error, with the callback for a {element.__type} component named '{element.name}':`
        )
        log.print(err)

        task.wait(1)

        if element.title then
            element.title.Text = locale.resolve(element.name)
        end
        variables.tweenService
            :Create(
                flashFrame,
                TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }
            )
            :Play()
        variables.tweenService
            :Create(
                element.stroke,
                TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Color = self.theme.ElementStroke }
            )
            :Play()
        element._errored = false
    end)
end

-- Standard element body: white base + gradient fill + rounded corner + flat stroke (hidden until shown).
-- Returns the stroke; call after creating `main` with a white BackgroundColor3.
function Window:StyleElementBody(main)
    self:Create("UIGradient", {
        Rotation = 270,

        Parent = main,
    }, { Color = "ElementGradient" })

    self:Create("UICorner", {
        Parent = main,
    }, { CornerRadius = "ElementCornerRadius" })

    return self:Create("UIStroke", {
        Transparency = 1,

        Parent = main,
    }, { Color = "ElementStroke", Transparency = "ElementStrokeTransparency" })
end

-- Shared scaffold for the compact button/toggle row: the white body + stroke, the fill flex
-- so it shares the row width, and the click surface. Callers add their own padding + content
-- into the returned interact, keeping the two elements identical where they should be.
function Window:_buildCompactRow(host, name, interactZIndex)
    local main = self:Create("Frame", {
        Name = name,
        Size = UDim2.fromOffset(0, compactRowHeight),
        AutomaticSize = Enum.AutomaticSize.X,
        ClipsDescendants = true, -- overflow guard
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,

        BackgroundTransparency = 1, -- In = ElementTransparency

        Parent = host.tabPage,
    }, { BackgroundTransparency = "ElementTransparency" })

    local stroke = self:StyleElementBody(main)

    -- share the row width (grow + shrink)
    self:Create("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill,
        Parent = main,
    })

    -- main flows + fills the interact
    self:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,

        Parent = main,
    })

    -- clickable wrapper, doubles as the hover-brighten surface
    local interact = self:Create("TextButton", {
        Text = "",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1, -- hover fades to 0.97
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, compactRowHeight),
        BorderSizePixel = 0,
        TextTransparency = 1,
        ZIndex = interactZIndex or 1,

        Parent = main,
    })

    self:Create("UICorner", {
        Parent = interact,
    }, { CornerRadius = "ElementCornerRadius" })

    return main, stroke, interact
end

-- Like StyleElementBody but with a gradient stroke (subtle sheen) instead of a flat one.
-- White stroke base tinted by the ElementStrokeGradient. Used by the dropdown's header +
-- options cards. Returns the stroke.
function Window:StyleElementPanel(frame)
    self:Create("UIGradient", {
        Rotation = 270,

        Parent = frame,
    }, { Color = "ElementGradient" })

    self:Create("UICorner", {
        Parent = frame,
    }, { CornerRadius = "ElementCornerRadius" })

    local stroke = self:Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1, -- In = ElementStrokeTransparency

        Parent = frame,
    })

    self:Create("UIGradient", {
        Rotation = 270,

        Parent = stroke,
    }, { Color = "ElementStrokeGradient" })

    return stroke
end

-- Reveal a single instance: instantly set props when animate is false, else tween them with info.
function Window:_reveal(instance, props, animate, info)
    if not instance then
        return
    end
    if animate then
        variables.tweenService:Create(instance, info or revealInfo, props):Play()
    else
        for property, value in props do
            instance[property] = value
        end
    end
end

-- Reveal the parts every non-Section element shares (fill/stroke/title/icon/descriptor).
function Window:_revealCommon(element, animate)
    self:_reveal(element.stroke, { Transparency = self.theme.ElementStrokeTransparency }, animate)
    self:_reveal(element.title, { TextTransparency = 0 }, animate)
    self:_reveal(element.main, { BackgroundTransparency = self.theme.ElementTransparency or 0 }, animate)
    if element.iconLabel then
        self:_reveal(element.iconLabel, { ImageTransparency = 0 }, animate)
    end
    if element.descriptor then
        self:_reveal(element.descriptor.titleLabel, { TextTransparency = 0.7 }, animate)
    end
end

-- The reverse of _revealCommon: fade the same shared parts back out to fully transparent.
function Window:_hideCommon(element, animate)
    self:_reveal(element.stroke, { Transparency = 1 }, animate)
    self:_reveal(element.title, { TextTransparency = 1 }, animate)
    self:_reveal(element.main, { BackgroundTransparency = 1 }, animate)
    if element.iconLabel then
        self:_reveal(element.iconLabel, { ImageTransparency = 1 }, animate)
    end
    if element.descriptor then
        self:_reveal(element.descriptor.titleLabel, { TextTransparency = 1 }, animate)
    end
end

-- The rect main morphs into once collapsed: the same top-centre spot the old standalone
-- restore pill used to sit at, translated into main's own centre-anchored space (main never
-- changes AnchorPoint, so its Position always addresses its centre, not its top edge).
function Window:_collapsedRect()
    local size = if self.showIconOnly then collapsedIconSize else collapsedSize
    -- a pill that's been dragged stays where it was put, rather than snapping back to the top
    if self._collapsedPosition then
        return self._collapsedPosition, size
    end
    local home = UDim2.new(
        collapsedTop.X.Scale,
        collapsedTop.X.Offset,
        collapsedTop.Y.Scale,
        collapsedTop.Y.Offset + size.Y.Offset / 2
    )
    return home, size
end

-- true only when the window is fully shown and idle. hover/press animations gate on this so
-- nothing lights up mid show/hide/minimise reveal, while elements are still tweening in.
function Window:_interactive()
    return not self.animating and not self.hidden
end

-- true when the window is up and not mid reveal or hide. action icons settle on this rather
-- than _interactive: minimise animates too, but it never repaints the icons the way show and
-- hide do, so an icon settling during it has nothing to fight and would otherwise stay lit.
function Window:_settled()
    return not self.hidden and not self._revealing
end

function Window:Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(self.connections, connection)
    return connection
end

-- Like Connect, but also files the connection on the element that owns it, so Tab:Remove can
-- tear an element's connections down instead of leaving them tracked until Unload. Every
-- persistent element connection funnels through here.
function Window:ConnectFor(owner, signal, callback)
    local connection = self:Connect(signal, callback)
    owner.connections = owner.connections or {}
    table.insert(owner.connections, connection)
    return connection
end

-- Disconnect a connection from Window:Connect and drop it from the tracked list.
-- Transient UI (dropdown popups, removed tabs) calls this so open/close churn doesnt
-- pile up dead entries that only get cleared at Unload.
function Window:Disconnect(connection)
    if not connection then
        return
    end
    local index = table.find(self.connections, connection)
    if index then
        table.remove(self.connections, index)
    end
    connection:Disconnect()
end

-- Destroy a subtree and forget every tracked instance inside it. Transient elements
-- (notifications) use this instead of a bare Destroy so self.instances doesnt grow
-- for the whole session.
function Window:DestroySubtree(root)
    if not root then
        return
    end

    local inSubtree = { [root] = true }
    for _, descendant in root:GetDescendants() do
        inSubtree[descendant] = true
    end
    for i = #self.instances, 1, -1 do
        local instance = self.instances[i]
        if inSubtree[instance] then
            table.remove(self.instances, i)
            self.themeProperties[instance] = nil
            self.localeProperties[instance] = nil
        end
    end

    root:Destroy()
end

-- Drop a batch of connections in one go. Disconnect does a linear scan and a shift per
-- connection, which is fine for one and quadratic for a thousand; this filters each list once.
-- `owner` is the element that also tracked them, if any.
function Window:DisconnectMany(owner, connections)
    if not connections or #connections == 0 then
        return
    end

    local dropping = {}
    for _, connection in connections do
        dropping[connection] = true
        connection:Disconnect()
    end

    local function filter(list)
        if not list then
            return
        end
        local kept = 0
        for index = 1, #list do
            local entry = list[index]
            if not dropping[entry] then
                kept += 1
                list[kept] = entry
            end
        end
        for index = #list, kept + 1, -1 do
            list[index] = nil
        end
    end

    filter(self.connections)
    if owner and owner ~= self then
        filter(owner.connections)
    end
end

-- DestroySubtree for a batch. One walk of the tracked instances for the whole set rather than
-- one per subtree - tearing down a long list was otherwise re-walking every instance in the
-- window for every row it dropped.
function Window:DestroySubtrees(roots)
    if not roots or #roots == 0 then
        return
    end

    local inSubtree = {}
    for _, root in roots do
        inSubtree[root] = true
        for _, descendant in root:GetDescendants() do
            inSubtree[descendant] = true
        end
    end

    local kept = 0
    for index = 1, #self.instances do
        local instance = self.instances[index]
        if inSubtree[instance] then
            self.themeProperties[instance] = nil
            self.localeProperties[instance] = nil
        else
            kept += 1
            self.instances[kept] = instance
        end
    end
    for index = #self.instances, kept + 1, -1 do
        self.instances[index] = nil
    end

    for _, root in roots do
        root:Destroy()
    end
end

function Window:Unload()
    self.unloaded = true
    -- drop our effects and release the gui they hung on, but leave the enabled flag alone -
    -- another window may still be open and haptics arent ours to switch off for it
    hapticEngine.teardown()
    hapticEngine.releaseContainer(self.screenGui)
    if self._liveTween then
        self._liveTween:Cancel() -- unparks the LiveAnimation loop before we destroy the gradient
        self._liveTween = nil
    end
    for i = #self.connections, 1, -1 do
        self.connections[i]:Disconnect()
    end
    for i = #self.instances, 1, -1 do
        self.instances[i]:Destroy()
    end

    -- destroying isnt forgetting: a hub that loads and unloads repeatedly would keep the whole
    -- dead instance graph reachable through the handle it still holds. DestroySubtree already
    -- clears as it goes, so match it here.
    table.clear(self.connections)
    table.clear(self.instances)
    table.clear(self.themeProperties)
    table.clear(self.localeProperties)
    table.clear(self.controls)
    table.clear(self.tabs)
end

return Window

end)() end,
    [32] = function()local wax,script,require=ImportGlobals(32)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Deep violet dark theme with a purple accent. Partial: overrides the violet tones + accent,
-- inherits corners, fonts and toggle/field behaviour from default.
return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 16, 32)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(30, 22, 46)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 28, 56)),
    }),
    ShadowColor = Color3.fromRGB(12, 6, 22),

    ElementStroke = Color3.fromRGB(54, 42, 74),
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 24, 48)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(36, 28, 54)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 28, 54)),
    }),
    ElementStrokeGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 58, 104)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(88, 72, 124)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 58, 104)),
    }),
    ElementStrokeHover = Color3.fromRGB(84, 68, 118),

    TabBackground = ColorSequence.new(Color3.fromRGB(54, 42, 80), Color3.fromRGB(34, 26, 52)),
    TabStroke = ColorSequence.new(Color3.fromRGB(88, 70, 128), Color3.fromRGB(54, 42, 80)),

    SliderBackground = Color3.fromRGB(46, 36, 68),
    SliderBackgroundHover = Color3.fromRGB(60, 48, 90),
    SliderProgress = ColorSequence.new(Color3.fromRGB(170, 112, 248), Color3.fromRGB(138, 80, 224)),

    -- Violet accent for the active toggle, slider glow and popup primary button.
    AccentColor = Color3.fromRGB(168, 110, 246),
    AccentStroke = Color3.fromRGB(200, 154, 255),

    ToggleKnobOff = Color3.fromRGB(224, 214, 236), -- cool off-knob on the dark track

    StatBackground = Color3.fromRGB(24, 18, 38),

    DropdownHighlight = Color3.fromRGB(168, 110, 246),

    NeutralButton = Color3.fromRGB(46, 36, 68),
    NeutralButtonHover = Color3.fromRGB(60, 48, 90),
    NeutralButtonStroke = Color3.fromRGB(140, 116, 190),
}

end)() end,
    [33] = function()local wax,script,require=ImportGlobals(33)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Deep cobalt dark theme with blue accents. A partial theme: it only overrides the colours that
-- differ from default and inherits the rest (corners, fonts, toggle/field behaviour) from it.
return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 16, 34)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(20, 26, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 36, 66)),
    }),
    ShadowColor = Color3.fromRGB(6, 8, 20),

    ElementStroke = Color3.fromRGB(44, 52, 82),
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 32, 58)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(30, 38, 66)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 38, 66)),
    }),
    ElementStrokeGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 66, 104)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(70, 82, 124)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 66, 104)),
    }),
    ElementStrokeHover = Color3.fromRGB(64, 76, 116),

    TabBackground = ColorSequence.new(Color3.fromRGB(48, 58, 92), Color3.fromRGB(30, 38, 64)),
    TabStroke = ColorSequence.new(Color3.fromRGB(78, 92, 140), Color3.fromRGB(48, 58, 92)),

    SliderBackground = Color3.fromRGB(40, 48, 78),
    SliderBackgroundHover = Color3.fromRGB(54, 64, 100),
    SliderProgress = ColorSequence.new(Color3.fromRGB(64, 132, 248), Color3.fromRGB(42, 104, 224)),

    -- Blue accent for the active toggle, slider glow and popup primary button.
    AccentColor = Color3.fromRGB(48, 120, 240),
    AccentStroke = Color3.fromRGB(96, 164, 255),

    ToggleKnobOff = Color3.fromRGB(196, 206, 232), -- cool off-knob on the dark track

    StatBackground = Color3.fromRGB(20, 26, 48),

    DropdownHighlight = Color3.fromRGB(48, 120, 240),

    NeutralButton = Color3.fromRGB(40, 48, 78),
    NeutralButtonHover = Color3.fromRGB(54, 64, 100),
    NeutralButtonStroke = Color3.fromRGB(120, 138, 195), -- clearly lighter than the fill, reads at 0.85
}

end)() end,
    [34] = function()local wax,script,require=ImportGlobals(34)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.Parent.utility.variables)

return {
    CornerRoundness = UDim.new(0, 20),
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35)),
    }),
    ShadowColor = Color3.fromRGB(20, 20, 20),

    ElementStroke = Color3.fromRGB(35, 35, 35),
    -- Per-element fill gradient (applied over a white base)
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35)),
    }),
    -- Subtle sheen tint for gradient strokes (dropdown cards). Kept lighter than the fill so
    -- the edge still reads low in the window, where the bg gradient is itself ~35.
    ElementStrokeGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(48, 48, 48)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(58, 58, 58)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 48, 48)),
    }),
    TabColor = Color3.fromRGB(255, 255, 255),
    TabBackground = ColorSequence.new(Color3.fromRGB(50, 50, 50), Color3.fromRGB(35, 35, 35)),
    TabStroke = ColorSequence.new(Color3.fromRGB(95, 95, 95), Color3.fromRGB(50, 50, 50)),
    SliderBackground = Color3.fromRGB(38, 38, 42),
    SliderBackgroundHover = Color3.fromRGB(50, 50, 56),
    SliderProgress = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 210)),
    SliderStroke = Color3.fromRGB(255, 255, 255),
    ActionColor = Color3.fromRGB(255, 255, 255),
    TitleFont = variables.brandFont(Enum.FontWeight.SemiBold),
    Font = variables.brandFont(Enum.FontWeight.Medium),
    ContentColor = Color3.fromRGB(255, 255, 255),

    LiveAnimation = false, -- Subtly changes window gradient and shadow offset to make Slate feel more natural.

    DarkToggleOverlay = true,
    ElementTransparency = 0,
    ElementStrokeTransparency = 0,
    ElementStrokeHoverTransparency = 0,
    ElementStrokeHover = Color3.fromRGB(60, 60, 68),
    ElementCornerRadius = UDim.new(0, 12),
    ElementTextHoverColor = Color3.fromRGB(255, 255, 255),
    TitlingColor = Color3.fromRGB(255, 255, 255),

    DropdownHighlight = Color3.fromRGB(255, 255, 255),

    -- Accent for the active toggle, slider glow and popup primary button (Slate Monochrome).
    AccentColor = Color3.fromRGB(255, 255, 255),
    AccentStroke = Color3.fromRGB(255, 255, 255),
    AccentGlow = 0.2, -- shown transparency of the toggle's accent glow

    StatBackground = Color3.fromRGB(20, 20, 24),
    SliderHandle = Color3.fromRGB(255, 255, 255),
    PillCornerRadius = UDim.new(1, 0), -- tab pills + the collapsed icon

    -- Toggle switch: track colour + transparency, and the off-knob's colour + transparency.
    ToggleTrack = Color3.fromRGB(0, 0, 0),
    ToggleTrackTransparency = 0.9,
    ToggleKnobOff = Color3.fromRGB(160, 160, 170),
    ToggleKnobOffTransparency = 0.6,

    -- Inset fields (input, keybind box): fill, its transparency, and the soft glow behind them.
    FieldBackground = Color3.fromRGB(255, 255, 255),
    FieldTransparency = 0.92,
    FieldGlow = Color3.fromRGB(255, 255, 255),

    PlaceholderColor = Color3.fromRGB(150, 150, 160), -- input/search hint text
    SurfaceStroke = Color3.fromRGB(255, 255, 255), -- faint rim on window/field/toast/popup surfaces

    -- Popup neutral (secondary) button: rest, hover and edge.
    NeutralButton = Color3.fromRGB(28, 28, 34),
    NeutralButtonHover = Color3.fromRGB(44, 44, 52),
    NeutralButtonStroke = Color3.fromRGB(80, 80, 90),

    ErrorColor = Color3.fromRGB(180, 180, 180),
    ErrorStrokeColor = Color3.fromRGB(240, 240, 240),
}

end)() end,
    [35] = function()local wax,script,require=ImportGlobals(35)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Warm charcoal dark theme with an amber accent. Partial: overrides the warm tones + accent,
-- inherits corners, fonts and toggle/field behaviour from default.
return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 18, 16)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(32, 27, 23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 33, 28)),
    }),
    ShadowColor = Color3.fromRGB(16, 12, 8),

    ElementStroke = Color3.fromRGB(54, 46, 40),
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 27, 23)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(38, 32, 27)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 32, 27)),
    }),
    ElementStrokeGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 62, 52)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(88, 76, 64)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 62, 52)),
    }),
    ElementStrokeHover = Color3.fromRGB(84, 72, 60),

    TabBackground = ColorSequence.new(Color3.fromRGB(56, 47, 40), Color3.fromRGB(36, 30, 26)),
    TabStroke = ColorSequence.new(Color3.fromRGB(92, 78, 66), Color3.fromRGB(56, 47, 40)),

    SliderBackground = Color3.fromRGB(48, 40, 34),
    SliderBackgroundHover = Color3.fromRGB(62, 52, 44),
    SliderProgress = ColorSequence.new(Color3.fromRGB(244, 152, 44), Color3.fromRGB(220, 110, 24)),

    -- Amber accent for the active toggle, slider glow and popup primary button.
    AccentColor = Color3.fromRGB(240, 142, 40),
    AccentStroke = Color3.fromRGB(255, 182, 92),

    ToggleKnobOff = Color3.fromRGB(232, 224, 214), -- warm off-knob on the dark track

    StatBackground = Color3.fromRGB(26, 21, 18),

    DropdownHighlight = Color3.fromRGB(240, 142, 40),

    NeutralButton = Color3.fromRGB(48, 40, 34),
    NeutralButtonHover = Color3.fromRGB(64, 54, 46),
    NeutralButtonStroke = Color3.fromRGB(150, 128, 104),
}

end)() end,
    [36] = function()local wax,script,require=ImportGlobals(36)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.Parent.utility.variables)

-- Light theme: cool white surfaces, dark text and cyan accents.
return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(246, 249, 251)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 241, 245)),
    }),
    -- Soft cool shadow so the window lifts off a light background without a hard edge.
    ShadowColor = Color3.fromRGB(116, 124, 132),

    LiveAnimation = false,

    -- Opaque white elements read against the near-white window through a thin border, not a tint.
    ElementTransparency = 0,
    ElementStroke = Color3.fromRGB(218, 224, 228),
    ElementGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
    ElementStrokeGradient = ColorSequence.new(Color3.fromRGB(224, 230, 234), Color3.fromRGB(232, 238, 242)),
    ElementStrokeTransparency = 0.1,
    ElementStrokeHoverTransparency = 0,
    ElementStrokeHover = Color3.fromRGB(0, 176, 208), -- cyan edge on hover
    DarkToggleOverlay = false, -- no dark veil; the track colour carries the switch instead

    -- Dark label so it reads unselected on white and stays legible on the cyan selected pill.
    TabColor = Color3.fromRGB(38, 42, 46),
    TabBackground = ColorSequence.new(Color3.fromRGB(0, 176, 208), Color3.fromRGB(0, 150, 184)),
    TabStroke = ColorSequence.new(Color3.fromRGB(80, 206, 230), Color3.fromRGB(0, 160, 196)),

    SliderBackground = Color3.fromRGB(224, 230, 234),
    SliderBackgroundHover = Color3.fromRGB(212, 220, 224),
    SliderProgress = ColorSequence.new(Color3.fromRGB(0, 182, 214), Color3.fromRGB(0, 146, 182)),
    SliderStroke = Color3.fromRGB(200, 206, 210),

    -- Cyan accent for the toggle, slider glow and popup primary button.
    AccentColor = Color3.fromRGB(0, 176, 208),
    AccentStroke = Color3.fromRGB(96, 210, 232),
    AccentGlow = 0.85, -- subtle accent bloom on the toggle/slider

    StatBackground = Color3.fromRGB(255, 255, 255),
    SliderHandle = Color3.fromRGB(60, 66, 72), -- dark grip instead of a white blob

    -- Opaque grey track so the switch reads on white without the dark overlay; white off-knob.
    ToggleTrack = Color3.fromRGB(198, 204, 210),
    ToggleTrackTransparency = 0,
    ToggleKnobOffTransparency = 0.05,

    -- Visible grey inset fields with a soft grey shadow instead of an invisible white one.
    FieldBackground = Color3.fromRGB(224, 230, 234),
    FieldTransparency = 0,
    FieldGlow = Color3.fromRGB(148, 154, 160),

    PlaceholderColor = Color3.fromRGB(138, 144, 150),
    SurfaceStroke = Color3.fromRGB(204, 210, 214),

    -- Light secondary button (dark text via adaptive contrast) instead of a dark blob on white.
    NeutralButton = Color3.fromRGB(224, 230, 234),
    NeutralButtonHover = Color3.fromRGB(212, 220, 224),
    NeutralButtonStroke = Color3.fromRGB(242, 246, 248), -- lighter than the fill

    ActionColor = Color3.fromRGB(68, 74, 80), -- top-bar icons
    TitlingColor = Color3.fromRGB(26, 30, 34),
    TitleFont = variables.brandFont(Enum.FontWeight.SemiBold),
    Font = variables.brandFont(Enum.FontWeight.Medium),
    ContentColor = Color3.fromRGB(42, 46, 52),
    ElementTextHoverColor = Color3.fromRGB(18, 22, 26),

    DropdownHighlight = Color3.fromRGB(0, 176, 208),

    ErrorColor = Color3.fromRGB(200, 60, 55),
    ErrorStrokeColor = Color3.fromRGB(240, 80, 70),
}

end)() end,
    [37] = function()local wax,script,require=ImportGlobals(37)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Dark theme with a rose accent. Partial: overrides the warm-plum tones + pink accent, inherits
-- corners, fonts and toggle/field behaviour from default.
return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 18, 22)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(36, 26, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(44, 32, 38)),
    }),
    ShadowColor = Color3.fromRGB(18, 10, 14),

    ElementStroke = Color3.fromRGB(58, 44, 50),
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 25, 29)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(40, 30, 34)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 34)),
    }),
    ElementStrokeGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(76, 58, 66)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(92, 70, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(76, 58, 66)),
    }),
    ElementStrokeHover = Color3.fromRGB(88, 66, 74),

    TabBackground = ColorSequence.new(Color3.fromRGB(62, 46, 53), Color3.fromRGB(38, 29, 33)),
    TabStroke = ColorSequence.new(Color3.fromRGB(102, 78, 88), Color3.fromRGB(62, 46, 53)),

    SliderBackground = Color3.fromRGB(50, 38, 44),
    SliderBackgroundHover = Color3.fromRGB(64, 50, 56),
    SliderProgress = ColorSequence.new(Color3.fromRGB(244, 88, 140), Color3.fromRGB(220, 60, 116)),

    -- Rose accent for the active toggle, slider glow and popup primary button.
    AccentColor = Color3.fromRGB(240, 82, 138),
    AccentStroke = Color3.fromRGB(255, 134, 178),

    ToggleKnobOff = Color3.fromRGB(236, 220, 226), -- warm off-knob on the dark track

    StatBackground = Color3.fromRGB(28, 20, 24),

    DropdownHighlight = Color3.fromRGB(240, 82, 138),

    NeutralButton = Color3.fromRGB(50, 38, 44),
    NeutralButtonHover = Color3.fromRGB(64, 50, 56),
    NeutralButtonStroke = Color3.fromRGB(170, 122, 140),
}

end)() end,
    [38] = function()local wax,script,require=ImportGlobals(38)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Public API types. camelCase is the documented surface; PascalCase keys still work.

export type Theme = string | { [string]: any }

-- Optional dev hook: given a source string (the English copy, which doubles as its key) and the
-- active locale id, return the translation, or nil/"" to fall through to the built-in tables.
export type Translator = (source: string, localeId: string) -> string?

-- Translation tables keyed by locale id, each mapping a source string to its translation, e.g.
-- { fr = { ["Close"] = "Fermer" }, ["pt-br"] = { ["Close"] = "Fechar" } }.
export type Translations = { [string]: { [string]: string } }

export type WindowConfiguration = {
    autoSave: boolean?,
    autoLoad: boolean?,
    fileName: string?,
    customFolder: string?,
}

export type WindowProps = {
    name: string?,
    subtitle: string?,
    theme: Theme?,
    icon: (string | number)?,
    showName: string?,
    showIcon: (string | number)?,
    showIconOnly: boolean?, -- collapse to a round icon badge instead of an icon-and-label pill
    sidebarLayout: boolean?, -- tabs down the left instead of across the top
    profile: string?, -- the line under the player's name in the sidebar; empty leaves the name alone
    configuration: WindowConfiguration?,
    fallbackFont: (Font | Enum.Font)?, -- built-in stand-in shown in secure mode while the brand font downloads
    locale: string?, -- pin the UI language; defaults to the player's Roblox locale
    translations: Translations?, -- language tables keyed by locale id; the easy, table-first path
    translator: Translator?, -- resolve copy yourself; falls back to the built-in tables
}

export type TabProps = {
    name: string?,
    icon: (string | number)?,
}

export type TagProps = {
    text: string?,
    title: string?,
    icon: (string | number)?,
    color: Color3?,
    order: number?,
}

export type SectionProps = {
    name: string?,
    icon: (string | number)?,
}

export type TextProps = {
    name: string?, -- the title above the body; either half can be left out
    text: string?, -- the body
    icon: (string | number)?,
}

export type DividerProps = {
    text: string?, -- an optional word in the middle of the rule
    spacing: number?, -- room above and below, in pixels
    line: boolean?, -- false draws no rule, leaving only the room
}

export type GroupProps = {
    direction: string?, -- "row" | "column" (default row); "horizontal"/"vertical" also work
}

export type ButtonProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    callback: (() -> ())?,
}

export type ToggleProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    value: boolean?,
    forgetState: boolean?,
    callback: ((value: boolean) -> ())?,
}

export type SliderProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    range: { number }?, -- { min, max }
    increment: number?,
    value: number?,
    suffix: string?,
    minimal: boolean?, -- track only, no name/value (for dense rows)
    forgetState: boolean?,
    -- dragging is true from the moment the handle is grabbed until it's let go
    callback: ((value: number, dragging: boolean) -> ())?,
}

export type DropdownProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    options: { string }?,
    value: (string | { string })?,
    multiSelect: boolean?,
    placeholder: string?,
    forgetState: boolean?,
    callback: ((value: any) -> ())?,
}

export type InputProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    value: string?,
    placeholder: string?,
    numeric: boolean?,
    clearOnFocus: boolean?,
    forgetState: boolean?,
    callback: ((value: string) -> ())?,
}

export type KeybindProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    value: (EnumItem | string)?, -- an Enum.KeyCode / mouse button, or a KeyCode name
    forgetState: boolean?,
    isMenuToggle: boolean?, -- internal: the settings menu-toggle keybind, clash check runs in reverse
    hold: boolean?, -- fire callback(true) once held, callback(false) on release
    holdThreshold: number?, -- seconds to hold before it counts (default 0.2)
    callback: ((value: EnumItem | boolean) -> ())?, -- bound key on press, or true/false in hold mode
    onChanged: ((key: EnumItem) -> ())?, -- fires when the binding is changed
}

export type ColorPickerProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    flag: string?,
    color: Color3?, -- initial colour (accepts a hex string too)
    alpha: number?, -- initial alpha 0..1 (default 1)
    forgetState: boolean?,
    callback: ((value: Color3, alpha: number) -> ())?,
}

export type StatProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    prefix: string?,
    suffix: string?,
    value: number?,
    display: string?, -- "value" | "change"
    compact: boolean?,
    changeMode: string?, -- "percentage" | "absolute"
    changeBaseline: string?, -- "previous" | "initial"
    numberEasing: boolean?,
}

export type ProgressProps = {
    name: string?,
    description: string?,
    icon: (string | number)?,
    range: { number }?, -- { min, max }, defaulting to { 0, 1 } (or { 0, steps })
    value: number?,
    steps: number?, -- draw the track as this many segments instead of one continuous fill
    text: string?, -- a fixed readout beside the title
    format: ((value: number, min: number, max: number) -> string)?, -- build the readout yourself
    showValue: boolean?, -- false hides the readout entirely (default true)
    indeterminate: boolean?, -- a sweep instead of a value, for work of unknown length
}

export type ConsoleProps = {
    name: string?,
    description: string?,
    text: string?, -- the body
    height: number?, -- how tall the block stands, in pixels (default 120)
    follow: boolean?, -- jump to the newest line on Append, the way a console does
    maxLines: number?, -- how many lines to keep; past this the oldest roll off (default 200)
}

export type NotifyProps = {
    title: string?,
    content: string?,
    icon: (string | number)?,
    duration: number?,
}

export type ToastProps = {
    title: string?,
    subtitle: string?, -- optional second line
    subtitleAbove: boolean?, -- render the subtitle above the title (label-over-value)
    icon: (string | number)?, -- optional; asset id or ready image string (rbxthumb works)
    avatar: number?, -- optional user id; shows that user's headshot as a larger avatar
    minWidth: number?, -- floor the pill width; slack becomes right-hand room (content is left-aligned)
    duration: number?,
    position: "Top" | "Bottom"?,
}

export type PopupBox = {
    title: string?,
    description: string?,
    icon: (string | number)?,
}

export type PopupOption = {
    text: string?,
    style: string?, -- "neutral" (default) | "primary" | "danger"
    callback: (() -> ())?,
}

export type PopupProps = {
    title: string?,
    subtitle: string?,
    icon: (string | number)?,
    content: string?, -- a body paragraph
    boxes: { PopupBox }?, -- a list of cards (the changelog layout)
    options: { PopupOption }?, -- footer buttons; defaults to a single dismiss button
    dismissable: boolean?, -- click the dim or press Escape to close (default true)
}

-- Handles ------------------------------------------------------------------
-- Every element can be reordered within its tab.
export type Moveable = {
    MoveTo: (self: any, index: number) -> (),
    MoveToTop: (self: any) -> (),
    MoveToBottom: (self: any) -> (),
    MoveUp: (self: any) -> (),
    MoveDown: (self: any) -> (),
}

-- Every element you can operate takes a lock: it dims, stops taking input, and its callback
-- wont fire. Display-only elements dont have one.
export type Lockable = {
    Lock: (self: any, reason: string?) -> (),
    Unlock: (self: any) -> (),
    IsLocked: (self: any) -> boolean,
}

export type Button = Moveable & Lockable & {}

export type Toggle = Moveable & Lockable & {
    value: boolean,
    Set: (self: Toggle, value: boolean, skipCallback: boolean?) -> (),
}

export type Slider = Moveable & Lockable & {
    value: number,
    Set: (self: Slider, value: number, skipCallback: boolean?) -> (),
}

export type Dropdown = Moveable & Lockable & {
    value: { string }, -- always stored pruned to the current options, even single-select
    Set: (self: Dropdown, value: string | { string }, skipCallback: boolean?) -> (),
    Refresh: (self: Dropdown, options: { string }) -> (),
    Add: (self: Dropdown, option: string) -> (),
    Remove: (self: Dropdown, option: string) -> (),
}

export type Input = Moveable & Lockable & {
    value: string,
    Set: (self: Input, value: string, skipCallback: boolean?) -> (),
}

export type Keybind = Moveable & Lockable & {
    value: EnumItem,
    Set: (self: Keybind, value: EnumItem | string, skipChanged: boolean?) -> (),
}

export type ColorPicker = Moveable & Lockable & {
    value: Color3,
    alpha: number,
    Set: (self: ColorPicker, value: Color3 | string, skipCallback: boolean?) -> (),
    SetAlpha: (self: ColorPicker, alpha: number, skipCallback: boolean?) -> (),
}

export type Stat = Moveable & {
    value: number,
    Set: (self: Stat, value: number) -> (),
    ResetBaseline: (self: Stat, value: number?) -> (),
}

export type Progress = Moveable & {
    value: number,
    Set: (self: Progress, value: number) -> (),
    Get: (self: Progress) -> number,
    GetPercentage: (self: Progress) -> number, -- where the value sits in its range, 0 to 1
    SetRange: (self: Progress, min: number, max: number) -> (),
    SetText: (self: Progress, text: string?) -> (), -- nothing goes back to the formatter
    SetIndeterminate: (self: Progress, state: boolean) -> (),
    Remove: (self: Progress) -> (),
}

export type Console = Moveable & {
    Set: (self: Console, text: string) -> (),
    Append: (self: Console, line: string) -> (), -- multi-line splits, so the cap still counts
    Clear: (self: Console) -> (),
    Get: (self: Console) -> string,
    Copy: (self: Console) -> boolean, -- false where the executor has no setclipboard
    SetHeight: (self: Console, height: number) -> (),
    Remove: (self: Console) -> (),
}

export type Section = Moveable & {}

-- A heading in the sidebar rail rather than in a tab's element list. Not Moveable: the rail
-- orders itself by the order tabs and sections are created, the way tabs themselves do.
export type TabSection = {
    Remove: (self: TabSection) -> (),
}

export type Text = Moveable & {
    name: string, -- the title
    text: string, -- the body
    Set: (self: Text, text: string) -> (),
    SetTitle: (self: Text, title: string) -> (),
}

export type Divider = Moveable & {
    text: string, -- "" when the rule carries no word
    Set: (self: Divider, text: string?) -> (),
}

-- Tags sit in the window's title bar and order themselves, so they aren't Moveable.
export type Tag = {
    Set: (self: Tag, props: TagProps) -> (),
    SetColor: (self: Tag, color: Color3) -> (),
    SetText: (self: Tag, text: string?) -> (),
    SetIcon: (self: Tag, icon: (string | number)?) -> (),
    Remove: (self: Tag) -> (),
}

export type Popup = {
    Close: (self: Popup) -> (),
}

-- A group lays elements along one axis and nests, so a row of columns builds a grid.
-- A row accepts the compact elements (button/toggle/stat) + slider; a column also takes
-- dropdown, section, text and divider. Input, keybind and colorpicker stay tab-level for now.
export type Group = Moveable & {
    CreateButton: (self: Group, props: ButtonProps) -> Button,
    CreateToggle: (self: Group, props: ToggleProps) -> Toggle,
    CreateSwitch: (self: Group, props: ToggleProps) -> Toggle,
    CreateStat: (self: Group, props: StatProps) -> Stat,
    CreateSlider: (self: Group, props: SliderProps) -> Slider,
    -- nil on a row: only columns take these
    CreateDropdown: (self: Group, props: DropdownProps) -> Dropdown?,
    CreateSection: (self: Group, props: SectionProps) -> Section?,
    CreateText: (self: Group, props: TextProps) -> Text?,
    CreateDivider: (self: Group, props: DividerProps?) -> Divider?,
    CreateGroup: (self: Group, props: GroupProps?) -> Group,
}

export type Tab = {
    Select: (self: Tab, noAnimation: boolean?) -> (),
    Deselect: (self: Tab, noAnimation: boolean?) -> (),
    Remove: (self: Tab) -> (),
    CreateButton: (self: Tab, props: ButtonProps) -> Button,
    CreateToggle: (self: Tab, props: ToggleProps) -> Toggle,
    CreateSwitch: (self: Tab, props: ToggleProps) -> Toggle,
    CreateSlider: (self: Tab, props: SliderProps) -> Slider,
    CreateDropdown: (self: Tab, props: DropdownProps) -> Dropdown,
    CreateInput: (self: Tab, props: InputProps) -> Input,
    CreateKeybind: (self: Tab, props: KeybindProps) -> Keybind,
    CreateColorPicker: (self: Tab, props: ColorPickerProps) -> ColorPicker,
    CreateStat: (self: Tab, props: StatProps) -> Stat,
    CreateProgress: (self: Tab, props: ProgressProps) -> Progress,
    CreateConsole: (self: Tab, props: ConsoleProps) -> Console,
    CreateSection: (self: Tab, props: SectionProps) -> Section,
    CreateText: (self: Tab, props: TextProps) -> Text,
    CreateDivider: (self: Tab, props: DividerProps?) -> Divider,
    CreateGroup: (self: Tab, props: GroupProps?) -> Group,
}

export type Window = {
    unloaded: boolean, -- true once Unload has run; the handle is spent
    -- always-live view of every saved control, keyed by flag; reads give the current value,
    -- writes route through the control's Set
    Flags: { [string]: any },
    CreateTab: (self: Window, props: TabProps) -> Tab,
    -- sidebar layout only; does nothing under the top strip
    CreateSection: (self: Window, props: SectionProps) -> TabSection,
    CreateTag: (self: Window, props: TagProps) -> Tag,
    Notify: (self: Window, props: NotifyProps) -> (),
    Toast: (self: Window, props: ToastProps) -> (),
    Popup: (self: Window, props: PopupProps) -> Popup?, -- nil once the window is unloaded
    Show: (self: Window) -> (),
    Hide: (self: Window) -> (),
    ToggleHide: (self: Window) -> (),
    ToggleMinimise: (self: Window) -> (),
    Navigate: (self: Window, tab: string | Tab) -> (),
    ChangeTheme: (self: Window, theme: Theme) -> (),
    SetLocale: (self: Window, localeId: string) -> (),
    SetTranslator: (self: Window, translator: Translator?) -> (),
    RegisterTranslations: (self: Window, translations: Translations) -> (),
    Save: (self: Window, name: string?) -> boolean,
    Load: (self: Window, name: string?) -> boolean,
    ListConfigs: (self: Window) -> { string },
    DeleteConfig: (self: Window, name: string) -> boolean,
    GetPath: (self: Window) -> (string, string),
    Get: (self: Window, flag: string) -> any,
    Set: (self: Window, flag: string, value: any) -> boolean,
    Unload: (self: Window) -> (),
}

export type Rayfield = {
    CreateWindow: (self: Rayfield, props: WindowProps) -> Window,
}

return {}

end)() end,
    [40] = function()local wax,script,require=ImportGlobals(40)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Haptic feedback. A thin wrapper over HapticEffect that buzzes the player's device
-- (phone, gamepad, VR controller) on two interactions: a press and a notification. We map
-- them to the presets that feel best in practice - the softer UIHover tick for a press, the
-- crisper UIClick for a notification. No-ops on devices without haptics, off from settings.

local variables = require(script.Parent.variables)

local hapticEngine = {}

hapticEngine.enabled = false -- off by default; the settings toggle flips it (see setEnabled)

-- Resolve the presets once. HapticEffect (and its enum) only exist on newer clients, so
-- everything below is gated on this: on an old client `types` stays empty and every call
-- is a no-op. pcall guards the enum lookup too, since indexing a missing value would throw.
type HapticTypes = {
    click: Enum.HapticEffectType?,
    notify: Enum.HapticEffectType?,
}

local types: HapticTypes = {}
local supported, resolvedTypes = pcall(function()
    Instance.new("HapticEffect"):Destroy() -- probe: errors on clients without the class
    return {
        click = Enum.HapticEffectType.UIHover, -- presses use the softer hover tick
        notify = Enum.HapticEffectType.UIClick, -- notifications use the crisper click
    }
end)
if supported then
    types = resolvedTypes
end

-- One reusable effect per preset, made on first use and kept parented for the session.
--
-- These live with the interface, not in the Workspace the docs examples use. Workspace is
-- readable by the game's own scripts, so a pooled effect sitting there is the one piece of
-- Rayfield a game could find by walking the tree - everything else hides behind gethui with
-- a random name. An effect only needs *a* parent to play, not a world one.
local effects: { [Enum.HapticEffectType]: Instance } = {}
local container: Instance? = nil

-- Where new effects get parented. The window hands us its ScreenGui; until then (or after it
-- goes away) fall back to the container every Rayfield gui lives in.
function hapticEngine.setContainer(target: Instance?)
    container = target
end

-- Let go of a gui thats being torn down, without stamping on a container another window may
-- have set since. Passing nil clears whatever is held.
function hapticEngine.releaseContainer(target: Instance?)
    if target == nil or container == target then
        container = nil
    end
end

local function containerFor(): Instance
    if container and container.Parent then
        return container
    end
    return variables.guiContainer
end

local function effectFor(hapticType: Enum.HapticEffectType): Instance?
    local effect = effects[hapticType]
    -- recreate if it was never made, or got destroyed out from under us (Parent goes nil)
    if effect and effect.Parent then
        return effect
    end
    local ok, made = pcall(Instance.new, "HapticEffect")
    if not ok then
        return nil
    end
    local hapticEffect = made :: any
    hapticEffect.Type = hapticType
    local parented = pcall(function()
        made.Parent = containerFor()
    end)
    if not parented then
        made:Destroy()
        return nil
    end
    effects[hapticType] = made
    return made
end

local function play(hapticType: Enum.HapticEffectType?)
    if not hapticType or not hapticEngine.enabled then
        return
    end
    local effect = effectFor(hapticType)
    if effect then
        local hapticEffect = effect :: any
        pcall(hapticEffect.Play, effect)
    end
end

-- tap for a button, switch, tab or any discrete press
function hapticEngine.click()
    play(types.click)
end

-- attention buzz for a notification, toast or popup
function hapticEngine.notify()
    play(types.notify)
end

-- Global on/off for the settings toggle. Turning it off tears the pooled effects down so
-- nothing lingers behind; they're remade lazily if it's turned back on.
function hapticEngine.setEnabled(state: boolean?)
    hapticEngine.enabled = state and true or false
    if not hapticEngine.enabled then
        hapticEngine.teardown()
    end
end

-- Drop the pool without touching the enabled flag, so a window can clean up after itself
-- without deciding haptics for anyone else.
function hapticEngine.teardown()
    for hapticType, effect in effects do
        pcall(effect.Destroy, effect)
        effects[hapticType] = nil
    end
end

return hapticEngine

end)() end,
    [41] = function()local wax,script,require=ImportGlobals(41)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local network = require(script.Parent.network)
local log = require(script.Parent.log)

export type AssetId = number | string
export type AssetDownloadUrl = string
export type CacheKey = AssetId
export type ResolvedAsset = AssetId
export type AssetRequestPayload = {
    Url: string,
    Method: string,
}
local assetResolver = {
    Enum = {
        AssetDownloadUrl = {
            RobloxDownloadUrl = "https://assetdelivery.roblox.com/v1/asset/?id=%d" :: AssetDownloadUrl,
            RoProxyDownloadUrl = "https://assetdelivery.roproxy.com/v1/asset?id=%d" :: AssetDownloadUrl,
        },
    },
}
assetResolver.__index = assetResolver
assetResolver.__type = "assetResolver"
type AssetResolverState = {
    contentCache: { [CacheKey]: string }?,
    contentCacheOrder: { CacheKey }?,
    contentDownloadUrl: AssetDownloadUrl,
    pendingRequests: { [CacheKey]: { thread } },
}
export type AssetResolver = AssetResolverState & {
    resolve: (self: AssetResolver, value: unknown) -> ResolvedAsset?,
    getAssetContentFromUrl: (self: AssetResolver, url: string, cacheKey: CacheKey?, forced: boolean?) -> string?,
    getAssetContentFromId: (self: AssetResolver, id: AssetId, forced: boolean?) -> string?,
}
-- example asset ids:
--[[
rbxassetid://12187277209,
rbxassetid://12187293441
]]

-- bodies are whole pngs and ttfs, and every caller gates on isfile, so a cached body is only ever
-- re-read inside a retry loop. keep the last few for that and evict the oldest, rather than pinning
-- a session's worth of assets in memory for readers that never come back
local contentCacheLimit = 8

function assetResolver.new(useCache: boolean?, assetContentDownloadUrl: AssetDownloadUrl?): AssetResolver
    local contentCache: { [CacheKey]: string }? = if useCache then {} else nil
    local self = setmetatable(
        {
            contentCache = contentCache,
            contentCacheOrder = if useCache then {} :: { CacheKey } else nil,
            contentDownloadUrl = assetContentDownloadUrl or assetResolver.Enum.AssetDownloadUrl.RobloxDownloadUrl,
            pendingRequests = {},
        } :: AssetResolverState,
        assetResolver
    ) :: any
    return self
end

function assetResolver.resolve(_self: AssetResolver, value: unknown): ResolvedAsset?
    if type(value) == "number" then
        return value
    end

    if type(value) ~= "string" then
        return nil
    end

    if string.sub(value, 1, 11) == "rbxasset://" or string.sub(value, 1, 11) == "rbxthumb://" then
        return value
    end

    local id = tonumber(string.match(value, "^rbxassetid://(%d+)$"))
    if id then
        return id
    end

    return nil
end

-- executors disagree on response shape, so trust the body only when whatever status
-- info the executor does give us says the request actually succeeded
local function isGoodResponse(response: unknown): boolean
    if type(response) ~= "table" then
        return false
    end
    local shaped = response :: { Body: unknown, StatusCode: unknown, Success: unknown }
    local body = shaped.Body
    if type(body) ~= "string" or #body == 0 then
        return false
    end
    if type(shaped.StatusCode) == "number" then
        local statusCode = shaped.StatusCode :: number
        return statusCode >= 200 and statusCode < 300
    end
    if type(shaped.Success) == "boolean" then
        return shaped.Success :: boolean
    end
    -- no status of any kind: a shape we dont know, so we cant say the body is the asset
    return false
end

function assetResolver.getAssetContentFromUrl(
    self: AssetResolver,
    url: string,
    cacheKey: CacheKey?,
    forced: boolean?
): string?
    -- forced skips the session cache, so retry loops see fresh responses
    local contentCache = self.contentCache
    if cacheKey ~= nil and contentCache and not forced then
        local cachedContent = contentCache[cacheKey]
        if cachedContent then
            return cachedContent
        end
    end

    -- one download per key at a time; late callers wait on the first request's body
    -- instead of racing their own copy down
    local pendingRequests = self.pendingRequests
    if cacheKey ~= nil then
        local pending = pendingRequests[cacheKey]
        if pending then
            table.insert(pending, coroutine.running())
            return coroutine.yield()
        end
        pendingRequests[cacheKey] = {}
    end

    local content: string? = nil
    local requestFn = network.getRequestFn()
    if not requestFn then
        log.warn("No request function available to download asset content.")
    else
        local success, response = pcall(
            requestFn,
            {
                Url = url,
                Method = "GET",
            } :: AssetRequestPayload
        )
        if success and isGoodResponse(response) then
            local body = (response :: { Body: string }).Body
            content = body
            if cacheKey ~= nil and contentCache then
                local order = self.contentCacheOrder
                if order and contentCache[cacheKey] == nil then
                    table.insert(order, cacheKey)
                    local oldest = if #order > contentCacheLimit then table.remove(order, 1) else nil
                    if oldest ~= nil then
                        contentCache[oldest] = nil
                    end
                end
                contentCache[cacheKey] = body
            end
        elseif not forced then
            log.warn("Failed to download asset content for url: " .. tostring(url))
        end
    end

    -- resume waiters with whatever we got, nil included, and always clear the entry.
    -- plain resume, since not every runtime's task.spawn can take a thread
    if cacheKey ~= nil then
        local waiting = pendingRequests[cacheKey]
        pendingRequests[cacheKey] = nil
        if waiting then
            for _, thread in waiting do
                coroutine.resume(thread, content)
            end
        end
    end
    return content
end

function assetResolver.getAssetContentFromId(self: AssetResolver, id: AssetId, forced: boolean?): string?
    local resolvedId = self:resolve(id)
    -- we can only download content for valid asset ids
    if not resolvedId or type(resolvedId) ~= "number" then
        log.warn("Invalid asset id: " .. tostring(resolvedId))
        return nil
    end

    local downloadUrl = string.format(self.contentDownloadUrl, resolvedId)
    return self:getAssetContentFromUrl(downloadUrl, resolvedId, forced)
end

return assetResolver

end)() end,
    [42] = function()local wax,script,require=ImportGlobals(42)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local colors = {}

-- black or white, whichever reads better on the bg
function colors.contrastColor(color: Color3): Color3
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
    return if luminance > 0.5 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(255, 255, 255)
end

-- Coerce a Color3 to a ColorSequence (pass a ColorSequence through). UIGradient.Color
-- only accepts a sequence, so theme transforms feed colours through this.
function colors.toColorSequence(color: Color3 | ColorSequence): ColorSequence
    return if typeof(color) == "ColorSequence" then color else ColorSequence.new(color)
end

-- Pick near-black or white text for whatever colour it sits on, by perceived luminance.
-- Used for text on a solid fill whose colour comes from the theme (e.g. popup buttons).
function colors.contrastText(color: Color3): Color3
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
    return if luminance > 0.6 then Color3.fromRGB(20, 20, 20) else Color3.fromRGB(255, 255, 255)
end

return colors

end)() end,
    [43] = function()local wax,script,require=ImportGlobals(43)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Shared visual constants. Theme-varying colours/fonts live in themes/; these dont.

local constants = {}

-- brand font asset (themes reference this too)
constants.fontAsset = "rbxassetid://12187365364"

-- the input/keybind fields hug their text, tweening width instead of AutomaticSize so it animates
constants.pillResizeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Every built-in icon Rayfield ships, by name. Single source of truth: secure mode caches
-- exactly these (see utility/image) so the UI never has to fall back to a raw asset id at
-- runtime. Add a new built-in icon here and it's cached automatically.
constants.icons = {
    close = 83277910885129,
    minimise = 108115485663409,
    maximise = 88738500661569,
    settings = 129180860773723,
    search = 100604009889706,
    chevron = 88479147175134,
    check = 125626312718314,
    dot = 91452555903853, -- unselected dropdown option (also the colorpicker "invisible" mark)
    colorpicker = 91452555903853, -- same hollow-box glyph as dot
    banner = 106790631609801,
    config = 125823673784681, -- saved-configurations picker
    rayfield = 106790631609801, -- Slate logo icon
    slate = 106790631609801, -- Slate logo icon
}

-- Accent used by the toggle switch + slider glow when active (Slate Monochrome).
constants.accent = {
    on = Color3.fromRGB(255, 255, 255),
    onStroke = Color3.fromRGB(255, 255, 255),
}

-- Stat card accents per direction (fill drives the card + glow, stroke is the brighter edge).
constants.statAccents = {
    positive = {
        fill = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
        stroke = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
    },
    negative = {
        fill = ColorSequence.new(Color3.fromRGB(120, 120, 120), Color3.fromRGB(80, 80, 80)),
        stroke = ColorSequence.new(Color3.fromRGB(180, 180, 180), Color3.fromRGB(140, 140, 140)),
    },
    neutral = {
        fill = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200)),
        stroke = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220)),
    },
}

-- Named stacking layers for window furniture (assumes Global ZIndexBehavior)
constants.zIndex = {
    -- over an element's own content, so a locked element cant be reached through it
    elementLock = 60,
    elementLockContent = 65,
    bottomFade = 100,
    -- bottom-right notification cards, above the bottom fade + drag so they aren't dimmed or
    -- pierced by them (they land over the window's lower-right corner)
    notification = 1500,
    drag = 1000,
    -- top-centre and bottom-centre toasts float over the whole window
    toast = 2000,
    toastContent = 2001,
    restoreContent = 100001,
    restoreInteract = 100002,
}

-- DisplayOrder for the top-level ScreenGuis (the window vs the loading banner).
constants.displayOrder = {
    window = 99999,
    banner = 100000,
    -- modal popups sit above everything, dim included
    popup = 100001,
}

return constants

end)() end,
    [44] = function()local wax,script,require=ImportGlobals(44)local ImportGlobals return (function(...)-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local enums = {}

-- FromValue with a manual scan fallback for executors whose Enum sandbox lacks it
function enums.itemFromValue(enumType, value)
    local ok, item = pcall(function()
        return enumType:FromValue(value)
    end)
    if ok and item then
        return item
    end

    local itemsOk, items = pcall(function()
        return enumType:GetEnumItems()
    end)
    if not itemsOk then
        return nil
    end

    for _, enumItem in items do
        if enumItem.Value == value then
            return enumItem
        end
    end

    return nil
end

return enums

end)() end,
    [45] = function()local wax,script,require=ImportGlobals(45)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Filesystem Abstraction
-- Uses native executor functions when available, simulates with instances

local services = require(script.Parent.services)
-- local variables = require(script.Parent.variables)

local filesystem = {}

local isStudio = services.getService("RunService"):IsStudio()
-- writefile alone isnt proof of a full file API; every one of these gets called
-- unconditionally somewhere, so a partial set must fall through to no filesystem at all
local hasNativeFS = not isStudio
    and typeof(writefile) == "function"
    and typeof(readfile) == "function"
    and typeof(isfile) == "function"
    and typeof(isfolder) == "function"
    and typeof(makefolder) == "function"
    and typeof(listfiles) == "function"
    and typeof(delfile) == "function"
    and typeof(delfolder) == "function"

if hasNativeFS then
    -- Native executor environment - wrap globals directly

    function filesystem.writefile(path: string, content: string)
        writefile(path, content)
    end

    function filesystem.readfile(path: string): string
        return readfile(path)
    end

    -- appendfile is missing on several executors, so only wrap it when its real;
    -- the shared fallback below covers the rest
    if typeof(appendfile) == "function" then
        function filesystem.appendfile(path: string, content: string)
            appendfile(path, content)
        end
    end

    function filesystem.isfile(path: string): boolean
        return isfile(path)
    end

    function filesystem.delfile(path: string)
        delfile(path)
    end

    function filesystem.listfiles(folder: string): { string }
        return listfiles(folder)
    end

    function filesystem.makefolder(path: string)
        makefolder(path)
    end

    function filesystem.isfolder(path: string): boolean
        return isfolder(path)
    end

    function filesystem.delfolder(path: string)
        delfolder(path)
    end
elseif isStudio then
    -- Studio simulation using Instance hierarchy under ReplicatedStorage.
    -- Files are StringValues, folders are Folders. Glass is glass.

    local root = Instance.new("Folder")
    root.Name = "Filesystem"
    root.Parent = services.getService("ReplicatedStorage")

    local function splitPath(path: string): { string }
        local parts = {}
        for part in string.gmatch(path, "[^/]+") do
            table.insert(parts, part)
        end
        return parts
    end

    local function resolveParent(parts: { string }, createMissing: boolean): Instance?
        local current: Instance = root
        for i = 1, #parts - 1 do
            local child = current:FindFirstChild(parts[i])
            if not child then
                if not createMissing then
                    return nil
                end
                local folder = Instance.new("Folder")
                folder.Name = parts[i]
                folder.Parent = current
                child = folder
            end
            current = child :: Instance
        end
        return current
    end

    local function fileFromInstance(instance: Instance?): StringValue?
        if instance and instance:IsA("StringValue") then
            return instance
        end
        return nil
    end

    function filesystem.writefile(path: string, content: string)
        local parts = splitPath(path)
        assert(#parts > 0, "Invalid path")

        local parent = resolveParent(parts, true)
        assert(parent, "Invalid path")
        local fileName = parts[#parts]

        local existing = parent:FindFirstChild(fileName)
        local existingFile = fileFromInstance(existing)
        if existingFile then
            existingFile.Value = content
        else
            if existing then
                existing:Destroy()
            end
            local file = Instance.new("StringValue")
            file.Name = fileName
            file.Value = content
            file.Parent = parent
        end
    end

    function filesystem.readfile(path: string): string
        local parts = splitPath(path)
        assert(#parts > 0, "Invalid path")

        local parent = resolveParent(parts, false)
        assert(parent, "File not found: " .. path)

        local file = parent:FindFirstChild(parts[#parts])
        local stringFile = fileFromInstance(file)
        assert(stringFile, "File not found: " .. path)

        return stringFile.Value
    end

    function filesystem.isfile(path: string): boolean
        local parts = splitPath(path)
        if #parts == 0 then
            return false
        end

        local parent = resolveParent(parts, false)
        if not parent then
            return false
        end

        return fileFromInstance(parent:FindFirstChild(parts[#parts])) ~= nil
    end

    function filesystem.listfiles(folder: string): { string }
        local parts = splitPath(folder)
        local current: Instance = root

        for _, part in parts do
            local child = current:FindFirstChild(part)
            if not child or not child:IsA("Folder") then
                error("Folder not found: " .. folder)
            end
            current = child
        end

        local results: { string } = {}
        for _, child in current:GetChildren() do
            table.insert(results, folder .. "/" .. child.Name)
        end
        return results
    end

    function filesystem.delfile(path: string)
        local parts = splitPath(path)
        assert(#parts > 0, "Invalid path")

        local parent = resolveParent(parts, false)
        assert(parent, "File not found: " .. path)

        local file = parent:FindFirstChild(parts[#parts])
        local stringFile = fileFromInstance(file)
        assert(stringFile, "File not found: " .. path)

        stringFile:Destroy()
    end

    function filesystem.makefolder(path: string)
        local parts = splitPath(path)
        if #parts == 0 then
            return
        end

        local current: Instance = root
        for _, part in parts do
            local child = current:FindFirstChild(part)
            if not child then
                local folder = Instance.new("Folder")
                folder.Name = part
                folder.Parent = current
                child = folder
            end
            current = child :: Instance
        end
    end

    function filesystem.isfolder(path: string): boolean
        local parts = splitPath(path)
        if #parts == 0 then
            return false
        end

        local current: Instance = root
        for _, part in parts do
            local child = current:FindFirstChild(part)
            if not child or not child:IsA("Folder") then
                return false
            end
            current = child
        end
        return true
    end

    function filesystem.delfolder(path: string)
        local parts = splitPath(path)
        assert(#parts > 0, "Invalid path")

        local parent = resolveParent(parts, false)
        assert(parent, "Folder not found: " .. path)

        local folder = parent:FindFirstChild(parts[#parts])
        assert(folder and folder:IsA("Folder"), "Folder not found: " .. path)

        folder:Destroy()
    end
end

-- append built from read + write, shared by the studio sim and executors without
-- appendfile. creates the file when its missing, same as the native global does
if filesystem.writefile and not filesystem.appendfile then
    function filesystem.appendfile(path: string, content: string)
        local existing = if filesystem.isfile(path) then filesystem.readfile(path) else nil
        filesystem.writefile(path, if existing then existing .. content else content)
    end
end

function filesystem.ensureFolder(path: string)
    if not filesystem.isfolder(path) then
        filesystem.makefolder(path)
    end
end

function filesystem.ensureDir(dir: string)
    local built = ""
    for part in string.gmatch(dir, "[^/]+") do
        built = if built == "" then part else built .. "/" .. part
        if not filesystem.isfolder(built) then
            filesystem.makefolder(built)
        end
    end
end

return filesystem

end)() end,
    [46] = function()local wax,script,require=ImportGlobals(46)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local filesystem = require(script.Parent.filesystem)
local path = require(script.Parent.path)

-- defaults
local DEFAULT_ROOT_PATH = "Slate"

local fileSystemManager = {}
fileSystemManager.__index = fileSystemManager

export type FileSystemManager = {
    root: string,
    assets: string,
    getPath: (self: FileSystemManager, subpath: string?) -> string,
    getAssetsFolder: (self: FileSystemManager, subfolder: string?) -> string,
    getRootFolder: (self: FileSystemManager) -> string,
}

function fileSystemManager.new(name: string?): FileSystemManager
    -- ensure the folder exists
    local root = name or DEFAULT_ROOT_PATH
    local self = setmetatable({
        root = root,
        assets = root .. "/Assets",
    }, fileSystemManager) :: any
    pcall(filesystem.ensureFolder, self.root)
    pcall(filesystem.ensureFolder, self.assets)

    return self
end

function fileSystemManager:getPath(subpath: string?): string
    return path.join(self.root, subpath)
end

function fileSystemManager:getAssetsFolder(subfolder: string?): string
    if subfolder then
        local assetPath = path.join(self.assets, subfolder)
        pcall(filesystem.ensureFolder, assetPath)
        return assetPath
    end
    return self.assets
end

function fileSystemManager:getRootFolder(): string
    return self.root
end

return fileSystemManager

end)() end,
    [47] = function()local wax,script,require=ImportGlobals(47)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local flagNames = {}

local offsetBasis = 2166136261
local prime = 16777619

-- FNV-1a over the raw bytes. Same name, same flag, every session, or saved configs stop reloading.
local function hashName(name: string): number
    local hash = offsetBasis
    for index = 1, #name do
        hash = bit32.bxor(hash, string.byte(name, index))
        -- split the multiply so it never runs out of double precision
        local low = hash % 65536
        local high = (hash - low) / 65536
        hash = (((high * prime) % 65536) * 65536 + low * prime) % 4294967296
    end
    return hash
end

-- Derives a suitable config flag key from element name.
function flagNames.deriveFlagFromName(name: string): string
    local flag = name:gsub("(%S+)", function(w: string): string
        return w:sub(1, 1):upper() .. w:sub(2, -1)
    end):gsub("[^%w]", "")

    -- %w is ASCII only, so a name like "音量" strips down to nothing and the element would
    -- silently skip persistence. Hash the name instead and it keeps a stable key.
    if flag == "" and name ~= "" then
        return string.format("Flag%08x", hashName(name))
    end

    return flag
end

return flagNames

end)() end,
    [48] = function()local wax,script,require=ImportGlobals(48)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local services = require(script.Parent.services)
local httpService = services.getService("HttpService")
local runService = services.getService("RunService")
local fileSystem = require(script.Parent.filesystem)
local assetResolver = require(script.Parent.assetResolver)
local log = require(script.Parent.log)
local path = require(script.Parent.path)

local function jsonEncode(data: unknown): string?
    local success, result = pcall(function()
        return httpService:JSONEncode(data)
    end)
    if success and type(result) == "string" then
        return result
    else
        log.warn("Failed to encode JSON:", result)
        return nil
    end
end

local function jsonDecode(jsonString: string): unknown?
    local success, result = pcall(function()
        return httpService:JSONDecode(jsonString)
    end)
    if success then
        return result
    else
        log.warn("Failed to decode JSON:", result)
        return nil
    end
end

local fontManager = {}
fontManager.__type = "fontManager"

export type FontFace = {
    name: string,
    family: string,
    weight: number,
    style: string,
    assetId: string,
}

export type FontManifest = {
    name: string,
    faces: { FontFace },
}

export type CachedFont = {
    customId: number | string,
    manifest: FontManifest,
    loadedFromDisk: boolean,
    variants: { [string]: Font },
}

export type FontCache = { [number]: CachedFont }

export type FontResolverOptions = {
    fallbackFont: Font?,
    saveToDisk: boolean?,
    skipCache: boolean?,
}

type FontManagerState = {
    _debug: boolean,
    _pendingLoads: { [string]: { thread } },
    rootFolder: string,
    assetResolver: assetResolver.AssetResolver,
    defaultOptions: FontResolverOptions,
    fontCache: FontCache?,
}

export type FontManager = FontManagerState & {
    resolve: (self: FontManager, id: number | string) -> Font?,
    loadFont: (
        self: FontManager,
        id: (number | string)?,
        fontWeight: Enum.FontWeight?,
        fontStyle: Enum.FontStyle?,
        saveToDisk: boolean?,
        skipCache: boolean?
    ) -> Font?,
    getFontFromId: (self: FontManager, id: number | string) -> Font?,
}

export type fontManager = FontManager

-- the manifest comes off the network, so trust nothing about its shape. names feed straight
-- into disk paths, so sanitize them here too. returns nil for anything we cant use.
local function validateManifest(manifest: unknown): FontManifest?
    local candidate = manifest :: any
    if type(candidate) ~= "table" or type(candidate.name) ~= "string" or type(candidate.faces) ~= "table" then
        return nil
    end
    candidate.name = path.sanitizeFile(candidate.name)
    if #candidate.name == 0 or #candidate.faces == 0 then
        return nil
    end
    for _, face in candidate.faces do
        if type(face) ~= "table" or type(face.name) ~= "string" or type(face.assetId) ~= "string" then
            return nil
        end
        face.name = path.sanitizeFile(face.name)
        if #face.name == 0 then
            return nil
        end
    end
    return candidate :: FontManifest
end

-- a face only downloads when its file is missing, so an error page or a truncated body written to
-- disk would shadow the real font every session after. check the signature like we do for pngs
local fontSignatures = { "\0\1\0\0", "OTTO", "true", "ttcf", "wOFF", "wOF2" }

local function isFontBody(body: string): boolean
    for _, signature in fontSignatures do
        if string.sub(body, 1, #signature) == signature then
            return true
        end
    end
    return false
end

local env = getfenv()

local function variantKey(fontWeight: Enum.FontWeight, fontStyle: Enum.FontStyle): string
    return tostring(fontWeight) .. "|" .. tostring(fontStyle)
end

local function resolveId(id: unknown): number?
    if type(id) == "number" then
        return id
    end

    if type(id) == "string" then
        return tonumber(id)
    end

    return nil
end

function fontManager.__index(self: FontManagerState, key: unknown): unknown
    local classMember = (fontManager :: any)[key]
    if classMember ~= nil then
        return classMember
    end

    local resolvedId = resolveId(key)
    if not resolvedId then
        return nil
    end

    local fontCache = self.fontCache
    if fontCache then
        local cached = fontCache[resolvedId]
        if cached then
            local regularKey = variantKey(Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            local regularFont = cached.variants and cached.variants[regularKey]
            if regularFont then
                return regularFont
            end

            for _, font in pairs(cached.variants or {}) do
                return font
            end
        end
    end

    return nil
end

function fontManager.new(
    rootFolder: string,
    useDebug: boolean?,
    useCache: boolean?,
    assetContentDownloadUrl: assetResolver.AssetDownloadUrl?,
    defaultOptions: FontResolverOptions?
): FontManager
    local defaultResolverOptions = defaultOptions
        or {
            saveToDisk = true,
            skipCache = not useCache or false,
            fallbackFont = Font.fromEnum(Enum.Font.SourceSans),
        }
    local self = setmetatable(
        {
            rootFolder = rootFolder,
            fontCache = if useCache then {} :: FontCache else nil,
            assetResolver = assetResolver.new(useCache, assetContentDownloadUrl),
            defaultOptions = defaultResolverOptions,
            _debug = useDebug or runService:IsStudio() or false,
            _pendingLoads = {},
        } :: FontManagerState,
        fontManager
    ) :: any
    -- executors without filesystem support must degrade to the fallback font, not kill the require
    pcall(fileSystem.ensureFolder, rootFolder)
    return self
end

-- the full manifest + face pipeline for one font. slow path only; loadFont wraps it
-- with the session cache and in-flight dedup
local function fetchFont(
    self: FontManager,
    resolvedId: number,
    requestedFontWeight: Enum.FontWeight,
    requestedFontStyle: Enum.FontStyle,
    cacheKey: string
): Font?
    local manifestPath = self.rootFolder .. "/" .. resolvedId .. ".json"
    -- fonts only load through the disk cache; without a file API there is just the fallback
    if typeof(fileSystem.isfile) ~= "function" then
        return self.defaultOptions.fallbackFont
    end
    local possibleFontManifest: string? = nil
    local downloadedManifest = false
    if runService:IsStudio() and self._debug then
        log.warn("Font manifest loading is not supported in Studio. Using default font manifest for testing.")
        possibleFontManifest =
            '{"name":"Inter","faces":[{"name":"Thin","weight":100,"style":"normal","assetId":"rbxassetid://12187277209"},{"name":"Extra Light","weight":200,"style":"normal","assetId":"rbxassetid://12187293441"},{"name":"Light","weight":300,"style":"normal","assetId":"rbxassetid://12187268450"},{"name":"Regular","weight":400,"style":"normal","assetId":"rbxassetid://12187266066"},{"name":"Medium","weight":500,"style":"normal","assetId":"rbxassetid://12187336822"},{"name":"Semi Bold","weight":600,"style":"normal","assetId":"rbxassetid://12187254443"},{"name":"Bold","weight":700,"style":"normal","assetId":"rbxassetid://12187275575"},{"name":"Extra Bold","weight":800,"style":"normal","assetId":"rbxassetid://12187267750"},{"name":"Black","weight":900,"style":"normal","assetId":"rbxassetid://12187359223"}]}'
    elseif fileSystem.isfile(manifestPath) then
        local ok, contents = pcall(fileSystem.readfile, manifestPath)
        possibleFontManifest = ok and contents or nil
    else
        -- written below only once it validates, so a bad body never poisons the cache
        possibleFontManifest = self.assetResolver:getAssetContentFromId(resolvedId, false)
        downloadedManifest = possibleFontManifest ~= nil
    end
    local fontManifest: FontManifest? = nil
    if possibleFontManifest then
        local ok, parsedManifest = pcall(jsonDecode, possibleFontManifest)
        if ok and parsedManifest then
            fontManifest = validateManifest(parsedManifest)
        else
            if self._debug then
                log.warn(
                    "Failed to parse font manifest for font id: "
                        .. tostring(resolvedId)
                        .. ". Error: "
                        .. tostring(parsedManifest)
                )
            end
        end
    else
        return self.defaultOptions.fallbackFont
    end
    if not fontManifest then
        if self._debug then
            log.warn("Font manifest is nil for font id: " .. tostring(resolvedId))
        end
        -- a cached manifest that fails validation would fail forever; drop it
        pcall(fileSystem.delfile, manifestPath)
        return self.defaultOptions.fallbackFont
    end
    if downloadedManifest and possibleFontManifest then
        pcall(fileSystem.writefile, manifestPath, possibleFontManifest)
    end
    local fontDirectory = self.rootFolder .. "/" .. fontManifest.name
    local madeAllFontsLocal = true
    -- create folder for the font
    if not pcall(fileSystem.ensureFolder, fontDirectory) then
        return self.defaultOptions.fallbackFont
    end

    -- iterate over each face, caching each to disk like we do images: a face only downloads once,
    -- later sessions reuse the local file and just re-resolve it
    for i, face in ipairs(fontManifest.faces) do
        local fontFacePath = fontDirectory .. "/" .. face.name:gsub(" ", "-") .. ".ttf"
        -- a crash mid-write leaves a truncated face that shadows the real font forever, so
        -- recheck the signature and let a bad file heal the way the manifest does above
        if fileSystem.isfile(fontFacePath) then
            local readOk, existing = pcall(fileSystem.readfile, fontFacePath)
            if not readOk or type(existing) ~= "string" or not isFontBody(existing) then
                pcall(fileSystem.delfile, fontFacePath)
            end
        end
        if not fileSystem.isfile(fontFacePath) then
            local fontFaceId = self.assetResolver:resolve(face.assetId)
            local fontFaceContent = if fontFaceId ~= nil
                then self.assetResolver:getAssetContentFromId(fontFaceId, false)
                else nil
            if not fontFaceContent or not isFontBody(fontFaceContent) then
                madeAllFontsLocal = false
                if self._debug then
                    log.warn(
                        "Font face content is missing or not a font for font id: "
                            .. tostring(resolvedId)
                            .. ", face: "
                            .. face.name
                    )
                end
                continue
            end
            pcall(fileSystem.writefile, fontFacePath, fontFaceContent)
        end
        local ok, uri = pcall(env.getcustomasset, fontFacePath)
        if ok and type(uri) == "string" then
            fontManifest.faces[i].assetId = uri
            if self._debug then
                log.print("Loaded font face for id: " .. tostring(resolvedId) .. ", face: " .. face.name)
            end
        else
            madeAllFontsLocal = false
            if self._debug then
                log.warn("Failed to load font face for id: " .. tostring(resolvedId) .. ", face: " .. face.name)
            end
        end
    end
    -- every face must be local before we hand the font over; falling back to the remote id
    -- here would fetch the asset this whole flow exists to keep off the wire
    if not madeAllFontsLocal then
        return self.defaultOptions.fallbackFont
    end

    local encodedManifest = jsonEncode(fontManifest)
    if not encodedManifest or not pcall(fileSystem.writefile, fontDirectory .. "/manifest.json", encodedManifest) then
        return self.defaultOptions.fallbackFont
    end
    local manifestOk, fontManifestId = pcall(env.getcustomasset, fontDirectory .. "/manifest.json")
    if not manifestOk or not fontManifestId then
        if self._debug then
            log.warn("Failed to load font manifest for id: " .. tostring(resolvedId))
        end
        return self.defaultOptions.fallbackFont
    end
    -- load the font using the manifest
    local ok, loadedFont = pcall(Font.new, fontManifestId :: any, requestedFontWeight, requestedFontStyle)
    if not ok or not loadedFont then
        if self._debug then
            log.warn("Failed to load font for id: " .. tostring(resolvedId))
        end
        return self.defaultOptions.fallbackFont
    end

    -- write the font manifest to the disk
    local fontCache = self.fontCache
    if fontCache then
        fontCache[resolvedId] = {
            customId = fontManifestId,
            manifest = fontManifest,
            loadedFromDisk = true,
            variants = {
                [cacheKey] = loadedFont,
            },
        }
        if self._debug then
            log.print("Cached font for id: " .. tostring(resolvedId))
        end
    end
    return loadedFont
end

function fontManager.loadFont(
    self: FontManager,
    id: (number | string)?,
    fontWeight: Enum.FontWeight?,
    fontStyle: Enum.FontStyle?,
    saveToDisk: boolean?,
    skipCache: boolean?
): Font?
    if saveToDisk == nil then
        saveToDisk = self.defaultOptions.saveToDisk
    end
    if skipCache == nil then
        skipCache = self.defaultOptions.skipCache
    end
    local requestedFontWeight = fontWeight or Enum.FontWeight.Regular
    local requestedFontStyle = fontStyle or Enum.FontStyle.Normal
    local cacheKey = variantKey(requestedFontWeight, requestedFontStyle)
    local rawId = self.assetResolver:resolve(id)
    local resolvedId = resolveId(rawId)
    if not resolvedId then
        log.warn("Invalid font id: " .. tostring(id))
        return self.defaultOptions.fallbackFont
    end
    -- if the font is already cached, return it
    local fontCache = self.fontCache
    if fontCache and not skipCache then
        local cachedFont = fontCache[resolvedId]
        if cachedFont then
            local cachedVariant = cachedFont.variants and cachedFont.variants[cacheKey]
            if cachedVariant then
                if self._debug then
                    log.print("Loaded font from cache for id: " .. tostring(resolvedId))
                end
                return cachedVariant
            end

            local ok, loadedFont = pcall(Font.new, cachedFont.customId :: any, requestedFontWeight, requestedFontStyle)
            if ok and loadedFont then
                cachedFont.variants = cachedFont.variants or {}
                cachedFont.variants[cacheKey] = loadedFont
                if self._debug then
                    log.print("Loaded font variant from cache for id: " .. tostring(resolvedId))
                end
                return loadedFont
            else
                if self._debug then
                    log.warn("Failed to load font from cache for id: " .. tostring(resolvedId))
                end
                fontCache[resolvedId] = nil
                return self.defaultOptions.fallbackFont
            end
        end
    end

    -- if saveToDisk is false, we cannot load the font from disk, so we return the default font
    if not saveToDisk then
        if self._debug then
            log.warn("Font loading without saving to disk can be detected by Anti-cheats.")
        end

        return self.defaultOptions.fallbackFont
    end

    -- concurrent loads of the same variant share one pipeline instead of downloading twice
    local pendingLoads = self._pendingLoads
    local pendingKey = tostring(resolvedId) .. "|" .. cacheKey
    local waiting = pendingLoads[pendingKey]
    if waiting then
        table.insert(waiting, coroutine.running())
        return coroutine.yield()
    end
    pendingLoads[pendingKey] = {}

    local ok, result = pcall(fetchFont, self, resolvedId, requestedFontWeight, requestedFontStyle, cacheKey)
    local loadedFont = if ok then result else self.defaultOptions.fallbackFont

    -- hand every waiter the same result, and always clear the entry so a failure
    -- doesnt strand later callers. plain resume, since not every runtime's
    -- task.spawn can take a thread
    waiting = pendingLoads[pendingKey]
    pendingLoads[pendingKey] = nil
    if waiting then
        for _, thread in waiting do
            coroutine.resume(thread, loadedFont)
        end
    end
    return loadedFont
end

function fontManager.resolve(self: FontManager, id: number | string): Font?
    local resolvedId = resolveId(id)
    if not resolvedId then
        return nil
    end

    local fontCache = self.fontCache
    if fontCache then
        local cached = fontCache[resolvedId]
        if cached then
            if self._debug then
                log.print("Resolved font for id: " .. tostring(resolvedId))
            end
            for _, font in pairs(cached.variants or {}) do
                return font
            end
        end
    end

    return nil
end

function fontManager.getFontFromId(self: FontManager, id: number | string): Font?
    return self:resolve(id)
end

return fontManager

end)() end,
    [49] = function()local wax,script,require=ImportGlobals(49)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local functions = {}

local textMetrics = require(script.Parent.textMetrics)
local colors = require(script.Parent.colors)
local flags = require(script.Parent.flagNames)

functions.textWidth = textMetrics.textWidth
functions.textHeight = textMetrics.textHeight
functions.deriveFlagFromName = flags.deriveFlagFromName
functions.contrastColor = colors.contrastColor
functions.toColorSequence = colors.toColorSequence
functions.contrastText = colors.contrastText

return functions

end)() end,
    [50] = function()local wax,script,require=ImportGlobals(50)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local imageCache = require(script.Parent.imageCache)
local variables = require(script.Parent.variables)

type AvatarCallback = imageCache.AvatarCallback
type PreloadCallback = imageCache.PreloadCallback

local image = {}

image.rewrites = imageCache.rewrites
image.onBlock = nil :: ((unknown) -> ())?

-- images that resolve blank in secure mode (their icon isnt cached yet) register here, so the real
-- texture can be dropped in once the background download lands instead of leaving a blank. keyed by
-- instance so re-assigning the same icon cant stack up, and weakly so a destroyed one isnt pinned
type PendingProperties = { [string]: boolean }

image.pending = {} :: { [number]: { [Instance]: PendingProperties } }

-- once preload settles nothing else will ever land, so theres nothing left worth tracking
local settled = false

local imageProperties: { [string]: boolean } = {
    Image = true,
    HoverImage = true,
    PressedImage = true,
}

local function idOf(value: unknown): number?
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        return tonumber(string.match(value, "^rbxassetid://(%d+)$"))
    end
    return nil
end

local function blocked(value: unknown): string
    if image.onBlock then
        image.onBlock(value)
    end
    return ""
end

function image.preload(onSettled: PreloadCallback?): (boolean, number)
    settled = false
    return imageCache.preload(function(failed)
        -- everything that cached has already rebound through onCached, and everything else never
        -- will, so drop whats left and stop tracking rather than growing all session
        settled = true
        table.clear(image.pending)
        if onSettled then
            onSettled(failed)
        end
    end)
end

function image.avatar(userId: number, onReady: AvatarCallback?): string
    if not variables.secureMode then
        return `rbxthumb://type=AvatarHeadShot&id={userId}&w=48&h=48`
    end

    return imageCache.avatar(userId, onReady)
end

function image.assign(instance: Instance, property: string, value: unknown)
    local target = instance :: any
    if not imageProperties[property] then
        target[property] = value
        return
    end
    target[property] = image.resolve(value)
    -- in secure mode an un-cached icon resolves blank; remember it so it appears once cached
    if variables.secureMode and not settled then
        local id = idOf(value)
        if id and not image.rewrites[id] then
            local waiting = image.pending[id]
            if not waiting then
                waiting = setmetatable({}, { __mode = "k" }) :: any
                image.pending[id] = waiting
            end
            local properties = waiting[instance]
            if not properties then
                properties = {}
                waiting[instance] = properties
            end
            properties[property] = true
        end
    end
end

-- imageCache calls this when a background icon download lands: drop the real texture into every
-- instance that resolved blank waiting for it
imageCache.onCached = function(id: number)
    local waiting = image.pending[id]
    if not waiting then
        return
    end
    local uri = image.rewrites[id]
    if uri then
        for instance, properties in waiting do
            if instance.Parent then
                local target = instance :: any
                for property in properties do
                    target[property] = uri
                end
            end
        end
    end
    image.pending[id] = nil
end

function image.resolve(value: unknown): string
    if value == nil or value == 0 or value == "" then
        return ""
    end

    if type(value) == "string" then
        if string.sub(value, 1, 11) == "rbxasset://" then
            return value
        end
        if string.sub(value, 1, 11) == "rbxthumb://" then
            return if variables.secureMode then blocked(value) else value
        end
    end

    local id: number? = nil
    if type(value) == "number" then
        id = value
    elseif type(value) == "string" then
        id = tonumber(string.match(value, "^rbxassetid://(%d+)$"))
    end

    local rewrite = if id then image.rewrites[id] else nil
    if rewrite then
        return rewrite
    end

    if variables.secureMode then
        return blocked(value)
    end

    if type(value) == "number" then
        return "rbxassetid://" .. value
    end
    if type(value) == "string" then
        return value
    end

    return blocked(value)
end

return image

end)() end,
    [51] = function()local wax,script,require=ImportGlobals(51)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local filesystem = require(script.Parent.filesystem)
local path = require(script.Parent.path)
local variables = require(script.Parent.variables)
local constants = require(script.Parent.constants)

export type RewriteMap = { [number]: string }
export type CacheSettledCallback = (failed: number) -> ()
export type PreloadCallback = CacheSettledCallback
export type AvatarCallback = (uri: string) -> ()
export type OnCachedCallback = (id: number) -> ()
export type ThumbnailEntry = {
    state: string?,
    imageUrl: string?,
}
export type ThumbnailResponse = {
    data: { ThumbnailEntry }?,
}
local imageCache = {}

local cacheRoot = variables.fileSystemManager:getRootFolder()
local cacheFolder = variables.fileSystemManager:getAssetsFolder()
local assetResolver = variables.assetResolver

-- raw host, not the /blob/ page: that 302s and executors that dont follow redirects
-- would cache the redirect body instead of the png
local assetBase = "https://raw.githubusercontent.com/SiriusSoftwareLtd/rayfield-gen2/main/assets/"
local headshotPx = 48
local thumbEndpoint =
    "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=%dx%d&format=Png&isCircular=false"

local manifest: { [number]: string } = {}
for _, id in constants.icons do
    local iconId = id :: number
    manifest[iconId] = assetBase .. tostring(iconId) .. ".png"
end
local manifestSize = 0
for _ in manifest do
    manifestSize += 1
end

imageCache.rewrites = {} :: RewriteMap
imageCache.onCached = nil :: OnCachedCallback? -- image sets this to rebind blank instances when a background download lands

local pngMagic = "\137PNG\r\n\26\n"

local function cacheFile(filePath: string, url: string): string?
    -- no custom assets or no file API means nothing can be cached at all
    if type(getfenv().getcustomasset) ~= "function" or typeof(filesystem.isfile) ~= "function" then
        return nil
    end
    if not filesystem.isfile(filePath) then
        pcall(filesystem.ensureFolder, cacheRoot)
        pcall(filesystem.ensureFolder, cacheFolder)
        local body = assetResolver:getAssetContentFromUrl(url, filePath, false)
        -- never write a non-png body (error page, redirect html) to disk; a poisoned
        -- cache file would shadow the real asset on every later session
        if not body or string.sub(body, 1, 8) ~= pngMagic then
            return nil
        end
        if not pcall(filesystem.writefile, filePath, body) then
            return nil
        end
    end
    local ok, uri = pcall(getfenv().getcustomasset, filePath)
    return if ok and type(uri) == "string" then uri else nil
end

local function avatarPath(userId: number): string
    return path.join(cacheFolder, "avatar_" .. tostring(userId) .. ".png")
end

local function decodeThumbnailUrl(body: string): string?
    local decodeOk, parsed = pcall(function()
        return variables.httpService:JSONDecode(body)
    end)
    if not decodeOk or type(parsed) ~= "table" then
        return nil
    end

    local data = (parsed :: ThumbnailResponse).data
    if type(data) ~= "table" then
        return nil
    end

    local entry = data[1]
    if type(entry) ~= "table" then
        return nil
    end

    local thumbnail = entry :: ThumbnailEntry
    if thumbnail.state == "Completed" and type(thumbnail.imageUrl) == "string" then
        return thumbnail.imageUrl
    end

    return nil
end

local function fetchAvatar(userId: number): string?
    local cdnUrl: string? = nil
    for attempt = 1, 4 do
        -- retries must bypass the session cache or a cached "Pending" response wins forever
        local body = assetResolver:getAssetContentFromUrl(
            string.format(thumbEndpoint, userId, headshotPx, headshotPx),
            "avatar:" .. tostring(userId),
            attempt > 1
        )
        if body then
            local imageUrl = decodeThumbnailUrl(body)
            if imageUrl then
                cdnUrl = imageUrl
                break
            end
        end
        if attempt < 4 then
            task.wait(0.3)
        end
    end
    if not cdnUrl then
        return nil
    end

    return cacheFile(avatarPath(userId), cdnUrl)
end

-- one fetch pipeline per user, and a miss is remembered for the session so the same
-- broken avatar doesnt re-burn the retry loop on every call
local pendingAvatars: { [number]: { AvatarCallback } } = {}
local failedAvatars: { [number]: boolean } = {}

-- onSettled(failed) fires once every background download has finished, with the count that never
-- cached (a genuine failure), so callers can surface it without spamming per-icon.
function imageCache.preload(onSettled: PreloadCallback?): (boolean, number)
    local env = getfenv()
    if type(env.getcustomasset) ~= "function" or typeof(filesystem.isfile) ~= "function" then
        if onSettled then
            -- defer so a caller that assigns state right after calling preload still sees this
            task.defer(onSettled, manifestSize)
        end
        return false, manifestSize
    end

    local rewrites = imageCache.rewrites
    table.clear(rewrites) -- drop stale entries before remapping (no-op on the fixed built-in manifest)

    local function settle()
        if not onSettled then
            return
        end
        local failed = 0
        for id in manifest do
            if not rewrites[id] then
                failed += 1
            end
        end
        onSettled(failed)
    end

    local pending, missing = 0, 0
    local spawning = true -- keep a synchronously-finishing download from settling mid-loop
    for id, url in manifest do
        local filePath = path.join(cacheFolder, tostring(id) .. ".png")
        local uri: string? = nil
        if filesystem.isfile(filePath) then
            local ok, res = pcall(env.getcustomasset, filePath)
            uri = if ok and type(res) == "string" then res else nil
        end
        if uri then
            -- already on disk from a past session: use it right away
            rewrites[id] = uri
        else
            -- not cached yet: fetch it in the background and swap it in once it lands
            missing += 1
            pending += 1
            task.spawn(function()
                local cached = cacheFile(filePath, url)
                if cached then
                    rewrites[id] = cached
                    if imageCache.onCached then
                        -- a throw in here would strand the counter and settle would never fire
                        pcall(imageCache.onCached, id)
                    end
                end
                pending -= 1
                if pending == 0 and not spawning then
                    settle()
                end
            end)
        end
    end

    spawning = false
    if pending == 0 then
        settle()
    end

    return missing == 0, missing
end

function imageCache.avatar(userId: unknown, onReady: AvatarCallback?): string
    if type(userId) ~= "number" then
        return ""
    end

    -- no file API means no local avatar cache; secure mode just goes without the headshot
    if typeof(filesystem.isfile) ~= "function" then
        return ""
    end

    local filePath = avatarPath(userId)
    if filesystem.isfile(filePath) then
        local ok, uri = pcall(getfenv().getcustomasset, filePath)
        if ok and type(uri) == "string" then
            return uri
        end
    end

    -- this user already failed this session; dont spend another retry loop on them
    if failedAvatars[userId] then
        return ""
    end

    -- a fetch already in flight for this user takes our callback along instead of
    -- racing a duplicate pipeline
    local waiting = pendingAvatars[userId]
    if waiting then
        if onReady then
            table.insert(waiting, onReady)
        end
        return ""
    end

    if onReady then
        pendingAvatars[userId] = { onReady }
        task.spawn(function()
            local uri = fetchAvatar(userId)
            local callbacks = pendingAvatars[userId]
            pendingAvatars[userId] = nil
            if not uri then
                failedAvatars[userId] = true
                return
            end
            if callbacks then
                for _, callback in callbacks do
                    -- one bad callback must not starve the rest
                    pcall(callback, uri)
                end
            end
        end)
    end

    return ""
end

return imageCache

end)() end,
    [52] = function()local wax,script,require=ImportGlobals(52)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Where a window puts its tab selector, and every measurement that follows from it.
-- "top" is the horizontal pill strip under the topbar. "sidebar" is a vertical rail down the
-- left with the content in its own card. Anything that needs one of these numbers reads it
-- from here, so the two layouts cant drift apart in a stray offset somewhere.

local layouts = {}

-- The same bar in both layouts: title and subtitle left, actions right.
local topbarHeight = 64

-- The strip hangs a pixel into the topbar's base, and the content starts a small gap below it.
local tabStripTop = topbarHeight - 1
local tabStripHeight = 38
local tabStripGap = 3

export type Mode = "top" | "sidebar"

export type Layout = {
    mode: Mode,

    -- Everything above the content area. The elements frame is sized (1, -chromeHeight).
    topbarHeight: number,
    chromeHeight: number,

    -- Which way the pages slide as you change tab: across for a strip, up and down for a rail,
    -- so the movement always answers the selector.
    pageDirection: Enum.FillDirection,

    -- Bottom fade over the content: elements dissolve into the window as they scroll out.
    -- fadeCorners nil means the whole shape is rounded; a list rounds only those corners.
    fadeSize: UDim2,
    fadeTransparency: NumberSequence,
    fadeCorners: { string }?,

    -- top only
    tabStripTop: number?,
    tabStripHeight: number?,

    -- sidebar only
    railWidth: number?,
    railCollapsedWidth: number?,
    railCollapseBelow: number?,
    rowHeight: number?,
    rowCornerRadius: number?,
    rowSpacing: number?,
    railPadding: number?,
    rowInset: number?,
    rowPadding: number?,
    rowContentSpacing: number?,
    rowIconSize: number?,
    footerHeight: number?,
    avatarSize: number?,
    cardTransparency: number?,
    cardStrokeRotation: number?,
    cardStrokeTransparency: NumberSequence?,
    cardCorners: { string }?,
}

layouts.top = {
    mode = "top" :: Mode,

    topbarHeight = topbarHeight,
    chromeHeight = tabStripTop + tabStripHeight + tabStripGap,

    tabStripTop = tabStripTop,
    tabStripHeight = tabStripHeight,

    pageDirection = Enum.FillDirection.Horizontal,

    -- the negative scale keeps the fade a touch shorter on a tall window, so it stays a hint
    -- of a fade rather than swallowing the last row
    fadeSize = UDim2.new(1, 0, -0.093, 100),
    fadeTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.4414, 0),
        NumberSequenceKeypoint.new(0.7007, 0.631),
        NumberSequenceKeypoint.new(1, 1),
    }),
} :: Layout

layouts.sidebar = {
    mode = "sidebar" :: Mode,

    topbarHeight = topbarHeight,
    chromeHeight = topbarHeight,

    -- offset, not scale: element rows want a stable width, so a narrower window takes it out
    -- of the rail rather than shaving both sides proportionally.
    railWidth = 219,
    -- under railCollapseBelow the rail drops its titles and becomes an icon rail, which is the
    -- difference between a usable content card and an unusable one on a phone.
    railCollapsedWidth = 64,
    railCollapseBelow = 589,

    rowHeight = 38,
    rowCornerRadius = 14,
    rowSpacing = 4,
    -- clears the selected row's glow, which reaches about this far past its own top edge
    railPadding = 17,
    rowInset = 15,
    rowPadding = 10,
    rowContentSpacing = 6,
    rowIconSize = 20,

    footerHeight = 60,
    avatarSize = 34,

    pageDirection = Enum.FillDirection.Vertical,

    cardTransparency = 0.98,
    cardStrokeRotation = 55,
    -- the card is tucked into the window's bottom-right corner, so it shares that radius and
    -- the one diagonally opposite it. The other two butt against the topbar and the rail.
    cardCorners = { "TopLeftRadius", "BottomRightRadius" },
    cardStrokeTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.128, 0.95),
        NumberSequenceKeypoint.new(0.414, 0.985),
        NumberSequenceKeypoint.new(1, 1),
    }),

    fadeSize = UDim2.new(1, 0, 0, 55),
    fadeTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.377, 0),
        NumberSequenceKeypoint.new(1, 1),
    }),
    -- only the corner it actually sits in; the rail holds the other side
    fadeCorners = { "BottomRightRadius" },
} :: Layout

-- Resolve whatever the dev passed to a layout. An unknown name warns through the caller's
-- fallback rather than here, so this stays a pure lookup.
function layouts.get(mode: unknown): Layout?
    if mode == "sidebar" then
        return layouts.sidebar
    elseif mode == "top" then
        return layouts.top
    end
    return nil
end

-- How wide the rail reads at this window width. Titles need the room to be there; below that
-- they cost more than they give, so the rail keeps the icons and drops them.
function layouts.railWidthFor(layout: Layout, windowWidth: number): number
    if layout.mode ~= "sidebar" then
        return 0
    end
    local full = layout.railWidth :: number
    if windowWidth < (layout.railCollapseBelow :: number) then
        return layout.railCollapsedWidth :: number
    end
    return full
end

return layouts

end)() end,
    [53] = function()local wax,script,require=ImportGlobals(53)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Rayfield's localization core. Two kinds of copy pass through here: the library's own chrome
-- (search placeholder, "Signed in as", the settings page, and so on) and whatever names a dev
-- gives its elements. Both resolve the same way - the dev translator first, then the built-in
-- table for the active locale, then the source string itself - so anything untranslated still
-- reads in plain English instead of a blank or a raw key.
--
-- Only strings wrapped in locale.t() are treated as copy. Element values, slider readouts,
-- keybind keys and hex codes are data, not language, so they're deliberately left alone.

local variables = require(script.Parent.variables)
local log = require(script.Parent.log)

local locale = {}

export type LocaleToken = { [any]: string }
export type Translator = (source: string, localeId: string) -> string?
export type TranslationTables = { [string]: { [string]: string } }

-- English is canonical: every wrapped string in src is written in it, so the source text is
-- also its own lookup key. A new language is just a table keyed by those same source strings;
-- any key it omits falls back to English on its own. Regional tables ("pt-br") win over the
-- bare language ("pt") when both exist.
locale.strings = {} :: TranslationTables
-- ["fr"] = { ["Signed in as"] = "Connecte en tant que", ... },

-- active locale id and the optional dev hook (source, localeId) -> string?. both start neutral,
-- so with no setup at all everything renders in English.
locale.current = "en"
locale.translator = nil :: Translator?

-- a wrapped string carries this tag as a key so Window:Create can tell copy apart from a plain
-- value. property values are always Roblox datatypes or primitives, never plain tables, so the
-- table-with-tag shape is unambiguous.
local tokenTag = {}

local function languageOf(id: string): string
    return string.match(id, "^(%a+)") or id
end

-- Wrap a string so it localizes. Returns the value untouched when there's nothing to translate
-- (non-strings, empty) so callers can wrap unconditionally without special-casing nil names.
function locale.t(source: unknown): unknown
    if type(source) ~= "string" or source == "" then
        return source
    end
    return { [tokenTag] = source }
end

-- True for a value produced by locale.t that still carries a source string.
function locale.isToken(value: unknown): boolean
    return type(value) == "table" and type((value :: { [any]: unknown })[tokenTag]) == "string"
end

function locale.sourceOf(token: LocaleToken): string
    return token[tokenTag]
end

-- Resolve a source string to the active locale: dev translator wins, then an exact-locale table,
-- then the language-only table, then the source itself. The translator is pcall'd so a dev's bad
-- hook can't take the UI down with it.
function locale.resolve(source: unknown): any
    if type(source) ~= "string" then
        return source
    end

    if locale.translator then
        local ok, translated = pcall(locale.translator, source, locale.current)
        if ok and type(translated) == "string" and translated ~= "" then
            return translated
        end
    end

    local exact = locale.strings[locale.current]
    if exact and exact[source] then
        return exact[source]
    end

    local language = locale.strings[languageOf(locale.current)]
    if language and language[source] then
        return language[source]
    end

    return source
end

-- Merge dev-supplied translation tables into the built-in set. Keyed by locale id (lowercased),
-- each a map of source string -> translation. Merges rather than replaces, so repeated calls (or
-- several windows) accumulate instead of clobbering. These sit alongside the library's own tables;
-- a dev translator, if set, still wins over both.
--
-- Entries are checked here rather than trusted: a non-string translation would sail through
-- resolve() into a Text property and only blow up at render, nowhere near the register call.
function locale.register(tables: TranslationTables?)
    if type(tables) ~= "table" then
        return
    end
    for id, entries in tables do
        if type(id) == "string" and type(entries) == "table" then
            id = string.lower(id)
            local target = locale.strings[id]
            if not target then
                target = {}
                locale.strings[id] = target
            end
            for source, translated in entries do
                if type(source) == "string" and type(translated) == "string" then
                    target[source] = translated
                else
                    log.warn(`Rayfield: skipping a '{id}' translation, entries must be string to string.`)
                end
            end
        end
    end
end

-- Point the active locale at `localeId` (lowercased), falling back to English when it isn't a
-- usable string. Setting it alone touches nothing on screen; callers re-resolve their own labels.
function locale.setActive(localeId: string?): string
    locale.current = if type(localeId) == "string" and localeId ~= "" then string.lower(localeId) else "en"
    return locale.current
end

-- The player's language from Roblox's locale id (e.g. "fr-fr"), lowercased and kept whole so a
-- translator sees the exact region. resolve() narrows to the language part when it needs to.
function locale.detect(): string
    local id = variables.localizationService.RobloxLocaleId
    if type(id) == "string" and id ~= "" then
        return string.lower(id)
    end
    return "en"
end

return locale

end)() end,
    [54] = function()local wax,script,require=ImportGlobals(54)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Shared Lock/Unlock for tab elements. Call lockable(Class) once on the prototype.
--
-- A locked element does three things, and it needs all three: it dims so you can see it's out
-- of reach, it stops taking input, and its callback won't fire. The last one is the important
-- one - a lock that only greys the pixels is a lock that other libraries have shipped broken.

local function lockable<T>(class: T): T
    local target = class :: any

    -- Lock it. `reason` is an optional line shown in place of the description while locked.
    function target:Lock(reason: string?)
        self.window:_setElementLocked(self, true, reason)
    end

    function target:Unlock()
        self.window:_setElementLocked(self, false)
    end

    function target:IsLocked(): boolean
        return self.locked == true
    end

    return class
end

return lockable

end)() end,
    [55] = function()local wax,script,require=ImportGlobals(55)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Rayfield's own console output. Silenced under secure mode so the library never announces
-- itself through warn/print, both of which anti-cheats hook. The game's and the dev's own
-- output are left alone; this only gags Rayfield.

local runtime = require(script.Parent.runtime)

local log = {}

type SuppressPredicate = () -> boolean

local function defaultSecureModeSource(): boolean
    return runtime.secureMode
end

local secureModeSource: SuppressPredicate = defaultSecureModeSource
local suppressPredicate: SuppressPredicate? = nil

-- variables.luau points this at its mutable secureMode once it loads; until then the
-- runtime snapshot answers. nil restores the default.
function log.setSecureModeSource(source: SuppressPredicate?)
    secureModeSource = if type(source) == "function" then source else defaultSecureModeSource
end

-- extra gag for embedders (the test runner uses this), layered over secure mode so
-- loading variables never clobbers it. nil clears it.
function log.setSuppressPredicate(predicate: SuppressPredicate?)
    suppressPredicate = if type(predicate) == "function" then predicate else nil
end

local function shouldSuppress(): boolean
    if suppressPredicate and suppressPredicate() then
        return true
    end
    return secureModeSource()
end

function log.warn(...)
    if shouldSuppress() then
        return
    end
    warn(...)
end

function log.print(...)
    if shouldSuppress() then
        return
    end
    print(...)
end

return log

end)() end,
    [56] = function()local wax,script,require=ImportGlobals(56)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Shared Move* methods for tab elements. Call moveable(Class) once on the prototype.

local function moveable<T>(class: T): T
    local target = class :: any

    function target:MoveTo(index: number)
        self.tab:_moveElement(self, index)
    end

    function target:MoveToTop()
        self.tab:_moveElement(self, 1)
    end

    function target:MoveToBottom()
        self.tab:_moveElement(self, #self.tab.elements)
    end

    function target:MoveUp()
        local idx = table.find(self.tab.elements, self)
        if idx then
            self.tab:_moveElement(self, idx - 1)
        end
    end

    function target:MoveDown()
        local idx = table.find(self.tab.elements, self)
        if idx then
            self.tab:_moveElement(self, idx + 1)
        end
    end

    return class
end

return moveable

end)() end,
    [57] = function()local wax,script,require=ImportGlobals(57)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local network = {}
network.__index = network

export type RequestFn = (...any) -> any

-- accepts the environment table from getfenv()
function network.getRequestFn(env: any?): RequestFn?
    env = env or getfenv()
    return env.request
        or env.http_request
        or (env.http and env.http.request)
        or (env.syn and env.syn.request)
        or (env.fluxus and env.fluxus.request)
end

return network

end)() end,
    [58] = function()local wax,script,require=ImportGlobals(58)local ImportGlobals return (function(...)--!nonstrict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Odometer readout: a number as a row of per-digit reels. Each digit is a clipped
-- cell holding a strip of glyphs; changing it tweens the strip so the new digit
-- rolls up from the bottom and the old one leaves the top. Non-digit characters
-- (separators, %, prefix/suffix) are static cells.
--
-- Cells are variable width (each digit's natural advance) so it reads like normal
-- text, not a monospaced counter, and the width tweens with the roll. Reconciles
-- from the right so decimals/suffixes stay put as digits grow on the left. Cells are
-- pooled and reused (hidden, never destroyed) so window:Create owns their cleanup.

local variables = require(script.Parent.variables)
local TextService = variables.textService

local odometer = {}
odometer.__index = odometer

-- Two stacked copies of 0-9. A reel on digit d rests at strip Y = -d*H. Rolling up
-- moves to higher indices; rolling down first jumps to the second copy (same glyph)
-- so it can travel down without running past index 0.
local stripLength = 20

local function measure(font, size, text)
    local params = Instance.new("GetTextBoundsParams")
    params.Text = text
    params.Font = font
    params.Size = size
    params.Width = math.huge
    local ok, bounds = pcall(TextService.GetTextBoundsAsync, TextService, params)
    return if ok then bounds else Vector2.new(size * 0.6, size)
end

-- Digit advances are the same for every odometer of a given font+size, but
-- GetTextBoundsAsync yields, so measure the ten digits once per (font, size) and
-- cache. Later odometers reuse the result and never touch TextService again.
local metricsCache = {}
local function digitMetrics(font, size)
    -- Style is part of the key: italic and normal measure differently
    local key = tostring(font.Family)
        .. "|"
        .. tostring(font.Weight)
        .. "|"
        .. tostring(font.Style)
        .. "|"
        .. tostring(size)
    local cached = metricsCache[key]
    if cached then
        return cached
    end

    local advance, maxWidth = {}, 0
    for d = 0, 9 do
        local w = math.ceil(measure(font, size, tostring(d)).X)
        advance[d] = w
        if w > maxWidth then
            maxWidth = w
        end
    end
    cached = { advance = advance, maxWidth = maxWidth }
    metricsCache[key] = cached
    return cached
end

-- window   : owning Window (for :Create, theming + cleanup)
-- container: Frame the row lives in; the odometer lays its cells out inside it
-- opts     : { textSize, alignment (Enum.HorizontalAlignment), transparency, duration }
function odometer.new(window, container, opts)
    opts = opts or {}
    local self = setmetatable({
        window = window,
        container = container,
        textSize = opts.textSize or 16,
        transparency = opts.transparency or 1, -- current base text transparency
        duration = opts.duration or 0.55,
        slots = {}, -- [indexFromRight] = { reel = reelData?, static = label? }
        length = 0, -- how many slots are currently shown
    }, odometer)

    self.roll = TweenInfo.new(self.duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    -- Cells sit above the container so the digits never get hidden by it under Global
    -- ZIndexBehavior, wherever the container itself is stacked (floored at the old default).
    self.zIndex = math.max(container.ZIndex + 1, 6)

    -- Height tracks the text size (not the taller text-bounds height) so the readout
    -- keeps a plain-label footprint; neighbour digits sit one cell away, outside the clip.
    self.height = math.ceil(self.textSize)

    -- Natural advance per digit (includes side bearings), plus the widest: the
    -- scrolling strip uses the widest so no glyph clips mid-roll, while each clip
    -- cell uses its own digit's advance.
    local metrics = digitMetrics(window.theme.Font, self.textSize)
    self.advance = metrics.advance
    self.maxWidth = metrics.maxWidth

    window:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = opts.alignment or Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),

        Parent = container,
    })

    return self
end

-- Lazily build (or fetch) the reel for a slot: a clipped cell + a fixed-width
-- strip of 20 themed digit labels, centred so the visible glyph sits in the
-- middle of the (variable-width) cell.
function odometer:_reel(index)
    local slot = self.slots[index]
    if slot.reel then
        return slot.reel
    end

    local cell = self.window:Create("Frame", {
        Name = "Reel",
        Size = UDim2.fromOffset(self.maxWidth, self.height),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = self.zIndex,

        Parent = self.container,
    })

    local strip = self.window:Create("Frame", {
        Size = UDim2.fromOffset(self.maxWidth, self.height),
        AnchorPoint = Vector2.new(0.5, 0), -- centred horizontally in the cell
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = self.zIndex,

        Parent = cell,
    })

    for i = 0, stripLength - 1 do
        self.window:Create("TextLabel", {
            Text = tostring(i % 10),
            Position = UDim2.fromOffset(0, i * self.height),
            Size = UDim2.fromOffset(self.maxWidth, self.height),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextSize = self.textSize,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextTransparency = self.transparency,
            ZIndex = self.zIndex,

            Parent = strip,
        }, { TextColor3 = "ContentColor", FontFace = "Font" })
    end

    local reel = { cell = cell, strip = strip, digit = 0, target = 0, stripTween = nil, sizeTween = nil }
    slot.reel = reel
    return reel
end

-- Fetch/build the static (separator/letter) label for a slot. Statics hug their
-- own glyph width so separators/suffixes space naturally.
function odometer:_static(index)
    local slot = self.slots[index]
    if slot.static then
        return slot.static
    end

    local label = self.window:Create("TextLabel", {
        Name = "Static",
        Size = UDim2.fromOffset(0, self.height),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = self.textSize,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTransparency = self.transparency,
        ZIndex = self.zIndex,

        Parent = self.container,
    }, { TextColor3 = "ContentColor", FontFace = "Font" })

    slot.static = label
    return label
end

local function stopReel(reel)
    if reel.stripTween then
        reel.stripTween:Cancel()
        reel.stripTween = nil
    end
    if reel.sizeTween then
        reel.sizeTween:Cancel()
        reel.sizeTween = nil
    end
end

function odometer:_reelSnap(reel, digit)
    stopReel(reel)
    reel.cell.Size = UDim2.fromOffset(self.advance[digit], self.height)
    reel.strip.Position = UDim2.new(0.5, 0, 0, -digit * self.height)
    reel.digit = digit
    reel.target = digit
end

function odometer:_reelRoll(reel, digit, up)
    -- Finalise any in-flight roll so we start from a clean resting digit.
    if reel.stripTween or reel.sizeTween then
        self:_reelSnap(reel, reel.target)
    end

    local a = reel.digit
    if a == digit then
        return
    end

    local startIndex, targetIndex
    if up then
        startIndex = a
        targetIndex = a + (digit - a) % 10 -- 1..9 above, glyph at target = digit
    else
        startIndex = a + 10 -- jump to 2nd copy (same glyph) to travel downward
        targetIndex = startIndex - (a - digit) % 10
    end

    reel.strip.Position = UDim2.new(0.5, 0, 0, -startIndex * self.height)
    reel.target = digit

    -- Roll the strip vertically and reflow the cell to the new digit's width together.
    local stripTween = variables.tweenService:Create(reel.strip, self.roll, {
        Position = UDim2.new(0.5, 0, 0, -targetIndex * self.height),
    })
    local sizeTween = variables.tweenService:Create(reel.cell, self.roll, {
        Size = UDim2.fromOffset(self.advance[digit], self.height),
    })
    reel.stripTween = stripTween
    reel.sizeTween = sizeTween
    stripTween.Completed:Connect(function(state)
        if state == Enum.PlaybackState.Completed and reel.stripTween == stripTween then
            self:_reelSnap(reel, digit)
        end
    end)
    stripTween:Play()
    sizeTween:Play()
    reel.digit = digit
end

-- Show a slot as a digit; hide its static twin. A cell coming back from hidden
-- (the number grew past this column earlier, e.g. 100 -> 99 -> 100) snaps rather
-- than rolling from whatever stale digit it last held.
function odometer:_putDigit(index, digit, up, animate)
    local reel = self:_reel(index)
    local wasHidden = not reel.cell.Visible
    reel.cell.Visible = true
    reel.cell.LayoutOrder = -index
    if self.slots[index].static then
        self.slots[index].static.Visible = false
    end
    if animate and not wasHidden then
        self:_reelRoll(reel, digit, up)
    else
        self:_reelSnap(reel, digit)
    end
end

-- Show a slot as a static char; hide its reel twin.
function odometer:_putStatic(index, char)
    local label = self:_static(index)
    if not label.Visible then
        -- reveal only fades visible statics, so a hidden cell may carry a stale level
        label.TextTransparency = self.transparency
    end
    label.Text = char
    label.Visible = true
    label.LayoutOrder = -index
    if self.slots[index].reel then
        self.slots[index].reel.cell.Visible = false
    end
end

function odometer:_hide(index)
    local slot = self.slots[index]
    if not slot then
        return
    end
    if slot.reel then
        slot.reel.cell.Visible = false
    end
    if slot.static then
        slot.static.Visible = false
    end
end

-- Core: render `text`, animating digit changes when `animate` and rolling in the
-- direction implied by `up` (value increased vs decreased).
function odometer:_render(text, animate, up)
    text = tostring(text)

    -- skip the reconcile when unchanged; snap() runs every drag frame
    if text == self._lastText then
        return
    end
    self._lastText = text

    -- Split into whole UTF-8 characters, not bytes: a suffix like "°" is two
    -- bytes and string.sub would tear it into invalid halves (rendered as tofu).
    local chars = {}
    for _, code in utf8.codes(text) do
        table.insert(chars, utf8.char(code))
    end

    local n = #chars
    for i = 0, math.max(n, self.length) - 1 do
        self.slots[i] = self.slots[i] or {}
        if i < n then
            local char = chars[n - i] -- reconcile from the right
            if char:match("%d") then
                self:_putDigit(i, tonumber(char), up, animate)
            else
                self:_putStatic(i, char)
            end
        else
            self:_hide(i)
        end
    end
    self.length = n
end

-- Roll to `text` (digits animate, direction from `up`).
function odometer:to(text, up)
    self:_render(text, true, up)
end

-- Set `text` instantly (no roll).
function odometer:snap(text)
    self:_render(text, false, true)
end

-- Fade every current label toward `target` transparency, and remember it so
-- lazily-created cells come in at the same level. Mirrors Window:_reveal.
function odometer:reveal(target, animate, info)
    self.transparency = target
    for _, slot in self.slots do
        if slot.static and slot.static.Visible then
            self.window:_reveal(slot.static, { TextTransparency = target }, animate, info)
        end
        if slot.reel then
            for _, lbl in slot.reel.strip:GetChildren() do
                if lbl:IsA("TextLabel") then
                    self.window:_reveal(lbl, { TextTransparency = target }, animate, info)
                end
            end
        end
    end
end

return odometer

end)() end,
    [59] = function()local wax,script,require=ImportGlobals(59)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Shared layout ordering. Tabs and groups both space children by tens so a descriptor can
-- slot in right after its element (order + 1) without colliding with the next one.

type OrderedElement = {
    main: GuiObject,
    descriptor: { main: GuiObject }?,
}

local function assignOrder(element: OrderedElement, order: number)
    element.main.LayoutOrder = order
    if element.descriptor then
        element.descriptor.main.LayoutOrder = order + 1
    end
end

return assignOrder

end)() end,
    [60] = function()local wax,script,require=ImportGlobals(60)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local path = {}

function path.join(basePath: string, childPath: string?): string
    if not childPath or childPath == "" then
        return basePath
    end

    return basePath .. "/" .. childPath
end

-- Removing a character can expose a fresh "..", so every sanitizer drops the illegal
-- characters first and only then walks the dots out, repeating until nothing changes.
-- ".:./.:./x" is the case that motivates it: the dots are inert until the colons go.
local function stripTraversal(text: string): string
    local previous
    repeat
        previous = text
        text = text:gsub("%.%.", "")
    until text == previous
    return text
end

-- strips drive letters and leading slashes too, so a folder name can never escape the
-- executors workspace on its own
function path.sanitizeFolder(value: unknown): string
    local text = tostring(value):gsub("\\", "/"):gsub('[:<>"|?*%c]', "")
    text = stripTraversal(text):gsub("/+", "/")
    return (text:gsub("^/+", ""))
end

-- also drops the characters Windows refuses in filenames, so a window named
-- "MyHub: S3" still writes instead of failing on every save
function path.sanitizeFile(value: unknown): string
    local text = tostring(value):gsub("[/\\]", ""):gsub('[:<>"|?*%c]', "")
    return stripTraversal(text)
end

function path.basename(value: unknown): string
    return tostring(value):match("[^/\\]+$") or tostring(value)
end

function path.stripExtension(value: unknown, extension: string?): string
    if extension and extension ~= "" then
        local text = tostring(value)
        if text:sub(-#extension) == extension then
            return text:sub(1, -#extension - 1)
        end
        return text
    end

    local base = tostring(value):match("^(.+)%.%w+$")
    return base or tostring(value)
end

return path

end)() end,
    [61] = function()local wax,script,require=ImportGlobals(61)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local persistence = {}

local config = require(script.Parent.persistenceConfig)
local settings = require(script.Parent.persistenceSettings)

persistence.getPath = config.getPath
persistence.save = config.save
persistence.load = config.load
persistence.applyTo = config.applyTo
persistence.list = config.list
persistence.delete = config.delete
persistence.getSettingsPath = settings.getSettingsPath
persistence.saveSettings = settings.saveSettings
persistence.loadSettings = settings.loadSettings

return persistence

end)() end,
    [62] = function()local wax,script,require=ImportGlobals(62)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.variables)
local filesystem = require(script.Parent.filesystem)
local log = require(script.Parent.log)
local path = require(script.Parent.path)
local paths = require(script.Parent.persistencePaths)
local atomic = require(script.Parent.persistenceWrite)

local persistenceConfig = {}

type PersistedControl = {
    value: unknown,
    flag: string?,
    _canBeNil: boolean?,
    _serialize: ((PersistedControl) -> unknown)?,
    _deserialize: ((PersistedControl, unknown) -> ())?,
    Set: (PersistedControl, unknown) -> (),
}

type ConfigWindow = {
    controls: { [string]: PersistedControl },
    configuration: {
        fileName: string?,
        customFolder: string?,
    },
    name: string,
    _loading: boolean?,
    _loadedConfig: { [string]: unknown }?,
    _loadedConfigPath: string?,
}

function persistenceConfig.getPath(window: ConfigWindow, name: unknown?): (string?, string?)
    return paths.getConfigPath(window, name)
end

function persistenceConfig.save(window: ConfigWindow, name: unknown?): boolean
    local dir, fullPath = persistenceConfig.getPath(window, name)
    if not dir or not fullPath then
        log.warn("Rayfield: configuration name '" .. tostring(name) .. "' has no usable characters")
        return false
    end

    -- no file API on this executor: nowhere to save, degrade as quietly as load does
    if typeof(filesystem.writefile) ~= "function" then
        return false
    end

    local flags: { [string]: unknown } = {}
    for flag, control in window.controls do
        local ok, value = pcall(function()
            local serialize = control._serialize
            if serialize then
                return serialize(control)
            end
            return control.value
        end)
        if ok then
            flags[flag] = value
        else
            log.warn("Rayfield: Failed to serialize flag '" .. tostring(flag) .. "' - " .. tostring(value))
        end
    end

    -- carry forward saved values whose elements aren't built yet; without this an early
    -- autosave would permanently drop a late element's saved value. only into the file they
    -- came from though, or Load("A") then Save("B") would smuggle A's flags into B.
    local loadedConfig = window._loadedConfig
    if loadedConfig and window._loadedConfigPath == fullPath then
        for flag, value in loadedConfig do
            if window.controls[flag] == nil then
                flags[flag] = value
            end
        end
    end

    local encodeSuccess, encoded = pcall(variables.httpService.JSONEncode, variables.httpService, flags)
    if not encodeSuccess then
        log.warn("Rayfield: Failed to encode configuration - " .. tostring(encoded))
        return false
    end

    local ok, err = pcall(function()
        atomic.write(dir, fullPath, encoded)
    end)

    if not ok then
        log.warn("Rayfield: Failed to save configuration - " .. tostring(err))
        return false
    end

    -- the file we just wrote is now the truth, so later carry-forwards use current values,
    -- not the ones from load time; without this an element torn down after a change would
    -- have its old value written back by the next autosave
    if window._loadedConfigPath == nil or window._loadedConfigPath == fullPath then
        window._loadedConfig = flags
        window._loadedConfigPath = fullPath
    end

    return true
end

-- Decode a saved config. Also hands back the raw text, so a file that read fine but isn't a
-- config can be backed up.
local function decodeFile(fullPath: string): ({ [string]: unknown }?, string?)
    if not filesystem.isfile(fullPath) then
        return nil, nil
    end

    local readOk, contents = pcall(filesystem.readfile, fullPath)
    if not readOk or type(contents) ~= "string" then
        log.warn("Rayfield: Failed to read configuration file")
        return nil, nil
    end

    local decodeOk, parsed = pcall(variables.httpService.JSONDecode, variables.httpService, contents)

    -- a scalar root is valid JSON but not a config, so it resets like any other bad file
    if not decodeOk or type(parsed) ~= "table" then
        return nil, contents
    end

    return parsed :: { [string]: unknown }, contents
end

-- Every corrupt file gets its own backup. Reusing one name would let a second corruption
-- destroy the salvageable data the first backup exists to keep.
local function backupPathFor(fullPath: string): string
    -- same path logic as getConfigPath, so the backup lands next to the file it mirrors
    local stem = path.stripExtension(fullPath, ".rfld")
    local candidate = stem .. " (Incorrect Format).rfld"
    local index = 2
    while index <= 100 and filesystem.isfile(candidate) do
        candidate = stem .. " (Incorrect Format " .. index .. ").rfld"
        index += 1
    end
    return candidate
end

function persistenceConfig.load(window: ConfigWindow, name: unknown?): boolean
    local dir, fullPath = persistenceConfig.getPath(window, name)
    if not dir or not fullPath then
        log.warn("Rayfield: configuration name '" .. tostring(name) .. "' has no usable characters")
        return false
    end

    -- no file API on this executor: nothing to load, degrade quietly
    if typeof(filesystem.isfile) ~= "function" then
        return false
    end

    local parsedFlags, raw = decodeFile(fullPath)

    -- a save that died mid-overwrite leaves its whole copy parked beside the wreck, so take
    -- that instead. only when the real file is really there, or a deleted config could come back.
    if not parsedFlags and filesystem.isfile(fullPath) then
        local parked, parkedRaw = decodeFile(atomic.tempPathFor(fullPath))
        if parked and parkedRaw then
            parsedFlags = parked
            -- put it back where it belongs so the next load reads it straight
            pcall(atomic.write, dir, fullPath, parkedRaw)
        end
    end

    if not parsedFlags then
        if raw then
            log.warn("Rayfield: Configuration file has an invalid format, backing up and resetting")
            local backupPath = backupPathFor(fullPath)
            pcall(function()
                filesystem.ensureDir(dir)
                filesystem.writefile(backupPath, raw)
                filesystem.delfile(fullPath)
            end)
        end
        return false
    end

    local flags = parsedFlags :: { [string]: unknown }
    local wasLoading = window._loading
    window._loading = true
    -- the reset must survive a throwing restore, or autosave stays suppressed all session
    local applyOk, applyErr = pcall(function()
        for flag, control in window.controls do
            persistenceConfig.applyTo(control, flags[flag])
        end
    end)
    -- back to what it was, not just down: a nested load from a control callback must leave
    -- the outer load's guard standing
    window._loading = wasLoading
    if not applyOk then
        log.warn("Rayfield: Failed to apply configuration - " .. tostring(applyErr))
    end

    -- kept so elements built after this load can still restore themselves (see
    -- Window:_restoreLate). without it a late element shows its default and the next
    -- autosave writes that default over the saved value.
    window._loadedConfig = flags
    window._loadedConfigPath = fullPath

    return true
end

-- restore one control from a decoded config. callers own the window._loading guard.
function persistenceConfig.applyTo(control: PersistedControl, value: unknown)
    if value == nil and not control._canBeNil then
        return
    end
    local ok, err = pcall(function()
        local deserialize = control._deserialize
        if deserialize then
            deserialize(control, value)
        else
            control:Set(value)
        end
    end)
    if not ok then
        log.warn("Rayfield: Failed to restore flag '" .. tostring(control.flag) .. "' - " .. tostring(err))
    end
end

function persistenceConfig.list(window: ConfigWindow): { string }
    local dir = persistenceConfig.getPath(window)

    local names: { string } = {}
    -- the no-name path always resolves; the guard just narrows the type
    if not dir then
        return names
    end
    local ok, files = pcall(filesystem.listfiles, dir)
    if not ok or type(files) ~= "table" then
        return names
    end

    for _, filePath in files do
        local file = path.basename(filePath)
        -- listfiles returns folders and anything else in the dir; only our own configs are
        -- real names, so require the extension rather than listing whatever is lying around
        if file:sub(-5) == ".rfld" then
            local base = path.stripExtension(file, ".rfld")
            if base and base ~= "" and not base:find(" %(Incorrect Format[^%)]*%)$") then
                table.insert(names, base)
            end
        end
    end

    table.sort(names)
    return names
end

function persistenceConfig.delete(window: ConfigWindow, name: unknown): boolean
    if type(name) ~= "string" or name == "" then
        return false
    end

    local _, fullPath = persistenceConfig.getPath(window, name)
    if not fullPath then
        return false
    end
    if typeof(filesystem.isfile) ~= "function" or not filesystem.isfile(fullPath) then
        return false
    end

    -- take the parked copy with it, or a later load could resurrect what was just deleted
    pcall(filesystem.delfile, atomic.tempPathFor(fullPath))

    return (pcall(filesystem.delfile, fullPath))
end

return persistenceConfig

end)() end,
    [63] = function()local wax,script,require=ImportGlobals(63)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.variables)
local path = require(script.Parent.path)

local paths = {}

type ConfigWindow = {
    configuration: {
        fileName: string?,
        customFolder: string?,
    },
    name: string,
}

function paths.getConfigPath(window: ConfigWindow, name: unknown?): (string?, string?)
    local dir = variables.fileSystemManager:getPath("Configurations")
    if window.configuration.customFolder then
        dir = path.join(dir, path.sanitizeFolder(window.configuration.customFolder))
    end
    if name ~= nil then
        -- an explicit name that sanitizes away must fail here, not quietly
        -- target the window's default file
        local safe = path.sanitizeFile(name)
        if safe == "" then
            return nil, nil
        end
        return dir, path.join(dir, safe .. ".rfld")
    end
    local safe = path.sanitizeFile(window.configuration.fileName or window.name)
    if safe == "" then
        safe = path.sanitizeFile(window.name)
    end
    if safe == "" then
        safe = "Configuration"
    end
    return dir, path.join(dir, safe .. ".rfld")
end

function paths.getSettingsPath(): (string, string)
    local dir = variables.fileSystemManager:getPath("Settings")
    return dir, path.join(dir, "rayfield.rfld")
end

return paths

end)() end,
    [64] = function()local wax,script,require=ImportGlobals(64)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.variables)
local filesystem = require(script.Parent.filesystem)
local paths = require(script.Parent.persistencePaths)
local atomic = require(script.Parent.persistenceWrite)
local enums = require(script.Parent.enums)

local persistenceSettings = {}

type SettingsWindow = {
    settings: {
        toggleKeybind: EnumItem,
        mouseOverride: boolean,
        keepOnScreen: boolean,
        welcomeToast: boolean,
        haptics: boolean,
        showProfile: boolean,
    },
}

type DecodedSettings = {
    toggleKeybind: { [number]: unknown }?,
    mouseOverride: unknown?,
    keepOnScreen: unknown?,
    welcomeToast: unknown?,
    haptics: unknown?,
    showProfile: unknown?,
}

function persistenceSettings.getSettingsPath(): (string, string)
    return paths.getSettingsPath()
end

function persistenceSettings.saveSettings(window: SettingsWindow): boolean
    local dir, fullPath = persistenceSettings.getSettingsPath()

    local data: { [string]: unknown } = {
        toggleKeybind = {
            tostring(window.settings.toggleKeybind.EnumType),
            window.settings.toggleKeybind.Value,
        } :: { unknown },
        mouseOverride = window.settings.mouseOverride,
        keepOnScreen = window.settings.keepOnScreen,
        welcomeToast = window.settings.welcomeToast,
        haptics = window.settings.haptics,
        showProfile = window.settings.showProfile,
    }

    local ok, encoded = pcall(variables.httpService.JSONEncode, variables.httpService, data)
    if not ok then
        return false
    end

    local writeOk = pcall(atomic.write, dir, fullPath, encoded)

    if not writeOk then
        return false
    end

    return true
end

-- Decode the settings file. Also hands back the raw text, so a parked copy can be put back.
local function decodeFile(fullPath: string): (DecodedSettings?, string?)
    local fileExists = false
    pcall(function()
        fileExists = filesystem.isfile(fullPath)
    end)
    if not fileExists then
        return nil, nil
    end

    local readOk, contents = pcall(filesystem.readfile, fullPath)
    if not readOk or type(contents) ~= "string" then
        return nil, nil
    end

    local decodeOk, parsed = pcall(variables.httpService.JSONDecode, variables.httpService, contents)
    -- JSONDecode happily returns scalars; a corrupt file must not brick CreateWindow
    if not decodeOk or type(parsed) ~= "table" then
        return nil, contents
    end

    return parsed :: DecodedSettings, contents
end

function persistenceSettings.loadSettings(window: SettingsWindow): boolean
    local dir, fullPath = persistenceSettings.getSettingsPath()

    local settings = decodeFile(fullPath)

    -- a save that died mid-overwrite leaves its whole copy parked beside the wreck, so take that
    if not settings then
        local parked, parkedRaw = decodeFile(atomic.tempPathFor(fullPath))
        if parked and parkedRaw then
            settings = parked
            -- put it back where it belongs so the next load reads it straight
            pcall(atomic.write, dir, fullPath, parkedRaw)
        end
    end

    if not settings then
        return false
    end

    if settings.toggleKeybind then
        pcall(function()
            local enumName = tostring(settings.toggleKeybind[1]):gsub("^Enum%.", "")
            local enumType = (Enum :: any)[enumName]
            if enumType then
                local enumItem = enums.itemFromValue(enumType, settings.toggleKeybind[2])
                if enumItem then
                    window.settings.toggleKeybind = enumItem
                end
            end
        end)
    end

    if type(settings.mouseOverride) == "boolean" then
        window.settings.mouseOverride = settings.mouseOverride
    end

    if type(settings.keepOnScreen) == "boolean" then
        window.settings.keepOnScreen = settings.keepOnScreen
    end

    if type(settings.welcomeToast) == "boolean" then
        window.settings.welcomeToast = settings.welcomeToast
    end

    if type(settings.haptics) == "boolean" then
        window.settings.haptics = settings.haptics
    end

    if type(settings.showProfile) == "boolean" then
        window.settings.showProfile = settings.showProfile
    end

    return true
end

return persistenceSettings

end)() end,
    [65] = function()local wax,script,require=ImportGlobals(65)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Crash-safe writes for the persistence layer.

local filesystem = require(script.Parent.filesystem)

local persistenceWrite = {}

local parkedExtension = ".saving"

-- Where a save parks its new copy while it works.
function persistenceWrite.tempPathFor(fullPath: string): string
    return fullPath .. parkedExtension
end

-- Executors give us no rename, so this is the next best thing: park a whole copy beside the
-- real file, read it back, then overwrite. Die mid-overwrite and the parked copy is still
-- intact for the next load to pick up. Throws on failure, callers pcall.
function persistenceWrite.write(dir: string, fullPath: string, contents: string)
    local tempPath = persistenceWrite.tempPathFor(fullPath)

    filesystem.ensureDir(dir)
    filesystem.writefile(tempPath, contents)

    -- a short read back means the disk is full or gone. stop here rather than shred the real file
    if filesystem.readfile(tempPath) ~= contents then
        error("parked copy did not write cleanly")
    end

    filesystem.writefile(fullPath, contents)
    pcall(filesystem.delfile, tempPath)
end

return persistenceWrite

end)() end,
    [66] = function()local wax,script,require=ImportGlobals(66)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local services = require(script.Parent.services)

export type RuntimeState = {
    secureMode: boolean,
    coreGui: CoreGui,
    workspace: Workspace,
    runService: RunService,
    userInputService: UserInputService,
    guiService: GuiService,
    localPlayer: Player?,
    tweenService: TweenService,
    httpService: HttpService,
    textService: TextService,
    replicatedStorage: ReplicatedStorage,
    localizationService: LocalizationService,
    guiContainer: Instance,
}

local runtime = {} :: RuntimeState

runtime.secureMode = (function()
    -- getgenv lives in the executor's script environment, not _G, same as gethui below
    if typeof(getgenv) ~= "function" then
        return false
    end
    local ok, val = pcall(function()
        return getgenv().RAYFIELD_SECURE
    end)
    return ok and val == true
end)()

runtime.coreGui = services.getService("CoreGui") :: CoreGui
runtime.workspace = services.getService("Workspace") :: Workspace -- read for CurrentCamera
runtime.runService = services.getService("RunService") :: RunService
runtime.userInputService = services.getService("UserInputService") :: UserInputService
runtime.guiService = services.getService("GuiService") :: GuiService
runtime.localPlayer = (services.getService("Players") :: Players).LocalPlayer
runtime.tweenService = services.getService("TweenService") :: TweenService
runtime.httpService = services.getService("HttpService") :: HttpService
runtime.textService = services.getService("TextService") :: TextService
runtime.replicatedStorage = services.getService("ReplicatedStorage") :: ReplicatedStorage
runtime.localizationService = services.getService("LocalizationService") :: LocalizationService
-- a gethui stub that returns nil would parent every ScreenGui nowhere, so fall back to CoreGui
runtime.guiContainer = (function(): Instance
    if runtime.runService:IsStudio() then
        -- Run mode and the command bar have no LocalPlayer, so land in CoreGui instead
        local player = runtime.localPlayer
        if player then
            return player.PlayerGui
        end
        return runtime.coreGui
    end
    if typeof(gethui) == "function" then
        local ok, container = pcall(gethui)
        if ok and container then
            return container
        end
    end
    return runtime.coreGui
end)()

return runtime

end)() end,
    [67] = function()local wax,script,require=ImportGlobals(67)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local services = {}

function services.getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

return services

end)() end,
    [68] = function()local wax,script,require=ImportGlobals(68)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local variables = require(script.Parent.variables)
local textService = variables.textService

local textMetrics = {}

-- Width (px) a string renders at for a given font+size, cached since GetTextBoundsAsync
-- yields. Elements use this to report how much room they need before they'd overlap,
-- so a horizontal group can decide how many fit per row.
local widthCache: { [string]: number } = {}
local widthCacheCount = 0
local widthCacheCap = 1024 -- dynamic labels (a live stat) would otherwise grow this forever

local function getTextBounds(params: GetTextBoundsParams): unknown
    local ok, bounds = pcall(function()
        return textService:GetTextBoundsAsync(params)
    end)
    return if ok then bounds else nil
end

local function boundAxis(bounds: unknown, axis: "X" | "Y"): number?
    if typeof(bounds) == "Vector2" then
        return if axis == "X" then bounds.X else bounds.Y
    end
    if type(bounds) == "table" and type((bounds :: any)[axis]) == "number" then
        return (bounds :: any)[axis]
    end
    return nil
end

function textMetrics.textWidth(font: Font, size: number, text: any): number
    text = tostring(text)
    -- Style is part of the key: italic and normal measure differently
    local key = tostring(font.Family)
        .. "|"
        .. tostring(font.Weight)
        .. "|"
        .. tostring(font.Style)
        .. "|"
        .. tostring(size)
        .. "|"
        .. text
    local cached = widthCache[key]
    if cached then
        return cached
    end

    local params = Instance.new("GetTextBoundsParams")
    params.Text = text
    params.Font = font
    params.Size = size
    params.Width = math.huge

    local measuredWidth = boundAxis(getTextBounds(params), "X")
    if not measuredWidth then
        -- rough fallback for this call only. never cached, so a transient failure doesnt
        -- lock in a wrong width for the string forever. count characters, not bytes, or
        -- anything non-ascii measures far too wide. utf8.len is nil on malformed input.
        local length = utf8.len(text) or #text
        return math.ceil(size * 0.55 * length)
    end

    local width = math.ceil(measuredWidth)
    if widthCacheCount >= widthCacheCap then
        widthCache = {}
        widthCacheCount = 0
    end
    widthCache[key] = width
    widthCacheCount += 1
    return width
end

-- Height (px) wrapped text needs at a fixed width. The vertical counterpart to textWidth,
-- used by notifications to size their card. Not cached: notification copy is one-shot.
function textMetrics.textHeight(font: Font, size: number, text: any, width: number): number
    local params = Instance.new("GetTextBoundsParams")
    params.Text = tostring(text)
    params.Font = font
    params.Size = size
    params.Width = width

    local measuredHeight = boundAxis(getTextBounds(params), "Y")
    return if measuredHeight then math.ceil(measuredHeight) else size
end

return textMetrics

end)() end,
    [69] = function()local wax,script,require=ImportGlobals(69)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local runtime = require(script.Parent.runtime)
local constants = require(script.Parent.constants)
local log = require(script.Parent.log)
local fileSystemManager = require(script.Parent.filesystemManager)
local assetResolver = require(script.Parent.assetResolver)
local fontManager = require(script.Parent.fontManager)

type RuntimeState = runtime.RuntimeState
type FileSystemManager = fileSystemManager.FileSystemManager
type AssetResolver = assetResolver.AssetResolver
type FontManager = fontManager.FontManager

export type VariablesState = RuntimeState & {
    fallbackFont: Font,
    fileSystemManager: FileSystemManager,
    assetResolver: AssetResolver,
    fontManager: FontManager,
    setFallbackFont: (font: Enum.Font | Font) -> (),
    brandFont: (weight: Enum.FontWeight?) -> Font,
}

local variables = table.clone(runtime) :: VariablesState
log.setSecureModeSource(function()
    return variables.secureMode
end)

-- built-in stand-in shown in secure mode until the real brand faces download. a dev can override
-- it per window with the FallbackFont prop (see setFallbackFont); defaults to BuilderSans.
variables.fallbackFont = Font.fromEnum(Enum.Font.BuilderSans)

variables.fileSystemManager = fileSystemManager.new()
variables.assetResolver =
    assetResolver.new(true, assetResolver.Enum.AssetDownloadUrl.RoProxyDownloadUrl) :: AssetResolver
variables.fontManager = fontManager.new(
    variables.fileSystemManager:getAssetsFolder("fonts"),
    false,
    true,
    assetResolver.Enum.AssetDownloadUrl.RoProxyDownloadUrl,
    {
        saveToDisk = true,
        skipCache = false,
        fallbackFont = variables.fallbackFont,
    }
) :: FontManager

-- let a dev pick the stand-in font, as an Enum.Font or a ready Font. keeps the font managers
-- own fallback in step so the swap check in init still lines up.
function variables.setFallbackFont(font: Enum.Font | Font)
    if typeof(font) == "EnumItem" then
        font = Font.fromEnum(font)
    end
    if typeof(font) == "Font" then
        variables.fallbackFont = font
        variables.fontManager.defaultOptions.fallbackFont = font
    end
end

-- brand font at a weight, non-blocking. normal mode streams the family id direct; secure mode
-- shows the fallback until the real faces download and swap in (see init).
function variables.brandFont(weight: Enum.FontWeight?): Font
    if variables.secureMode then
        return Font.new(variables.fallbackFont.Family, weight)
    end
    return Font.new(constants.fontAsset, weight)
end

return variables

end)() end,
    [70] = function()local wax,script,require=ImportGlobals(70)local ImportGlobals return (function(...)--!strict

-- Copyright (c) 2026 Corridon Capital
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- Picks the window size for a given screen. Each layout has its own ideal shape and its own
-- idea of which axis matters: the top-tab window is portrait and defends its height, the
-- sidebar window is landscape and defends its width. Anything roomy keeps the ideal untouched.

local layouts = require(script.Parent.layouts)

local windowSizing = {}

export type Profile = {
    -- The size we ship on a roomy screen, and the smallest we'll shrink to on a tiny one. The
    -- minimum is a floor, not a guarantee: a screen too small to hold it gets a window that
    -- fits instead.
    defaultSize: Vector2,
    minSize: Vector2,

    -- Most of the screen we'll ever take, per axis, plus a pixel floor so a huge display still
    -- gets a margin. Fractions rather than a flat inset: a fixed margin only ever bites on the
    -- small screens least able to afford it, which is how a phone ended up filled top to bottom
    -- while half its width sat unused.
    -- plain numbers, not a Vector2: its components are 32 bit, so 0.70 would come back as
    -- 0.69999998 and the cap would sit a pixel under what it says on some screens
    maxOccupancyX: number,
    maxOccupancyY: number?,
    marginFloorX: number,
    marginFloorY: number,

    -- Room to leave above a centred window for the Roblox topbar. Where this is set it takes
    -- the place of a vertical fraction: it is the thing the fraction was standing in for, and
    -- it does not give away half a phone screen to express it.
    topbarClearance: number?,

    -- How wide the window is ever allowed to read against its own height, and (sidebar only)
    -- how narrow, so a landscape window never turns portrait on the way down.
    maxAspectRatio: number,
    minAspectRatio: number?,

    -- top only: when a short screen forces the height down, the window earns a little width
    -- back. Scales with the height actually lost, so a screen tall enough keeps the ideal width.
    widthCompensation: number?,

    chromeHeight: number,
}

-- Below this, either axis is a viewport we dont believe - a camera mid-init or a stray 1x1
-- report. Sizing off one would pin the window at its floor for the session, so take the
-- default and let the caller's reconcile correct it once the screen reports properly.
local minPlausibleViewport = 200

local profiles = {
    top = {
        defaultSize = Vector2.new(475, 500),
        minSize = Vector2.new(300, 285),

        -- Height is bounded by the topbar rather than by a fraction. A flat 70% was chosen so a
        -- centred window cleared the Roblox topbar, but on a phone that gave away far more than
        -- the topbar needs: 273px of a 390px screen, leaving four rows of content. Asking for
        -- the clearance directly keeps the same gap above and hands the rest back. On a big
        -- screen nothing changes, because the ideal height caps it long before this does.
        maxOccupancyX = 0.86,
        topbarClearance = 36,
        marginFloorX = 24,
        marginFloorY = 28,

        -- A landscape phone leaves plenty of width spare, and the window could not reach it:
        -- at a phone's height the aspect ceiling bound the width long before the screen did.
        -- Both are raised together so a short screen gets a usably wide window, while a roomy
        -- one is untouched - the compensation only applies once height has actually been lost.
        maxAspectRatio = 2.3,
        widthCompensation = 130,

        chromeHeight = layouts.top.chromeHeight,
    } :: Profile,
    sidebar = {
        defaultSize = Vector2.new(685, 450),
        -- the floor sits where a rail plus a usable card still fit, in the same band the other
        -- landscape libraries settle on rather than something we invented.
        minSize = Vector2.new(560, 350),

        -- the mirror of the portrait window: width is what the layout is for, so it takes more
        -- of the screen across. The vertical cap is looser than the top layout's because a
        -- phone held landscape is short, and a rail of tabs needs the height to be worth using.
        maxOccupancyX = 0.92,
        maxOccupancyY = 0.8,
        marginFloorX = 24,
        marginFloorY = 28,

        maxAspectRatio = 2.6,
        minAspectRatio = 1.2,

        chromeHeight = layouts.sidebar.chromeHeight,
    } :: Profile,
}

function windowSizing.profile(mode: layouts.Mode?): Profile
    if mode == "sidebar" then
        return profiles.sidebar
    end
    return profiles.top
end

-- The page a window of this height can show. Nil height means the window hasn't been sized yet,
-- so answer with the smallest page there can be rather than nothing.
function windowSizing.pageHeight(windowHeight: number?, mode: layouts.Mode?): number
    local profile = windowSizing.profile(mode)
    local height = if windowHeight and windowHeight > 0 then windowHeight else profile.minSize.Y
    return math.max(height - profile.chromeHeight, 0)
end

-- How much height this screen will give. Whichever bound the profile declares applies; a
-- profile with both gets the tighter of the two.
local function availableHeight(profile: Profile, viewportY: number): number
    local limit = viewportY - profile.marginFloorY
    if profile.topbarClearance then
        limit = math.min(limit, viewportY - profile.topbarClearance * 2)
    end
    if profile.maxOccupancyY then
        limit = math.min(limit, viewportY * profile.maxOccupancyY)
    end
    return limit
end

-- How much of an axis we had to give up, 0 on a screen big enough and 1 once pinned to the floor.
local function deficit(actual: number, ideal: number, floor: number): number
    return math.clamp((ideal - actual) / (ideal - floor), 0, 1)
end

-- Portrait: settle the height first and buy a slice of width back for whatever it cost.
local function fitVertical(profile: Profile, availableX: number, availableY: number): UDim2
    -- the floor gives way to the screen: a viewport too small to hold it gets a smaller window
    -- rather than one hanging off the edge, so the occupancy caps hold at every size. settle the
    -- height to whole pixels first, so the aspect cap is measured against the height we ship
    -- rather than a fraction that rounds away underneath it.
    local height = math.floor(math.min(math.clamp(availableY, profile.minSize.Y, profile.defaultSize.Y), availableY))
    local lost = deficit(height, profile.defaultSize.Y, profile.minSize.Y)
    local width = math.max(profile.defaultSize.X + (profile.widthCompensation :: number) * lost, profile.minSize.X)

    -- the screen and the aspect ceiling are the hard limits, so they are applied after the
    -- floor has lifted the width: a minimum that can push back past a cap is not a cap.
    -- floor, not round: rounding up can carry the result back past those same limits.
    return UDim2.fromOffset(math.floor(math.min(width, availableX, height * profile.maxAspectRatio)), height)
end

-- Landscape: settle the width first, then take whatever height the screen allows without
-- letting the window read portrait.
local function fitHorizontal(profile: Profile, availableX: number, availableY: number): UDim2
    local width = math.min(math.clamp(availableX, profile.minSize.X, profile.defaultSize.X), availableX)
    local height = math.min(math.clamp(availableY, profile.minSize.Y, profile.defaultSize.Y), availableY)

    -- a tall screen doesn't make this a tall window, and a short one narrows it rather than
    -- stretching it into a letterbox. Height gives way first, so the layout keeps the width it
    -- exists for wherever the screen can afford it.
    -- the height settles to whole pixels before the width is capped against it, so the ceiling
    -- holds against the height we ship rather than the fraction it came from.
    height = math.floor(math.min(height, width / (profile.minAspectRatio :: number)))
    width = math.floor(math.min(width, height * profile.maxAspectRatio))

    return UDim2.fromOffset(width, height)
end

function windowSizing.fit(viewport: Vector2?, mode: layouts.Mode?): UDim2
    local profile = windowSizing.profile(mode)

    if not viewport or viewport.X < minPlausibleViewport or viewport.Y < minPlausibleViewport then
        return UDim2.fromOffset(profile.defaultSize.X, profile.defaultSize.Y)
    end

    local availableX = math.min(viewport.X * profile.maxOccupancyX, viewport.X - profile.marginFloorX)
    local availableY = availableHeight(profile, viewport.Y)

    if profile.minAspectRatio then
        return fitHorizontal(profile, availableX, availableY)
    end
    return fitVertical(profile, availableX, availableY)
end

return windowSizing

end)() end
} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        2,
        {
            "Slate"
        },
        {
            {
                38,
                2,
                {
                    "types"
                }
            },
            {
                2,
                1,
                {
                    "components"
                },
                {
                    {
                        4,
                        2,
                        {
                            "button"
                        }
                    },
                    {
                        5,
                        2,
                        {
                            "chrome"
                        }
                    },
                    {
                        20,
                        2,
                        {
                            "sidebar"
                        }
                    },
                    {
                        9,
                        2,
                        {
                            "divider"
                        }
                    },
                    {
                        10,
                        2,
                        {
                            "drag"
                        }
                    },
                    {
                        29,
                        2,
                        {
                            "toggle"
                        }
                    },
                    {
                        27,
                        2,
                        {
                            "text"
                        }
                    },
                    {
                        15,
                        2,
                        {
                            "notification"
                        }
                    },
                    {
                        14,
                        2,
                        {
                            "keybind"
                        }
                    },
                    {
                        7,
                        2,
                        {
                            "console"
                        }
                    },
                    {
                        21,
                        2,
                        {
                            "slider"
                        }
                    },
                    {
                        28,
                        2,
                        {
                            "toast"
                        }
                    },
                    {
                        18,
                        2,
                        {
                            "search"
                        }
                    },
                    {
                        16,
                        2,
                        {
                            "popup"
                        }
                    },
                    {
                        3,
                        2,
                        {
                            "action"
                        }
                    },
                    {
                        13,
                        2,
                        {
                            "input"
                        }
                    },
                    {
                        17,
                        2,
                        {
                            "progress"
                        }
                    },
                    {
                        8,
                        2,
                        {
                            "descriptor"
                        }
                    },
                    {
                        25,
                        2,
                        {
                            "tabSelector"
                        }
                    },
                    {
                        22,
                        2,
                        {
                            "stat"
                        }
                    },
                    {
                        6,
                        2,
                        {
                            "colorpicker"
                        }
                    },
                    {
                        30,
                        2,
                        {
                            "window"
                        }
                    },
                    {
                        11,
                        2,
                        {
                            "dropdown"
                        }
                    },
                    {
                        19,
                        2,
                        {
                            "section"
                        }
                    },
                    {
                        23,
                        2,
                        {
                            "tab"
                        }
                    },
                    {
                        24,
                        2,
                        {
                            "tabSection"
                        }
                    },
                    {
                        12,
                        2,
                        {
                            "group"
                        }
                    },
                    {
                        26,
                        2,
                        {
                            "tag"
                        }
                    }
                }
            },
            {
                39,
                1,
                {
                    "utility"
                },
                {
                    {
                        40,
                        2,
                        {
                            "HapticEngine"
                        }
                    },
                    {
                        44,
                        2,
                        {
                            "enums"
                        }
                    },
                    {
                        65,
                        2,
                        {
                            "persistenceWrite"
                        }
                    },
                    {
                        52,
                        2,
                        {
                            "layouts"
                        }
                    },
                    {
                        51,
                        2,
                        {
                            "imageCache"
                        }
                    },
                    {
                        47,
                        2,
                        {
                            "flagNames"
                        }
                    },
                    {
                        48,
                        2,
                        {
                            "fontManager"
                        }
                    },
                    {
                        54,
                        2,
                        {
                            "lockable"
                        }
                    },
                    {
                        50,
                        2,
                        {
                            "image"
                        }
                    },
                    {
                        69,
                        2,
                        {
                            "variables"
                        }
                    },
                    {
                        41,
                        2,
                        {
                            "assetResolver"
                        }
                    },
                    {
                        68,
                        2,
                        {
                            "textMetrics"
                        }
                    },
                    {
                        53,
                        2,
                        {
                            "locale"
                        }
                    },
                    {
                        60,
                        2,
                        {
                            "path"
                        }
                    },
                    {
                        58,
                        2,
                        {
                            "odometer"
                        }
                    },
                    {
                        42,
                        2,
                        {
                            "colors"
                        }
                    },
                    {
                        66,
                        2,
                        {
                            "runtime"
                        }
                    },
                    {
                        67,
                        2,
                        {
                            "services"
                        }
                    },
                    {
                        63,
                        2,
                        {
                            "persistencePaths"
                        }
                    },
                    {
                        46,
                        2,
                        {
                            "filesystemManager"
                        }
                    },
                    {
                        56,
                        2,
                        {
                            "moveable"
                        }
                    },
                    {
                        43,
                        2,
                        {
                            "constants"
                        }
                    },
                    {
                        61,
                        2,
                        {
                            "persistence"
                        }
                    },
                    {
                        64,
                        2,
                        {
                            "persistenceSettings"
                        }
                    },
                    {
                        59,
                        2,
                        {
                            "ordering"
                        }
                    },
                    {
                        57,
                        2,
                        {
                            "network"
                        }
                    },
                    {
                        62,
                        2,
                        {
                            "persistenceConfig"
                        }
                    },
                    {
                        45,
                        2,
                        {
                            "filesystem"
                        }
                    },
                    {
                        49,
                        2,
                        {
                            "functions"
                        }
                    },
                    {
                        70,
                        2,
                        {
                            "windowSizing"
                        }
                    },
                    {
                        55,
                        2,
                        {
                            "log"
                        }
                    }
                }
            },
            {
                31,
                1,
                {
                    "themes"
                },
                {
                    {
                        33,
                        2,
                        {
                            "cobalt"
                        }
                    },
                    {
                        32,
                        2,
                        {
                            "amethyst"
                        }
                    },
                    {
                        35,
                        2,
                        {
                            "ember"
                        }
                    },
                    {
                        37,
                        2,
                        {
                            "rose"
                        }
                    },
                    {
                        36,
                        2,
                        {
                            "frost"
                        }
                    },
                    {
                        34,
                        2,
                        {
                            "default"
                        }
                    }
                }
            }
        }
    }
}

-- Line offsets for debugging (only included when minifyTables is false)
local LineOffsets = {
    8,
    [3] = 196,
    [4] = 323,
    [5] = 610,
    [6] = 862,
    [7] = 2138,
    [8] = 2534,
    [9] = 2600,
    [10] = 2784,
    [11] = 3025,
    [12] = 4500,
    [13] = 4752,
    [14] = 5052,
    [15] = 5581,
    [16] = 5945,
    [17] = 6757,
    [18] = 7269,
    [19] = 7658,
    [20] = 7758,
    [21] = 8068,
    [22] = 8772,
    [23] = 9447,
    [24] = 9825,
    [25] = 9984,
    [26] = 10337,
    [27] = 10519,
    [28] = 10704,
    [29] = 11142,
    [30] = 11662,
    [32] = 14596,
    [33] = 14649,
    [34] = 14702,
    [35] = 14792,
    [36] = 14845,
    [37] = 14925,
    [38] = 14978,
    [40] = 15405,
    [41] = 15538,
    [42] = 15732,
    [43] = 15763,
    [44] = 15849,
    [45] = 15884,
    [46] = 16157,
    [47] = 16214,
    [48] = 16257,
    [49] = 16734,
    [50] = 16757,
    [51] = 16918,
    [52] = 17181,
    [53] = 17346,
    [54] = 17488,
    [55] = 17523,
    [56] = 17583,
    [57] = 17627,
    [58] = 17652,
    [59] = 18019,
    [60] = 18044,
    [61] = 18108,
    [62] = 18133,
    [63] = 18409,
    [64] = 18461,
    [65] = 18611,
    [66] = 18652,
    [67] = 18723,
    [68] = 18740,
    [69] = 18834,
    [70] = 18910
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "Slate"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring, tonumber, _VERSION =
      string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring, tonumber, _VERSION

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze or function(t) return t end -- lol

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {}

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in next, InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    -- Grabs the stack while it's still live; pcall alone would discard it. Guarded,
    -- since some executors sandbox `debug` away entirely
    local function CatchError(originalErrorMessage)
        local Traceback
        local TracebackSuccess, TracebackResult = pcall(function()
            return debug.traceback(nil, 2)
        end)
        if TracebackSuccess then
            Traceback = TracebackResult
        end

        return {Message = originalErrorMessage, Traceback = Traceback}
    end

    local function FormatError(caughtError)
        local originalErrorMessage = tostring(caughtError.Message)

        local VirtualFullName = scriptRef:GetFullName()

        -- Check for vanilla/Roblox format
        local OriginalErrorLine, BaseErrorMessage = string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        local FormattedMessage
        if not OriginalErrorLine or not LineOffsets then
            FormattedMessage = VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        else
            OriginalErrorLine = tonumber(OriginalErrorLine)

            local RefId = ScriptClosureRefIds[scriptRef]
            local LineOffset = LineOffsets[RefId]

            local RealErrorLine = OriginalErrorLine - LineOffset + 1
            if RealErrorLine < 0 then
                RealErrorLine = "?"
            end

            FormattedMessage = VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
        end

        local Traceback = caughtError.Traceback
        if Traceback and Traceback ~= "" then
            FormattedMessage = FormattedMessage .. "\n" .. Traceback
        end

        return FormattedMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, CaughtError = xpcall(Closure, CatchError)
        if not RunSuccess then
            error(FormatError(CaughtError), 0)
        end
    else
        local PCallReturn = {xpcall(Closure, CatchError)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local CaughtError = table_remove(PCallReturn, 1)
            error(FormatError(CaughtError), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {pcall(f, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end

-- AoT adjustment: Load init module (MainModule behavior)
return LoadScript(RealObjectRoot:GetChildren()[1])