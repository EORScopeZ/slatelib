-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)local variables = require(script.utility.variables)
local image = require(script.utility.image)
local locale = require(script.utility.locale)
local constants = require(script.utility.constants)
local types = require(script.types)

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
export type Slate = types.Slate
export type Slate = types.Slate
type WindowModule = {new: (types.WindowProps) -> types.Window}

local slate = {}::Slate

local function createBanner(properties: types.WindowProps?)
    local ui = Instance.new('ScreenGui')

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

    local card = Instance.new('Frame')
    card.Name = 'SplashCard'
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(195, 56)
    card.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
    card.BorderSizePixel = 0
    card.BackgroundTransparency = 0
    card.Parent = ui

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new('UIStroke')
    stroke.Color = Color3.fromRGB(48, 48, 56)
    stroke.Thickness = 1
    stroke.Parent = card

    local layout = Instance.new('UIListLayout')
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
    layout.Parent = card

    local logo = Instance.new('ImageLabel')
    logo.Name = 'Logo'
    logo.Size = UDim2.fromOffset(30, 30)
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.Image = image.resolve((properties and (properties.icon or properties.Icon)) or constants.icons.banner)
    logo.ScaleType = Enum.ScaleType.Fit
    logo.LayoutOrder = 1
    logo.Parent = card

    local textGroup = Instance.new('Frame')
    textGroup.Name = 'TextGroup'
    textGroup.Size = UDim2.fromOffset(96, 36)
    textGroup.BackgroundTransparency = 1
    textGroup.BorderSizePixel = 0
    textGroup.LayoutOrder = 2
    textGroup.Parent = card

    local textLayout = Instance.new('UIListLayout')
    textLayout.FillDirection = Enum.FillDirection.Vertical
    textLayout.SortOrder = Enum.SortOrder.LayoutOrder
    textLayout.Padding = UDim.new(0, 2)
    textLayout.Parent = textGroup

    local title = Instance.new('TextLabel')
    title.Name = 'Title'
    title.Size = UDim2.new(1, 0, 0, 18)
    title.BackgroundTransparency = 1
    title.Text = (properties and (properties.name or properties.Name)) or 'slate'
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 1
    title.Parent = textGroup

    local subtitle = Instance.new('TextLabel')
    subtitle.Name = 'Subtitle'
    subtitle.Size = UDim2.new(1, 0, 0, 14)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = (properties and (properties.subtitle or properties.Subtitle)) or 'initializing...'
    subtitle.TextColor3 = Color3.fromRGB(160, 160, 165)
    subtitle.TextSize = 12
    subtitle.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.LayoutOrder = 2
    subtitle.Parent = textGroup

    return ui
end

function slate:CreateWindow(properties: types.WindowProps): types.Window
    local banner = createBanner(properties)
    local window: types.Window?
    local queuedNotify: (() -> ())?

    if variables.secureMode then
        image.preload(function(failed)
            if failed <= 0 then
                return
            end

            local function notify()
                if not window or window.unloaded then
                    return
                end

                window:Notify({
                    title = locale.resolve('Secure mode'),
                    content = if failed == 1 then locale.resolve("An asset couldn't be cached and won't appear.")else locale.resolve("Some assets couldn't be cached and won't appear."),
                })
            end

            if window then
                notify()
            else
                queuedNotify = notify
            end
        end)
    end

    local made, result = pcall(function()
        return (require(script.components.window)::WindowModule).new(properties)
    end)

    if not made then
        banner:Destroy()
        error(result, 0)
    end

    local built = result::types.Window
    window = built

    if queuedNotify then
        task.spawn(queuedNotify)
        queuedNotify = nil
    end

    if variables.secureMode then
        task.spawn(function()
            local body = variables.fontManager:loadFont(constants.fontAsset, Enum.FontWeight.Medium)
            local title = variables.fontManager:loadFont(constants.fontAsset, Enum.FontWeight.SemiBold)

            if not built.unloaded and body and title and body ~= variables.fallbackFont and title ~= variables.fallbackFont then
                built:ChangeTheme({
                    Font = body,
                    TitleFont = title,
                })
            end
        end)
    end

    task.spawn(function()
        task.wait(1.4)

        if banner and banner.Parent then
            local card = banner:FindFirstChild('SplashCard', true)
            if card then
                local tween = variables.tweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(175, 48),
                })
                tween:Play()
                for _, child in card:GetDescendants() do
                    if child:IsA('TextLabel') then
                        variables.tweenService:Create(child, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
                    elseif child:IsA('ImageLabel') then
                        variables.tweenService:Create(child, TweenInfo.new(0.25), {ImageTransparency = 1}):Play()
                    elseif child:IsA('UIStroke') then
                        variables.tweenService:Create(child, TweenInfo.new(0.25), {Transparency = 1}):Play()
                    end
                end
                tween.Completed:Wait()
            end
            banner:Destroy()
        end

        task.wait(0.05)

        if not built.unloaded then
            built:Show()
        end
    end)

    return built
end

return slate

end)() end,
    [3] = function()local wax,script,require=ImportGlobals(3)local ImportGlobals return (function(...)local Action = {}

Action.__index = Action
Action.__type = 'Action'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local log = require(utility.log)
local hapticEngine = require(utility.HapticEngine)

function Action.new(window, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        name = properties.name or properties.Name or 'Action',
        icon = assert(properties.icon or properties.Icon, 'Missing argument (Icon expected)'),
        callback = assert(properties.callback or properties.Callback, 'Missing argument (Function expected)'),
        linkedTab = properties.linkedTab or properties.LinkedTab,
    }, Action)

    self.action = self.window:Create('Frame', {
        Name = self.name,
        BorderSizePixel = 0,
        LayoutOrder = -(properties.order or 0),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        Parent = self.window.actionContainer,
    })
    self.iconLabel = self.window:Create('ImageLabel', {
        Image = self.icon,
        Size = UDim2.fromOffset(20, 20),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Parent = self.action,
    }, {
        ImageColor3 = 'ActionColor',
    })
    self.interact = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextTransparency = 1,
        Parent = self.action,
    })

    local function settleIcon()
        if not self.window:_settled() then
            return
        end
        if self.linkedTab and self.window.selectedTab == self.linkedTab then
            return
        end
        if self.isLit and self:isLit() then
            return
        end

        variables.tweenService:Create(self.iconLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.6}):Play()
    end

    self.window:Connect(self.interact.MouseButton1Click, function()
        hapticEngine.click()
        task.spawn(function()
            local success, result = pcall(self.callback)

            if not success then
                log.warn(`Slate encountered an error, with the callback for a {self.__type} component named '{self.name}':`)
                log.print(result)
            end

            settleIcon()
        end)
    end)
    self.window:Connect(self.interact.MouseEnter, function()
        if not self.window:_interactive() then
            return
        end

        variables.tweenService:Create(self.iconLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.2}):Play()
    end)
    self.window:Connect(self.interact.MouseLeave, settleIcon)

    return self
end

return Action

end)() end,
    [4] = function()local wax,script,require=ImportGlobals(4)local ImportGlobals return (function(...)local Button = {}

Button.__index = Button
Button.__type = 'Button'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

function Button.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Button',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        compact = tab.compact or false,
        callback = properties.callback or properties.Callback or function() end,
    }, Button)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end
    if self.description and not self.compact then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    return self
end
function Button:_runCallback()
    self.window:_runGuarded(self, self.callback)
end
function Button:_buildFull()
    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 43),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)
    self.container = self.window:Create('Frame', {
        BorderSizePixel = 0,
        Parent = self.main,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
    })
    self.containerLayout = self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(250, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.interact = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextTransparency = 1,
        Parent = self.main,
    })

    self.window:_wireElementHover(self)
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        variables.tweenService:Create(self.main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -26, 0, 43),
        }):Play()
        self:_runCallback()
        task.wait(0.11)
        variables.tweenService:Create(self.main, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -20, 0, 43),
        }):Play()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Transparency = self.window.theme.ElementStrokeTransparency,
        }):Play()
    end)
end
function Button:_buildCompact()
    local window = self.window

    self.main, self.stroke, self.interact = window:_buildCompactRow(self.tab, self.name)
    self.hoverOverlay = self.interact

    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = self.interact,
    })
    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = self.interact,
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ImageTransparency = 1,
            Parent = self.interact,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.interact,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })
    self.window:_wireElementHover(self)
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        self:_runCallback()
        task.wait(0.11)
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Transparency = self.window.theme.ElementStrokeTransparency,
        }):Play()
    end)
end
function Button:_setShown(shown, animate)
    if shown then
        self.window:_revealCommon(self, animate)
    else
        self.window:_hideCommon(self, animate)
    end
end
function Button:_minWidth()
    local w = 32

    if self.icon then
        w += 22
    end

    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))

    return w
end

moveable(Button)
lockable(Button)

return Button

end)() end,
    [5] = function()local wax,script,require=ImportGlobals(5)local ImportGlobals return (function(...)local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local filesystem = require(utility.filesystem)
local constants = require(utility.constants)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)
local chrome = {}
local dragThreshold = 5

function chrome.buildCollapsedFace(window)
    local iconOnly = window.showIconOnly

    window.collapsedIcon = window:Create('ImageLabel', {
        Name = 'CollapsedIcon',
        AnchorPoint = if iconOnly then Vector2.new(0.5, 0.5)else Vector2.new(0, 0.5),
        Position = if iconOnly then UDim2.fromScale(0.5, 0.5)else UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        Image = window.showIcon,
        ZIndex = constants.zIndex.restoreContent,
        ImageTransparency = 1,
        Parent = window.main,
    }, {
        ImageColor3 = 'TitlingColor',
    })

    window:Create('UICorner', {
        Parent = window.collapsedIcon,
    }, {
        CornerRadius = 'PillCornerRadius',
    })

    local textContainer = window:Create('Frame', {
        Name = 'CollapsedText',
        Visible = not iconOnly,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 50, 0.5, 0),
        Size = UDim2.new(1, -60, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = constants.zIndex.restoreContent,
        Parent = window.main,
    })

    window:Create('UIListLayout', {
        Padding = UDim.new(0, 1),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = textContainer,
    })

    window.collapsedTitle = window:Create('TextLabel', {
        Name = 'Title',
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
        TextTransparency = 1,
        Parent = textContainer,
    }, {
        TextColor3 = 'TitlingColor',
    })
    window.collapsedSubtitle = window:Create('TextLabel', {
        Name = 'Subtitle',
        Text = locale.t('Tap to show'),
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundTransparency = 1,
        FontFace = variables.brandFont(Enum.FontWeight.Medium),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.restoreContent,
        TextTransparency = 1,
        Parent = textContainer,
    }, {
        TextColor3 = 'TitlingColor',
    })
    window.collapsedInteract = window:Create('TextButton', {
        Name = 'CollapsedInteract',
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = '',
        TextTransparency = 1,
        Visible = false,
        ZIndex = constants.zIndex.restoreInteract,
        Parent = window.main,
    })

    chrome.bindCollapsedDrag(window)
end
function chrome.bindCollapsedDrag(window)
    local uis = variables.userInputService
    local dragging, moved = false, false
    local grabOffset, grabMouse = Vector2.zero, Vector2.zero

    local function insetOffset()
        if window.screenGui and window.screenGui.IgnoreGuiInset then
            return variables.guiService:GetGuiInset()
        end

        return Vector2.zero
    end

    window:Connect(window.collapsedInteract.InputBegan, function(
        input,
        processed
    )
        if processed or not window.hidden or window.animating then
            return
        end

        local inputType = input.UserInputType.Name

        if inputType ~= 'MouseButton1' and inputType ~= 'Touch' then
            return
        end

        dragging, moved = true, false
        grabMouse = uis:GetMouseLocation()
        grabOffset = window.main.AbsolutePosition + window.main.AbsoluteSize * window.main.AnchorPoint - grabMouse
    end)
    window:Connect(uis.InputEnded, function(input)
        local inputType = input.UserInputType.Name

        if inputType ~= 'MouseButton1' and inputType ~= 'Touch' then
            return
        end
        if not dragging then
            return
        end

        dragging = false

        if moved then
            window._collapsedPosition = window.main.Position

            return
        end

        hapticEngine.click()
        window:ToggleHide()
    end)
    window:Connect(uis.WindowFocusReleased, function()
        dragging = false
    end)
    window:Connect(variables.runService.RenderStepped, function()
        if not dragging then
            return
        end
        if not window.hidden or window.animating then
            dragging = false

            return
        end

        local mouse = uis:GetMouseLocation()

        if not moved and (mouse - grabMouse).Magnitude < dragThreshold then
            return
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
    if typeof(filesystem.isfile) ~= 'function' or typeof(filesystem.writefile) ~= 'function' then
        return true
    end

    local path = variables.fileSystemManager:getPath('lastuser.txt')
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
function chrome.setCollapsedShown(window, shown, tweenInfo)
    local targets = {
        [window.collapsedIcon] = {
            ImageTransparency = if shown then 0 else 1,
        },
    }

    if not window.showIconOnly then
        targets[window.collapsedTitle] = {
            TextTransparency = if shown then 0 else 1,
        }
        targets[window.collapsedSubtitle] = {
            TextTransparency = if shown then 0.5 else 1,
        }
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
    [6] = function()local wax,script,require=ImportGlobals(6)local ImportGlobals return (function(...)local ColorPicker = {}

ColorPicker.__index = ColorPicker
ColorPicker.__type = 'ColorPicker'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local constants = require(utility.constants)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)
local hueSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})
local headerHeight = 41
local contentY = 52
local mapSize = Vector2.new(150, 120)
local hueX = 184
local hueWidth = 10
local alphaX = 214
local alphaWidth = 10
local rightX = 240
local alphaFieldWidth = 62
local fieldGap = 8
local narrowWidth = 400
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
local previewClosedPos = UDim2.new(1, -16, 0, headerHeight / 2)
local previewClosedSize = UDim2.fromOffset(40, 22)
local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local followInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local dragInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local heldInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function clamp01(n)
    return math.clamp(n, 0, 1)
end
local function clampByte(n)
    return math.clamp(math.round(n), 0, 255)
end

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

    local q = if l < 0.5 then l * (1 + s)else l + s - l * s
    local p = 2 * l - q

    return Color3.new(hue2(p, q, h + 1 / 3), hue2(p, q, h), hue2(p, q, h - 1 / 3))
end
local function numbersIn(s)
    local out = {}

    for n in s:gmatch('[%d%.]+')do
        table.insert(out, tonumber(n))
    end

    return out
end
local function parseColor(input)
    if typeof(input) ~= 'string' then
        return nil
    end

    local s = (input:lower():match('^%s*(.-)%s*$')) or ''

    if s == '' then
        return nil
    end
    if namedColors[s] then
        return namedColors[s]
    end

    local model = s:match('^(%a+)')
    local nums = numbersIn(s)

    if (model == 'hsv' or model == 'hsb') and #nums >= 3 then
        local h = (nums[1] % 360) / 360
        local sat = if nums[2] > 1 then nums[2] / 100 else nums[2]
        local v = if nums[3] > 1 then nums[3] / 100 else nums[3]

        return Color3.fromHSV(h, clamp01(sat), clamp01(v))
    end
    if model == 'hsl' and #nums >= 3 then
        local h = (nums[1] % 360) / 360
        local sat = if nums[2] > 1 then nums[2] / 100 else nums[2]
        local l = if nums[3] > 1 then nums[3] / 100 else nums[3]

        return hslToColor(h, clamp01(sat), clamp01(l))
    end
    if (model == 'rgb' or model == 'rgba') and #nums >= 3 then
        return Color3.fromRGB(clampByte(nums[1]), clampByte(nums[2]), clampByte(nums[3]))
    end

    local hex = s:match('^#?(%x%x%x%x%x%x)$') or s:match('^#?(%x%x%x)$') or s:match('^0x(%x%x%x%x%x%x)$')

    if hex then
        local ok, color = pcall(Color3.fromHex, hex)

        if ok then
            return color
        end
    end
    if #nums >= 3 and not model then
        if nums[1] <= 1 and nums[2] <= 1 and nums[3] <= 1 then
            return Color3.new(clamp01(nums[1]), clamp01(nums[2]), clamp01(nums[3]))
        end

        return Color3.fromRGB(clampByte(nums[1]), clampByte(nums[2]), clampByte(nums[3]))
    end

    return nil
end
local function coerceColor(value, fallback)
    if typeof(value) == 'Color3' then
        return value
    end
    if typeof(value) == 'string' then
        return parseColor(value) or fallback
    end

    return fallback
end

function ColorPicker.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Color Picker',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        callback = properties.callback or properties.Callback or function() end,
        _isOpen = false,
    }, ColorPicker)

    self.value = coerceColor(properties.color or properties.Color or properties.value or properties.Value or properties.default, Color3.fromRGB(255, 255, 255))
    self.hue, self.sat, self.val = self.value:ToHSV()

    local a = properties.alpha or properties.Alpha

    self.alpha = if type(a) == 'number'then clamp01(a)else 1
    self.flag = properties.flag or properties.Flag or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)

    self.window:_registerControl(self)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, headerHeight),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
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
    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if self._isOpen or not self.window:_interactive() then
            return
        end

        local theme = self.window.theme

        variables.tweenService:Create(self.stroke, fadeInfo, {
            Transparency = theme.ElementStrokeHoverTransparency,
            Color = theme.ElementStrokeHover,
        }):Play()
        variables.tweenService:Create(self.title, fadeInfo, {
            TextColor3 = theme.ElementTextHoverColor,
        }):Play()
        variables.tweenService:Create(self.hoverOverlay, fadeInfo, {BackgroundTransparency = 0.97}):Play()
    end)
    self.window:ConnectFor(self, self.main.MouseLeave, function()
        local theme = self.window.theme

        variables.tweenService:Create(self.stroke, fadeInfo, {
            Transparency = theme.ElementStrokeTransparency,
            Color = theme.ElementStroke,
        }):Play()
        variables.tweenService:Create(self.title, fadeInfo, {
            TextColor3 = theme.ContentColor,
        }):Play()
        variables.tweenService:Create(self.hoverOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
    end)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    self:_applyPickerVisibility(false, false)
    self:_setControlsVisible(false)
    self.window:ConnectFor(self, self.main:GetPropertyChangedSignal('AbsoluteSize'), function(
    )
        if self.window.animating or (self.window.hidden and self.window.hasShownOnce) then
            return
        end

        self:_applyLayout()
    end)
    self:_applyLayout()
    self:_render('instant')

    return self
end
function ColorPicker:_buildHeader()
    self.container = self.window:Create('Frame', {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0, headerHeight / 2),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.preview = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = previewClosedPos,
        Size = previewClosedSize,
        BackgroundColor3 = self.value,
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.preview,
    })

    self.previewShadow = self.window:CreateGlow(self.preview, self.value, 20, 1)
    self.invisibleGroup = self.window:Create('Frame', {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.preview,
    })

    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.invisibleGroup,
    })

    self.invisibleIcon = self.window:Create('ImageLabel', {
        Image = constants.icons.colorpicker,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        ImageTransparency = 1,
        Parent = self.invisibleGroup,
    }, {
        ImageColor3 = 'ContentColor',
    })
    self.invisibleText = self.window:Create('TextLabel', {
        Text = locale.t('Invisible'),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.invisibleGroup,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.interact = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        Text = '',
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 10,
        Parent = self.main,
    })
end
function ColorPicker:_buildMap()
    self.map = self.window:Create('Frame', {
        Position = UDim2.fromOffset(20, contentY),
        Size = UDim2.fromOffset(mapSize.X, mapSize.Y),
        BackgroundColor3 = Color3.fromHSV(self.hue, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.map,
    })

    self.mapStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = self.map,
    })
    self.satOverlay = self.window:Create('Frame', {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 3,
        BackgroundTransparency = 1,
        Parent = self.map,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.satOverlay,
    })
    self.window:Create('UIGradient', {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.satOverlay,
    })

    self.valOverlay = self.window:Create('Frame', {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 4,
        BackgroundTransparency = 1,
        Parent = self.map,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.valOverlay,
    })
    self.window:Create('UIGradient', {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Parent = self.valOverlay,
    })
end
function ColorPicker:_buildPicker()
    self:_buildMap()

    self.satCursor = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 6,
        BackgroundTransparency = 1,
        Parent = self.map,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.satCursor,
    })

    self.satCursorStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1,
        Parent = self.satCursor,
    })
    self.mapInteract = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = '',
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 7,
        Parent = self.map,
    })
    self.hueBar = self.window:Create('Frame', {
        Position = UDim2.fromOffset(hueX, contentY),
        Size = UDim2.fromOffset(hueWidth, mapSize.Y),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.hueBar,
    })
    self.window:Create('UIGradient', {
        Color = hueSequence,
        Rotation = 90,
        Parent = self.hueBar,
    })

    self.hueHandle = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(hueWidth + 8, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 4,
        BackgroundTransparency = 1,
        Parent = self.hueBar,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.hueHandle,
    })

    self.hueHandleStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1,
        Parent = self.hueHandle,
    })
    self.hueInteract = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 16, 1, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = '',
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 6,
        Parent = self.hueBar,
    })
    self.alphaBar = self.window:Create('Frame', {
        Position = UDim2.fromOffset(alphaX, contentY),
        Size = UDim2.fromOffset(alphaWidth, mapSize.Y),
        BackgroundColor3 = self.value,
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.alphaBar,
    })

    self.alphaGradient = self.window:Create('UIGradient', {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.alphaBar,
    })
    self.alphaHandle = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(alphaWidth + 8, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 4,
        BackgroundTransparency = 1,
        Parent = self.alphaBar,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.alphaHandle,
    })

    self.alphaHandleStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 1,
        Parent = self.alphaHandle,
    })
    self.alphaInteract = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 16, 1, 8),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = '',
        TextTransparency = 1,
        AutoButtonColor = false,
        ZIndex = 6,
        Parent = self.alphaBar,
    })
    self.hexBox = self.window:Create('Frame', {
        Position = UDim2.new(0, rightX, 0, contentY + 90),
        Size = UDim2.new(1, -(rightX + 20), 0, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.hexBox,
    })

    self.hexBoxStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = self.hexBox,
    })
    self.hexInput = self.window:Create('TextBox', {
        Text = '#' .. self.value:ToHex():upper(),
        PlaceholderText = locale.t('Smart Input'),
        Size = UDim2.new(1, -14, 1, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 3,
        TextTransparency = 1,
        Parent = self.hexBox,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
        PlaceholderColor3 = 'PlaceholderColor',
    })
    self.alphaBox = self.window:Create('Frame', {
        Position = UDim2.new(0, rightX, 0, contentY + 90),
        Size = UDim2.fromOffset(alphaFieldWidth, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = self.alphaBox,
    })

    self.alphaBoxStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = self.alphaBox,
    })
    self.alphaInput = self.window:Create('TextBox', {
        Text = tostring(math.round(self.alpha * 100)) .. '%',
        PlaceholderText = '100%',
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 3,
        TextTransparency = 1,
        Parent = self.alphaBox,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
        PlaceholderColor3 = 'PlaceholderColor',
    })

    self.window:ConnectFor(self, self.mapInteract.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_beginDrag('sat', input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)
    self.window:ConnectFor(self, self.hueInteract.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_beginDrag('hue', input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)
    self.window:ConnectFor(self, self.alphaInteract.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_beginDrag('alpha', input.UserInputType == Enum.UserInputType.MouseButton1)
        end
    end)
    self.window:ConnectFor(self, variables.userInputService.InputEnded, function(
        input
    )
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self._drag then
            self:_endDrag()
        end
    end)
    self.window:ConnectFor(self, self.hexInput.FocusLost, function()
        local color = parseColor(self.hexInput.Text)

        if color then
            self:Set(color)
        else
            self.hexInput.Text = '#' .. self.value:ToHex():upper()
        end
    end)
    self.window:ConnectFor(self, self.alphaInput.FocusLost, function()
        local n = tonumber((self.alphaInput.Text:gsub('[^%d%.]', '')))

        if n then
            self:SetAlpha(clamp01(n / 100))
        else
            self.alphaInput.Text = tostring(math.round(self.alpha * 100)) .. '%'
        end
    end)
end
function ColorPicker:_beginDrag(region, isMouse)
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
        local mouseReleased = self._dragIsMouse and not variables.userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

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
function ColorPicker:_setHeld(region)
    local satSize = if region == 'sat'then UDim2.fromOffset(16, 16)else UDim2.fromOffset(12, 12)
    local hueSize = if region == 'hue'then UDim2.fromOffset(hueWidth + 12, 10)else UDim2.fromOffset(hueWidth + 8, 8)
    local alphaSize = if region == 'alpha'then UDim2.fromOffset(alphaWidth + 12, 10)else UDim2.fromOffset(alphaWidth + 8, 8)

    variables.tweenService:Create(self.satCursor, heldInfo, {Size = satSize}):Play()
    variables.tweenService:Create(self.hueHandle, heldInfo, {Size = hueSize}):Play()
    variables.tweenService:Create(self.alphaHandle, heldInfo, {Size = alphaSize}):Play()
end
function ColorPicker:_mouseLocation()
    local mouse = variables.userInputService:GetMouseLocation()
    local screenGui = self.window.screenGui

    if screenGui and screenGui.IgnoreGuiInset then
        return mouse - variables.guiService:GetGuiInset()
    end

    return mouse
end
function ColorPicker:_pump()
    local prevHue, prevSat, prevVal, prevAlpha = self.hue, self.sat, self.val, self.alpha

    if self._drag == 'sat' then
        local size = self.map.AbsoluteSize

        if size.X <= 0 or size.Y <= 0 then
            return
        end

        local mouse = self:_mouseLocation()

        self.sat = clamp01((mouse.X - self.map.AbsolutePosition.X) / size.X)
        self.val = 1 - clamp01((mouse.Y - self.map.AbsolutePosition.Y) / size.Y)
    elseif self._drag == 'hue' then
        local height = self.hueBar.AbsoluteSize.Y

        if height <= 0 then
            return
        end

        local mouse = self:_mouseLocation()

        self.hue = clamp01((mouse.Y - self.hueBar.AbsolutePosition.Y) / height)
    elseif self._drag == 'alpha' then
        local height = self.alphaBar.AbsoluteSize.Y

        if height <= 0 then
            return
        end

        local mouse = self:_mouseLocation()

        self.alpha = 1 - clamp01((mouse.Y - self.alphaBar.AbsolutePosition.Y) / height)
    else
        return
    end
    if self.hue == prevHue and self.sat == prevSat and self.val == prevVal and self.alpha == prevAlpha then
        return
    end

    self.value = Color3.fromHSV(self.hue, self.sat, self.val)

    self:_render('drag')
    self:_fireCallback()
end
function ColorPicker:_render(mode)
    local mapHue = Color3.fromHSV(self.hue, 1, 1)
    local satPos = UDim2.new(self.sat, 0, 1 - self.val, 0)
    local huePos = UDim2.new(0.5, 0, self.hue, 0)
    local alphaPos = UDim2.new(0.5, 0, 1 - self.alpha, 0)
    local previewT = 1 - self.alpha
    local shadowT = 1 - 0.4 * self.alpha

    if mode == 'instant' then
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
        local moveInfo = if mode == 'drag'then dragInfo else followInfo

        variables.tweenService:Create(self.map, moveInfo, {BackgroundColor3 = mapHue}):Play()
        variables.tweenService:Create(self.satCursor, moveInfo, {
            Position = satPos,
            BackgroundColor3 = self.value,
        }):Play()
        variables.tweenService:Create(self.hueHandle, moveInfo, {
            Position = huePos,
            BackgroundColor3 = mapHue,
        }):Play()
        variables.tweenService:Create(self.alphaHandle, moveInfo, {
            Position = alphaPos,
            BackgroundColor3 = self.value,
        }):Play()
        variables.tweenService:Create(self.alphaBar, followInfo, {
            BackgroundColor3 = self.value,
        }):Play()

        local previewGoal = {
            BackgroundColor3 = self.value,
        }
        local shadowGoal = {
            Color = self.value,
        }

        if not self.window.hidden then
            previewGoal.BackgroundTransparency = previewT
            shadowGoal.Transparency = shadowT
        end

        variables.tweenService:Create(self.preview, followInfo, previewGoal):Play()
        variables.tweenService:Create(self.previewShadow, followInfo, shadowGoal):Play()
    end
    if not self.hexInput:IsFocused() then
        self.hexInput.Text = '#' .. self.value:ToHex():upper()
    end
    if not self.alphaInput:IsFocused() then
        self.alphaInput.Text = tostring(math.round(self.alpha * 100)) .. '%'
    end

    self:_renderInvisible(mode ~= 'instant')
end
function ColorPicker:_renderInvisible(animate)
    local inv = 0

    if self._isOpen and not self.window.hidden then
        inv = clamp01((0.12 - self.alpha) / 0.12)
    end

    local t = 1 - inv

    if animate then
        variables.tweenService:Create(self.invisibleIcon, fadeInfo, {ImageTransparency = t}):Play()
        variables.tweenService:Create(self.invisibleText, fadeInfo, {TextTransparency = t}):Play()
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

    self:_setControlsVisible(true)

    if self._outsideClickConn then
        self.window:Disconnect(self._outsideClickConn)
    end

    self._outsideClickConn = self.window:Connect(variables.userInputService.InputBegan, function(
        input
    )
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local pos = input.Position
        local mainPos = self.main.AbsolutePosition
        local mainSize = self.main.AbsoluteSize

        if pos.X < mainPos.X or pos.X > mainPos.X + mainSize.X or pos.Y < mainPos.Y or pos.Y > mainPos.Y + mainSize.Y then
            self:_close()
        end
    end)

    variables.tweenService:Create(self.main, openInfo, {
        Size = UDim2.new(1, -20, 0, self._openHeight),
    }):Play()
    variables.tweenService:Create(self.preview, openInfo, {
        Position = self._previewOpenPos,
        Size = self._previewOpenSize,
    }):Play()
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
    variables.tweenService:Create(self.preview, openInfo, {
        Position = previewClosedPos,
        Size = previewClosedSize,
    }):Play()
    variables.tweenService:Create(self.main, openInfo, {
        Size = UDim2.new(1, -20, 0, headerHeight),
    }):Play()
    task.delay(fadeInfo.Time, function()
        if not self._isOpen then
            self:_setControlsVisible(false)
        end
    end)
end
function ColorPicker:_applyPickerVisibility(open, animate)
    local set = {
        [self.map] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.satOverlay] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.valOverlay] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.mapStroke] = {
            Transparency = if open then 0.9 else 1,
        },
        [self.satCursor] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.satCursorStroke] = {
            Transparency = if open then 0 else 1,
        },
        [self.hueBar] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.hueHandle] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.hueHandleStroke] = {
            Transparency = if open then 0 else 1,
        },
        [self.alphaBar] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.alphaHandle] = {
            BackgroundTransparency = if open then 0 else 1,
        },
        [self.alphaHandleStroke] = {
            Transparency = if open then 0 else 1,
        },
        [self.hexBox] = {
            BackgroundTransparency = if open then 0.9 else 1,
        },
        [self.hexBoxStroke] = {
            Transparency = if open then 0.85 else 1,
        },
        [self.hexInput] = {
            TextTransparency = if open then 0.4 else 1,
        },
        [self.alphaBox] = {
            BackgroundTransparency = if open then 0.9 else 1,
        },
        [self.alphaBoxStroke] = {
            Transparency = if open then 0.85 else 1,
        },
        [self.alphaInput] = {
            TextTransparency = if open then 0.4 else 1,
        },
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
function ColorPicker:_setControlsVisible(visible)
    for _, frame in {
        self.map,
        self.hueBar,
        self.alphaBar,
        self.hexBox,
        self.alphaBox,
    }do
        frame.Visible = visible
    end
end
function ColorPicker:_applyLayout()
    local width = self.main.AbsoluteSize.X
    local mode = if width > 0 and width < narrowWidth then'narrow'else'wide'

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
        variables.tweenService:Create(self.main, openInfo, {
            Size = UDim2.new(1, -20, 0, self._openHeight),
        }):Play()
        variables.tweenService:Create(self.preview, openInfo, {
            Position = self._previewOpenPos,
            Size = self._previewOpenSize,
        }):Play()
    end
end
function ColorPicker:Set(color, skipCallback)
    self.value = coerceColor(color, self.value)
    self.hue, self.sat, self.val = self.value:ToHSV()

    self:_render(if self._isOpen then'animate'else'instant')

    if not skipCallback then
        self:_fireCallback()
        self.window:_persist(self)
    end
end
function ColorPicker:SetAlpha(alpha, skipCallback)
    self.alpha = clamp01(if type(alpha) == 'number'then alpha else self.alpha)

    self:_render(if self._isOpen then'animate'else'instant')

    if not skipCallback then
        self:_fireCallback()
        self.window:_persist(self)
    end
end
function ColorPicker:_serialize()
    return self.value:ToHex() .. string.format('%02x', math.clamp(math.round((self.alpha or 1) * 255), 0, 255))
end
function ColorPicker:_deserialize(raw)
    local hex = tostring(raw)
    local alpha = nil

    if #hex >= 8 then
        alpha = (tonumber(hex:sub(7, 8), 16) or 255) / 255
        hex = hex:sub(1, 6)
    end

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
        w:_reveal(self.preview, {
            BackgroundTransparency = 1 - self.alpha,
        }, animate)
        w:_reveal(self.previewShadow, {
            Transparency = 1 - 0.4 * self.alpha,
        }, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.preview, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.previewShadow, {Transparency = 1}, animate)

        if self._isOpen then
            self:_close()
        end
    end
end

moveable(ColorPicker)
lockable(ColorPicker)

return ColorPicker

end)() end,
    [7] = function()local wax,script,require=ImportGlobals(7)local ImportGlobals return (function(...)local Console = {}

Console.__index = Console
Console.__type = 'Console'

local utility = script.Parent.Parent.utility
local moveable = require(utility.moveable)
local locale = require(utility.locale)
local defaultHeight = 120
local minHeight = 48
local titleHeight = 24
local padding = 17
local textPadding = 12
local textSize = 12
local lineHeight = 1.25
local defaultMaxLines = 200
local monoFont = Font.fromEnum(Enum.Font.Code)

function Console.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name,
        description = properties.description or properties.Description,
        height = math.max(tonumber(properties.height or properties.Height) or defaultHeight, minHeight),
        follow = properties.follow or properties.Follow or false,
        maxLines = math.max(tonumber(properties.maxLines or properties.MaxLines) or defaultMaxLines, 1),
        lines = {},
        lineLabels = {},
        head = 1,
        nextOrder = 1,
        textDirty = true,
    }, Console)

    self:_build()
    self:_setLines(properties.text or properties.Text or '')

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    return self
end
function Console:Get(): string
    if self.textDirty then
        self.text = table.concat(self.lines, '\n')
        self.textDirty = false
    end

    return self.text
end
function Console:_setLines(text)
    text = if type(text) == 'string'then text else tostring(text)

    table.clear(self.lines)

    if text ~= '' then
        for line in string.gmatch(text .. '\n', '([^\n]*)\n')do
            table.insert(self.lines, line)
        end
    end

    self:_trim()
    self:_flush()
end
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
function Console:_makeLabel()
    return self.window:Create('TextLabel', {
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
        RichText = false,
        TextTransparency = self._textTransparency or 1,
        Parent = self.scroll,
    }, {
        TextColor3 = 'ContentColor',
    })
end

local function rowText(line: string): string
    return if line == ''then' 'else line
end

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

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, self.height + top + padding * 2),
        BorderSizePixel = 0,
        Name = self.name or 'Console',
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)

    if self.name then
        self.container = self.window:Create('Frame', {
            Size = UDim2.new(1, -padding * 2, 0, 16),
            Position = UDim2.new(0, padding, 0, padding),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = self.main,
        })
        self.title = self.window:Create('TextLabel', {
            Text = locale.t(self.name),
            Size = UDim2.fromScale(1, 1),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 1,
            Parent = self.container,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })
    end

    self.panel = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -padding),
        Size = UDim2.new(1, -padding * 2, 0, self.height),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'StatBackground',
    })

    self.window:Create('UICorner', {
        Parent = self.panel,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })

    self.panelStroke = self.window:Create('UIStroke', {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Transparency = 1,
        Parent = self.panel,
    }, {
        Color = 'SurfaceStroke',
    })
    self.scroll = self.window:Create('ScrollingFrame', {
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
    self.scrollLayout = self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.scroll,
    })

    self:_watchCanvas()
end
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
function Console:_watchCanvas()
    self.window:ConnectFor(self, self.scrollLayout:GetPropertyChangedSignal('AbsoluteContentSize'), function(
    )
        if self.follow then
            self:_pin()
        end
    end)
end
function Console:Set(text)
    self:_setLines(text)
end
function Console:Append(line)
    line = if type(line) == 'string'then line else tostring(line)

    for part in string.gmatch(line .. '\n', '([^\n]*)\n')do
        self:_pushLine(part)
    end

    self:_follow()
end
function Console:Clear()
    table.clear(self.lines)
    self:_flush()
end
function Console:Copy(): boolean
    local clipboard = (getgenv and getgenv().setclipboard) or setclipboard

    if typeof(clipboard) ~= 'function' then
        return false
    end

    return (pcall(clipboard, self:Get()))
end
function Console:SetHeight(height)
    self.height = math.max(tonumber(height) or defaultHeight, minHeight)

    local top = if self.name then titleHeight else 0

    self.panel.Size = UDim2.new(1, -padding * 2, 0, self.height)
    self.main.Size = UDim2.new(1, -20, 0, self.height + top + padding * 2)
end
function Console:_setShown(shown, animate)
    local w = self.window

    w:_reveal(self.main, {
        BackgroundTransparency = if shown then w.theme.ElementTransparency or 0 else 1,
    }, animate)
    w:_reveal(self.stroke, {
        Transparency = if shown then w.theme.ElementStrokeTransparency else 1,
    }, animate)
    w:_reveal(self.panel, {
        BackgroundTransparency = if shown then 0 else 1,
    }, animate)
    w:_reveal(self.panelStroke, {
        Transparency = if shown then 0.9 else 1,
    }, animate)

    self._textTransparency = if shown then 0.15 else 1

    for _, label in self.lineLabels do
        w:_reveal(label, {
            TextTransparency = self._textTransparency,
        }, animate)
    end

    if self.title then
        w:_reveal(self.title, {
            TextTransparency = if shown then 0 else 1,
        }, animate)
    end
    if self.descriptor then
        w:_reveal(self.descriptor.titleLabel, {
            TextTransparency = if shown then 0.7 else 1,
        }, animate)
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
    [8] = function()local wax,script,require=ImportGlobals(8)local ImportGlobals return (function(...)local Descriptor = {}

Descriptor.__index = Descriptor
Descriptor.__type = 'Descriptor'

local locale = require(script.Parent.Parent.utility.locale)

function Descriptor.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        description = properties.description or properties.Description or '',
    }, Descriptor)

    self.main = self.window:Create('Frame', {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 0),
        Parent = self.tab.tabPage,
    })

    self.window:Create('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.main,
    })

    self.titleLabel = self.window:Create('TextLabel', {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        RichText = true,
        Size = UDim2.new(1, -90, 0, 0),
        Text = locale.t(self.description),
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    self.window:Create('Frame', {
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
    [9] = function()local wax,script,require=ImportGlobals(9)local ImportGlobals return (function(...)local Divider = {}

Divider.__index = Divider
Divider.__type = 'Divider'

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)
local lineThickness = 1
local defaultSpacing = 12
local labelGap = 10
local labelHeight = 14
local textSize = 12
local lineShown = 0.88
local labelShown = 0.55

function Divider.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local spacing = properties.spacing or properties.Spacing
    local text = properties.text or properties.Text
    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        text = if text ~= nil then tostring(text)else'',
        spacing = if type(spacing) == 'number'then math.max(spacing, 0)else defaultSpacing,
        line = properties.line ~= false and properties.Line ~= false,
    }, Divider)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -40, 0, 0),
        BorderSizePixel = 0,
        Name = 'Divider',
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    })

    self.window:Create('UIListLayout', {
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
    if self.text ~= '' then
        self:_buildLabel()
    end

    self:_applyHeight()

    return self
end
function Divider:_buildHalf(order)
    local rule = self.window:Create('Frame', {
        Size = UDim2.new(0, 0, 0, lineThickness),
        BorderSizePixel = 0,
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'ContentColor',
    })

    self.window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Fill,
        Parent = rule,
    })

    return rule
end
function Divider:_buildLabel()
    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.text),
        Size = UDim2.fromOffset(0, labelHeight),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = textSize,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 2,
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    if self.line then
        self.right = self:_buildHalf(3)
    end
end
function Divider:_applyHeight()
    local content = if self.text ~= ''
        then labelHeight
        elseif self.line
        then lineThickness
        else 0

    self.main.Size = UDim2.new(1, -40, 0, self.spacing * 2 + content)
end
function Divider:Set(text)
    self.text = if text ~= nil then tostring(text)else''

    if self.text ~= '' and not self.title then
        self:_buildLabel()

        if not self.window.hidden then
            self:_setShown(true, true)
        end
    end
    if self.title then
        self.window:_bindLocale(self.title, 'Text', self.text)

        local named = self.text ~= ''

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

    w:_reveal(self.left, {BackgroundTransparency = ruleTransparency}, animate)
    w:_reveal(self.right, {BackgroundTransparency = ruleTransparency}, animate)
    w:_reveal(self.title, {
        TextTransparency = if shown then labelShown else 1,
    }, animate)
end

moveable(Divider)

return Divider

end)() end,
    [10] = function()local wax,script,require=ImportGlobals(10)local ImportGlobals return (function(...)local Drag = {}

Drag.__index = Drag
Drag.__type = 'Drag'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local constants = require(utility.constants)

function Drag.new(window, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
    }, Drag)

    self.drag = self.window:Create('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(150, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, self.window.size.Y.Offset / 2 + 15),
        ZIndex = constants.zIndex.drag,
        Visible = false,
        Parent = self.window.screenGui,
    })
    self.dragCosmetic = self.window:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.3),
        ZIndex = constants.zIndex.drag,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 4),
        Parent = self.drag,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 20),
        Parent = self.dragCosmetic,
    })
    self.window:CreateGlow(self.dragCosmetic, Color3.fromRGB(255, 255, 255), 10, 0.5)

    self.dragInteract = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        TextTransparency = 1,
        ZIndex = constants.zIndex.drag,
        Parent = self.drag,
    })

    local dragging = false
    local relative = nil
    local offset = Vector2.zero
    local screenGui = self.window.screenGui

    if screenGui and screenGui.IgnoreGuiInset then
        offset = variables.guiService:GetGuiInset()
    end

    local function getPosition()
        local mouseLocation = variables.userInputService and variables.userInputService:GetMouseLocation() or Vector2.new(0, 0)
        local validRelative = relative or Vector2.new(0, 0)
        local validOffset = offset or Vector2.new(0, 0)

        return mouseLocation + validRelative + validOffset
    end
    local function getTargets()
        local position = getPosition()
        local x, y = position.X, position.Y

        if self.window.settings and self.window.settings.keepOnScreen then
            local size = self.window.main.AbsoluteSize
            local screen = self.window.screenGui.AbsoluteSize
            local margin = 8
            local halfX, halfY = size.X / 2, size.Y / 2

            x = math.clamp(x, halfX + margin, math.max(halfX + margin, screen.X - halfX - margin))
            y = math.clamp(y, halfY + margin, math.max(halfY + margin, screen.Y - halfY - margin))
        end

        local mainTarget = UDim2.fromOffset(x, y)
        local dragTarget = UDim2.fromOffset(x, y + (self.window.main.Size.Y.Offset / 2 + 15))

        return mainTarget, dragTarget
    end

    self.window:Connect(self.drag.MouseEnter, function()
        if not dragging and not self.window.hidden then
            variables.tweenService:Create(self.dragCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.5,
                Size = UDim2.new(0, 120, 0, 4),
            }):Play()
        end
    end)
    self.window:Connect(self.drag.MouseLeave, function()
        if not dragging and not self.window.hidden then
            variables.tweenService:Create(self.dragCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.7,
                Size = UDim2.new(0, 100, 0, 4),
            }):Play()
        end
    end)

    local function releaseDrag()
        if not dragging then
            return
        end

        dragging = false

        if not self.window:_interactive() then
            return
        end

        variables.tweenService:Create(self.dragCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 100, 0, 4),
            BackgroundTransparency = 0.7,
        }):Play()

        local settle = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local mainTarget, dragTarget = getTargets()

        variables.tweenService:Create(self.window.main, settle, {Position = mainTarget}):Play()
        variables.tweenService:Create(self.drag, settle, {Position = dragTarget}):Play()
    end

    self.window:Connect(self.dragInteract.InputBegan, function(
        input,
        processed
    )
        if processed then
            return
        end

        local inputType = input.UserInputType.Name

        if inputType == 'MouseButton1' or inputType == 'Touch' then
            if not self.window:_interactive() then
                return
            end

            dragging = true

            if screenGui and screenGui.IgnoreGuiInset then
                offset = variables.guiService:GetGuiInset()
            end

            relative = self.window.main.AbsolutePosition + self.window.main.AbsoluteSize * self.window.main.AnchorPoint - variables.userInputService:GetMouseLocation()

            if not self.window.hidden then
                variables.tweenService:Create(self.dragCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 110, 0, 4),
                    BackgroundTransparency = 0,
                }):Play()
            end
        end
    end)
    self.window:Connect(variables.userInputService.InputEnded, function(input)
        local inputType = input.UserInputType.Name

        if inputType == 'MouseButton1' or inputType == 'Touch' then
            releaseDrag()
        end
    end)
    self.window:Connect(variables.userInputService.WindowFocusReleased, releaseDrag)

    local mainRemaining = 1e-7
    local barRemaining = 1e-60

    self.window:Connect(variables.runService.RenderStepped, function(dt)
        if not dragging then
            return
        end
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
    [11] = function()local wax,script,require=ImportGlobals(11)local ImportGlobals return (function(...)local Dropdown = {}

Dropdown.__index = Dropdown
Dropdown.__type = 'Dropdown'

local utility = script.Parent.Parent.utility
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
local roundRadius = UDim.new(0, 12)
local flatRadius = UDim.new(0, 7)
local searchCollapsedHeight = 30
local searchExpandedHeight = 38
local optionHeight = 38
local optionGap = 5
local listPadding = 2
local headerHeight = 41
local headerGap = 6
local cardPaddingTop = 7
local cardPaddingBottom = 6
local cardPadding = cardPaddingTop + cardPaddingBottom
local maxVisibleOptions = 4
local actionsHeight = 22
local hintTween = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local hoverTween = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local scrollbarShown = 0.4
local searchTween = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local function dedupStrings(arr)
    local seen = {}
    local out = {}

    for _, v in arr do
        if typeof(v) == 'string' and not seen[v] then
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
    if typeof(value) == 'string' then
        return {value}
    end
    if typeof(value) == 'table' then
        local out = dedupStrings(value)

        if not multi and #out > 1 then
            return {
                out[1],
            }
        end

        return out
    end

    return {}
end
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
    properties = if typeof(properties) == 'table'then properties else{}

    local options = properties.options or properties.Options or {}
    local multiSelect = properties.multiSelect or properties.MultiSelect or properties.MultipleOptions or false
    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Dropdown',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        flag = properties.flag or properties.Flag or (not (properties.forgetState or properties.ForgetState or tab.forgetState) and functions.deriveFlagFromName(properties.name or properties.Name or 'Dropdown') or nil),
        callback = properties.callback or properties.Callback or function() end,
        options = dedupStrings(options),
        multiSelect = multiSelect,
        placeholderText = locale.resolve(properties.placeholder or properties.Placeholder or 'None'),
        value = normalizeValue(properties.value or properties.Value or properties.currentOption or properties.CurrentOption, multiSelect),
        _isOpen = false,
        _optionFrames = {},
    }, Dropdown)

    self._desiredValue = self.value
    self.value = intersectWithOptions(self.value, self.options)

    self.window:_registerControl(self)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    })
    self.top = self.window:Create('Frame', {
        Size = UDim2.new(1, 0, 0, 41),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.main,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.top)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.top)
    self.flashTarget = self.top
    self.container = self.window:Create('Frame', {
        BorderSizePixel = 0,
        Parent = self.top,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 5,
    })
    self.containerLayout = self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            ZIndex = 5,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        ZIndex = 5,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.selectedLabel = self.window:Create('TextLabel', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -41, 0.5, 0),
        Size = UDim2.fromOffset(168, 15),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextWrapped = true,
        TextTransparency = 1,
        ZIndex = 5,
        Parent = self.top,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.chevron = self.window:Create('ImageLabel', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(16, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Image = 'rbxassetid://' .. tostring(chevronIcon),
        Rotation = 180,
        ImageTransparency = 1,
        ZIndex = 5,
        Parent = self.top,
    }, {
        ImageColor3 = 'ContentColor',
    })
    self.interact = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 41),
        Position = UDim2.fromScale(0, 0),
        BorderSizePixel = 0,
        Text = '',
        TextTransparency = 1,
        ZIndex = 10,
        AutoButtonColor = false,
        Parent = self.main,
    })
    self.panel = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        Size = UDim2.new(1, 0, 1, -(headerHeight + headerGap)),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 1,
        BackgroundTransparency = 1,
        Parent = self.main,
    })
    self.panelStroke = self.window:StyleElementPanel(self.panel)

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.panel,
    })
    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, cardPaddingTop),
        PaddingBottom = UDim.new(0, cardPaddingBottom),
        Parent = self.panel,
    })
    self:_buildSearch()
    self:_buildActions()

    self.list = self.window:Create('ScrollingFrame', {
        Active = true,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ScrollBarImageColor3 = Color3.fromRGB(240, 240, 240),
        ScrollBarThickness = 3,
        ScrollBarImageTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 3,
        ZIndex = 1,
        Parent = self.panel,
    })

    self.window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Fill,
        Parent = self.list,
    })
    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal('CanvasPosition'), function(
    )
        self:_syncScrollHint()
    end)
    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal('AbsoluteCanvasSize'), function(
    )
        self:_syncScrollHint()
    end)
    self.window:ConnectFor(self, self.list:GetPropertyChangedSignal('AbsoluteWindowSize'), function(
    )
        self:_syncScrollHint()
    end)

    self.listLayout = self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = self.list,
    })

    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, listPadding),
        PaddingBottom = UDim.new(0, listPadding),
        Parent = self.list,
    })

    self.emptyLabel = self.window:Create('TextLabel', {
        Name = 'Empty',
        Size = UDim2.new(1, -12, 0, optionHeight),
        BackgroundTransparency = 1,
        Text = locale.t('No matches'),
        TextSize = 14,
        TextTransparency = 0.55,
        Visible = false,
        LayoutOrder = 1,
        Parent = self.list,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    local function isOptionSelected(name)
        return table.find(self.value, name) ~= nil
    end
    local function renderOptionState(data, animate)
        local selected = isOptionSelected(data.name)
        local bgT = if self._isOpen then(selected and 0.9 or 0.95)else 1
        local titleT = if self._isOpen then(selected and 0 or 0.3)else 1
        local iconT = if self._isOpen then(selected and 0 or 0.7)else 1
        local strokeT = if self._isOpen then(selected and 0.85 or 0.93)else 1

        image.assign(data.checkIcon, 'Image', if selected then checkIcon else dotIcon)

        if animate then
            local info = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

            variables.tweenService:Create(data.frame, info, {BackgroundTransparency = bgT}):Play()
            variables.tweenService:Create(data.title, info, {TextTransparency = titleT}):Play()
            variables.tweenService:Create(data.checkIcon, info, {ImageTransparency = iconT}):Play()
            variables.tweenService:Create(data.stroke, info, {Transparency = strokeT}):Play()
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
                self.selectedLabel.Text = locale.resolve('Various')
            end
        else
            self.selectedLabel.Text = self.value[1] or self.placeholderText
        end
    end

    self._renderOptionState = renderOptionState
    self._updateSelectedLabel = updateSelectedLabel

    local function buildOption(optionName)
        local frame = self.window:Create('Frame', {
            Size = UDim2.new(1, -12, 0, optionHeight),
            BorderSizePixel = 0,
            LayoutOrder = #self._optionFrames + 1,
            BackgroundTransparency = 1,
            Parent = self.list,
        }, {
            BackgroundColor3 = 'DropdownHighlight',
        })
        local corner = self.window:Create('UICorner', {
            CornerRadius = flatRadius,
            Parent = frame,
        })
        local optionStroke = self.window:Create('UIStroke', {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 1,
            Parent = frame,
        })
        local interact = self.window:Create('TextButton', {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = '',
            TextTransparency = 1,
            ZIndex = 50,
            Parent = frame,
        })
        local container = self.window:Create('Frame', {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 0.5, 0),
            Size = UDim2.fromOffset(170, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = frame,
        })

        self.window:Create('UIListLayout', {
            Padding = UDim.new(0, 5),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = container,
        })

        local checkIcon = self.window:Create('ImageLabel', {
            Image = 'rbxassetid://' .. tostring(checkIcon),
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            ZIndex = 5,
            Parent = container,
        }, {
            ImageColor3 = 'ContentColor',
        })
        local title = self.window:Create('TextLabel', {
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
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })
        local data = {
            name = optionName,
            frame = frame,
            interact = interact,
            title = title,
            checkIcon = checkIcon,
            container = container,
            stroke = optionStroke,
            corner = corner,
            connections = {},
        }

        table.insert(data.connections, self.window:ConnectFor(self, frame.MouseEnter, function(
        )
            if not self._isOpen or not self.window:_interactive() then
                return
            end
            if isOptionSelected(data.name) then
                return
            end

            variables.tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.9}):Play()
            variables.tweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.15}):Play()
        end))
        table.insert(data.connections, self.window:ConnectFor(self, frame.MouseLeave, function(
        )
            if not self._isOpen then
                return
            end
            if isOptionSelected(data.name) then
                return
            end

            variables.tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
            variables.tweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.3}):Play()
        end))
        table.insert(data.connections, self.window:ConnectFor(self, interact.MouseButton1Click, function(
        )
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
        end))

        return data
    end

    self._buildOption = buildOption

    for _, opt in self.options do
        local data = buildOption(opt)

        table.insert(self._optionFrames, data)
    end

    updateSelectedLabel()
    self:_updateCorners()
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        hapticEngine.click()

        if self._isOpen then
            self:_close()
        else
            self:_open()
        end
    end)
    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if self._isOpen or not self.window:_interactive() then
            return
        end

        variables.tweenService:Create(self.title, hoverTween, {
            TextColor3 = self.window.theme.ElementTextHoverColor,
        }):Play()
        variables.tweenService:Create(self.hoverOverlay, hoverTween, {BackgroundTransparency = 0.97}):Play()
        variables.tweenService:Create(self.stroke, hoverTween, {
            Transparency = self.window.theme.ElementStrokeHoverTransparency,
            Color = self.window.theme.ElementStrokeHover,
        }):Play()
    end)
    self.window:ConnectFor(self, self.main.MouseLeave, function()
        variables.tweenService:Create(self.title, hoverTween, {
            TextColor3 = self.window.theme.ContentColor,
        }):Play()
        variables.tweenService:Create(self.hoverOverlay, hoverTween, {BackgroundTransparency = 1}):Play()
        variables.tweenService:Create(self.stroke, hoverTween, {
            Transparency = self.window.theme.ElementStrokeTransparency,
            Color = self.window.theme.ElementStroke,
        }):Play()
    end)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    return self
end
function Dropdown:_callbackValue()
    if self.multiSelect then
        return table.clone(self.value)
    end

    return self.value[1]
end
function Dropdown:_buildSearch()
    self._searchOpen = false
    self.searchbar = self.window:Create('Frame', {
        Name = 'Search',
        Size = UDim2.new(1, -12, 0, searchCollapsedHeight),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ClipsDescendants = false,
        ZIndex = 1,
        Parent = self.panel,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 12),
        Parent = self.searchbar,
    })

    self.searchStroke = self.window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = self.searchbar,
    })
    self.searchShadow = self.window:CreateGlow(self.searchbar, Color3.fromRGB(255, 255, 255), 20, 1)
    self.searchToggle = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = '',
        TextTransparency = 1,
        ZIndex = 51,
        Parent = self.searchbar,
    })
    self.searchInput = self.window:Create('TextBox', {
        Text = '',
        PlaceholderText = locale.t('Search...'),
        Size = UDim2.new(1, -58, 0, 16),
        Position = UDim2.new(0, 44, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        TextEditable = false,
        Interactable = false,
        ZIndex = 52,
        TextTransparency = 1,
        Parent = self.searchbar,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
        PlaceholderColor3 = 'PlaceholderColor',
    })
    self.searchIcon = self.window:Create('ImageButton', {
        Image = 'rbxassetid://' .. tostring(searchIconAsset),
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(0, 24, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        AutoButtonColor = false,
        ZIndex = 53,
        ImageTransparency = 1,
        Parent = self.searchbar,
    }, {
        ImageColor3 = 'ContentColor',
    })

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
    self.window:ConnectFor(self, self.searchInput:GetPropertyChangedSignal('Text'), function(
    )
        self:_applyFilter(self.searchInput.Text)
    end)
    self.window:ConnectFor(self, self.searchInput.FocusLost, function()
        if self.searchInput.Text == '' then
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

    variables.tweenService:Create(self.searchbar, searchTween, {
        Size = UDim2.new(1, -12, 0, searchExpandedHeight),
        BackgroundTransparency = 0.92,
    }):Play()
    variables.tweenService:Create(self.searchStroke, searchTween, {Transparency = 0.86}):Play()
    variables.tweenService:Create(self.searchShadow, searchTween, {Transparency = 0.92}):Play()
    variables.tweenService:Create(self.searchInput, searchTween, {TextTransparency = 0.3}):Play()
    self:_resizeToOptions()
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

    self.searchInput.Text = ''

    variables.tweenService:Create(self.searchbar, searchTween, {
        Size = UDim2.new(1, -12, 0, searchCollapsedHeight),
        BackgroundTransparency = 1,
    }):Play()
    variables.tweenService:Create(self.searchStroke, searchTween, {Transparency = 1}):Play()
    variables.tweenService:Create(self.searchShadow, searchTween, {Transparency = 1}):Play()
    variables.tweenService:Create(self.searchInput, searchTween, {TextTransparency = 1}):Play()
    self:_resizeToOptions()
end
function Dropdown:_applyFilter(query)
    query = string.lower(query or '')

    local shown = 0

    for _, data in self._optionFrames do
        local visible = query == '' or string.find(string.lower(data.name), query, 1, true) ~= nil

        data.frame.Visible = visible

        if visible then
            shown += 1
        end
    end

    self.emptyLabel.Visible = shown == 0 and query ~= ''

    self:_updateCorners()
    self:_resizeToOptions()
    self:_syncScrollHint()
end
function Dropdown:_syncScrollHint()
    local canvasSize, windowSize, at = self.list.AbsoluteCanvasSize, self.list.AbsoluteWindowSize, self.list.CanvasPosition

    if not canvasSize or not windowSize or not at then
        return
    end

    local more = self._isOpen and windowSize.Y > 0 and canvasSize.Y - (at.Y + windowSize.Y) > 1

    variables.tweenService:Create(self.list, hintTween, {
        ScrollBarImageTransparency = if more then scrollbarShown else 1,
    }):Play()
end
function Dropdown:_visibleOptions(): {string}
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
        return
    end

    self.actions = self.window:Create('Frame', {
        Name = 'Actions',
        Size = UDim2.new(1, -12, 0, actionsHeight),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = self.panel,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 12),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.actions,
    })

    local function action(label: string, order: number, apply: () -> ())
        local button = self.window:Create('TextButton', {
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, actionsHeight),
            BackgroundTransparency = 1,
            Text = locale.t(label),
            TextSize = 13,
            TextTransparency = 0.45,
            LayoutOrder = order,
            Parent = self.actions,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })

        self.window:ConnectFor(self, button.MouseEnter, function()
            variables.tweenService:Create(button, hintTween, {TextTransparency = 0.15}):Play()
        end)
        self.window:ConnectFor(self, button.MouseLeave, function()
            variables.tweenService:Create(button, hintTween, {TextTransparency = 0.45}):Play()
        end)
        self.window:ConnectFor(self, button.MouseButton1Click, function()
            apply()
            self:_afterBulkChange()
        end)

        return button
    end

    action('Select all', 1, function()
        local shown = self:_visibleOptions()

        for _, name in shown do
            if not table.find(self.value, name) then
                table.insert(self.value, name)
            end
        end
    end)
    action('Clear', 2, function()
        local shown = self:_visibleOptions()

        for index = #self.value, 1, -1 do
            if table.find(shown, self.value[index]) then
                table.remove(self.value, index)
            end
        end
    end)
end
function Dropdown:_afterBulkChange()
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
function Dropdown:_resizeToOptions()
    if not self._isOpen then
        return
    end

    variables.tweenService:Create(self.main, searchTween, {
        Size = UDim2.new(1, -20, 0, self:_openHeight()),
    }):Play()
end
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
local function rowsThatFit(space: number): number
    return math.max(math.floor((space - listPadding * 2 + optionGap) / (optionHeight + optionGap)), 1)
end

function Dropdown:_pageHeight(): number
    local size = self.window.size

    return windowSizing.pageHeight(size and size.Y.Offset, self.window.layout.mode)
end
function Dropdown:_openHeight()
    local n = 0

    for _, data in self._optionFrames do
        if data.frame.Visible then
            n += 1
        end
    end

    local searchHeight = if self._searchOpen then searchExpandedHeight else searchCollapsedHeight
    local overhead = headerHeight + headerGap + cardPadding + searchHeight + optionGap + (if self.actions then actionsHeight + optionGap else 0)
    local available = self:_pageHeight()
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

    self._outsideClickConn = self.window:Connect(variables.userInputService.InputBegan, function(
        input
    )
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local pos = input.Position
        local mainPos = self.main.AbsolutePosition
        local mainSize = self.main.AbsoluteSize

        if pos.X < mainPos.X or pos.X > mainPos.X + mainSize.X or pos.Y < mainPos.Y or pos.Y > mainPos.Y + mainSize.Y then
            self:_close()
        end
    end)

    variables.tweenService:Create(self.main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, -20, 0, self:_openHeight()),
    }):Play()
    variables.tweenService:Create(self.chevron, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Rotation = 0}):Play()
    variables.tweenService:Create(self.panel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = self.window.theme.ElementTransparency or 0,
    }):Play()
    variables.tweenService:Create(self.panelStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = self.window.theme.ElementStrokeTransparency,
    }):Play()
    variables.tweenService:Create(self.searchIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end

    self:_syncScrollHint()
    self:_bringIntoView()
end
function Dropdown:_bringIntoView()
    local page = self.tab and self.tab.tabPage

    if not page then
        return
    end

    local view, at, pageAt, cardAt = page.AbsoluteWindowSize, page.CanvasPosition, page.AbsolutePosition, self.main.AbsolutePosition

    if not view or not at or not pageAt or not cardAt or view.Y <= 0 then
        return
    end

    local top = cardAt.Y - pageAt.Y + at.Y
    local bottom = top + self:_openHeight()
    local overflow = bottom - (at.Y + view.Y)

    if overflow <= 0 then
        return
    end

    local target = math.min(at.Y + overflow + 8, top)

    variables.tweenService:Create(page, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(at.X, target),
    }):Play()
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
    variables.tweenService:Create(self.chevron, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Rotation = 180}):Play()
    variables.tweenService:Create(self.panel, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    variables.tweenService:Create(self.panelStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1}):Play()
    variables.tweenService:Create(self.searchIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end

    variables.tweenService:Create(self.main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, -20, 0, 41),
    }):Play()
end
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
function Dropdown:_deriveSelection()
    local previous = self.value

    self.value = intersectWithOptions(self._desiredValue or self.value, self.options)

    return not sameSelection(self.value, previous)
end
function Dropdown:_reindexOptions()
    for index, data in self._optionFrames do
        data.frame.LayoutOrder = index
    end
end
function Dropdown:_rebindOption(data, name, index)
    data.name = name
    data.title.Text = name
    data.frame.LayoutOrder = index
end
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
    local existing = #self._optionFrames
    local wanted = #self.options

    for index = 1, math.min(existing, wanted)do
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

    for _, data in self._optionFrames do
        self._renderOptionState(data, false)
    end

    self._updateSelectedLabel()
    self:_applyFilter(if self._searchOpen then self.searchInput.Text else'')

    if selectionChanged then
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end
end
function Dropdown:Add(option)
    if typeof(option) ~= 'string' or option == '' then
        return
    end
    if table.find(self.options, option) then
        return
    end

    table.insert(self.options, option)

    local data = self._buildOption(option)

    table.insert(self._optionFrames, data)

    local selectionChanged = self:_deriveSelection()

    if self._isOpen then
        self._renderOptionState(data, true)
    end

    self:_applyFilter(if self._searchOpen then self.searchInput.Text else'')

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
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end

    self:_applyFilter(if self._searchOpen then self.searchInput.Text else'')
end
function Dropdown:Set(value, skipCallback)
    local newValue = normalizeValue(value, self.multiSelect)

    self._desiredValue = newValue
    self.value = intersectWithOptions(newValue, self.options)

    for _, data in self._optionFrames do
        self._renderOptionState(data, true)
    end

    self._updateSelectedLabel()

    if not skipCallback then
        self.window:_runGuarded(self, self.callback, self:_callbackValue())
        self.window:_persist(self)
    end
end
function Dropdown:_setShown(shown, animate)
    local w = self.window

    w:_reveal(self.stroke, {
        Transparency = if shown then w.theme.ElementStrokeTransparency else 1,
    }, animate)
    w:_reveal(self.title, {
        TextTransparency = if shown then 0 else 1,
    }, animate)
    w:_reveal(self.top, {
        BackgroundTransparency = if shown then(w.theme.ElementTransparency or 0)else 1,
    }, animate)

    if self.iconLabel then
        w:_reveal(self.iconLabel, {
            ImageTransparency = if shown then 0 else 1,
        }, animate)
    end
    if self.descriptor then
        w:_reveal(self.descriptor.titleLabel, {
            TextTransparency = if shown then 0.7 else 1,
        }, animate)
    end

    w:_reveal(self.selectedLabel, {
        TextTransparency = if shown then 0.5 else 1,
    }, animate)
    w:_reveal(self.chevron, {
        ImageTransparency = if shown then 0.5 else 1,
    }, animate)

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
    [12] = function()local wax,script,require=ImportGlobals(12)local ImportGlobals return (function(...)local Group = {}

Group.__index = Group
Group.__type = 'Group'

local moveable = require(script.Parent.Parent.utility.moveable)
local log = require(script.Parent.Parent.utility.log)
local assignOrder = require(script.Parent.Parent.utility.ordering)
local elementPadding = 8
local compactCapable = {
    button = true,
    toggle = true,
    stat = true,
    slider = true,
}

function Group.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local dir = string.lower(properties.direction or properties.Direction or 'row')
    local vertical = dir == 'column' or dir == 'vertical'
    local horizontal = not vertical
    local direction = if horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical
    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        direction = direction,
        compact = horizontal,
        forgetState = tab.forgetState,
        elements = {},
    }, Group)
    local nestedInRow = tab.direction == Enum.FillDirection.Horizontal

    self.main = self.window:Create('Frame', {
        Name = 'Group',
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = if horizontal then UDim2.new(1, -20, 0, 0)else UDim2.new(1, 0, 0, 0),
        Parent = self.tab.tabPage,
    })

    if nestedInRow then
        self.main.Size = UDim2.new(0, 0, 0, 0)

        self.window:Create('UIFlexItem', {
            FlexMode = Enum.UIFlexMode.Fill,
            Parent = self.main,
        })
    end

    self.tabPage = self.main
    self.layout = self.window:Create('UIListLayout', {
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
        log.warn(`Slate: a row only holds compact elements (button/toggle/stat/slider), ignoring '{componentName}'. Use a column for it.`)

        return nil
    end

    local element = require(script.Parent[componentName]).new(self, properties)

    table.insert(self.elements, element)
    assignOrder(element, #self.elements * 10)
    self.window:_restoreLate(element)

    if self.compact then
        self:_wrapChild(element)
    end

    self:_reflowRow()

    if not self.window.hidden then
        element:_setShown(true, true)
    end

    return element
end
function Group:_reflowRow()
    if self.direction ~= Enum.FillDirection.Horizontal then
        return
    end

    local onlyGroups = #self.elements > 0

    for _, element in self.elements do
        if element.__type ~= 'Group' then
            onlyGroups = false

            break
        end
    end

    self.layout.Padding = if onlyGroups then UDim.new(0, -10)else UDim.new(0, elementPadding)
end
function Group:_wrapChild(element)
    self.layout.Wraps = true
    self.layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
    element._widthManaged = true

    local minWidth = if element._minWidth then element:_minWidth()else 0

    if minWidth > 0 then
        element.main.AutomaticSize = Enum.AutomaticSize.None
        element.main.Size = UDim2.new(0, minWidth, element.main.Size.Y.Scale, element.main.Size.Y.Offset)
    end
end
function Group:CreateButton(properties)
    return self:_add('button', properties)
end
function Group:CreateToggle(properties)
    return self:_add('toggle', properties)
end
function Group:CreateSwitch(properties)
    return self:_add('toggle', properties)
end
function Group:CreateStat(properties)
    return self:_add('stat', properties)
end
function Group:CreateSlider(properties)
    return self:_add('slider', properties)
end
function Group:CreateDropdown(properties)
    return self:_add('dropdown', properties)
end
function Group:CreateSection(properties)
    return self:_add('section', properties)
end
function Group:CreateText(properties)
    return self:_add('text', properties)
end
function Group:CreateDivider(properties)
    return self:_add('divider', properties)
end
function Group:_addGroup(properties)
    properties = if typeof(properties) == 'table'then table.clone(properties)else{}

    if self.direction == Enum.FillDirection.Horizontal then
        self.layout.VerticalAlignment = Enum.VerticalAlignment.Top

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
function Group:_setShown(shown, animate)
    for _, el in self.elements do
        el:_setShown(shown, animate)
    end
end
function Group:_refreshTheme()
    for _, el in self.elements do
        if el._refreshTheme then
            el:_refreshTheme()
        end
    end
end

moveable(Group)

return Group

end)() end,
    [13] = function()local wax,script,require=ImportGlobals(13)local ImportGlobals return (function(...)local Input = {}

Input.__index = Input
Input.__type = 'Input'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local constants = require(utility.constants)
local hapticEngine = require(utility.HapticEngine)
local resizeInfo = constants.pillResizeInfo
local focusInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function parseExp(text)
    local a, b = text:match('^([%d%.%-]+)%^([%d%.%-]+)$')

    if a and b then
        local na, nb = tonumber(a), tonumber(b)

        if na and nb then
            return na ^ nb
        end
    end

    return tonumber(text)
end

function Input.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Input',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        placeholder = properties.placeholder or properties.Placeholder or '',
        numeric = properties.numeric or properties.Numeric or false,
        clearOnFocus = properties.clearOnFocus or properties.ClearOnFocus or false,
        callback = properties.callback or properties.Callback or function() end,
    }, Input)

    self.value = tostring(properties.value or properties.Value or properties.currentValue or properties.CurrentValue or '')
    self.flag = properties.flag or properties.Flag or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)

    self.window:_registerControl(self)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)
    self.container = self.window:Create('Frame', {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.box = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0, 20),
        Size = UDim2.fromOffset(85, 30),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'FieldBackground',
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.box,
    })

    self.boxStroke = self.window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.box,
    }, {
        Color = 'SurfaceStroke',
    })
    self.glow = self.window:CreateGlow(self.box, 'FieldGlow', 20, 1)
    self._glowIdle = 1
    self.input = self.window:Create('TextBox', {
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
        TextTransparency = 1,
        Parent = self.box,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
        PlaceholderColor3 = 'PlaceholderColor',
    })

    self.window:ConnectFor(self, self.input:GetPropertyChangedSignal('Text'), function(
    )
        if self.numeric then
            local cleaned = (self.input.Text:gsub('[^%d%.%-eE%^]', ''))

            if cleaned ~= self.input.Text then
                self.input.Text = cleaned

                return
            end
        end

        self:_sizeBox(true)
    end)
    self.window:ConnectFor(self, self.input.Focused, function()
        variables.tweenService:Create(self.input, focusInfo, {TextTransparency = 0}):Play()
    end)
    self.window:ConnectFor(self, self.input.FocusLost, function()
        variables.tweenService:Create(self.input, focusInfo, {TextTransparency = 0.6}):Play()

        if self.clearOnFocus and self.input.Text == '' and self.value ~= '' then
            self.input.Text = self.value

            return
        end
        if self.input.Text == self.value then
            return
        end

        self:_commit(self.input.Text)
    end)
    self.window:_wireElementHover(self)

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    self:_sizeBox(false)

    return self
end
function Input:_sizeBox(animate)
    local shown = self.input.Text ~= '' and self.input.Text or self.placeholder
    local width = math.clamp(functions.textWidth(self.window.theme.Font, 15, shown) + 30, 70, 220)

    if animate then
        variables.tweenService:Create(self.box, resizeInfo, {
            Size = UDim2.fromOffset(width, 30),
        }):Play()
    else
        self.box.Size = UDim2.fromOffset(width, 30)
    end
end
function Input:_commit(text, silent)
    text = tostring(text)

    if self.numeric then
        local n = parseExp(text)

        if not n or n ~= n or n == math.huge or n == -math.huge then
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
        w:_reveal(self.box, {
            BackgroundTransparency = w.theme.FieldTransparency,
        }, animate)
        w:_reveal(self.boxStroke, {Transparency = 0.85}, animate)
        w:_reveal(self.input, {TextTransparency = 0.6}, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.box, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.boxStroke, {Transparency = 1}, animate)
        w:_reveal(self.input, {TextTransparency = 1}, animate)
    end
end
function Input:_refreshTheme()
    variables.tweenService:Create(self.box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = self.window.theme.FieldTransparency,
    }):Play()
end

moveable(Input)
lockable(Input)

return Input

end)() end,
    [14] = function()local wax,script,require=ImportGlobals(14)local ImportGlobals return (function(...)local Keybind = {}

Keybind.__index = Keybind
Keybind.__type = 'Keybind'

local utility = script.Parent.Parent.utility
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
local mouseNames = {
    [Enum.UserInputType.MouseButton1] = 'MB1',
    [Enum.UserInputType.MouseButton2] = 'MB2',
    [Enum.UserInputType.MouseButton3] = 'MB3',
}

local function keyName(value)
    if typeof(value) ~= 'EnumItem' or value == Enum.KeyCode.Unknown then
        return 'None'
    end

    return mouseNames[value] or value.Name
end
local function coerceKey(value)
    if typeof(value) == 'EnumItem' then
        return value
    end
    if type(value) == 'string' then
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
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Keybind',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        isMenuToggle = properties.isMenuToggle or properties.IsMenuToggle or false,
        callback = properties.callback or properties.Callback or function() end,
        onChanged = properties.onChanged or properties.OnChanged or function() end,
        hold = properties.hold or properties.Hold or false,
        holdThreshold = properties.holdThreshold or properties.HoldThreshold or 0.2,
        recording = false,
    }, Keybind)

    self.value = coerceKey(properties.value or properties.Value or properties.default or properties.Default)
    self.flag = properties.flag or properties.Flag or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)

    self.window:_registerControl(self)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)
    self.hoverOverlay = self.window:CreateHoverOverlay(self.main)
    self.container = self.window:Create('Frame', {
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(150, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.box = self.window:Create('TextButton', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0, 20),
        Size = UDim2.fromOffset(40, 30),
        AutoButtonColor = false,
        Text = '',
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'FieldBackground',
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.box,
    })

    self.boxStroke = self.window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.box,
    }, {
        Color = 'SurfaceStroke',
    })
    self.glow = self.window:CreateGlow(self.box, 'FieldGlow', 20, 1)
    self._glowIdle = 0.9
    self.keyLabel = self.window:Create('TextLabel', {
        Text = keyName(self.value),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 2,
        TextTransparency = 1,
        Parent = self.box,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    self.window:ConnectFor(self, self.box.MouseButton1Click, function()
        hapticEngine.click()

        if self.recording then
            self:_stopRecording()
        else
            self:_startRecording()
        end
    end)
    self.window:ConnectFor(self, variables.userInputService.InputBegan, function(
        input,
        processed
    )
        if processed then
            return
        end
        if self.recording then
            self:_capture(input)

            return
        end
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
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    self:_sizeBox(false)

    return self
end
function Keybind:_sizeBox(animate)
    local width = math.clamp(functions.textWidth(self.window.theme.Font, 15, self.keyLabel.Text) + 28, 40, 200)

    if animate then
        variables.tweenService:Create(self.box, resizeInfo, {
            Size = UDim2.fromOffset(width, 30),
        }):Play()
    else
        self.box.Size = UDim2.fromOffset(width, 30)
    end
end
function Keybind:_startRecording()
    local current = self.window._recordingKeybind

    if current and current ~= self then
        current:_stopRecording()
    end

    self.recording = true
    self.window._recordingKeybind = self
    self.keyLabel.Text = locale.resolve('Recording')

    self:_sizeBox(true)
    variables.tweenService:Create(self.glow, recordInfo, {Transparency = 0.7}):Play()
    variables.tweenService:Create(self.keyLabel, recordInfo, {TextTransparency = 0}):Play()
end
function Keybind:_stopRecording()
    self.recording = false

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
    variables.tweenService:Create(self.glow, recordInfo, {Transparency = 0.9}):Play()
    variables.tweenService:Create(self.keyLabel, recordInfo, {TextTransparency = 0.6}):Play()
end
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
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
        key = input.UserInputType
    end
    if not key then
        return
    end
    if self.isMenuToggle then
        local clash = self.window:_keybindUsing(key, self)

        if clash then
            self.window:Notify({
                title = locale.resolve('Keybind unavailable'),
                content = string.format(locale.resolve('%s is bound to %s. Kept %s.'), keyName(key), clash.name, keyName(self.value)),
            })
            self:_stopRecording()
            self.window:_flashResult(self, false)

            return
        end
    elseif key == self.window.settings.toggleKeybind then
        self.window:Notify({
            title = locale.resolve('Keybind unavailable'),
            content = string.format(locale.resolve('%s is the menu toggle key. Kept %s.'), keyName(key), keyName(self.value)),
        })
        self:_stopRecording()
        self.window:_flashResult(self, false)

        return
    end

    self:_bind(key)
end
function Keybind:_bind(key)
    self.value = key

    self:_stopRecording()
    self.window:_runGuarded(self, self.onChanged, key)
    self.window:_persist(self)
    self.window:_flashResult(self, true)
end
function Keybind:_matches(input)
    local v = self.value

    if typeof(v) ~= 'EnumItem' or v == Enum.KeyCode.Unknown then
        return false
    end
    if v.EnumType == Enum.KeyCode then
        return input.KeyCode == v
    elseif v.EnumType == Enum.UserInputType then
        return input.UserInputType == v
    end

    return false
end
function Keybind:_beginHold(input)
    if self._holding or self._holdPress then
        return
    end

    local press = {}

    self._holdPress = press

    local heldKeyCode = input.KeyCode
    local heldInputType = input.UserInputType

    task.delay(self.holdThreshold, function()
        if self._holdPress ~= press then
            return
        end

        self._holding = true

        self.window:_runGuarded(self, self.callback, true)
    end)

    local conn

    conn = self.window:ConnectFor(self, variables.userInputService.InputEnded, function(
        ended
    )
        local released = if heldKeyCode ~= Enum.KeyCode.Unknown then ended.KeyCode == heldKeyCode else ended.UserInputType == heldInputType

        if not released then
            return
        end
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

    if key ~= Enum.KeyCode.Unknown then
        if self.isMenuToggle then
            local clash = self.window:_keybindUsing(key, self)

            if clash then
                log.warn('Slate: ' .. keyName(key) .. " is bound to '" .. tostring(clash.name) .. "'; kept " .. keyName(self.value))

                return
            end
        elseif key == self.window.settings.toggleKeybind then
            log.warn('Slate: ' .. keyName(key) .. ' is the menu toggle key; kept ' .. keyName(self.value))

            return
        end
    end

    self.value = key

    if self.recording then
        self:_stopRecording()
    else
        self.keyLabel.Text = keyName(self.value)

        self:_sizeBox(true)
    end
    if not skipChanged then
        self.window:_runGuarded(self, self.onChanged, self.value)
        self.window:_persist(self)
    end
end
function Keybind:_serialize()
    return {
        tostring(self.value.EnumType),
        self.value.Value,
    }
end
function Keybind:_deserialize(raw)
    local enumName = tostring(raw[1]):gsub('^Enum%.', '')
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
        w:_reveal(self.box, {
            BackgroundTransparency = w.theme.FieldTransparency,
        }, animate)
        w:_reveal(self.boxStroke, {Transparency = 0.85}, animate)
        w:_reveal(self.keyLabel, {TextTransparency = 0.6}, animate)
        w:_reveal(self.glow, {Transparency = 0.9}, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.box, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.boxStroke, {Transparency = 1}, animate)
        w:_reveal(self.keyLabel, {TextTransparency = 1}, animate)
        w:_reveal(self.glow, {Transparency = 1}, animate)
    end
end
function Keybind:_refreshTheme()
    variables.tweenService:Create(self.box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = self.window.theme.FieldTransparency,
    }):Play()
end

moveable(Keybind)
lockable(Keybind)

return Keybind

end)() end,
    [15] = function()local wax,script,require=ImportGlobals(15)local ImportGlobals return (function(...)local Notification = {}

Notification.__index = Notification
Notification.__type = 'Notification'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local hapticEngine = require(utility.HapticEngine)
local growInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local swipeInInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local shrinkInfo = TweenInfo.new(0.9, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local offscreenRight = UDim2.new(0.5, 360, 0.5, 0)
local centred = UDim2.new(0.5, 0, 0.5, 0)
local maxLive = 6
local stackPadding = 8

local function autoDuration(content)
    return math.clamp(#content * 0.06 + 3, 3, 9)
end

function Notification.new(window, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        title = properties.title or properties.Title or 'Notification',
        content = properties.content or properties.Content or '',
        icon = properties.icon or properties.Icon or 136661212895058,
        _hovered = false,
        _dismissed = false,
    }, Notification)

    self.duration = properties.duration or properties.Duration or autoDuration(self.content)

    local hasIcon = self.icon ~= nil and self.icon ~= 0 and self.icon ~= ''

    self.main = self.window:Create('Frame', {
        Name = 'Notification',
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.notification,
        Parent = self.window.notifications,
    })

    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, stackPadding),
        Parent = self.main,
    })

    self.body = self.window:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 1, 0),
        Position = offscreenRight,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true,
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.notification,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UIGradient', {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),
        Parent = self.body,
    }, {
        Color = {
            'WindowColor',
            functions.toColorSequence,
        },
    })
    self.window:Create('UICorner', {
        Parent = self.body,
    }, {
        CornerRadius = 'CornerRoundness',
    })

    self.stroke = self.window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.body,
    }, {
        Color = 'SurfaceStroke',
    })
    self.shadow = self.window:CreateGlow(self.body, 'ShadowColor', 20, 1)

    self.window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = self.body,
    })
    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 12),
        Parent = self.body,
    })

    if hasIcon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(26, 26),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = constants.zIndex.notification,
            ImageTransparency = 1,
            Parent = self.body,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.container = self.window:Create('Frame', {
        Size = UDim2.fromOffset(hasIcon and 224 or 260, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.notification,
        Parent = self.body,
    })

    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = self.container,
    })

    self.titleLabel = self.window:Create('TextLabel', {
        Text = self.title,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        ZIndex = constants.zIndex.notification,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'TitleFont',
    })

    if self.content ~= '' then
        self.descriptionLabel = self.window:Create('TextLabel', {
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
            TextTransparency = 1,
            Parent = self.container,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })
    end

    self.window._notificationCount = (self.window._notificationCount or 0) + 1
    self.main.LayoutOrder = self.window._notificationCount

    local live = self.window._liveNotifications

    if not live then
        live = {}
        self.window._liveNotifications = live
    end

    table.insert(live, self)

    while#live > maxLive do
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                self:_dismiss()
            end
        end),
    }

    task.spawn(function()
        self:_show()
    end)

    return self
end
function Notification:_measure()
    local colWidth = self.iconLabel and 224 or 260
    local contentH = functions.textHeight(self.window.theme.TitleFont, 16, self.title, colWidth)

    if self.descriptionLabel then
        contentH = contentH + 4 + functions.textHeight(self.window.theme.Font, 15, self.content, colWidth)
    end

    return math.max(contentH, self.iconLabel and 26 or 0) + 28
end
function Notification:_show()
    local target = self:_measure() + stackPadding

    if self._dismissed or not self.main.Parent then
        return
    end

    hapticEngine.notify()
    variables.tweenService:Create(self.main, growInfo, {
        Size = UDim2.new(1, 0, 0, target),
    }):Play()
    variables.tweenService:Create(self.body, swipeInInfo, {Position = centred}):Play()
    variables.tweenService:Create(self.body, fadeLong, {BackgroundTransparency = 0}):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, {TextTransparency = 0}):Play()
    variables.tweenService:Create(self.stroke, fadeLong, {Transparency = 0.95}):Play()
    variables.tweenService:Create(self.shadow, fadeShort, {Transparency = 0.6}):Play()
    task.wait(0.05)

    if self._dismissed or not self.main.Parent then
        return
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, {ImageTransparency = 0}):Play()
    end

    task.wait(0.05)

    if self._dismissed or not self.main.Parent then
        return
    end
    if self.descriptionLabel then
        variables.tweenService:Create(self.descriptionLabel, fadeShort, {TextTransparency = 0.35}):Play()
    end

    local elapsed = 0

    while elapsed < self.duration and not self._dismissed and self.main.Parent do
        local dt = task.wait()

        if not self._hovered then
            elapsed += dt
        end
    end

    self:_dismiss()
end
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

    variables.tweenService:Create(self.body, fadeLong, {BackgroundTransparency = 1}):Play()
    variables.tweenService:Create(self.stroke, fadeLong, {Transparency = 1}):Play()
    variables.tweenService:Create(self.shadow, fadeShort, {Transparency = 1}):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, {TextTransparency = 1}):Play()

    if self.descriptionLabel then
        variables.tweenService:Create(self.descriptionLabel, fadeShort, {TextTransparency = 1}):Play()
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, {ImageTransparency = 1}):Play()
    end

    variables.tweenService:Create(self.body, shrinkInfo, {
        Size = UDim2.new(1, -90, 1, 0),
    }):Play()

    local collapse = variables.tweenService:Create(self.main, shrinkInfo, {
        Size = UDim2.new(1, 0, 0, 0),
    })

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
    [16] = function()local wax,script,require=ImportGlobals(16)local ImportGlobals return (function(...)local Popup = {}

Popup.__index = Popup
Popup.__type = 'Popup'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local locale = require(utility.locale)
local log = require(utility.log)
local hapticEngine = require(utility.HapticEngine)
local enterInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local backdropInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local cardWidth = 400
local sidePadding = 22
local topPadding = 24
local bottomPadding = 22
local regionGap = 16
local innerWidth = cardWidth - sidePadding * 2
local titleSize = 18
local subtitleSize = 14
local contentSize = 15
local headerIconSize = 16
local headerIconGap = 12
local maxContentHeight = 300
local contentInset = 4
local contentWidth = innerWidth - contentInset * 2
local boxSidePad = 16
local boxVerticalPad = 13
local boxIconSize = 20
local boxIconGap = 10
local boxTitleSize = 15
local boxDescSize = 14
local boxGap = 8
local boxWidthInset = 10
local buttonHeight = 40
local buttonGap = 8
local buttonCorner = UDim.new(1, 0)
local buttonTextSize = 16
local backdropShown = 0.5
local stack = {}
local consumedEscape = nil

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
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        title = properties.title or properties.Title or 'Popup',
        subtitle = properties.subtitle or properties.Subtitle,
        content = properties.content or properties.Content,
        icon = properties.icon or properties.Icon,
        boxes = properties.boxes or properties.Boxes,
        options = properties.options or properties.Options,
        dismissable = if properties.dismissable ~= nil
            then properties.dismissable
            elseif properties.Dismissable ~= nil
            then properties.Dismissable
            else true,
        _reveal = {},
        _connections = {},
        _closed = false,
    }, Popup)

    if not self.options or #self.options == 0 then
        self.options = {
            {
                text = 'Okay',
            },
        }
    end

    self:_build()
    pruneStack()
    table.insert(stack, self)
    task.spawn(function()
        self:_show()
    end)

    return self
end
function Popup:_fade(instance, prop, to)
    table.insert(self._reveal, {
        instance = instance,
        prop = prop,
        to = to,
    })

    return instance
end
function Popup:_build()
    local window = self.window
    local hasIcon = self.icon ~= nil and self.icon ~= 0 and self.icon ~= ''

    self.screenGui = window:Create('ScreenGui', {
        Name = variables.httpService:GenerateGUID(false),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Enabled = true,
        DisplayOrder = constants.displayOrder.popup,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = variables.guiContainer,
    })
    self.backdrop = window:Create('Frame', {
        Name = 'Backdrop',
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Active = true,
        BackgroundTransparency = 1,
        Parent = self.screenGui,
    })

    self:_fade(self.backdrop, 'BackgroundTransparency', backdropShown)

    self.card = window:Create('Frame', {
        Name = 'Card',
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 14),
        Size = UDim2.fromOffset(cardWidth, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Active = true,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = self.screenGui,
    })

    self:_fade(self.card, 'BackgroundTransparency', 0)
    window:Create('UIGradient', {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),
        Parent = self.card,
    }, {
        Color = {
            'WindowColor',
            functions.toColorSequence,
        },
    })
    window:Create('UICorner', {
        Parent = self.card,
    }, {
        CornerRadius = 'CornerRoundness',
    })

    self.cardStroke = window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.card,
    }, {
        Color = 'SurfaceStroke',
    })

    self:_fade(self.cardStroke, 'Transparency', 0.95)

    self.cardShadow = window:CreateGlow(self.card, 'ShadowColor', 26, 1)

    self:_fade(self.cardShadow, 'Transparency', 0.55)
    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, sidePadding),
        PaddingRight = UDim.new(0, sidePadding),
        PaddingTop = UDim.new(0, topPadding),
        PaddingBottom = UDim.new(0, bottomPadding),
        Parent = self.card,
    })
    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, regionGap),
        Parent = self.card,
    })

    local headerHeight = self:_measureHeader(hasIcon)

    self:_buildHeader(hasIcon, headerHeight)

    local contentHeight = self:_buildContent()

    self:_buildFooter()

    local regions = 2 + (contentHeight > 0 and 1 or 0)
    local cardHeight = topPadding + headerHeight + contentHeight + buttonHeight + bottomPadding + regionGap * (regions - 1)

    self.card.Size = UDim2.fromOffset(cardWidth, cardHeight)
    self.card.AutomaticSize = Enum.AutomaticSize.None

    if self.dismissable then
        table.insert(self._connections, window:Connect(self.backdrop.InputBegan, function(
            input
        )
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                self:Close()
            end
        end))
        table.insert(self._connections, window:Connect(variables.userInputService.InputBegan, function(
            input,
            processed
        )
            if not processed and input.KeyCode == Enum.KeyCode.Escape and topmost(self) then
                if input == consumedEscape then
                    return
                end

                consumedEscape = input

                self:Close()
            end
        end))
    end
end
function Popup:_buildHeader(hasIcon, headerHeight)
    local window = self.window
    local header = window:Create('Frame', {
        Name = 'Header',
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        LayoutOrder = 1,
        Parent = self.card,
    })

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, headerIconGap),
        Parent = header,
    })

    if hasIcon then
        self:_fade(window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(headerIconSize, headerIconSize),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ImageTransparency = 1,
            Parent = header,
        }, {
            ImageColor3 = 'TitlingColor',
        }), 'ImageTransparency', 0)
    end

    local textColumn = window:Create('Frame', {
        Name = 'Text',
        BackgroundTransparency = 1,
        Size = UDim2.new(1, hasIcon and -(headerIconSize + headerIconGap) or 0, 0, self._columnH),
        LayoutOrder = 2,
        Parent = header,
    })

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
        Parent = textColumn,
    })
    self:_fade(window:Create('TextLabel', {
        Text = locale.t(self.title),
        Size = UDim2.new(1, 0, 0, self._titleH),
        BackgroundTransparency = 1,
        TextSize = titleSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = textColumn,
    }, {
        TextColor3 = 'TitlingColor',
        FontFace = 'Font',
    }), 'TextTransparency', 0)

    if self.subtitle and self.subtitle ~= '' then
        self:_fade(window:Create('TextLabel', {
            Text = locale.t(self.subtitle),
            Size = UDim2.new(1, 0, 0, self._subH),
            BackgroundTransparency = 1,
            TextSize = subtitleSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            TextTransparency = 1,
            Parent = textColumn,
        }, {
            TextColor3 = 'TitlingColor',
            FontFace = 'Font',
        }), 'TextTransparency', 0.55)
    end
end
function Popup:_buildContent()
    if (not self.content or self.content == '') and (not self.boxes or #self.boxes == 0) then
        return 0
    end

    local window = self.window
    local measured = if self.boxes and #self.boxes > 0 then self:_measureBoxes()else self:_measureText()
    local viewHeight = math.min(measured, maxContentHeight) + contentInset * 2
    local content = window:Create('ScrollingFrame', {
        Name = 'Content',
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, viewHeight),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 2,
        ScrollBarImageTransparency = 1,
        Parent = self.card,
    })

    self:_fade(content, 'ScrollBarImageTransparency', 0.8)
    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, contentInset),
        PaddingRight = UDim.new(0, contentInset),
        PaddingTop = UDim.new(0, contentInset),
        PaddingBottom = UDim.new(0, contentInset),
        Parent = content,
    })

    if self.boxes and #self.boxes > 0 then
        window:Create('UIListLayout', {
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
        self:_fade(window:Create('TextLabel', {
            Text = locale.t(self.content),
            Size = UDim2.new(1, 0, 0, measured),
            BackgroundTransparency = 1,
            TextSize = contentSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            TextTransparency = 1,
            Parent = content,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        }), 'TextTransparency', 0.5)
    end

    return viewHeight
end
function Popup:_buildBox(parent, box, order)
    local window = self.window

    box = if typeof(box) == 'table'then box else{
        title = tostring(box),
    }

    local hasIcon = box.icon ~= nil and box.icon ~= 0 and box.icon ~= ''
    local frameH, titleH, descH, columnH = self:_measureBox(box)
    local frame = window:Create('Frame', {
        Name = 'Box',
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -boxWidthInset, 0, frameH),
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    self:_fade(frame, 'BackgroundTransparency', 0)

    local stroke = window:StyleElementPanel(frame)

    self:_fade(stroke, 'Transparency', window.theme.ElementStrokeTransparency)
    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, boxSidePad),
        PaddingRight = UDim.new(0, boxSidePad),
        PaddingTop = UDim.new(0, boxVerticalPad),
        PaddingBottom = UDim.new(0, boxVerticalPad),
        Parent = frame,
    })
    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, boxIconGap),
        Parent = frame,
    })

    if hasIcon then
        self:_fade(window:Create('ImageLabel', {
            Image = box.icon,
            Size = UDim2.fromOffset(boxIconSize, boxIconSize),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ImageTransparency = 1,
            Parent = frame,
        }, {
            ImageColor3 = 'ContentColor',
        }), 'ImageTransparency', 0)
    end

    local textColumn = window:Create('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, hasIcon and -(boxIconSize + boxIconGap) or 0, 0, columnH),
        LayoutOrder = 2,
        Parent = frame,
    })

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
        Parent = textColumn,
    })
    self:_fade(window:Create('TextLabel', {
        Text = locale.t(box.title or box.Title or ''),
        Size = UDim2.new(1, 0, 0, titleH),
        BackgroundTransparency = 1,
        TextSize = boxTitleSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = textColumn,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'TitleFont',
    }), 'TextTransparency', 0)

    local description = box.description or box.Description

    if description and description ~= '' then
        self:_fade(window:Create('TextLabel', {
            Text = locale.t(description),
            Size = UDim2.new(1, 0, 0, descH),
            BackgroundTransparency = 1,
            TextSize = boxDescSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            LayoutOrder = 2,
            TextTransparency = 1,
            Parent = textColumn,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        }), 'TextTransparency', 0.65)
    end
end
function Popup:_buildFooter()
    local window = self.window
    local footer = window:Create('Frame', {
        Name = 'Footer',
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, buttonHeight),
        LayoutOrder = 3,
        Parent = self.card,
    })

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, buttonGap),
        Parent = footer,
    })

    for index, option in self.options do
        self:_buildButton(footer, option, index)
    end
end
function Popup:_buildButton(parent, option, order)
    local window = self.window

    option = if typeof(option) == 'table'then option else{
        text = tostring(option),
    }

    local style = option.style or option.Style or 'neutral'
    local label = option.text or option.Text or option.name or option.Name or 'Okay'
    local callback = option.callback or option.Callback
    local restColor, hoverColor, edgeColor, strokeShown

    if style == 'primary' then
        restColor, hoverColor, edgeColor, strokeShown = window.theme.AccentColor, window.theme.AccentStroke, window.theme.AccentStroke, 0.1
    elseif style == 'danger' then
        restColor, hoverColor, edgeColor, strokeShown = window.theme.ErrorColor, window.theme.ErrorStrokeColor, window.theme.ErrorStrokeColor, 0
    else
        restColor, hoverColor, edgeColor, strokeShown = window.theme.NeutralButton, window.theme.NeutralButtonHover, window.theme.NeutralButtonStroke, 0.85
    end

    local button = window:Create('Frame', {
        Name = 'Button',
        BackgroundColor3 = restColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, buttonHeight),
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Parent = parent,
    })

    self:_fade(button, 'BackgroundTransparency', 0)
    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Fill,
        Parent = button,
    })
    window:Create('UICorner', {
        CornerRadius = buttonCorner,
        Parent = button,
    })

    local stroke = window:Create('UIStroke', {
        Color = edgeColor,
        Transparency = 1,
        Parent = button,
    })

    self:_fade(stroke, 'Transparency', strokeShown)
    self:_fade(window:Create('TextLabel', {
        Text = locale.t(label),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        TextSize = buttonTextSize,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextColor3 = functions.contrastText(restColor),
        TextTransparency = 1,
        Parent = button,
    }, {
        FontFace = 'Font',
    }), 'TextTransparency', 0)

    local interact = window:Create('TextButton', {
        Text = '',
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = button,
    })
    local hoverInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    table.insert(self._connections, window:Connect(interact.MouseEnter, function(
    )
        if self._closed then
            return
        end

        variables.tweenService:Create(button, hoverInfo, {BackgroundColor3 = hoverColor}):Play()
    end))
    table.insert(self._connections, window:Connect(interact.MouseLeave, function(
    )
        variables.tweenService:Create(button, hoverInfo, {BackgroundColor3 = restColor}):Play()
    end))
    table.insert(self._connections, window:Connect(interact.MouseButton1Click, function(
    )
        if self._closed then
            return
        end

        hapticEngine.click()
        variables.tweenService:Create(stroke, hoverInfo, {Transparency = 1}):Play()

        if callback then
            task.spawn(function()
                local ok, err = pcall(callback)

                if not ok then
                    log.warn("Slate: popup button '" .. label .. "' callback errored:")
                    log.print(err)
                end
            end)
        end

        self:Close()
    end))
end
function Popup:_measureHeader(hasIcon)
    local textWidth = innerWidth - (if hasIcon then headerIconSize + headerIconGap else 0)

    self._titleH = functions.textHeight(self.window.theme.Font, titleSize, locale.resolve(self.title), textWidth)
    self._subH = if self.subtitle and self.subtitle ~= ''then functions.textHeight(self.window.theme.Font, subtitleSize, locale.resolve(self.subtitle), textWidth)else 0
    self._columnH = self._titleH + (if self._subH > 0 then 3 + self._subH else 0)

    return math.max(self._columnH, if hasIcon then headerIconSize else 0)
end
function Popup:_measureText()
    return functions.textHeight(self.window.theme.Font, contentSize, locale.resolve(self.content), contentWidth)
end
function Popup:_measureBox(box)
    box = if typeof(box) == 'table'then box else{
        title = tostring(box),
    }

    local hasIcon = box.icon ~= nil and box.icon ~= 0 and box.icon ~= ''
    local textWidth = contentWidth - boxWidthInset - boxSidePad * 2 - (if hasIcon then boxIconSize + boxIconGap else 0)
    local titleH = functions.textHeight(self.window.theme.TitleFont, boxTitleSize, locale.resolve(box.title or box.Title or ''), textWidth)
    local descH = 0
    local description = box.description or box.Description

    if description and description ~= '' then
        descH = functions.textHeight(self.window.theme.Font, boxDescSize, locale.resolve(description), textWidth)
    end

    local columnH = titleH + (if descH > 0 then 3 + descH else 0)
    local frameH = math.max(columnH, if hasIcon then boxIconSize else 0) + boxVerticalPad * 2

    return frameH, titleH, descH, columnH
end
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
function Popup:_show()
    if not self.screenGui.Parent then
        return
    end

    hapticEngine.notify()
    variables.tweenService:Create(self.card, enterInfo, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()

    for _, entry in self._reveal do
        local info = if entry.instance == self.backdrop then backdropInfo else fadeLong

        variables.tweenService:Create(entry.instance, info, {
            [entry.prop] = entry.to,
        }):Play()
    end
end
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

    variables.tweenService:Create(self.card, fadeShort, {
        Position = UDim2.new(0.5, 0, 0.5, 10),
    }):Play()

    for _, entry in self._reveal do
        variables.tweenService:Create(entry.instance, fadeShort, {
            [entry.prop] = 1,
        }):Play()
    end

    task.delay(fadeShort.Time, function()
        self.window:DestroySubtree(self.screenGui)
    end)
end

return Popup

end)() end,
    [17] = function()local wax,script,require=ImportGlobals(17)local ImportGlobals return (function(...)local Progress = {}

Progress.__index = Progress
Progress.__type = 'Progress'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local locale = require(utility.locale)
local rowHeight = 60
local trackHeight = 8
local inset = 20
local stepHeight = 6
local stepGap = 6
local titleSize = 16
local readoutSize = 14
local readoutTransparency = 0.4
local fillInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local fillTransparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(1, 0),
})
local sweepSeconds = 0.9
local sweepInfo = TweenInfo.new(sweepSeconds, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 
-1, true)

local function finite(value: unknown): number?
    local number = tonumber(value)

    if number == nil or number ~= number or math.abs(number) == math.huge then
        return nil
    end

    return number
end

function Progress.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local steps = finite(properties.steps or properties.Steps)

    steps = if steps and steps >= 2 then math.floor(steps)else nil

    local range = properties.range or properties.Range
    local min = finite(range and range[1]) or 0
    local max = finite(range and range[2]) or steps or 1

    if min > max then
        min, max = max, min
    end

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Progress',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        min = min,
        max = max,
        steps = steps,
        value = 0,
        text = properties.text or properties.Text,
        format = properties.format or properties.Format,
        showValue = if properties.showValue == nil then true else properties.showValue == true,
        indeterminate = properties.indeterminate or properties.Indeterminate or false,
    }, Progress)

    self.value = self:_clamp(finite(properties.value or properties.Value) or min)

    self:_build()

    if self.description then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    return self
end
function Progress:_clamp(value: number): number
    return math.clamp(finite(value) or self.min, self.min, self.max)
end
function Progress:_ratio(): number
    local span = self.max - self.min

    if span <= 0 then
        return 1
    end

    return (self.value - self.min) / span
end
function Progress:_filledSteps(): number
    local count = self.steps::number

    return math.clamp(math.round(self:_ratio() * count), 0, count)
end
function Progress:_readout(): string
    if self.text then
        return locale.resolve(self.text)
    end
    if self.format then
        local ok, formatted = pcall(self.format, self.value, self.min, self.max)

        if ok and type(formatted) == 'string' then
            return formatted
        end
    end
    if self.steps then
        return string.format('%d/%d', self:_filledSteps(), self.steps)
    end

    return string.format('%d%%', math.round(self:_ratio() * 100))
end
function Progress:_build()
    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, rowHeight),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)
    self.container = self.window:Create('Frame', {
        Size = UDim2.new(0, 170, 0, titleSize),
        Position = UDim2.new(0, inset, 0, 20),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(250, titleSize),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = titleSize,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.readout = self.window:Create('TextLabel', {
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
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    if self.steps then
        self:_buildSteps()

        return
    end

    self.track = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -16),
        Size = UDim2.new(1, -inset * 2, 0, trackHeight),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'SliderBackground',
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.track,
    })

    self.fill = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromScale(if self.indeterminate then 0 else self:_ratio(), 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.track,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.fill,
    })
    self.window:Create('UIGradient', {
        Offset = Vector2.new(0, 0.5),
        Rotation = 2,
        Transparency = fillTransparency,
        Parent = self.fill,
    }, {
        Color = {
            'SliderProgress',
            functions.toColorSequence,
        },
    })

    self.fillGlow = self.window:CreateGlow(self.fill, 'AccentColor', 20, 1)

    if self.indeterminate then
        self:_startSweep()
    end
end
function Progress:_buildSteps()
    local count = self.steps::number

    self.track = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -17),
        Size = UDim2.new(1, -inset * 2, 0, stepHeight),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, stepGap),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.track,
    })

    self.stepFrames = {}

    for index = 1, count do
        local segment = self.window:Create('Frame', {
            Size = UDim2.new(1 / count, -(stepGap * (count - 1)) / count, 1, 0),
            BorderSizePixel = 0,
            LayoutOrder = index,
            BackgroundTransparency = 1,
            Parent = self.track,
        }, {
            BackgroundColor3 = 'SliderBackground',
        })

        self.window:Create('UICorner', {
            CornerRadius = UDim.new(1, 0),
            Parent = segment,
        })

        local fill = self.window:Create('Frame', {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 2,
            BackgroundTransparency = 1,
            Parent = segment,
        })

        self.window:Create('UICorner', {
            CornerRadius = UDim.new(1, 0),
            Parent = fill,
        })
        self.window:Create('UIGradient', {
            Rotation = 90,
            Parent = fill,
        }, {
            Color = {
                'SliderProgress',
                functions.toColorSequence,
            },
        })
        table.insert(self.stepFrames, {
            segment = segment,
            fill = fill,
        })
    end
end
function Progress:_startSweep()
    if self._sweep or self.steps then
        return
    end

    self.fill.AnchorPoint = Vector2.new(0, 0.5)
    self.fill.Position = UDim2.fromScale(0, 0.5)
    self.fill.Size = UDim2.fromScale(0, 1)
    self._sweep = variables.tweenService:Create(self.fill, sweepInfo, {
        Size = UDim2.fromScale(1, 1),
    })

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
        if not self._shown then
            return
        end

        local filled = self:_filledSteps()

        for index, step in self.stepFrames do
            local target = if index <= filled then 0 else 1

            if animate == false then
                step.fill.BackgroundTransparency = target
            else
                variables.tweenService:Create(step.fill, fillInfo, {BackgroundTransparency = target}):Play()
            end
        end

        return
    end

    local size = UDim2.fromScale(self:_ratio(), 1)

    if animate == false then
        self.fill.Size = size
    else
        variables.tweenService:Create(self.fill, fillInfo, {Size = size}):Play()
    end
end
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
function Progress:GetPercentage(): number
    return self:_ratio()
end
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
function Progress:SetText(text)
    self.text = text
    self.readout.Text = self:_readout()
end
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

    w:_reveal(self.readout, {
        TextTransparency = if shown then readoutTransparency else 1,
    }, animate)

    if shown then
        w:_revealCommon(self, animate)
    else
        w:_hideCommon(self, animate)
    end
    if self.steps then
        local filled = self:_filledSteps()

        for index, step in self.stepFrames do
            w:_reveal(step.segment, {
                BackgroundTransparency = if shown then 0 else 1,
            }, animate)
            w:_reveal(step.fill, {
                BackgroundTransparency = if shown and index <= filled then 0 else 1,
            }, animate)
        end

        return
    end

    w:_reveal(self.track, {
        BackgroundTransparency = if shown then 0 else 1,
    }, animate)
    w:_reveal(self.fill, {
        BackgroundTransparency = if shown then 0 else 1,
    }, animate)
    w:_reveal(self.fillGlow, {
        Transparency = if shown then w.theme.AccentGlow else 1,
    }, animate)
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
    [18] = function()local wax,script,require=ImportGlobals(18)local ImportGlobals return (function(...)local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local constants = require(utility.constants)
local locale = require(utility.locale)
local action = require(script.Parent.action)
local search = {}
local swapInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local iconRest = 0.6
local iconLit = 0.2

local function unitText(unit)
    if unit.__type == 'Group' then
        local parts = {}

        local function walk(group)
            for _, child in group.elements do
                if child.__type == 'Group' then
                    walk(child)
                elseif child.name then
                    table.insert(parts, child.name)
                end
            end
        end

        walk(unit)

        return table.concat(parts, '\n')
    end

    return unit.name or ''
end
local function collectUnits(window)
    local units = {}

    for _, tab in window.tabs do
        if tab.neglectSelector then
            continue
        end

        for _, element in tab.elements do
            if element.__type ~= 'Section' then
                table.insert(units, element)
            end
        end
    end

    return units
end
local function setPillShown(window, shown, info)
    variables.tweenService:Create(window.searchPill, info, {
        BackgroundTransparency = if shown then 0.9 else 1,
    }):Play()
    variables.tweenService:Create(window.searchStroke, info, {
        Transparency = if shown then 0.85 else 1,
    }):Play()
    variables.tweenService:Create(window.searchShadow, info, {
        Transparency = if shown then 0.92 else 1,
    }):Play()
    variables.tweenService:Create(window.searchIcon, info, {
        ImageTransparency = if shown then 0.65 else 1,
    }):Play()
    variables.tweenService:Create(window.searchInput, info, {
        TextTransparency = if shown then 0.2 else 1,
    }):Play()
end
local function setTabsShown(window, shown, info)
    if window.layout.mode == 'sidebar' then
        return
    end

    for _, tab in window.tabs do
        if not tab.neglectSelector and tab.topbarItem then
            tab:_applyVisual(if shown then(if window.selectedTab == tab then'selected'else'unselected')else'hidden', info)
        end
    end
end
local function applyFilter(window, query)
    query = string.lower(query or '')

    local anyVisible = false

    for _, entry in window._searchUnits do
        local match = query == '' or string.find(entry.text, query, 1, true) ~= nil

        entry.unit.main.Visible = match

        if entry.unit.descriptor then
            entry.unit.descriptor.main.Visible = match
        end

        anyVisible = anyVisible or match
    end

    window.searchEmpty.Visible = not anyVisible and query ~= ''
end
local function gatherUnits(window)
    window._searchUnits = {}

    local order = 0

    for _, unit in collectUnits(window)do
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
    if window._searching or window.minimised or not window:_interactive() then
        return
    end

    window._searching = true

    gatherUnits(window)
    applyFilter(window, '')
    window:_jumpTo(window.searchPage)
    setTabsShown(window, false, swapInfo)
    task.delay(swapInfo.Time, function()
        if window._searching and window.layout.mode ~= 'sidebar' then
            window.tabList.Visible = false
        end
    end)

    window.searchPill.Visible = true

    setPillShown(window, true, swapInfo)
    window.searchInput:CaptureFocus()
    variables.tweenService:Create(window.searchAction.iconLabel, swapInfo, {ImageTransparency = iconLit}):Play()
end
function search.close(window, config)
    if not window._searching then
        return
    end

    config = config or {}
    window._searching = false
    window.searchInput.Text = ''

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

    variables.tweenService:Create(window.searchAction.iconLabel, swapInfo, {ImageTransparency = iconRest}):Play()
end
function search.toggle(window)
    if window._searching then
        search.close(window, {showTabs = true})
    else
        search.open(window)
    end
end
function search.railWidth(window, width)
    if window.searchPill then
        window.searchPill.Size = UDim2.new(1, -(width + 30), 0, 35)
    end
end
function search.build(window)
    window._searching = false
    window.searchPage = window:Create('ScrollingFrame', {
        Name = 'Search',
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 2000,
        Parent = window.elements,
    })

    window:Create('UIListLayout', {
        Padding = UDim.new(0, 7),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = window.searchPage,
    })
    window:Create('UIPadding', {
        PaddingTop = UDim.new(0, if window.layout.mode == 'sidebar'then 53 else 10),
        PaddingBottom = UDim.new(0, 33),
        Parent = window.searchPage,
    })

    window.searchEmpty = window:Create('TextLabel', {
        Name = 'NoResults',
        Text = locale.t('No results'),
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
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    local sidebarLayout = window.layout.mode == 'sidebar'
    local top = if sidebarLayout then window.layout.chromeHeight + 8 else window.layout.tabStripTop + 1

    window.searchPill = window:Create('Frame', {
        Name = 'SearchBar',
        AnchorPoint = Vector2.new(if sidebarLayout then 1 else 0.5, 0),
        Position = UDim2.new(if sidebarLayout then 1 else 0.5, if sidebarLayout then
-15 else 0, 0, top),
        Size = UDim2.new(1, if sidebarLayout then-(window.layout.railWidth + 30)else
-35, 0, 35),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 10,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = window.main,
    })

    window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = window.searchPill,
    })

    window.searchStroke = window:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 1,
        Parent = window.searchPill,
    })
    window.searchShadow = window:Create('UIShadow', {
        BlurRadius = UDim.new(0, 20),
        Color = Color3.fromRGB(255, 255, 255),
        ZIndex = -1,
        Transparency = 1,
        Parent = window.searchPill,
    })
    window.searchIcon = window:Create('ImageLabel', {
        Image = 'rbxassetid://' .. tostring(constants.icons.search),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 1),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        ZIndex = 10,
        ImageTransparency = 1,
        Parent = window.searchPill,
    }, {
        ImageColor3 = 'ContentColor',
    })
    window.searchInput = window:Create('TextBox', {
        Text = '',
        PlaceholderText = locale.t('Search all pages'),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 40, 0.5, 0),
        Size = UDim2.new(1, -110, 0, 18),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        ZIndex = 10,
        TextTransparency = 1,
        Parent = window.searchPill,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
        PlaceholderColor3 = 'PlaceholderColor',
    })

    window:Connect(window.searchInput:GetPropertyChangedSignal('Text'), function(
    )
        if window._searching then
            applyFilter(window, window.searchInput.Text)
        end
    end)

    window.searchAction = action.new(window, {
        name = 'Search',
        icon = constants.icons.search,
        order = 4,
        callback = function()
            search.toggle(window)
        end,
    })
    window.searchAction.isLit = function()
        return window._searching
    end
end

return search

end)() end,
    [19] = function()local wax,script,require=ImportGlobals(19)local ImportGlobals return (function(...)local Section = {}

Section.__index = Section
Section.__type = 'Section'

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)

function Section.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Section',
        icon = properties.icon or properties.Icon,
    }, Section)
    local topSpace = if#self.tab.elements == 0 then 0 else 13

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -40, 0, 20 + topSpace),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    })

    if topSpace > 0 then
        self.window:Create('UIPadding', {
            PaddingTop = UDim.new(0, topSpace),
            Parent = self.main,
        })
    end

    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.main,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.main,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 15,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    return self
end
function Section:_setShown(shown, animate)
    local w = self.window

    w:_reveal(self.title, {
        TextTransparency = if shown then 0.6 else 1,
    }, animate)

    if self.iconLabel then
        w:_reveal(self.iconLabel, {
            ImageTransparency = if shown then 0.65 else 1,
        }, animate)
    end
end

moveable(Section)

return Section

end)() end,
    [20] = function()local wax,script,require=ImportGlobals(20)local ImportGlobals return (function(...)local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local image = require(utility.image)
local locale = require(utility.locale)
local tabSelector = require(script.Parent.tabSelector)
local search = require(script.Parent.search)
local sidebar = {}
local nameTransparency = 0
local subtitleTransparency = 0.7
local avatarPlateTransparency = 0.95
local settleInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function profileVisible(window)
    return window.layout.mode == 'sidebar' and window.profile ~= nil and window.settings.showProfile and variables.localPlayer ~= nil
end
local function buildProfile(window, layout)
    local player = variables.localPlayer

    if not player then
        return
    end

    window.profile = window:Create('Frame', {
        Name = 'Profile',
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.new(1, 0, 0, layout.footerHeight),
        BackgroundTransparency = 1,
        Parent = window.sidebar,
    })
    window.profileContainer = window:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, layout.rowInset, 0.5, 0),
        Size = UDim2.new(1, -layout.rowInset, 1, 0),
        BackgroundTransparency = 1,
        Parent = window.profile,
    })
    window.profileLayout = window:Create('UIListLayout', {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = window.profileContainer,
    })
    window.profileAvatar = window:Create('ImageLabel', {
        Name = 'Avatar',
        Image = image.avatar(player.UserId, function(uri)
            if window.profileAvatar and not window.unloaded then
                image.assign(window.profileAvatar, 'Image', uri)
            end
        end),
        Size = UDim2.fromOffset(layout.avatarSize, layout.avatarSize),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Parent = window.profileContainer,
    })

    window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = window.profileAvatar,
    })

    window.profileLabels = window:Create('Frame', {
        Size = UDim2.fromOffset(50, layout.avatarSize),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = window.profileContainer,
    })

    window:Create('UIListLayout', {
        Padding = UDim.new(0, 2),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = window.profileLabels,
    })

    window.profileName = window:Create('TextLabel', {
        Text = player.DisplayName,
        Size = UDim2.fromOffset(50, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        Parent = window.profileLabels,
    }, {
        TextColor3 = 'TitlingColor',
        FontFace = 'Font',
    })
    window.profileSubtitle = window:Create('TextLabel', {
        Text = '',
        Size = UDim2.fromOffset(50, 14),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Visible = false,
        TextTransparency = 1,
        Parent = window.profileLabels,
    }, {
        TextColor3 = 'TitlingColor',
        FontFace = 'Font',
    })
end

function sidebar.build(window, layout)
    window.sidebar = window:Create('Frame', {
        Name = 'Sidebar',
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(0, layout.railWidth, 1, -layout.chromeHeight),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = window.main,
    })
    window.tabList = window:Create('ScrollingFrame', {
        Name = 'Tabs',
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

    window:Create('UIPadding', {
        PaddingTop = UDim.new(0, layout.railPadding),
        PaddingBottom = UDim.new(0, layout.railPadding),
        Parent = window.tabList,
    })

    window.tabListLayout = window:Create('UIListLayout', {
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
function sidebar.reflowProfile(window)
    local layout = window.layout
    local shown = profileVisible(window)

    if window.profile then
        window.profile.Visible = shown
    end

    window.tabList.Size = UDim2.new(1, 0, 1, if shown then-layout.footerHeight else 0)
end
function sidebar.applyWidth(window, width)
    local layout = window.layout

    window.sidebar.Size = UDim2.new(0, width, 1, -layout.chromeHeight)
    window.elements.Size = UDim2.new(1, -width, 1, -layout.chromeHeight)
    window.bottomFade.Size = UDim2.new(1, -width, layout.fadeSize.Y.Scale, layout.fadeSize.Y.Offset)

    search.railWidth(window, width)

    local collapsed = width < (layout.railWidth::number)

    for _, tab in window.tabs do
        if not tab.neglectSelector then
            tabSelector.setRowCollapsed(tab, collapsed, layout)
        end
    end

    if window.profileContainer then
        window.profileContainer.Position = UDim2.new(0, if collapsed then 0 else layout.rowInset, 0.5, 0)
        window.profileContainer.Size = UDim2.new(1, if collapsed then 0 else-layout.rowInset, 1, 0)
        window.profileLayout.HorizontalAlignment = if collapsed then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left
        window.profileLabels.Visible = not collapsed
    end
end
function sidebar.setProfileShown(window, shown, tweenInfo)
    if not window.profile or not window.profile.Visible then
        return
    end

    local targets = {
        [window.profileAvatar] = {
            ImageTransparency = if shown then 0 else 1,
            BackgroundTransparency = if shown then avatarPlateTransparency else 1,
        },
        [window.profileName] = {
            TextTransparency = if shown then nameTransparency else 1,
        },
        [window.profileSubtitle] = {
            TextTransparency = if shown then subtitleTransparency else 1,
        },
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

    sidebar.setProfileShown(window, false, settleInfo)
    task.delay(settleInfo.Time, function()
        if window.unloaded or window.settings.showProfile then
            return
        end

        sidebar.reflowProfile(window)
    end)

    window.settings.showProfile = false
end
function sidebar.setSubtitle(window, text)
    if not window.profileSubtitle then
        return
    end

    local resolved = if type(text) == 'string' and text ~= ''then locale.resolve(text)else nil

    window.profileSubtitle.Text = resolved or ''
    window.profileSubtitle.Visible = resolved ~= nil
end

return sidebar

end)() end,
    [21] = function()local wax,script,require=ImportGlobals(21)local ImportGlobals return (function(...)local Slider = {}

Slider.__index = Slider
Slider.__type = 'Slider'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local odometer = require(utility.odometer)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

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
local function snapTo(range, increment, value)
    local snapped = range[1] + math.round((value - range[1]) / increment) * increment

    return math.clamp(snapped, range[1], range[2])
end

local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local heldInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local followInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local narrowWidth = 300
local handleRest = Vector2.new(35, 20)
local handleHeld = Vector2.new(41, 22)

local function fillSize(ratio: number): UDim2
    return UDim2.new(ratio, 0, 1, 0)
end
local function handleOffset(): UDim2
    return UDim2.new(1, 0, 0.5, 0)
end
local function ratioFromPointer(x: number, left: number, travel: number): number
    return math.clamp((x - left) / travel, 0, 1)
end

function Slider.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Slider',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        range = properties.range or properties.Range or {0, 100},
        increment = properties.increment or properties.Increment or 1,
        suffix = properties.suffix or properties.Suffix or '',
        callback = properties.callback or properties.Callback or function() end,
        dragging = false,
        minimal = properties.minimal or properties.Minimal or false,
        _handleWidth = handleRest.X,
    }, Slider)

    assert(typeof(self.range) == 'table' and typeof(self.range[1]) == 'number' and typeof(self.range[2]) == 'number', 'A slider range needs two numbers, like { 0, 100 }.')

    if self.range[1] > self.range[2] then
        self.range = {
            self.range[2],
            self.range[1],
        }
    end
    if self.increment <= 0 then
        self.increment = 1
    end

    self.value = if(properties.value or properties.Value) ~= nil
        then(properties.value or properties.Value)
        elseif(properties.currentValue or properties.CurrentValue) ~= nil
        then(properties.currentValue or properties.CurrentValue)
        else self.range[1]
    self.value = snapTo(self.range, self.increment, self.value)
    self._decimals = decimalsOf(self.increment)
    self.flag = properties.flag or properties.Flag or (not self.forgetState and functions.deriveFlagFromName(self.name) or nil)

    self.window:_registerControl(self)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 65),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)
    self._lastValue = self.value

    if not self.minimal then
        self:_buildLabel()
    end

    self.track = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(222, 14),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = self.main,
    }, {
        BackgroundColor3 = 'SliderBackground',
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 13),
        Parent = self.track,
    })

    self.progress = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = self.track,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(0, 13),
        Parent = self.progress,
    })
    self.window:Create('UIGradient', {
        Offset = Vector2.new(0, 0.5),
        Rotation = 2,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Parent = self.progress,
    }, {
        Color = {
            'SliderProgress',
            functions.toColorSequence,
        },
    })

    self.progressGlow = self.window:CreateGlow(self.progress, 'AccentColor', 20, 1)
    self.handle = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, handleRest.X / 2 - 2, 0.5, 0),
        Size = UDim2.fromOffset(handleRest.X, handleRest.Y),
        BorderSizePixel = 0,
        ZIndex = 50,
        BackgroundTransparency = 1,
        Parent = self.track,
    }, {
        BackgroundColor3 = 'SliderHandle',
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.handle,
    })

    self.handleGlow = self.window:CreateGlow(self.handle, Color3.fromRGB(255, 255, 255), 10, 1)
    self.handleStroke = self.window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.handle,
    }, {
        Color = 'SliderStroke',
    })
    self.interact = self.window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = '',
        TextTransparency = 1,
        ZIndex = 10,
        Parent = self.track,
    })

    self.window:ConnectFor(self, self.main.MouseEnter, function()
        if not self.window:_interactive() then
            return
        end

        variables.tweenService:Create(self.track, tweenInfo, {
            BackgroundColor3 = self.window.theme.SliderBackgroundHover,
        }):Play()
    end)
    self.window:ConnectFor(self, self.main.MouseLeave, function()
        variables.tweenService:Create(self.track, tweenInfo, {
            BackgroundColor3 = self.window.theme.SliderBackground,
        }):Play()
    end)
    self.window:ConnectFor(self, self.interact.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hapticEngine.click()

            self.dragging = true

            self:_setHeld(true)
            self:_updateFromMouse()

            if self._dragConnection then
                self._dragConnection:Disconnect()

                self._dragConnection = nil
            end

            self._dragConnection = variables.runService.RenderStepped:Connect(function(
            )
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
    self.window:ConnectFor(self, variables.userInputService.InputEnded, function(
        input
    )
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:_endDrag()
        end
    end)
    self.window:ConnectFor(self, variables.userInputService.WindowFocusReleased, function(
    )
        self:_endDrag()
    end)

    if self.description and not self.minimal then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    self.window:ConnectFor(self, self.main:GetPropertyChangedSignal('AbsoluteSize'), function(
    )
        if self.window.animating or (self.window.hidden and self.window.hasShownOnce) then
            return
        end

        self:_applyLayout()
    end)
    self:_applyLayout()

    if self.minimal then
        self.main.Size = UDim2.new(1, -20, 0, 41)
        self.track.AnchorPoint = Vector2.new(0.5, 0.5)
        self.track.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.track.Size = UDim2.new(1, -30, 0, 14)
    end

    self:_renderProgress()

    return self
end
function Slider:_buildLabel()
    self.container = self.window:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 20, 0.5, 0),
        Size = UDim2.fromOffset(170, 33),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.main,
    })
    self.containerLayout = self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 2),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.container,
    })
    self.titleContainer = self.window:Create('Frame', {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = self.container,
    })

    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.titleContainer,
    })

    self.titleFlex = self.window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.None,
        Parent = self.titleContainer,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 5,
            ImageTransparency = 1,
            Parent = self.titleContainer,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.new(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        RichText = true,
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.titleContainer,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    self.window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    self.valueHost = self.window:Create('Frame', {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 6,
        LayoutOrder = 1,
        Parent = self.container,
    })
    self.valueOdo = odometer.new(self.window, self.valueHost, {
        textSize = 15,
        alignment = Enum.HorizontalAlignment.Left,
        transparency = 1,
        duration = 0.28,
    })

    self.valueOdo:snap(self:_format(self.value))
end
function Slider:_setMainHeight(height)
    if self._widthManaged then
        self.main.Size = UDim2.new(self.main.Size.X.Scale, self.main.Size.X.Offset, 0, height)
    else
        self.main.Size = UDim2.new(1, -20, 0, height)
    end
end
function Slider:_applyLayout()
    if self.minimal then
        return
    end

    local width = self.main.AbsoluteSize.X
    local mode = if width > 0 and width < narrowWidth then'narrow'else'wide'

    if self._layoutMode == mode then
        return
    end

    self._layoutMode = mode

    if mode == 'narrow' then
        self:_setMainHeight(70)

        self.container.AnchorPoint = Vector2.new(0, 0)
        self.container.Position = UDim2.new(0, 20, 0, 14)
        self.container.Size = UDim2.new(1, -40, 0, 16)
        self.containerLayout.FillDirection = Enum.FillDirection.Horizontal
        self.titleFlex.FlexMode = Enum.UIFlexMode.Fill
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
    local text = string.format('%.' .. self._decimals .. 'f', value)

    if self.suffix ~= '' then
        if string.sub(self.suffix, 1, 1) == ' ' or string.sub(self.suffix, 1, 1) == '°' or string.sub(self.suffix, 1, 1) == '%' then
            return text .. self.suffix
        end
        return text .. ' ' .. self.suffix
    end

    return text
end
function Slider:_pillTravel()
    return math.max(self.track.AbsoluteSize.X, 0)
end
function Slider:_renderProgress(info)
    local span = self.range[2] - self.range[1]
    local ratio = if span ~= 0 then math.clamp((self.value - self.range[1]) / span, 0, 1) else 0
    local size = fillSize(ratio)
    local handleOffset = (1 - 2 * ratio) * (self._handleWidth / 2 - 2)
    local handlePos = UDim2.new(ratio, handleOffset, 0.5, 0)

    if info then
        variables.tweenService:Create(self.progress, info, {Size = size}):Play()
        variables.tweenService:Create(self.handle, info, {Position = handlePos}):Play()
    else
        self.progress.Size = size
        self.handle.Position = handlePos
    end
end
function Slider:_updateFromMouse()
    local travel = self:_pillTravel()

    if travel <= 0 then
        return
    end

    local ratio = ratioFromPointer(variables.userInputService:GetMouseLocation().X, self.track.AbsolutePosition.X, travel)
    local value = snapTo(self.range, self.increment, self.range[1] + ratio * (self.range[2] - self.range[1]))

    if value ~= self.value then
        self.value = value

        if self.valueOdo then
            self.valueOdo:snap(self:_format(value))
        end

        self._lastValue = value

        self:_renderProgress(followInfo)
        self:_fireCallback(value)
    end
end
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
function Slider:_setHeld(held)
    if not held then
        self:_fireCallback(self.value)
    end

    local target = if held then handleHeld else handleRest

    self._handleWidth = target.X

    variables.tweenService:Create(self.handle, heldInfo, {
        Size = UDim2.fromOffset(target.X, target.Y),
        BackgroundTransparency = if held then 0.7 else 0,
    }):Play()
    variables.tweenService:Create(self.handleStroke, heldInfo, {
        Transparency = if held then 0.6 else 1,
    }):Play()
    self:_renderProgress(heldInfo)
end
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

local sliderGlowReveal = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0.35)

function Slider:_setShown(shown, animate)
    local w = self.window

    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.track, {BackgroundTransparency = 0}, animate)
        w:_reveal(self.progress, {BackgroundTransparency = 0}, animate)
        w:_reveal(self.handle, {BackgroundTransparency = 0}, animate)

        if self.valueOdo then
            self.valueOdo:reveal(0.3, animate)
        end

        w:_reveal(self.progressGlow, {
            Transparency = math.max(0.55, w.theme.AccentGlow),
        }, animate, sliderGlowReveal)
        w:_reveal(self.handleGlow, {Transparency = 0.8}, animate, sliderGlowReveal)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.track, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.progress, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.handle, {BackgroundTransparency = 1}, animate)

        if self.valueOdo then
            self.valueOdo:reveal(1, animate)
        end

        w:_reveal(self.progressGlow, {Transparency = 1}, animate, sliderGlowReveal)
        w:_reveal(self.handleGlow, {Transparency = 1}, animate, sliderGlowReveal)
    end
end
function Slider:_refreshTheme()
    variables.tweenService:Create(self.progressGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = math.max(0.55, self.window.theme.AccentGlow),
    }):Play()
end
function Slider:_minWidth()
    if self.minimal then
        return 100
    end

    local w = 40

    if self.icon then
        w += 22
    end

    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))
    w += 12
    w += functions.textWidth(self.window.theme.Font, 15, self:_format(self.value))

    return math.max(w, 160)
end

moveable(Slider)
lockable(Slider)

return Slider

end)() end,
    [22] = function()local wax,script,require=ImportGlobals(22)local ImportGlobals return (function(...)local Statistic = {}

Statistic.__index = Statistic
Statistic.__type = 'Statistic'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local odometer = require(utility.odometer)
local moveable = require(utility.moveable)
local constants = require(utility.constants)
local locale = require(utility.locale)
local log = require(utility.log)
local accents = constants.statAccents
local accentTransparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.85),
    NumberSequenceKeypoint.new(1, 0),
})
local compactHeight = 41
local accentTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential)

local function glowColor(accent)
    return accent.fill.Keypoints[1].Value
end
local function formatPct(pct)
    if pct > 0 then
        return string.format('+%.1f%%', pct)
    elseif pct < 0 then
        return string.format('%.1f%%', pct)
    else
        return '0%'
    end
end
local function formatValue(value)
    if typeof(value) ~= 'number' then
        return tostring(value)
    end

    local rounded = math.round(math.abs(value))
    local s = string.format('%.0f', rounded)
    local result = s:reverse():gsub('%d%d%d', '%0,'):reverse()

    if result:sub(1, 1) == ',' then
        result = result:sub(2)
    end

    return if value < 0 and rounded ~= 0 then'-' .. result else result
end
local function formatChange(delta)
    local rounded = math.round(delta)

    if rounded > 0 then
        return '+' .. formatValue(rounded)
    elseif rounded < 0 then
        return formatValue(rounded)
    else
        return '0'
    end
end

function Statistic.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Statistic',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        value = if(properties.value or properties.Value) ~= nil then(properties.value or properties.Value)else 0,
        _hasValue = (properties.value or properties.Value) ~= nil,
        numberEasing = if(properties.numberEasing ~= nil)
            then properties.numberEasing
            elseif properties.NumberEasing ~= nil
            then properties.NumberEasing
            else true,
        changeMode = properties.changeMode or properties.ChangeMode or 'percentage',
        changeBaseline = properties.changeBaseline or properties.ChangeBaseline or 'previous',
        prefix = properties.prefix or properties.Prefix or '',
        suffix = properties.suffix or properties.Suffix or '',
        compact = properties.compact or properties.Compact or tab.compact or false,
        display = (properties.display or properties.Display or 'value'),
        _initialValue = if(properties.value or properties.Value) ~= nil then(properties.value or properties.Value)else nil,
        _lastChange = 0,
    }, Statistic)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end
    if self.description then
        if self.compact then
            log.warn(`Slate: a compact stat has no room for a description, ignoring it on '{self.name}'.`)
        else
            self.descriptor = require(script.Parent.descriptor).new(self.tab, {
                description = self.description,
            })
        end
    end

    return self
end
function Statistic:_buildFull()
    local window = self.window

    self.main = window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 90),
        BorderSizePixel = 0,
        Name = self.name,
        ZIndex = 5,
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundColor3 = 'StatBackground',
        BackgroundTransparency = 'ElementTransparency',
    })

    window:Create('UICorner', {
        Parent = self.main,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })

    self.stroke = window:Create('UIStroke', {
        Transparency = 1,
        Color = Color3.fromRGB(255, 255, 255),
        Parent = self.main,
    }, {
        Transparency = 'ElementStrokeTransparency',
    })
    self.strokeGradient = window:Create('UIGradient', {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.stroke,
        Transparency = accentTransparency,
        Parent = self.stroke,
    })
    self.titleContainer = window:Create('Frame', {
        Size = UDim2.new(1, -40, 0, 32),
        Position = UDim2.fromOffset(20, 15),
        BorderSizePixel = 0,
        LayoutOrder = -1,
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = self.main,
    })
    self.gradientContainer = window:Create('Frame', {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromOffset(0, 0),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 5,
        Parent = self.main,
    })
    self.glow = window:CreateGlow(self.main, glowColor(accents.neutral), 13, 1)
    self.title = window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(300, 19),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        ZIndex = 10,
        TextTransparency = 1,
        Parent = self.titleContainer,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'TitleFont',
    })
    self.mainGradient = window:Create('UIGradient', {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.fill,
        Transparency = accentTransparency,
        Parent = self.gradientContainer,
    })

    window:Create('UICorner', {
        Parent = self.gradientContainer,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(32, 32),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 10,
            ImageTransparency = 1,
            Parent = self.titleContainer,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.containerLayout = window:Create('UIListLayout', {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.titleContainer,
    })
    self.valueHost = window:Create('Frame', {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 20, 1, -15),
        Size = UDim2.fromOffset(200, 20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = self.main,
    })
    self.changeHost = window:Create('Frame', {
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
        transparency = 1,
    })

    self.valueOdo:snap(self:_formatValue(self.value))

    self.changeOdo = odometer.new(window, self.changeHost, {
        textSize = 15,
        alignment = Enum.HorizontalAlignment.Right,
        transparency = 1,
    })

    self.changeOdo:snap(self:_formatChange(0))

    self._accentGradients = {
        self.strokeGradient,
        self.mainGradient,
    }
end
function Statistic:_buildCompact()
    local window = self.window
    local inRow = self.tab.compact or false

    self.main = window:Create('Frame', {
        Name = self.name,
        Size = if inRow then UDim2.fromOffset(0, compactHeight)else UDim2.new(1, 
-20, 0, compactHeight),
        AutomaticSize = if inRow then Enum.AutomaticSize.X else Enum.AutomaticSize.None,
        ClipsDescendants = true,
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundColor3 = 'StatBackground',
        BackgroundTransparency = 'ElementTransparency',
    })

    window:Create('UICorner', {
        Parent = self.main,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })

    self.stroke = window:Create('UIStroke', {
        Transparency = 1,
        Color = Color3.fromRGB(255, 255, 255),
        Parent = self.main,
    }, {
        Transparency = 'ElementStrokeTransparency',
    })
    self.strokeGradient = window:Create('UIGradient', {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.stroke,
        Transparency = accentTransparency,
        Parent = self.stroke,
    })

    if inRow then
        window:Create('UIFlexItem', {
            FlexMode = Enum.UIFlexMode.Fill,
            Parent = self.main,
        })
    end

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Parent = self.main,
    })

    self.card = window:Create('Frame', {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, compactHeight),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    window:Create('UICorner', {
        Parent = self.card,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })

    self.mainGradient = window:Create('UIGradient', {
        Rotation = 2,
        Offset = Vector2.new(0, 0.5),
        Color = accents.neutral.fill,
        Transparency = accentTransparency,
        Parent = self.card,
    })

    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = self.card,
    })
    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        Padding = UDim.new(0, 10),
        Parent = self.card,
    })

    self.titleContainer = window:Create('Frame', {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        ZIndex = 6,
        Parent = self.card,
    })

    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.titleContainer,
    })
    window:Create('UIListLayout', {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.titleContainer,
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(20, 20),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ZIndex = 6,
            ImageTransparency = 1,
            Parent = self.titleContainer,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = window:Create('TextLabel', {
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
        TextTransparency = 1,
        Parent = self.titleContainer,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })

    self.readoutHost = window:Create('Frame', {
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

    self.readoutOdo:snap(self.display == 'change' and self:_formatChange(0) or self:_formatValue(self.value))

    self._accentGradients = {
        self.strokeGradient,
        self.mainGradient,
    }
end
function Statistic:_setAccent(key, direction)
    local accent = accents[key]

    self.strokeGradient.Color = accent.stroke
    self.mainGradient.Color = accent.fill

    if self.glow then
        self.glow.Color = glowColor(accent)
    end

    local rotation = if direction == 1
        then 14
        elseif direction == -1
        then-10
        else 2
    local offset = if direction == 1
        then Vector2.new(0.04, 0.5)
        elseif direction == -1
        then Vector2.new(-0.04, 0.5)
        else Vector2.new(0, 0.5)

    for _, gradient in self._accentGradients do
        variables.tweenService:Create(gradient, accentTweenInfo, {
            Rotation = rotation,
            Offset = offset,
        }):Play()
    end
end
function Statistic:_formatValue(value)
    return self.prefix .. formatValue(value) .. self.suffix
end
function Statistic:_formatChange(delta)
    if self.changeMode == 'absolute' then
        return formatChange(delta)
    else
        return formatPct(delta)
    end
end
function Statistic:_showValue(odo, value, previousValue, hasNoHistory)
    if self.numberEasing and not hasNoHistory then
        odo:to(self:_formatValue(value), value >= previousValue)
    else
        odo:snap(self:_formatValue(value))
    end
end
function Statistic:_updateFullReadouts(
    value,
    previousValue,
    targetChange,
    noChange,
    infinityText,
    hasNoHistory
)
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
function Statistic:_updateCompactReadout(
    value,
    previousValue,
    targetChange,
    noChange,
    infinityText,
    hasNoHistory
)
    if self.display == 'change' then
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
    else
        self:_showValue(self.readoutOdo, value, previousValue, hasNoHistory)
    end
end
function Statistic:Set(value)
    assert(typeof(value) == 'number', 'Statistic:Set() - value must be a number, got ' .. typeof(value))

    local previousValue = self.value
    local hasNoHistory = not self._hasValue

    self.value = value
    self._hasValue = true

    if hasNoHistory then
        self._initialValue = value
    end

    local refValue = if self.changeBaseline == 'initial'then self._initialValue else previousValue
    local noChange = hasNoHistory or refValue == value
    local targetChange, infinityText, accentKey, direction

    if noChange then
        targetChange = 0
        accentKey = 'neutral'
        direction = 0
    elseif refValue == 0 then
        local sign = if value > 0 then'+'else'-'
        local suffix = if self.changeMode == 'percentage'then'\u{221e}%'else'\u{221e}'

        infinityText = sign .. suffix
        accentKey = if value > 0 then'positive'else'negative'
        direction = if value > 0 then 1 else-1
    elseif self.changeMode == 'percentage' then
        targetChange = ((value - refValue) / math.abs(refValue)) * 100
        direction = if targetChange > 0
            then 1
            elseif targetChange < 0
            then-1
            else 0
        accentKey = if direction == 1
            then'positive'
            elseif direction == -1
            then'negative'
            else'neutral'
    else
        targetChange = value - refValue
        direction = if targetChange > 0
            then 1
            elseif targetChange < 0
            then-1
            else 0
        accentKey = if direction == 1
            then'positive'
            elseif direction == -1
            then'negative'
            else'neutral'
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
    local baseline = if typeof(newBaseline) == 'number'then newBaseline else self.value

    self._initialValue = baseline
    self.value = baseline
    self._hasValue = true
    self._lastChange = 0

    if self.compact then
        if self.display == 'change' then
            self.readoutOdo:snap(self:_formatChange(0))
        else
            self:_showValue(self.readoutOdo, baseline, previousValue, hasNoHistory)
        end
    else
        self.changeOdo:snap(self:_formatChange(0))
        self:_showValue(self.valueOdo, baseline, previousValue, hasNoHistory)
    end

    self:_setAccent('neutral', 0)
end
function Statistic:_setShown(shown, animate)
    local w = self.window

    if self.compact then
        w:_reveal(self.main, {
            BackgroundTransparency = if shown then(self.window.theme.ElementTransparency or 0)else 1,
        }, animate)
        w:_reveal(self.stroke, {
            Transparency = if shown then self.window.theme.ElementStrokeTransparency else 1,
        }, animate)
        w:_reveal(self.card, {
            BackgroundTransparency = if shown then 0 else 1,
        }, animate)
        w:_reveal(self.title, {
            TextTransparency = if shown then 0 else 1,
        }, animate)

        if self.iconLabel then
            w:_reveal(self.iconLabel, {
                ImageTransparency = if shown then 0 else 1,
            }, animate)
        end

        self.readoutOdo:reveal(if shown then 0 else 1, animate)

        return
    end
    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.gradientContainer, {BackgroundTransparency = 0}, animate)
        w:_reveal(self.glow, {Transparency = 0.82}, animate)
        self.valueOdo:reveal(0, animate)
        self.changeOdo:reveal(0, animate)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.gradientContainer, {BackgroundTransparency = 1}, animate)
        w:_reveal(self.glow, {Transparency = 1}, animate)
        self.valueOdo:reveal(1, animate)
        self.changeOdo:reveal(1, animate)
    end
end
function Statistic:_minWidth()
    local w = 30 + 10

    if self.icon then
        w += 26
    end

    w += functions.textWidth(self.window.theme.Font, 16, locale.resolve(self.name))

    local readout = if self.display == 'change'then self:_formatChange(0)else self:_formatValue(self.value)

    w += functions.textWidth(self.window.theme.Font, 17, readout)

    return w
end

moveable(Statistic)

return Statistic

end)() end,
    [23] = function()local wax,script,require=ImportGlobals(23)local ImportGlobals return (function(...)local Tab = {}

Tab.__index = Tab
Tab.__type = 'Tab'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local assignOrder = require(utility.ordering)
local hapticEngine = require(utility.HapticEngine)
local search = require(script.Parent.search)
local tabSelector = require(script.Parent.tabSelector)

local function teardownElements(window, elements)
    for _, element in elements do
        if element.__type == 'Group' then
            teardownElements(window, element.elements)
        else
            window:_unregisterControl(element)
        end
        if element.connections then
            for _, connection in element.connections do
                window:Disconnect(connection)
            end

            element.connections = nil
        end
        if element._dragConnection then
            element._dragConnection:Disconnect()

            element._dragConnection = nil
        end
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
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        name = properties.name or properties.Name,
        icon = properties.icon or properties.Icon,
        iconColor = properties.iconColor or properties.IconColor,
        neglectSelector = properties.neglectSelector or properties.NeglectSelector or false,
        customOrder = properties.customOrder or properties.CustomOrder or 0,
        forgetState = properties.forgetState or properties.ForgetState or false,
        elements = {},
        connections = {},
    }, Tab)

    assert(self.name or self.icon, 'A tab needs a name or an icon.')

    if not self.neglectSelector then
        tabSelector.build(self, self.window.layout)
    end

    self.tabPage = self.window:Create('ScrollingFrame', {
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
    self.tabPageLayout = self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 7),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.tabPage,
    })

    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 33),
        Parent = self.tabPage,
    })

    if not self.neglectSelector then
        table.insert(self.connections, self.window:Connect(self.topbarItemInteract.MouseButton1Click, function(
        )
            hapticEngine.click()
            self:Select()
        end))
        table.insert(self.connections, self.window:Connect(self.topbarItemInteract.MouseEnter, function(
        )
            if not self.window:_interactive() then
                return
            end
            if self.window.selectedTab ~= self then
                self:_applyVisual('hover', hoverTweenInfo)
                self:_spinGradients()
            end
        end))
        table.insert(self.connections, self.window:Connect(self.topbarItemInteract.MouseLeave, function(
        )
            if self.window.selectedTab ~= self then
                self:_applyVisual('unselected', hoverTweenInfo)
            end
        end))
    end

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
function Tab:_spinGradients()
    if self.neglectSelector then
        return
    end

    local spinInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    for _, gradient in {
        self.topbarItemGradient,
        self.topbarItemStrokeGradient,
    }do
        gradient.Rotation = 90 - 360

        variables.tweenService:Create(gradient, spinInfo, {Rotation = 90}):Play()
    end
end
function Tab:Select(noAnimation)
    if self.window._searching then
        search.close(self.window, {
            showTabs = true,
            jumpTo = false,
        })
    end

    self.window.selectedTab = self

    self.window:_jumpTo(self.tabPage)

    local skipAnimation = noAnimation or not self.window:_interactive()

    if not self.neglectSelector and not skipAnimation then
        self:_applyVisual('selected', selectTweenInfo)
    end

    for _, tab in self.window.tabs do
        if tab ~= self.window.selectedTab then
            tab:Deselect(skipAnimation)
        end
    end

    if self ~= self.window.rfSettings and self.window.settingsAction and not skipAnimation then
        variables.tweenService:Create(self.window.settingsAction.iconLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.6}):Play()
    end
end
function Tab:Deselect(noAnimation)
    if not self.neglectSelector and not noAnimation then
        self:_applyVisual('unselected', selectTweenInfo)
    end
end
function Tab:_register(element)
    table.insert(self.elements, element)
    assignOrder(element, #self.elements * 10)
    self.window:_restoreLate(element)

    if not self.window.hidden then
        element:_setShown(true, true)
    end

    return element
end
function Tab:CreateButton(properties)
    return self:_register(require(script.Parent.button).new(self, properties))
end
function Tab:CreateToggle(properties)
    return self:_register(require(script.Parent.toggle).new(self, properties))
end
function Tab:CreateSwitch(properties)
    return self:CreateToggle(properties)
end
function Tab:CreateSection(properties)
    return self:_register(require(script.Parent.section).new(self, properties))
end
function Tab:CreateText(properties)
    return self:_register(require(script.Parent.text).new(self, properties))
end
function Tab:CreateDivider(properties)
    return self:_register(require(script.Parent.divider).new(self, properties))
end
function Tab:CreateProgress(properties)
    return self:_register(require(script.Parent.progress).new(self, properties))
end
function Tab:CreateConsole(properties)
    return self:_register(require(script.Parent.console).new(self, properties))
end
function Tab:CreateStat(properties)
    return self:_register(require(script.Parent.stat).new(self, properties))
end
function Tab:CreateSlider(properties)
    return self:_register(require(script.Parent.slider).new(self, properties))
end
function Tab:CreateDropdown(properties)
    return self:_register(require(script.Parent.dropdown).new(self, properties))
end
function Tab:CreateInput(properties)
    return self:_register(require(script.Parent.input).new(self, properties))
end
function Tab:CreateKeybind(properties)
    return self:_register(require(script.Parent.keybind).new(self, properties))
end
function Tab:CreateColorPicker(properties)
    return self:_register(require(script.Parent.colorpicker).new(self, properties))
end
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

    if window._searching then
        search.close(window, {
            showTabs = true,
            jumpTo = window.selectedTab and window.selectedTab.tabPage,
        })
    end

    local idx = table.find(window.tabs, self)

    if idx then
        table.remove(window.tabs, idx)
    end
    if window.selectedTab == self then
        window.selectedTab = nil

        for _, tab in ipairs(window.tabs)do
            if not tab.neglectSelector then
                tab:Select()

                break
            end
        end
    end

    teardownElements(window, self.elements)

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
    [24] = function()local wax,script,require=ImportGlobals(24)local ImportGlobals return (function(...)local TabSection = {}

TabSection.__index = TabSection
TabSection.__type = 'TabSection'

local locale = require(script.Parent.Parent.utility.locale)
local log = require(script.Parent.Parent.utility.log)
local sectionInset = 20
local spacingAbove = 6
local spacingBelow = 3

local function anythingAbove(window)
    for _, tab in window.tabs do
        if not tab.neglectSelector then
            return true
        end
    end

    return #window.tabSections > 0
end

function TabSection.new(window, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        name = properties.name or properties.Name or 'Section',
        icon = properties.icon or properties.Icon,
    }, TabSection)

    if window.layout.mode ~= 'sidebar' then
        if not window._warnedTabSection then
            window._warnedTabSection = true

            log.warn(
[[Slate: Window:CreateSection needs the sidebar layout; it does nothing on the top strip.]])
        end

        self.inert = true

        return self
    end

    self.main = window:Create('Frame', {
        Name = self.name,
        Size = UDim2.new(1, -sectionInset * 2, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        Parent = window.tabList,
    })
    self.padding = window:Create('UIPadding', {
        PaddingTop = UDim.new(0, if anythingAbove(window)then spacingAbove else 0),
        PaddingBottom = UDim.new(0, spacingBelow),
        Parent = self.main,
    })

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.main,
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 0,
            ImageTransparency = 1,
            Parent = self.main,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = window:Create('TextLabel', {
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
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    return self
end
function TabSection:_setShown(shown, animate)
    if not self.main then
        return
    end

    local w = self.window

    w:_reveal(self.title, {
        TextTransparency = if shown then 0.6 else 1,
    }, animate)

    if self.iconLabel then
        w:_reveal(self.iconLabel, {
            ImageTransparency = if shown then 0.65 else 1,
        }, animate)
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
    [25] = function()local wax,script,require=ImportGlobals(25)local ImportGlobals return (function(...)local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local locale = require(utility.locale)
local tabSelector = {}

local function initialOf(name: string?): string
    if type(name) ~= 'string' or name == '' then
        return '?'
    end

    local afterFirst = utf8.offset(name, 2)
    local first = if afterFirst then string.sub(name, 1, afterFirst - 1)else name

    return string.upper(first)
end

tabSelector.states = {
    top = {
        selected = {
            background = 0,
            stroke = 0,
            content = 0,
        },
        hover = {
            background = 0.4,
            stroke = 0.3,
            content = 0.3,
        },
        unselected = {
            background = 0.8,
            stroke = 0.65,
            content = 0.5,
        },
        hidden = {
            background = 1,
            stroke = 1,
            content = 1,
        },
    },
    sidebar = {
        selected = {
            background = 0.4,
            stroke = 0.5,
            content = 0,
            shadow = 0.8,
        },
        hover = {
            background = 0.7,
            stroke = 0.8,
            content = 0.3,
            shadow = 1,
        },
        unselected = {
            background = 1,
            stroke = 1,
            content = 0.5,
            shadow = 1,
        },
        hidden = {
            background = 1,
            stroke = 1,
            content = 1,
            shadow = 1,
        },
    },
}

local function addGradients(tab, host, stroke)
    tab.topbarItemGradient = tab.window:Create('UIGradient', {
        Rotation = 90,
        Parent = host,
    }, {
        Color = {
            'TabBackground',
            functions.toColorSequence,
        },
    })
    tab.topbarItemStrokeGradient = tab.window:Create('UIGradient', {
        Rotation = 90,
        Parent = stroke,
    }, {
        Color = {
            'TabStroke',
            functions.toColorSequence,
        },
    })
end
local function addContent(tab, iconSize, withInitial)
    if withInitial and not tab.icon then
        tab.topbarItemInitial = tab.window:Create('TextLabel', {
            Text = initialOf(tab.name),
            Size = UDim2.fromOffset(iconSize, iconSize),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = iconSize - 4,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            Visible = false,
            TextTransparency = 1,
            Parent = tab.topbarItemContainer,
        }, {
            TextColor3 = 'TabColor',
            FontFace = 'Font',
        })
    end
    if tab.icon then
        local iconProps = {
            Image = tab.icon,
            Size = UDim2.fromOffset(iconSize, iconSize),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = tab.topbarItemContainer,
        }
        if tab.iconColor then
            iconProps.ImageColor3 = tab.iconColor
        end
        tab.topbarItemIcon = tab.window:Create('ImageLabel', iconProps, if tab.iconColor then nil else {
            ImageColor3 = 'TabColor',
        })
    end
    if tab.name then
        tab.topbarItemTitle = tab.window:Create('TextLabel', {
            Text = locale.t(tab.name),
            Size = UDim2.fromOffset(0, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextSize = 16,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,
            TextTransparency = 1,
            Parent = tab.topbarItemContainer,
        }, {
            TextColor3 = 'TabColor',
            FontFace = 'Font',
        })
    end
end
local function buildPill(tab)
    tab.topbarItem = tab.window:Create('Frame', {
        Name = tab.name,
        Size = UDim2.fromOffset(0, 34),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Visible = false,
        LayoutOrder = tab.customOrder or 0,
        Parent = tab.window.tabList,
    })
    tab.topbarItemInteract = tab.window:Create('TextButton', {
        Active = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = '',
        TextTransparency = 1,
        Parent = tab.topbarItem,
    })

    tab.window:Create('UICorner', {
        Parent = tab.topbarItem,
    }, {
        CornerRadius = 'PillCornerRadius',
    })

    tab.topbarItemStroke = tab.window:Create('UIStroke', {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = tab.topbarItem,
    })

    addGradients(tab, tab.topbarItem, tab.topbarItemStroke)

    tab.topbarItemContainer = tab.window:Create('Frame', {
        Size = UDim2.fromOffset(0, 34),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = tab.topbarItem,
    })

    tab.window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 13),
        PaddingRight = UDim.new(0, 14),
        Parent = tab.topbarItemContainer,
    })

    tab.topbarItemLayout = tab.window:Create('UIListLayout', {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab.topbarItemContainer,
    })

    addContent(tab, 16, false)
end
local function buildRow(tab, layout)
    tab.topbarItem = tab.window:Create('Frame', {
        Name = tab.name,
        Size = UDim2.new(1, -layout.rowInset * 2, 0, layout.rowHeight),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Visible = false,
        LayoutOrder = tab.customOrder or 0,
        Parent = tab.window.tabList,
    })
    tab.topbarItemInteract = tab.window:Create('TextButton', {
        Active = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = '',
        TextTransparency = 1,
        Parent = tab.topbarItem,
    })

    tab.window:Create('UICorner', {
        CornerRadius = UDim.new(0, layout.rowCornerRadius),
        Parent = tab.topbarItem,
    })

    tab.topbarItemStroke = tab.window:Create('UIStroke', {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = tab.topbarItem,
    })

    addGradients(tab, tab.topbarItem, tab.topbarItemStroke)

    tab.topbarItemShadow = tab.window:Create('UIShadow', {
        BlurRadius = UDim.new(0, 20),
        Color = Color3.fromRGB(255, 255, 255),
        Offset = UDim2.new(0, 0, 0, -15),
        Spread = UDim2.new(0, 10, 0, -30),
        ZIndex = -1,
        Transparency = 1,
        Parent = tab.topbarItem,
    })
    tab.topbarItemContainer = tab.window:Create('Frame', {
        Size = UDim2.new(1, -layout.rowPadding, 0, 24),
        Position = UDim2.new(0, layout.rowPadding, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = tab.topbarItem,
    })
    tab.topbarItemLayout = tab.window:Create('UIListLayout', {
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
    if layout.mode == 'sidebar' then
        buildRow(tab, layout)
    else
        buildPill(tab)
    end
end
function tabSelector.setRowCollapsed(tab, collapsed, layout)
    if layout.mode ~= 'sidebar' or not tab.topbarItem then
        return
    end
    if tab.topbarItemTitle then
        tab.topbarItemTitle.Visible = not collapsed
    end
    if tab.topbarItemInitial then
        tab.topbarItemInitial.Visible = collapsed
    end

    local inset = if collapsed then 0 else layout.rowPadding

    tab.topbarItemContainer.Size = UDim2.new(1, -inset, 0, 24)
    tab.topbarItemContainer.Position = UDim2.new(0, inset, 0.5, 0)
    tab.topbarItemLayout.HorizontalAlignment = if collapsed then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left
end
function tabSelector.applyVisual(tab, state, tweenInfo)
    local targets = {
        [tab.topbarItem] = {
            BackgroundTransparency = state.background,
        },
        [tab.topbarItemStroke] = {
            Transparency = state.stroke,
        },
    }

    if tab.topbarItemIcon then
        targets[tab.topbarItemIcon] = {
            ImageTransparency = state.content,
        }
    end
    if tab.topbarItemTitle then
        targets[tab.topbarItemTitle] = {
            TextTransparency = state.content,
        }
    end
    if tab.topbarItemInitial then
        targets[tab.topbarItemInitial] = {
            TextTransparency = state.content,
        }
    end
    if tab.topbarItemShadow and state.shadow then
        targets[tab.topbarItemShadow] = {
            Transparency = state.shadow,
        }
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
    [26] = function()local wax,script,require=ImportGlobals(26)local ImportGlobals return (function(...)local Tag = {}

Tag.__index = Tag
Tag.__type = 'Tag'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local image = require(utility.image)
local defaultColor = Color3.fromRGB(255, 175, 15)
local setTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Tag.new(window, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        text = properties.text or properties.Text or properties.title or properties.Title,
        icon = properties.icon or properties.Icon,
        color = properties.color or properties.Color or defaultColor,
    }, Tag)

    assert(self.icon or (self.text and self.text ~= ''), 'A Tag requires an icon, text, or both.')

    self.main = self.window:Create('Frame', {
        Name = 'Tag',
        Size = UDim2.fromOffset(10, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = self.color,
        BorderSizePixel = 0,
        LayoutOrder = properties.order or properties.Order or 0,
        BackgroundTransparency = 1,
        Parent = self.window.tagContainer,
    })

    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.main,
    })
    self.window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = self.main,
    })
    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.main,
    })

    local contrast = functions.contrastColor(self.color)

    self.iconLabel = self.window:Create('ImageLabel', {
        Name = 'Icon',
        Image = self.icon or '',
        ImageColor3 = contrast,
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Visible = self.icon ~= nil,
        ZIndex = 5,
        ImageTransparency = 1,
        Parent = self.main,
    })
    self.title = self.window:Create('TextLabel', {
        Name = 'Title',
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(10, 15),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = self.text or '',
        TextColor3 = contrast,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        RichText = true,
        Visible = self.text ~= nil and self.text ~= '',
        LayoutOrder = 1,
        ZIndex = 5,
        TextTransparency = 1,
        Parent = self.main,
    }, {
        FontFace = 'Font',
    })
    self.window.tagContainer.Visible = true

    if not self.window.hidden then
        self:_setShown(true, setTweenInfo)
    end

    return self
end
function Tag:_setShown(shown, animate)
    local target = if shown then 0 else 1
    local info = if typeof(animate) == 'TweenInfo'
        then animate
        elseif animate
        then setTweenInfo
        else nil

    if info then
        variables.tweenService:Create(self.main, info, {BackgroundTransparency = target}):Play()
        variables.tweenService:Create(self.iconLabel, info, {ImageTransparency = target}):Play()
        variables.tweenService:Create(self.title, info, {TextTransparency = target}):Play()
    else
        self.main.BackgroundTransparency = target
        self.iconLabel.ImageTransparency = target
        self.title.TextTransparency = target
    end
end
function Tag:SetColor(color)
    self.color = color

    local contrast = functions.contrastColor(color)

    variables.tweenService:Create(self.main, setTweenInfo, {BackgroundColor3 = color}):Play()
    variables.tweenService:Create(self.iconLabel, setTweenInfo, {ImageColor3 = contrast}):Play()
    variables.tweenService:Create(self.title, setTweenInfo, {TextColor3 = contrast}):Play()
end
function Tag:SetText(text)
    self.text = text
    self.title.Text = text or ''
    self.title.Visible = text ~= nil and text ~= ''
end
function Tag:SetIcon(icon)
    self.icon = icon

    image.assign(self.iconLabel, 'Image', icon)

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
    [27] = function()local wax,script,require=ImportGlobals(27)local ImportGlobals return (function(...)local Text = {}

Text.__index = Text
Text.__type = 'Text'

local moveable = require(script.Parent.Parent.utility.moveable)
local locale = require(script.Parent.Parent.utility.locale)
local titleSize = 16
local bodySize = 14
local bodyShown = 0.45

function Text.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = tostring(properties.name or properties.Name or ''),
        text = tostring(properties.text or properties.Text or ''),
        icon = properties.icon or properties.Icon,
    }, Text)

    self.main = self.window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        Name = if self.name ~= ''then self.name else'Text',
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = self.window:StyleElementBody(self.main)

    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        Parent = self.main,
    })
    self.window:Create('UIListLayout', {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.main,
    })

    self.titleRow = self.window:Create('Frame', {
        Name = 'Title',
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = self.main,
    })

    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.titleRow,
    })

    if self.icon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.titleRow,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = self.window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.new(1, if self.icon then-22 else 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        RichText = true,
        TextSize = titleSize,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.titleRow,
    }, {
        TextColor3 = 'TitlingColor',
        FontFace = 'Font',
    })
    self.body = self.window:Create('TextLabel', {
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
        TextTransparency = 1,
        Parent = self.main,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    self:_applyPresence()

    return self
end
function Text:_applyPresence()
    self.titleRow.Visible = self.name ~= '' or self.icon ~= nil
    self.body.Visible = self.text ~= ''
end
function Text:Set(text)
    self.text = tostring(text)

    self.window:_bindLocale(self.body, 'Text', self.text)
    self:_applyPresence()
end
function Text:SetTitle(title)
    self.name = tostring(title)

    self.window:_bindLocale(self.title, 'Text', self.name)
    self:_applyPresence()
end
function Text:_setShown(shown, animate)
    if shown then
        self.window:_revealCommon(self, animate)
    else
        self.window:_hideCommon(self, animate)
    end

    self.window:_reveal(self.body, {
        TextTransparency = if shown then bodyShown else 1,
    }, animate)
end

moveable(Text)

return Text

end)() end,
    [28] = function()local wax,script,require=ImportGlobals(28)local ImportGlobals return (function(...)local Toast = {}

Toast.__index = Toast
Toast.__type = 'Toast'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local constants = require(utility.constants)
local image = require(utility.image)
local hapticEngine = require(utility.HapticEngine)
local slideInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local growInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeLong = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeShort = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local shrinkInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local iconSize = 24
local avatarSize = 32
local leftPadding = 18
local rightPadding = 18
local avatarLeftPadding = 10
local avatarRightPadding = 28
local iconGap = 12
local stackPadding = 8
local MIN_WIDTH, MAX_WIDTH = 140, 320
local maxLive = 6
local offscreenAbove = UDim2.new(0.5, 0, 0.5, -180)
local offscreenBelow = UDim2.new(0.5, 0, 0.5, 180)
local centred = UDim2.new(0.5, 0, 0.5, 0)

local function autoDuration(text)
    return math.clamp(#text * 0.06 + 3, 3, 9)
end
local function resolveImage(icon)
    if type(icon) == 'number' then
        return 'rbxassetid://' .. tostring(icon)
    end

    return icon
end

function Toast.new(window, properties, container)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        window = assert(window, 'Missing argument #1 (Window expected)'),
        title = properties.title or properties.Title or '',
        subtitle = properties.subtitle or properties.Subtitle,
        icon = properties.icon or properties.Icon,
        avatar = properties.avatar or properties.Avatar,
        minWidth = properties.minWidth or properties.MinWidth,
        subtitleAbove = properties.subtitleAbove or properties.SubtitleAbove or false,
        position = properties.position or 'Top',
        _hovered = false,
        _dismissed = false,
    }, Toast)

    self.duration = properties.duration or properties.Duration or autoDuration(self.title .. (self.subtitle or ''))

    local hasAvatar = self.avatar ~= nil and self.avatar ~= 0
    local hasIcon = hasAvatar or (self.icon ~= nil and self.icon ~= 0 and self.icon ~= '')

    self._iconImage = if hasAvatar
        then image.avatar(self.avatar, function(uri)
            if self.iconLabel and not self._dismissed and self.main.Parent then
                image.assign(self.iconLabel, 'Image', uri)
            end
        end)
        elseif hasIcon
        then resolveImage(self.icon)
        else nil
    self._iconSize = if hasAvatar then avatarSize else iconSize
    self._leftPad = if hasAvatar then avatarLeftPadding else leftPadding
    self._rightPad = if hasAvatar then avatarRightPadding else rightPadding
    self._minWidth = math.clamp(self.minWidth or 0, MIN_WIDTH, MAX_WIDTH)

    local hasSubtitle = self.subtitle ~= nil and self.subtitle ~= ''

    self.main = self.window:Create('Frame', {
        Name = 'Toast',
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.toast,
        Parent = container or self.window.toasts,
    })

    self.window:Create('UIPadding', {
        PaddingTop = UDim.new(0, stackPadding),
        Parent = self.main,
    })

    self.body = self.window:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 1, 0),
        Position = if self.position == 'Bottom'then offscreenBelow else offscreenAbove,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true,
        BorderSizePixel = 0,
        ZIndex = constants.zIndex.toast,
        BackgroundTransparency = 1,
        Parent = self.main,
    })

    self.window:Create('UIGradient', {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),
        Parent = self.body,
    }, {
        Color = {
            'WindowColor',
            functions.toColorSequence,
        },
    })
    self.window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.body,
    })

    self.stroke = self.window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.body,
    }, {
        Color = 'SurfaceStroke',
    })
    self.shadow = self.window:CreateGlow(self.body, 'ShadowColor', 20, 1)

    self.window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, self._leftPad),
        PaddingRight = UDim.new(0, self._rightPad),
        Parent = self.body,
    })
    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, iconGap),
        Parent = self.body,
    })

    if hasIcon then
        self.iconLabel = self.window:Create('ImageLabel', {
            Image = self._iconImage,
            Size = UDim2.fromOffset(self._iconSize, self._iconSize),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            LayoutOrder = 1,
            ZIndex = constants.zIndex.toastContent,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.body,
        }, if hasAvatar then nil else{
            ImageColor3 = 'ContentColor',
        })

        self.window:Create('UICorner', {
            CornerRadius = UDim.new(1, 0),
            Parent = self.iconLabel,
        })
    end

    self.container = self.window:Create('Frame', {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, hasSubtitle and 32 or 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = constants.zIndex.toastContent,
        Parent = self.body,
    })

    self.window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1),
        Parent = self.container,
    })

    self.titleLabel = self.window:Create('TextLabel', {
        Text = self.title,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = if self.subtitleAbove then 2 else 1,
        ZIndex = constants.zIndex.toastContent,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'TitleFont',
    })

    if hasSubtitle then
        self.subtitleLabel = self.window:Create('TextLabel', {
            Text = self.subtitle,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 14),
            BackgroundTransparency = 1,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = if self.subtitleAbove then 1 else 2,
            ZIndex = constants.zIndex.toastContent,
            TextTransparency = 1,
            Parent = self.container,
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })
    end

    self.window._toastCount = (self.window._toastCount or 0) + 1
    self.main.LayoutOrder = -self.window._toastCount

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

    while#live > maxLive do
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                self:_dismiss()
            end
        end),
    }

    task.spawn(function()
        self:_show()
    end)

    return self
end
function Toast:_measure()
    local titleWidth = functions.textWidth(self.window.theme.TitleFont, 16, self.title)
    local subtitleWidth = if self.subtitleLabel then functions.textWidth(self.window.theme.Font, 14, self.subtitle)else 0
    local textWidth = math.max(titleWidth, subtitleWidth)
    local left = if self.iconLabel then self._leftPad + self._iconSize + iconGap else self._leftPad
    local width = math.clamp(left + textWidth + self._rightPad, self._minWidth, MAX_WIDTH)

    if left + textWidth + self._rightPad > MAX_WIDTH then
        local column = MAX_WIDTH - left - self._rightPad

        for _, label in {
            self.titleLabel,
            self.subtitleLabel,
        }do
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
function Toast:_show()
    if not self.main.Parent then
        return
    end

    hapticEngine.notify()

    local width, height = self:_measure()

    if self._dismissed or not self.main.Parent then
        return
    end

    self.main.Size = UDim2.new(0, width, 0, 0)

    variables.tweenService:Create(self.main, growInfo, {
        Size = UDim2.new(0, width, 0, height + stackPadding),
    }):Play()
    variables.tweenService:Create(self.body, slideInfo, {Position = centred}):Play()
    variables.tweenService:Create(self.body, fadeLong, {BackgroundTransparency = 0}):Play()
    variables.tweenService:Create(self.stroke, fadeLong, {Transparency = 0.9}):Play()
    variables.tweenService:Create(self.shadow, fadeShort, {Transparency = 0.6}):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, {TextTransparency = 0}):Play()
    task.wait(0.05)

    if self._dismissed or not self.main.Parent then
        return
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, {BackgroundTransparency = 0.95}):Play()
        variables.tweenService:Create(self.iconLabel, fadeShort, {ImageTransparency = 0}):Play()
    end

    task.wait(0.05)

    if self._dismissed or not self.main.Parent then
        return
    end
    if self.subtitleLabel then
        variables.tweenService:Create(self.subtitleLabel, fadeShort, {TextTransparency = 0.5}):Play()
    end

    local elapsed = 0

    while elapsed < self.duration and not self._dismissed and self.main.Parent do
        local dt = task.wait()

        if not self._hovered then
            elapsed += dt
        end
    end

    self:_dismiss()
end
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

    variables.tweenService:Create(self.body, fadeLong, {BackgroundTransparency = 1}):Play()
    variables.tweenService:Create(self.stroke, fadeLong, {Transparency = 1}):Play()
    variables.tweenService:Create(self.shadow, fadeShort, {Transparency = 1}):Play()
    variables.tweenService:Create(self.titleLabel, fadeShort, {TextTransparency = 1}):Play()

    if self.subtitleLabel then
        variables.tweenService:Create(self.subtitleLabel, fadeShort, {TextTransparency = 1}):Play()
    end
    if self.iconLabel then
        variables.tweenService:Create(self.iconLabel, fadeShort, {
            ImageTransparency = 1,
            BackgroundTransparency = 1,
        }):Play()
    end

    variables.tweenService:Create(self.body, shrinkInfo, {
        Size = UDim2.new(1, -60, 1, 0),
    }):Play()

    local collapse = variables.tweenService:Create(self.main, shrinkInfo, {
        Size = UDim2.new(0, self.main.Size.X.Offset, 0, 0),
    })

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
    [29] = function()local wax,script,require=ImportGlobals(29)local ImportGlobals return (function(...)local Toggle = {}

Toggle.__index = Toggle
Toggle.__type = 'Toggle'

local utility = script.Parent.Parent.utility
local variables = require(utility.variables)
local functions = require(utility.functions)
local moveable = require(utility.moveable)
local lockable = require(utility.lockable)
local locale = require(utility.locale)
local hapticEngine = require(utility.HapticEngine)

function Toggle.new(tab, properties)
    properties = if typeof(properties) == 'table'then properties else{}

    local self = setmetatable({
        tab = assert(tab, 'Missing argument #1 (Tab expected)'),
        window = tab.window,
        name = properties.name or properties.Name or 'Switch',
        icon = properties.icon or properties.Icon,
        description = properties.description or properties.Description,
        forgetState = properties.forgetState or properties.ForgetState or tab.forgetState,
        compact = tab.compact or false,
        flag = properties.flag or properties.Flag or (not (properties.forgetState or properties.ForgetState or tab.forgetState) and functions.deriveFlagFromName(properties.name or properties.Name or 'Switch') or nil),
        callback = properties.callback or properties.Callback or function() end,
        value = if(properties.value or properties.Value) ~= nil then(properties.value or properties.Value)else false,
    }, Toggle)

    self.window:_registerControl(self)

    if self.compact then
        self:_buildCompact()
    else
        self:_buildFull()
    end
    if self.description and not self.compact then
        self.descriptor = require(script.Parent.descriptor).new(self.tab, {
            description = self.description,
        })
    end

    return self
end
function Toggle:_buildSwitch(parent)
    local window = self.window

    self.functionContainer = window:Create('Frame', {
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(50, 21),
        BackgroundTransparency = 1,
        Parent = parent,
    }, {
        BackgroundColor3 = 'ToggleTrack',
    })

    window:Create('UICorner', {
        CornerRadius = UDim.new(0, 15),
        Parent = self.functionContainer,
    })

    self.containerStroke = window:Create('UIStroke', {
        Transparency = 1,
        Parent = self.functionContainer,
    }, {
        Color = 'SurfaceStroke',
    })
    self.indicator = window:Create('Frame', {
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(25, 17),
        Position = self.value and UDim2.new(1, -28, 0.5, 0) or UDim2.new(1, -47, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.value and self.window.theme.AccentColor or self.window.theme.ToggleKnobOff,
        BackgroundTransparency = 1,
        Parent = self.functionContainer,
    })

    window:Create('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Parent = self.indicator,
    })

    self.indicatorStroke = window:Create('UIStroke', {
        Color = self.value and self.window.theme.AccentStroke or Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = self.indicator,
    })
    self.indicatorGlow = window:CreateGlow(self.indicator, 'AccentColor', 20, 1)
    self.overlay = window:Create('Frame', {
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.functionContainer,
    }, {
        Visible = 'DarkToggleOverlay',
    })

    window:Create('UICorner', {
        CornerRadius = UDim.new(0, 15),
        Parent = self.overlay,
    })

    self.overlayGradient = window:Create('UIGradient', {
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
function Toggle:_performToggle()
    hapticEngine.click()

    self.value = not self.value

    self:_animateIndicator()
    self.window:_runGuarded(self, self.callback, self.value)
    self.window:_persist(self)
end
function Toggle:_buildFull()
    local window = self.window

    self.main = window:Create('Frame', {
        Size = UDim2.new(1, -20, 0, 41),
        BorderSizePixel = 0,
        Name = self.name,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tab.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    self.stroke = window:StyleElementBody(self.main)
    self.hoverOverlay = window:CreateHoverOverlay(self.main)
    self.container = window:Create('Frame', {
        BorderSizePixel = 0,
        Parent = self.main,
        Size = UDim2.new(0, 170, 0, 16),
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
    })
    self.containerLayout = window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(250, 16),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })
    self.interact = window:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(1, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        TextTransparency = 1,
        ZIndex = 10,
        Parent = self.main,
    })

    self:_buildSwitch(self.main)

    self.functionContainer.Position = UDim2.new(1, -15, 0, 20)
    self.functionContainer.AnchorPoint = Vector2.new(1, 0.5)

    self.window:_wireElementHover(self)
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        variables.tweenService:Create(self.main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -26, 0, 41),
        }):Play()
        self:_performToggle()
        task.wait(0.11)
        variables.tweenService:Create(self.main, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -20, 0, 41),
        }):Play()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Transparency = self.window.theme.ElementStrokeTransparency,
        }):Play()
    end)
end
function Toggle:_buildCompact()
    local window = self.window

    self.main, self.stroke, self.interact = window:_buildCompactRow(self.tab, self.name, 10)
    self.hoverOverlay = self.interact

    window:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = self.interact,
    })
    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
        Padding = UDim.new(0, 10),
        Parent = self.interact,
    })

    self.container = window:Create('Frame', {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 0,
        Parent = self.interact,
    })

    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.container,
    })
    window:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Parent = self.container,
    })

    if self.icon then
        self.iconLabel = window:Create('ImageLabel', {
            Image = self.icon,
            Size = UDim2.fromOffset(16, 16),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            ImageTransparency = 1,
            Parent = self.container,
        }, {
            ImageColor3 = 'ContentColor',
        })
    end

    self.title = window:Create('TextLabel', {
        Text = locale.t(self.name),
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = 1,
        TextTransparency = 1,
        Parent = self.container,
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

    window:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
        Parent = self.title,
    })
    self:_buildSwitch(self.interact)

    self.functionContainer.LayoutOrder = 1

    self.window:_wireElementHover(self)
    self.window:ConnectFor(self, self.interact.MouseButton1Click, function()
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 1}):Play()
        self:_performToggle()
        task.wait(0.11)
        variables.tweenService:Create(self.stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Transparency = self.window.theme.ElementStrokeTransparency,
        }):Play()
    end)
end
function Toggle:_animateIndicator()
    local info = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    if self.indicatorGlow then
        variables.tweenService:Create(self.indicatorGlow, info, {
            Transparency = self.value and self.window.theme.AccentGlow or 1,
        }):Play()
    end
    if self.value then
        variables.tweenService:Create(self.indicator, info, {
            Position = UDim2.new(1, -28, 0.5, 0),
            BackgroundColor3 = self.window.theme.AccentColor,
            BackgroundTransparency = 0,
        }):Play()
        variables.tweenService:Create(self.indicatorStroke, info, {
            Color = self.window.theme.AccentStroke,
            Transparency = 0,
        }):Play()
    else
        variables.tweenService:Create(self.indicator, info, {
            Position = UDim2.new(1, -47, 0.5, 0),
            BackgroundColor3 = self.window.theme.ToggleKnobOff,
            BackgroundTransparency = self.window.theme.ToggleKnobOffTransparency,
        }):Play()
        variables.tweenService:Create(self.indicatorStroke, info, {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.7,
        }):Play()
    end
end

local toggleReveal = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local toggleGlowReveal = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0.35)

function Toggle:_setShown(shown, animate)
    local w = self.window

    if shown then
        w:_revealCommon(self, animate)
        w:_reveal(self.indicator, {
            BackgroundColor3 = self.value and w.theme.AccentColor or w.theme.ToggleKnobOff,
            BackgroundTransparency = self.value and 0 or w.theme.ToggleKnobOffTransparency,
        }, animate, toggleReveal)
        w:_reveal(self.indicatorStroke, {
            Color = self.value and w.theme.AccentStroke or Color3.fromRGB(255, 255, 255),
            Transparency = self.value and 0 or 0.7,
        }, animate, toggleReveal)
        w:_reveal(self.indicatorGlow, {
            Transparency = self.value and w.theme.AccentGlow or 1,
        }, animate, toggleGlowReveal)
        w:_reveal(self.overlay, {BackgroundTransparency = 0}, animate, toggleReveal)
        w:_reveal(self.containerStroke, {Transparency = 0.85}, animate, toggleReveal)
        w:_reveal(self.functionContainer, {
            BackgroundTransparency = w.theme.ToggleTrackTransparency,
        }, animate, toggleReveal)
    else
        w:_hideCommon(self, animate)
        w:_reveal(self.indicator, {BackgroundTransparency = 1}, animate, toggleReveal)
        w:_reveal(self.indicatorStroke, {Transparency = 1}, animate, toggleReveal)
        w:_reveal(self.indicatorGlow, {Transparency = 1}, animate, toggleGlowReveal)
        w:_reveal(self.overlay, {BackgroundTransparency = 1}, animate, toggleReveal)
        w:_reveal(self.containerStroke, {Transparency = 1}, animate, toggleReveal)
        w:_reveal(self.functionContainer, {BackgroundTransparency = 1}, animate, toggleReveal)
    end
end
function Toggle:_refreshTheme()
    local t = self.window.theme
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local ts = variables.tweenService

    ts:Create(self.functionContainer, info, {
        BackgroundTransparency = t.ToggleTrackTransparency,
    }):Play()
    ts:Create(self.indicator, info, {
        BackgroundColor3 = self.value and t.AccentColor or t.ToggleKnobOff,
        BackgroundTransparency = self.value and 0 or t.ToggleKnobOffTransparency,
    }):Play()
    ts:Create(self.indicatorStroke, info, {
        Color = self.value and t.AccentStroke or Color3.fromRGB(255, 255, 255),
    }):Play()

    if self.indicatorGlow then
        ts:Create(self.indicatorGlow, info, {
            Transparency = self.value and t.AccentGlow or 1,
        }):Play()
    end
end
function Toggle:_minWidth()
    local w = 30 + 10 + 50

    if self.icon then
        w += 21
    end

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
    if not skipCallback then
        self.window:_runGuarded(self, self.callback, self.value)
        self.window:_persist(self)
    end
end

return Toggle

end)() end,
    [30] = function()local wax,script,require=ImportGlobals(30)local ImportGlobals return (function(...)local utility = script.Parent.Parent.utility
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
local variables = require(utility.variables)
local themes = script.Parent.Parent.themes
local Window = {}

Window.__index = Window

local revealInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local collapsedSize = UDim2.fromOffset(185, 50)
local collapsedIconSize = UDim2.fromOffset(50, 50)
local collapsedTop = UDim2.new(0.5, 0, 0, 20)
local topToastOpenPosition = UDim2.new(0.5, 0, 0, 12)
local topToastClosedPosition = UDim2.new(0.5, 0, 0, collapsedTop.Y.Offset + collapsedSize.Y.Offset + 12)
local topToastMoveInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local maxToastWidth = 320
local compactRowHeight = 41
local lockScrimTransparency = 0.55
local lockedDescriptionTransparency = 0.55
local tabStagger = 0.04
local maxStaggeredTabs = 8
local viewportReconcileInterval = 2

local function fitWindowSize(mode, customSize): UDim2
    if typeof(customSize) == 'UDim2' then
        return customSize
    elseif typeof(customSize) == 'Vector2' then
        return UDim2.fromOffset(customSize.X, customSize.Y)
    elseif typeof(customSize) == 'string' and (customSize:lower() == 'max' or customSize:lower() == 'maximum' or customSize:lower() == 'full') then
        local camera = variables.workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
        return UDim2.fromOffset(math.floor(viewport.X * 0.94), math.floor(viewport.Y * 0.88))
    elseif typeof(customSize) == 'table' then
        local x = customSize.X or customSize.width or customSize[1] or 740
        local y = customSize.Y or customSize.height or customSize[2] or 480
        return UDim2.fromOffset(x, y)
    end

    local camera = variables.workspace.CurrentCamera

    return windowSizing.fit(camera and camera.ViewportSize, mode)
end

local cornerNames = {
    'TopLeftRadius',
    'TopRightRadius',
    'BottomLeftRadius',
    'BottomRightRadius',
}
local perCornerSupported = (function()
    return (pcall(function()
        local probe = Instance.new('UICorner')

        probe.TopLeftRadius = UDim.new(0, 1)

        probe:Destroy()
    end))
end)()

local function resolveLayout(value)
    return if value then layouts.sidebar else layouts.top
end

local gradientKeys = {
    WindowColor = true,
    ElementGradient = true,
    ElementStrokeGradient = true,
    TabBackground = true,
    TabStroke = true,
    SliderProgress = true,
}

local function coerceThemeValue(key, value)
    if gradientKeys[key] and typeof(value) == 'Color3' then
        return ColorSequence.new(value)
    end

    return value
end
local function firstColor(value)
    return if typeof(value) == 'ColorSequence'then value.Keypoints[1].Value else value
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

    variables.tweenService:Create(container, topToastMoveInfo, {Position = target}):Play()
end
local function edgeShade(color, amount)
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
    local target = if luminance > 0.5 then Color3.new(0, 0, 0)else Color3.new(1, 1, 1)

    return color:Lerp(target, amount)
end
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
local function themeOverrides(value)
    if typeof(value) == 'table' then
        return value
    elseif typeof(value) == 'string' then
        local named = themes:FindFirstChild(string.lower(value))

        if named then
            return require(named)
        end

        log.warn("Slate: unknown theme '" .. value .. "', using default")
    elseif value ~= nil then
        log.warn(
[[Slate: invalid theme (expected a built-in name or a theme table), using default]])
    end

    return require(themes['default'])
end
local function resolveTheme(value)
    local resolved = table.clone(require(themes['default']))
    local overrides = themeOverrides(value)

    for key, override in overrides do
        resolved[key] = coerceThemeValue(key, override)
    end

    if typeof(value) == 'table' then
        deriveStrokes(resolved, overrides)
    end

    local userTable = if typeof(value) == 'table'then value else nil

    if not (userTable and (userTable.Font or userTable.font)) then
        resolved.Font = variables.brandFont(Enum.FontWeight.Medium)
    end
    if not (userTable and (userTable.TitleFont or userTable.titleFont)) then
        resolved.TitleFont = variables.brandFont(Enum.FontWeight.SemiBold)
    end

    return resolved
end

function Window.new(properties)
    properties = if typeof(properties) == 'table'then properties else{}

    if properties.translations or properties.Translations then
        locale.register(properties.translations or properties.Translations)
    end
    if properties.translator or properties.Translator then
        locale.translator = properties.translator or properties.Translator
    end

    locale.setActive(properties.locale or properties.Locale or locale.detect())

    local fallbackFont = properties.fallbackFont or properties.FallbackFont

    if fallbackFont then
        variables.setFallbackFont(fallbackFont)
    end

    local layout = resolveLayout(properties.sidebarLayout or properties.SidebarLayout)
    local requestedSize = properties.size or properties.Size or properties.windowSize or properties.WindowSize
    local self = setmetatable({
        name = properties.name or properties.Name or 'Slate Window',
        subheading = properties.subtitle or properties.Subtitle,
        layout = layout,
        size = fitWindowSize(layout.mode, requestedSize),
        instances = {},
        connections = {},
        icon = properties.icon or properties.Icon or constants.icons.slate,
        iconColor = properties.iconColor or properties.IconColor,
        showName = properties.showName or properties.ShowName or 'Slate',
        showIcon = properties.showIcon or properties.ShowIcon or constants.icons.slate,
        showIconOnly = properties.showIconOnly or properties.ShowIconOnly or false,
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

    self.Flags = setmetatable({}, {
        __index = function(_, flag)
            local control = self.controls[flag]

            return control and control.value
        end,
        __newindex = function(_, flag, value)
            local control = self.controls[flag]

            if not control then
                log.warn("Slate: no flag '" .. tostring(flag) .. "' to set")

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
    self.settings = {
        toggleKeybind = Enum.KeyCode.K,
        mouseOverride = true,
        keepOnScreen = true,
        welcomeToast = true,
        haptics = true,
        showProfile = true,
    }
    self.screenGui = self:Create('ScreenGui', {
        Name = variables.httpService:GenerateGUID(false),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Enabled = true,
        DisplayOrder = constants.displayOrder.window,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = variables.guiContainer,
    })
    self.main = self:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Name = self.name,
        ZIndex = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = self.size,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.screenGui,
    })
    self.drag = require(script.Parent.drag).new(self)
    self.windowCorner = self:Create('UICorner', {
        Parent = self.main,
    }, {
        CornerRadius = 'CornerRoundness',
    })
    self.windowStroke = self:Create('UIStroke', {
        Transparency = 1,
        Parent = self.main,
    }, {
        Color = 'SurfaceStroke',
    })
    self.windowGradient = self:Create('UIGradient', {
        Rotation = 270,
        Offset = Vector2.new(0, -0.1),
        Parent = self.main,
    }, {
        Color = {
            'WindowColor',
            functions.toColorSequence,
        },
    })
    self.bottomFade = self:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.fromScale(1, 1),
        Size = self.layout.fadeSize,
        ZIndex = constants.zIndex.bottomFade,
        BackgroundTransparency = 1,
        Parent = self.main,
    })
    self.bottomFadeCorner = self:_roundCorners(self.bottomFade, self.layout.fadeCorners)
    self.bottomFadeGradient = self:Create('UIGradient', {
        Rotation = 270,
        Offset = Vector2.new(0, 0.2),
        Transparency = self.layout.fadeTransparency,
        Parent = self.bottomFade,
    }, {
        Color = {
            'WindowColor',
            function(color)
                return ColorSequence.new(functions.toColorSequence(color).Keypoints[1].Value)
            end,
        },
    })
    self.topbar = self:Create('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, self.layout.topbarHeight),
        Active = true,
        Parent = self.main,
    })
    self.topContainer = self:Create('Frame', {
        Size = UDim2.new(0, 300, 0, 24),
        Position = UDim2.new(0, 25, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Parent = self.topbar,
    })
    self.topContainerLayout = self:Create('UIListLayout', {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.topContainer,
    })
    self.titleContainer = self:Create('Frame', {
        Size = UDim2.fromOffset(50, 24),
        Position = UDim2.new(0, 25, 0.5, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = self.topContainer,
    })
    self.titleContainerLayout = self:Create('UIListLayout', {
        Padding = UDim.new(0, 3),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.titleContainer,
    })

    if self.name then
        self.title = self:Create('TextLabel', {
            Text = locale.t(self.name),
            FontFace = variables.brandFont(Enum.FontWeight.Medium),
            Size = UDim2.fromOffset(50, 20),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            TextSize = 20,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextTransparency = 1,
            Parent = self.titleContainer,
        }, {
            FontFace = 'Font',
            TextColor3 = 'TitlingColor',
        })
    end
    if self.icon then
        local iconProps = {
            Image = self.icon,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(26, 26),
            ImageTransparency = 1,
            LayoutOrder = 0,
            Parent = self.topContainer,
        }
        if self.iconColor then
            iconProps.ImageColor3 = self.iconColor
        end
        self.topbarIcon = self:Create('ImageLabel', iconProps, if self.iconColor then nil else {
            ImageColor3 = 'TitlingColor',
        })
    end
    if self.subheading then
        self.subtitle = self:Create('TextLabel', {
            Text = locale.t(self.subheading),
            Size = UDim2.fromOffset(50, 12),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextTransparency = 1,
            Parent = self.titleContainer,
        }, {
            TextColor3 = 'TitlingColor',
            FontFace = 'Font',
        })
    end

    self.tagContainer = self:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 25, 0.5, 0),
        Size = UDim2.fromOffset(50, 24),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Visible = false,
        Parent = self.topContainer,
    })
    self.tagContainerLayout = self:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.tagContainer,
    })
    self.windowShadow = self:CreateGlow(self.main, 'ShadowColor', 20, 1)
    self.elements = self:Create('Frame', {
        Size = UDim2.new(1, 0, 1, -self.layout.chromeHeight),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.main,
    })

    if self.layout.mode == 'sidebar' then
        self.elementsCorner = self:_roundCorners(self.elements, self.layout.cardCorners)
        self.elementsStroke = self:Create('UIStroke', {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Transparency = 1,
            Parent = self.elements,
        }, {
            Color = 'SurfaceStroke',
        })

        self:Create('UIGradient', {
            Rotation = self.layout.cardStrokeRotation,
            Transparency = self.layout.cardStrokeTransparency,
            Parent = self.elementsStroke,
        })
    end

    self.elementsLayout = self:Create('UIPageLayout', {
        Padding = UDim.new(0, 0),
        FillDirection = self.layout.pageDirection,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        ScrollWheelInputEnabled = false,
        GamepadInputEnabled = false,
        TouchInputEnabled = false,
        EasingStyle = Enum.EasingStyle.Exponential,
        TweenTime = 0.4,
        Parent = self.elements,
    })

    if self.layout.mode == 'sidebar' then
        sidebar.build(self, self.layout)
        sidebar.applyWidth(self, layouts.railWidthFor(self.layout, self.size.X.Offset))
    else
        self.tabList = self:Create('ScrollingFrame', {
            Name = 'Tabs',
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
        self.tabListLayout = self:Create('UIListLayout', {
            Padding = UDim.new(0, 7),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = self.tabList,
        })

        self:Create('UIPadding', {
            PaddingLeft = UDim.new(0, 22),
            PaddingRight = UDim.new(0, 10),
            Parent = self.tabList,
        })
    end

    self.actionContainer = self:Create('Frame', {
        AnchorPoint = Vector2.new(1, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 24),
        Position = UDim2.new(1, -20, 0.5, 0),
        BackgroundTransparency = 1,
        Parent = self.topbar,
    })
    self.actionsListLayout = self:Create('UIListLayout', {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.actionContainer,
    })
    self.rfSettings = self:CreateTab({
        name = 'Slate Settings',
        customOrder = 1000,
        neglectSelector = true,
        forgetState = true,
    })

    require(script.Parent.action).new(self, {
        name = 'Close',
        icon = constants.icons.close,
        order = 1,
        callback = function()
            self:ToggleHide()
        end,
    })

    self.minimiseAction = require(script.Parent.action).new(self, {
        name = 'Minimise',
        icon = constants.icons.minimise,
        order = 2,
        callback = function()
            self:ToggleMinimise()
        end,
    })
    self.settingsAction = require(script.Parent.action).new(self, {
        name = 'Settings',
        icon = constants.icons.settings,
        order = 3,
        linkedTab = self.rfSettings,
        callback = function()
            self.rfSettings:Select()
        end,
    })

    search.build(self)
    self:_applyRailWidth()

    self.unloaded = false
    self.minimised = false
    self.hidden = true
    self.animating = false
    self._revealing = false
    self.hasShownOnce = false
    self._collapsedShown = false

    self:LoadSettings()

    if self.layout.mode == 'sidebar' then
        sidebar.reflowProfile(self)
        sidebar.setSubtitle(self, self.profileText)
    end

    hapticEngine.setContainer(self.screenGui)
    hapticEngine.setEnabled(self.settings.haptics)
    chrome.buildCollapsedFace(self)
    self:_bindKeybind()
    self:_bindMouseOverride()
    self:_bindTopbarDrag()
    self:_watchViewport()
    self:_buildSettingsUI()
    self:_syncLiveAnimation()

    return self
end
function Window:_syncLiveAnimation()
    if not self.theme.LiveAnimation then
        self._liveAnimating = false

        return
    end
    if self._liveAnimating then
        return
    end

    self._liveAnimating = true
    self._liveGeneration = (self._liveGeneration or 0) + 1

    local generation = self._liveGeneration

    task.spawn(function()
        local out = true
        local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        while self._liveGeneration == generation and self._liveAnimating and not self.unloaded do
            local tweenW = variables.tweenService:Create(self.windowGradient, tweenInfo, {
                Offset = Vector2.new(if out then 0.4 else-0.2, 0),
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
    local overrides = if typeof(theme) == 'table'then theme else resolveTheme(theme)

    for name, value in overrides do
        self.theme[name] = coerceThemeValue(name, value)
    end

    if typeof(theme) == 'table' then
        deriveStrokes(self.theme, overrides)
    end

    for instance, properties in self.themeProperties do
        for property, value in properties do
            local targetValue = if typeof(value) == 'table'then value[2](self.theme[value[1] ])else self.theme[value]

            if typeof(targetValue) == 'Color3' or typeof(targetValue) == 'number' then
                variables.tweenService:Create(instance, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {[property] = targetValue}):Play()
            else
                instance[property] = targetValue
            end
        end
    end

    if self.hidden then
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
    assert(not self.unloaded, 'Cannot create a tab on an unloaded window.')

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
        if not self.hidden and not self.minimised then
            newTab.topbarItem.Visible = true

            newTab:_applyVisual(if self.selectedTab == newTab then'selected'else'unselected', TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
        end
    end

    return newTab
end
function Window:CreateSection(properties)
    assert(not self.unloaded, 'Cannot create a section on an unloaded window.')

    local section = require(script.Parent.tabSection).new(self, properties)

    table.insert(self.tabSections, section)

    if not section.inert and not self.hidden and not self.minimised then
        section:_setVisible(true)
        section:_setShown(true, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
    end

    return section
end
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
    assert(not self.unloaded, 'Cannot create a tag on an unloaded window.')

    local newTag = require(script.Parent.tag).new(self, properties)

    table.insert(self.tags, newTag)

    return newTag
end
function Window:_registerControl(control)
    if not control.flag or control.flag == '' or control.forgetState then
        return
    end

    local flag = control.flag

    if self.controls[flag] then
        local n = 2

        while self.controls[flag .. n] do
            n += 1
        end

        flag = flag .. n

        log.warn("Slate: duplicate config flag '" .. control.flag .. "', saving this one as '" .. flag .. "'. Set a unique flag to keep it stable across sessions.")
    end

    control.flag = flag
    self.controls[flag] = control

    return flag
end
function Window:_restoreLate(element)
    if not self._loadedConfig or not element.flag or element.forgetState then
        return
    end

    local wasLoading = self._loading

    self._loading = true

    persistence.applyTo(element, self._loadedConfig[element.flag])

    self._loading = wasLoading
end
function Window:_persist(control)
    if control.flag and not control.forgetState and self.configuration.autoSave and not self._loading then
        task.spawn(self.Save, self)
    end
end
function Window:_unregisterControl(control)
    if control.flag and self.controls[control.flag] == control then
        self.controls[control.flag] = nil
    end
end
function Window:_keybindUsing(key, exclude)
    if typeof(key) ~= 'EnumItem' or key == Enum.KeyCode.Unknown then
        return nil
    end

    for _, tab in self.tabs do
        for _, element in tab.elements do
            if element ~= exclude and element.__type == 'Keybind' and element.value == key then
                return element
            end
        end
    end

    return nil
end
function Window:Notify(properties)
    if self.unloaded then
        return
    end
    if not self.notifications then
        self.notifications = self:Create('Frame', {
            Name = 'Notifications',
            Size = UDim2.new(0, 300, 0, 800),
            Position = UDim2.new(1, -20, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Parent = self.screenGui,
        })

        self:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 0),
            Parent = self.notifications,
        })
    end

    return require(script.Parent.notification).new(self, properties)
end
function Window:Toast(properties)
    if self.unloaded then
        return
    end

    properties = if typeof(properties) == 'table'then properties else{}

    local position = properties.position or properties.Position or 'Top'
    local isTop = typeof(position) ~= 'string' or position:lower() ~= 'bottom'

    properties.position = if isTop then'Top'else'Bottom'

    local containerKey = if isTop then'_toastsTop'else'_toastsBottom'
    local container = self[containerKey]

    if not container then
        container = self:Create('Frame', {
            Name = 'Toasts',
            Size = UDim2.new(0, maxToastWidth, 1, -24),
            Position = if isTop then topToastOpenPosition else UDim2.new(0.5, 0, 1, 
-12),
            AnchorPoint = if isTop then Vector2.new(0.5, 0)else Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            ZIndex = constants.zIndex.toast,
            Parent = self.screenGui,
        })

        self:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = if isTop then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 0),
            Parent = container,
        })

        self[containerKey] = container

        if isTop then
            setTopToastPosition(self, false)
        end
    end

    return require(script.Parent.toast).new(self, properties, container)
end
function Window:Popup(properties)
    if self.unloaded then
        return
    end

    return require(script.Parent.popup).new(self, properties)
end
function Window:Hide()
    if self.animating or self.hidden then
        return
    end
    if self._searching then
        search.close(self, {
            showTabs = false,
            jumpTo = self.selectedTab and self.selectedTab.tabPage,
        })
    end
    if self._recordingKeybind then
        self._recordingKeybind:_stopRecording()
    end

    self.animating = true
    self._revealing = true
    self.hidden = true
    self.collapsedInteract.Visible = false

    if self.minimised then
        self.minimised = false

        image.assign(self.minimiseAction.iconLabel, 'Image', constants.icons.minimise)
    end

    self._restorePosition = self.main.Position

    local home, size = self:_collapsedRect()
    local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local moveInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local cornerInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local faceInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    variables.tweenService:Create(self.drag.dragCosmetic, fadeInfo, {
        Size = UDim2.fromOffset(0, 4),
        BackgroundTransparency = 1,
    }):Play()
    task.delay(0.18, function()
        if not self.hidden then
            return
        end

        self.drag.drag.Visible = false
    end)
    self:_fadeSurfaces(false, fadeInfo)

    if self.title then
        variables.tweenService:Create(self.title, fadeInfo, {TextTransparency = 1}):Play()
    end
    if self.subtitle then
        variables.tweenService:Create(self.subtitle, fadeInfo, {TextTransparency = 1}):Play()
    end
    if self.topbarIcon then
        variables.tweenService:Create(self.topbarIcon, fadeInfo, {ImageTransparency = 1}):Play()
    end

    for _, action in ipairs(self.actionContainer:GetChildren())do
        if action:IsA('Frame') then
            variables.tweenService:Create(action.ImageLabel, fadeInfo, {ImageTransparency = 1}):Play()
        end
    end
    for _, tag in self.tags do
        tag:_setShown(false, fadeInfo)
    end
    for _, tab in pairs(self.tabs)do
        if not tab.neglectSelector and tab.topbarItem then
            tab:_applyVisual('hidden', fadeInfo)
        end
    end

    self:_setTabSectionsShown(false, fadeInfo)
    self:_fadeSelectedElementsOut()

    local collapse = variables.tweenService:Create(self.main, moveInfo, {
        Size = size,
        Position = home,
    })

    collapse.Completed:Connect(function()
        if self.unloaded or not self.hidden then
            return
        end

        self._collapsedShown = true

        setTopToastPosition(self, true)

        self.collapsedInteract.Visible = true
        self.animating = false
        self._revealing = false
    end)
    collapse:Play()
    variables.tweenService:Create(self.windowCorner, cornerInfo, {
        CornerRadius = UDim.new(1, 0),
    }):Play()
    task.delay(0.18, function()
        if not self.hidden then
            return
        end

        self.topbar.Visible = false

        self:_setContentVisible(false)
        chrome.setCollapsedShown(self, true, faceInfo)
    end)
end
function Window:SetSize(newSize, animate)
    if self.unloaded then
        return
    end

    local targetSize = fitWindowSize(self.layout.mode, newSize)
    self.size = targetSize

    if animate ~= false and not self.hidden and not self.minimised then
        variables.tweenService:Create(self.main, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = targetSize,
        }):Play()
    elseif not self.hidden and not self.minimised then
        self.main.Size = targetSize
    end
end
function Window:Maximise(animate)
    self:SetSize('max', animate)
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
    if self._searching then
        search.close(self, {showTabs = true})
    end

    self.animating = true

    local sizeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    if self.minimised then
        self.minimised = false

        image.assign(self.minimiseAction.iconLabel, 'Image', constants.icons.minimise)
        variables.tweenService:Create(self.main, sizeInfo, {
            Size = self.size,
        }):Play()
        self:_fadeSurfaces(true, fadeInfo)
        variables.tweenService:Create(self.drag.drag, sizeInfo, {
            Position = UDim2.new(self.main.Position.X.Scale, self.main.Position.X.Offset, self.main.Position.Y.Scale, self.main.Position.Y.Offset + self.size.Y.Offset / 2 + 15),
        }):Play()
        task.delay(0.2, function()
            if self.minimised or self.hidden then
                return
            end

            self:_setContentVisible(true)

            for _, tab in pairs(self.tabs)do
                if not tab.neglectSelector and tab.topbarItem then
                    tab.topbarItem.Visible = true

                    tab:_applyVisual(if self.selectedTab == tab then'selected'else'unselected', fadeInfo)
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

        image.assign(self.minimiseAction.iconLabel, 'Image', constants.icons.maximise)
        self:_fadeSelectedElementsOut()

        for _, tab in pairs(self.tabs)do
            if not tab.neglectSelector and tab.topbarItem then
                tab:_applyVisual('hidden', fadeInfo)
            end
        end

        self:_setTabSectionsShown(false, fadeInfo)
        task.delay(0.3, function()
            if not self.minimised then
                return
            end

            self:_setContentVisible(false)

            for _, tab in pairs(self.tabs)do
                if not tab.neglectSelector and tab.topbarItem then
                    tab.topbarItem.Visible = false
                end
            end

            self:_setTabSectionsVisible(false)
        end)
        self:_fadeSurfaces(false, fadeInfo)
        variables.tweenService:Create(self.main, sizeInfo, {
            Size = UDim2.fromOffset(self.size.X.Offset, self.layout.topbarHeight),
        }):Play()
        variables.tweenService:Create(self.drag.drag, sizeInfo, {
            Position = UDim2.new(self.main.Position.X.Scale, self.main.Position.X.Offset, self.main.Position.Y.Scale, self.main.Position.Y.Offset + self.layout.topbarHeight / 2 + 15),
        }):Play()
        task.delay(0.5, function()
            self.animating = false
        end)
    end
end
function Window:_syncDragBar()
    local bar = self.drag and self.drag.drag

    if not bar then
        return
    end

    local position = self.main.Position
    local below = self.size.Y.Offset / 2 + 15

    bar.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + below)
end
function Window:_clampedPosition(position: UDim2): UDim2
    if not self.settings or not self.settings.keepOnScreen then
        return position
    end
    if position.X.Scale ~= 0 or position.Y.Scale ~= 0 then
        return position
    end

    local screen = self.screenGui.AbsoluteSize
    local halfX, halfY = self.size.X.Offset / 2, self.size.Y.Offset / 2
    local margin = 8
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
function Window:_applyWindowSize()
    if self.unloaded then
        return
    end

    local size = fitWindowSize(self.layout.mode)
    local changed = size ~= self.size

    self.size = size

    self:_applyRailWidth()

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
function Window:_applyRailWidth()
    if self.layout.mode ~= 'sidebar' then
        return
    end

    sidebar.applyWidth(self, layouts.railWidthFor(self.layout, self.size.X.Offset))
end
function Window:_watchViewport()
    local cameraConnection: RBXScriptConnection? = nil
    local pending = false

    local function request()
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
            cameraConnection = self:Connect(camera:GetPropertyChangedSignal('ViewportSize'), request)
        end

        request()
    end

    self:Connect(variables.workspace:GetPropertyChangedSignal('CurrentCamera'), bind)
    bind()

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
    self:Connect(variables.userInputService.InputBegan, function(
        input,
        processed
    )
        if processed or self._recordingKeybind then
            return
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

    self:Connect(uis:GetPropertyChangedSignal('MouseBehavior'), free)
    self:Connect(uis:GetPropertyChangedSignal('MouseIconEnabled'), free)
    self:Connect(uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            free()
        end
    end)

    self._freeMouse = free
end
function Window:_bindTopbarDrag()
    local uis = variables.userInputService
    local dragging = false
    local relative = Vector2.zero
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
    local function overInteractiveChild(x, y)
        for _, region in {
            self.tabList,
            self.actionContainer,
        }do
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

        if inputType ~= 'MouseButton1' and inputType ~= 'Touch' then
            return
        end
        if overInteractiveChild(input.Position.X, input.Position.Y) then
            return
        end
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

        if inputType == 'MouseButton1' or inputType == 'Touch' then
            dragging = false
        end
    end)
    self:Connect(uis.WindowFocusReleased, function()
        dragging = false
    end)
    self:Connect(variables.runService.RenderStepped, function()
        if not dragging then
            return
        end
        if not self:_interactive() then
            dragging = false

            return
        end

        self.main.Position = getTarget()

        if self.drag and self.drag.drag then
            local mainPosition = self.main.Position

            self.drag.drag.Position = UDim2.new(mainPosition.X.Scale, mainPosition.X.Offset, mainPosition.Y.Scale, mainPosition.Y.Offset + (self.main.Size.Y.Offset / 2 + 15))
        end
    end)
end
function Window:_buildSettingsUI()
    self.rfSettings:CreateSection({
        name = 'General',
    })
    self.rfSettings:CreateKeybind({
        name = 'Toggle Keybind',
        icon = constants.icons.search,
        value = self.settings.toggleKeybind,
        isMenuToggle = true,
        onChanged = function(key)
            self.settings.toggleKeybind = key

            self:SaveSettings()
        end,
    })
    self.rfSettings:CreateToggle({
        name = 'Unlock cursor while open',
        description = 
[[Unlocks the cursor while the menu is open so you can configure in FPS games that lock it.]],
        value = self.settings.mouseOverride,
        callback = function(state)
            self.settings.mouseOverride = state

            self:SaveSettings()
        end,
    })
    self.rfSettings:CreateToggle({
        name = 'Welcome toast',
        description = 
[[Shows a 'Signed in as' toast the first time you open the menu on a new account.]],
        value = self.settings.welcomeToast,
        callback = function(state)
            self.settings.welcomeToast = state

            self:SaveSettings()
        end,
    })
    self.rfSettings:CreateToggle({
        name = 'Haptics',
        description = 
[[A subtle tap as you interact, on devices that support haptics.]],
        value = self.settings.haptics,
        callback = function(state)
            self.settings.haptics = state

            hapticEngine.setEnabled(state)
            self:SaveSettings()
        end,
    })
    self.rfSettings:CreateSection({
        name = 'Window',
    })

    if self.layout.mode == 'sidebar' and self.profile then
        self.rfSettings:CreateToggle({
            name = 'Show profile',
            description = 
[[Shows your avatar and name at the base of the sidebar. Turn it off to keep ]] .. 'them out of a stream or a screenshot.',
            value = self.settings.showProfile,
            callback = function(state)
                sidebar.setProfileEnabled(self, state)
                self:SaveSettings()
            end,
        })
    end

    self.rfSettings:CreateToggle({
        name = 'Keep window on screen',
        description = 
[[Stops the window being dragged off the edge of the screen and lost.]],
        value = self.settings.keepOnScreen,
        callback = function(state)
            self.settings.keepOnScreen = state

            self:SaveSettings()
        end,
    })
    self.rfSettings:CreateButton({
        name = 'Reset Window Position',
        callback = function()
            variables.tweenService:Create(self.main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }):Play()
            variables.tweenService:Create(self.drag.drag, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, self.size.Y.Offset / 2 + 15),
            }):Play()
        end,
    })

    if next(self.configuration) ~= nil then
        self.rfSettings:CreateSection({
            name = 'Configurations',
        })

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
            name = 'Saved Configurations',
            icon = constants.icons.config,
            options = self:ListConfigs(),
            value = selected,
            placeholder = 'No saved configurations',
            callback = function(value)
                selected = value
            end,
        })
        nameInput = self.rfSettings:CreateInput({
            name = 'Configuration Name',
            description = 
[[Name a new configuration, or leave blank to overwrite the selected one.]],
            placeholder = 'e.g. PvP Loadout',
            clearOnFocus = false,
        })

        local actions = self.rfSettings:CreateGroup()

        actions:CreateButton({
            name = 'Save',
            icon = constants.icons.config,
            callback = function()
                local name = nameInput.value

                if name == '' then
                    name = selected
                end
                if not name or name == '' then
                    self:Toast({
                        title = locale.resolve('Name your configuration first'),
                    })

                    return
                end
                if self:Save(name) then
                    nameInput:Set('')

                    selected = name

                    refreshConfigs()
                    self:Toast({
                        title = locale.resolve('Saved configuration'),
                        subtitle = name,
                        icon = constants.icons.config,
                    })
                else
                    self:Toast({
                        title = locale.resolve("Couldn't save configuration"),
                        subtitle = name,
                    })
                end
            end,
        })
        actions:CreateButton({
            name = 'Load',
            callback = function()
                if not selected or selected == '' then
                    self:Toast({
                        title = locale.resolve('Pick a configuration to load'),
                    })

                    return
                end
                if self:_applyNamedConfig(selected) then
                    self:Toast({
                        title = locale.resolve('Loaded configuration'),
                        subtitle = selected,
                    })
                else
                    self:Toast({
                        title = locale.resolve("Couldn't load configuration"),
                        subtitle = selected,
                    })
                end
            end,
        })
        actions:CreateButton({
            name = 'Delete',
            callback = function()
                local deleting = selected

                if not deleting or deleting == '' then
                    self:Toast({
                        title = locale.resolve('Pick a configuration to delete'),
                    })

                    return
                end
                if self:DeleteConfig(deleting) then
                    refreshConfigs()
                    self:Toast({
                        title = locale.resolve('Deleted configuration'),
                        subtitle = deleting,
                    })
                else
                    self:Toast({
                        title = locale.resolve("Couldn't delete configuration"),
                        subtitle = deleting,
                    })
                end
            end,
        })
    end
end
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
function Window:_roundCorners(parent, corners)
    if not corners or not perCornerSupported then
        return self:Create('UICorner', {Parent = parent}, {
            CornerRadius = 'CornerRoundness',
        })
    end

    local properties = {Parent = parent}
    local themed = {}

    for _, name in cornerNames do
        properties[name] = UDim.new(0, 0)
    end
    for _, name in corners do
        properties[name] = nil
        themed[name] = 'CornerRoundness'
    end

    return self:Create('UICorner', properties, themed)
end
function Window:_setElementLocked(element, locked, reason)
    locked = locked == true

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

    variables.tweenService:Create(element.lockScrim, info, {
        BackgroundTransparency = if locked then lockScrimTransparency else 1,
    }):Play()

    if not locked then
        task.delay(info.Time, function()
            if not element.locked and element.lockScrim then
                element.lockScrim.Visible = false
            end
        end)
    end

    local descriptor = element.descriptor

    if not descriptor then
        return
    end
    if locked then
        element._descriptionBefore = element._descriptionBefore or descriptor.titleLabel.Text
        descriptor.titleLabel.Text = locale.resolve(reason or 'This element is locked.')
    elseif element._descriptionBefore then
        descriptor.titleLabel.Text = element._descriptionBefore
        element._descriptionBefore = nil
    end

    variables.tweenService:Create(descriptor.titleLabel, info, {
        TextTransparency = if locked then lockedDescriptionTransparency else 0.7,
    }):Play()
end
function Window:_buildLockScrim(element)
    element.lockScrim = self:Create('TextButton', {
        Name = 'ElementLock',
        Active = true,
        AutoButtonColor = false,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        Text = '',
        TextTransparency = 1,
        ZIndex = constants.zIndex.elementLock,
        Visible = false,
        BackgroundTransparency = 1,
        Parent = element.main,
    }, {
        BackgroundColor3 = {
            'WindowColor',
            firstColor,
        },
    })

    self:Create('UICorner', {
        Parent = element.lockScrim,
    }, {
        CornerRadius = 'ElementCornerRadius',
    })
end
function Window:_setContentVisible(visible)
    self.elements.Visible = visible
    self.tabList.Visible = visible

    if self.sidebar then
        self.sidebar.Visible = visible
    end
end
function Window:_fadeSurfaces(shown, fadeInfo)
    local targets = {
        [self.windowShadow] = {
            Transparency = if shown then 0.6 else 1,
        },
        [self.windowStroke] = {
            Transparency = if shown then 0.95 else 1,
        },
        [self.bottomFade] = {
            BackgroundTransparency = if shown then 0 else 1,
        },
    }

    if self.elementsStroke then
        targets[self.elements] = {
            BackgroundTransparency = if shown then self.layout.cardTransparency else 1,
        }
        targets[self.elementsStroke] = {
            Transparency = if shown then 0 else 1,
        }
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
function Window:_fadeSelectedElementsOut()
    if self.selectedTab then
        for _, element in ipairs(self.selectedTab.elements)do
            element:_setShown(false, true)
        end
    end
end
function Window:_revealElements(perElementDelay, budget)
    for _, tab in pairs(self.tabs)do
        if tab ~= self.selectedTab then
            for _, element in ipairs(tab.elements)do
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

    for _, element in ipairs(tab.elements)do
        local top = element.main.AbsolutePosition.Y
        local onScreen = (top + element.main.AbsoluteSize.Y) > viewTop and top < viewBottom

        if onScreen then
            element:_setShown(true, true)

            staggered += 1

            if staggered <= maxStaggered then
                task.wait(perElementDelay)
            end
        else
            element:_setShown(true, false)
        end
    end
end
function Window:Show()
    if self.animating or not self.hidden then
        return
    end

    self.animating = true
    self._revealing = true

    if self.configuration.autoLoad and not self._autoLoaded then
        self._autoLoaded = true

        local ok, err = pcall(self.Load, self)

        if not ok then
            log.warn('Slate: Failed to load configuration - ' .. tostring(err))
        end
    end

    self.hidden = false
    self.minimised = false

    if self._themeRefreshPending then
        self._themeRefreshPending = false

        self:_refreshElementThemes()
    end

    self.collapsedInteract.Visible = false

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
    local target = self:_clampedPosition(self._restorePosition or UDim2.new(0.5, 0, 0.5, 0))

    self._restorePosition = target

    local growInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local cornerInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local fadeInfo = TweenInfo.new(0.28, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    chrome.setCollapsedShown(self, false, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))

    local restore = variables.tweenService:Create(self.main, growInfo, {
        Size = self.size,
        Position = target,
    })

    restore.Completed:Connect(function()
        if self.hidden or self.unloaded then
            return
        end

        self._collapsedShown = false

        setTopToastPosition(self, true)
    end)
    restore:Play()
    variables.tweenService:Create(self.windowCorner, cornerInfo, {
        CornerRadius = self.theme.CornerRoundness,
    }):Play()
    task.delay(0.22, function()
        self.topbar.Visible = true

        self:_setContentVisible(true)
        self:_fadeSurfaces(true, fadeInfo)

        if self.topbarIcon then
            variables.tweenService:Create(self.topbarIcon, fadeInfo, {ImageTransparency = 0}):Play()
        end
        if self.title then
            variables.tweenService:Create(self.title, fadeInfo, {TextTransparency = 0}):Play()
        end
        if self.subtitle then
            variables.tweenService:Create(self.subtitle, fadeInfo, {TextTransparency = 0.7}):Play()
        end

        for _, action in ipairs(self.actionContainer:GetChildren())do
            if action:IsA('Frame') then
                variables.tweenService:Create(action.ImageLabel, fadeInfo, {ImageTransparency = 0.6}):Play()
            end
        end

        if self.settingsAction and self.selectedTab == self.rfSettings then
            variables.tweenService:Create(self.settingsAction.iconLabel, fadeInfo, {ImageTransparency = 0.2}):Play()
        end

        for _, tag in self.tags do
            tag:_setShown(true, fadeInfo)
        end
        for _, tab in pairs(self.tabs)do
            if not tab.neglectSelector and tab.topbarItem then
                tab.topbarItem.Visible = true

                tab:_applyVisual(if self.selectedTab == tab then'selected'else'unselected', fadeInfo)
            end
        end

        self:_setTabSectionsVisible(true)
        self:_setTabSectionsShown(true, fadeInfo)
        self:_revealElements(0.035, 0.4)
    end)
    task.delay(0.22, function()
        self.drag.drag.Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset + self.size.Y.Offset / 2 + 15)
        self.drag.dragCosmetic.Size = UDim2.fromOffset(0, 4)
        self.drag.dragCosmetic.BackgroundTransparency = 1
        self.drag.drag.Visible = true

        variables.tweenService:Create(self.drag.dragCosmetic, growInfo, {
            Size = UDim2.fromOffset(100, 4),
            BackgroundTransparency = 0.7,
        }):Play()
    end)
    task.delay(0.6, function()
        self.animating = false
        self._revealing = false
    end)
end
function Window:_firstShow()
    self.drag.drag.Visible = false
    self.main.Visible = true

    local expandInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local fadeInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    variables.tweenService:Create(self.main, expandInfo, {
        BackgroundTransparency = 0,
        Size = self.size,
    }):Play()

    self.topbar.Visible = true
    self:_setContentVisible(true)
    self:_fadeSurfaces(true, fadeInfo)

    if self.icon and self.topbarIcon then
        variables.tweenService:Create(self.topbarIcon, fadeInfo, {ImageTransparency = 0}):Play()
    end
    if self.title then
        variables.tweenService:Create(self.title, fadeInfo, {TextTransparency = 0}):Play()
    end
    if self.subtitle then
        variables.tweenService:Create(self.subtitle, fadeInfo, {TextTransparency = 0.7}):Play()
    end

    for _, action in ipairs(self.actionContainer:GetChildren())do
        if action:IsA('Frame') then
            variables.tweenService:Create(action.ImageLabel, fadeInfo, {ImageTransparency = 0.6}):Play()
        end
    end
    for _, tag in self.tags do
        tag:_setShown(true, fadeInfo)
    end

    task.spawn(function()
        local info = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        self:_setTabSectionsVisible(true)
        self:_setTabSectionsShown(true, info)

        local staggered = 0

        for _, tab in pairs(self.tabs)do
            if not tab.neglectSelector then
                tab.topbarItem.Visible = true

                tab:_applyVisual(if self.selectedTab == tab then'selected'else'unselected', info)
                tab:_spinGradients()

                staggered += 1

                if staggered <= maxStaggeredTabs then
                    task.wait(tabStagger)
                end
            end
        end
    end)
    self:_revealElements(0.03, 1.5)
    task.wait(0.5)
    self:_syncDragBar()

    self.drag.drag.Visible = true

    variables.tweenService:Create(self.drag.dragCosmetic, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
    variables.tweenService:Create(self.drag.dragCosmetic, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(100, 4),
    }):Play()

    self.animating = false
    self._revealing = false

    local localPlayer = variables.localPlayer

    if localPlayer and self.settings.welcomeToast and chrome.isNewUser() then
        self:Toast({
            title = localPlayer.DisplayName,
            subtitle = locale.resolve('Signed in as'),
            subtitleAbove = true,
            avatar = localPlayer.UserId,
            minWidth = 220,
        })
    end
end
function Window:GetPath()
    return persistence.getPath(self)
end
function Window:Save(name)
    if name ~= nil and (type(name) ~= 'string' or name == '') then
        return false
    end

    return persistence.save(self, name)
end
function Window:Load(name)
    if name ~= nil and (type(name) ~= 'string' or name == '') then
        return false
    end

    return persistence.load(self, name)
end
function Window:_applyNamedConfig(name)
    if not self:Load(name) then
        return false
    end

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
function Window:Get(flag)
    local control = self.controls[flag]

    return control and control.value
end
function Window:Set(flag, value)
    local control = self.controls[flag]

    if not control then
        return false
    end

    control:Set(value)

    return true
end
function Window:_jumpTo(page)
    if page then
        self.elementsLayout:JumpTo(page)
    end
end
function Window:Navigate(tab)
    if tab == nil then
        return
    end

    local target

    for _, candidate in self.tabs do
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
    assert(typeof(className) == 'string', 'Invalid argument #1 (string expected)')

    local instance = Instance.new(className)

    if themeProperties and self.theme then
        for property, value in themeProperties do
            instance[property] = (if typeof(value) == 'table'then value[2](self.theme[value[1] ])else self.theme[value])
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
function Window:_bindLocale(instance, property, source)
    instance[property] = locale.resolve(source)

    local entries = self.localeProperties[instance]

    if not entries then
        entries = {}
        self.localeProperties[instance] = entries
    end

    entries[property] = source
end
function Window:SetLocale(localeId)
    locale.setActive(localeId)

    for instance, entries in self.localeProperties do
        for property, source in entries do
            instance[property] = locale.resolve(source)
        end
    end
end
function Window:SetTranslator(translator)
    locale.translator = translator
end
function Window:RegisterTranslations(tables)
    locale.register(tables)
    self:SetLocale(locale.current)
end
function Window:CreateGlow(parent, color, blur, transparency)
    local properties = {
        BlurRadius = UDim.new(0, blur),
        Transparency = transparency,
        ZIndex = -1,
        Parent = parent,
    }

    if typeof(color) == 'string' then
        return self:Create('UIShadow', properties, {
            Color = {
                color,
                function(value)
                    return if typeof(value) == 'ColorSequence'then value.Keypoints[1].Value else value
                end,
            },
        })
    end

    properties.Color = color

    return self:Create('UIShadow', properties)
end
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

    variables.tweenService:Create(box, inInfo, {BackgroundColor3 = fill}):Play()

    if stroke then
        variables.tweenService:Create(stroke, inInfo, {
            Color = edge,
            Transparency = 0.4,
        }):Play()
    end
    if glow then
        variables.tweenService:Create(glow, inInfo, {
            Color = edge,
            Transparency = 0.6,
        }):Play()
    end

    element._flashToken = (element._flashToken or 0) + 1

    local token = element._flashToken

    task.delay(0.22, function()
        if element._flashToken ~= token then
            return
        end

        variables.tweenService:Create(box, outInfo, {
            BackgroundColor3 = self.theme.FieldBackground,
        }):Play()

        if stroke then
            variables.tweenService:Create(stroke, outInfo, {
                Color = self.theme.SurfaceStroke,
                Transparency = 0.85,
            }):Play()
        end
        if glow then
            variables.tweenService:Create(glow, outInfo, {
                Color = self.theme.FieldGlow,
                Transparency = element._glowIdle or 1,
            }):Play()
        end
    end)
end
function Window:CreateHoverOverlay(parent)
    local overlay = self:Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = parent,
    })

    self:Create('UICorner', {Parent = overlay}, {
        CornerRadius = 'ElementCornerRadius',
    })

    return overlay
end
function Window:_wireElementHover(element)
    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local theme = self.theme

    self:ConnectFor(element, element.main.MouseEnter, function()
        if not self:_interactive() then
            return
        end

        variables.tweenService:Create(element.stroke, info, {
            Transparency = theme.ElementStrokeHoverTransparency,
            Color = theme.ElementStrokeHover,
        }):Play()
        variables.tweenService:Create(element.title, info, {
            TextColor3 = theme.ElementTextHoverColor,
        }):Play()

        if element.hoverOverlay then
            variables.tweenService:Create(element.hoverOverlay, info, {BackgroundTransparency = 0.97}):Play()
        end
    end)
    self:ConnectFor(element, element.main.MouseLeave, function()
        variables.tweenService:Create(element.stroke, info, {
            Transparency = theme.ElementStrokeTransparency,
            Color = theme.ElementStroke,
        }):Play()
        variables.tweenService:Create(element.title, info, {
            TextColor3 = theme.ContentColor,
        }):Play()

        if element.hoverOverlay then
            variables.tweenService:Create(element.hoverOverlay, info, {BackgroundTransparency = 1}):Play()
        end
    end)
end
function Window:_runGuarded(element, fn, ...)
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

        variables.tweenService:Create(flashFrame, quickOut, {
            BackgroundColor3 = self.theme.ErrorColor,
        }):Play()
        variables.tweenService:Create(element.stroke, quickOut, {
            Color = self.theme.ErrorStrokeColor,
        }):Play()

        if element.title then
            element.title.Text = locale.resolve('Error, log recorded in console.')
        end

        log.warn(`Slate encountered an error, with the callback for a {element.__type} component named '{element.name}':`)
        log.print(err)
        task.wait(1)

        if element.title then
            element.title.Text = locale.resolve(element.name)
        end

        variables.tweenService:Create(flashFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
        variables.tweenService:Create(element.stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Color = self.theme.ElementStroke,
        }):Play()

        element._errored = false
    end)
end
function Window:StyleElementBody(main)
    self:Create('UIGradient', {
        Rotation = 270,
        Parent = main,
    }, {
        Color = 'ElementGradient',
    })
    self:Create('UICorner', {Parent = main}, {
        CornerRadius = 'ElementCornerRadius',
    })

    return self:Create('UIStroke', {
        Transparency = 1,
        Parent = main,
    }, {
        Color = 'ElementStroke',
        Transparency = 'ElementStrokeTransparency',
    })
end
function Window:_buildCompactRow(host, name, interactZIndex)
    local main = self:Create('Frame', {
        Name = name,
        Size = UDim2.fromOffset(0, compactRowHeight),
        AutomaticSize = Enum.AutomaticSize.X,
        ClipsDescendants = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = host.tabPage,
    }, {
        BackgroundTransparency = 'ElementTransparency',
    })
    local stroke = self:StyleElementBody(main)

    self:Create('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Fill,
        Parent = main,
    })
    self:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Parent = main,
    })

    local interact = self:Create('TextButton', {
        Text = '',
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, compactRowHeight),
        BorderSizePixel = 0,
        TextTransparency = 1,
        ZIndex = interactZIndex or 1,
        Parent = main,
    })

    self:Create('UICorner', {Parent = interact}, {
        CornerRadius = 'ElementCornerRadius',
    })

    return main, stroke, interact
end
function Window:StyleElementPanel(frame)
    self:Create('UIGradient', {
        Rotation = 270,
        Parent = frame,
    }, {
        Color = 'ElementGradient',
    })
    self:Create('UICorner', {Parent = frame}, {
        CornerRadius = 'ElementCornerRadius',
    })

    local stroke = self:Create('UIStroke', {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 1,
        Parent = frame,
    })

    self:Create('UIGradient', {
        Rotation = 270,
        Parent = stroke,
    }, {
        Color = 'ElementStrokeGradient',
    })

    return stroke
end
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
function Window:_revealCommon(element, animate)
    self:_reveal(element.stroke, {
        Transparency = self.theme.ElementStrokeTransparency,
    }, animate)
    self:_reveal(element.title, {TextTransparency = 0}, animate)
    self:_reveal(element.main, {
        BackgroundTransparency = self.theme.ElementTransparency or 0,
    }, animate)

    if element.iconLabel then
        self:_reveal(element.iconLabel, {ImageTransparency = 0}, animate)
    end
    if element.descriptor then
        self:_reveal(element.descriptor.titleLabel, {TextTransparency = 0.7}, animate)
    end
end
function Window:_hideCommon(element, animate)
    self:_reveal(element.stroke, {Transparency = 1}, animate)
    self:_reveal(element.title, {TextTransparency = 1}, animate)
    self:_reveal(element.main, {BackgroundTransparency = 1}, animate)

    if element.iconLabel then
        self:_reveal(element.iconLabel, {ImageTransparency = 1}, animate)
    end
    if element.descriptor then
        self:_reveal(element.descriptor.titleLabel, {TextTransparency = 1}, animate)
    end
end
function Window:_collapsedRect()
    local size = if self.showIconOnly then collapsedIconSize else collapsedSize

    if self._collapsedPosition then
        return self._collapsedPosition, size
    end

    local home = UDim2.new(collapsedTop.X.Scale, collapsedTop.X.Offset, collapsedTop.Y.Scale, collapsedTop.Y.Offset + size.Y.Offset / 2)

    return home, size
end
function Window:_interactive()
    return not self.animating and not self.hidden
end
function Window:_settled()
    return not self.hidden and not self._revealing
end
function Window:Connect(signal, callback)
    local connection = signal:Connect(callback)

    table.insert(self.connections, connection)

    return connection
end
function Window:ConnectFor(owner, signal, callback)
    local connection = self:Connect(signal, callback)

    owner.connections = owner.connections or {}

    table.insert(owner.connections, connection)

    return connection
end
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
function Window:DestroySubtree(root)
    if not root then
        return
    end

    local inSubtree = {[root] = true}

    for _, descendant in root:GetDescendants()do
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
function Window:DestroySubtrees(roots)
    if not roots or #roots == 0 then
        return
    end

    local inSubtree = {}

    for _, root in roots do
        inSubtree[root] = true

        for _, descendant in root:GetDescendants()do
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

    hapticEngine.teardown()
    hapticEngine.releaseContainer(self.screenGui)

    if self._liveTween then
        self._liveTween:Cancel()

        self._liveTween = nil
    end

    for i = #self.connections, 1, -1 do
        self.connections[i]:Disconnect()
    end
    for i = #self.instances, 1, -1 do
        self.instances[i]:Destroy()
    end

    table.clear(self.connections)
    table.clear(self.instances)
    table.clear(self.themeProperties)
    table.clear(self.localeProperties)
    table.clear(self.controls)
    table.clear(self.tabs)
end

return Window

end)() end,
    [32] = function()local wax,script,require=ImportGlobals(32)local ImportGlobals return (function(...)return {
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
    AccentColor = Color3.fromRGB(168, 110, 246),
    AccentStroke = Color3.fromRGB(200, 154, 255),
    ToggleKnobOff = Color3.fromRGB(224, 214, 236),
    StatBackground = Color3.fromRGB(24, 18, 38),
    DropdownHighlight = Color3.fromRGB(168, 110, 246),
    NeutralButton = Color3.fromRGB(46, 36, 68),
    NeutralButtonHover = Color3.fromRGB(60, 48, 90),
    NeutralButtonStroke = Color3.fromRGB(140, 116, 190),
}

end)() end,
    [33] = function()local wax,script,require=ImportGlobals(33)local ImportGlobals return (function(...)return {
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
    AccentColor = Color3.fromRGB(48, 120, 240),
    AccentStroke = Color3.fromRGB(96, 164, 255),
    ToggleKnobOff = Color3.fromRGB(196, 206, 232),
    StatBackground = Color3.fromRGB(20, 26, 48),
    DropdownHighlight = Color3.fromRGB(48, 120, 240),
    NeutralButton = Color3.fromRGB(40, 48, 78),
    NeutralButtonHover = Color3.fromRGB(54, 64, 100),
    NeutralButtonStroke = Color3.fromRGB(120, 138, 195),
}

end)() end,
    [34] = function()local wax,script,require=ImportGlobals(34)local ImportGlobals return (function(...)local variables = require(script.Parent.Parent.utility.variables)

return {
    CornerRoundness = UDim.new(0, 20),
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35)),
    }),
    ShadowColor = Color3.fromRGB(20, 20, 20),
    ElementStroke = Color3.fromRGB(35, 35, 35),
    ElementGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.9999, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35)),
    }),
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
    LiveAnimation = false,
    DarkToggleOverlay = true,
    ElementTransparency = 0,
    ElementStrokeTransparency = 0,
    ElementStrokeHoverTransparency = 0,
    ElementStrokeHover = Color3.fromRGB(60, 60, 68),
    ElementCornerRadius = UDim.new(0, 12),
    ElementTextHoverColor = Color3.fromRGB(255, 255, 255),
    TitlingColor = Color3.fromRGB(255, 255, 255),
    DropdownHighlight = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(255, 255, 255),
    AccentStroke = Color3.fromRGB(255, 255, 255),
    AccentGlow = 0.05,
    StatBackground = Color3.fromRGB(20, 20, 24),
    SliderHandle = Color3.fromRGB(255, 255, 255),
    PillCornerRadius = UDim.new(1, 0),
    ToggleTrack = Color3.fromRGB(0, 0, 0),
    ToggleTrackTransparency = 0.9,
    ToggleKnobOff = Color3.fromRGB(160, 160, 170),
    ToggleKnobOffTransparency = 0.6,
    FieldBackground = Color3.fromRGB(255, 255, 255),
    FieldTransparency = 0.92,
    FieldGlow = Color3.fromRGB(255, 255, 255),
    PlaceholderColor = Color3.fromRGB(150, 150, 160),
    SurfaceStroke = Color3.fromRGB(255, 255, 255),
    NeutralButton = Color3.fromRGB(28, 28, 34),
    NeutralButtonHover = Color3.fromRGB(44, 44, 52),
    NeutralButtonStroke = Color3.fromRGB(80, 80, 90),
    ErrorColor = Color3.fromRGB(180, 180, 180),
    ErrorStrokeColor = Color3.fromRGB(240, 240, 240),
}

end)() end,
    [35] = function()local wax,script,require=ImportGlobals(35)local ImportGlobals return (function(...)return {
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
    AccentColor = Color3.fromRGB(240, 142, 40),
    AccentStroke = Color3.fromRGB(255, 182, 92),
    ToggleKnobOff = Color3.fromRGB(232, 224, 214),
    StatBackground = Color3.fromRGB(26, 21, 18),
    DropdownHighlight = Color3.fromRGB(240, 142, 40),
    NeutralButton = Color3.fromRGB(48, 40, 34),
    NeutralButtonHover = Color3.fromRGB(64, 54, 46),
    NeutralButtonStroke = Color3.fromRGB(150, 128, 104),
}

end)() end,
    [36] = function()local wax,script,require=ImportGlobals(36)local ImportGlobals return (function(...)local variables = require(script.Parent.Parent.utility.variables)

return {
    WindowColor = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(246, 249, 251)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 241, 245)),
    }),
    ShadowColor = Color3.fromRGB(116, 124, 132),
    LiveAnimation = false,
    ElementTransparency = 0,
    ElementStroke = Color3.fromRGB(218, 224, 228),
    ElementGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
    ElementStrokeGradient = ColorSequence.new(Color3.fromRGB(224, 230, 234), Color3.fromRGB(232, 238, 242)),
    ElementStrokeTransparency = 0.1,
    ElementStrokeHoverTransparency = 0,
    ElementStrokeHover = Color3.fromRGB(0, 176, 208),
    DarkToggleOverlay = false,
    TabColor = Color3.fromRGB(38, 42, 46),
    TabBackground = ColorSequence.new(Color3.fromRGB(0, 176, 208), Color3.fromRGB(0, 150, 184)),
    TabStroke = ColorSequence.new(Color3.fromRGB(80, 206, 230), Color3.fromRGB(0, 160, 196)),
    SliderBackground = Color3.fromRGB(224, 230, 234),
    SliderBackgroundHover = Color3.fromRGB(212, 220, 224),
    SliderProgress = ColorSequence.new(Color3.fromRGB(0, 182, 214), Color3.fromRGB(0, 146, 182)),
    SliderStroke = Color3.fromRGB(200, 206, 210),
    AccentColor = Color3.fromRGB(0, 176, 208),
    AccentStroke = Color3.fromRGB(96, 210, 232),
    AccentGlow = 0.85,
    StatBackground = Color3.fromRGB(255, 255, 255),
    SliderHandle = Color3.fromRGB(60, 66, 72),
    ToggleTrack = Color3.fromRGB(198, 204, 210),
    ToggleTrackTransparency = 0,
    ToggleKnobOffTransparency = 0.05,
    FieldBackground = Color3.fromRGB(224, 230, 234),
    FieldTransparency = 0,
    FieldGlow = Color3.fromRGB(148, 154, 160),
    PlaceholderColor = Color3.fromRGB(138, 144, 150),
    SurfaceStroke = Color3.fromRGB(204, 210, 214),
    NeutralButton = Color3.fromRGB(224, 230, 234),
    NeutralButtonHover = Color3.fromRGB(212, 220, 224),
    NeutralButtonStroke = Color3.fromRGB(242, 246, 248),
    ActionColor = Color3.fromRGB(68, 74, 80),
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
    [37] = function()local wax,script,require=ImportGlobals(37)local ImportGlobals return (function(...)return {
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
    AccentColor = Color3.fromRGB(240, 82, 138),
    AccentStroke = Color3.fromRGB(255, 134, 178),
    ToggleKnobOff = Color3.fromRGB(236, 220, 226),
    StatBackground = Color3.fromRGB(28, 20, 24),
    DropdownHighlight = Color3.fromRGB(240, 82, 138),
    NeutralButton = Color3.fromRGB(50, 38, 44),
    NeutralButtonHover = Color3.fromRGB(64, 50, 56),
    NeutralButtonStroke = Color3.fromRGB(170, 122, 140),
}

end)() end,
    [38] = function()local wax,script,require=ImportGlobals(38)local ImportGlobals return (function(...)export type Theme = string | {[string]: any}
export type Translator = (source: string, localeId: string) -> string?
export type Translations = {[string]: {[string]: string}}
export type WindowConfiguration = {autoSave: boolean?, autoLoad: boolean?, fileName: string?, customFolder: string?}
export type WindowProps = {name: string?, subtitle: string?, theme: Theme?, icon: (string | number)?, iconColor: Color3?, showName: string?, showIcon: (string | number)?, showIconOnly: boolean?, sidebarLayout: boolean?, profile: string?, configuration: WindowConfiguration?, fallbackFont: (Font | Enum.Font)?, locale: string?, translations: Translations?, translator: Translator?}
export type TabProps = {name: string?, icon: (string | number)?, iconColor: Color3?}
export type TagProps = {text: string?, title: string?, icon: (string | number)?, iconColor: Color3?, color: Color3?, order: number?}
export type SectionProps = {name: string?, icon: (string | number)?, iconColor: Color3?}
export type TextProps = {name: string?, text: string?, icon: (string | number)?, iconColor: Color3?}
export type DividerProps = {text: string?, spacing: number?, line: boolean?}
export type GroupProps = {direction: string?}
export type ButtonProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, callback: (() -> ())?}
export type ToggleProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, value: boolean?, forgetState: boolean?, callback: ((value: boolean) -> ())?}
export type SliderProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, range: {number}?, increment: number?, value: number?, suffix: string?, minimal: boolean?, forgetState: boolean?, callback: ((value: number, dragging: boolean) -> ())?}
export type DropdownProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, options: {string}?, value: (string | {string})?, multiSelect: boolean?, placeholder: string?, forgetState: boolean?, callback: ((value: any) -> ())?}
export type InputProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, value: string?, placeholder: string?, numeric: boolean?, clearOnFocus: boolean?, forgetState: boolean?, callback: ((value: string) -> ())?}
export type KeybindProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, value: (EnumItem | string)?, forgetState: boolean?, isMenuToggle: boolean?, hold: boolean?, holdThreshold: number?, callback: ((value: EnumItem | boolean) -> ())?, onChanged: ((key: EnumItem) -> ())?}
export type ColorPickerProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, flag: string?, color: Color3?, alpha: number?, forgetState: boolean?, callback: ((value: Color3, alpha: number) -> ())?}
export type StatProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, prefix: string?, suffix: string?, value: number?, display: string?, compact: boolean?, changeMode: string?, changeBaseline: string?, numberEasing: boolean?}
export type ProgressProps = {name: string?, description: string?, icon: (string | number)?, iconColor: Color3?, range: {number}?, value: number?, steps: number?, text: string?, format: ((value: number, min: number, max: number) -> string)?, showValue: boolean?, indeterminate: boolean?}
export type ConsoleProps = {name: string?, description: string?, text: string?, height: number?, follow: boolean?, maxLines: number?}
export type NotifyProps = {title: string?, content: string?, icon: (string | number)?, iconColor: Color3?, duration: number?}
export type ToastProps = {title: string?, subtitle: string?, subtitleAbove: boolean?, icon: (string | number)?, iconColor: Color3?, avatar: number?, minWidth: number?, duration: number?, position: ('Top' | 'Bottom')?}
export type PopupBox = {title: string?, description: string?, icon: (string | number)?, iconColor: Color3?}
export type PopupOption = {text: string?, style: string?, callback: (() -> ())?}
export type PopupProps = {title: string?, subtitle: string?, icon: (string | number)?, iconColor: Color3?, content: string?, boxes: {PopupBox}?, options: {PopupOption}?, dismissable: boolean?}
export type Moveable = {MoveTo: (self: any, index: number) -> (), MoveToTop: (self: any) -> (), MoveToBottom: (self: any) -> (), MoveUp: (self: any) -> (), MoveDown: (self: any) -> ()}
export type Lockable = {Lock: (self: any, reason: string?) -> (), Unlock: (self: any) -> (), IsLocked: (self: any) -> boolean}
export type Button = Moveable & Lockable & {}
export type Toggle = Moveable & Lockable & {value: boolean, Set: (self: Toggle, value: boolean, skipCallback: boolean?) -> ()}
export type Slider = Moveable & Lockable & {value: number, Set: (self: Slider, value: number, skipCallback: boolean?) -> ()}
export type Dropdown = Moveable & Lockable & {value: {string}, Set: (self: Dropdown, value: string | {string}, skipCallback: boolean?) -> (), Refresh: (self: Dropdown, options: {string}) -> (), Add: (self: Dropdown, option: string) -> (), Remove: (self: Dropdown, option: string) -> ()}
export type Input = Moveable & Lockable & {value: string, Set: (self: Input, value: string, skipCallback: boolean?) -> ()}
export type Keybind = Moveable & Lockable & {value: EnumItem, Set: (self: Keybind, value: EnumItem | string, skipChanged: boolean?) -> ()}
export type ColorPicker = Moveable & Lockable & {value: Color3, alpha: number, Set: (self: ColorPicker, value: Color3 | string, skipCallback: boolean?) -> (), SetAlpha: (self: ColorPicker, alpha: number, skipCallback: boolean?) -> ()}
export type Stat = Moveable & {value: number, Set: (self: Stat, value: number) -> (), ResetBaseline: (self: Stat, value: number?) -> ()}
export type Progress = Moveable & {value: number, Set: (self: Progress, value: number) -> (), Get: (self: Progress) -> number, GetPercentage: (self: Progress) -> number, SetRange: (self: Progress, min: number, max: number) -> (), SetText: (self: Progress, text: string?) -> (), SetIndeterminate: (self: Progress, state: boolean) -> (), Remove: (self: Progress) -> ()}
export type Console = Moveable & {Set: (self: Console, text: string) -> (), Append: (self: Console, line: string) -> (), Clear: (self: Console) -> (), Get: (self: Console) -> string, Copy: (self: Console) -> boolean, SetHeight: (self: Console, height: number) -> (), Remove: (self: Console) -> ()}
export type Section = Moveable & {}
export type TabSection = {Remove: (self: TabSection) -> ()}
export type Text = Moveable & {name: string, text: string, Set: (self: Text, text: string) -> (), SetTitle: (self: Text, title: string) -> ()}
export type Divider = Moveable & {text: string, Set: (self: Divider, text: string?) -> ()}
export type Tag = {Set: (self: Tag, props: TagProps) -> (), SetColor: (self: Tag, color: Color3) -> (), SetText: (self: Tag, text: string?) -> (), SetIcon: (self: Tag, icon: (string | number)?) -> (), Remove: (self: Tag) -> ()}
export type Popup = {Close: (self: Popup) -> ()}
export type Group = Moveable & {CreateButton: (self: Group, props: ButtonProps) -> Button, CreateToggle: (self: Group, props: ToggleProps) -> Toggle, CreateSwitch: (self: Group, props: ToggleProps) -> Toggle, CreateStat: (self: Group, props: StatProps) -> Stat, CreateSlider: (self: Group, props: SliderProps) -> Slider, CreateDropdown: (self: Group, props: DropdownProps) -> Dropdown?, CreateSection: (self: Group, props: SectionProps) -> Section?, CreateText: (self: Group, props: TextProps) -> Text?, CreateDivider: (self: Group, props: DividerProps?) -> Divider?, CreateGroup: (self: Group, props: GroupProps?) -> Group}
export type Tab = {Select: (self: Tab, noAnimation: boolean?) -> (), Deselect: (self: Tab, noAnimation: boolean?) -> (), Remove: (self: Tab) -> (), CreateButton: (self: Tab, props: ButtonProps) -> Button, CreateToggle: (self: Tab, props: ToggleProps) -> Toggle, CreateSwitch: (self: Tab, props: ToggleProps) -> Toggle, CreateSlider: (self: Tab, props: SliderProps) -> Slider, CreateDropdown: (self: Tab, props: DropdownProps) -> Dropdown, CreateInput: (self: Tab, props: InputProps) -> Input, CreateKeybind: (self: Tab, props: KeybindProps) -> Keybind, CreateColorPicker: (self: Tab, props: ColorPickerProps) -> ColorPicker, CreateStat: (self: Tab, props: StatProps) -> Stat, CreateProgress: (self: Tab, props: ProgressProps) -> Progress, CreateConsole: (self: Tab, props: ConsoleProps) -> Console, CreateSection: (self: Tab, props: SectionProps) -> Section, CreateText: (self: Tab, props: TextProps) -> Text, CreateDivider: (self: Tab, props: DividerProps?) -> Divider, CreateGroup: (self: Tab, props: GroupProps?) -> Group}
export type Window = {unloaded: boolean, Flags: {[string]: any}, CreateTab: (self: Window, props: TabProps) -> Tab, CreateSection: (self: Window, props: SectionProps) -> TabSection, CreateTag: (self: Window, props: TagProps) -> Tag, Notify: (self: Window, props: NotifyProps) -> (), Toast: (self: Window, props: ToastProps) -> (), Popup: (self: Window, props: PopupProps) -> Popup?, Show: (self: Window) -> (), Hide: (self: Window) -> (), ToggleHide: (self: Window) -> (), ToggleMinimise: (self: Window) -> (), Navigate: (self: Window, tab: string | Tab) -> (), ChangeTheme: (self: Window, theme: Theme) -> (), SetLocale: (self: Window, localeId: string) -> (), SetTranslator: (self: Window, translator: Translator?) -> (), RegisterTranslations: (self: Window, translations: Translations) -> (), Save: (self: Window, name: string?) -> boolean, Load: (self: Window, name: string?) -> boolean, ListConfigs: (self: Window) -> {string}, DeleteConfig: (self: Window, name: string) -> boolean, GetPath: (self: Window) -> (string, string), Get: (self: Window, flag: string) -> any, Set: (self: Window, flag: string, value: any) -> boolean, Unload: (self: Window) -> ()}
export type Slate = {CreateWindow: (self: Slate, props: WindowProps) -> Window}

return {}

end)() end,
    [40] = function()local wax,script,require=ImportGlobals(40)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local hapticEngine = {}

hapticEngine.enabled = false

type HapticTypes = {click: Enum.HapticEffectType?, notify: Enum.HapticEffectType?}

local types: HapticTypes = {}
local supported, resolvedTypes = pcall(function()
    Instance.new('HapticEffect'):Destroy()

    return {
        click = Enum.HapticEffectType.UIHover,
        notify = Enum.HapticEffectType.UIClick,
    }
end)

if supported then
    types = resolvedTypes
end

local effects: {[Enum.HapticEffectType]: Instance} = {}
local container: Instance? = nil

function hapticEngine.setContainer(target: Instance?)
    container = target
end
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

    if effect and effect.Parent then
        return effect
    end

    local ok, made = pcall(Instance.new, 'HapticEffect')

    if not ok then
        return nil
    end

    local hapticEffect = made::any

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
        local hapticEffect = effect::any

        pcall(hapticEffect.Play, effect)
    end
end

function hapticEngine.click()
    play(types.click)
end
function hapticEngine.notify()
    play(types.notify)
end
function hapticEngine.setEnabled(state: boolean?)
    hapticEngine.enabled = state and true or false

    if not hapticEngine.enabled then
        hapticEngine.teardown()
    end
end
function hapticEngine.teardown()
    for hapticType, effect in effects do
        pcall(effect.Destroy, effect)

        effects[hapticType] = nil
    end
end

return hapticEngine

end)() end,
    [41] = function()local wax,script,require=ImportGlobals(41)local ImportGlobals return (function(...)local network = require(script.Parent.network)
local log = require(script.Parent.log)

export type AssetId = number | string
export type AssetDownloadUrl = string
export type CacheKey = AssetId
export type ResolvedAsset = AssetId
export type AssetRequestPayload = {Url: string, Method: string}

local assetResolver = {
    Enum = {
        AssetDownloadUrl = {
            RobloxDownloadUrl = 'https://assetdelivery.roblox.com/v1/asset/?id=%d'::AssetDownloadUrl,
            RoProxyDownloadUrl = 'https://assetdelivery.roproxy.com/v1/asset?id=%d'::AssetDownloadUrl,
        },
    },
}

assetResolver.__index = assetResolver
assetResolver.__type = 'assetResolver'

type AssetResolverState = {contentCache: {[CacheKey]: string}?, contentCacheOrder: {CacheKey}?, contentDownloadUrl: AssetDownloadUrl, pendingRequests: {[CacheKey]: {thread}}}
export type AssetResolver = AssetResolverState&{resolve: (self:AssetResolver, value:unknown) -> ResolvedAsset?, getAssetContentFromUrl: (self:AssetResolver, url:string, cacheKey:CacheKey?, forced:boolean?) -> string?, getAssetContentFromId: (self:AssetResolver, id:AssetId, forced:boolean?) -> string?}

local contentCacheLimit = 8

function assetResolver.new(
    useCache: boolean?,
    assetContentDownloadUrl: AssetDownloadUrl?
): AssetResolver
    local contentCache: {[CacheKey]: string}? = if useCache then{}else nil
    local self = setmetatable({
        contentCache = contentCache,
        contentCacheOrder = if useCache then{}::{CacheKey}else nil,
        contentDownloadUrl = assetContentDownloadUrl or assetResolver.Enum.AssetDownloadUrl.RobloxDownloadUrl,
        pendingRequests = {},
    }::AssetResolverState, assetResolver)::any

    return self
end
function assetResolver.resolve(_self: AssetResolver, value: unknown): ResolvedAsset?
    if type(value) == 'number' then
        return value
    end
    if type(value) ~= 'string' then
        return nil
    end
    if string.sub(value, 1, 11) == 'rbxasset://' or string.sub(value, 1, 11) == 'rbxthumb://' then
        return value
    end

    local id = tonumber(string.match(value, '^rbxassetid://(%d+)$'))

    if id then
        return id
    end

    return nil
end

local function isGoodResponse(response: unknown): boolean
    if type(response) ~= 'table' then
        return false
    end

    local shaped = response::{Body: unknown, StatusCode: unknown, Success: unknown}
    local body = shaped.Body

    if type(body) ~= 'string' or #body == 0 then
        return false
    end
    if type(shaped.StatusCode) == 'number' then
        local statusCode = shaped.StatusCode::number

        return statusCode >= 200 and statusCode < 300
    end
    if type(shaped.Success) == 'boolean' then
        return shaped.Success::boolean
    end

    return false
end

function assetResolver.getAssetContentFromUrl(
    self: AssetResolver,
    url: string,
    cacheKey: CacheKey?,
    forced: boolean?
): string?
    local contentCache = self.contentCache

    if cacheKey ~= nil and contentCache and not forced then
        local cachedContent = contentCache[cacheKey]

        if cachedContent then
            return cachedContent
        end
    end

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
        log.warn('No request function available to download asset content.')
    else
        local success, response = pcall(requestFn, {
            Url = url,
            Method = 'GET',
        }::AssetRequestPayload)

        if success and isGoodResponse(response) then
            local body = (response::{Body: string}).Body

            content = body

            if cacheKey ~= nil and contentCache then
                local order = self.contentCacheOrder

                if order and contentCache[cacheKey] == nil then
                    table.insert(order, cacheKey)

                    local oldest = if#order > contentCacheLimit then table.remove(order, 1)else nil

                    if oldest ~= nil then
                        contentCache[oldest] = nil
                    end
                end

                contentCache[cacheKey] = body
            end
        elseif not forced then
            log.warn('Failed to download asset content for url: ' .. tostring(url))
        end
    end
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
function assetResolver.getAssetContentFromId(
    self: AssetResolver,
    id: AssetId,
    forced: boolean?
): string?
    local resolvedId = self:resolve(id)

    if not resolvedId or type(resolvedId) ~= 'number' then
        log.warn('Invalid asset id: ' .. tostring(resolvedId))

        return nil
    end

    local downloadUrl = string.format(self.contentDownloadUrl, resolvedId)

    return self:getAssetContentFromUrl(downloadUrl, resolvedId, forced)
end

return assetResolver

end)() end,
    [42] = function()local wax,script,require=ImportGlobals(42)local ImportGlobals return (function(...)local colors = {}

function colors.contrastColor(color: Color3): Color3
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B

    return if luminance > 0.5 then Color3.fromRGB(0, 0, 0)else Color3.fromRGB(255, 255, 255)
end
function colors.toColorSequence(color: Color3 | ColorSequence): ColorSequence
    return if typeof(color) == 'ColorSequence'then color else ColorSequence.new(color)
end
function colors.contrastText(color: Color3): Color3
    local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B

    return if luminance > 0.6 then Color3.fromRGB(20, 20, 20)else Color3.fromRGB(255, 255, 255)
end

return colors

end)() end,
    [43] = function()local wax,script,require=ImportGlobals(43)local ImportGlobals return (function(...)local constants = {}

constants.fontAsset = 'rbxassetid://12187365364'
constants.pillResizeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
constants.icons = {
    close = 83277910885129,
    minimise = 108115485663409,
    maximise = 88738500661569,
    settings = 129180860773723,
    search = 100604009889706,
    chevron = 88479147175134,
    check = 125626312718314,
    dot = 91452555903853,
    colorpicker = 91452555903853,
    banner = 136661212895058,
    config = 125823673784681,
    rayfield = 136661212895058,
    slate = 136661212895058,
}
constants.accent = {
    on = Color3.fromRGB(255, 255, 255),
    onStroke = Color3.fromRGB(255, 255, 255),
}
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
constants.zIndex = {
    elementLock = 60,
    elementLockContent = 65,
    bottomFade = 100,
    notification = 1500,
    drag = 1000,
    toast = 2000,
    toastContent = 2001,
    restoreContent = 100001,
    restoreInteract = 100002,
}
constants.displayOrder = {
    window = 99999,
    banner = 100000,
    popup = 100001,
}

return constants

end)() end,
    [44] = function()local wax,script,require=ImportGlobals(44)local ImportGlobals return (function(...)local enums = {}

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
    [45] = function()local wax,script,require=ImportGlobals(45)local ImportGlobals return (function(...)local services = require(script.Parent.services)
local filesystem = {}
local isStudio = services.getService('RunService'):IsStudio()
local hasNativeFS = not isStudio and typeof(writefile) == 'function' and typeof(readfile) == 'function' and typeof(isfile) == 'function' and typeof(isfolder) == 'function' and typeof(makefolder) == 'function' and typeof(listfiles) == 'function' and typeof(delfile) == 'function' and typeof(delfolder) == 'function'

if hasNativeFS then
    function filesystem.writefile(path: string, content: string)
        writefile(path, content)
    end
    function filesystem.readfile(path: string): string
        return readfile(path)
    end

    if typeof(appendfile) == 'function' then
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
    function filesystem.listfiles(folder: string): {string}
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
    local root = Instance.new('Folder')

    root.Name = 'Filesystem'
    root.Parent = services.getService('ReplicatedStorage')

    local function splitPath(path: string): {string}
        local parts = {}

        for part in string.gmatch(path, '[^/]+')do
            table.insert(parts, part)
        end

        return parts
    end
    local function resolveParent(parts: {string}, createMissing: boolean): Instance?
        local current: Instance = root

        for i = 1, #parts - 1 do
            local child = current:FindFirstChild(parts[i])

            if not child then
                if not createMissing then
                    return nil
                end

                local folder = Instance.new('Folder')

                folder.Name = parts[i]
                folder.Parent = current
                child = folder
            end

            current = child::Instance
        end

        return current
    end
    local function fileFromInstance(instance: Instance?): StringValue?
        if instance and instance:IsA('StringValue') then
            return instance
        end

        return nil
    end

    function filesystem.writefile(path: string, content: string)
        local parts = splitPath(path)

        assert(#parts > 0, 'Invalid path')

        local parent = resolveParent(parts, true)

        assert(parent, 'Invalid path')

        local fileName = parts[#parts]
        local existing = parent:FindFirstChild(fileName)
        local existingFile = fileFromInstance(existing)

        if existingFile then
            existingFile.Value = content
        else
            if existing then
                existing:Destroy()
            end

            local file = Instance.new('StringValue')

            file.Name = fileName
            file.Value = content
            file.Parent = parent
        end
    end
    function filesystem.readfile(path: string): string
        local parts = splitPath(path)

        assert(#parts > 0, 'Invalid path')

        local parent = resolveParent(parts, false)

        assert(parent, 'File not found: ' .. path)

        local file = parent:FindFirstChild(parts[#parts])
        local stringFile = fileFromInstance(file)

        assert(stringFile, 'File not found: ' .. path)

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
    function filesystem.listfiles(folder: string): {string}
        local parts = splitPath(folder)
        local current: Instance = root

        for _, part in parts do
            local child = current:FindFirstChild(part)

            if not child or not child:IsA('Folder') then
                error('Folder not found: ' .. folder)
            end

            current = child
        end

        local results: {string} = {}

        for _, child in current:GetChildren()do
            table.insert(results, folder .. '/' .. child.Name)
        end

        return results
    end
    function filesystem.delfile(path: string)
        local parts = splitPath(path)

        assert(#parts > 0, 'Invalid path')

        local parent = resolveParent(parts, false)

        assert(parent, 'File not found: ' .. path)

        local file = parent:FindFirstChild(parts[#parts])
        local stringFile = fileFromInstance(file)

        assert(stringFile, 'File not found: ' .. path)
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
                local folder = Instance.new('Folder')

                folder.Name = part
                folder.Parent = current
                child = folder
            end

            current = child::Instance
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

            if not child or not child:IsA('Folder') then
                return false
            end

            current = child
        end

        return true
    end
    function filesystem.delfolder(path: string)
        local parts = splitPath(path)

        assert(#parts > 0, 'Invalid path')

        local parent = resolveParent(parts, false)

        assert(parent, 'Folder not found: ' .. path)

        local folder = parent:FindFirstChild(parts[#parts])

        assert(folder and folder:IsA('Folder'), 'Folder not found: ' .. path)
        folder:Destroy()
    end
end
if filesystem.writefile and not filesystem.appendfile then
    function filesystem.appendfile(path: string, content: string)
        local existing = if filesystem.isfile(path)then filesystem.readfile(path)else nil

        filesystem.writefile(path, if existing then existing .. content else content)
    end
end

function filesystem.ensureFolder(path: string)
    if not filesystem.isfolder(path) then
        filesystem.makefolder(path)
    end
end
function filesystem.ensureDir(dir: string)
    local built = ''

    for part in string.gmatch(dir, '[^/]+')do
        built = if built == ''then part else built .. '/' .. part

        if not filesystem.isfolder(built) then
            filesystem.makefolder(built)
        end
    end
end

return filesystem

end)() end,
    [46] = function()local wax,script,require=ImportGlobals(46)local ImportGlobals return (function(...)local filesystem = require(script.Parent.filesystem)
local path = require(script.Parent.path)
local DEFAULT_ROOT_PATH = 'Slate'
local fileSystemManager = {}

fileSystemManager.__index = fileSystemManager

export type FileSystemManager = {root: string, assets: string, getPath: (self:FileSystemManager, subpath:string?) -> string, getAssetsFolder: (self:FileSystemManager, subfolder:string?) -> string, getRootFolder: (self:FileSystemManager) -> string}

function fileSystemManager.new(name: string?): FileSystemManager
    local root = name or DEFAULT_ROOT_PATH
    local self = setmetatable({
        root = root,
        assets = root .. '/Assets',
    }, fileSystemManager)::any

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
    [47] = function()local wax,script,require=ImportGlobals(47)local ImportGlobals return (function(...)local flagNames = {}
local offsetBasis = 2166136261
local prime = 16777619

local function hashName(name: string): number
    local hash = offsetBasis

    for index = 1, #name do
        hash = bit32.bxor(hash, string.byte(name, index))

        local low = hash % 65536
        local high = (hash - low) / 65536

        hash = (((high * prime) % 65536) * 65536 + low * prime) % 4294967296
    end

    return hash
end

function flagNames.deriveFlagFromName(name: string): string
    local flag = name:gsub('(%S+)', function(w: string): string
        return w:sub(1, 1):upper() .. w:sub(2, -1)
    end):gsub('[^%w]', '')

    if flag == '' and name ~= '' then
        return string.format('Flag%08x', hashName(name))
    end

    return flag
end

return flagNames

end)() end,
    [48] = function()local wax,script,require=ImportGlobals(48)local ImportGlobals return (function(...)local fluentIcons = {}

local files: {[string]: string} = {
    ["accesstime"] = "ic_fluent_access_time_24_filled.png",
    ["access-time"] = "ic_fluent_access_time_24_filled.png",
    ["access_time"] = "ic_fluent_access_time_24_filled.png",
    ["accessibility"] = "ic_fluent_accessibility_24_filled.png",
    ["accessibilitycheckmark"] = "ic_fluent_accessibility_checkmark_24_filled.png",
    ["accessibility-checkmark"] = "ic_fluent_accessibility_checkmark_24_filled.png",
    ["accessibility_checkmark"] = "ic_fluent_accessibility_checkmark_24_filled.png",
    ["add"] = "ic_fluent_add_24_filled.png",
    ["addcircle"] = "ic_fluent_add_circle_24_filled.png",
    ["add-circle"] = "ic_fluent_add_circle_24_filled.png",
    ["add_circle"] = "ic_fluent_add_circle_24_filled.png",
    ["addsquare"] = "ic_fluent_add_square_24_filled.png",
    ["add-square"] = "ic_fluent_add_square_24_filled.png",
    ["add_square"] = "ic_fluent_add_square_24_filled.png",
    ["addsubtractcircle"] = "ic_fluent_add_subtract_circle_24_filled.png",
    ["add-subtract-circle"] = "ic_fluent_add_subtract_circle_24_filled.png",
    ["add_subtract_circle"] = "ic_fluent_add_subtract_circle_24_filled.png",
    ["airplane"] = "ic_fluent_airplane_24_filled.png",
    ["airplanetakeoff"] = "ic_fluent_airplane_take_off_24_filled.png",
    ["airplane-take-off"] = "ic_fluent_airplane_take_off_24_filled.png",
    ["airplane_take_off"] = "ic_fluent_airplane_take_off_24_filled.png",
    ["album"] = "ic_fluent_album_24_filled.png",
    ["albumadd"] = "ic_fluent_album_add_24_filled.png",
    ["album-add"] = "ic_fluent_album_add_24_filled.png",
    ["album_add"] = "ic_fluent_album_add_24_filled.png",
    ["alert"] = "ic_fluent_alert_24_filled.png",
    ["alertoff"] = "ic_fluent_alert_off_24_filled.png",
    ["alert-off"] = "ic_fluent_alert_off_24_filled.png",
    ["alert_off"] = "ic_fluent_alert_off_24_filled.png",
    ["alerton"] = "ic_fluent_alert_on_24_filled.png",
    ["alert-on"] = "ic_fluent_alert_on_24_filled.png",
    ["alert_on"] = "ic_fluent_alert_on_24_filled.png",
    ["alertsnooze"] = "ic_fluent_alert_snooze_24_filled.png",
    ["alert-snooze"] = "ic_fluent_alert_snooze_24_filled.png",
    ["alert_snooze"] = "ic_fluent_alert_snooze_24_filled.png",
    ["alerturgent"] = "ic_fluent_alert_urgent_24_filled.png",
    ["alert-urgent"] = "ic_fluent_alert_urgent_24_filled.png",
    ["alert_urgent"] = "ic_fluent_alert_urgent_24_filled.png",
    ["alignbottom"] = "ic_fluent_align_bottom_24_filled.png",
    ["align-bottom"] = "ic_fluent_align_bottom_24_filled.png",
    ["align_bottom"] = "ic_fluent_align_bottom_24_filled.png",
    ["aligncenterhorizontal"] = "ic_fluent_align_center_horizontal_24_filled.png",
    ["align-center-horizontal"] = "ic_fluent_align_center_horizontal_24_filled.png",
    ["align_center_horizontal"] = "ic_fluent_align_center_horizontal_24_filled.png",
    ["aligncentervertical"] = "ic_fluent_align_center_vertical_24_filled.png",
    ["align-center-vertical"] = "ic_fluent_align_center_vertical_24_filled.png",
    ["align_center_vertical"] = "ic_fluent_align_center_vertical_24_filled.png",
    ["alignleft"] = "ic_fluent_align_left_24_filled.png",
    ["align-left"] = "ic_fluent_align_left_24_filled.png",
    ["align_left"] = "ic_fluent_align_left_24_filled.png",
    ["alignright"] = "ic_fluent_align_right_24_filled.png",
    ["align-right"] = "ic_fluent_align_right_24_filled.png",
    ["align_right"] = "ic_fluent_align_right_24_filled.png",
    ["aligntop"] = "ic_fluent_align_top_24_filled.png",
    ["align-top"] = "ic_fluent_align_top_24_filled.png",
    ["align_top"] = "ic_fluent_align_top_24_filled.png",
    ["animalcat"] = "ic_fluent_animal_cat_24_filled.png",
    ["animal-cat"] = "ic_fluent_animal_cat_24_filled.png",
    ["animal_cat"] = "ic_fluent_animal_cat_24_filled.png",
    ["animaldog"] = "ic_fluent_animal_dog_24_filled.png",
    ["animal-dog"] = "ic_fluent_animal_dog_24_filled.png",
    ["animal_dog"] = "ic_fluent_animal_dog_24_filled.png",
    ["animalrabbit"] = "ic_fluent_animal_rabbit_24_filled.png",
    ["animal-rabbit"] = "ic_fluent_animal_rabbit_24_filled.png",
    ["animal_rabbit"] = "ic_fluent_animal_rabbit_24_filled.png",
    ["animalturtle"] = "ic_fluent_animal_turtle_24_filled.png",
    ["animal-turtle"] = "ic_fluent_animal_turtle_24_filled.png",
    ["animal_turtle"] = "ic_fluent_animal_turtle_24_filled.png",
    ["appfolder"] = "ic_fluent_app_folder_24_filled.png",
    ["app-folder"] = "ic_fluent_app_folder_24_filled.png",
    ["app_folder"] = "ic_fluent_app_folder_24_filled.png",
    ["appgeneric"] = "ic_fluent_app_generic_24_filled.png",
    ["app-generic"] = "ic_fluent_app_generic_24_filled.png",
    ["app_generic"] = "ic_fluent_app_generic_24_filled.png",
    ["apprecent"] = "ic_fluent_app_recent_24_filled.png",
    ["app-recent"] = "ic_fluent_app_recent_24_filled.png",
    ["app_recent"] = "ic_fluent_app_recent_24_filled.png",
    ["appstore"] = "ic_fluent_app_store_24_filled.png",
    ["app-store"] = "ic_fluent_app_store_24_filled.png",
    ["app_store"] = "ic_fluent_app_store_24_filled.png",
    ["apptitle"] = "ic_fluent_app_title_24_filled.png",
    ["app-title"] = "ic_fluent_app_title_24_filled.png",
    ["app_title"] = "ic_fluent_app_title_24_filled.png",
    ["approvalsapp"] = "ic_fluent_approvals_app_24_filled.png",
    ["approvals-app"] = "ic_fluent_approvals_app_24_filled.png",
    ["approvals_app"] = "ic_fluent_approvals_app_24_filled.png",
    ["apps"] = "ic_fluent_apps_24_filled.png",
    ["appsaddin"] = "ic_fluent_apps_add_in_24_filled.png",
    ["apps-add-in"] = "ic_fluent_apps_add_in_24_filled.png",
    ["apps_add_in"] = "ic_fluent_apps_add_in_24_filled.png",
    ["appslist"] = "ic_fluent_apps_list_24_filled.png",
    ["apps-list"] = "ic_fluent_apps_list_24_filled.png",
    ["apps_list"] = "ic_fluent_apps_list_24_filled.png",
    ["appslistdetail"] = "ic_fluent_apps_list_detail_24_filled.png",
    ["apps-list-detail"] = "ic_fluent_apps_list_detail_24_filled.png",
    ["apps_list_detail"] = "ic_fluent_apps_list_detail_24_filled.png",
    ["archive"] = "ic_fluent_archive_24_filled.png",
    ["arrowautofitcontent"] = "ic_fluent_arrow_autofit_content_24_filled.png",
    ["arrow-autofit-content"] = "ic_fluent_arrow_autofit_content_24_filled.png",
    ["arrow_autofit_content"] = "ic_fluent_arrow_autofit_content_24_filled.png",
    ["arrowautofitdown"] = "ic_fluent_arrow_autofit_down_24_filled.png",
    ["arrow-autofit-down"] = "ic_fluent_arrow_autofit_down_24_filled.png",
    ["arrow_autofit_down"] = "ic_fluent_arrow_autofit_down_24_filled.png",
    ["arrowautofitheight"] = "ic_fluent_arrow_autofit_height_24_filled.png",
    ["arrow-autofit-height"] = "ic_fluent_arrow_autofit_height_24_filled.png",
    ["arrow_autofit_height"] = "ic_fluent_arrow_autofit_height_24_filled.png",
    ["arrowautofitheightdotted"] = "ic_fluent_arrow_autofit_height_dotted_24_filled.png",
    ["arrow-autofit-height-dotted"] = "ic_fluent_arrow_autofit_height_dotted_24_filled.png",
    ["arrow_autofit_height_dotted"] = "ic_fluent_arrow_autofit_height_dotted_24_filled.png",
    ["arrowautofitup"] = "ic_fluent_arrow_autofit_up_24_filled.png",
    ["arrow-autofit-up"] = "ic_fluent_arrow_autofit_up_24_filled.png",
    ["arrow_autofit_up"] = "ic_fluent_arrow_autofit_up_24_filled.png",
    ["arrowautofitwidth"] = "ic_fluent_arrow_autofit_width_24_filled.png",
    ["arrow-autofit-width"] = "ic_fluent_arrow_autofit_width_24_filled.png",
    ["arrow_autofit_width"] = "ic_fluent_arrow_autofit_width_24_filled.png",
    ["arrowautofitwidthdotted"] = "ic_fluent_arrow_autofit_width_dotted_24_filled.png",
    ["arrow-autofit-width-dotted"] = "ic_fluent_arrow_autofit_width_dotted_24_filled.png",
    ["arrow_autofit_width_dotted"] = "ic_fluent_arrow_autofit_width_dotted_24_filled.png",
    ["arrowbidirectionalupdown"] = "ic_fluent_arrow_bidirectional_up_down_24_filled.png",
    ["arrow-bidirectional-up-down"] = "ic_fluent_arrow_bidirectional_up_down_24_filled.png",
    ["arrow_bidirectional_up_down"] = "ic_fluent_arrow_bidirectional_up_down_24_filled.png",
    ["arrowbounce"] = "ic_fluent_arrow_bounce_24_filled.png",
    ["arrow-bounce"] = "ic_fluent_arrow_bounce_24_filled.png",
    ["arrow_bounce"] = "ic_fluent_arrow_bounce_24_filled.png",
    ["arrowcircledown"] = "ic_fluent_arrow_circle_down_24_filled.png",
    ["arrow-circle-down"] = "ic_fluent_arrow_circle_down_24_filled.png",
    ["arrow_circle_down"] = "ic_fluent_arrow_circle_down_24_filled.png",
    ["arrowcircledowndouble"] = "ic_fluent_arrow_circle_down_double_24_filled.png",
    ["arrow-circle-down-double"] = "ic_fluent_arrow_circle_down_double_24_filled.png",
    ["arrow_circle_down_double"] = "ic_fluent_arrow_circle_down_double_24_filled.png",
    ["arrowcircledownright"] = "ic_fluent_arrow_circle_down_right_24_filled.png",
    ["arrow-circle-down-right"] = "ic_fluent_arrow_circle_down_right_24_filled.png",
    ["arrow_circle_down_right"] = "ic_fluent_arrow_circle_down_right_24_filled.png",
    ["arrowcircledownsplit"] = "ic_fluent_arrow_circle_down_split_24_filled.png",
    ["arrow-circle-down-split"] = "ic_fluent_arrow_circle_down_split_24_filled.png",
    ["arrow_circle_down_split"] = "ic_fluent_arrow_circle_down_split_24_filled.png",
    ["arrowcircleleft"] = "ic_fluent_arrow_circle_left_24_filled.png",
    ["arrow-circle-left"] = "ic_fluent_arrow_circle_left_24_filled.png",
    ["arrow_circle_left"] = "ic_fluent_arrow_circle_left_24_filled.png",
    ["arrowcircleright"] = "ic_fluent_arrow_circle_right_24_filled.png",
    ["arrow-circle-right"] = "ic_fluent_arrow_circle_right_24_filled.png",
    ["arrow_circle_right"] = "ic_fluent_arrow_circle_right_24_filled.png",
    ["arrowcircleup"] = "ic_fluent_arrow_circle_up_24_filled.png",
    ["arrow-circle-up"] = "ic_fluent_arrow_circle_up_24_filled.png",
    ["arrow_circle_up"] = "ic_fluent_arrow_circle_up_24_filled.png",
    ["arrowcircleupleft"] = "ic_fluent_arrow_circle_up_left_24_filled.png",
    ["arrow-circle-up-left"] = "ic_fluent_arrow_circle_up_left_24_filled.png",
    ["arrow_circle_up_left"] = "ic_fluent_arrow_circle_up_left_24_filled.png",
    ["arrowclockwise"] = "ic_fluent_arrow_clockwise_24_filled.png",
    ["arrow-clockwise"] = "ic_fluent_arrow_clockwise_24_filled.png",
    ["arrow_clockwise"] = "ic_fluent_arrow_clockwise_24_filled.png",
    ["arrowclockwisedashes"] = "ic_fluent_arrow_clockwise_dashes_24_filled.png",
    ["arrow-clockwise-dashes"] = "ic_fluent_arrow_clockwise_dashes_24_filled.png",
    ["arrow_clockwise_dashes"] = "ic_fluent_arrow_clockwise_dashes_24_filled.png",
    ["arrowcollapseall"] = "ic_fluent_arrow_collapse_all_24_filled.png",
    ["arrow-collapse-all"] = "ic_fluent_arrow_collapse_all_24_filled.png",
    ["arrow_collapse_all"] = "ic_fluent_arrow_collapse_all_24_filled.png",
    ["arrowcounterclockwise"] = "ic_fluent_arrow_counterclockwise_24_filled.png",
    ["arrow-counterclockwise"] = "ic_fluent_arrow_counterclockwise_24_filled.png",
    ["arrow_counterclockwise"] = "ic_fluent_arrow_counterclockwise_24_filled.png",
    ["arrowcounterclockwisedashes"] = "ic_fluent_arrow_counterclockwise_dashes_24_filled.png",
    ["arrow-counterclockwise-dashes"] = "ic_fluent_arrow_counterclockwise_dashes_24_filled.png",
    ["arrow_counterclockwise_dashes"] = "ic_fluent_arrow_counterclockwise_dashes_24_filled.png",
    ["arrowcurvedownleft"] = "ic_fluent_arrow_curve_down_left_24_filled.png",
    ["arrow-curve-down-left"] = "ic_fluent_arrow_curve_down_left_24_filled.png",
    ["arrow_curve_down_left"] = "ic_fluent_arrow_curve_down_left_24_filled.png",
    ["arrowdown"] = "ic_fluent_arrow_down_24_filled.png",
    ["arrow-down"] = "ic_fluent_arrow_down_24_filled.png",
    ["arrow_down"] = "ic_fluent_arrow_down_24_filled.png",
    ["arrowdownleft"] = "ic_fluent_arrow_down_left_24_filled.png",
    ["arrow-down-left"] = "ic_fluent_arrow_down_left_24_filled.png",
    ["arrow_down_left"] = "ic_fluent_arrow_down_left_24_filled.png",
    ["arrowdownload"] = "ic_fluent_arrow_download_24_filled.png",
    ["arrow-download"] = "ic_fluent_arrow_download_24_filled.png",
    ["arrow_download"] = "ic_fluent_arrow_download_24_filled.png",
    ["arrowenterleft"] = "ic_fluent_arrow_enter_left_24_filled.png",
    ["arrow-enter-left"] = "ic_fluent_arrow_enter_left_24_filled.png",
    ["arrow_enter_left"] = "ic_fluent_arrow_enter_left_24_filled.png",
    ["arrowenterup"] = "ic_fluent_arrow_enter_up_24_filled.png",
    ["arrow-enter-up"] = "ic_fluent_arrow_enter_up_24_filled.png",
    ["arrow_enter_up"] = "ic_fluent_arrow_enter_up_24_filled.png",
    ["arrowexpand"] = "ic_fluent_arrow_expand_24_filled.png",
    ["arrow-expand"] = "ic_fluent_arrow_expand_24_filled.png",
    ["arrow_expand"] = "ic_fluent_arrow_expand_24_filled.png",
    ["arrowexportltr"] = "ic_fluent_arrow_export_ltr_24_filled.png",
    ["arrow-export-ltr"] = "ic_fluent_arrow_export_ltr_24_filled.png",
    ["arrow_export_ltr"] = "ic_fluent_arrow_export_ltr_24_filled.png",
    ["arrowexportup"] = "ic_fluent_arrow_export_up_24_filled.png",
    ["arrow-export-up"] = "ic_fluent_arrow_export_up_24_filled.png",
    ["arrow_export_up"] = "ic_fluent_arrow_export_up_24_filled.png",
    ["arrowforward"] = "ic_fluent_arrow_forward_24_filled.png",
    ["arrow-forward"] = "ic_fluent_arrow_forward_24_filled.png",
    ["arrow_forward"] = "ic_fluent_arrow_forward_24_filled.png",
    ["arrowgrowth"] = "ic_fluent_arrow_growth_24_filled.png",
    ["arrow-growth"] = "ic_fluent_arrow_growth_24_filled.png",
    ["arrow_growth"] = "ic_fluent_arrow_growth_24_filled.png",
    ["arrowhookdownleft"] = "ic_fluent_arrow_hook_down_left_24_filled.png",
    ["arrow-hook-down-left"] = "ic_fluent_arrow_hook_down_left_24_filled.png",
    ["arrow_hook_down_left"] = "ic_fluent_arrow_hook_down_left_24_filled.png",
    ["arrowhookdownright"] = "ic_fluent_arrow_hook_down_right_24_filled.png",
    ["arrow-hook-down-right"] = "ic_fluent_arrow_hook_down_right_24_filled.png",
    ["arrow_hook_down_right"] = "ic_fluent_arrow_hook_down_right_24_filled.png",
    ["arrowhookupleft"] = "ic_fluent_arrow_hook_up_left_24_filled.png",
    ["arrow-hook-up-left"] = "ic_fluent_arrow_hook_up_left_24_filled.png",
    ["arrow_hook_up_left"] = "ic_fluent_arrow_hook_up_left_24_filled.png",
    ["arrowhookupright"] = "ic_fluent_arrow_hook_up_right_24_filled.png",
    ["arrow-hook-up-right"] = "ic_fluent_arrow_hook_up_right_24_filled.png",
    ["arrow_hook_up_right"] = "ic_fluent_arrow_hook_up_right_24_filled.png",
    ["arrowimport"] = "ic_fluent_arrow_import_24_filled.png",
    ["arrow-import"] = "ic_fluent_arrow_import_24_filled.png",
    ["arrow_import"] = "ic_fluent_arrow_import_24_filled.png",
    ["arrowleft"] = "ic_fluent_arrow_left_24_filled.png",
    ["arrow-left"] = "ic_fluent_arrow_left_24_filled.png",
    ["arrow_left"] = "ic_fluent_arrow_left_24_filled.png",
    ["arrowmaximize"] = "ic_fluent_arrow_maximize_24_filled.png",
    ["arrow-maximize"] = "ic_fluent_arrow_maximize_24_filled.png",
    ["arrow_maximize"] = "ic_fluent_arrow_maximize_24_filled.png",
    ["arrowmaximizevertical"] = "ic_fluent_arrow_maximize_vertical_24_filled.png",
    ["arrow-maximize-vertical"] = "ic_fluent_arrow_maximize_vertical_24_filled.png",
    ["arrow_maximize_vertical"] = "ic_fluent_arrow_maximize_vertical_24_filled.png",
    ["arrowminimize"] = "ic_fluent_arrow_minimize_24_filled.png",
    ["arrow-minimize"] = "ic_fluent_arrow_minimize_24_filled.png",
    ["arrow_minimize"] = "ic_fluent_arrow_minimize_24_filled.png",
    ["arrowminimizevertical"] = "ic_fluent_arrow_minimize_vertical_24_filled.png",
    ["arrow-minimize-vertical"] = "ic_fluent_arrow_minimize_vertical_24_filled.png",
    ["arrow_minimize_vertical"] = "ic_fluent_arrow_minimize_vertical_24_filled.png",
    ["arrowmove"] = "ic_fluent_arrow_move_24_filled.png",
    ["arrow-move"] = "ic_fluent_arrow_move_24_filled.png",
    ["arrow_move"] = "ic_fluent_arrow_move_24_filled.png",
    ["arrownext"] = "ic_fluent_arrow_next_24_filled.png",
    ["arrow-next"] = "ic_fluent_arrow_next_24_filled.png",
    ["arrow_next"] = "ic_fluent_arrow_next_24_filled.png",
    ["arrowprevious"] = "ic_fluent_arrow_previous_24_filled.png",
    ["arrow-previous"] = "ic_fluent_arrow_previous_24_filled.png",
    ["arrow_previous"] = "ic_fluent_arrow_previous_24_filled.png",
    ["arrowredo"] = "ic_fluent_arrow_redo_24_filled.png",
    ["arrow-redo"] = "ic_fluent_arrow_redo_24_filled.png",
    ["arrow_redo"] = "ic_fluent_arrow_redo_24_filled.png",
    ["arrowrepeatall"] = "ic_fluent_arrow_repeat_all_24_filled.png",
    ["arrow-repeat-all"] = "ic_fluent_arrow_repeat_all_24_filled.png",
    ["arrow_repeat_all"] = "ic_fluent_arrow_repeat_all_24_filled.png",
    ["arrowrepeatalloff"] = "ic_fluent_arrow_repeat_all_off_24_filled.png",
    ["arrow-repeat-all-off"] = "ic_fluent_arrow_repeat_all_off_24_filled.png",
    ["arrow_repeat_all_off"] = "ic_fluent_arrow_repeat_all_off_24_filled.png",
    ["arrowreply"] = "ic_fluent_arrow_reply_24_filled.png",
    ["arrow-reply"] = "ic_fluent_arrow_reply_24_filled.png",
    ["arrow_reply"] = "ic_fluent_arrow_reply_24_filled.png",
    ["arrowreplyall"] = "ic_fluent_arrow_reply_all_24_filled.png",
    ["arrow-reply-all"] = "ic_fluent_arrow_reply_all_24_filled.png",
    ["arrow_reply_all"] = "ic_fluent_arrow_reply_all_24_filled.png",
    ["arrowreplydown"] = "ic_fluent_arrow_reply_down_24_filled.png",
    ["arrow-reply-down"] = "ic_fluent_arrow_reply_down_24_filled.png",
    ["arrow_reply_down"] = "ic_fluent_arrow_reply_down_24_filled.png",
    ["arrowreset"] = "ic_fluent_arrow_reset_24_filled.png",
    ["arrow-reset"] = "ic_fluent_arrow_reset_24_filled.png",
    ["arrow_reset"] = "ic_fluent_arrow_reset_24_filled.png",
    ["arrowright"] = "ic_fluent_arrow_right_24_filled.png",
    ["arrow-right"] = "ic_fluent_arrow_right_24_filled.png",
    ["arrow_right"] = "ic_fluent_arrow_right_24_filled.png",
    ["arrowrotateclockwise"] = "ic_fluent_arrow_rotate_clockwise_24_filled.png",
    ["arrow-rotate-clockwise"] = "ic_fluent_arrow_rotate_clockwise_24_filled.png",
    ["arrow_rotate_clockwise"] = "ic_fluent_arrow_rotate_clockwise_24_filled.png",
    ["arrowrotatecounterclockwise"] = "ic_fluent_arrow_rotate_counterclockwise_24_filled.png",
    ["arrow-rotate-counterclockwise"] = "ic_fluent_arrow_rotate_counterclockwise_24_filled.png",
    ["arrow_rotate_counterclockwise"] = "ic_fluent_arrow_rotate_counterclockwise_24_filled.png",
    ["arrowrouting"] = "ic_fluent_arrow_routing_24_filled.png",
    ["arrow-routing"] = "ic_fluent_arrow_routing_24_filled.png",
    ["arrow_routing"] = "ic_fluent_arrow_routing_24_filled.png",
    ["arrowroutingrectanglemultiple"] = "ic_fluent_arrow_routing_rectangle_multiple_24_filled.png",
    ["arrow-routing-rectangle-multiple"] = "ic_fluent_arrow_routing_rectangle_multiple_24_filled.png",
    ["arrow_routing_rectangle_multiple"] = "ic_fluent_arrow_routing_rectangle_multiple_24_filled.png",
    ["arrowsort"] = "ic_fluent_arrow_sort_24_filled.png",
    ["arrow-sort"] = "ic_fluent_arrow_sort_24_filled.png",
    ["arrow_sort"] = "ic_fluent_arrow_sort_24_filled.png",
    ["arrowsortdown"] = "ic_fluent_arrow_sort_down_24_filled.png",
    ["arrow-sort-down"] = "ic_fluent_arrow_sort_down_24_filled.png",
    ["arrow_sort_down"] = "ic_fluent_arrow_sort_down_24_filled.png",
    ["arrowsortup"] = "ic_fluent_arrow_sort_up_24_filled.png",
    ["arrow-sort-up"] = "ic_fluent_arrow_sort_up_24_filled.png",
    ["arrow_sort_up"] = "ic_fluent_arrow_sort_up_24_filled.png",
    ["arrowsquaredown"] = "ic_fluent_arrow_square_down_24_filled.png",
    ["arrow-square-down"] = "ic_fluent_arrow_square_down_24_filled.png",
    ["arrow_square_down"] = "ic_fluent_arrow_square_down_24_filled.png",
    ["arrowswap"] = "ic_fluent_arrow_swap_24_filled.png",
    ["arrow-swap"] = "ic_fluent_arrow_swap_24_filled.png",
    ["arrow_swap"] = "ic_fluent_arrow_swap_24_filled.png",
    ["arrowsync"] = "ic_fluent_arrow_sync_24_filled.png",
    ["arrow-sync"] = "ic_fluent_arrow_sync_24_filled.png",
    ["arrow_sync"] = "ic_fluent_arrow_sync_24_filled.png",
    ["arrowsynccircle"] = "ic_fluent_arrow_sync_circle_24_filled.png",
    ["arrow-sync-circle"] = "ic_fluent_arrow_sync_circle_24_filled.png",
    ["arrow_sync_circle"] = "ic_fluent_arrow_sync_circle_24_filled.png",
    ["arrowtrending"] = "ic_fluent_arrow_trending_24_filled.png",
    ["arrow-trending"] = "ic_fluent_arrow_trending_24_filled.png",
    ["arrow_trending"] = "ic_fluent_arrow_trending_24_filled.png",
    ["arrowtrendingcheckmark"] = "ic_fluent_arrow_trending_checkmark_24_filled.png",
    ["arrow-trending-checkmark"] = "ic_fluent_arrow_trending_checkmark_24_filled.png",
    ["arrow_trending_checkmark"] = "ic_fluent_arrow_trending_checkmark_24_filled.png",
    ["arrowtrendinglines"] = "ic_fluent_arrow_trending_lines_24_filled.png",
    ["arrow-trending-lines"] = "ic_fluent_arrow_trending_lines_24_filled.png",
    ["arrow_trending_lines"] = "ic_fluent_arrow_trending_lines_24_filled.png",
    ["arrowtrendingsettings"] = "ic_fluent_arrow_trending_settings_24_filled.png",
    ["arrow-trending-settings"] = "ic_fluent_arrow_trending_settings_24_filled.png",
    ["arrow_trending_settings"] = "ic_fluent_arrow_trending_settings_24_filled.png",
    ["arrowturnbidirectionaldownright"] = "ic_fluent_arrow_turn_bidirectional_down_right_24_filled.png",
    ["arrow-turn-bidirectional-down-right"] = "ic_fluent_arrow_turn_bidirectional_down_right_24_filled.png",
    ["arrow_turn_bidirectional_down_right"] = "ic_fluent_arrow_turn_bidirectional_down_right_24_filled.png",
    ["arrowturnright"] = "ic_fluent_arrow_turn_right_24_filled.png",
    ["arrow-turn-right"] = "ic_fluent_arrow_turn_right_24_filled.png",
    ["arrow_turn_right"] = "ic_fluent_arrow_turn_right_24_filled.png",
    ["arrowundo"] = "ic_fluent_arrow_undo_24_filled.png",
    ["arrow-undo"] = "ic_fluent_arrow_undo_24_filled.png",
    ["arrow_undo"] = "ic_fluent_arrow_undo_24_filled.png",
    ["arrowup"] = "ic_fluent_arrow_up_24_filled.png",
    ["arrow-up"] = "ic_fluent_arrow_up_24_filled.png",
    ["arrow_up"] = "ic_fluent_arrow_up_24_filled.png",
    ["arrowupleft"] = "ic_fluent_arrow_up_left_24_filled.png",
    ["arrow-up-left"] = "ic_fluent_arrow_up_left_24_filled.png",
    ["arrow_up_left"] = "ic_fluent_arrow_up_left_24_filled.png",
    ["arrowupright"] = "ic_fluent_arrow_up_right_24_filled.png",
    ["arrow-up-right"] = "ic_fluent_arrow_up_right_24_filled.png",
    ["arrow_up_right"] = "ic_fluent_arrow_up_right_24_filled.png",
    ["arrowupload"] = "ic_fluent_arrow_upload_24_filled.png",
    ["arrow-upload"] = "ic_fluent_arrow_upload_24_filled.png",
    ["arrow_upload"] = "ic_fluent_arrow_upload_24_filled.png",
    ["arrowsbidirectional"] = "ic_fluent_arrows_bidirectional_24_filled.png",
    ["arrows-bidirectional"] = "ic_fluent_arrows_bidirectional_24_filled.png",
    ["arrows_bidirectional"] = "ic_fluent_arrows_bidirectional_24_filled.png",
    ["attach"] = "ic_fluent_attach_24_filled.png",
    ["attacharrowright"] = "ic_fluent_attach_arrow_right_24_filled.png",
    ["attach-arrow-right"] = "ic_fluent_attach_arrow_right_24_filled.png",
    ["attach_arrow_right"] = "ic_fluent_attach_arrow_right_24_filled.png",
    ["attachtext"] = "ic_fluent_attach_text_24_filled.png",
    ["attach-text"] = "ic_fluent_attach_text_24_filled.png",
    ["attach_text"] = "ic_fluent_attach_text_24_filled.png",
    ["autofitheight"] = "ic_fluent_auto_fit_height_24_filled.png",
    ["auto-fit-height"] = "ic_fluent_auto_fit_height_24_filled.png",
    ["auto_fit_height"] = "ic_fluent_auto_fit_height_24_filled.png",
    ["autofitwidth"] = "ic_fluent_auto_fit_width_24_filled.png",
    ["auto-fit-width"] = "ic_fluent_auto_fit_width_24_filled.png",
    ["auto_fit_width"] = "ic_fluent_auto_fit_width_24_filled.png",
    ["autocorrect"] = "ic_fluent_autocorrect_24_filled.png",
    ["autofitcontent"] = "ic_fluent_autofit_content_24_filled.png",
    ["autofit-content"] = "ic_fluent_autofit_content_24_filled.png",
    ["autofit_content"] = "ic_fluent_autofit_content_24_filled.png",
    ["autosum"] = "ic_fluent_autosum_24_filled.png",
    ["backpack"] = "ic_fluent_backpack_24_filled.png",
    ["backpackadd"] = "ic_fluent_backpack_add_24_filled.png",
    ["backpack-add"] = "ic_fluent_backpack_add_24_filled.png",
    ["backpack_add"] = "ic_fluent_backpack_add_24_filled.png",
    ["backspace"] = "ic_fluent_backspace_24_filled.png",
    ["badge"] = "ic_fluent_badge_24_filled.png",
    ["balloon"] = "ic_fluent_balloon_24_filled.png",
    ["barcodescanner"] = "ic_fluent_barcode_scanner_24_filled.png",
    ["barcode-scanner"] = "ic_fluent_barcode_scanner_24_filled.png",
    ["barcode_scanner"] = "ic_fluent_barcode_scanner_24_filled.png",
    ["battery0"] = "ic_fluent_battery_0_24_filled.png",
    ["battery1"] = "ic_fluent_battery_1_24_filled.png",
    ["battery2"] = "ic_fluent_battery_2_24_filled.png",
    ["battery3"] = "ic_fluent_battery_3_24_filled.png",
    ["battery4"] = "ic_fluent_battery_4_24_filled.png",
    ["battery5"] = "ic_fluent_battery_5_24_filled.png",
    ["battery6"] = "ic_fluent_battery_6_24_filled.png",
    ["battery7"] = "ic_fluent_battery_7_24_filled.png",
    ["battery8"] = "ic_fluent_battery_8_24_filled.png",
    ["battery9"] = "ic_fluent_battery_9_24_filled.png",
    ["batterycharge"] = "ic_fluent_battery_charge_24_filled.png",
    ["battery-charge"] = "ic_fluent_battery_charge_24_filled.png",
    ["battery_charge"] = "ic_fluent_battery_charge_24_filled.png",
    ["batterycheckmark"] = "ic_fluent_battery_checkmark_24_filled.png",
    ["battery-checkmark"] = "ic_fluent_battery_checkmark_24_filled.png",
    ["battery_checkmark"] = "ic_fluent_battery_checkmark_24_filled.png",
    ["batteryfull"] = "ic_fluent_battery_full_24_filled.png",
    ["battery-full"] = "ic_fluent_battery_full_24_filled.png",
    ["battery_full"] = "ic_fluent_battery_full_24_filled.png",
    ["batterysaver"] = "ic_fluent_battery_saver_24_filled.png",
    ["battery-saver"] = "ic_fluent_battery_saver_24_filled.png",
    ["battery_saver"] = "ic_fluent_battery_saver_24_filled.png",
    ["batterywarning"] = "ic_fluent_battery_warning_24_filled.png",
    ["battery-warning"] = "ic_fluent_battery_warning_24_filled.png",
    ["battery_warning"] = "ic_fluent_battery_warning_24_filled.png",
    ["beach"] = "ic_fluent_beach_24_filled.png",
    ["beaker"] = "ic_fluent_beaker_24_filled.png",
    ["beakeredit"] = "ic_fluent_beaker_edit_24_filled.png",
    ["beaker-edit"] = "ic_fluent_beaker_edit_24_filled.png",
    ["beaker_edit"] = "ic_fluent_beaker_edit_24_filled.png",
    ["bed"] = "ic_fluent_bed_24_filled.png",
    ["binfull"] = "ic_fluent_bin_full_24_filled.png",
    ["bin-full"] = "ic_fluent_bin_full_24_filled.png",
    ["bin_full"] = "ic_fluent_bin_full_24_filled.png",
    ["block"] = "ic_fluent_block_24_filled.png",
    ["bluetooth"] = "ic_fluent_bluetooth_24_filled.png",
    ["bluetoothconnected"] = "ic_fluent_bluetooth_connected_24_filled.png",
    ["bluetooth-connected"] = "ic_fluent_bluetooth_connected_24_filled.png",
    ["bluetooth_connected"] = "ic_fluent_bluetooth_connected_24_filled.png",
    ["bluetoothdisabled"] = "ic_fluent_bluetooth_disabled_24_filled.png",
    ["bluetooth-disabled"] = "ic_fluent_bluetooth_disabled_24_filled.png",
    ["bluetooth_disabled"] = "ic_fluent_bluetooth_disabled_24_filled.png",
    ["bluetoothsearching"] = "ic_fluent_bluetooth_searching_24_filled.png",
    ["bluetooth-searching"] = "ic_fluent_bluetooth_searching_24_filled.png",
    ["bluetooth_searching"] = "ic_fluent_bluetooth_searching_24_filled.png",
    ["blur"] = "ic_fluent_blur_24_filled.png",
    ["board"] = "ic_fluent_board_24_filled.png",
    ["boardsplit"] = "ic_fluent_board_split_24_filled.png",
    ["board-split"] = "ic_fluent_board_split_24_filled.png",
    ["board_split"] = "ic_fluent_board_split_24_filled.png",
    ["book"] = "ic_fluent_book_24_filled.png",
    ["bookadd"] = "ic_fluent_book_add_24_filled.png",
    ["book-add"] = "ic_fluent_book_add_24_filled.png",
    ["book_add"] = "ic_fluent_book_add_24_filled.png",
    ["bookclock"] = "ic_fluent_book_clock_24_filled.png",
    ["book-clock"] = "ic_fluent_book_clock_24_filled.png",
    ["book_clock"] = "ic_fluent_book_clock_24_filled.png",
    ["bookcoins"] = "ic_fluent_book_coins_24_filled.png",
    ["book-coins"] = "ic_fluent_book_coins_24_filled.png",
    ["book_coins"] = "ic_fluent_book_coins_24_filled.png",
    ["bookcompass"] = "ic_fluent_book_compass_24_filled.png",
    ["book-compass"] = "ic_fluent_book_compass_24_filled.png",
    ["book_compass"] = "ic_fluent_book_compass_24_filled.png",
    ["bookcontacts"] = "ic_fluent_book_contacts_24_filled.png",
    ["book-contacts"] = "ic_fluent_book_contacts_24_filled.png",
    ["book_contacts"] = "ic_fluent_book_contacts_24_filled.png",
    ["bookdatabase"] = "ic_fluent_book_database_24_filled.png",
    ["book-database"] = "ic_fluent_book_database_24_filled.png",
    ["book_database"] = "ic_fluent_book_database_24_filled.png",
    ["bookexclamationmark"] = "ic_fluent_book_exclamation_mark_24_filled.png",
    ["book-exclamation-mark"] = "ic_fluent_book_exclamation_mark_24_filled.png",
    ["book_exclamation_mark"] = "ic_fluent_book_exclamation_mark_24_filled.png",
    ["bookglobe"] = "ic_fluent_book_globe_24_filled.png",
    ["book-globe"] = "ic_fluent_book_globe_24_filled.png",
    ["book_globe"] = "ic_fluent_book_globe_24_filled.png",
    ["bookinformation"] = "ic_fluent_book_information_24_filled.png",
    ["book-information"] = "ic_fluent_book_information_24_filled.png",
    ["book_information"] = "ic_fluent_book_information_24_filled.png",
    ["bookletter"] = "ic_fluent_book_letter_24_filled.png",
    ["book-letter"] = "ic_fluent_book_letter_24_filled.png",
    ["book_letter"] = "ic_fluent_book_letter_24_filled.png",
    ["booknumber"] = "ic_fluent_book_number_24_filled.png",
    ["book-number"] = "ic_fluent_book_number_24_filled.png",
    ["book_number"] = "ic_fluent_book_number_24_filled.png",
    ["bookopen"] = "ic_fluent_book_open_24_filled.png",
    ["book-open"] = "ic_fluent_book_open_24_filled.png",
    ["book_open"] = "ic_fluent_book_open_24_filled.png",
    ["bookopenglobe"] = "ic_fluent_book_open_globe_24_filled.png",
    ["book-open-globe"] = "ic_fluent_book_open_globe_24_filled.png",
    ["book_open_globe"] = "ic_fluent_book_open_globe_24_filled.png",
    ["bookopenmicrophone"] = "ic_fluent_book_open_microphone_24_filled.png",
    ["book-open-microphone"] = "ic_fluent_book_open_microphone_24_filled.png",
    ["book_open_microphone"] = "ic_fluent_book_open_microphone_24_filled.png",
    ["bookpulse"] = "ic_fluent_book_pulse_24_filled.png",
    ["book-pulse"] = "ic_fluent_book_pulse_24_filled.png",
    ["book_pulse"] = "ic_fluent_book_pulse_24_filled.png",
    ["bookquestionmark"] = "ic_fluent_book_question_mark_24_filled.png",
    ["book-question-mark"] = "ic_fluent_book_question_mark_24_filled.png",
    ["book_question_mark"] = "ic_fluent_book_question_mark_24_filled.png",
    ["bookquestionmarkrtl"] = "ic_fluent_book_question_mark_rtl_24_filled.png",
    ["book-question-mark-rtl"] = "ic_fluent_book_question_mark_rtl_24_filled.png",
    ["book_question_mark_rtl"] = "ic_fluent_book_question_mark_rtl_24_filled.png",
    ["booksearch"] = "ic_fluent_book_search_24_filled.png",
    ["book-search"] = "ic_fluent_book_search_24_filled.png",
    ["book_search"] = "ic_fluent_book_search_24_filled.png",
    ["bookstar"] = "ic_fluent_book_star_24_filled.png",
    ["book-star"] = "ic_fluent_book_star_24_filled.png",
    ["book_star"] = "ic_fluent_book_star_24_filled.png",
    ["booktheta"] = "ic_fluent_book_theta_24_filled.png",
    ["book-theta"] = "ic_fluent_book_theta_24_filled.png",
    ["book_theta"] = "ic_fluent_book_theta_24_filled.png",
    ["booktoolbox"] = "ic_fluent_book_toolbox_24_filled.png",
    ["book-toolbox"] = "ic_fluent_book_toolbox_24_filled.png",
    ["book_toolbox"] = "ic_fluent_book_toolbox_24_filled.png",
    ["bookmark"] = "ic_fluent_bookmark_24_filled.png",
    ["bookmarkadd"] = "ic_fluent_bookmark_add_24_filled.png",
    ["bookmark-add"] = "ic_fluent_bookmark_add_24_filled.png",
    ["bookmark_add"] = "ic_fluent_bookmark_add_24_filled.png",
    ["bookmarkmultiple"] = "ic_fluent_bookmark_multiple_24_filled.png",
    ["bookmark-multiple"] = "ic_fluent_bookmark_multiple_24_filled.png",
    ["bookmark_multiple"] = "ic_fluent_bookmark_multiple_24_filled.png",
    ["bookmarkoff"] = "ic_fluent_bookmark_off_24_filled.png",
    ["bookmark-off"] = "ic_fluent_bookmark_off_24_filled.png",
    ["bookmark_off"] = "ic_fluent_bookmark_off_24_filled.png",
    ["border"] = "ic_fluent_border_24_filled.png",
    ["borderall"] = "ic_fluent_border_all_24_filled.png",
    ["border-all"] = "ic_fluent_border_all_24_filled.png",
    ["border_all"] = "ic_fluent_border_all_24_filled.png",
    ["borderbottom"] = "ic_fluent_border_bottom_24_filled.png",
    ["border-bottom"] = "ic_fluent_border_bottom_24_filled.png",
    ["border_bottom"] = "ic_fluent_border_bottom_24_filled.png",
    ["borderbottomdouble"] = "ic_fluent_border_bottom_double_24_filled.png",
    ["border-bottom-double"] = "ic_fluent_border_bottom_double_24_filled.png",
    ["border_bottom_double"] = "ic_fluent_border_bottom_double_24_filled.png",
    ["borderbottomthick"] = "ic_fluent_border_bottom_thick_24_filled.png",
    ["border-bottom-thick"] = "ic_fluent_border_bottom_thick_24_filled.png",
    ["border_bottom_thick"] = "ic_fluent_border_bottom_thick_24_filled.png",
    ["borderleft"] = "ic_fluent_border_left_24_filled.png",
    ["border-left"] = "ic_fluent_border_left_24_filled.png",
    ["border_left"] = "ic_fluent_border_left_24_filled.png",
    ["borderoutside"] = "ic_fluent_border_outside_24_filled.png",
    ["border-outside"] = "ic_fluent_border_outside_24_filled.png",
    ["border_outside"] = "ic_fluent_border_outside_24_filled.png",
    ["borderoutsidethick"] = "ic_fluent_border_outside_thick_24_filled.png",
    ["border-outside-thick"] = "ic_fluent_border_outside_thick_24_filled.png",
    ["border_outside_thick"] = "ic_fluent_border_outside_thick_24_filled.png",
    ["borderright"] = "ic_fluent_border_right_24_filled.png",
    ["border-right"] = "ic_fluent_border_right_24_filled.png",
    ["border_right"] = "ic_fluent_border_right_24_filled.png",
    ["bordertop"] = "ic_fluent_border_top_24_filled.png",
    ["border-top"] = "ic_fluent_border_top_24_filled.png",
    ["border_top"] = "ic_fluent_border_top_24_filled.png",
    ["bordertopbottom"] = "ic_fluent_border_top_bottom_24_filled.png",
    ["border-top-bottom"] = "ic_fluent_border_top_bottom_24_filled.png",
    ["border_top_bottom"] = "ic_fluent_border_top_bottom_24_filled.png",
    ["bordertopbottomdouble"] = "ic_fluent_border_top_bottom_double_24_filled.png",
    ["border-top-bottom-double"] = "ic_fluent_border_top_bottom_double_24_filled.png",
    ["border_top_bottom_double"] = "ic_fluent_border_top_bottom_double_24_filled.png",
    ["bordertopbottomthick"] = "ic_fluent_border_top_bottom_thick_24_filled.png",
    ["border-top-bottom-thick"] = "ic_fluent_border_top_bottom_thick_24_filled.png",
    ["border_top_bottom_thick"] = "ic_fluent_border_top_bottom_thick_24_filled.png",
    ["bot"] = "ic_fluent_bot_24_filled.png",
    ["botadd"] = "ic_fluent_bot_add_24_filled.png",
    ["bot-add"] = "ic_fluent_bot_add_24_filled.png",
    ["bot_add"] = "ic_fluent_bot_add_24_filled.png",
    ["bowlchopsticks"] = "ic_fluent_bowl_chopsticks_24_filled.png",
    ["bowl-chopsticks"] = "ic_fluent_bowl_chopsticks_24_filled.png",
    ["bowl_chopsticks"] = "ic_fluent_bowl_chopsticks_24_filled.png",
    ["boxedit"] = "ic_fluent_box_edit_24_filled.png",
    ["box-edit"] = "ic_fluent_box_edit_24_filled.png",
    ["box_edit"] = "ic_fluent_box_edit_24_filled.png",
    ["boxtoolbox"] = "ic_fluent_box_toolbox_24_filled.png",
    ["box-toolbox"] = "ic_fluent_box_toolbox_24_filled.png",
    ["box_toolbox"] = "ic_fluent_box_toolbox_24_filled.png",
    ["bracesvariable"] = "ic_fluent_braces_variable_24_filled.png",
    ["braces-variable"] = "ic_fluent_braces_variable_24_filled.png",
    ["braces_variable"] = "ic_fluent_braces_variable_24_filled.png",
    ["braincircuit"] = "ic_fluent_brain_circuit_24_filled.png",
    ["brain-circuit"] = "ic_fluent_brain_circuit_24_filled.png",
    ["brain_circuit"] = "ic_fluent_brain_circuit_24_filled.png",
    ["branch"] = "ic_fluent_branch_24_filled.png",
    ["branchcompare"] = "ic_fluent_branch_compare_24_filled.png",
    ["branch-compare"] = "ic_fluent_branch_compare_24_filled.png",
    ["branch_compare"] = "ic_fluent_branch_compare_24_filled.png",
    ["branchfork"] = "ic_fluent_branch_fork_24_filled.png",
    ["branch-fork"] = "ic_fluent_branch_fork_24_filled.png",
    ["branch_fork"] = "ic_fluent_branch_fork_24_filled.png",
    ["briefcase"] = "ic_fluent_briefcase_24_filled.png",
    ["briefcasemedical"] = "ic_fluent_briefcase_medical_24_filled.png",
    ["briefcase-medical"] = "ic_fluent_briefcase_medical_24_filled.png",
    ["briefcase_medical"] = "ic_fluent_briefcase_medical_24_filled.png",
    ["briefcaseoff"] = "ic_fluent_briefcase_off_24_filled.png",
    ["briefcase-off"] = "ic_fluent_briefcase_off_24_filled.png",
    ["briefcase_off"] = "ic_fluent_briefcase_off_24_filled.png",
    ["broadactivityfeed"] = "ic_fluent_broad_activity_feed_24_filled.png",
    ["broad-activity-feed"] = "ic_fluent_broad_activity_feed_24_filled.png",
    ["broad_activity_feed"] = "ic_fluent_broad_activity_feed_24_filled.png",
    ["broom"] = "ic_fluent_broom_24_filled.png",
    ["bug"] = "ic_fluent_bug_24_filled.png",
    ["building"] = "ic_fluent_building_24_filled.png",
    ["buildingbank"] = "ic_fluent_building_bank_24_filled.png",
    ["building-bank"] = "ic_fluent_building_bank_24_filled.png",
    ["building_bank"] = "ic_fluent_building_bank_24_filled.png",
    ["buildingbanklink"] = "ic_fluent_building_bank_link_24_filled.png",
    ["building-bank-link"] = "ic_fluent_building_bank_link_24_filled.png",
    ["building_bank_link"] = "ic_fluent_building_bank_link_24_filled.png",
    ["buildingbanktoolbox"] = "ic_fluent_building_bank_toolbox_24_filled.png",
    ["building-bank-toolbox"] = "ic_fluent_building_bank_toolbox_24_filled.png",
    ["building_bank_toolbox"] = "ic_fluent_building_bank_toolbox_24_filled.png",
    ["buildingfactory"] = "ic_fluent_building_factory_24_filled.png",
    ["building-factory"] = "ic_fluent_building_factory_24_filled.png",
    ["building_factory"] = "ic_fluent_building_factory_24_filled.png",
    ["buildinggovernment"] = "ic_fluent_building_government_24_filled.png",
    ["building-government"] = "ic_fluent_building_government_24_filled.png",
    ["building_government"] = "ic_fluent_building_government_24_filled.png",
    ["buildingmultiple"] = "ic_fluent_building_multiple_24_filled.png",
    ["building-multiple"] = "ic_fluent_building_multiple_24_filled.png",
    ["building_multiple"] = "ic_fluent_building_multiple_24_filled.png",
    ["buildingretail"] = "ic_fluent_building_retail_24_filled.png",
    ["building-retail"] = "ic_fluent_building_retail_24_filled.png",
    ["building_retail"] = "ic_fluent_building_retail_24_filled.png",
    ["buildingretailmoney"] = "ic_fluent_building_retail_money_24_filled.png",
    ["building-retail-money"] = "ic_fluent_building_retail_money_24_filled.png",
    ["building_retail_money"] = "ic_fluent_building_retail_money_24_filled.png",
    ["buildingretailshield"] = "ic_fluent_building_retail_shield_24_filled.png",
    ["building-retail-shield"] = "ic_fluent_building_retail_shield_24_filled.png",
    ["building_retail_shield"] = "ic_fluent_building_retail_shield_24_filled.png",
    ["buildingretailtoolbox"] = "ic_fluent_building_retail_toolbox_24_filled.png",
    ["building-retail-toolbox"] = "ic_fluent_building_retail_toolbox_24_filled.png",
    ["building_retail_toolbox"] = "ic_fluent_building_retail_toolbox_24_filled.png",
    ["buildingshop"] = "ic_fluent_building_shop_24_filled.png",
    ["building-shop"] = "ic_fluent_building_shop_24_filled.png",
    ["building_shop"] = "ic_fluent_building_shop_24_filled.png",
    ["buildingskyscraper"] = "ic_fluent_building_skyscraper_24_filled.png",
    ["building-skyscraper"] = "ic_fluent_building_skyscraper_24_filled.png",
    ["building_skyscraper"] = "ic_fluent_building_skyscraper_24_filled.png",
    ["calculator"] = "ic_fluent_calculator_24_filled.png",
    ["calculatormultiple"] = "ic_fluent_calculator_multiple_24_filled.png",
    ["calculator-multiple"] = "ic_fluent_calculator_multiple_24_filled.png",
    ["calculator_multiple"] = "ic_fluent_calculator_multiple_24_filled.png",
    ["calendar3day"] = "ic_fluent_calendar_3_day_24_filled.png",
    ["calendar3-day"] = "ic_fluent_calendar_3_day_24_filled.png",
    ["calendar3_day"] = "ic_fluent_calendar_3_day_24_filled.png",
    ["calendaradd"] = "ic_fluent_calendar_add_24_filled.png",
    ["calendar-add"] = "ic_fluent_calendar_add_24_filled.png",
    ["calendar_add"] = "ic_fluent_calendar_add_24_filled.png",
    ["calendaragenda"] = "ic_fluent_calendar_agenda_24_filled.png",
    ["calendar-agenda"] = "ic_fluent_calendar_agenda_24_filled.png",
    ["calendar_agenda"] = "ic_fluent_calendar_agenda_24_filled.png",
    ["calendararrowdown"] = "ic_fluent_calendar_arrow_down_24_filled.png",
    ["calendar-arrow-down"] = "ic_fluent_calendar_arrow_down_24_filled.png",
    ["calendar_arrow_down"] = "ic_fluent_calendar_arrow_down_24_filled.png",
    ["calendarassistant"] = "ic_fluent_calendar_assistant_24_filled.png",
    ["calendar-assistant"] = "ic_fluent_calendar_assistant_24_filled.png",
    ["calendar_assistant"] = "ic_fluent_calendar_assistant_24_filled.png",
    ["calendarcancel"] = "ic_fluent_calendar_cancel_24_filled.png",
    ["calendar-cancel"] = "ic_fluent_calendar_cancel_24_filled.png",
    ["calendar_cancel"] = "ic_fluent_calendar_cancel_24_filled.png",
    ["calendarcheckmark"] = "ic_fluent_calendar_checkmark_24_filled.png",
    ["calendar-checkmark"] = "ic_fluent_calendar_checkmark_24_filled.png",
    ["calendar_checkmark"] = "ic_fluent_calendar_checkmark_24_filled.png",
    ["calendarclock"] = "ic_fluent_calendar_clock_24_filled.png",
    ["calendar-clock"] = "ic_fluent_calendar_clock_24_filled.png",
    ["calendar_clock"] = "ic_fluent_calendar_clock_24_filled.png",
    ["calendarday"] = "ic_fluent_calendar_day_24_filled.png",
    ["calendar-day"] = "ic_fluent_calendar_day_24_filled.png",
    ["calendar_day"] = "ic_fluent_calendar_day_24_filled.png",
    ["calendaredit"] = "ic_fluent_calendar_edit_24_filled.png",
    ["calendar-edit"] = "ic_fluent_calendar_edit_24_filled.png",
    ["calendar_edit"] = "ic_fluent_calendar_edit_24_filled.png",
    ["calendarempty"] = "ic_fluent_calendar_empty_24_filled.png",
    ["calendar-empty"] = "ic_fluent_calendar_empty_24_filled.png",
    ["calendar_empty"] = "ic_fluent_calendar_empty_24_filled.png",
    ["calendarerror"] = "ic_fluent_calendar_error_24_filled.png",
    ["calendar-error"] = "ic_fluent_calendar_error_24_filled.png",
    ["calendar_error"] = "ic_fluent_calendar_error_24_filled.png",
    ["calendarltr"] = "ic_fluent_calendar_ltr_24_filled.png",
    ["calendar-ltr"] = "ic_fluent_calendar_ltr_24_filled.png",
    ["calendar_ltr"] = "ic_fluent_calendar_ltr_24_filled.png",
    ["calendarmonth"] = "ic_fluent_calendar_month_24_filled.png",
    ["calendar-month"] = "ic_fluent_calendar_month_24_filled.png",
    ["calendar_month"] = "ic_fluent_calendar_month_24_filled.png",
    ["calendarmultiple"] = "ic_fluent_calendar_multiple_24_filled.png",
    ["calendar-multiple"] = "ic_fluent_calendar_multiple_24_filled.png",
    ["calendar_multiple"] = "ic_fluent_calendar_multiple_24_filled.png",
    ["calendaroverdue"] = "ic_fluent_calendar_overdue_24_filled.png",
    ["calendar-overdue"] = "ic_fluent_calendar_overdue_24_filled.png",
    ["calendar_overdue"] = "ic_fluent_calendar_overdue_24_filled.png",
    ["calendarperson"] = "ic_fluent_calendar_person_24_filled.png",
    ["calendar-person"] = "ic_fluent_calendar_person_24_filled.png",
    ["calendar_person"] = "ic_fluent_calendar_person_24_filled.png",
    ["calendarquestionmark"] = "ic_fluent_calendar_question_mark_24_filled.png",
    ["calendar-question-mark"] = "ic_fluent_calendar_question_mark_24_filled.png",
    ["calendar_question_mark"] = "ic_fluent_calendar_question_mark_24_filled.png",
    ["calendarreply"] = "ic_fluent_calendar_reply_24_filled.png",
    ["calendar-reply"] = "ic_fluent_calendar_reply_24_filled.png",
    ["calendar_reply"] = "ic_fluent_calendar_reply_24_filled.png",
    ["calendarrtl"] = "ic_fluent_calendar_rtl_24_filled.png",
    ["calendar-rtl"] = "ic_fluent_calendar_rtl_24_filled.png",
    ["calendar_rtl"] = "ic_fluent_calendar_rtl_24_filled.png",
    ["calendarstar"] = "ic_fluent_calendar_star_24_filled.png",
    ["calendar-star"] = "ic_fluent_calendar_star_24_filled.png",
    ["calendar_star"] = "ic_fluent_calendar_star_24_filled.png",
    ["calendarsync"] = "ic_fluent_calendar_sync_24_filled.png",
    ["calendar-sync"] = "ic_fluent_calendar_sync_24_filled.png",
    ["calendar_sync"] = "ic_fluent_calendar_sync_24_filled.png",
    ["calendartoday"] = "ic_fluent_calendar_today_24_filled.png",
    ["calendar-today"] = "ic_fluent_calendar_today_24_filled.png",
    ["calendar_today"] = "ic_fluent_calendar_today_24_filled.png",
    ["calendarweeknumbers"] = "ic_fluent_calendar_week_numbers_24_filled.png",
    ["calendar-week-numbers"] = "ic_fluent_calendar_week_numbers_24_filled.png",
    ["calendar_week_numbers"] = "ic_fluent_calendar_week_numbers_24_filled.png",
    ["calendarweekstart"] = "ic_fluent_calendar_week_start_24_filled.png",
    ["calendar-week-start"] = "ic_fluent_calendar_week_start_24_filled.png",
    ["calendar_week_start"] = "ic_fluent_calendar_week_start_24_filled.png",
    ["calendarworkweek"] = "ic_fluent_calendar_work_week_24_filled.png",
    ["calendar-work-week"] = "ic_fluent_calendar_work_week_24_filled.png",
    ["calendar_work_week"] = "ic_fluent_calendar_work_week_24_filled.png",
    ["call"] = "ic_fluent_call_24_filled.png",
    ["calladd"] = "ic_fluent_call_add_24_filled.png",
    ["call-add"] = "ic_fluent_call_add_24_filled.png",
    ["call_add"] = "ic_fluent_call_add_24_filled.png",
    ["callcheckmark"] = "ic_fluent_call_checkmark_24_filled.png",
    ["call-checkmark"] = "ic_fluent_call_checkmark_24_filled.png",
    ["call_checkmark"] = "ic_fluent_call_checkmark_24_filled.png",
    ["calldismiss"] = "ic_fluent_call_dismiss_24_filled.png",
    ["call-dismiss"] = "ic_fluent_call_dismiss_24_filled.png",
    ["call_dismiss"] = "ic_fluent_call_dismiss_24_filled.png",
    ["callend"] = "ic_fluent_call_end_24_filled.png",
    ["call-end"] = "ic_fluent_call_end_24_filled.png",
    ["call_end"] = "ic_fluent_call_end_24_filled.png",
    ["callforward"] = "ic_fluent_call_forward_24_filled.png",
    ["call-forward"] = "ic_fluent_call_forward_24_filled.png",
    ["call_forward"] = "ic_fluent_call_forward_24_filled.png",
    ["callinbound"] = "ic_fluent_call_inbound_24_filled.png",
    ["call-inbound"] = "ic_fluent_call_inbound_24_filled.png",
    ["call_inbound"] = "ic_fluent_call_inbound_24_filled.png",
    ["callmissed"] = "ic_fluent_call_missed_24_filled.png",
    ["call-missed"] = "ic_fluent_call_missed_24_filled.png",
    ["call_missed"] = "ic_fluent_call_missed_24_filled.png",
    ["calloutbound"] = "ic_fluent_call_outbound_24_filled.png",
    ["call-outbound"] = "ic_fluent_call_outbound_24_filled.png",
    ["call_outbound"] = "ic_fluent_call_outbound_24_filled.png",
    ["callpark"] = "ic_fluent_call_park_24_filled.png",
    ["call-park"] = "ic_fluent_call_park_24_filled.png",
    ["call_park"] = "ic_fluent_call_park_24_filled.png",
    ["callpause"] = "ic_fluent_call_pause_24_filled.png",
    ["call-pause"] = "ic_fluent_call_pause_24_filled.png",
    ["call_pause"] = "ic_fluent_call_pause_24_filled.png",
    ["callprohibited"] = "ic_fluent_call_prohibited_24_filled.png",
    ["call-prohibited"] = "ic_fluent_call_prohibited_24_filled.png",
    ["call_prohibited"] = "ic_fluent_call_prohibited_24_filled.png",
    ["calligraphypen"] = "ic_fluent_calligraphy_pen_24_filled.png",
    ["calligraphy-pen"] = "ic_fluent_calligraphy_pen_24_filled.png",
    ["calligraphy_pen"] = "ic_fluent_calligraphy_pen_24_filled.png",
    ["camera"] = "ic_fluent_camera_24_filled.png",
    ["cameraadd"] = "ic_fluent_camera_add_24_filled.png",
    ["camera-add"] = "ic_fluent_camera_add_24_filled.png",
    ["camera_add"] = "ic_fluent_camera_add_24_filled.png",
    ["cameradome"] = "ic_fluent_camera_dome_24_filled.png",
    ["camera-dome"] = "ic_fluent_camera_dome_24_filled.png",
    ["camera_dome"] = "ic_fluent_camera_dome_24_filled.png",
    ["cameraoff"] = "ic_fluent_camera_off_24_filled.png",
    ["camera-off"] = "ic_fluent_camera_off_24_filled.png",
    ["camera_off"] = "ic_fluent_camera_off_24_filled.png",
    ["cameraswitch"] = "ic_fluent_camera_switch_24_filled.png",
    ["camera-switch"] = "ic_fluent_camera_switch_24_filled.png",
    ["camera_switch"] = "ic_fluent_camera_switch_24_filled.png",
    ["caret"] = "ic_fluent_caret_24_filled.png",
    ["caretdown"] = "ic_fluent_caret_down_24_filled.png",
    ["caret-down"] = "ic_fluent_caret_down_24_filled.png",
    ["caret_down"] = "ic_fluent_caret_down_24_filled.png",
    ["caretdownleft"] = "ic_fluent_caret_down_left_24_filled.png",
    ["caret-down-left"] = "ic_fluent_caret_down_left_24_filled.png",
    ["caret_down_left"] = "ic_fluent_caret_down_left_24_filled.png",
    ["caretleft"] = "ic_fluent_caret_left_24_filled.png",
    ["caret-left"] = "ic_fluent_caret_left_24_filled.png",
    ["caret_left"] = "ic_fluent_caret_left_24_filled.png",
    ["caretright"] = "ic_fluent_caret_right_24_filled.png",
    ["caret-right"] = "ic_fluent_caret_right_24_filled.png",
    ["caret_right"] = "ic_fluent_caret_right_24_filled.png",
    ["caretup"] = "ic_fluent_caret_up_24_filled.png",
    ["caret-up"] = "ic_fluent_caret_up_24_filled.png",
    ["caret_up"] = "ic_fluent_caret_up_24_filled.png",
    ["cart"] = "ic_fluent_cart_24_filled.png",
    ["cast"] = "ic_fluent_cast_24_filled.png",
    ["cellular3g"] = "ic_fluent_cellular_3g_24_filled.png",
    ["cellular4g"] = "ic_fluent_cellular_4g_24_filled.png",
    ["cellular5g"] = "ic_fluent_cellular_5g_24_filled.png",
    ["cellulardata1"] = "ic_fluent_cellular_data_1_24_filled.png",
    ["cellular-data1"] = "ic_fluent_cellular_data_1_24_filled.png",
    ["cellular_data1"] = "ic_fluent_cellular_data_1_24_filled.png",
    ["cellulardata2"] = "ic_fluent_cellular_data_2_24_filled.png",
    ["cellular-data2"] = "ic_fluent_cellular_data_2_24_filled.png",
    ["cellular_data2"] = "ic_fluent_cellular_data_2_24_filled.png",
    ["cellulardata3"] = "ic_fluent_cellular_data_3_24_filled.png",
    ["cellular-data3"] = "ic_fluent_cellular_data_3_24_filled.png",
    ["cellular_data3"] = "ic_fluent_cellular_data_3_24_filled.png",
    ["cellulardata4"] = "ic_fluent_cellular_data_4_24_filled.png",
    ["cellular-data4"] = "ic_fluent_cellular_data_4_24_filled.png",
    ["cellular_data4"] = "ic_fluent_cellular_data_4_24_filled.png",
    ["cellulardata5"] = "ic_fluent_cellular_data_5_24_filled.png",
    ["cellular-data5"] = "ic_fluent_cellular_data_5_24_filled.png",
    ["cellular_data5"] = "ic_fluent_cellular_data_5_24_filled.png",
    ["cellulardatacellularoff"] = "ic_fluent_cellular_data_cellular_off_24_filled.png",
    ["cellular-data-cellular-off"] = "ic_fluent_cellular_data_cellular_off_24_filled.png",
    ["cellular_data_cellular_off"] = "ic_fluent_cellular_data_cellular_off_24_filled.png",
    ["cellulardatacellularunavailable"] = "ic_fluent_cellular_data_cellular_unavailable_24_filled.png",
    ["cellular-data-cellular-unavailable"] = "ic_fluent_cellular_data_cellular_unavailable_24_filled.png",
    ["cellular_data_cellular_unavailable"] = "ic_fluent_cellular_data_cellular_unavailable_24_filled.png",
    ["cellulardataunavailable"] = "ic_fluent_cellular_data_unavailable_24_filled.png",
    ["cellular-data-unavailable"] = "ic_fluent_cellular_data_unavailable_24_filled.png",
    ["cellular_data_unavailable"] = "ic_fluent_cellular_data_unavailable_24_filled.png",
    ["cellularwarning"] = "ic_fluent_cellular_warning_24_filled.png",
    ["cellular-warning"] = "ic_fluent_cellular_warning_24_filled.png",
    ["cellular_warning"] = "ic_fluent_cellular_warning_24_filled.png",
    ["centerhorizontal"] = "ic_fluent_center_horizontal_24_filled.png",
    ["center-horizontal"] = "ic_fluent_center_horizontal_24_filled.png",
    ["center_horizontal"] = "ic_fluent_center_horizontal_24_filled.png",
    ["centervertical"] = "ic_fluent_center_vertical_24_filled.png",
    ["center-vertical"] = "ic_fluent_center_vertical_24_filled.png",
    ["center_vertical"] = "ic_fluent_center_vertical_24_filled.png",
    ["certificate"] = "ic_fluent_certificate_24_filled.png",
    ["channel"] = "ic_fluent_channel_24_filled.png",
    ["channeladd"] = "ic_fluent_channel_add_24_filled.png",
    ["channel-add"] = "ic_fluent_channel_add_24_filled.png",
    ["channel_add"] = "ic_fluent_channel_add_24_filled.png",
    ["channelalert"] = "ic_fluent_channel_alert_24_filled.png",
    ["channel-alert"] = "ic_fluent_channel_alert_24_filled.png",
    ["channel_alert"] = "ic_fluent_channel_alert_24_filled.png",
    ["channelarrowleft"] = "ic_fluent_channel_arrow_left_24_filled.png",
    ["channel-arrow-left"] = "ic_fluent_channel_arrow_left_24_filled.png",
    ["channel_arrow_left"] = "ic_fluent_channel_arrow_left_24_filled.png",
    ["channeldismiss"] = "ic_fluent_channel_dismiss_24_filled.png",
    ["channel-dismiss"] = "ic_fluent_channel_dismiss_24_filled.png",
    ["channel_dismiss"] = "ic_fluent_channel_dismiss_24_filled.png",
    ["channelshare"] = "ic_fluent_channel_share_24_filled.png",
    ["channel-share"] = "ic_fluent_channel_share_24_filled.png",
    ["channel_share"] = "ic_fluent_channel_share_24_filled.png",
    ["channelsubtract"] = "ic_fluent_channel_subtract_24_filled.png",
    ["channel-subtract"] = "ic_fluent_channel_subtract_24_filled.png",
    ["channel_subtract"] = "ic_fluent_channel_subtract_24_filled.png",
    ["chartperson"] = "ic_fluent_chart_person_24_filled.png",
    ["chart-person"] = "ic_fluent_chart_person_24_filled.png",
    ["chart_person"] = "ic_fluent_chart_person_24_filled.png",
    ["chat"] = "ic_fluent_chat_24_filled.png",
    ["chatbubblesquestion"] = "ic_fluent_chat_bubbles_question_24_filled.png",
    ["chat-bubbles-question"] = "ic_fluent_chat_bubbles_question_24_filled.png",
    ["chat_bubbles_question"] = "ic_fluent_chat_bubbles_question_24_filled.png",
    ["chathelp"] = "ic_fluent_chat_help_24_filled.png",
    ["chat-help"] = "ic_fluent_chat_help_24_filled.png",
    ["chat_help"] = "ic_fluent_chat_help_24_filled.png",
    ["chatmultiple"] = "ic_fluent_chat_multiple_24_filled.png",
    ["chat-multiple"] = "ic_fluent_chat_multiple_24_filled.png",
    ["chat_multiple"] = "ic_fluent_chat_multiple_24_filled.png",
    ["chatoff"] = "ic_fluent_chat_off_24_filled.png",
    ["chat-off"] = "ic_fluent_chat_off_24_filled.png",
    ["chat_off"] = "ic_fluent_chat_off_24_filled.png",
    ["chatsettings"] = "ic_fluent_chat_settings_24_filled.png",
    ["chat-settings"] = "ic_fluent_chat_settings_24_filled.png",
    ["chat_settings"] = "ic_fluent_chat_settings_24_filled.png",
    ["chatvideo"] = "ic_fluent_chat_video_24_filled.png",
    ["chat-video"] = "ic_fluent_chat_video_24_filled.png",
    ["chat_video"] = "ic_fluent_chat_video_24_filled.png",
    ["chatwarning"] = "ic_fluent_chat_warning_24_filled.png",
    ["chat-warning"] = "ic_fluent_chat_warning_24_filled.png",
    ["chat_warning"] = "ic_fluent_chat_warning_24_filled.png",
    ["check"] = "ic_fluent_check_24_filled.png",
    ["checkbox1"] = "ic_fluent_checkbox_1_24_filled.png",
    ["checkbox2"] = "ic_fluent_checkbox_2_24_filled.png",
    ["checkboxarrowright"] = "ic_fluent_checkbox_arrow_right_24_filled.png",
    ["checkbox-arrow-right"] = "ic_fluent_checkbox_arrow_right_24_filled.png",
    ["checkbox_arrow_right"] = "ic_fluent_checkbox_arrow_right_24_filled.png",
    ["checkboxchecked"] = "ic_fluent_checkbox_checked_24_filled.png",
    ["checkbox-checked"] = "ic_fluent_checkbox_checked_24_filled.png",
    ["checkbox_checked"] = "ic_fluent_checkbox_checked_24_filled.png",
    ["checkboxindeterminate"] = "ic_fluent_checkbox_indeterminate_24_filled.png",
    ["checkbox-indeterminate"] = "ic_fluent_checkbox_indeterminate_24_filled.png",
    ["checkbox_indeterminate"] = "ic_fluent_checkbox_indeterminate_24_filled.png",
    ["checkboxperson"] = "ic_fluent_checkbox_person_24_filled.png",
    ["checkbox-person"] = "ic_fluent_checkbox_person_24_filled.png",
    ["checkbox_person"] = "ic_fluent_checkbox_person_24_filled.png",
    ["checkboxunchecked"] = "ic_fluent_checkbox_unchecked_24_filled.png",
    ["checkbox-unchecked"] = "ic_fluent_checkbox_unchecked_24_filled.png",
    ["checkbox_unchecked"] = "ic_fluent_checkbox_unchecked_24_filled.png",
    ["checkboxwarning"] = "ic_fluent_checkbox_warning_24_filled.png",
    ["checkbox-warning"] = "ic_fluent_checkbox_warning_24_filled.png",
    ["checkbox_warning"] = "ic_fluent_checkbox_warning_24_filled.png",
    ["checkmark"] = "ic_fluent_checkmark_24_filled.png",
    ["checkmarkcircle"] = "ic_fluent_checkmark_circle_24_filled.png",
    ["checkmark-circle"] = "ic_fluent_checkmark_circle_24_filled.png",
    ["checkmark_circle"] = "ic_fluent_checkmark_circle_24_filled.png",
    ["checkmarklock"] = "ic_fluent_checkmark_lock_24_filled.png",
    ["checkmark-lock"] = "ic_fluent_checkmark_lock_24_filled.png",
    ["checkmark_lock"] = "ic_fluent_checkmark_lock_24_filled.png",
    ["checkmarksquare"] = "ic_fluent_checkmark_square_24_filled.png",
    ["checkmark-square"] = "ic_fluent_checkmark_square_24_filled.png",
    ["checkmark_square"] = "ic_fluent_checkmark_square_24_filled.png",
    ["chevroncircledown"] = "ic_fluent_chevron_circle_down_24_filled.png",
    ["chevron-circle-down"] = "ic_fluent_chevron_circle_down_24_filled.png",
    ["chevron_circle_down"] = "ic_fluent_chevron_circle_down_24_filled.png",
    ["chevroncircleright"] = "ic_fluent_chevron_circle_right_24_filled.png",
    ["chevron-circle-right"] = "ic_fluent_chevron_circle_right_24_filled.png",
    ["chevron_circle_right"] = "ic_fluent_chevron_circle_right_24_filled.png",
    ["chevrondown"] = "ic_fluent_chevron_down_24_filled.png",
    ["chevron-down"] = "ic_fluent_chevron_down_24_filled.png",
    ["chevron_down"] = "ic_fluent_chevron_down_24_filled.png",
    ["chevronleft"] = "ic_fluent_chevron_left_24_filled.png",
    ["chevron-left"] = "ic_fluent_chevron_left_24_filled.png",
    ["chevron_left"] = "ic_fluent_chevron_left_24_filled.png",
    ["chevronright"] = "ic_fluent_chevron_right_24_filled.png",
    ["chevron-right"] = "ic_fluent_chevron_right_24_filled.png",
    ["chevron_right"] = "ic_fluent_chevron_right_24_filled.png",
    ["chevronup"] = "ic_fluent_chevron_up_24_filled.png",
    ["chevron-up"] = "ic_fluent_chevron_up_24_filled.png",
    ["chevron_up"] = "ic_fluent_chevron_up_24_filled.png",
    ["chevronupdown"] = "ic_fluent_chevron_up_down_24_filled.png",
    ["chevron-up-down"] = "ic_fluent_chevron_up_down_24_filled.png",
    ["chevron_up_down"] = "ic_fluent_chevron_up_down_24_filled.png",
    ["circle"] = "ic_fluent_circle_24_filled.png",
    ["circleedit"] = "ic_fluent_circle_edit_24_filled.png",
    ["circle-edit"] = "ic_fluent_circle_edit_24_filled.png",
    ["circle_edit"] = "ic_fluent_circle_edit_24_filled.png",
    ["circlehalffill"] = "ic_fluent_circle_half_fill_24_filled.png",
    ["circle-half-fill"] = "ic_fluent_circle_half_fill_24_filled.png",
    ["circle_half_fill"] = "ic_fluent_circle_half_fill_24_filled.png",
    ["circleline"] = "ic_fluent_circle_line_24_filled.png",
    ["circle-line"] = "ic_fluent_circle_line_24_filled.png",
    ["circle_line"] = "ic_fluent_circle_line_24_filled.png",
    ["circlesmall"] = "ic_fluent_circle_small_24_filled.png",
    ["circle-small"] = "ic_fluent_circle_small_24_filled.png",
    ["circle_small"] = "ic_fluent_circle_small_24_filled.png",
    ["city"] = "ic_fluent_city_24_filled.png",
    ["class"] = "ic_fluent_class_24_filled.png",
    ["classification"] = "ic_fluent_classification_24_filled.png",
    ["clearformatting"] = "ic_fluent_clear_formatting_24_filled.png",
    ["clear-formatting"] = "ic_fluent_clear_formatting_24_filled.png",
    ["clear_formatting"] = "ic_fluent_clear_formatting_24_filled.png",
    ["clipboard"] = "ic_fluent_clipboard_24_filled.png",
    ["clipboardarrowright"] = "ic_fluent_clipboard_arrow_right_24_filled.png",
    ["clipboard-arrow-right"] = "ic_fluent_clipboard_arrow_right_24_filled.png",
    ["clipboard_arrow_right"] = "ic_fluent_clipboard_arrow_right_24_filled.png",
    ["clipboardcheckmark"] = "ic_fluent_clipboard_checkmark_24_filled.png",
    ["clipboard-checkmark"] = "ic_fluent_clipboard_checkmark_24_filled.png",
    ["clipboard_checkmark"] = "ic_fluent_clipboard_checkmark_24_filled.png",
    ["clipboardcode"] = "ic_fluent_clipboard_code_24_filled.png",
    ["clipboard-code"] = "ic_fluent_clipboard_code_24_filled.png",
    ["clipboard_code"] = "ic_fluent_clipboard_code_24_filled.png",
    ["clipboarderror"] = "ic_fluent_clipboard_error_24_filled.png",
    ["clipboard-error"] = "ic_fluent_clipboard_error_24_filled.png",
    ["clipboard_error"] = "ic_fluent_clipboard_error_24_filled.png",
    ["clipboardheart"] = "ic_fluent_clipboard_heart_24_filled.png",
    ["clipboard-heart"] = "ic_fluent_clipboard_heart_24_filled.png",
    ["clipboard_heart"] = "ic_fluent_clipboard_heart_24_filled.png",
    ["clipboardimage"] = "ic_fluent_clipboard_image_24_filled.png",
    ["clipboard-image"] = "ic_fluent_clipboard_image_24_filled.png",
    ["clipboard_image"] = "ic_fluent_clipboard_image_24_filled.png",
    ["clipboardletter"] = "ic_fluent_clipboard_letter_24_filled.png",
    ["clipboard-letter"] = "ic_fluent_clipboard_letter_24_filled.png",
    ["clipboard_letter"] = "ic_fluent_clipboard_letter_24_filled.png",
    ["clipboardlink"] = "ic_fluent_clipboard_link_24_filled.png",
    ["clipboard-link"] = "ic_fluent_clipboard_link_24_filled.png",
    ["clipboard_link"] = "ic_fluent_clipboard_link_24_filled.png",
    ["clipboardmore"] = "ic_fluent_clipboard_more_24_filled.png",
    ["clipboard-more"] = "ic_fluent_clipboard_more_24_filled.png",
    ["clipboard_more"] = "ic_fluent_clipboard_more_24_filled.png",
    ["clipboardpaste"] = "ic_fluent_clipboard_paste_24_filled.png",
    ["clipboard-paste"] = "ic_fluent_clipboard_paste_24_filled.png",
    ["clipboard_paste"] = "ic_fluent_clipboard_paste_24_filled.png",
    ["clipboardpulse"] = "ic_fluent_clipboard_pulse_24_filled.png",
    ["clipboard-pulse"] = "ic_fluent_clipboard_pulse_24_filled.png",
    ["clipboard_pulse"] = "ic_fluent_clipboard_pulse_24_filled.png",
    ["clipboardsearch"] = "ic_fluent_clipboard_search_24_filled.png",
    ["clipboard-search"] = "ic_fluent_clipboard_search_24_filled.png",
    ["clipboard_search"] = "ic_fluent_clipboard_search_24_filled.png",
    ["clipboardsettings"] = "ic_fluent_clipboard_settings_24_filled.png",
    ["clipboard-settings"] = "ic_fluent_clipboard_settings_24_filled.png",
    ["clipboard_settings"] = "ic_fluent_clipboard_settings_24_filled.png",
    ["clipboardtask"] = "ic_fluent_clipboard_task_24_filled.png",
    ["clipboard-task"] = "ic_fluent_clipboard_task_24_filled.png",
    ["clipboard_task"] = "ic_fluent_clipboard_task_24_filled.png",
    ["clipboardtaskadd"] = "ic_fluent_clipboard_task_add_24_filled.png",
    ["clipboard-task-add"] = "ic_fluent_clipboard_task_add_24_filled.png",
    ["clipboard_task_add"] = "ic_fluent_clipboard_task_add_24_filled.png",
    ["clipboardtasklistltr"] = "ic_fluent_clipboard_task_list_ltr_24_filled.png",
    ["clipboard-task-list-ltr"] = "ic_fluent_clipboard_task_list_ltr_24_filled.png",
    ["clipboard_task_list_ltr"] = "ic_fluent_clipboard_task_list_ltr_24_filled.png",
    ["clipboardtasklistrtl"] = "ic_fluent_clipboard_task_list_rtl_24_filled.png",
    ["clipboard-task-list-rtl"] = "ic_fluent_clipboard_task_list_rtl_24_filled.png",
    ["clipboard_task_list_rtl"] = "ic_fluent_clipboard_task_list_rtl_24_filled.png",
    ["clipboardtextltr"] = "ic_fluent_clipboard_text_ltr_24_filled.png",
    ["clipboard-text-ltr"] = "ic_fluent_clipboard_text_ltr_24_filled.png",
    ["clipboard_text_ltr"] = "ic_fluent_clipboard_text_ltr_24_filled.png",
    ["clipboardtextrtl"] = "ic_fluent_clipboard_text_rtl_24_filled.png",
    ["clipboard-text-rtl"] = "ic_fluent_clipboard_text_rtl_24_filled.png",
    ["clipboard_text_rtl"] = "ic_fluent_clipboard_text_rtl_24_filled.png",
    ["clock"] = "ic_fluent_clock_24_filled.png",
    ["clockalarm"] = "ic_fluent_clock_alarm_24_filled.png",
    ["clock-alarm"] = "ic_fluent_clock_alarm_24_filled.png",
    ["clock_alarm"] = "ic_fluent_clock_alarm_24_filled.png",
    ["clockarrowdownload"] = "ic_fluent_clock_arrow_download_24_filled.png",
    ["clock-arrow-download"] = "ic_fluent_clock_arrow_download_24_filled.png",
    ["clock_arrow_download"] = "ic_fluent_clock_arrow_download_24_filled.png",
    ["clockdismiss"] = "ic_fluent_clock_dismiss_24_filled.png",
    ["clock-dismiss"] = "ic_fluent_clock_dismiss_24_filled.png",
    ["clock_dismiss"] = "ic_fluent_clock_dismiss_24_filled.png",
    ["closedcaption"] = "ic_fluent_closed_caption_24_filled.png",
    ["closed-caption"] = "ic_fluent_closed_caption_24_filled.png",
    ["closed_caption"] = "ic_fluent_closed_caption_24_filled.png",
    ["closedcaptionoff"] = "ic_fluent_closed_caption_off_24_filled.png",
    ["closed-caption-off"] = "ic_fluent_closed_caption_off_24_filled.png",
    ["closed_caption_off"] = "ic_fluent_closed_caption_off_24_filled.png",
    ["cloud"] = "ic_fluent_cloud_24_filled.png",
    ["cloudarrowdown"] = "ic_fluent_cloud_arrow_down_24_filled.png",
    ["cloud-arrow-down"] = "ic_fluent_cloud_arrow_down_24_filled.png",
    ["cloud_arrow_down"] = "ic_fluent_cloud_arrow_down_24_filled.png",
    ["cloudarrowup"] = "ic_fluent_cloud_arrow_up_24_filled.png",
    ["cloud-arrow-up"] = "ic_fluent_cloud_arrow_up_24_filled.png",
    ["cloud_arrow_up"] = "ic_fluent_cloud_arrow_up_24_filled.png",
    ["cloudbackup"] = "ic_fluent_cloud_backup_24_filled.png",
    ["cloud-backup"] = "ic_fluent_cloud_backup_24_filled.png",
    ["cloud_backup"] = "ic_fluent_cloud_backup_24_filled.png",
    ["cloudcheckmark"] = "ic_fluent_cloud_checkmark_24_filled.png",
    ["cloud-checkmark"] = "ic_fluent_cloud_checkmark_24_filled.png",
    ["cloud_checkmark"] = "ic_fluent_cloud_checkmark_24_filled.png",
    ["clouddismiss"] = "ic_fluent_cloud_dismiss_24_filled.png",
    ["cloud-dismiss"] = "ic_fluent_cloud_dismiss_24_filled.png",
    ["cloud_dismiss"] = "ic_fluent_cloud_dismiss_24_filled.png",
    ["clouddownload"] = "ic_fluent_cloud_download_24_filled.png",
    ["cloud-download"] = "ic_fluent_cloud_download_24_filled.png",
    ["cloud_download"] = "ic_fluent_cloud_download_24_filled.png",
    ["cloudflow"] = "ic_fluent_cloud_flow_24_filled.png",
    ["cloud-flow"] = "ic_fluent_cloud_flow_24_filled.png",
    ["cloud_flow"] = "ic_fluent_cloud_flow_24_filled.png",
    ["cloudoff"] = "ic_fluent_cloud_off_24_filled.png",
    ["cloud-off"] = "ic_fluent_cloud_off_24_filled.png",
    ["cloud_off"] = "ic_fluent_cloud_off_24_filled.png",
    ["cloudoffline"] = "ic_fluent_cloud_offline_24_filled.png",
    ["cloud-offline"] = "ic_fluent_cloud_offline_24_filled.png",
    ["cloud_offline"] = "ic_fluent_cloud_offline_24_filled.png",
    ["cloudswap"] = "ic_fluent_cloud_swap_24_filled.png",
    ["cloud-swap"] = "ic_fluent_cloud_swap_24_filled.png",
    ["cloud_swap"] = "ic_fluent_cloud_swap_24_filled.png",
    ["cloudsync"] = "ic_fluent_cloud_sync_24_filled.png",
    ["cloud-sync"] = "ic_fluent_cloud_sync_24_filled.png",
    ["cloud_sync"] = "ic_fluent_cloud_sync_24_filled.png",
    ["cloudsynccomplete"] = "ic_fluent_cloud_sync_complete_24_filled.png",
    ["cloud-sync-complete"] = "ic_fluent_cloud_sync_complete_24_filled.png",
    ["cloud_sync_complete"] = "ic_fluent_cloud_sync_complete_24_filled.png",
    ["cloudwords"] = "ic_fluent_cloud_words_24_filled.png",
    ["cloud-words"] = "ic_fluent_cloud_words_24_filled.png",
    ["cloud_words"] = "ic_fluent_cloud_words_24_filled.png",
    ["code"] = "ic_fluent_code_24_filled.png",
    ["collections"] = "ic_fluent_collections_24_filled.png",
    ["collectionsadd"] = "ic_fluent_collections_add_24_filled.png",
    ["collections-add"] = "ic_fluent_collections_add_24_filled.png",
    ["collections_add"] = "ic_fluent_collections_add_24_filled.png",
    ["color"] = "ic_fluent_color_24_filled.png",
    ["colorbackground"] = "ic_fluent_color_background_24_filled.png",
    ["color-background"] = "ic_fluent_color_background_24_filled.png",
    ["color_background"] = "ic_fluent_color_background_24_filled.png",
    ["colorfill"] = "ic_fluent_color_fill_24_filled.png",
    ["color-fill"] = "ic_fluent_color_fill_24_filled.png",
    ["color_fill"] = "ic_fluent_color_fill_24_filled.png",
    ["colorline"] = "ic_fluent_color_line_24_filled.png",
    ["color-line"] = "ic_fluent_color_line_24_filled.png",
    ["color_line"] = "ic_fluent_color_line_24_filled.png",
    ["columnedit"] = "ic_fluent_column_edit_24_filled.png",
    ["column-edit"] = "ic_fluent_column_edit_24_filled.png",
    ["column_edit"] = "ic_fluent_column_edit_24_filled.png",
    ["columntriple"] = "ic_fluent_column_triple_24_filled.png",
    ["column-triple"] = "ic_fluent_column_triple_24_filled.png",
    ["column_triple"] = "ic_fluent_column_triple_24_filled.png",
    ["columntripleedit"] = "ic_fluent_column_triple_edit_24_filled.png",
    ["column-triple-edit"] = "ic_fluent_column_triple_edit_24_filled.png",
    ["column_triple_edit"] = "ic_fluent_column_triple_edit_24_filled.png",
    ["comma"] = "ic_fluent_comma_24_filled.png",
    ["comment"] = "ic_fluent_comment_24_filled.png",
    ["commentadd"] = "ic_fluent_comment_add_24_filled.png",
    ["comment-add"] = "ic_fluent_comment_add_24_filled.png",
    ["comment_add"] = "ic_fluent_comment_add_24_filled.png",
    ["commentarrowleft"] = "ic_fluent_comment_arrow_left_24_filled.png",
    ["comment-arrow-left"] = "ic_fluent_comment_arrow_left_24_filled.png",
    ["comment_arrow_left"] = "ic_fluent_comment_arrow_left_24_filled.png",
    ["commentarrowright"] = "ic_fluent_comment_arrow_right_24_filled.png",
    ["comment-arrow-right"] = "ic_fluent_comment_arrow_right_24_filled.png",
    ["comment_arrow_right"] = "ic_fluent_comment_arrow_right_24_filled.png",
    ["commentcheckmark"] = "ic_fluent_comment_checkmark_24_filled.png",
    ["comment-checkmark"] = "ic_fluent_comment_checkmark_24_filled.png",
    ["comment_checkmark"] = "ic_fluent_comment_checkmark_24_filled.png",
    ["commentdismiss"] = "ic_fluent_comment_dismiss_24_filled.png",
    ["comment-dismiss"] = "ic_fluent_comment_dismiss_24_filled.png",
    ["comment_dismiss"] = "ic_fluent_comment_dismiss_24_filled.png",
    ["commentedit"] = "ic_fluent_comment_edit_24_filled.png",
    ["comment-edit"] = "ic_fluent_comment_edit_24_filled.png",
    ["comment_edit"] = "ic_fluent_comment_edit_24_filled.png",
    ["commentlightning"] = "ic_fluent_comment_lightning_24_filled.png",
    ["comment-lightning"] = "ic_fluent_comment_lightning_24_filled.png",
    ["comment_lightning"] = "ic_fluent_comment_lightning_24_filled.png",
    ["commentmention"] = "ic_fluent_comment_mention_24_filled.png",
    ["comment-mention"] = "ic_fluent_comment_mention_24_filled.png",
    ["comment_mention"] = "ic_fluent_comment_mention_24_filled.png",
    ["commentmultiple"] = "ic_fluent_comment_multiple_24_filled.png",
    ["comment-multiple"] = "ic_fluent_comment_multiple_24_filled.png",
    ["comment_multiple"] = "ic_fluent_comment_multiple_24_filled.png",
    ["commentmultiplecheckmark"] = "ic_fluent_comment_multiple_checkmark_24_filled.png",
    ["comment-multiple-checkmark"] = "ic_fluent_comment_multiple_checkmark_24_filled.png",
    ["comment_multiple_checkmark"] = "ic_fluent_comment_multiple_checkmark_24_filled.png",
    ["commentnote"] = "ic_fluent_comment_note_24_filled.png",
    ["comment-note"] = "ic_fluent_comment_note_24_filled.png",
    ["comment_note"] = "ic_fluent_comment_note_24_filled.png",
    ["commentoff"] = "ic_fluent_comment_off_24_filled.png",
    ["comment-off"] = "ic_fluent_comment_off_24_filled.png",
    ["comment_off"] = "ic_fluent_comment_off_24_filled.png",
    ["communication"] = "ic_fluent_communication_24_filled.png",
    ["communicationperson"] = "ic_fluent_communication_person_24_filled.png",
    ["communication-person"] = "ic_fluent_communication_person_24_filled.png",
    ["communication_person"] = "ic_fluent_communication_person_24_filled.png",
    ["compassnorthwest"] = "ic_fluent_compass_northwest_24_filled.png",
    ["compass-northwest"] = "ic_fluent_compass_northwest_24_filled.png",
    ["compass_northwest"] = "ic_fluent_compass_northwest_24_filled.png",
    ["component2doubletapswipedown"] = "ic_fluent_component_2_double_tap_swipe_down_24_filled.png",
    ["component2-double-tap-swipe-down"] = "ic_fluent_component_2_double_tap_swipe_down_24_filled.png",
    ["component2_double_tap_swipe_down"] = "ic_fluent_component_2_double_tap_swipe_down_24_filled.png",
    ["component2doubletapswipeup"] = "ic_fluent_component_2_double_tap_swipe_up_24_filled.png",
    ["component2-double-tap-swipe-up"] = "ic_fluent_component_2_double_tap_swipe_up_24_filled.png",
    ["component2_double_tap_swipe_up"] = "ic_fluent_component_2_double_tap_swipe_up_24_filled.png",
    ["compose"] = "ic_fluent_compose_24_filled.png",
    ["conferenceroom"] = "ic_fluent_conference_room_24_filled.png",
    ["conference-room"] = "ic_fluent_conference_room_24_filled.png",
    ["conference_room"] = "ic_fluent_conference_room_24_filled.png",
    ["connector"] = "ic_fluent_connector_24_filled.png",
    ["contactcard"] = "ic_fluent_contact_card_24_filled.png",
    ["contact-card"] = "ic_fluent_contact_card_24_filled.png",
    ["contact_card"] = "ic_fluent_contact_card_24_filled.png",
    ["contactcardgroup"] = "ic_fluent_contact_card_group_24_filled.png",
    ["contact-card-group"] = "ic_fluent_contact_card_group_24_filled.png",
    ["contact_card_group"] = "ic_fluent_contact_card_group_24_filled.png",
    ["contentsettings"] = "ic_fluent_content_settings_24_filled.png",
    ["content-settings"] = "ic_fluent_content_settings_24_filled.png",
    ["content_settings"] = "ic_fluent_content_settings_24_filled.png",
    ["contractdownleft"] = "ic_fluent_contract_down_left_24_filled.png",
    ["contract-down-left"] = "ic_fluent_contract_down_left_24_filled.png",
    ["contract_down_left"] = "ic_fluent_contract_down_left_24_filled.png",
    ["controlbutton"] = "ic_fluent_control_button_24_filled.png",
    ["control-button"] = "ic_fluent_control_button_24_filled.png",
    ["control_button"] = "ic_fluent_control_button_24_filled.png",
    ["convertrange"] = "ic_fluent_convert_range_24_filled.png",
    ["convert-range"] = "ic_fluent_convert_range_24_filled.png",
    ["convert_range"] = "ic_fluent_convert_range_24_filled.png",
    ["converttotable"] = "ic_fluent_convert_to_table_24_filled.png",
    ["convert-to-table"] = "ic_fluent_convert_to_table_24_filled.png",
    ["convert_to_table"] = "ic_fluent_convert_to_table_24_filled.png",
    ["converttotext"] = "ic_fluent_convert_to_text_24_filled.png",
    ["convert-to-text"] = "ic_fluent_convert_to_text_24_filled.png",
    ["convert_to_text"] = "ic_fluent_convert_to_text_24_filled.png",
    ["converttotype"] = "ic_fluent_convert_to_type_24_filled.png",
    ["convert-to-type"] = "ic_fluent_convert_to_type_24_filled.png",
    ["convert_to_type"] = "ic_fluent_convert_to_type_24_filled.png",
    ["cookies"] = "ic_fluent_cookies_24_filled.png",
    ["copy"] = "ic_fluent_copy_24_filled.png",
    ["copyadd"] = "ic_fluent_copy_add_24_filled.png",
    ["copy-add"] = "ic_fluent_copy_add_24_filled.png",
    ["copy_add"] = "ic_fluent_copy_add_24_filled.png",
    ["copyarrowright"] = "ic_fluent_copy_arrow_right_24_filled.png",
    ["copy-arrow-right"] = "ic_fluent_copy_arrow_right_24_filled.png",
    ["copy_arrow_right"] = "ic_fluent_copy_arrow_right_24_filled.png",
    ["couch"] = "ic_fluent_couch_24_filled.png",
    ["creditcardperson"] = "ic_fluent_credit_card_person_24_filled.png",
    ["credit-card-person"] = "ic_fluent_credit_card_person_24_filled.png",
    ["credit_card_person"] = "ic_fluent_credit_card_person_24_filled.png",
    ["creditcardtoolbox"] = "ic_fluent_credit_card_toolbox_24_filled.png",
    ["credit-card-toolbox"] = "ic_fluent_credit_card_toolbox_24_filled.png",
    ["credit_card_toolbox"] = "ic_fluent_credit_card_toolbox_24_filled.png",
    ["crop"] = "ic_fluent_crop_24_filled.png",
    ["cropinterim"] = "ic_fluent_crop_interim_24_filled.png",
    ["crop-interim"] = "ic_fluent_crop_interim_24_filled.png",
    ["crop_interim"] = "ic_fluent_crop_interim_24_filled.png",
    ["cropinterimoff"] = "ic_fluent_crop_interim_off_24_filled.png",
    ["crop-interim-off"] = "ic_fluent_crop_interim_off_24_filled.png",
    ["crop_interim_off"] = "ic_fluent_crop_interim_off_24_filled.png",
    ["cube"] = "ic_fluent_cube_24_filled.png",
    ["cubesync"] = "ic_fluent_cube_sync_24_filled.png",
    ["cube-sync"] = "ic_fluent_cube_sync_24_filled.png",
    ["cube_sync"] = "ic_fluent_cube_sync_24_filled.png",
    ["currencydollareuro"] = "ic_fluent_currency_dollar_euro_24_filled.png",
    ["currency-dollar-euro"] = "ic_fluent_currency_dollar_euro_24_filled.png",
    ["currency_dollar_euro"] = "ic_fluent_currency_dollar_euro_24_filled.png",
    ["currencydollarrupee"] = "ic_fluent_currency_dollar_rupee_24_filled.png",
    ["currency-dollar-rupee"] = "ic_fluent_currency_dollar_rupee_24_filled.png",
    ["currency_dollar_rupee"] = "ic_fluent_currency_dollar_rupee_24_filled.png",
    ["cursor"] = "ic_fluent_cursor_24_filled.png",
    ["cursorclick"] = "ic_fluent_cursor_click_24_filled.png",
    ["cursor-click"] = "ic_fluent_cursor_click_24_filled.png",
    ["cursor_click"] = "ic_fluent_cursor_click_24_filled.png",
    ["cursorhover"] = "ic_fluent_cursor_hover_24_filled.png",
    ["cursor-hover"] = "ic_fluent_cursor_hover_24_filled.png",
    ["cursor_hover"] = "ic_fluent_cursor_hover_24_filled.png",
    ["cursorhoveroff"] = "ic_fluent_cursor_hover_off_24_filled.png",
    ["cursor-hover-off"] = "ic_fluent_cursor_hover_off_24_filled.png",
    ["cursor_hover_off"] = "ic_fluent_cursor_hover_off_24_filled.png",
    ["cut"] = "ic_fluent_cut_24_filled.png",
    ["darktheme"] = "ic_fluent_dark_theme_24_filled.png",
    ["dark-theme"] = "ic_fluent_dark_theme_24_filled.png",
    ["dark_theme"] = "ic_fluent_dark_theme_24_filled.png",
    ["dataarea"] = "ic_fluent_data_area_24_filled.png",
    ["data-area"] = "ic_fluent_data_area_24_filled.png",
    ["data_area"] = "ic_fluent_data_area_24_filled.png",
    ["databarhorizontal"] = "ic_fluent_data_bar_horizontal_24_filled.png",
    ["data-bar-horizontal"] = "ic_fluent_data_bar_horizontal_24_filled.png",
    ["data_bar_horizontal"] = "ic_fluent_data_bar_horizontal_24_filled.png",
    ["databarvertical"] = "ic_fluent_data_bar_vertical_24_filled.png",
    ["data-bar-vertical"] = "ic_fluent_data_bar_vertical_24_filled.png",
    ["data_bar_vertical"] = "ic_fluent_data_bar_vertical_24_filled.png",
    ["databarverticaladd"] = "ic_fluent_data_bar_vertical_add_24_filled.png",
    ["data-bar-vertical-add"] = "ic_fluent_data_bar_vertical_add_24_filled.png",
    ["data_bar_vertical_add"] = "ic_fluent_data_bar_vertical_add_24_filled.png",
    ["datafunnel"] = "ic_fluent_data_funnel_24_filled.png",
    ["data-funnel"] = "ic_fluent_data_funnel_24_filled.png",
    ["data_funnel"] = "ic_fluent_data_funnel_24_filled.png",
    ["datahistogram"] = "ic_fluent_data_histogram_24_filled.png",
    ["data-histogram"] = "ic_fluent_data_histogram_24_filled.png",
    ["data_histogram"] = "ic_fluent_data_histogram_24_filled.png",
    ["dataline"] = "ic_fluent_data_line_24_filled.png",
    ["data-line"] = "ic_fluent_data_line_24_filled.png",
    ["data_line"] = "ic_fluent_data_line_24_filled.png",
    ["datapie"] = "ic_fluent_data_pie_24_filled.png",
    ["data-pie"] = "ic_fluent_data_pie_24_filled.png",
    ["data_pie"] = "ic_fluent_data_pie_24_filled.png",
    ["datascatter"] = "ic_fluent_data_scatter_24_filled.png",
    ["data-scatter"] = "ic_fluent_data_scatter_24_filled.png",
    ["data_scatter"] = "ic_fluent_data_scatter_24_filled.png",
    ["datasunburst"] = "ic_fluent_data_sunburst_24_filled.png",
    ["data-sunburst"] = "ic_fluent_data_sunburst_24_filled.png",
    ["data_sunburst"] = "ic_fluent_data_sunburst_24_filled.png",
    ["datatreemap"] = "ic_fluent_data_treemap_24_filled.png",
    ["data-treemap"] = "ic_fluent_data_treemap_24_filled.png",
    ["data_treemap"] = "ic_fluent_data_treemap_24_filled.png",
    ["datatrending"] = "ic_fluent_data_trending_24_filled.png",
    ["data-trending"] = "ic_fluent_data_trending_24_filled.png",
    ["data_trending"] = "ic_fluent_data_trending_24_filled.png",
    ["datausage"] = "ic_fluent_data_usage_24_filled.png",
    ["data-usage"] = "ic_fluent_data_usage_24_filled.png",
    ["data_usage"] = "ic_fluent_data_usage_24_filled.png",
    ["datausageedit"] = "ic_fluent_data_usage_edit_24_filled.png",
    ["data-usage-edit"] = "ic_fluent_data_usage_edit_24_filled.png",
    ["data_usage_edit"] = "ic_fluent_data_usage_edit_24_filled.png",
    ["datawaterfall"] = "ic_fluent_data_waterfall_24_filled.png",
    ["data-waterfall"] = "ic_fluent_data_waterfall_24_filled.png",
    ["data_waterfall"] = "ic_fluent_data_waterfall_24_filled.png",
    ["datawhisker"] = "ic_fluent_data_whisker_24_filled.png",
    ["data-whisker"] = "ic_fluent_data_whisker_24_filled.png",
    ["data_whisker"] = "ic_fluent_data_whisker_24_filled.png",
    ["database"] = "ic_fluent_database_24_filled.png",
    ["databaselink"] = "ic_fluent_database_link_24_filled.png",
    ["database-link"] = "ic_fluent_database_link_24_filled.png",
    ["database_link"] = "ic_fluent_database_link_24_filled.png",
    ["databasesearch"] = "ic_fluent_database_search_24_filled.png",
    ["database-search"] = "ic_fluent_database_search_24_filled.png",
    ["database_search"] = "ic_fluent_database_search_24_filled.png",
    ["decimalarrowleft"] = "ic_fluent_decimal_arrow_left_24_filled.png",
    ["decimal-arrow-left"] = "ic_fluent_decimal_arrow_left_24_filled.png",
    ["decimal_arrow_left"] = "ic_fluent_decimal_arrow_left_24_filled.png",
    ["decimalarrowright"] = "ic_fluent_decimal_arrow_right_24_filled.png",
    ["decimal-arrow-right"] = "ic_fluent_decimal_arrow_right_24_filled.png",
    ["decimal_arrow_right"] = "ic_fluent_decimal_arrow_right_24_filled.png",
    ["delete"] = "ic_fluent_delete_24_filled.png",
    ["deletedismiss"] = "ic_fluent_delete_dismiss_24_filled.png",
    ["delete-dismiss"] = "ic_fluent_delete_dismiss_24_filled.png",
    ["delete_dismiss"] = "ic_fluent_delete_dismiss_24_filled.png",
    ["deleteoff"] = "ic_fluent_delete_off_24_filled.png",
    ["delete-off"] = "ic_fluent_delete_off_24_filled.png",
    ["delete_off"] = "ic_fluent_delete_off_24_filled.png",
    ["dentist"] = "ic_fluent_dentist_24_filled.png",
    ["designideas"] = "ic_fluent_design_ideas_24_filled.png",
    ["design-ideas"] = "ic_fluent_design_ideas_24_filled.png",
    ["design_ideas"] = "ic_fluent_design_ideas_24_filled.png",
    ["desktop"] = "ic_fluent_desktop_24_filled.png",
    ["desktoparrowright"] = "ic_fluent_desktop_arrow_right_24_filled.png",
    ["desktop-arrow-right"] = "ic_fluent_desktop_arrow_right_24_filled.png",
    ["desktop_arrow_right"] = "ic_fluent_desktop_arrow_right_24_filled.png",
    ["desktopkeyboard"] = "ic_fluent_desktop_keyboard_24_filled.png",
    ["desktop-keyboard"] = "ic_fluent_desktop_keyboard_24_filled.png",
    ["desktop_keyboard"] = "ic_fluent_desktop_keyboard_24_filled.png",
    ["desktoppulse"] = "ic_fluent_desktop_pulse_24_filled.png",
    ["desktop-pulse"] = "ic_fluent_desktop_pulse_24_filled.png",
    ["desktop_pulse"] = "ic_fluent_desktop_pulse_24_filled.png",
    ["desktopspeaker"] = "ic_fluent_desktop_speaker_24_filled.png",
    ["desktop-speaker"] = "ic_fluent_desktop_speaker_24_filled.png",
    ["desktop_speaker"] = "ic_fluent_desktop_speaker_24_filled.png",
    ["desktopspeakeroff"] = "ic_fluent_desktop_speaker_off_24_filled.png",
    ["desktop-speaker-off"] = "ic_fluent_desktop_speaker_off_24_filled.png",
    ["desktop_speaker_off"] = "ic_fluent_desktop_speaker_off_24_filled.png",
    ["developerboard"] = "ic_fluent_developer_board_24_filled.png",
    ["developer-board"] = "ic_fluent_developer_board_24_filled.png",
    ["developer_board"] = "ic_fluent_developer_board_24_filled.png",
    ["deviceeq"] = "ic_fluent_device_eq_24_filled.png",
    ["device-eq"] = "ic_fluent_device_eq_24_filled.png",
    ["device_eq"] = "ic_fluent_device_eq_24_filled.png",
    ["devicemeetingroom"] = "ic_fluent_device_meeting_room_24_filled.png",
    ["device-meeting-room"] = "ic_fluent_device_meeting_room_24_filled.png",
    ["device_meeting_room"] = "ic_fluent_device_meeting_room_24_filled.png",
    ["devicemeetingroomremote"] = "ic_fluent_device_meeting_room_remote_24_filled.png",
    ["device-meeting-room-remote"] = "ic_fluent_device_meeting_room_remote_24_filled.png",
    ["device_meeting_room_remote"] = "ic_fluent_device_meeting_room_remote_24_filled.png",
    ["diagram"] = "ic_fluent_diagram_24_filled.png",
    ["dialpad"] = "ic_fluent_dialpad_24_filled.png",
    ["dialpadoff"] = "ic_fluent_dialpad_off_24_filled.png",
    ["dialpad-off"] = "ic_fluent_dialpad_off_24_filled.png",
    ["dialpad_off"] = "ic_fluent_dialpad_off_24_filled.png",
    ["directions"] = "ic_fluent_directions_24_filled.png",
    ["dismiss"] = "ic_fluent_dismiss_24_filled.png",
    ["dismisscircle"] = "ic_fluent_dismiss_circle_24_filled.png",
    ["dismiss-circle"] = "ic_fluent_dismiss_circle_24_filled.png",
    ["dismiss_circle"] = "ic_fluent_dismiss_circle_24_filled.png",
    ["dismisssquare"] = "ic_fluent_dismiss_square_24_filled.png",
    ["dismiss-square"] = "ic_fluent_dismiss_square_24_filled.png",
    ["dismiss_square"] = "ic_fluent_dismiss_square_24_filled.png",
    ["diversity"] = "ic_fluent_diversity_24_filled.png",
    ["dividershort"] = "ic_fluent_divider_short_24_filled.png",
    ["divider-short"] = "ic_fluent_divider_short_24_filled.png",
    ["divider_short"] = "ic_fluent_divider_short_24_filled.png",
    ["dividertall"] = "ic_fluent_divider_tall_24_filled.png",
    ["divider-tall"] = "ic_fluent_divider_tall_24_filled.png",
    ["divider_tall"] = "ic_fluent_divider_tall_24_filled.png",
    ["dock"] = "ic_fluent_dock_24_filled.png",
    ["dockpanelleft"] = "ic_fluent_dock_panel_left_24_filled.png",
    ["dock-panel-left"] = "ic_fluent_dock_panel_left_24_filled.png",
    ["dock_panel_left"] = "ic_fluent_dock_panel_left_24_filled.png",
    ["dockpanelright"] = "ic_fluent_dock_panel_right_24_filled.png",
    ["dock-panel-right"] = "ic_fluent_dock_panel_right_24_filled.png",
    ["dock_panel_right"] = "ic_fluent_dock_panel_right_24_filled.png",
    ["dockrow"] = "ic_fluent_dock_row_24_filled.png",
    ["dock-row"] = "ic_fluent_dock_row_24_filled.png",
    ["dock_row"] = "ic_fluent_dock_row_24_filled.png",
    ["doctor"] = "ic_fluent_doctor_24_filled.png",
    ["document"] = "ic_fluent_document_24_filled.png",
    ["documentadd"] = "ic_fluent_document_add_24_filled.png",
    ["document-add"] = "ic_fluent_document_add_24_filled.png",
    ["document_add"] = "ic_fluent_document_add_24_filled.png",
    ["documentarrowleft"] = "ic_fluent_document_arrow_left_24_filled.png",
    ["document-arrow-left"] = "ic_fluent_document_arrow_left_24_filled.png",
    ["document_arrow_left"] = "ic_fluent_document_arrow_left_24_filled.png",
    ["documentarrowright"] = "ic_fluent_document_arrow_right_24_filled.png",
    ["document-arrow-right"] = "ic_fluent_document_arrow_right_24_filled.png",
    ["document_arrow_right"] = "ic_fluent_document_arrow_right_24_filled.png",
    ["documentbriefcase"] = "ic_fluent_document_briefcase_24_filled.png",
    ["document-briefcase"] = "ic_fluent_document_briefcase_24_filled.png",
    ["document_briefcase"] = "ic_fluent_document_briefcase_24_filled.png",
    ["documentbulletlist"] = "ic_fluent_document_bullet_list_24_filled.png",
    ["document-bullet-list"] = "ic_fluent_document_bullet_list_24_filled.png",
    ["document_bullet_list"] = "ic_fluent_document_bullet_list_24_filled.png",
    ["documentbulletlistclock"] = "ic_fluent_document_bullet_list_clock_24_filled.png",
    ["document-bullet-list-clock"] = "ic_fluent_document_bullet_list_clock_24_filled.png",
    ["document_bullet_list_clock"] = "ic_fluent_document_bullet_list_clock_24_filled.png",
    ["documentbulletlistoff"] = "ic_fluent_document_bullet_list_off_24_filled.png",
    ["document-bullet-list-off"] = "ic_fluent_document_bullet_list_off_24_filled.png",
    ["document_bullet_list_off"] = "ic_fluent_document_bullet_list_off_24_filled.png",
    ["documentcatchup"] = "ic_fluent_document_catch_up_24_filled.png",
    ["document-catch-up"] = "ic_fluent_document_catch_up_24_filled.png",
    ["document_catch_up"] = "ic_fluent_document_catch_up_24_filled.png",
    ["documentcheckmark"] = "ic_fluent_document_checkmark_24_filled.png",
    ["document-checkmark"] = "ic_fluent_document_checkmark_24_filled.png",
    ["document_checkmark"] = "ic_fluent_document_checkmark_24_filled.png",
    ["documentchevrondouble"] = "ic_fluent_document_chevron_double_24_filled.png",
    ["document-chevron-double"] = "ic_fluent_document_chevron_double_24_filled.png",
    ["document_chevron_double"] = "ic_fluent_document_chevron_double_24_filled.png",
    ["documentcopy"] = "ic_fluent_document_copy_24_filled.png",
    ["document-copy"] = "ic_fluent_document_copy_24_filled.png",
    ["document_copy"] = "ic_fluent_document_copy_24_filled.png",
    ["documentcss"] = "ic_fluent_document_css_24_filled.png",
    ["document-css"] = "ic_fluent_document_css_24_filled.png",
    ["document_css"] = "ic_fluent_document_css_24_filled.png",
    ["documentdismiss"] = "ic_fluent_document_dismiss_24_filled.png",
    ["document-dismiss"] = "ic_fluent_document_dismiss_24_filled.png",
    ["document_dismiss"] = "ic_fluent_document_dismiss_24_filled.png",
    ["documentedit"] = "ic_fluent_document_edit_24_filled.png",
    ["document-edit"] = "ic_fluent_document_edit_24_filled.png",
    ["document_edit"] = "ic_fluent_document_edit_24_filled.png",
    ["documentendnote"] = "ic_fluent_document_endnote_24_filled.png",
    ["document-endnote"] = "ic_fluent_document_endnote_24_filled.png",
    ["document_endnote"] = "ic_fluent_document_endnote_24_filled.png",
    ["documenterror"] = "ic_fluent_document_error_24_filled.png",
    ["document-error"] = "ic_fluent_document_error_24_filled.png",
    ["document_error"] = "ic_fluent_document_error_24_filled.png",
    ["documentfooter"] = "ic_fluent_document_footer_24_filled.png",
    ["document-footer"] = "ic_fluent_document_footer_24_filled.png",
    ["document_footer"] = "ic_fluent_document_footer_24_filled.png",
    ["documentfooterdismiss"] = "ic_fluent_document_footer_dismiss_24_filled.png",
    ["document-footer-dismiss"] = "ic_fluent_document_footer_dismiss_24_filled.png",
    ["document_footer_dismiss"] = "ic_fluent_document_footer_dismiss_24_filled.png",
    ["documentfooterremove"] = "ic_fluent_document_footer_remove_24_filled.png",
    ["document-footer-remove"] = "ic_fluent_document_footer_remove_24_filled.png",
    ["document_footer_remove"] = "ic_fluent_document_footer_remove_24_filled.png",
    ["documentheader"] = "ic_fluent_document_header_24_filled.png",
    ["document-header"] = "ic_fluent_document_header_24_filled.png",
    ["document_header"] = "ic_fluent_document_header_24_filled.png",
    ["documentheaderdismiss"] = "ic_fluent_document_header_dismiss_24_filled.png",
    ["document-header-dismiss"] = "ic_fluent_document_header_dismiss_24_filled.png",
    ["document_header_dismiss"] = "ic_fluent_document_header_dismiss_24_filled.png",
    ["documentheaderfooter"] = "ic_fluent_document_header_footer_24_filled.png",
    ["document-header-footer"] = "ic_fluent_document_header_footer_24_filled.png",
    ["document_header_footer"] = "ic_fluent_document_header_footer_24_filled.png",
    ["documentheaderremove"] = "ic_fluent_document_header_remove_24_filled.png",
    ["document-header-remove"] = "ic_fluent_document_header_remove_24_filled.png",
    ["document_header_remove"] = "ic_fluent_document_header_remove_24_filled.png",
    ["documentheart"] = "ic_fluent_document_heart_24_filled.png",
    ["document-heart"] = "ic_fluent_document_heart_24_filled.png",
    ["document_heart"] = "ic_fluent_document_heart_24_filled.png",
    ["documentheartpulse"] = "ic_fluent_document_heart_pulse_24_filled.png",
    ["document-heart-pulse"] = "ic_fluent_document_heart_pulse_24_filled.png",
    ["document_heart_pulse"] = "ic_fluent_document_heart_pulse_24_filled.png",
    ["documentjavascript"] = "ic_fluent_document_javascript_24_filled.png",
    ["document-javascript"] = "ic_fluent_document_javascript_24_filled.png",
    ["document_javascript"] = "ic_fluent_document_javascript_24_filled.png",
    ["documentlandscape"] = "ic_fluent_document_landscape_24_filled.png",
    ["document-landscape"] = "ic_fluent_document_landscape_24_filled.png",
    ["document_landscape"] = "ic_fluent_document_landscape_24_filled.png",
    ["documentlandscapedata"] = "ic_fluent_document_landscape_data_24_filled.png",
    ["document-landscape-data"] = "ic_fluent_document_landscape_data_24_filled.png",
    ["document_landscape_data"] = "ic_fluent_document_landscape_data_24_filled.png",
    ["documentlink"] = "ic_fluent_document_link_24_filled.png",
    ["document-link"] = "ic_fluent_document_link_24_filled.png",
    ["document_link"] = "ic_fluent_document_link_24_filled.png",
    ["documentmargins"] = "ic_fluent_document_margins_24_filled.png",
    ["document-margins"] = "ic_fluent_document_margins_24_filled.png",
    ["document_margins"] = "ic_fluent_document_margins_24_filled.png",
    ["documentmultiple"] = "ic_fluent_document_multiple_24_filled.png",
    ["document-multiple"] = "ic_fluent_document_multiple_24_filled.png",
    ["document_multiple"] = "ic_fluent_document_multiple_24_filled.png",
    ["documentmultiplepercent"] = "ic_fluent_document_multiple_percent_24_filled.png",
    ["document-multiple-percent"] = "ic_fluent_document_multiple_percent_24_filled.png",
    ["document_multiple_percent"] = "ic_fluent_document_multiple_percent_24_filled.png",
    ["documentmultipleprohibited"] = "ic_fluent_document_multiple_prohibited_24_filled.png",
    ["document-multiple-prohibited"] = "ic_fluent_document_multiple_prohibited_24_filled.png",
    ["document_multiple_prohibited"] = "ic_fluent_document_multiple_prohibited_24_filled.png",
    ["documentonepage"] = "ic_fluent_document_one_page_24_filled.png",
    ["document-one-page"] = "ic_fluent_document_one_page_24_filled.png",
    ["document_one_page"] = "ic_fluent_document_one_page_24_filled.png",
    ["documentpagebottomcenter"] = "ic_fluent_document_page_bottom_center_24_filled.png",
    ["document-page-bottom-center"] = "ic_fluent_document_page_bottom_center_24_filled.png",
    ["document_page_bottom_center"] = "ic_fluent_document_page_bottom_center_24_filled.png",
    ["documentpagebottomleft"] = "ic_fluent_document_page_bottom_left_24_filled.png",
    ["document-page-bottom-left"] = "ic_fluent_document_page_bottom_left_24_filled.png",
    ["document_page_bottom_left"] = "ic_fluent_document_page_bottom_left_24_filled.png",
    ["documentpagebottomright"] = "ic_fluent_document_page_bottom_right_24_filled.png",
    ["document-page-bottom-right"] = "ic_fluent_document_page_bottom_right_24_filled.png",
    ["document_page_bottom_right"] = "ic_fluent_document_page_bottom_right_24_filled.png",
    ["documentpagebreak"] = "ic_fluent_document_page_break_24_filled.png",
    ["document-page-break"] = "ic_fluent_document_page_break_24_filled.png",
    ["document_page_break"] = "ic_fluent_document_page_break_24_filled.png",
    ["documentpagenumber"] = "ic_fluent_document_page_number_24_filled.png",
    ["document-page-number"] = "ic_fluent_document_page_number_24_filled.png",
    ["document_page_number"] = "ic_fluent_document_page_number_24_filled.png",
    ["documentpagetopcenter"] = "ic_fluent_document_page_top_center_24_filled.png",
    ["document-page-top-center"] = "ic_fluent_document_page_top_center_24_filled.png",
    ["document_page_top_center"] = "ic_fluent_document_page_top_center_24_filled.png",
    ["documentpagetopleft"] = "ic_fluent_document_page_top_left_24_filled.png",
    ["document-page-top-left"] = "ic_fluent_document_page_top_left_24_filled.png",
    ["document_page_top_left"] = "ic_fluent_document_page_top_left_24_filled.png",
    ["documentpagetopright"] = "ic_fluent_document_page_top_right_24_filled.png",
    ["document-page-top-right"] = "ic_fluent_document_page_top_right_24_filled.png",
    ["document_page_top_right"] = "ic_fluent_document_page_top_right_24_filled.png",
    ["documentpdf"] = "ic_fluent_document_pdf_24_filled.png",
    ["document-pdf"] = "ic_fluent_document_pdf_24_filled.png",
    ["document_pdf"] = "ic_fluent_document_pdf_24_filled.png",
    ["documentpercent"] = "ic_fluent_document_percent_24_filled.png",
    ["document-percent"] = "ic_fluent_document_percent_24_filled.png",
    ["document_percent"] = "ic_fluent_document_percent_24_filled.png",
    ["documentpill"] = "ic_fluent_document_pill_24_filled.png",
    ["document-pill"] = "ic_fluent_document_pill_24_filled.png",
    ["document_pill"] = "ic_fluent_document_pill_24_filled.png",
    ["documentprohibited"] = "ic_fluent_document_prohibited_24_filled.png",
    ["document-prohibited"] = "ic_fluent_document_prohibited_24_filled.png",
    ["document_prohibited"] = "ic_fluent_document_prohibited_24_filled.png",
    ["documentquestionmark"] = "ic_fluent_document_question_mark_24_filled.png",
    ["document-question-mark"] = "ic_fluent_document_question_mark_24_filled.png",
    ["document_question_mark"] = "ic_fluent_document_question_mark_24_filled.png",
    ["documentribbon"] = "ic_fluent_document_ribbon_24_filled.png",
    ["document-ribbon"] = "ic_fluent_document_ribbon_24_filled.png",
    ["document_ribbon"] = "ic_fluent_document_ribbon_24_filled.png",
    ["documentsave"] = "ic_fluent_document_save_24_filled.png",
    ["document-save"] = "ic_fluent_document_save_24_filled.png",
    ["document_save"] = "ic_fluent_document_save_24_filled.png",
    ["documentsearch"] = "ic_fluent_document_search_24_filled.png",
    ["document-search"] = "ic_fluent_document_search_24_filled.png",
    ["document_search"] = "ic_fluent_document_search_24_filled.png",
    ["documentsplithint"] = "ic_fluent_document_split_hint_24_filled.png",
    ["document-split-hint"] = "ic_fluent_document_split_hint_24_filled.png",
    ["document_split_hint"] = "ic_fluent_document_split_hint_24_filled.png",
    ["documentsplithintoff"] = "ic_fluent_document_split_hint_off_24_filled.png",
    ["document-split-hint-off"] = "ic_fluent_document_split_hint_off_24_filled.png",
    ["document_split_hint_off"] = "ic_fluent_document_split_hint_off_24_filled.png",
    ["documentsync"] = "ic_fluent_document_sync_24_filled.png",
    ["document-sync"] = "ic_fluent_document_sync_24_filled.png",
    ["document_sync"] = "ic_fluent_document_sync_24_filled.png",
    ["documenttable"] = "ic_fluent_document_table_24_filled.png",
    ["document-table"] = "ic_fluent_document_table_24_filled.png",
    ["document_table"] = "ic_fluent_document_table_24_filled.png",
    ["documenttext"] = "ic_fluent_document_text_24_filled.png",
    ["document-text"] = "ic_fluent_document_text_24_filled.png",
    ["document_text"] = "ic_fluent_document_text_24_filled.png",
    ["documenttextlink"] = "ic_fluent_document_text_link_24_filled.png",
    ["document-text-link"] = "ic_fluent_document_text_link_24_filled.png",
    ["document_text_link"] = "ic_fluent_document_text_link_24_filled.png",
    ["documenttoolbox"] = "ic_fluent_document_toolbox_24_filled.png",
    ["document-toolbox"] = "ic_fluent_document_toolbox_24_filled.png",
    ["document_toolbox"] = "ic_fluent_document_toolbox_24_filled.png",
    ["documentwidth"] = "ic_fluent_document_width_24_filled.png",
    ["document-width"] = "ic_fluent_document_width_24_filled.png",
    ["document_width"] = "ic_fluent_document_width_24_filled.png",
    ["doorarrowleft"] = "ic_fluent_door_arrow_left_24_filled.png",
    ["door-arrow-left"] = "ic_fluent_door_arrow_left_24_filled.png",
    ["door_arrow_left"] = "ic_fluent_door_arrow_left_24_filled.png",
    ["doortag"] = "ic_fluent_door_tag_24_filled.png",
    ["door-tag"] = "ic_fluent_door_tag_24_filled.png",
    ["door_tag"] = "ic_fluent_door_tag_24_filled.png",
    ["doubleswipedown"] = "ic_fluent_double_swipe_down_24_filled.png",
    ["double-swipe-down"] = "ic_fluent_double_swipe_down_24_filled.png",
    ["double_swipe_down"] = "ic_fluent_double_swipe_down_24_filled.png",
    ["doubleswipeup"] = "ic_fluent_double_swipe_up_24_filled.png",
    ["double-swipe-up"] = "ic_fluent_double_swipe_up_24_filled.png",
    ["double_swipe_up"] = "ic_fluent_double_swipe_up_24_filled.png",
    ["drafts"] = "ic_fluent_drafts_24_filled.png",
    ["drag"] = "ic_fluent_drag_24_filled.png",
    ["drawshape"] = "ic_fluent_draw_shape_24_filled.png",
    ["draw-shape"] = "ic_fluent_draw_shape_24_filled.png",
    ["draw_shape"] = "ic_fluent_draw_shape_24_filled.png",
    ["drawtext"] = "ic_fluent_draw_text_24_filled.png",
    ["draw-text"] = "ic_fluent_draw_text_24_filled.png",
    ["draw_text"] = "ic_fluent_draw_text_24_filled.png",
    ["drinkbeer"] = "ic_fluent_drink_beer_24_filled.png",
    ["drink-beer"] = "ic_fluent_drink_beer_24_filled.png",
    ["drink_beer"] = "ic_fluent_drink_beer_24_filled.png",
    ["drinkcoffee"] = "ic_fluent_drink_coffee_24_filled.png",
    ["drink-coffee"] = "ic_fluent_drink_coffee_24_filled.png",
    ["drink_coffee"] = "ic_fluent_drink_coffee_24_filled.png",
    ["drinkmargarita"] = "ic_fluent_drink_margarita_24_filled.png",
    ["drink-margarita"] = "ic_fluent_drink_margarita_24_filled.png",
    ["drink_margarita"] = "ic_fluent_drink_margarita_24_filled.png",
    ["drinktogo"] = "ic_fluent_drink_to_go_24_filled.png",
    ["drink-to-go"] = "ic_fluent_drink_to_go_24_filled.png",
    ["drink_to_go"] = "ic_fluent_drink_to_go_24_filled.png",
    ["drinkwine"] = "ic_fluent_drink_wine_24_filled.png",
    ["drink-wine"] = "ic_fluent_drink_wine_24_filled.png",
    ["drink_wine"] = "ic_fluent_drink_wine_24_filled.png",
    ["drivetrain"] = "ic_fluent_drive_train_24_filled.png",
    ["drive-train"] = "ic_fluent_drive_train_24_filled.png",
    ["drive_train"] = "ic_fluent_drive_train_24_filled.png",
    ["drop"] = "ic_fluent_drop_24_filled.png",
    ["dualscreen"] = "ic_fluent_dual_screen_24_filled.png",
    ["dual-screen"] = "ic_fluent_dual_screen_24_filled.png",
    ["dual_screen"] = "ic_fluent_dual_screen_24_filled.png",
    ["dualscreenadd"] = "ic_fluent_dual_screen_add_24_filled.png",
    ["dual-screen-add"] = "ic_fluent_dual_screen_add_24_filled.png",
    ["dual_screen_add"] = "ic_fluent_dual_screen_add_24_filled.png",
    ["dualscreenarrowright"] = "ic_fluent_dual_screen_arrow_right_24_filled.png",
    ["dual-screen-arrow-right"] = "ic_fluent_dual_screen_arrow_right_24_filled.png",
    ["dual_screen_arrow_right"] = "ic_fluent_dual_screen_arrow_right_24_filled.png",
    ["dualscreenarrowup"] = "ic_fluent_dual_screen_arrow_up_24_filled.png",
    ["dual-screen-arrow-up"] = "ic_fluent_dual_screen_arrow_up_24_filled.png",
    ["dual_screen_arrow_up"] = "ic_fluent_dual_screen_arrow_up_24_filled.png",
    ["dualscreenclock"] = "ic_fluent_dual_screen_clock_24_filled.png",
    ["dual-screen-clock"] = "ic_fluent_dual_screen_clock_24_filled.png",
    ["dual_screen_clock"] = "ic_fluent_dual_screen_clock_24_filled.png",
    ["dualscreenclosedalert"] = "ic_fluent_dual_screen_closed_alert_24_filled.png",
    ["dual-screen-closed-alert"] = "ic_fluent_dual_screen_closed_alert_24_filled.png",
    ["dual_screen_closed_alert"] = "ic_fluent_dual_screen_closed_alert_24_filled.png",
    ["dualscreendesktop"] = "ic_fluent_dual_screen_desktop_24_filled.png",
    ["dual-screen-desktop"] = "ic_fluent_dual_screen_desktop_24_filled.png",
    ["dual_screen_desktop"] = "ic_fluent_dual_screen_desktop_24_filled.png",
    ["dualscreendismiss"] = "ic_fluent_dual_screen_dismiss_24_filled.png",
    ["dual-screen-dismiss"] = "ic_fluent_dual_screen_dismiss_24_filled.png",
    ["dual_screen_dismiss"] = "ic_fluent_dual_screen_dismiss_24_filled.png",
    ["dualscreengroup"] = "ic_fluent_dual_screen_group_24_filled.png",
    ["dual-screen-group"] = "ic_fluent_dual_screen_group_24_filled.png",
    ["dual_screen_group"] = "ic_fluent_dual_screen_group_24_filled.png",
    ["dualscreenheader"] = "ic_fluent_dual_screen_header_24_filled.png",
    ["dual-screen-header"] = "ic_fluent_dual_screen_header_24_filled.png",
    ["dual_screen_header"] = "ic_fluent_dual_screen_header_24_filled.png",
    ["dualscreenlock"] = "ic_fluent_dual_screen_lock_24_filled.png",
    ["dual-screen-lock"] = "ic_fluent_dual_screen_lock_24_filled.png",
    ["dual_screen_lock"] = "ic_fluent_dual_screen_lock_24_filled.png",
    ["dualscreenmirror"] = "ic_fluent_dual_screen_mirror_24_filled.png",
    ["dual-screen-mirror"] = "ic_fluent_dual_screen_mirror_24_filled.png",
    ["dual_screen_mirror"] = "ic_fluent_dual_screen_mirror_24_filled.png",
    ["dualscreenpagination"] = "ic_fluent_dual_screen_pagination_24_filled.png",
    ["dual-screen-pagination"] = "ic_fluent_dual_screen_pagination_24_filled.png",
    ["dual_screen_pagination"] = "ic_fluent_dual_screen_pagination_24_filled.png",
    ["dualscreensettings"] = "ic_fluent_dual_screen_settings_24_filled.png",
    ["dual-screen-settings"] = "ic_fluent_dual_screen_settings_24_filled.png",
    ["dual_screen_settings"] = "ic_fluent_dual_screen_settings_24_filled.png",
    ["dualscreenspan"] = "ic_fluent_dual_screen_span_24_filled.png",
    ["dual-screen-span"] = "ic_fluent_dual_screen_span_24_filled.png",
    ["dual_screen_span"] = "ic_fluent_dual_screen_span_24_filled.png",
    ["dualscreenspeaker"] = "ic_fluent_dual_screen_speaker_24_filled.png",
    ["dual-screen-speaker"] = "ic_fluent_dual_screen_speaker_24_filled.png",
    ["dual_screen_speaker"] = "ic_fluent_dual_screen_speaker_24_filled.png",
    ["dualscreenstatusbar"] = "ic_fluent_dual_screen_status_bar_24_filled.png",
    ["dual-screen-status-bar"] = "ic_fluent_dual_screen_status_bar_24_filled.png",
    ["dual_screen_status_bar"] = "ic_fluent_dual_screen_status_bar_24_filled.png",
    ["dualscreentablet"] = "ic_fluent_dual_screen_tablet_24_filled.png",
    ["dual-screen-tablet"] = "ic_fluent_dual_screen_tablet_24_filled.png",
    ["dual_screen_tablet"] = "ic_fluent_dual_screen_tablet_24_filled.png",
    ["dualscreenupdate"] = "ic_fluent_dual_screen_update_24_filled.png",
    ["dual-screen-update"] = "ic_fluent_dual_screen_update_24_filled.png",
    ["dual_screen_update"] = "ic_fluent_dual_screen_update_24_filled.png",
    ["dualscreenverticalscroll"] = "ic_fluent_dual_screen_vertical_scroll_24_filled.png",
    ["dual-screen-vertical-scroll"] = "ic_fluent_dual_screen_vertical_scroll_24_filled.png",
    ["dual_screen_vertical_scroll"] = "ic_fluent_dual_screen_vertical_scroll_24_filled.png",
    ["dualscreenvibrate"] = "ic_fluent_dual_screen_vibrate_24_filled.png",
    ["dual-screen-vibrate"] = "ic_fluent_dual_screen_vibrate_24_filled.png",
    ["dual_screen_vibrate"] = "ic_fluent_dual_screen_vibrate_24_filled.png",
    ["dumbbell"] = "ic_fluent_dumbbell_24_filled.png",
    ["earth"] = "ic_fluent_earth_24_filled.png",
    ["edit"] = "ic_fluent_edit_24_filled.png",
    ["editoff"] = "ic_fluent_edit_off_24_filled.png",
    ["edit-off"] = "ic_fluent_edit_off_24_filled.png",
    ["edit_off"] = "ic_fluent_edit_off_24_filled.png",
    ["editsettings"] = "ic_fluent_edit_settings_24_filled.png",
    ["edit-settings"] = "ic_fluent_edit_settings_24_filled.png",
    ["edit_settings"] = "ic_fluent_edit_settings_24_filled.png",
    ["emoji"] = "ic_fluent_emoji_24_filled.png",
    ["emojiadd"] = "ic_fluent_emoji_add_24_filled.png",
    ["emoji-add"] = "ic_fluent_emoji_add_24_filled.png",
    ["emoji_add"] = "ic_fluent_emoji_add_24_filled.png",
    ["emojiangry"] = "ic_fluent_emoji_angry_24_filled.png",
    ["emoji-angry"] = "ic_fluent_emoji_angry_24_filled.png",
    ["emoji_angry"] = "ic_fluent_emoji_angry_24_filled.png",
    ["emojihand"] = "ic_fluent_emoji_hand_24_filled.png",
    ["emoji-hand"] = "ic_fluent_emoji_hand_24_filled.png",
    ["emoji_hand"] = "ic_fluent_emoji_hand_24_filled.png",
    ["emojilaugh"] = "ic_fluent_emoji_laugh_24_filled.png",
    ["emoji-laugh"] = "ic_fluent_emoji_laugh_24_filled.png",
    ["emoji_laugh"] = "ic_fluent_emoji_laugh_24_filled.png",
    ["emojimeh"] = "ic_fluent_emoji_meh_24_filled.png",
    ["emoji-meh"] = "ic_fluent_emoji_meh_24_filled.png",
    ["emoji_meh"] = "ic_fluent_emoji_meh_24_filled.png",
    ["emojimultiple"] = "ic_fluent_emoji_multiple_24_filled.png",
    ["emoji-multiple"] = "ic_fluent_emoji_multiple_24_filled.png",
    ["emoji_multiple"] = "ic_fluent_emoji_multiple_24_filled.png",
    ["emojisad"] = "ic_fluent_emoji_sad_24_filled.png",
    ["emoji-sad"] = "ic_fluent_emoji_sad_24_filled.png",
    ["emoji_sad"] = "ic_fluent_emoji_sad_24_filled.png",
    ["emojisurprise"] = "ic_fluent_emoji_surprise_24_filled.png",
    ["emoji-surprise"] = "ic_fluent_emoji_surprise_24_filled.png",
    ["emoji_surprise"] = "ic_fluent_emoji_surprise_24_filled.png",
    ["engine"] = "ic_fluent_engine_24_filled.png",
    ["equaloff"] = "ic_fluent_equal_off_24_filled.png",
    ["equal-off"] = "ic_fluent_equal_off_24_filled.png",
    ["equal_off"] = "ic_fluent_equal_off_24_filled.png",
    ["eraser"] = "ic_fluent_eraser_24_filled.png",
    ["erasermedium"] = "ic_fluent_eraser_medium_24_filled.png",
    ["eraser-medium"] = "ic_fluent_eraser_medium_24_filled.png",
    ["eraser_medium"] = "ic_fluent_eraser_medium_24_filled.png",
    ["erasersegment"] = "ic_fluent_eraser_segment_24_filled.png",
    ["eraser-segment"] = "ic_fluent_eraser_segment_24_filled.png",
    ["eraser_segment"] = "ic_fluent_eraser_segment_24_filled.png",
    ["erasersmall"] = "ic_fluent_eraser_small_24_filled.png",
    ["eraser-small"] = "ic_fluent_eraser_small_24_filled.png",
    ["eraser_small"] = "ic_fluent_eraser_small_24_filled.png",
    ["erasertool"] = "ic_fluent_eraser_tool_24_filled.png",
    ["eraser-tool"] = "ic_fluent_eraser_tool_24_filled.png",
    ["eraser_tool"] = "ic_fluent_eraser_tool_24_filled.png",
    ["errorcircle"] = "ic_fluent_error_circle_24_filled.png",
    ["error-circle"] = "ic_fluent_error_circle_24_filled.png",
    ["error_circle"] = "ic_fluent_error_circle_24_filled.png",
    ["expandupleft"] = "ic_fluent_expand_up_left_24_filled.png",
    ["expand-up-left"] = "ic_fluent_expand_up_left_24_filled.png",
    ["expand_up_left"] = "ic_fluent_expand_up_left_24_filled.png",
    ["expandupright"] = "ic_fluent_expand_up_right_24_filled.png",
    ["expand-up-right"] = "ic_fluent_expand_up_right_24_filled.png",
    ["expand_up_right"] = "ic_fluent_expand_up_right_24_filled.png",
    ["extendeddock"] = "ic_fluent_extended_dock_24_filled.png",
    ["extended-dock"] = "ic_fluent_extended_dock_24_filled.png",
    ["extended_dock"] = "ic_fluent_extended_dock_24_filled.png",
    ["extension"] = "ic_fluent_extension_24_filled.png",
    ["eyehide"] = "ic_fluent_eye_hide_24_filled.png",
    ["eye-hide"] = "ic_fluent_eye_hide_24_filled.png",
    ["eye_hide"] = "ic_fluent_eye_hide_24_filled.png",
    ["eyeshow"] = "ic_fluent_eye_show_24_filled.png",
    ["eye-show"] = "ic_fluent_eye_show_24_filled.png",
    ["eye_show"] = "ic_fluent_eye_show_24_filled.png",
    ["eyetrackingoff"] = "ic_fluent_eye_tracking_off_24_filled.png",
    ["eye-tracking-off"] = "ic_fluent_eye_tracking_off_24_filled.png",
    ["eye_tracking_off"] = "ic_fluent_eye_tracking_off_24_filled.png",
    ["eyetrackingon"] = "ic_fluent_eye_tracking_on_24_filled.png",
    ["eye-tracking-on"] = "ic_fluent_eye_tracking_on_24_filled.png",
    ["eye_tracking_on"] = "ic_fluent_eye_tracking_on_24_filled.png",
    ["eyedropper"] = "ic_fluent_eyedropper_24_filled.png",
    ["fstop"] = "ic_fluent_f_stop_24_filled.png",
    ["f-stop"] = "ic_fluent_f_stop_24_filled.png",
    ["f_stop"] = "ic_fluent_f_stop_24_filled.png",
    ["fastacceleration"] = "ic_fluent_fast_acceleration_24_filled.png",
    ["fast-acceleration"] = "ic_fluent_fast_acceleration_24_filled.png",
    ["fast_acceleration"] = "ic_fluent_fast_acceleration_24_filled.png",
    ["fastforward"] = "ic_fluent_fast_forward_24_filled.png",
    ["fast-forward"] = "ic_fluent_fast_forward_24_filled.png",
    ["fast_forward"] = "ic_fluent_fast_forward_24_filled.png",
    ["filter"] = "ic_fluent_filter_24_filled.png",
    ["filterdismiss"] = "ic_fluent_filter_dismiss_24_filled.png",
    ["filter-dismiss"] = "ic_fluent_filter_dismiss_24_filled.png",
    ["filter_dismiss"] = "ic_fluent_filter_dismiss_24_filled.png",
    ["filtersync"] = "ic_fluent_filter_sync_24_filled.png",
    ["filter-sync"] = "ic_fluent_filter_sync_24_filled.png",
    ["filter_sync"] = "ic_fluent_filter_sync_24_filled.png",
    ["fingerprint"] = "ic_fluent_fingerprint_24_filled.png",
    ["fixedwidth"] = "ic_fluent_fixed_width_24_filled.png",
    ["fixed-width"] = "ic_fluent_fixed_width_24_filled.png",
    ["fixed_width"] = "ic_fluent_fixed_width_24_filled.png",
    ["flag"] = "ic_fluent_flag_24_filled.png",
    ["flagoff"] = "ic_fluent_flag_off_24_filled.png",
    ["flag-off"] = "ic_fluent_flag_off_24_filled.png",
    ["flag_off"] = "ic_fluent_flag_off_24_filled.png",
    ["flagpride"] = "ic_fluent_flag_pride_24_filled.png",
    ["flag-pride"] = "ic_fluent_flag_pride_24_filled.png",
    ["flag_pride"] = "ic_fluent_flag_pride_24_filled.png",
    ["flashauto"] = "ic_fluent_flash_auto_24_filled.png",
    ["flash-auto"] = "ic_fluent_flash_auto_24_filled.png",
    ["flash_auto"] = "ic_fluent_flash_auto_24_filled.png",
    ["flashcheckmark"] = "ic_fluent_flash_checkmark_24_filled.png",
    ["flash-checkmark"] = "ic_fluent_flash_checkmark_24_filled.png",
    ["flash_checkmark"] = "ic_fluent_flash_checkmark_24_filled.png",
    ["flashoff"] = "ic_fluent_flash_off_24_filled.png",
    ["flash-off"] = "ic_fluent_flash_off_24_filled.png",
    ["flash_off"] = "ic_fluent_flash_off_24_filled.png",
    ["flashon"] = "ic_fluent_flash_on_24_filled.png",
    ["flash-on"] = "ic_fluent_flash_on_24_filled.png",
    ["flash_on"] = "ic_fluent_flash_on_24_filled.png",
    ["flashlight"] = "ic_fluent_flashlight_24_filled.png",
    ["flashlightoff"] = "ic_fluent_flashlight_off_24_filled.png",
    ["flashlight-off"] = "ic_fluent_flashlight_off_24_filled.png",
    ["flashlight_off"] = "ic_fluent_flashlight_off_24_filled.png",
    ["fliphorizontal"] = "ic_fluent_flip_horizontal_24_filled.png",
    ["flip-horizontal"] = "ic_fluent_flip_horizontal_24_filled.png",
    ["flip_horizontal"] = "ic_fluent_flip_horizontal_24_filled.png",
    ["flipvertical"] = "ic_fluent_flip_vertical_24_filled.png",
    ["flip-vertical"] = "ic_fluent_flip_vertical_24_filled.png",
    ["flip_vertical"] = "ic_fluent_flip_vertical_24_filled.png",
    ["fluid"] = "ic_fluent_fluid_24_filled.png",
    ["folder"] = "ic_fluent_folder_24_filled.png",
    ["folderadd"] = "ic_fluent_folder_add_24_filled.png",
    ["folder-add"] = "ic_fluent_folder_add_24_filled.png",
    ["folder_add"] = "ic_fluent_folder_add_24_filled.png",
    ["folderarrowright"] = "ic_fluent_folder_arrow_right_24_filled.png",
    ["folder-arrow-right"] = "ic_fluent_folder_arrow_right_24_filled.png",
    ["folder_arrow_right"] = "ic_fluent_folder_arrow_right_24_filled.png",
    ["folderarrowup"] = "ic_fluent_folder_arrow_up_24_filled.png",
    ["folder-arrow-up"] = "ic_fluent_folder_arrow_up_24_filled.png",
    ["folder_arrow_up"] = "ic_fluent_folder_arrow_up_24_filled.png",
    ["folderlink"] = "ic_fluent_folder_link_24_filled.png",
    ["folder-link"] = "ic_fluent_folder_link_24_filled.png",
    ["folder_link"] = "ic_fluent_folder_link_24_filled.png",
    ["folderopen"] = "ic_fluent_folder_open_24_filled.png",
    ["folder-open"] = "ic_fluent_folder_open_24_filled.png",
    ["folder_open"] = "ic_fluent_folder_open_24_filled.png",
    ["folderprohibited"] = "ic_fluent_folder_prohibited_24_filled.png",
    ["folder-prohibited"] = "ic_fluent_folder_prohibited_24_filled.png",
    ["folder_prohibited"] = "ic_fluent_folder_prohibited_24_filled.png",
    ["folderswap"] = "ic_fluent_folder_swap_24_filled.png",
    ["folder-swap"] = "ic_fluent_folder_swap_24_filled.png",
    ["folder_swap"] = "ic_fluent_folder_swap_24_filled.png",
    ["folderzip"] = "ic_fluent_folder_zip_24_filled.png",
    ["folder-zip"] = "ic_fluent_folder_zip_24_filled.png",
    ["folder_zip"] = "ic_fluent_folder_zip_24_filled.png",
    ["fontdecrease"] = "ic_fluent_font_decrease_24_filled.png",
    ["font-decrease"] = "ic_fluent_font_decrease_24_filled.png",
    ["font_decrease"] = "ic_fluent_font_decrease_24_filled.png",
    ["fontincrease"] = "ic_fluent_font_increase_24_filled.png",
    ["font-increase"] = "ic_fluent_font_increase_24_filled.png",
    ["font_increase"] = "ic_fluent_font_increase_24_filled.png",
    ["fontspacetrackingin"] = "ic_fluent_font_space_tracking_in_24_filled.png",
    ["font-space-tracking-in"] = "ic_fluent_font_space_tracking_in_24_filled.png",
    ["font_space_tracking_in"] = "ic_fluent_font_space_tracking_in_24_filled.png",
    ["fontspacetrackingout"] = "ic_fluent_font_space_tracking_out_24_filled.png",
    ["font-space-tracking-out"] = "ic_fluent_font_space_tracking_out_24_filled.png",
    ["font_space_tracking_out"] = "ic_fluent_font_space_tracking_out_24_filled.png",
    ["food"] = "ic_fluent_food_24_filled.png",
    ["foodcake"] = "ic_fluent_food_cake_24_filled.png",
    ["food-cake"] = "ic_fluent_food_cake_24_filled.png",
    ["food_cake"] = "ic_fluent_food_cake_24_filled.png",
    ["foodegg"] = "ic_fluent_food_egg_24_filled.png",
    ["food-egg"] = "ic_fluent_food_egg_24_filled.png",
    ["food_egg"] = "ic_fluent_food_egg_24_filled.png",
    ["foodpizza"] = "ic_fluent_food_pizza_24_filled.png",
    ["food-pizza"] = "ic_fluent_food_pizza_24_filled.png",
    ["food_pizza"] = "ic_fluent_food_pizza_24_filled.png",
    ["foodtoast"] = "ic_fluent_food_toast_24_filled.png",
    ["food-toast"] = "ic_fluent_food_toast_24_filled.png",
    ["food_toast"] = "ic_fluent_food_toast_24_filled.png",
    ["formnew"] = "ic_fluent_form_new_24_filled.png",
    ["form-new"] = "ic_fluent_form_new_24_filled.png",
    ["form_new"] = "ic_fluent_form_new_24_filled.png",
    ["fps120"] = "ic_fluent_fps_120_24_filled.png",
    ["fps"] = "ic_fluent_fps_240_20_filled.png",
    ["fps30"] = "ic_fluent_fps_30_24_filled.png",
    ["fps60"] = "ic_fluent_fps_60_24_filled.png",
    ["fps960"] = "ic_fluent_fps_960_24_filled.png",
    ["fullscreenmaximize"] = "ic_fluent_full_screen_maximize_24_filled.png",
    ["full-screen-maximize"] = "ic_fluent_full_screen_maximize_24_filled.png",
    ["full_screen_maximize"] = "ic_fluent_full_screen_maximize_24_filled.png",
    ["fullscreenminimize"] = "ic_fluent_full_screen_minimize_24_filled.png",
    ["full-screen-minimize"] = "ic_fluent_full_screen_minimize_24_filled.png",
    ["full_screen_minimize"] = "ic_fluent_full_screen_minimize_24_filled.png",
    ["games"] = "ic_fluent_games_24_filled.png",
    ["ganttchart"] = "ic_fluent_gantt_chart_24_filled.png",
    ["gantt-chart"] = "ic_fluent_gantt_chart_24_filled.png",
    ["gantt_chart"] = "ic_fluent_gantt_chart_24_filled.png",
    ["gas"] = "ic_fluent_gas_24_filled.png",
    ["gaspump"] = "ic_fluent_gas_pump_24_filled.png",
    ["gas-pump"] = "ic_fluent_gas_pump_24_filled.png",
    ["gas_pump"] = "ic_fluent_gas_pump_24_filled.png",
    ["gauge"] = "ic_fluent_gauge_24_filled.png",
    ["gavel"] = "ic_fluent_gavel_24_filled.png",
    ["gesture"] = "ic_fluent_gesture_24_filled.png",
    ["gif"] = "ic_fluent_gif_24_filled.png",
    ["gift"] = "ic_fluent_gift_24_filled.png",
    ["giftcardadd"] = "ic_fluent_gift_card_add_24_filled.png",
    ["gift-card-add"] = "ic_fluent_gift_card_add_24_filled.png",
    ["gift_card_add"] = "ic_fluent_gift_card_add_24_filled.png",
    ["glance"] = "ic_fluent_glance_24_filled.png",
    ["glasses"] = "ic_fluent_glasses_24_filled.png",
    ["glassesoff"] = "ic_fluent_glasses_off_24_filled.png",
    ["glasses-off"] = "ic_fluent_glasses_off_24_filled.png",
    ["glasses_off"] = "ic_fluent_glasses_off_24_filled.png",
    ["globe"] = "ic_fluent_globe_24_filled.png",
    ["globeadd"] = "ic_fluent_globe_add_24_filled.png",
    ["globe-add"] = "ic_fluent_globe_add_24_filled.png",
    ["globe_add"] = "ic_fluent_globe_add_24_filled.png",
    ["globeclock"] = "ic_fluent_globe_clock_24_filled.png",
    ["globe-clock"] = "ic_fluent_globe_clock_24_filled.png",
    ["globe_clock"] = "ic_fluent_globe_clock_24_filled.png",
    ["globedesktop"] = "ic_fluent_globe_desktop_24_filled.png",
    ["globe-desktop"] = "ic_fluent_globe_desktop_24_filled.png",
    ["globe_desktop"] = "ic_fluent_globe_desktop_24_filled.png",
    ["globelocation"] = "ic_fluent_globe_location_24_filled.png",
    ["globe-location"] = "ic_fluent_globe_location_24_filled.png",
    ["globe_location"] = "ic_fluent_globe_location_24_filled.png",
    ["globeperson"] = "ic_fluent_globe_person_24_filled.png",
    ["globe-person"] = "ic_fluent_globe_person_24_filled.png",
    ["globe_person"] = "ic_fluent_globe_person_24_filled.png",
    ["globesearch"] = "ic_fluent_globe_search_24_filled.png",
    ["globe-search"] = "ic_fluent_globe_search_24_filled.png",
    ["globe_search"] = "ic_fluent_globe_search_24_filled.png",
    ["globeshield"] = "ic_fluent_globe_shield_24_filled.png",
    ["globe-shield"] = "ic_fluent_globe_shield_24_filled.png",
    ["globe_shield"] = "ic_fluent_globe_shield_24_filled.png",
    ["globesurface"] = "ic_fluent_globe_surface_24_filled.png",
    ["globe-surface"] = "ic_fluent_globe_surface_24_filled.png",
    ["globe_surface"] = "ic_fluent_globe_surface_24_filled.png",
    ["globevideo"] = "ic_fluent_globe_video_24_filled.png",
    ["globe-video"] = "ic_fluent_globe_video_24_filled.png",
    ["globe_video"] = "ic_fluent_globe_video_24_filled.png",
    ["grid"] = "ic_fluent_grid_24_filled.png",
    ["griddots"] = "ic_fluent_grid_dots_24_filled.png",
    ["grid-dots"] = "ic_fluent_grid_dots_24_filled.png",
    ["grid_dots"] = "ic_fluent_grid_dots_24_filled.png",
    ["group"] = "ic_fluent_group_24_filled.png",
    ["groupdismiss"] = "ic_fluent_group_dismiss_24_filled.png",
    ["group-dismiss"] = "ic_fluent_group_dismiss_24_filled.png",
    ["group_dismiss"] = "ic_fluent_group_dismiss_24_filled.png",
    ["grouplist"] = "ic_fluent_group_list_24_filled.png",
    ["group-list"] = "ic_fluent_group_list_24_filled.png",
    ["group_list"] = "ic_fluent_group_list_24_filled.png",
    ["groupreturn"] = "ic_fluent_group_return_24_filled.png",
    ["group-return"] = "ic_fluent_group_return_24_filled.png",
    ["group_return"] = "ic_fluent_group_return_24_filled.png",
    ["guardian"] = "ic_fluent_guardian_24_filled.png",
    ["guest"] = "ic_fluent_guest_24_filled.png",
    ["guestadd"] = "ic_fluent_guest_add_24_filled.png",
    ["guest-add"] = "ic_fluent_guest_add_24_filled.png",
    ["guest_add"] = "ic_fluent_guest_add_24_filled.png",
    ["guitar"] = "ic_fluent_guitar_24_filled.png",
    ["handdraw"] = "ic_fluent_hand_draw_24_filled.png",
    ["hand-draw"] = "ic_fluent_hand_draw_24_filled.png",
    ["hand_draw"] = "ic_fluent_hand_draw_24_filled.png",
    ["handleft"] = "ic_fluent_hand_left_24_filled.png",
    ["hand-left"] = "ic_fluent_hand_left_24_filled.png",
    ["hand_left"] = "ic_fluent_hand_left_24_filled.png",
    ["handright"] = "ic_fluent_hand_right_24_filled.png",
    ["hand-right"] = "ic_fluent_hand_right_24_filled.png",
    ["hand_right"] = "ic_fluent_hand_right_24_filled.png",
    ["handshake"] = "ic_fluent_handshake_24_filled.png",
    ["hatgraduation"] = "ic_fluent_hat_graduation_24_filled.png",
    ["hat-graduation"] = "ic_fluent_hat_graduation_24_filled.png",
    ["hat_graduation"] = "ic_fluent_hat_graduation_24_filled.png",
    ["hd"] = "ic_fluent_hd_24_filled.png",
    ["hdr"] = "ic_fluent_hdr_24_filled.png",
    ["headphones"] = "ic_fluent_headphones_24_filled.png",
    ["headphonessoundwave"] = "ic_fluent_headphones_sound_wave_24_filled.png",
    ["headphones-sound-wave"] = "ic_fluent_headphones_sound_wave_24_filled.png",
    ["headphones_sound_wave"] = "ic_fluent_headphones_sound_wave_24_filled.png",
    ["headset"] = "ic_fluent_headset_24_filled.png",
    ["headsetadd"] = "ic_fluent_headset_add_24_filled.png",
    ["headset-add"] = "ic_fluent_headset_add_24_filled.png",
    ["headset_add"] = "ic_fluent_headset_add_24_filled.png",
    ["headsetvr"] = "ic_fluent_headset_vr_24_filled.png",
    ["headset-vr"] = "ic_fluent_headset_vr_24_filled.png",
    ["headset_vr"] = "ic_fluent_headset_vr_24_filled.png",
    ["heart"] = "ic_fluent_heart_24_filled.png",
    ["heartpulse"] = "ic_fluent_heart_pulse_24_filled.png",
    ["heart-pulse"] = "ic_fluent_heart_pulse_24_filled.png",
    ["heart_pulse"] = "ic_fluent_heart_pulse_24_filled.png",
    ["highlight"] = "ic_fluent_highlight_24_filled.png",
    ["highlightaccent"] = "ic_fluent_highlight_accent_24_filled.png",
    ["highlight-accent"] = "ic_fluent_highlight_accent_24_filled.png",
    ["highlight_accent"] = "ic_fluent_highlight_accent_24_filled.png",
    ["history"] = "ic_fluent_history_24_filled.png",
    ["home"] = "ic_fluent_home_24_filled.png",
    ["homeadd"] = "ic_fluent_home_add_24_filled.png",
    ["home-add"] = "ic_fluent_home_add_24_filled.png",
    ["home_add"] = "ic_fluent_home_add_24_filled.png",
    ["homecheckmark"] = "ic_fluent_home_checkmark_24_filled.png",
    ["home-checkmark"] = "ic_fluent_home_checkmark_24_filled.png",
    ["home_checkmark"] = "ic_fluent_home_checkmark_24_filled.png",
    ["homeperson"] = "ic_fluent_home_person_24_filled.png",
    ["home-person"] = "ic_fluent_home_person_24_filled.png",
    ["home_person"] = "ic_fluent_home_person_24_filled.png",
    ["icons"] = "ic_fluent_icons_24_filled.png",
    ["image"] = "ic_fluent_image_24_filled.png",
    ["imageadd"] = "ic_fluent_image_add_24_filled.png",
    ["image-add"] = "ic_fluent_image_add_24_filled.png",
    ["image_add"] = "ic_fluent_image_add_24_filled.png",
    ["imagealttext"] = "ic_fluent_image_alt_text_24_filled.png",
    ["image-alt-text"] = "ic_fluent_image_alt_text_24_filled.png",
    ["image_alt_text"] = "ic_fluent_image_alt_text_24_filled.png",
    ["imagearrowback"] = "ic_fluent_image_arrow_back_24_filled.png",
    ["image-arrow-back"] = "ic_fluent_image_arrow_back_24_filled.png",
    ["image_arrow_back"] = "ic_fluent_image_arrow_back_24_filled.png",
    ["imagearrowcounterclockwise"] = "ic_fluent_image_arrow_counterclockwise_24_filled.png",
    ["image-arrow-counterclockwise"] = "ic_fluent_image_arrow_counterclockwise_24_filled.png",
    ["image_arrow_counterclockwise"] = "ic_fluent_image_arrow_counterclockwise_24_filled.png",
    ["imagearrowforward"] = "ic_fluent_image_arrow_forward_24_filled.png",
    ["image-arrow-forward"] = "ic_fluent_image_arrow_forward_24_filled.png",
    ["image_arrow_forward"] = "ic_fluent_image_arrow_forward_24_filled.png",
    ["imagecopy"] = "ic_fluent_image_copy_24_filled.png",
    ["image-copy"] = "ic_fluent_image_copy_24_filled.png",
    ["image_copy"] = "ic_fluent_image_copy_24_filled.png",
    ["imageedit"] = "ic_fluent_image_edit_24_filled.png",
    ["image-edit"] = "ic_fluent_image_edit_24_filled.png",
    ["image_edit"] = "ic_fluent_image_edit_24_filled.png",
    ["imageglobe"] = "ic_fluent_image_globe_24_filled.png",
    ["image-globe"] = "ic_fluent_image_globe_24_filled.png",
    ["image_globe"] = "ic_fluent_image_globe_24_filled.png",
    ["imagemultiple"] = "ic_fluent_image_multiple_24_filled.png",
    ["image-multiple"] = "ic_fluent_image_multiple_24_filled.png",
    ["image_multiple"] = "ic_fluent_image_multiple_24_filled.png",
    ["imageoff"] = "ic_fluent_image_off_24_filled.png",
    ["image-off"] = "ic_fluent_image_off_24_filled.png",
    ["image_off"] = "ic_fluent_image_off_24_filled.png",
    ["imageprohibited"] = "ic_fluent_image_prohibited_24_filled.png",
    ["image-prohibited"] = "ic_fluent_image_prohibited_24_filled.png",
    ["image_prohibited"] = "ic_fluent_image_prohibited_24_filled.png",
    ["imagereflection"] = "ic_fluent_image_reflection_24_filled.png",
    ["image-reflection"] = "ic_fluent_image_reflection_24_filled.png",
    ["image_reflection"] = "ic_fluent_image_reflection_24_filled.png",
    ["imagesearch"] = "ic_fluent_image_search_24_filled.png",
    ["image-search"] = "ic_fluent_image_search_24_filled.png",
    ["image_search"] = "ic_fluent_image_search_24_filled.png",
    ["imageshadow"] = "ic_fluent_image_shadow_24_filled.png",
    ["image-shadow"] = "ic_fluent_image_shadow_24_filled.png",
    ["image_shadow"] = "ic_fluent_image_shadow_24_filled.png",
    ["immersivereader"] = "ic_fluent_immersive_reader_24_filled.png",
    ["immersive-reader"] = "ic_fluent_immersive_reader_24_filled.png",
    ["immersive_reader"] = "ic_fluent_immersive_reader_24_filled.png",
    ["important"] = "ic_fluent_important_24_filled.png",
    ["incognito"] = "ic_fluent_incognito_24_filled.png",
    ["info"] = "ic_fluent_info_24_filled.png",
    ["inkstroke"] = "ic_fluent_ink_stroke_24_filled.png",
    ["ink-stroke"] = "ic_fluent_ink_stroke_24_filled.png",
    ["ink_stroke"] = "ic_fluent_ink_stroke_24_filled.png",
    ["inkingtool"] = "ic_fluent_inking_tool_24_filled.png",
    ["inking-tool"] = "ic_fluent_inking_tool_24_filled.png",
    ["inking_tool"] = "ic_fluent_inking_tool_24_filled.png",
    ["inkingtoolaccent"] = "ic_fluent_inking_tool_accent_24_filled.png",
    ["inking-tool-accent"] = "ic_fluent_inking_tool_accent_24_filled.png",
    ["inking_tool_accent"] = "ic_fluent_inking_tool_accent_24_filled.png",
    ["inprivateaccount"] = "ic_fluent_inprivate_account_24_filled.png",
    ["inprivate-account"] = "ic_fluent_inprivate_account_24_filled.png",
    ["inprivate_account"] = "ic_fluent_inprivate_account_24_filled.png",
    ["iosarrowleft"] = "ic_fluent_ios_arrow_left_24_filled.png",
    ["ios-arrow-left"] = "ic_fluent_ios_arrow_left_24_filled.png",
    ["ios_arrow_left"] = "ic_fluent_ios_arrow_left_24_filled.png",
    ["iosarrowltr"] = "ic_fluent_ios_arrow_ltr_24_filled.png",
    ["ios-arrow-ltr"] = "ic_fluent_ios_arrow_ltr_24_filled.png",
    ["ios_arrow_ltr"] = "ic_fluent_ios_arrow_ltr_24_filled.png",
    ["iosarrowright"] = "ic_fluent_ios_arrow_right_24_filled.png",
    ["ios-arrow-right"] = "ic_fluent_ios_arrow_right_24_filled.png",
    ["ios_arrow_right"] = "ic_fluent_ios_arrow_right_24_filled.png",
    ["iosarrowrtl"] = "ic_fluent_ios_arrow_rtl_24_filled.png",
    ["ios-arrow-rtl"] = "ic_fluent_ios_arrow_rtl_24_filled.png",
    ["ios_arrow_rtl"] = "ic_fluent_ios_arrow_rtl_24_filled.png",
    ["iot"] = "ic_fluent_iot_24_filled.png",
    ["javascript"] = "ic_fluent_javascript_24_filled.png",
    ["key"] = "ic_fluent_key_24_filled.png",
    ["keyboard123"] = "ic_fluent_keyboard_123_24_filled.png",
    ["keyboard"] = "ic_fluent_keyboard_24_filled.png",
    ["keyboarddock"] = "ic_fluent_keyboard_dock_24_filled.png",
    ["keyboard-dock"] = "ic_fluent_keyboard_dock_24_filled.png",
    ["keyboard_dock"] = "ic_fluent_keyboard_dock_24_filled.png",
    ["keyboardlayoutfloat"] = "ic_fluent_keyboard_layout_float_24_filled.png",
    ["keyboard-layout-float"] = "ic_fluent_keyboard_layout_float_24_filled.png",
    ["keyboard_layout_float"] = "ic_fluent_keyboard_layout_float_24_filled.png",
    ["keyboardlayoutonehandedleft"] = "ic_fluent_keyboard_layout_one_handed_left_24_filled.png",
    ["keyboard-layout-one-handed-left"] = "ic_fluent_keyboard_layout_one_handed_left_24_filled.png",
    ["keyboard_layout_one_handed_left"] = "ic_fluent_keyboard_layout_one_handed_left_24_filled.png",
    ["keyboardlayoutresize"] = "ic_fluent_keyboard_layout_resize_24_filled.png",
    ["keyboard-layout-resize"] = "ic_fluent_keyboard_layout_resize_24_filled.png",
    ["keyboard_layout_resize"] = "ic_fluent_keyboard_layout_resize_24_filled.png",
    ["keyboardlayoutsplit"] = "ic_fluent_keyboard_layout_split_24_filled.png",
    ["keyboard-layout-split"] = "ic_fluent_keyboard_layout_split_24_filled.png",
    ["keyboard_layout_split"] = "ic_fluent_keyboard_layout_split_24_filled.png",
    ["keyboardshift"] = "ic_fluent_keyboard_shift_24_filled.png",
    ["keyboard-shift"] = "ic_fluent_keyboard_shift_24_filled.png",
    ["keyboard_shift"] = "ic_fluent_keyboard_shift_24_filled.png",
    ["keyboardshiftuppercase"] = "ic_fluent_keyboard_shift_uppercase_24_filled.png",
    ["keyboard-shift-uppercase"] = "ic_fluent_keyboard_shift_uppercase_24_filled.png",
    ["keyboard_shift_uppercase"] = "ic_fluent_keyboard_shift_uppercase_24_filled.png",
    ["keyboardtab"] = "ic_fluent_keyboard_tab_24_filled.png",
    ["keyboard-tab"] = "ic_fluent_keyboard_tab_24_filled.png",
    ["keyboard_tab"] = "ic_fluent_keyboard_tab_24_filled.png",
    ["laptop"] = "ic_fluent_laptop_24_filled.png",
    ["lasso"] = "ic_fluent_lasso_24_filled.png",
    ["launchersettings"] = "ic_fluent_launcher_settings_24_filled.png",
    ["launcher-settings"] = "ic_fluent_launcher_settings_24_filled.png",
    ["launcher_settings"] = "ic_fluent_launcher_settings_24_filled.png",
    ["layer"] = "ic_fluent_layer_24_filled.png",
    ["leafone"] = "ic_fluent_leaf_one_24_filled.png",
    ["leaf-one"] = "ic_fluent_leaf_one_24_filled.png",
    ["leaf_one"] = "ic_fluent_leaf_one_24_filled.png",
    ["leafthree"] = "ic_fluent_leaf_three_24_filled.png",
    ["leaf-three"] = "ic_fluent_leaf_three_24_filled.png",
    ["leaf_three"] = "ic_fluent_leaf_three_24_filled.png",
    ["leaftwo"] = "ic_fluent_leaf_two_24_filled.png",
    ["leaf-two"] = "ic_fluent_leaf_two_24_filled.png",
    ["leaf_two"] = "ic_fluent_leaf_two_24_filled.png",
    ["learningapp"] = "ic_fluent_learning_app_24_filled.png",
    ["learning-app"] = "ic_fluent_learning_app_24_filled.png",
    ["learning_app"] = "ic_fluent_learning_app_24_filled.png",
    ["library"] = "ic_fluent_library_24_filled.png",
    ["lightbulb"] = "ic_fluent_lightbulb_24_filled.png",
    ["lightbulbcircle"] = "ic_fluent_lightbulb_circle_24_filled.png",
    ["lightbulb-circle"] = "ic_fluent_lightbulb_circle_24_filled.png",
    ["lightbulb_circle"] = "ic_fluent_lightbulb_circle_24_filled.png",
    ["lightbulbfilament"] = "ic_fluent_lightbulb_filament_24_filled.png",
    ["lightbulb-filament"] = "ic_fluent_lightbulb_filament_24_filled.png",
    ["lightbulb_filament"] = "ic_fluent_lightbulb_filament_24_filled.png",
    ["likert"] = "ic_fluent_likert_24_filled.png",
    ["linestyle"] = "ic_fluent_line_style_24_filled.png",
    ["line-style"] = "ic_fluent_line_style_24_filled.png",
    ["line_style"] = "ic_fluent_line_style_24_filled.png",
    ["link"] = "ic_fluent_link_24_filled.png",
    ["linkdismiss"] = "ic_fluent_link_dismiss_24_filled.png",
    ["link-dismiss"] = "ic_fluent_link_dismiss_24_filled.png",
    ["link_dismiss"] = "ic_fluent_link_dismiss_24_filled.png",
    ["linkedit"] = "ic_fluent_link_edit_24_filled.png",
    ["link-edit"] = "ic_fluent_link_edit_24_filled.png",
    ["link_edit"] = "ic_fluent_link_edit_24_filled.png",
    ["linksquare"] = "ic_fluent_link_square_24_filled.png",
    ["link-square"] = "ic_fluent_link_square_24_filled.png",
    ["link_square"] = "ic_fluent_link_square_24_filled.png",
    ["list"] = "ic_fluent_list_24_filled.png",
    ["live"] = "ic_fluent_live_24_filled.png",
    ["liveoff"] = "ic_fluent_live_off_24_filled.png",
    ["live-off"] = "ic_fluent_live_off_24_filled.png",
    ["live_off"] = "ic_fluent_live_off_24_filled.png",
    ["locallanguage"] = "ic_fluent_local_language_24_filled.png",
    ["local-language"] = "ic_fluent_local_language_24_filled.png",
    ["local_language"] = "ic_fluent_local_language_24_filled.png",
    ["locallanguagezi"] = "ic_fluent_local_language_zi_24_filled.png",
    ["local-language-zi"] = "ic_fluent_local_language_zi_24_filled.png",
    ["local_language_zi"] = "ic_fluent_local_language_zi_24_filled.png",
    ["location"] = "ic_fluent_location_24_filled.png",
    ["locationdismiss"] = "ic_fluent_location_dismiss_24_filled.png",
    ["location-dismiss"] = "ic_fluent_location_dismiss_24_filled.png",
    ["location_dismiss"] = "ic_fluent_location_dismiss_24_filled.png",
    ["locationlive"] = "ic_fluent_location_live_24_filled.png",
    ["location-live"] = "ic_fluent_location_live_24_filled.png",
    ["location_live"] = "ic_fluent_location_live_24_filled.png",
    ["locationoff"] = "ic_fluent_location_off_24_filled.png",
    ["location-off"] = "ic_fluent_location_off_24_filled.png",
    ["location_off"] = "ic_fluent_location_off_24_filled.png",
    ["lockclosed"] = "ic_fluent_lock_closed_24_filled.png",
    ["lock-closed"] = "ic_fluent_lock_closed_24_filled.png",
    ["lock_closed"] = "ic_fluent_lock_closed_24_filled.png",
    ["lockmultiple"] = "ic_fluent_lock_multiple_24_filled.png",
    ["lock-multiple"] = "ic_fluent_lock_multiple_24_filled.png",
    ["lock_multiple"] = "ic_fluent_lock_multiple_24_filled.png",
    ["lockopen"] = "ic_fluent_lock_open_24_filled.png",
    ["lock-open"] = "ic_fluent_lock_open_24_filled.png",
    ["lock_open"] = "ic_fluent_lock_open_24_filled.png",
    ["lockshield"] = "ic_fluent_lock_shield_24_filled.png",
    ["lock-shield"] = "ic_fluent_lock_shield_24_filled.png",
    ["lock_shield"] = "ic_fluent_lock_shield_24_filled.png",
    ["lottery"] = "ic_fluent_lottery_24_filled.png",
    ["luggage"] = "ic_fluent_luggage_24_filled.png",
    ["mail"] = "ic_fluent_mail_24_filled.png",
    ["mailadd"] = "ic_fluent_mail_add_24_filled.png",
    ["mail-add"] = "ic_fluent_mail_add_24_filled.png",
    ["mail_add"] = "ic_fluent_mail_add_24_filled.png",
    ["mailalert"] = "ic_fluent_mail_alert_24_filled.png",
    ["mail-alert"] = "ic_fluent_mail_alert_24_filled.png",
    ["mail_alert"] = "ic_fluent_mail_alert_24_filled.png",
    ["mailall"] = "ic_fluent_mail_all_24_filled.png",
    ["mail-all"] = "ic_fluent_mail_all_24_filled.png",
    ["mail_all"] = "ic_fluent_mail_all_24_filled.png",
    ["mailarrowup"] = "ic_fluent_mail_arrow_up_24_filled.png",
    ["mail-arrow-up"] = "ic_fluent_mail_arrow_up_24_filled.png",
    ["mail_arrow_up"] = "ic_fluent_mail_arrow_up_24_filled.png",
    ["mailclock"] = "ic_fluent_mail_clock_24_filled.png",
    ["mail-clock"] = "ic_fluent_mail_clock_24_filled.png",
    ["mail_clock"] = "ic_fluent_mail_clock_24_filled.png",
    ["mailcopy"] = "ic_fluent_mail_copy_24_filled.png",
    ["mail-copy"] = "ic_fluent_mail_copy_24_filled.png",
    ["mail_copy"] = "ic_fluent_mail_copy_24_filled.png",
    ["maildismiss"] = "ic_fluent_mail_dismiss_24_filled.png",
    ["mail-dismiss"] = "ic_fluent_mail_dismiss_24_filled.png",
    ["mail_dismiss"] = "ic_fluent_mail_dismiss_24_filled.png",
    ["mailerror"] = "ic_fluent_mail_error_24_filled.png",
    ["mail-error"] = "ic_fluent_mail_error_24_filled.png",
    ["mail_error"] = "ic_fluent_mail_error_24_filled.png",
    ["mailinbox"] = "ic_fluent_mail_inbox_24_filled.png",
    ["mail-inbox"] = "ic_fluent_mail_inbox_24_filled.png",
    ["mail_inbox"] = "ic_fluent_mail_inbox_24_filled.png",
    ["mailinboxadd"] = "ic_fluent_mail_inbox_add_24_filled.png",
    ["mail-inbox-add"] = "ic_fluent_mail_inbox_add_24_filled.png",
    ["mail_inbox_add"] = "ic_fluent_mail_inbox_add_24_filled.png",
    ["mailinboxall"] = "ic_fluent_mail_inbox_all_24_filled.png",
    ["mail-inbox-all"] = "ic_fluent_mail_inbox_all_24_filled.png",
    ["mail_inbox_all"] = "ic_fluent_mail_inbox_all_24_filled.png",
    ["mailinboxarrowright"] = "ic_fluent_mail_inbox_arrow_right_24_filled.png",
    ["mail-inbox-arrow-right"] = "ic_fluent_mail_inbox_arrow_right_24_filled.png",
    ["mail_inbox_arrow_right"] = "ic_fluent_mail_inbox_arrow_right_24_filled.png",
    ["mailinboxarrowup"] = "ic_fluent_mail_inbox_arrow_up_24_filled.png",
    ["mail-inbox-arrow-up"] = "ic_fluent_mail_inbox_arrow_up_24_filled.png",
    ["mail_inbox_arrow_up"] = "ic_fluent_mail_inbox_arrow_up_24_filled.png",
    ["mailinboxcheckmark"] = "ic_fluent_mail_inbox_checkmark_24_filled.png",
    ["mail-inbox-checkmark"] = "ic_fluent_mail_inbox_checkmark_24_filled.png",
    ["mail_inbox_checkmark"] = "ic_fluent_mail_inbox_checkmark_24_filled.png",
    ["mailinboxdismiss"] = "ic_fluent_mail_inbox_dismiss_24_filled.png",
    ["mail-inbox-dismiss"] = "ic_fluent_mail_inbox_dismiss_24_filled.png",
    ["mail_inbox_dismiss"] = "ic_fluent_mail_inbox_dismiss_24_filled.png",
    ["maillink"] = "ic_fluent_mail_link_24_filled.png",
    ["mail-link"] = "ic_fluent_mail_link_24_filled.png",
    ["mail_link"] = "ic_fluent_mail_link_24_filled.png",
    ["mailmultiple"] = "ic_fluent_mail_multiple_24_filled.png",
    ["mail-multiple"] = "ic_fluent_mail_multiple_24_filled.png",
    ["mail_multiple"] = "ic_fluent_mail_multiple_24_filled.png",
    ["mailoff"] = "ic_fluent_mail_off_24_filled.png",
    ["mail-off"] = "ic_fluent_mail_off_24_filled.png",
    ["mail_off"] = "ic_fluent_mail_off_24_filled.png",
    ["mailprohibited"] = "ic_fluent_mail_prohibited_24_filled.png",
    ["mail-prohibited"] = "ic_fluent_mail_prohibited_24_filled.png",
    ["mail_prohibited"] = "ic_fluent_mail_prohibited_24_filled.png",
    ["mailread"] = "ic_fluent_mail_read_24_filled.png",
    ["mail-read"] = "ic_fluent_mail_read_24_filled.png",
    ["mail_read"] = "ic_fluent_mail_read_24_filled.png",
    ["mailtemplate"] = "ic_fluent_mail_template_24_filled.png",
    ["mail-template"] = "ic_fluent_mail_template_24_filled.png",
    ["mail_template"] = "ic_fluent_mail_template_24_filled.png",
    ["mailunread"] = "ic_fluent_mail_unread_24_filled.png",
    ["mail-unread"] = "ic_fluent_mail_unread_24_filled.png",
    ["mail_unread"] = "ic_fluent_mail_unread_24_filled.png",
    ["map"] = "ic_fluent_map_24_filled.png",
    ["mapdrive"] = "ic_fluent_map_drive_24_filled.png",
    ["map-drive"] = "ic_fluent_map_drive_24_filled.png",
    ["map_drive"] = "ic_fluent_map_drive_24_filled.png",
    ["matchapplayout"] = "ic_fluent_match_app_layout_24_filled.png",
    ["match-app-layout"] = "ic_fluent_match_app_layout_24_filled.png",
    ["match_app_layout"] = "ic_fluent_match_app_layout_24_filled.png",
    ["mathformatlinear"] = "ic_fluent_math_format_linear_24_filled.png",
    ["math-format-linear"] = "ic_fluent_math_format_linear_24_filled.png",
    ["math_format_linear"] = "ic_fluent_math_format_linear_24_filled.png",
    ["mathformatprofessional"] = "ic_fluent_math_format_professional_24_filled.png",
    ["math-format-professional"] = "ic_fluent_math_format_professional_24_filled.png",
    ["math_format_professional"] = "ic_fluent_math_format_professional_24_filled.png",
    ["mathformula"] = "ic_fluent_math_formula_24_filled.png",
    ["math-formula"] = "ic_fluent_math_formula_24_filled.png",
    ["math_formula"] = "ic_fluent_math_formula_24_filled.png",
    ["maximize"] = "ic_fluent_maximize_24_filled.png",
    ["meetnow"] = "ic_fluent_meet_now_24_filled.png",
    ["meet-now"] = "ic_fluent_meet_now_24_filled.png",
    ["meet_now"] = "ic_fluent_meet_now_24_filled.png",
    ["megaphone"] = "ic_fluent_megaphone_24_filled.png",
    ["megaphoneoff"] = "ic_fluent_megaphone_off_24_filled.png",
    ["megaphone-off"] = "ic_fluent_megaphone_off_24_filled.png",
    ["megaphone_off"] = "ic_fluent_megaphone_off_24_filled.png",
    ["mention"] = "ic_fluent_mention_24_filled.png",
    ["merge"] = "ic_fluent_merge_24_filled.png",
    ["micoff"] = "ic_fluent_mic_off_24_filled.png",
    ["mic-off"] = "ic_fluent_mic_off_24_filled.png",
    ["mic_off"] = "ic_fluent_mic_off_24_filled.png",
    ["micon"] = "ic_fluent_mic_on_24_filled.png",
    ["mic-on"] = "ic_fluent_mic_on_24_filled.png",
    ["mic_on"] = "ic_fluent_mic_on_24_filled.png",
    ["micprohibited"] = "ic_fluent_mic_prohibited_24_filled.png",
    ["mic-prohibited"] = "ic_fluent_mic_prohibited_24_filled.png",
    ["mic_prohibited"] = "ic_fluent_mic_prohibited_24_filled.png",
    ["micsettings"] = "ic_fluent_mic_settings_24_filled.png",
    ["mic-settings"] = "ic_fluent_mic_settings_24_filled.png",
    ["mic_settings"] = "ic_fluent_mic_settings_24_filled.png",
    ["micsparkle"] = "ic_fluent_mic_sparkle_24_filled.png",
    ["mic-sparkle"] = "ic_fluent_mic_sparkle_24_filled.png",
    ["mic_sparkle"] = "ic_fluent_mic_sparkle_24_filled.png",
    ["microscope"] = "ic_fluent_microscope_24_filled.png",
    ["midi"] = "ic_fluent_midi_24_filled.png",
    ["mobileoptimized"] = "ic_fluent_mobile_optimized_24_filled.png",
    ["mobile-optimized"] = "ic_fluent_mobile_optimized_24_filled.png",
    ["mobile_optimized"] = "ic_fluent_mobile_optimized_24_filled.png",
    ["molecule"] = "ic_fluent_molecule_24_filled.png",
    ["money"] = "ic_fluent_money_24_filled.png",
    ["moneycalculator"] = "ic_fluent_money_calculator_24_filled.png",
    ["money-calculator"] = "ic_fluent_money_calculator_24_filled.png",
    ["money_calculator"] = "ic_fluent_money_calculator_24_filled.png",
    ["morehorizontal"] = "ic_fluent_more_horizontal_24_filled.png",
    ["more-horizontal"] = "ic_fluent_more_horizontal_24_filled.png",
    ["more_horizontal"] = "ic_fluent_more_horizontal_24_filled.png",
    ["morevertical"] = "ic_fluent_more_vertical_24_filled.png",
    ["more-vertical"] = "ic_fluent_more_vertical_24_filled.png",
    ["more_vertical"] = "ic_fluent_more_vertical_24_filled.png",
    ["moviesandtv"] = "ic_fluent_movies_and_tv_24_filled.png",
    ["movies-and-tv"] = "ic_fluent_movies_and_tv_24_filled.png",
    ["movies_and_tv"] = "ic_fluent_movies_and_tv_24_filled.png",
    ["multiplier12x"] = "ic_fluent_multiplier_1_2x_24_filled.png",
    ["multiplier15x"] = "ic_fluent_multiplier_1_5x_24_filled.png",
    ["multiplier18x"] = "ic_fluent_multiplier_1_8x_24_filled.png",
    ["multiplier1x"] = "ic_fluent_multiplier_1x_24_filled.png",
    ["multiplier2x"] = "ic_fluent_multiplier_2x_24_filled.png",
    ["multiplier5x"] = "ic_fluent_multiplier_5x_24_filled.png",
    ["multiselect"] = "ic_fluent_multiselect_24_filled.png",
    ["musicnote1"] = "ic_fluent_music_note_1_24_filled.png",
    ["music-note1"] = "ic_fluent_music_note_1_24_filled.png",
    ["music_note1"] = "ic_fluent_music_note_1_24_filled.png",
    ["musicnote2"] = "ic_fluent_music_note_2_24_filled.png",
    ["music-note2"] = "ic_fluent_music_note_2_24_filled.png",
    ["music_note2"] = "ic_fluent_music_note_2_24_filled.png",
    ["mylocation"] = "ic_fluent_my_location_24_filled.png",
    ["my-location"] = "ic_fluent_my_location_24_filled.png",
    ["my_location"] = "ic_fluent_my_location_24_filled.png",
    ["navigation"] = "ic_fluent_navigation_24_filled.png",
    ["navigationunread"] = "ic_fluent_navigation_unread_24_filled.png",
    ["navigation-unread"] = "ic_fluent_navigation_unread_24_filled.png",
    ["navigation_unread"] = "ic_fluent_navigation_unread_24_filled.png",
    ["networkcheck"] = "ic_fluent_network_check_24_filled.png",
    ["network-check"] = "ic_fluent_network_check_24_filled.png",
    ["network_check"] = "ic_fluent_network_check_24_filled.png",
    ["new"] = "ic_fluent_new_24_filled.png",
    ["news"] = "ic_fluent_news_24_filled.png",
    ["next"] = "ic_fluent_next_24_filled.png",
    ["note"] = "ic_fluent_note_24_filled.png",
    ["noteadd"] = "ic_fluent_note_add_24_filled.png",
    ["note-add"] = "ic_fluent_note_add_24_filled.png",
    ["note_add"] = "ic_fluent_note_add_24_filled.png",
    ["noteedit"] = "ic_fluent_note_edit_24_filled.png",
    ["note-edit"] = "ic_fluent_note_edit_24_filled.png",
    ["note_edit"] = "ic_fluent_note_edit_24_filled.png",
    ["notebook"] = "ic_fluent_notebook_24_filled.png",
    ["notebookadd"] = "ic_fluent_notebook_add_24_filled.png",
    ["notebook-add"] = "ic_fluent_notebook_add_24_filled.png",
    ["notebook_add"] = "ic_fluent_notebook_add_24_filled.png",
    ["notebookerror"] = "ic_fluent_notebook_error_24_filled.png",
    ["notebook-error"] = "ic_fluent_notebook_error_24_filled.png",
    ["notebook_error"] = "ic_fluent_notebook_error_24_filled.png",
    ["notebooklightning"] = "ic_fluent_notebook_lightning_24_filled.png",
    ["notebook-lightning"] = "ic_fluent_notebook_lightning_24_filled.png",
    ["notebook_lightning"] = "ic_fluent_notebook_lightning_24_filled.png",
    ["notebookquestionmark"] = "ic_fluent_notebook_question_mark_24_filled.png",
    ["notebook-question-mark"] = "ic_fluent_notebook_question_mark_24_filled.png",
    ["notebook_question_mark"] = "ic_fluent_notebook_question_mark_24_filled.png",
    ["notebooksection"] = "ic_fluent_notebook_section_24_filled.png",
    ["notebook-section"] = "ic_fluent_notebook_section_24_filled.png",
    ["notebook_section"] = "ic_fluent_notebook_section_24_filled.png",
    ["notebooksectionarrowright"] = "ic_fluent_notebook_section_arrow_right_24_filled.png",
    ["notebook-section-arrow-right"] = "ic_fluent_notebook_section_arrow_right_24_filled.png",
    ["notebook_section_arrow_right"] = "ic_fluent_notebook_section_arrow_right_24_filled.png",
    ["notebooksubsection"] = "ic_fluent_notebook_subsection_24_filled.png",
    ["notebook-subsection"] = "ic_fluent_notebook_subsection_24_filled.png",
    ["notebook_subsection"] = "ic_fluent_notebook_subsection_24_filled.png",
    ["notebooksync"] = "ic_fluent_notebook_sync_24_filled.png",
    ["notebook-sync"] = "ic_fluent_notebook_sync_24_filled.png",
    ["notebook_sync"] = "ic_fluent_notebook_sync_24_filled.png",
    ["notepad"] = "ic_fluent_notepad_24_filled.png",
    ["notepadperson"] = "ic_fluent_notepad_person_24_filled.png",
    ["notepad-person"] = "ic_fluent_notepad_person_24_filled.png",
    ["notepad_person"] = "ic_fluent_notepad_person_24_filled.png",
    ["numberrow"] = "ic_fluent_number_row_24_filled.png",
    ["number-row"] = "ic_fluent_number_row_24_filled.png",
    ["number_row"] = "ic_fluent_number_row_24_filled.png",
    ["numbersymbol"] = "ic_fluent_number_symbol_24_filled.png",
    ["number-symbol"] = "ic_fluent_number_symbol_24_filled.png",
    ["number_symbol"] = "ic_fluent_number_symbol_24_filled.png",
    ["numbersymboldismiss"] = "ic_fluent_number_symbol_dismiss_24_filled.png",
    ["number-symbol-dismiss"] = "ic_fluent_number_symbol_dismiss_24_filled.png",
    ["number_symbol_dismiss"] = "ic_fluent_number_symbol_dismiss_24_filled.png",
    ["numbersymbolsquare"] = "ic_fluent_number_symbol_square_24_filled.png",
    ["number-symbol-square"] = "ic_fluent_number_symbol_square_24_filled.png",
    ["number_symbol_square"] = "ic_fluent_number_symbol_square_24_filled.png",
    ["officeapps"] = "ic_fluent_office_apps_24_filled.png",
    ["office-apps"] = "ic_fluent_office_apps_24_filled.png",
    ["office_apps"] = "ic_fluent_office_apps_24_filled.png",
    ["open"] = "ic_fluent_open_24_filled.png",
    ["openfolder"] = "ic_fluent_open_folder_24_filled.png",
    ["open-folder"] = "ic_fluent_open_folder_24_filled.png",
    ["open_folder"] = "ic_fluent_open_folder_24_filled.png",
    ["openoff"] = "ic_fluent_open_off_24_filled.png",
    ["open-off"] = "ic_fluent_open_off_24_filled.png",
    ["open_off"] = "ic_fluent_open_off_24_filled.png",
    ["options"] = "ic_fluent_options_24_filled.png",
    ["organization"] = "ic_fluent_organization_24_filled.png",
    ["orientation"] = "ic_fluent_orientation_24_filled.png",
    ["paddingdown"] = "ic_fluent_padding_down_24_filled.png",
    ["padding-down"] = "ic_fluent_padding_down_24_filled.png",
    ["padding_down"] = "ic_fluent_padding_down_24_filled.png",
    ["paddingleft"] = "ic_fluent_padding_left_24_filled.png",
    ["padding-left"] = "ic_fluent_padding_left_24_filled.png",
    ["padding_left"] = "ic_fluent_padding_left_24_filled.png",
    ["paddingright"] = "ic_fluent_padding_right_24_filled.png",
    ["padding-right"] = "ic_fluent_padding_right_24_filled.png",
    ["padding_right"] = "ic_fluent_padding_right_24_filled.png",
    ["paddingtop"] = "ic_fluent_padding_top_24_filled.png",
    ["padding-top"] = "ic_fluent_padding_top_24_filled.png",
    ["padding_top"] = "ic_fluent_padding_top_24_filled.png",
    ["pagefit"] = "ic_fluent_page_fit_24_filled.png",
    ["page-fit"] = "ic_fluent_page_fit_24_filled.png",
    ["page_fit"] = "ic_fluent_page_fit_24_filled.png",
    ["paintbrush"] = "ic_fluent_paint_brush_24_filled.png",
    ["paint-brush"] = "ic_fluent_paint_brush_24_filled.png",
    ["paint_brush"] = "ic_fluent_paint_brush_24_filled.png",
    ["paintbrusharrowdown"] = "ic_fluent_paint_brush_arrow_down_24_filled.png",
    ["paint-brush-arrow-down"] = "ic_fluent_paint_brush_arrow_down_24_filled.png",
    ["paint_brush_arrow_down"] = "ic_fluent_paint_brush_arrow_down_24_filled.png",
    ["paintbrusharrowup"] = "ic_fluent_paint_brush_arrow_up_24_filled.png",
    ["paint-brush-arrow-up"] = "ic_fluent_paint_brush_arrow_up_24_filled.png",
    ["paint_brush_arrow_up"] = "ic_fluent_paint_brush_arrow_up_24_filled.png",
    ["paintbucket"] = "ic_fluent_paint_bucket_24_filled.png",
    ["paint-bucket"] = "ic_fluent_paint_bucket_24_filled.png",
    ["paint_bucket"] = "ic_fluent_paint_bucket_24_filled.png",
    ["pair"] = "ic_fluent_pair_24_filled.png",
    ["paneclose"] = "ic_fluent_pane_close_24_filled.png",
    ["pane-close"] = "ic_fluent_pane_close_24_filled.png",
    ["pane_close"] = "ic_fluent_pane_close_24_filled.png",
    ["paneopen"] = "ic_fluent_pane_open_24_filled.png",
    ["pane-open"] = "ic_fluent_pane_open_24_filled.png",
    ["pane_open"] = "ic_fluent_pane_open_24_filled.png",
    ["panelleft"] = "ic_fluent_panel_left_24_filled.png",
    ["panel-left"] = "ic_fluent_panel_left_24_filled.png",
    ["panel_left"] = "ic_fluent_panel_left_24_filled.png",
    ["panelright"] = "ic_fluent_panel_right_24_filled.png",
    ["panel-right"] = "ic_fluent_panel_right_24_filled.png",
    ["panel_right"] = "ic_fluent_panel_right_24_filled.png",
    ["panelrightcontract"] = "ic_fluent_panel_right_contract_24_filled.png",
    ["panel-right-contract"] = "ic_fluent_panel_right_contract_24_filled.png",
    ["panel_right_contract"] = "ic_fluent_panel_right_contract_24_filled.png",
    ["panelrightexpand"] = "ic_fluent_panel_right_expand_24_filled.png",
    ["panel-right-expand"] = "ic_fluent_panel_right_expand_24_filled.png",
    ["panel_right_expand"] = "ic_fluent_panel_right_expand_24_filled.png",
    ["password"] = "ic_fluent_password_24_filled.png",
    ["patch"] = "ic_fluent_patch_24_filled.png",
    ["patient"] = "ic_fluent_patient_24_filled.png",
    ["pause"] = "ic_fluent_pause_24_filled.png",
    ["pausecircle"] = "ic_fluent_pause_circle_24_filled.png",
    ["pause-circle"] = "ic_fluent_pause_circle_24_filled.png",
    ["pause_circle"] = "ic_fluent_pause_circle_24_filled.png",
    ["payment"] = "ic_fluent_payment_24_filled.png",
    ["people"] = "ic_fluent_people_24_filled.png",
    ["peopleadd"] = "ic_fluent_people_add_24_filled.png",
    ["people-add"] = "ic_fluent_people_add_24_filled.png",
    ["people_add"] = "ic_fluent_people_add_24_filled.png",
    ["peopleaudience"] = "ic_fluent_people_audience_24_filled.png",
    ["people-audience"] = "ic_fluent_people_audience_24_filled.png",
    ["people_audience"] = "ic_fluent_people_audience_24_filled.png",
    ["peoplecheckmark"] = "ic_fluent_people_checkmark_24_filled.png",
    ["people-checkmark"] = "ic_fluent_people_checkmark_24_filled.png",
    ["people_checkmark"] = "ic_fluent_people_checkmark_24_filled.png",
    ["peoplecommunity"] = "ic_fluent_people_community_24_filled.png",
    ["people-community"] = "ic_fluent_people_community_24_filled.png",
    ["people_community"] = "ic_fluent_people_community_24_filled.png",
    ["peoplecommunityadd"] = "ic_fluent_people_community_add_24_filled.png",
    ["people-community-add"] = "ic_fluent_people_community_add_24_filled.png",
    ["people_community_add"] = "ic_fluent_people_community_add_24_filled.png",
    ["peopleerror"] = "ic_fluent_people_error_24_filled.png",
    ["people-error"] = "ic_fluent_people_error_24_filled.png",
    ["people_error"] = "ic_fluent_people_error_24_filled.png",
    ["peoplemoney"] = "ic_fluent_people_money_24_filled.png",
    ["people-money"] = "ic_fluent_people_money_24_filled.png",
    ["people_money"] = "ic_fluent_people_money_24_filled.png",
    ["peoplesearch"] = "ic_fluent_people_search_24_filled.png",
    ["people-search"] = "ic_fluent_people_search_24_filled.png",
    ["people_search"] = "ic_fluent_people_search_24_filled.png",
    ["peoplesettings"] = "ic_fluent_people_settings_24_filled.png",
    ["people-settings"] = "ic_fluent_people_settings_24_filled.png",
    ["people_settings"] = "ic_fluent_people_settings_24_filled.png",
    ["peopleswap"] = "ic_fluent_people_swap_24_filled.png",
    ["people-swap"] = "ic_fluent_people_swap_24_filled.png",
    ["people_swap"] = "ic_fluent_people_swap_24_filled.png",
    ["peopleteam"] = "ic_fluent_people_team_24_filled.png",
    ["people-team"] = "ic_fluent_people_team_24_filled.png",
    ["people_team"] = "ic_fluent_people_team_24_filled.png",
    ["peopleteamadd"] = "ic_fluent_people_team_add_24_filled.png",
    ["people-team-add"] = "ic_fluent_people_team_add_24_filled.png",
    ["people_team_add"] = "ic_fluent_people_team_add_24_filled.png",
    ["peopleteamdelete"] = "ic_fluent_people_team_delete_24_filled.png",
    ["people-team-delete"] = "ic_fluent_people_team_delete_24_filled.png",
    ["people_team_delete"] = "ic_fluent_people_team_delete_24_filled.png",
    ["peopleteamtoolbox"] = "ic_fluent_people_team_toolbox_24_filled.png",
    ["people-team-toolbox"] = "ic_fluent_people_team_toolbox_24_filled.png",
    ["people_team_toolbox"] = "ic_fluent_people_team_toolbox_24_filled.png",
    ["person"] = "ic_fluent_person_24_filled.png",
    ["personaccounts"] = "ic_fluent_person_accounts_24_filled.png",
    ["person-accounts"] = "ic_fluent_person_accounts_24_filled.png",
    ["person_accounts"] = "ic_fluent_person_accounts_24_filled.png",
    ["personadd"] = "ic_fluent_person_add_24_filled.png",
    ["person-add"] = "ic_fluent_person_add_24_filled.png",
    ["person_add"] = "ic_fluent_person_add_24_filled.png",
    ["personarrowleft"] = "ic_fluent_person_arrow_left_24_filled.png",
    ["person-arrow-left"] = "ic_fluent_person_arrow_left_24_filled.png",
    ["person_arrow_left"] = "ic_fluent_person_arrow_left_24_filled.png",
    ["personarrowright"] = "ic_fluent_person_arrow_right_24_filled.png",
    ["person-arrow-right"] = "ic_fluent_person_arrow_right_24_filled.png",
    ["person_arrow_right"] = "ic_fluent_person_arrow_right_24_filled.png",
    ["personavailable"] = "ic_fluent_person_available_24_filled.png",
    ["person-available"] = "ic_fluent_person_available_24_filled.png",
    ["person_available"] = "ic_fluent_person_available_24_filled.png",
    ["personboard"] = "ic_fluent_person_board_24_filled.png",
    ["person-board"] = "ic_fluent_person_board_24_filled.png",
    ["person_board"] = "ic_fluent_person_board_24_filled.png",
    ["personcall"] = "ic_fluent_person_call_24_filled.png",
    ["person-call"] = "ic_fluent_person_call_24_filled.png",
    ["person_call"] = "ic_fluent_person_call_24_filled.png",
    ["personchat"] = "ic_fluent_person_chat_24_filled.png",
    ["person-chat"] = "ic_fluent_person_chat_24_filled.png",
    ["person_chat"] = "ic_fluent_person_chat_24_filled.png",
    ["personclock"] = "ic_fluent_person_clock_24_filled.png",
    ["person-clock"] = "ic_fluent_person_clock_24_filled.png",
    ["person_clock"] = "ic_fluent_person_clock_24_filled.png",
    ["persondelete"] = "ic_fluent_person_delete_24_filled.png",
    ["person-delete"] = "ic_fluent_person_delete_24_filled.png",
    ["person_delete"] = "ic_fluent_person_delete_24_filled.png",
    ["personfeedback"] = "ic_fluent_person_feedback_24_filled.png",
    ["person-feedback"] = "ic_fluent_person_feedback_24_filled.png",
    ["person_feedback"] = "ic_fluent_person_feedback_24_filled.png",
    ["personlock"] = "ic_fluent_person_lock_24_filled.png",
    ["person-lock"] = "ic_fluent_person_lock_24_filled.png",
    ["person_lock"] = "ic_fluent_person_lock_24_filled.png",
    ["personmail"] = "ic_fluent_person_mail_24_filled.png",
    ["person-mail"] = "ic_fluent_person_mail_24_filled.png",
    ["person_mail"] = "ic_fluent_person_mail_24_filled.png",
    ["personmoney"] = "ic_fluent_person_money_24_filled.png",
    ["person-money"] = "ic_fluent_person_money_24_filled.png",
    ["person_money"] = "ic_fluent_person_money_24_filled.png",
    ["personnote"] = "ic_fluent_person_note_24_filled.png",
    ["person-note"] = "ic_fluent_person_note_24_filled.png",
    ["person_note"] = "ic_fluent_person_note_24_filled.png",
    ["personpill"] = "ic_fluent_person_pill_24_filled.png",
    ["person-pill"] = "ic_fluent_person_pill_24_filled.png",
    ["person_pill"] = "ic_fluent_person_pill_24_filled.png",
    ["personprohibited"] = "ic_fluent_person_prohibited_24_filled.png",
    ["person-prohibited"] = "ic_fluent_person_prohibited_24_filled.png",
    ["person_prohibited"] = "ic_fluent_person_prohibited_24_filled.png",
    ["personquestionmark"] = "ic_fluent_person_question_mark_24_filled.png",
    ["person-question-mark"] = "ic_fluent_person_question_mark_24_filled.png",
    ["person_question_mark"] = "ic_fluent_person_question_mark_24_filled.png",
    ["personsupport"] = "ic_fluent_person_support_24_filled.png",
    ["person-support"] = "ic_fluent_person_support_24_filled.png",
    ["person_support"] = "ic_fluent_person_support_24_filled.png",
    ["personswap"] = "ic_fluent_person_swap_24_filled.png",
    ["person-swap"] = "ic_fluent_person_swap_24_filled.png",
    ["person_swap"] = "ic_fluent_person_swap_24_filled.png",
    ["personvoice"] = "ic_fluent_person_voice_24_filled.png",
    ["person-voice"] = "ic_fluent_person_voice_24_filled.png",
    ["person_voice"] = "ic_fluent_person_voice_24_filled.png",
    ["phone"] = "ic_fluent_phone_24_filled.png",
    ["phoneadd"] = "ic_fluent_phone_add_24_filled.png",
    ["phone-add"] = "ic_fluent_phone_add_24_filled.png",
    ["phone_add"] = "ic_fluent_phone_add_24_filled.png",
    ["phonearrowright"] = "ic_fluent_phone_arrow_right_24_filled.png",
    ["phone-arrow-right"] = "ic_fluent_phone_arrow_right_24_filled.png",
    ["phone_arrow_right"] = "ic_fluent_phone_arrow_right_24_filled.png",
    ["phonedesktop"] = "ic_fluent_phone_desktop_24_filled.png",
    ["phone-desktop"] = "ic_fluent_phone_desktop_24_filled.png",
    ["phone_desktop"] = "ic_fluent_phone_desktop_24_filled.png",
    ["phonedismiss"] = "ic_fluent_phone_dismiss_24_filled.png",
    ["phone-dismiss"] = "ic_fluent_phone_dismiss_24_filled.png",
    ["phone_dismiss"] = "ic_fluent_phone_dismiss_24_filled.png",
    ["phonelaptop"] = "ic_fluent_phone_laptop_24_filled.png",
    ["phone-laptop"] = "ic_fluent_phone_laptop_24_filled.png",
    ["phone_laptop"] = "ic_fluent_phone_laptop_24_filled.png",
    ["phonelinksetup"] = "ic_fluent_phone_link_setup_24_filled.png",
    ["phone-link-setup"] = "ic_fluent_phone_link_setup_24_filled.png",
    ["phone_link_setup"] = "ic_fluent_phone_link_setup_24_filled.png",
    ["phonelock"] = "ic_fluent_phone_lock_24_filled.png",
    ["phone-lock"] = "ic_fluent_phone_lock_24_filled.png",
    ["phone_lock"] = "ic_fluent_phone_lock_24_filled.png",
    ["phonepageheader"] = "ic_fluent_phone_page_header_24_filled.png",
    ["phone-page-header"] = "ic_fluent_phone_page_header_24_filled.png",
    ["phone_page_header"] = "ic_fluent_phone_page_header_24_filled.png",
    ["phonepagination"] = "ic_fluent_phone_pagination_24_filled.png",
    ["phone-pagination"] = "ic_fluent_phone_pagination_24_filled.png",
    ["phone_pagination"] = "ic_fluent_phone_pagination_24_filled.png",
    ["phonescreentime"] = "ic_fluent_phone_screen_time_24_filled.png",
    ["phone-screen-time"] = "ic_fluent_phone_screen_time_24_filled.png",
    ["phone_screen_time"] = "ic_fluent_phone_screen_time_24_filled.png",
    ["phoneshake"] = "ic_fluent_phone_shake_24_filled.png",
    ["phone-shake"] = "ic_fluent_phone_shake_24_filled.png",
    ["phone_shake"] = "ic_fluent_phone_shake_24_filled.png",
    ["phonespanin"] = "ic_fluent_phone_span_in_24_filled.png",
    ["phone-span-in"] = "ic_fluent_phone_span_in_24_filled.png",
    ["phone_span_in"] = "ic_fluent_phone_span_in_24_filled.png",
    ["phonespanout"] = "ic_fluent_phone_span_out_24_filled.png",
    ["phone-span-out"] = "ic_fluent_phone_span_out_24_filled.png",
    ["phone_span_out"] = "ic_fluent_phone_span_out_24_filled.png",
    ["phonespeaker"] = "ic_fluent_phone_speaker_24_filled.png",
    ["phone-speaker"] = "ic_fluent_phone_speaker_24_filled.png",
    ["phone_speaker"] = "ic_fluent_phone_speaker_24_filled.png",
    ["phonestatusbar"] = "ic_fluent_phone_status_bar_24_filled.png",
    ["phone-status-bar"] = "ic_fluent_phone_status_bar_24_filled.png",
    ["phone_status_bar"] = "ic_fluent_phone_status_bar_24_filled.png",
    ["phonetablet"] = "ic_fluent_phone_tablet_24_filled.png",
    ["phone-tablet"] = "ic_fluent_phone_tablet_24_filled.png",
    ["phone_tablet"] = "ic_fluent_phone_tablet_24_filled.png",
    ["phoneupdate"] = "ic_fluent_phone_update_24_filled.png",
    ["phone-update"] = "ic_fluent_phone_update_24_filled.png",
    ["phone_update"] = "ic_fluent_phone_update_24_filled.png",
    ["phoneverticalscroll"] = "ic_fluent_phone_vertical_scroll_24_filled.png",
    ["phone-vertical-scroll"] = "ic_fluent_phone_vertical_scroll_24_filled.png",
    ["phone_vertical_scroll"] = "ic_fluent_phone_vertical_scroll_24_filled.png",
    ["phonevibrate"] = "ic_fluent_phone_vibrate_24_filled.png",
    ["phone-vibrate"] = "ic_fluent_phone_vibrate_24_filled.png",
    ["phone_vibrate"] = "ic_fluent_phone_vibrate_24_filled.png",
    ["photofilter"] = "ic_fluent_photo_filter_24_filled.png",
    ["photo-filter"] = "ic_fluent_photo_filter_24_filled.png",
    ["photo_filter"] = "ic_fluent_photo_filter_24_filled.png",
    ["pi"] = "ic_fluent_pi_24_filled.png",
    ["pictureinpicture"] = "ic_fluent_picture_in_picture_24_filled.png",
    ["picture-in-picture"] = "ic_fluent_picture_in_picture_24_filled.png",
    ["picture_in_picture"] = "ic_fluent_picture_in_picture_24_filled.png",
    ["pill"] = "ic_fluent_pill_24_filled.png",
    ["pin"] = "ic_fluent_pin_24_filled.png",
    ["pinoff"] = "ic_fluent_pin_off_24_filled.png",
    ["pin-off"] = "ic_fluent_pin_off_24_filled.png",
    ["pin_off"] = "ic_fluent_pin_off_24_filled.png",
    ["pivot"] = "ic_fluent_pivot_24_filled.png",
    ["play"] = "ic_fluent_play_24_filled.png",
    ["playcircle"] = "ic_fluent_play_circle_24_filled.png",
    ["play-circle"] = "ic_fluent_play_circle_24_filled.png",
    ["play_circle"] = "ic_fluent_play_circle_24_filled.png",
    ["plugdisconnected"] = "ic_fluent_plug_disconnected_24_filled.png",
    ["plug-disconnected"] = "ic_fluent_plug_disconnected_24_filled.png",
    ["plug_disconnected"] = "ic_fluent_plug_disconnected_24_filled.png",
    ["pointscan"] = "ic_fluent_point_scan_24_filled.png",
    ["point-scan"] = "ic_fluent_point_scan_24_filled.png",
    ["point_scan"] = "ic_fluent_point_scan_24_filled.png",
    ["poll"] = "ic_fluent_poll_24_filled.png",
    ["porthdmi"] = "ic_fluent_port_hdmi_24_filled.png",
    ["port-hdmi"] = "ic_fluent_port_hdmi_24_filled.png",
    ["port_hdmi"] = "ic_fluent_port_hdmi_24_filled.png",
    ["portmicrousb"] = "ic_fluent_port_micro_usb_24_filled.png",
    ["port-micro-usb"] = "ic_fluent_port_micro_usb_24_filled.png",
    ["port_micro_usb"] = "ic_fluent_port_micro_usb_24_filled.png",
    ["portusba"] = "ic_fluent_port_usb_a_24_filled.png",
    ["port-usb-a"] = "ic_fluent_port_usb_a_24_filled.png",
    ["port_usb_a"] = "ic_fluent_port_usb_a_24_filled.png",
    ["portusbc"] = "ic_fluent_port_usb_c_24_filled.png",
    ["port-usb-c"] = "ic_fluent_port_usb_c_24_filled.png",
    ["port_usb_c"] = "ic_fluent_port_usb_c_24_filled.png",
    ["positionbackward"] = "ic_fluent_position_backward_24_filled.png",
    ["position-backward"] = "ic_fluent_position_backward_24_filled.png",
    ["position_backward"] = "ic_fluent_position_backward_24_filled.png",
    ["positionforward"] = "ic_fluent_position_forward_24_filled.png",
    ["position-forward"] = "ic_fluent_position_forward_24_filled.png",
    ["position_forward"] = "ic_fluent_position_forward_24_filled.png",
    ["positiontoback"] = "ic_fluent_position_to_back_24_filled.png",
    ["position-to-back"] = "ic_fluent_position_to_back_24_filled.png",
    ["position_to_back"] = "ic_fluent_position_to_back_24_filled.png",
    ["positiontofront"] = "ic_fluent_position_to_front_24_filled.png",
    ["position-to-front"] = "ic_fluent_position_to_front_24_filled.png",
    ["position_to_front"] = "ic_fluent_position_to_front_24_filled.png",
    ["power"] = "ic_fluent_power_24_filled.png",
    ["predictions"] = "ic_fluent_predictions_24_filled.png",
    ["premium"] = "ic_fluent_premium_24_filled.png",
    ["premiumperson"] = "ic_fluent_premium_person_24_filled.png",
    ["premium-person"] = "ic_fluent_premium_person_24_filled.png",
    ["premium_person"] = "ic_fluent_premium_person_24_filled.png",
    ["presenter"] = "ic_fluent_presenter_24_filled.png",
    ["presenteroff"] = "ic_fluent_presenter_off_24_filled.png",
    ["presenter-off"] = "ic_fluent_presenter_off_24_filled.png",
    ["presenter_off"] = "ic_fluent_presenter_off_24_filled.png",
    ["previewlink"] = "ic_fluent_preview_link_24_filled.png",
    ["preview-link"] = "ic_fluent_preview_link_24_filled.png",
    ["preview_link"] = "ic_fluent_preview_link_24_filled.png",
    ["previous"] = "ic_fluent_previous_24_filled.png",
    ["print"] = "ic_fluent_print_24_filled.png",
    ["printadd"] = "ic_fluent_print_add_24_filled.png",
    ["print-add"] = "ic_fluent_print_add_24_filled.png",
    ["print_add"] = "ic_fluent_print_add_24_filled.png",
    ["production"] = "ic_fluent_production_24_filled.png",
    ["productioncheckmark"] = "ic_fluent_production_checkmark_24_filled.png",
    ["production-checkmark"] = "ic_fluent_production_checkmark_24_filled.png",
    ["production_checkmark"] = "ic_fluent_production_checkmark_24_filled.png",
    ["prohibited"] = "ic_fluent_prohibited_24_filled.png",
    ["prohibitedmultiple"] = "ic_fluent_prohibited_multiple_24_filled.png",
    ["prohibited-multiple"] = "ic_fluent_prohibited_multiple_24_filled.png",
    ["prohibited_multiple"] = "ic_fluent_prohibited_multiple_24_filled.png",
    ["projectionscreen"] = "ic_fluent_projection_screen_24_filled.png",
    ["projection-screen"] = "ic_fluent_projection_screen_24_filled.png",
    ["projection_screen"] = "ic_fluent_projection_screen_24_filled.png",
    ["projectionscreendismiss"] = "ic_fluent_projection_screen_dismiss_24_filled.png",
    ["projection-screen-dismiss"] = "ic_fluent_projection_screen_dismiss_24_filled.png",
    ["projection_screen_dismiss"] = "ic_fluent_projection_screen_dismiss_24_filled.png",
    ["protocolhandler"] = "ic_fluent_protocol_handler_24_filled.png",
    ["protocol-handler"] = "ic_fluent_protocol_handler_24_filled.png",
    ["protocol_handler"] = "ic_fluent_protocol_handler_24_filled.png",
    ["pulse"] = "ic_fluent_pulse_24_filled.png",
    ["pulsesquare"] = "ic_fluent_pulse_square_24_filled.png",
    ["pulse-square"] = "ic_fluent_pulse_square_24_filled.png",
    ["pulse_square"] = "ic_fluent_pulse_square_24_filled.png",
    ["puzzlecube"] = "ic_fluent_puzzle_cube_24_filled.png",
    ["puzzle-cube"] = "ic_fluent_puzzle_cube_24_filled.png",
    ["puzzle_cube"] = "ic_fluent_puzzle_cube_24_filled.png",
    ["puzzlepiece"] = "ic_fluent_puzzle_piece_24_filled.png",
    ["puzzle-piece"] = "ic_fluent_puzzle_piece_24_filled.png",
    ["puzzle_piece"] = "ic_fluent_puzzle_piece_24_filled.png",
    ["qrcode"] = "ic_fluent_qr_code_24_filled.png",
    ["qr-code"] = "ic_fluent_qr_code_24_filled.png",
    ["qr_code"] = "ic_fluent_qr_code_24_filled.png",
    ["question"] = "ic_fluent_question_24_filled.png",
    ["questioncircle"] = "ic_fluent_question_circle_24_filled.png",
    ["question-circle"] = "ic_fluent_question_circle_24_filled.png",
    ["question_circle"] = "ic_fluent_question_circle_24_filled.png",
    ["quiznew"] = "ic_fluent_quiz_new_24_filled.png",
    ["quiz-new"] = "ic_fluent_quiz_new_24_filled.png",
    ["quiz_new"] = "ic_fluent_quiz_new_24_filled.png",
    ["radiobutton"] = "ic_fluent_radio_button_24_filled.png",
    ["radio-button"] = "ic_fluent_radio_button_24_filled.png",
    ["radio_button"] = "ic_fluent_radio_button_24_filled.png",
    ["ratingmature"] = "ic_fluent_rating_mature_24_filled.png",
    ["rating-mature"] = "ic_fluent_rating_mature_24_filled.png",
    ["rating_mature"] = "ic_fluent_rating_mature_24_filled.png",
    ["ratioonetoone"] = "ic_fluent_ratio_one_to_one_24_filled.png",
    ["ratio-one-to-one"] = "ic_fluent_ratio_one_to_one_24_filled.png",
    ["ratio_one_to_one"] = "ic_fluent_ratio_one_to_one_24_filled.png",
    ["reorder"] = "ic_fluent_re_order_24_filled.png",
    ["re-order"] = "ic_fluent_re_order_24_filled.png",
    ["re_order"] = "ic_fluent_re_order_24_filled.png",
    ["reorderdotshorizontal"] = "ic_fluent_re_order_dots_horizontal_24_filled.png",
    ["re-order-dots-horizontal"] = "ic_fluent_re_order_dots_horizontal_24_filled.png",
    ["re_order_dots_horizontal"] = "ic_fluent_re_order_dots_horizontal_24_filled.png",
    ["reorderdotsvertical"] = "ic_fluent_re_order_dots_vertical_24_filled.png",
    ["re-order-dots-vertical"] = "ic_fluent_re_order_dots_vertical_24_filled.png",
    ["re_order_dots_vertical"] = "ic_fluent_re_order_dots_vertical_24_filled.png",
    ["readaloud"] = "ic_fluent_read_aloud_24_filled.png",
    ["read-aloud"] = "ic_fluent_read_aloud_24_filled.png",
    ["read_aloud"] = "ic_fluent_read_aloud_24_filled.png",
    ["readinglist"] = "ic_fluent_reading_list_24_filled.png",
    ["reading-list"] = "ic_fluent_reading_list_24_filled.png",
    ["reading_list"] = "ic_fluent_reading_list_24_filled.png",
    ["readinglistadd"] = "ic_fluent_reading_list_add_24_filled.png",
    ["reading-list-add"] = "ic_fluent_reading_list_add_24_filled.png",
    ["reading_list_add"] = "ic_fluent_reading_list_add_24_filled.png",
    ["readingmodemobile"] = "ic_fluent_reading_mode_mobile_24_filled.png",
    ["reading-mode-mobile"] = "ic_fluent_reading_mode_mobile_24_filled.png",
    ["reading_mode_mobile"] = "ic_fluent_reading_mode_mobile_24_filled.png",
    ["realestate"] = "ic_fluent_real_estate_24_filled.png",
    ["real-estate"] = "ic_fluent_real_estate_24_filled.png",
    ["real_estate"] = "ic_fluent_real_estate_24_filled.png",
    ["receipt"] = "ic_fluent_receipt_24_filled.png",
    ["receiptadd"] = "ic_fluent_receipt_add_24_filled.png",
    ["receipt-add"] = "ic_fluent_receipt_add_24_filled.png",
    ["receipt_add"] = "ic_fluent_receipt_add_24_filled.png",
    ["receiptbag"] = "ic_fluent_receipt_bag_24_filled.png",
    ["receipt-bag"] = "ic_fluent_receipt_bag_24_filled.png",
    ["receipt_bag"] = "ic_fluent_receipt_bag_24_filled.png",
    ["receiptcube"] = "ic_fluent_receipt_cube_24_filled.png",
    ["receipt-cube"] = "ic_fluent_receipt_cube_24_filled.png",
    ["receipt_cube"] = "ic_fluent_receipt_cube_24_filled.png",
    ["receiptmoney"] = "ic_fluent_receipt_money_24_filled.png",
    ["receipt-money"] = "ic_fluent_receipt_money_24_filled.png",
    ["receipt_money"] = "ic_fluent_receipt_money_24_filled.png",
    ["receiptplay"] = "ic_fluent_receipt_play_24_filled.png",
    ["receipt-play"] = "ic_fluent_receipt_play_24_filled.png",
    ["receipt_play"] = "ic_fluent_receipt_play_24_filled.png",
    ["record"] = "ic_fluent_record_24_filled.png",
    ["recordstop"] = "ic_fluent_record_stop_24_filled.png",
    ["record-stop"] = "ic_fluent_record_stop_24_filled.png",
    ["record_stop"] = "ic_fluent_record_stop_24_filled.png",
    ["rectanglelandscape"] = "ic_fluent_rectangle_landscape_24_filled.png",
    ["rectangle-landscape"] = "ic_fluent_rectangle_landscape_24_filled.png",
    ["rectangle_landscape"] = "ic_fluent_rectangle_landscape_24_filled.png",
    ["rename"] = "ic_fluent_rename_24_filled.png",
    ["resizeimage"] = "ic_fluent_resize_image_24_filled.png",
    ["resize-image"] = "ic_fluent_resize_image_24_filled.png",
    ["resize_image"] = "ic_fluent_resize_image_24_filled.png",
    ["resizelarge"] = "ic_fluent_resize_large_24_filled.png",
    ["resize-large"] = "ic_fluent_resize_large_24_filled.png",
    ["resize_large"] = "ic_fluent_resize_large_24_filled.png",
    ["resizesmall"] = "ic_fluent_resize_small_24_filled.png",
    ["resize-small"] = "ic_fluent_resize_small_24_filled.png",
    ["resize_small"] = "ic_fluent_resize_small_24_filled.png",
    ["resizetable"] = "ic_fluent_resize_table_24_filled.png",
    ["resize-table"] = "ic_fluent_resize_table_24_filled.png",
    ["resize_table"] = "ic_fluent_resize_table_24_filled.png",
    ["resizevideo"] = "ic_fluent_resize_video_24_filled.png",
    ["resize-video"] = "ic_fluent_resize_video_24_filled.png",
    ["resize_video"] = "ic_fluent_resize_video_24_filled.png",
    ["reward"] = "ic_fluent_reward_24_filled.png",
    ["rewind"] = "ic_fluent_rewind_24_filled.png",
    ["ribbon"] = "ic_fluent_ribbon_24_filled.png",
    ["ribbonadd"] = "ic_fluent_ribbon_add_24_filled.png",
    ["ribbon-add"] = "ic_fluent_ribbon_add_24_filled.png",
    ["ribbon_add"] = "ic_fluent_ribbon_add_24_filled.png",
    ["ribbonstar"] = "ic_fluent_ribbon_star_24_filled.png",
    ["ribbon-star"] = "ic_fluent_ribbon_star_24_filled.png",
    ["ribbon_star"] = "ic_fluent_ribbon_star_24_filled.png",
    ["roadcone"] = "ic_fluent_road_cone_24_filled.png",
    ["road-cone"] = "ic_fluent_road_cone_24_filled.png",
    ["road_cone"] = "ic_fluent_road_cone_24_filled.png",
    ["rocket"] = "ic_fluent_rocket_24_filled.png",
    ["rotateleft"] = "ic_fluent_rotate_left_24_filled.png",
    ["rotate-left"] = "ic_fluent_rotate_left_24_filled.png",
    ["rotate_left"] = "ic_fluent_rotate_left_24_filled.png",
    ["rotateright"] = "ic_fluent_rotate_right_24_filled.png",
    ["rotate-right"] = "ic_fluent_rotate_right_24_filled.png",
    ["rotate_right"] = "ic_fluent_rotate_right_24_filled.png",
    ["router"] = "ic_fluent_router_24_filled.png",
    ["rowtriple"] = "ic_fluent_row_triple_24_filled.png",
    ["row-triple"] = "ic_fluent_row_triple_24_filled.png",
    ["row_triple"] = "ic_fluent_row_triple_24_filled.png",
    ["rss"] = "ic_fluent_rss_24_filled.png",
    ["ruler"] = "ic_fluent_ruler_24_filled.png",
    ["run"] = "ic_fluent_run_24_filled.png",
    ["save"] = "ic_fluent_save_24_filled.png",
    ["savearrowright"] = "ic_fluent_save_arrow_right_24_filled.png",
    ["save-arrow-right"] = "ic_fluent_save_arrow_right_24_filled.png",
    ["save_arrow_right"] = "ic_fluent_save_arrow_right_24_filled.png",
    ["savecopy"] = "ic_fluent_save_copy_24_filled.png",
    ["save-copy"] = "ic_fluent_save_copy_24_filled.png",
    ["save_copy"] = "ic_fluent_save_copy_24_filled.png",
    ["saveedit"] = "ic_fluent_save_edit_24_filled.png",
    ["save-edit"] = "ic_fluent_save_edit_24_filled.png",
    ["save_edit"] = "ic_fluent_save_edit_24_filled.png",
    ["savings"] = "ic_fluent_savings_24_filled.png",
    ["scalefill"] = "ic_fluent_scale_fill_24_filled.png",
    ["scale-fill"] = "ic_fluent_scale_fill_24_filled.png",
    ["scale_fill"] = "ic_fluent_scale_fill_24_filled.png",
    ["scalefit"] = "ic_fluent_scale_fit_24_filled.png",
    ["scale-fit"] = "ic_fluent_scale_fit_24_filled.png",
    ["scale_fit"] = "ic_fluent_scale_fit_24_filled.png",
    ["scales"] = "ic_fluent_scales_24_filled.png",
    ["scan"] = "ic_fluent_scan_24_filled.png",
    ["scanobject"] = "ic_fluent_scan_object_24_filled.png",
    ["scan-object"] = "ic_fluent_scan_object_24_filled.png",
    ["scan_object"] = "ic_fluent_scan_object_24_filled.png",
    ["scantable"] = "ic_fluent_scan_table_24_filled.png",
    ["scan-table"] = "ic_fluent_scan_table_24_filled.png",
    ["scan_table"] = "ic_fluent_scan_table_24_filled.png",
    ["scantext"] = "ic_fluent_scan_text_24_filled.png",
    ["scan-text"] = "ic_fluent_scan_text_24_filled.png",
    ["scan_text"] = "ic_fluent_scan_text_24_filled.png",
    ["scanthumbup"] = "ic_fluent_scan_thumb_up_24_filled.png",
    ["scan-thumb-up"] = "ic_fluent_scan_thumb_up_24_filled.png",
    ["scan_thumb_up"] = "ic_fluent_scan_thumb_up_24_filled.png",
    ["scanthumbupoff"] = "ic_fluent_scan_thumb_up_off_24_filled.png",
    ["scan-thumb-up-off"] = "ic_fluent_scan_thumb_up_off_24_filled.png",
    ["scan_thumb_up_off"] = "ic_fluent_scan_thumb_up_off_24_filled.png",
    ["scantype"] = "ic_fluent_scan_type_24_filled.png",
    ["scan-type"] = "ic_fluent_scan_type_24_filled.png",
    ["scan_type"] = "ic_fluent_scan_type_24_filled.png",
    ["scratchpad"] = "ic_fluent_scratchpad_24_filled.png",
    ["screenshot"] = "ic_fluent_screenshot_24_filled.png",
    ["search"] = "ic_fluent_search_24_filled.png",
    ["searchinfo"] = "ic_fluent_search_info_24_filled.png",
    ["search-info"] = "ic_fluent_search_info_24_filled.png",
    ["search_info"] = "ic_fluent_search_info_24_filled.png",
    ["searchsquare"] = "ic_fluent_search_square_24_filled.png",
    ["search-square"] = "ic_fluent_search_square_24_filled.png",
    ["search_square"] = "ic_fluent_search_square_24_filled.png",
    ["searchvisual"] = "ic_fluent_search_visual_24_filled.png",
    ["search-visual"] = "ic_fluent_search_visual_24_filled.png",
    ["search_visual"] = "ic_fluent_search_visual_24_filled.png",
    ["selectalloff"] = "ic_fluent_select_all_off_24_filled.png",
    ["select-all-off"] = "ic_fluent_select_all_off_24_filled.png",
    ["select_all_off"] = "ic_fluent_select_all_off_24_filled.png",
    ["selectallon"] = "ic_fluent_select_all_on_24_filled.png",
    ["select-all-on"] = "ic_fluent_select_all_on_24_filled.png",
    ["select_all_on"] = "ic_fluent_select_all_on_24_filled.png",
    ["selectobject"] = "ic_fluent_select_object_24_filled.png",
    ["select-object"] = "ic_fluent_select_object_24_filled.png",
    ["select_object"] = "ic_fluent_select_object_24_filled.png",
    ["send"] = "ic_fluent_send_24_filled.png",
    ["sendclock"] = "ic_fluent_send_clock_24_filled.png",
    ["send-clock"] = "ic_fluent_send_clock_24_filled.png",
    ["send_clock"] = "ic_fluent_send_clock_24_filled.png",
    ["sendcopy"] = "ic_fluent_send_copy_24_filled.png",
    ["send-copy"] = "ic_fluent_send_copy_24_filled.png",
    ["send_copy"] = "ic_fluent_send_copy_24_filled.png",
    ["serialport"] = "ic_fluent_serial_port_24_filled.png",
    ["serial-port"] = "ic_fluent_serial_port_24_filled.png",
    ["serial_port"] = "ic_fluent_serial_port_24_filled.png",
    ["server"] = "ic_fluent_server_24_filled.png",
    ["servicebell"] = "ic_fluent_service_bell_24_filled.png",
    ["service-bell"] = "ic_fluent_service_bell_24_filled.png",
    ["service_bell"] = "ic_fluent_service_bell_24_filled.png",
    ["settopstack"] = "ic_fluent_set_top_stack_24_filled.png",
    ["set-top-stack"] = "ic_fluent_set_top_stack_24_filled.png",
    ["set_top_stack"] = "ic_fluent_set_top_stack_24_filled.png",
    ["settings"] = "ic_fluent_settings_24_filled.png",
    ["shapeexclude"] = "ic_fluent_shape_exclude_24_filled.png",
    ["shape-exclude"] = "ic_fluent_shape_exclude_24_filled.png",
    ["shape_exclude"] = "ic_fluent_shape_exclude_24_filled.png",
    ["shapeintersect"] = "ic_fluent_shape_intersect_24_filled.png",
    ["shape-intersect"] = "ic_fluent_shape_intersect_24_filled.png",
    ["shape_intersect"] = "ic_fluent_shape_intersect_24_filled.png",
    ["shapesubtract"] = "ic_fluent_shape_subtract_24_filled.png",
    ["shape-subtract"] = "ic_fluent_shape_subtract_24_filled.png",
    ["shape_subtract"] = "ic_fluent_shape_subtract_24_filled.png",
    ["shapeunion"] = "ic_fluent_shape_union_24_filled.png",
    ["shape-union"] = "ic_fluent_shape_union_24_filled.png",
    ["shape_union"] = "ic_fluent_shape_union_24_filled.png",
    ["shapes"] = "ic_fluent_shapes_24_filled.png",
    ["share"] = "ic_fluent_share_24_filled.png",
    ["shareandroid"] = "ic_fluent_share_android_24_filled.png",
    ["share-android"] = "ic_fluent_share_android_24_filled.png",
    ["share_android"] = "ic_fluent_share_android_24_filled.png",
    ["shareclosetray"] = "ic_fluent_share_close_tray_24_filled.png",
    ["share-close-tray"] = "ic_fluent_share_close_tray_24_filled.png",
    ["share_close_tray"] = "ic_fluent_share_close_tray_24_filled.png",
    ["shareios"] = "ic_fluent_share_ios_24_filled.png",
    ["share-ios"] = "ic_fluent_share_ios_24_filled.png",
    ["share_ios"] = "ic_fluent_share_ios_24_filled.png",
    ["sharescreenperson"] = "ic_fluent_share_screen_person_24_filled.png",
    ["share-screen-person"] = "ic_fluent_share_screen_person_24_filled.png",
    ["share_screen_person"] = "ic_fluent_share_screen_person_24_filled.png",
    ["sharescreenpersonoverlay"] = "ic_fluent_share_screen_person_overlay_24_filled.png",
    ["share-screen-person-overlay"] = "ic_fluent_share_screen_person_overlay_24_filled.png",
    ["share_screen_person_overlay"] = "ic_fluent_share_screen_person_overlay_24_filled.png",
    ["sharescreenpersonoverlayinside"] = "ic_fluent_share_screen_person_overlay_inside_24_filled.png",
    ["share-screen-person-overlay-inside"] = "ic_fluent_share_screen_person_overlay_inside_24_filled.png",
    ["share_screen_person_overlay_inside"] = "ic_fluent_share_screen_person_overlay_inside_24_filled.png",
    ["sharescreenstart"] = "ic_fluent_share_screen_start_24_filled.png",
    ["share-screen-start"] = "ic_fluent_share_screen_start_24_filled.png",
    ["share_screen_start"] = "ic_fluent_share_screen_start_24_filled.png",
    ["sharescreenstop"] = "ic_fluent_share_screen_stop_24_filled.png",
    ["share-screen-stop"] = "ic_fluent_share_screen_stop_24_filled.png",
    ["share_screen_stop"] = "ic_fluent_share_screen_stop_24_filled.png",
    ["shield"] = "ic_fluent_shield_24_filled.png",
    ["shieldbadge"] = "ic_fluent_shield_badge_24_filled.png",
    ["shield-badge"] = "ic_fluent_shield_badge_24_filled.png",
    ["shield_badge"] = "ic_fluent_shield_badge_24_filled.png",
    ["shieldcheckmark"] = "ic_fluent_shield_checkmark_24_filled.png",
    ["shield-checkmark"] = "ic_fluent_shield_checkmark_24_filled.png",
    ["shield_checkmark"] = "ic_fluent_shield_checkmark_24_filled.png",
    ["shielddismiss"] = "ic_fluent_shield_dismiss_24_filled.png",
    ["shield-dismiss"] = "ic_fluent_shield_dismiss_24_filled.png",
    ["shield_dismiss"] = "ic_fluent_shield_dismiss_24_filled.png",
    ["shielderror"] = "ic_fluent_shield_error_24_filled.png",
    ["shield-error"] = "ic_fluent_shield_error_24_filled.png",
    ["shield_error"] = "ic_fluent_shield_error_24_filled.png",
    ["shieldkeyhole"] = "ic_fluent_shield_keyhole_24_filled.png",
    ["shield-keyhole"] = "ic_fluent_shield_keyhole_24_filled.png",
    ["shield_keyhole"] = "ic_fluent_shield_keyhole_24_filled.png",
    ["shieldprohibited"] = "ic_fluent_shield_prohibited_24_filled.png",
    ["shield-prohibited"] = "ic_fluent_shield_prohibited_24_filled.png",
    ["shield_prohibited"] = "ic_fluent_shield_prohibited_24_filled.png",
    ["shieldtask"] = "ic_fluent_shield_task_24_filled.png",
    ["shield-task"] = "ic_fluent_shield_task_24_filled.png",
    ["shield_task"] = "ic_fluent_shield_task_24_filled.png",
    ["shieldvideo"] = "ic_fluent_shield_video_24_filled.png",
    ["shield-video"] = "ic_fluent_shield_video_24_filled.png",
    ["shield_video"] = "ic_fluent_shield_video_24_filled.png",
    ["shifts"] = "ic_fluent_shifts_24_filled.png",
    ["shifts30minutes"] = "ic_fluent_shifts_30_minutes_24_filled.png",
    ["shifts30-minutes"] = "ic_fluent_shifts_30_minutes_24_filled.png",
    ["shifts30_minutes"] = "ic_fluent_shifts_30_minutes_24_filled.png",
    ["shiftsactivity"] = "ic_fluent_shifts_activity_24_filled.png",
    ["shifts-activity"] = "ic_fluent_shifts_activity_24_filled.png",
    ["shifts_activity"] = "ic_fluent_shifts_activity_24_filled.png",
    ["shiftsadd"] = "ic_fluent_shifts_add_24_filled.png",
    ["shifts-add"] = "ic_fluent_shifts_add_24_filled.png",
    ["shifts_add"] = "ic_fluent_shifts_add_24_filled.png",
    ["shiftsavailability"] = "ic_fluent_shifts_availability_24_filled.png",
    ["shifts-availability"] = "ic_fluent_shifts_availability_24_filled.png",
    ["shifts_availability"] = "ic_fluent_shifts_availability_24_filled.png",
    ["shiftscheckmark"] = "ic_fluent_shifts_checkmark_24_filled.png",
    ["shifts-checkmark"] = "ic_fluent_shifts_checkmark_24_filled.png",
    ["shifts_checkmark"] = "ic_fluent_shifts_checkmark_24_filled.png",
    ["shiftsday"] = "ic_fluent_shifts_day_24_filled.png",
    ["shifts-day"] = "ic_fluent_shifts_day_24_filled.png",
    ["shifts_day"] = "ic_fluent_shifts_day_24_filled.png",
    ["shiftsopen"] = "ic_fluent_shifts_open_24_filled.png",
    ["shifts-open"] = "ic_fluent_shifts_open_24_filled.png",
    ["shifts_open"] = "ic_fluent_shifts_open_24_filled.png",
    ["shiftsprohibited"] = "ic_fluent_shifts_prohibited_24_filled.png",
    ["shifts-prohibited"] = "ic_fluent_shifts_prohibited_24_filled.png",
    ["shifts_prohibited"] = "ic_fluent_shifts_prohibited_24_filled.png",
    ["shiftsquestionmark"] = "ic_fluent_shifts_question_mark_24_filled.png",
    ["shifts-question-mark"] = "ic_fluent_shifts_question_mark_24_filled.png",
    ["shifts_question_mark"] = "ic_fluent_shifts_question_mark_24_filled.png",
    ["shiftsteam"] = "ic_fluent_shifts_team_24_filled.png",
    ["shifts-team"] = "ic_fluent_shifts_team_24_filled.png",
    ["shifts_team"] = "ic_fluent_shifts_team_24_filled.png",
    ["shoppingbag"] = "ic_fluent_shopping_bag_24_filled.png",
    ["shopping-bag"] = "ic_fluent_shopping_bag_24_filled.png",
    ["shopping_bag"] = "ic_fluent_shopping_bag_24_filled.png",
    ["shortpick"] = "ic_fluent_shortpick_24_filled.png",
    ["signout"] = "ic_fluent_sign_out_24_filled.png",
    ["sign-out"] = "ic_fluent_sign_out_24_filled.png",
    ["sign_out"] = "ic_fluent_sign_out_24_filled.png",
    ["signature"] = "ic_fluent_signature_24_filled.png",
    ["signed"] = "ic_fluent_signed_24_filled.png",
    ["sim"] = "ic_fluent_sim_24_filled.png",
    ["skipbackward10"] = "ic_fluent_skip_backward_10_24_filled.png",
    ["skip-backward10"] = "ic_fluent_skip_backward_10_24_filled.png",
    ["skip_backward10"] = "ic_fluent_skip_backward_10_24_filled.png",
    ["skipforward10"] = "ic_fluent_skip_forward_10_24_filled.png",
    ["skip-forward10"] = "ic_fluent_skip_forward_10_24_filled.png",
    ["skip_forward10"] = "ic_fluent_skip_forward_10_24_filled.png",
    ["skipforward30"] = "ic_fluent_skip_forward_30_24_filled.png",
    ["skip-forward30"] = "ic_fluent_skip_forward_30_24_filled.png",
    ["skip_forward30"] = "ic_fluent_skip_forward_30_24_filled.png",
    ["skipforwardtab"] = "ic_fluent_skip_forward_tab_24_filled.png",
    ["skip-forward-tab"] = "ic_fluent_skip_forward_tab_24_filled.png",
    ["skip_forward_tab"] = "ic_fluent_skip_forward_tab_24_filled.png",
    ["sleep"] = "ic_fluent_sleep_24_filled.png",
    ["slideadd"] = "ic_fluent_slide_add_24_filled.png",
    ["slide-add"] = "ic_fluent_slide_add_24_filled.png",
    ["slide_add"] = "ic_fluent_slide_add_24_filled.png",
    ["slidedesign"] = "ic_fluent_slide_design_24_filled.png",
    ["slide-design"] = "ic_fluent_slide_design_24_filled.png",
    ["slide_design"] = "ic_fluent_slide_design_24_filled.png",
    ["slideeraser"] = "ic_fluent_slide_eraser_24_filled.png",
    ["slide-eraser"] = "ic_fluent_slide_eraser_24_filled.png",
    ["slide_eraser"] = "ic_fluent_slide_eraser_24_filled.png",
    ["slidegrid"] = "ic_fluent_slide_grid_24_filled.png",
    ["slide-grid"] = "ic_fluent_slide_grid_24_filled.png",
    ["slide_grid"] = "ic_fluent_slide_grid_24_filled.png",
    ["slidehide"] = "ic_fluent_slide_hide_24_filled.png",
    ["slide-hide"] = "ic_fluent_slide_hide_24_filled.png",
    ["slide_hide"] = "ic_fluent_slide_hide_24_filled.png",
    ["slidelayout"] = "ic_fluent_slide_layout_24_filled.png",
    ["slide-layout"] = "ic_fluent_slide_layout_24_filled.png",
    ["slide_layout"] = "ic_fluent_slide_layout_24_filled.png",
    ["slidemicrophone"] = "ic_fluent_slide_microphone_24_filled.png",
    ["slide-microphone"] = "ic_fluent_slide_microphone_24_filled.png",
    ["slide_microphone"] = "ic_fluent_slide_microphone_24_filled.png",
    ["slidemultiple"] = "ic_fluent_slide_multiple_24_filled.png",
    ["slide-multiple"] = "ic_fluent_slide_multiple_24_filled.png",
    ["slide_multiple"] = "ic_fluent_slide_multiple_24_filled.png",
    ["slidemultiplearrowright"] = "ic_fluent_slide_multiple_arrow_right_24_filled.png",
    ["slide-multiple-arrow-right"] = "ic_fluent_slide_multiple_arrow_right_24_filled.png",
    ["slide_multiple_arrow_right"] = "ic_fluent_slide_multiple_arrow_right_24_filled.png",
    ["slidemultiplesearch"] = "ic_fluent_slide_multiple_search_24_filled.png",
    ["slide-multiple-search"] = "ic_fluent_slide_multiple_search_24_filled.png",
    ["slide_multiple_search"] = "ic_fluent_slide_multiple_search_24_filled.png",
    ["slidesearch"] = "ic_fluent_slide_search_24_filled.png",
    ["slide-search"] = "ic_fluent_slide_search_24_filled.png",
    ["slide_search"] = "ic_fluent_slide_search_24_filled.png",
    ["slidesettings"] = "ic_fluent_slide_settings_24_filled.png",
    ["slide-settings"] = "ic_fluent_slide_settings_24_filled.png",
    ["slide_settings"] = "ic_fluent_slide_settings_24_filled.png",
    ["slidesize"] = "ic_fluent_slide_size_24_filled.png",
    ["slide-size"] = "ic_fluent_slide_size_24_filled.png",
    ["slide_size"] = "ic_fluent_slide_size_24_filled.png",
    ["slidetext"] = "ic_fluent_slide_text_24_filled.png",
    ["slide-text"] = "ic_fluent_slide_text_24_filled.png",
    ["slide_text"] = "ic_fluent_slide_text_24_filled.png",
    ["slidetransition"] = "ic_fluent_slide_transition_24_filled.png",
    ["slide-transition"] = "ic_fluent_slide_transition_24_filled.png",
    ["slide_transition"] = "ic_fluent_slide_transition_24_filled.png",
    ["smartwatch"] = "ic_fluent_smartwatch_24_filled.png",
    ["smartwatchdot"] = "ic_fluent_smartwatch_dot_24_filled.png",
    ["smartwatch-dot"] = "ic_fluent_smartwatch_dot_24_filled.png",
    ["smartwatch_dot"] = "ic_fluent_smartwatch_dot_24_filled.png",
    ["snooze"] = "ic_fluent_snooze_24_filled.png",
    ["soundsource"] = "ic_fluent_sound_source_24_filled.png",
    ["sound-source"] = "ic_fluent_sound_source_24_filled.png",
    ["sound_source"] = "ic_fluent_sound_source_24_filled.png",
    ["spacebar"] = "ic_fluent_spacebar_24_filled.png",
    ["sparkle"] = "ic_fluent_sparkle_24_filled.png",
    ["speaker0"] = "ic_fluent_speaker_0_24_filled.png",
    ["speaker1"] = "ic_fluent_speaker_1_24_filled.png",
    ["speaker2"] = "ic_fluent_speaker_2_24_filled.png",
    ["speakerbluetooth"] = "ic_fluent_speaker_bluetooth_24_filled.png",
    ["speaker-bluetooth"] = "ic_fluent_speaker_bluetooth_24_filled.png",
    ["speaker_bluetooth"] = "ic_fluent_speaker_bluetooth_24_filled.png",
    ["speakeredit"] = "ic_fluent_speaker_edit_24_filled.png",
    ["speaker-edit"] = "ic_fluent_speaker_edit_24_filled.png",
    ["speaker_edit"] = "ic_fluent_speaker_edit_24_filled.png",
    ["speakermute"] = "ic_fluent_speaker_mute_24_filled.png",
    ["speaker-mute"] = "ic_fluent_speaker_mute_24_filled.png",
    ["speaker_mute"] = "ic_fluent_speaker_mute_24_filled.png",
    ["speakeroff"] = "ic_fluent_speaker_off_24_filled.png",
    ["speaker-off"] = "ic_fluent_speaker_off_24_filled.png",
    ["speaker_off"] = "ic_fluent_speaker_off_24_filled.png",
    ["speakersettings"] = "ic_fluent_speaker_settings_24_filled.png",
    ["speaker-settings"] = "ic_fluent_speaker_settings_24_filled.png",
    ["speaker_settings"] = "ic_fluent_speaker_settings_24_filled.png",
    ["speakerusb"] = "ic_fluent_speaker_usb_24_filled.png",
    ["speaker-usb"] = "ic_fluent_speaker_usb_24_filled.png",
    ["speaker_usb"] = "ic_fluent_speaker_usb_24_filled.png",
    ["splithorizontal"] = "ic_fluent_split_horizontal_24_filled.png",
    ["split-horizontal"] = "ic_fluent_split_horizontal_24_filled.png",
    ["split_horizontal"] = "ic_fluent_split_horizontal_24_filled.png",
    ["splitvertical"] = "ic_fluent_split_vertical_24_filled.png",
    ["split-vertical"] = "ic_fluent_split_vertical_24_filled.png",
    ["split_vertical"] = "ic_fluent_split_vertical_24_filled.png",
    ["sport"] = "ic_fluent_sport_24_filled.png",
    ["sportamericanfootball"] = "ic_fluent_sport_american_football_24_filled.png",
    ["sport-american-football"] = "ic_fluent_sport_american_football_24_filled.png",
    ["sport_american_football"] = "ic_fluent_sport_american_football_24_filled.png",
    ["sportbaseball"] = "ic_fluent_sport_baseball_24_filled.png",
    ["sport-baseball"] = "ic_fluent_sport_baseball_24_filled.png",
    ["sport_baseball"] = "ic_fluent_sport_baseball_24_filled.png",
    ["sportbasketball"] = "ic_fluent_sport_basketball_24_filled.png",
    ["sport-basketball"] = "ic_fluent_sport_basketball_24_filled.png",
    ["sport_basketball"] = "ic_fluent_sport_basketball_24_filled.png",
    ["sporthockey"] = "ic_fluent_sport_hockey_24_filled.png",
    ["sport-hockey"] = "ic_fluent_sport_hockey_24_filled.png",
    ["sport_hockey"] = "ic_fluent_sport_hockey_24_filled.png",
    ["sportsoccer"] = "ic_fluent_sport_soccer_24_filled.png",
    ["sport-soccer"] = "ic_fluent_sport_soccer_24_filled.png",
    ["sport_soccer"] = "ic_fluent_sport_soccer_24_filled.png",
    ["squarearrowforward"] = "ic_fluent_square_arrow_forward_24_filled.png",
    ["square-arrow-forward"] = "ic_fluent_square_arrow_forward_24_filled.png",
    ["square_arrow_forward"] = "ic_fluent_square_arrow_forward_24_filled.png",
    ["squaremultiple"] = "ic_fluent_square_multiple_24_filled.png",
    ["square-multiple"] = "ic_fluent_square_multiple_24_filled.png",
    ["square_multiple"] = "ic_fluent_square_multiple_24_filled.png",
    ["stack"] = "ic_fluent_stack_24_filled.png",
    ["stackstar"] = "ic_fluent_stack_star_24_filled.png",
    ["stack-star"] = "ic_fluent_stack_star_24_filled.png",
    ["stack_star"] = "ic_fluent_stack_star_24_filled.png",
    ["star"] = "ic_fluent_star_24_filled.png",
    ["staradd"] = "ic_fluent_star_add_24_filled.png",
    ["star-add"] = "ic_fluent_star_add_24_filled.png",
    ["star_add"] = "ic_fluent_star_add_24_filled.png",
    ["stararrowrightend"] = "ic_fluent_star_arrow_right_end_24_filled.png",
    ["star-arrow-right-end"] = "ic_fluent_star_arrow_right_end_24_filled.png",
    ["star_arrow_right_end"] = "ic_fluent_star_arrow_right_end_24_filled.png",
    ["stararrowrightstart"] = "ic_fluent_star_arrow_right_start_24_filled.png",
    ["star-arrow-right-start"] = "ic_fluent_star_arrow_right_start_24_filled.png",
    ["star_arrow_right_start"] = "ic_fluent_star_arrow_right_start_24_filled.png",
    ["staredit"] = "ic_fluent_star_edit_24_filled.png",
    ["star-edit"] = "ic_fluent_star_edit_24_filled.png",
    ["star_edit"] = "ic_fluent_star_edit_24_filled.png",
    ["staremphasis"] = "ic_fluent_star_emphasis_24_filled.png",
    ["star-emphasis"] = "ic_fluent_star_emphasis_24_filled.png",
    ["star_emphasis"] = "ic_fluent_star_emphasis_24_filled.png",
    ["starhalf"] = "ic_fluent_star_half_24_filled.png",
    ["star-half"] = "ic_fluent_star_half_24_filled.png",
    ["star_half"] = "ic_fluent_star_half_24_filled.png",
    ["starlinehorizontal3"] = "ic_fluent_star_line_horizontal_3_24_filled.png",
    ["star-line-horizontal3"] = "ic_fluent_star_line_horizontal_3_24_filled.png",
    ["star_line_horizontal3"] = "ic_fluent_star_line_horizontal_3_24_filled.png",
    ["staroff"] = "ic_fluent_star_off_24_filled.png",
    ["star-off"] = "ic_fluent_star_off_24_filled.png",
    ["star_off"] = "ic_fluent_star_off_24_filled.png",
    ["staronequarter"] = "ic_fluent_star_one_quarter_24_filled.png",
    ["star-one-quarter"] = "ic_fluent_star_one_quarter_24_filled.png",
    ["star_one_quarter"] = "ic_fluent_star_one_quarter_24_filled.png",
    ["starprohibited"] = "ic_fluent_star_prohibited_24_filled.png",
    ["star-prohibited"] = "ic_fluent_star_prohibited_24_filled.png",
    ["star_prohibited"] = "ic_fluent_star_prohibited_24_filled.png",
    ["starsettings"] = "ic_fluent_star_settings_24_filled.png",
    ["star-settings"] = "ic_fluent_star_settings_24_filled.png",
    ["star_settings"] = "ic_fluent_star_settings_24_filled.png",
    ["starthreequarter"] = "ic_fluent_star_three_quarter_24_filled.png",
    ["star-three-quarter"] = "ic_fluent_star_three_quarter_24_filled.png",
    ["star_three_quarter"] = "ic_fluent_star_three_quarter_24_filled.png",
    ["status"] = "ic_fluent_status_24_filled.png",
    ["steps"] = "ic_fluent_steps_24_filled.png",
    ["stethoscope"] = "ic_fluent_stethoscope_24_filled.png",
    ["sticker"] = "ic_fluent_sticker_24_filled.png",
    ["stickeradd"] = "ic_fluent_sticker_add_24_filled.png",
    ["sticker-add"] = "ic_fluent_sticker_add_24_filled.png",
    ["sticker_add"] = "ic_fluent_sticker_add_24_filled.png",
    ["stop"] = "ic_fluent_stop_24_filled.png",
    ["storage"] = "ic_fluent_storage_24_filled.png",
    ["storemicrosoft"] = "ic_fluent_store_microsoft_24_filled.png",
    ["store-microsoft"] = "ic_fluent_store_microsoft_24_filled.png",
    ["store_microsoft"] = "ic_fluent_store_microsoft_24_filled.png",
    ["stream"] = "ic_fluent_stream_24_filled.png",
    ["strikethroughgana"] = "ic_fluent_strikethrough_ga_na_24_filled.png",
    ["strikethrough-ga-na"] = "ic_fluent_strikethrough_ga_na_24_filled.png",
    ["strikethrough_ga_na"] = "ic_fluent_strikethrough_ga_na_24_filled.png",
    ["styleguide"] = "ic_fluent_style_guide_24_filled.png",
    ["style-guide"] = "ic_fluent_style_guide_24_filled.png",
    ["style_guide"] = "ic_fluent_style_guide_24_filled.png",
    ["subgrid"] = "ic_fluent_sub_grid_24_filled.png",
    ["sub-grid"] = "ic_fluent_sub_grid_24_filled.png",
    ["sub_grid"] = "ic_fluent_sub_grid_24_filled.png",
    ["subtract"] = "ic_fluent_subtract_24_filled.png",
    ["subtractcircle"] = "ic_fluent_subtract_circle_24_filled.png",
    ["subtract-circle"] = "ic_fluent_subtract_circle_24_filled.png",
    ["subtract_circle"] = "ic_fluent_subtract_circle_24_filled.png",
    ["subtractsquare"] = "ic_fluent_subtract_square_24_filled.png",
    ["subtract-square"] = "ic_fluent_subtract_square_24_filled.png",
    ["subtract_square"] = "ic_fluent_subtract_square_24_filled.png",
    ["surfaceearbuds"] = "ic_fluent_surface_earbuds_24_filled.png",
    ["surface-earbuds"] = "ic_fluent_surface_earbuds_24_filled.png",
    ["surface_earbuds"] = "ic_fluent_surface_earbuds_24_filled.png",
    ["surfacehub"] = "ic_fluent_surface_hub_24_filled.png",
    ["surface-hub"] = "ic_fluent_surface_hub_24_filled.png",
    ["surface_hub"] = "ic_fluent_surface_hub_24_filled.png",
    ["swipedown"] = "ic_fluent_swipe_down_24_filled.png",
    ["swipe-down"] = "ic_fluent_swipe_down_24_filled.png",
    ["swipe_down"] = "ic_fluent_swipe_down_24_filled.png",
    ["swiperight"] = "ic_fluent_swipe_right_24_filled.png",
    ["swipe-right"] = "ic_fluent_swipe_right_24_filled.png",
    ["swipe_right"] = "ic_fluent_swipe_right_24_filled.png",
    ["swipeup"] = "ic_fluent_swipe_up_24_filled.png",
    ["swipe-up"] = "ic_fluent_swipe_up_24_filled.png",
    ["swipe_up"] = "ic_fluent_swipe_up_24_filled.png",
    ["symbols"] = "ic_fluent_symbols_24_filled.png",
    ["syringe"] = "ic_fluent_syringe_24_filled.png",
    ["system"] = "ic_fluent_system_24_filled.png",
    ["tab"] = "ic_fluent_tab_24_filled.png",
    ["tabadd"] = "ic_fluent_tab_add_24_filled.png",
    ["tab-add"] = "ic_fluent_tab_add_24_filled.png",
    ["tab_add"] = "ic_fluent_tab_add_24_filled.png",
    ["tabarrowleft"] = "ic_fluent_tab_arrow_left_24_filled.png",
    ["tab-arrow-left"] = "ic_fluent_tab_arrow_left_24_filled.png",
    ["tab_arrow_left"] = "ic_fluent_tab_arrow_left_24_filled.png",
    ["tabdesktoparrowclockwise"] = "ic_fluent_tab_desktop_arrow_clockwise_24_filled.png",
    ["tab-desktop-arrow-clockwise"] = "ic_fluent_tab_desktop_arrow_clockwise_24_filled.png",
    ["tab_desktop_arrow_clockwise"] = "ic_fluent_tab_desktop_arrow_clockwise_24_filled.png",
    ["tabdesktopbottom"] = "ic_fluent_tab_desktop_bottom_24_filled.png",
    ["tab-desktop-bottom"] = "ic_fluent_tab_desktop_bottom_24_filled.png",
    ["tab_desktop_bottom"] = "ic_fluent_tab_desktop_bottom_24_filled.png",
    ["tabdesktopimage"] = "ic_fluent_tab_desktop_image_24_filled.png",
    ["tab-desktop-image"] = "ic_fluent_tab_desktop_image_24_filled.png",
    ["tab_desktop_image"] = "ic_fluent_tab_desktop_image_24_filled.png",
    ["tabdesktopmultiplebottom"] = "ic_fluent_tab_desktop_multiple_bottom_24_filled.png",
    ["tab-desktop-multiple-bottom"] = "ic_fluent_tab_desktop_multiple_bottom_24_filled.png",
    ["tab_desktop_multiple_bottom"] = "ic_fluent_tab_desktop_multiple_bottom_24_filled.png",
    ["tabinprivate"] = "ic_fluent_tab_in_private_24_filled.png",
    ["tab-in-private"] = "ic_fluent_tab_in_private_24_filled.png",
    ["tab_in_private"] = "ic_fluent_tab_in_private_24_filled.png",
    ["tabinprivateaccount"] = "ic_fluent_tab_inprivate_account_24_filled.png",
    ["tab-inprivate-account"] = "ic_fluent_tab_inprivate_account_24_filled.png",
    ["tab_inprivate_account"] = "ic_fluent_tab_inprivate_account_24_filled.png",
    ["tabprohibited"] = "ic_fluent_tab_prohibited_24_filled.png",
    ["tab-prohibited"] = "ic_fluent_tab_prohibited_24_filled.png",
    ["tab_prohibited"] = "ic_fluent_tab_prohibited_24_filled.png",
    ["tabshielddismiss"] = "ic_fluent_tab_shield_dismiss_24_filled.png",
    ["tab-shield-dismiss"] = "ic_fluent_tab_shield_dismiss_24_filled.png",
    ["tab_shield_dismiss"] = "ic_fluent_tab_shield_dismiss_24_filled.png",
    ["table"] = "ic_fluent_table_24_filled.png",
    ["tableadd"] = "ic_fluent_table_add_24_filled.png",
    ["table-add"] = "ic_fluent_table_add_24_filled.png",
    ["table_add"] = "ic_fluent_table_add_24_filled.png",
    ["tablecelledit"] = "ic_fluent_table_cell_edit_24_filled.png",
    ["table-cell-edit"] = "ic_fluent_table_cell_edit_24_filled.png",
    ["table_cell_edit"] = "ic_fluent_table_cell_edit_24_filled.png",
    ["tablecellsmerge"] = "ic_fluent_table_cells_merge_24_filled.png",
    ["table-cells-merge"] = "ic_fluent_table_cells_merge_24_filled.png",
    ["table_cells_merge"] = "ic_fluent_table_cells_merge_24_filled.png",
    ["tablecellssplit"] = "ic_fluent_table_cells_split_24_filled.png",
    ["table-cells-split"] = "ic_fluent_table_cells_split_24_filled.png",
    ["table_cells_split"] = "ic_fluent_table_cells_split_24_filled.png",
    ["tabledeletecolumn"] = "ic_fluent_table_delete_column_24_filled.png",
    ["table-delete-column"] = "ic_fluent_table_delete_column_24_filled.png",
    ["table_delete_column"] = "ic_fluent_table_delete_column_24_filled.png",
    ["tabledeleterow"] = "ic_fluent_table_delete_row_24_filled.png",
    ["table-delete-row"] = "ic_fluent_table_delete_row_24_filled.png",
    ["table_delete_row"] = "ic_fluent_table_delete_row_24_filled.png",
    ["tabledismiss"] = "ic_fluent_table_dismiss_24_filled.png",
    ["table-dismiss"] = "ic_fluent_table_dismiss_24_filled.png",
    ["table_dismiss"] = "ic_fluent_table_dismiss_24_filled.png",
    ["tableedit"] = "ic_fluent_table_edit_24_filled.png",
    ["table-edit"] = "ic_fluent_table_edit_24_filled.png",
    ["table_edit"] = "ic_fluent_table_edit_24_filled.png",
    ["tablefreezecolumn"] = "ic_fluent_table_freeze_column_24_filled.png",
    ["table-freeze-column"] = "ic_fluent_table_freeze_column_24_filled.png",
    ["table_freeze_column"] = "ic_fluent_table_freeze_column_24_filled.png",
    ["tablefreezecolumnandrow"] = "ic_fluent_table_freeze_column_and_row_24_filled.png",
    ["table-freeze-column-and-row"] = "ic_fluent_table_freeze_column_and_row_24_filled.png",
    ["table_freeze_column_and_row"] = "ic_fluent_table_freeze_column_and_row_24_filled.png",
    ["tablefreezerow"] = "ic_fluent_table_freeze_row_24_filled.png",
    ["table-freeze-row"] = "ic_fluent_table_freeze_row_24_filled.png",
    ["table_freeze_row"] = "ic_fluent_table_freeze_row_24_filled.png",
    ["tableinsertcolumn"] = "ic_fluent_table_insert_column_24_filled.png",
    ["table-insert-column"] = "ic_fluent_table_insert_column_24_filled.png",
    ["table_insert_column"] = "ic_fluent_table_insert_column_24_filled.png",
    ["tableinsertrow"] = "ic_fluent_table_insert_row_24_filled.png",
    ["table-insert-row"] = "ic_fluent_table_insert_row_24_filled.png",
    ["table_insert_row"] = "ic_fluent_table_insert_row_24_filled.png",
    ["tablemoveabove"] = "ic_fluent_table_move_above_24_filled.png",
    ["table-move-above"] = "ic_fluent_table_move_above_24_filled.png",
    ["table_move_above"] = "ic_fluent_table_move_above_24_filled.png",
    ["tablemovebelow"] = "ic_fluent_table_move_below_24_filled.png",
    ["table-move-below"] = "ic_fluent_table_move_below_24_filled.png",
    ["table_move_below"] = "ic_fluent_table_move_below_24_filled.png",
    ["tablemoveleft"] = "ic_fluent_table_move_left_24_filled.png",
    ["table-move-left"] = "ic_fluent_table_move_left_24_filled.png",
    ["table_move_left"] = "ic_fluent_table_move_left_24_filled.png",
    ["tablemoveright"] = "ic_fluent_table_move_right_24_filled.png",
    ["table-move-right"] = "ic_fluent_table_move_right_24_filled.png",
    ["table_move_right"] = "ic_fluent_table_move_right_24_filled.png",
    ["tableresizecolumn"] = "ic_fluent_table_resize_column_24_filled.png",
    ["table-resize-column"] = "ic_fluent_table_resize_column_24_filled.png",
    ["table_resize_column"] = "ic_fluent_table_resize_column_24_filled.png",
    ["tableresizerow"] = "ic_fluent_table_resize_row_24_filled.png",
    ["table-resize-row"] = "ic_fluent_table_resize_row_24_filled.png",
    ["table_resize_row"] = "ic_fluent_table_resize_row_24_filled.png",
    ["tablesettings"] = "ic_fluent_table_settings_24_filled.png",
    ["table-settings"] = "ic_fluent_table_settings_24_filled.png",
    ["table_settings"] = "ic_fluent_table_settings_24_filled.png",
    ["tablesimple"] = "ic_fluent_table_simple_24_filled.png",
    ["table-simple"] = "ic_fluent_table_simple_24_filled.png",
    ["table_simple"] = "ic_fluent_table_simple_24_filled.png",
    ["tablestackabove"] = "ic_fluent_table_stack_above_24_filled.png",
    ["table-stack-above"] = "ic_fluent_table_stack_above_24_filled.png",
    ["table_stack_above"] = "ic_fluent_table_stack_above_24_filled.png",
    ["tablestackbelow"] = "ic_fluent_table_stack_below_24_filled.png",
    ["table-stack-below"] = "ic_fluent_table_stack_below_24_filled.png",
    ["table_stack_below"] = "ic_fluent_table_stack_below_24_filled.png",
    ["tablestackleft"] = "ic_fluent_table_stack_left_24_filled.png",
    ["table-stack-left"] = "ic_fluent_table_stack_left_24_filled.png",
    ["table_stack_left"] = "ic_fluent_table_stack_left_24_filled.png",
    ["tablestackright"] = "ic_fluent_table_stack_right_24_filled.png",
    ["table-stack-right"] = "ic_fluent_table_stack_right_24_filled.png",
    ["table_stack_right"] = "ic_fluent_table_stack_right_24_filled.png",
    ["tableswitch"] = "ic_fluent_table_switch_24_filled.png",
    ["table-switch"] = "ic_fluent_table_switch_24_filled.png",
    ["table_switch"] = "ic_fluent_table_switch_24_filled.png",
    ["tablet"] = "ic_fluent_tablet_24_filled.png",
    ["tabletspeaker"] = "ic_fluent_tablet_speaker_24_filled.png",
    ["tablet-speaker"] = "ic_fluent_tablet_speaker_24_filled.png",
    ["tablet_speaker"] = "ic_fluent_tablet_speaker_24_filled.png",
    ["tabs"] = "ic_fluent_tabs_24_filled.png",
    ["tag"] = "ic_fluent_tag_24_filled.png",
    ["tagdismiss"] = "ic_fluent_tag_dismiss_24_filled.png",
    ["tag-dismiss"] = "ic_fluent_tag_dismiss_24_filled.png",
    ["tag_dismiss"] = "ic_fluent_tag_dismiss_24_filled.png",
    ["taglock"] = "ic_fluent_tag_lock_24_filled.png",
    ["tag-lock"] = "ic_fluent_tag_lock_24_filled.png",
    ["tag_lock"] = "ic_fluent_tag_lock_24_filled.png",
    ["taglockaccent"] = "ic_fluent_tag_lock_accent_24_filled.png",
    ["tag-lock-accent"] = "ic_fluent_tag_lock_accent_24_filled.png",
    ["tag_lock_accent"] = "ic_fluent_tag_lock_accent_24_filled.png",
    ["tagquestionmark"] = "ic_fluent_tag_question_mark_24_filled.png",
    ["tag-question-mark"] = "ic_fluent_tag_question_mark_24_filled.png",
    ["tag_question_mark"] = "ic_fluent_tag_question_mark_24_filled.png",
    ["tapdouble"] = "ic_fluent_tap_double_24_filled.png",
    ["tap-double"] = "ic_fluent_tap_double_24_filled.png",
    ["tap_double"] = "ic_fluent_tap_double_24_filled.png",
    ["tapsingle"] = "ic_fluent_tap_single_24_filled.png",
    ["tap-single"] = "ic_fluent_tap_single_24_filled.png",
    ["tap_single"] = "ic_fluent_tap_single_24_filled.png",
    ["target"] = "ic_fluent_target_24_filled.png",
    ["targetarrow"] = "ic_fluent_target_arrow_24_filled.png",
    ["target-arrow"] = "ic_fluent_target_arrow_24_filled.png",
    ["target_arrow"] = "ic_fluent_target_arrow_24_filled.png",
    ["targetedit"] = "ic_fluent_target_edit_24_filled.png",
    ["target-edit"] = "ic_fluent_target_edit_24_filled.png",
    ["target_edit"] = "ic_fluent_target_edit_24_filled.png",
    ["tasklistadd"] = "ic_fluent_task_list_add_24_filled.png",
    ["task-list-add"] = "ic_fluent_task_list_add_24_filled.png",
    ["task_list_add"] = "ic_fluent_task_list_add_24_filled.png",
    ["tasklistltr"] = "ic_fluent_task_list_ltr_24_filled.png",
    ["task-list-ltr"] = "ic_fluent_task_list_ltr_24_filled.png",
    ["task_list_ltr"] = "ic_fluent_task_list_ltr_24_filled.png",
    ["tasklistrtl"] = "ic_fluent_task_list_rtl_24_filled.png",
    ["task-list-rtl"] = "ic_fluent_task_list_rtl_24_filled.png",
    ["task_list_rtl"] = "ic_fluent_task_list_rtl_24_filled.png",
    ["tasklistsquareadd"] = "ic_fluent_task_list_square_add_24_filled.png",
    ["task-list-square-add"] = "ic_fluent_task_list_square_add_24_filled.png",
    ["task_list_square_add"] = "ic_fluent_task_list_square_add_24_filled.png",
    ["tasklistsquareltr"] = "ic_fluent_task_list_square_ltr_24_filled.png",
    ["task-list-square-ltr"] = "ic_fluent_task_list_square_ltr_24_filled.png",
    ["task_list_square_ltr"] = "ic_fluent_task_list_square_ltr_24_filled.png",
    ["tasklistsquarertl"] = "ic_fluent_task_list_square_rtl_24_filled.png",
    ["task-list-square-rtl"] = "ic_fluent_task_list_square_rtl_24_filled.png",
    ["task_list_square_rtl"] = "ic_fluent_task_list_square_rtl_24_filled.png",
    ["tasksapp"] = "ic_fluent_tasks_app_24_filled.png",
    ["tasks-app"] = "ic_fluent_tasks_app_24_filled.png",
    ["tasks_app"] = "ic_fluent_tasks_app_24_filled.png",
    ["teddy"] = "ic_fluent_teddy_24_filled.png",
    ["temperature"] = "ic_fluent_temperature_24_filled.png",
    ["tent"] = "ic_fluent_tent_24_filled.png",
    ["tetrisapp"] = "ic_fluent_tetris_app_24_filled.png",
    ["tetris-app"] = "ic_fluent_tetris_app_24_filled.png",
    ["tetris_app"] = "ic_fluent_tetris_app_24_filled.png",
    ["text"] = "ic_fluent_text_24_filled.png",
    ["textadd"] = "ic_fluent_text_add_24_filled.png",
    ["text-add"] = "ic_fluent_text_add_24_filled.png",
    ["text_add"] = "ic_fluent_text_add_24_filled.png",
    ["textaddspaceafter"] = "ic_fluent_text_add_space_after_24_filled.png",
    ["text-add-space-after"] = "ic_fluent_text_add_space_after_24_filled.png",
    ["text_add_space_after"] = "ic_fluent_text_add_space_after_24_filled.png",
    ["textaddspacebefore"] = "ic_fluent_text_add_space_before_24_filled.png",
    ["text-add-space-before"] = "ic_fluent_text_add_space_before_24_filled.png",
    ["text_add_space_before"] = "ic_fluent_text_add_space_before_24_filled.png",
    ["textaddt"] = "ic_fluent_text_add_t_24_filled.png",
    ["text-add-t"] = "ic_fluent_text_add_t_24_filled.png",
    ["text_add_t"] = "ic_fluent_text_add_t_24_filled.png",
    ["textaligncenter"] = "ic_fluent_text_align_center_24_filled.png",
    ["text-align-center"] = "ic_fluent_text_align_center_24_filled.png",
    ["text_align_center"] = "ic_fluent_text_align_center_24_filled.png",
    ["textaligncenterrotate270"] = "ic_fluent_text_align_center_rotate_270_24_filled.png",
    ["text-align-center-rotate270"] = "ic_fluent_text_align_center_rotate_270_24_filled.png",
    ["text_align_center_rotate270"] = "ic_fluent_text_align_center_rotate_270_24_filled.png",
    ["textaligndistributed"] = "ic_fluent_text_align_distributed_24_filled.png",
    ["text-align-distributed"] = "ic_fluent_text_align_distributed_24_filled.png",
    ["text_align_distributed"] = "ic_fluent_text_align_distributed_24_filled.png",
    ["textaligndistributedevenly"] = "ic_fluent_text_align_distributed_evenly_24_filled.png",
    ["text-align-distributed-evenly"] = "ic_fluent_text_align_distributed_evenly_24_filled.png",
    ["text_align_distributed_evenly"] = "ic_fluent_text_align_distributed_evenly_24_filled.png",
    ["textaligndistributedvertical"] = "ic_fluent_text_align_distributed_vertical_24_filled.png",
    ["text-align-distributed-vertical"] = "ic_fluent_text_align_distributed_vertical_24_filled.png",
    ["text_align_distributed_vertical"] = "ic_fluent_text_align_distributed_vertical_24_filled.png",
    ["textalignjustify"] = "ic_fluent_text_align_justify_24_filled.png",
    ["text-align-justify"] = "ic_fluent_text_align_justify_24_filled.png",
    ["text_align_justify"] = "ic_fluent_text_align_justify_24_filled.png",
    ["textalignjustifylow"] = "ic_fluent_text_align_justify_low_24_filled.png",
    ["text-align-justify-low"] = "ic_fluent_text_align_justify_low_24_filled.png",
    ["text_align_justify_low"] = "ic_fluent_text_align_justify_low_24_filled.png",
    ["textalignjustifylowrotate90"] = "ic_fluent_text_align_justify_low_rotate_90_24_filled.png",
    ["text-align-justify-low-rotate90"] = "ic_fluent_text_align_justify_low_rotate_90_24_filled.png",
    ["text_align_justify_low_rotate90"] = "ic_fluent_text_align_justify_low_rotate_90_24_filled.png",
    ["textalignjustifyrotate90"] = "ic_fluent_text_align_justify_rotate_90_24_filled.png",
    ["text-align-justify-rotate90"] = "ic_fluent_text_align_justify_rotate_90_24_filled.png",
    ["text_align_justify_rotate90"] = "ic_fluent_text_align_justify_rotate_90_24_filled.png",
    ["textalignleft"] = "ic_fluent_text_align_left_24_filled.png",
    ["text-align-left"] = "ic_fluent_text_align_left_24_filled.png",
    ["text_align_left"] = "ic_fluent_text_align_left_24_filled.png",
    ["textalignleftrotate270"] = "ic_fluent_text_align_left_rotate_270_24_filled.png",
    ["text-align-left-rotate270"] = "ic_fluent_text_align_left_rotate_270_24_filled.png",
    ["text_align_left_rotate270"] = "ic_fluent_text_align_left_rotate_270_24_filled.png",
    ["textalignright"] = "ic_fluent_text_align_right_24_filled.png",
    ["text-align-right"] = "ic_fluent_text_align_right_24_filled.png",
    ["text_align_right"] = "ic_fluent_text_align_right_24_filled.png",
    ["textalignrightrotate270"] = "ic_fluent_text_align_right_rotate_270_24_filled.png",
    ["text-align-right-rotate270"] = "ic_fluent_text_align_right_rotate_270_24_filled.png",
    ["text_align_right_rotate270"] = "ic_fluent_text_align_right_rotate_270_24_filled.png",
    ["textbold"] = "ic_fluent_text_bold_24_filled.png",
    ["text-bold"] = "ic_fluent_text_bold_24_filled.png",
    ["text_bold"] = "ic_fluent_text_bold_24_filled.png",
    ["textbulletlistadd"] = "ic_fluent_text_bullet_list_add_24_filled.png",
    ["text-bullet-list-add"] = "ic_fluent_text_bullet_list_add_24_filled.png",
    ["text_bullet_list_add"] = "ic_fluent_text_bullet_list_add_24_filled.png",
    ["textbulletlistltr"] = "ic_fluent_text_bullet_list_ltr_24_filled.png",
    ["text-bullet-list-ltr"] = "ic_fluent_text_bullet_list_ltr_24_filled.png",
    ["text_bullet_list_ltr"] = "ic_fluent_text_bullet_list_ltr_24_filled.png",
    ["textbulletlistrtl"] = "ic_fluent_text_bullet_list_rtl_24_filled.png",
    ["text-bullet-list-rtl"] = "ic_fluent_text_bullet_list_rtl_24_filled.png",
    ["text_bullet_list_rtl"] = "ic_fluent_text_bullet_list_rtl_24_filled.png",
    ["textbulletlistsquare"] = "ic_fluent_text_bullet_list_square_24_filled.png",
    ["text-bullet-list-square"] = "ic_fluent_text_bullet_list_square_24_filled.png",
    ["text_bullet_list_square"] = "ic_fluent_text_bullet_list_square_24_filled.png",
    ["textbulletlistsquareedit"] = "ic_fluent_text_bullet_list_square_edit_24_filled.png",
    ["text-bullet-list-square-edit"] = "ic_fluent_text_bullet_list_square_edit_24_filled.png",
    ["text_bullet_list_square_edit"] = "ic_fluent_text_bullet_list_square_edit_24_filled.png",
    ["textbulletlistsquarewarning"] = "ic_fluent_text_bullet_list_square_warning_24_filled.png",
    ["text-bullet-list-square-warning"] = "ic_fluent_text_bullet_list_square_warning_24_filled.png",
    ["text_bullet_list_square_warning"] = "ic_fluent_text_bullet_list_square_warning_24_filled.png",
    ["textbulletlisttree"] = "ic_fluent_text_bullet_list_tree_24_filled.png",
    ["text-bullet-list-tree"] = "ic_fluent_text_bullet_list_tree_24_filled.png",
    ["text_bullet_list_tree"] = "ic_fluent_text_bullet_list_tree_24_filled.png",
    ["textcaselowercase"] = "ic_fluent_text_case_lowercase_24_filled.png",
    ["text-case-lowercase"] = "ic_fluent_text_case_lowercase_24_filled.png",
    ["text_case_lowercase"] = "ic_fluent_text_case_lowercase_24_filled.png",
    ["textcasetitle"] = "ic_fluent_text_case_title_24_filled.png",
    ["text-case-title"] = "ic_fluent_text_case_title_24_filled.png",
    ["text_case_title"] = "ic_fluent_text_case_title_24_filled.png",
    ["textcaseuppercase"] = "ic_fluent_text_case_uppercase_24_filled.png",
    ["text-case-uppercase"] = "ic_fluent_text_case_uppercase_24_filled.png",
    ["text_case_uppercase"] = "ic_fluent_text_case_uppercase_24_filled.png",
    ["textchangecase"] = "ic_fluent_text_change_case_24_filled.png",
    ["text-change-case"] = "ic_fluent_text_change_case_24_filled.png",
    ["text_change_case"] = "ic_fluent_text_change_case_24_filled.png",
    ["textclearformatting"] = "ic_fluent_text_clear_formatting_24_filled.png",
    ["text-clear-formatting"] = "ic_fluent_text_clear_formatting_24_filled.png",
    ["text_clear_formatting"] = "ic_fluent_text_clear_formatting_24_filled.png",
    ["textclearformattingga"] = "ic_fluent_text_clear_formatting_ga_24_filled.png",
    ["text-clear-formatting-ga"] = "ic_fluent_text_clear_formatting_ga_24_filled.png",
    ["text_clear_formatting_ga"] = "ic_fluent_text_clear_formatting_ga_24_filled.png",
    ["textcollapse"] = "ic_fluent_text_collapse_24_filled.png",
    ["text-collapse"] = "ic_fluent_text_collapse_24_filled.png",
    ["text_collapse"] = "ic_fluent_text_collapse_24_filled.png",
    ["textcolor"] = "ic_fluent_text_color_24_filled.png",
    ["text-color"] = "ic_fluent_text_color_24_filled.png",
    ["text_color"] = "ic_fluent_text_color_24_filled.png",
    ["textcoloraccent"] = "ic_fluent_text_color_accent_24_filled.png",
    ["text-color-accent"] = "ic_fluent_text_color_accent_24_filled.png",
    ["text_color_accent"] = "ic_fluent_text_color_accent_24_filled.png",
    ["textcolorga"] = "ic_fluent_text_color_ga_24_filled.png",
    ["text-color-ga"] = "ic_fluent_text_color_ga_24_filled.png",
    ["text_color_ga"] = "ic_fluent_text_color_ga_24_filled.png",
    ["textcolumnone"] = "ic_fluent_text_column_one_24_filled.png",
    ["text-column-one"] = "ic_fluent_text_column_one_24_filled.png",
    ["text_column_one"] = "ic_fluent_text_column_one_24_filled.png",
    ["textcolumnonenarrow"] = "ic_fluent_text_column_one_narrow_24_filled.png",
    ["text-column-one-narrow"] = "ic_fluent_text_column_one_narrow_24_filled.png",
    ["text_column_one_narrow"] = "ic_fluent_text_column_one_narrow_24_filled.png",
    ["textcolumnonewide"] = "ic_fluent_text_column_one_wide_24_filled.png",
    ["text-column-one-wide"] = "ic_fluent_text_column_one_wide_24_filled.png",
    ["text_column_one_wide"] = "ic_fluent_text_column_one_wide_24_filled.png",
    ["textcolumnthree"] = "ic_fluent_text_column_three_24_filled.png",
    ["text-column-three"] = "ic_fluent_text_column_three_24_filled.png",
    ["text_column_three"] = "ic_fluent_text_column_three_24_filled.png",
    ["textcolumntwo"] = "ic_fluent_text_column_two_24_filled.png",
    ["text-column-two"] = "ic_fluent_text_column_two_24_filled.png",
    ["text_column_two"] = "ic_fluent_text_column_two_24_filled.png",
    ["textcolumntwoleft"] = "ic_fluent_text_column_two_left_24_filled.png",
    ["text-column-two-left"] = "ic_fluent_text_column_two_left_24_filled.png",
    ["text_column_two_left"] = "ic_fluent_text_column_two_left_24_filled.png",
    ["textcolumntworight"] = "ic_fluent_text_column_two_right_24_filled.png",
    ["text-column-two-right"] = "ic_fluent_text_column_two_right_24_filled.png",
    ["text_column_two_right"] = "ic_fluent_text_column_two_right_24_filled.png",
    ["textcontinuous"] = "ic_fluent_text_continuous_24_filled.png",
    ["text-continuous"] = "ic_fluent_text_continuous_24_filled.png",
    ["text_continuous"] = "ic_fluent_text_continuous_24_filled.png",
    ["textdescription"] = "ic_fluent_text_description_24_filled.png",
    ["text-description"] = "ic_fluent_text_description_24_filled.png",
    ["text_description"] = "ic_fluent_text_description_24_filled.png",
    ["textdirectionhorizontalleft"] = "ic_fluent_text_direction_horizontal_left_24_filled.png",
    ["text-direction-horizontal-left"] = "ic_fluent_text_direction_horizontal_left_24_filled.png",
    ["text_direction_horizontal_left"] = "ic_fluent_text_direction_horizontal_left_24_filled.png",
    ["textdirectionhorizontalltr"] = "ic_fluent_text_direction_horizontal_ltr_24_filled.png",
    ["text-direction-horizontal-ltr"] = "ic_fluent_text_direction_horizontal_ltr_24_filled.png",
    ["text_direction_horizontal_ltr"] = "ic_fluent_text_direction_horizontal_ltr_24_filled.png",
    ["textdirectionhorizontalright"] = "ic_fluent_text_direction_horizontal_right_24_filled.png",
    ["text-direction-horizontal-right"] = "ic_fluent_text_direction_horizontal_right_24_filled.png",
    ["text_direction_horizontal_right"] = "ic_fluent_text_direction_horizontal_right_24_filled.png",
    ["textdirectionhorizontalrtl"] = "ic_fluent_text_direction_horizontal_rtl_24_filled.png",
    ["text-direction-horizontal-rtl"] = "ic_fluent_text_direction_horizontal_rtl_24_filled.png",
    ["text_direction_horizontal_rtl"] = "ic_fluent_text_direction_horizontal_rtl_24_filled.png",
    ["textdirectionrotate270ltr"] = "ic_fluent_text_direction_rotate_270_ltr_24_filled.png",
    ["text-direction-rotate270-ltr"] = "ic_fluent_text_direction_rotate_270_ltr_24_filled.png",
    ["text_direction_rotate270_ltr"] = "ic_fluent_text_direction_rotate_270_ltr_24_filled.png",
    ["textdirectionrotate270right"] = "ic_fluent_text_direction_rotate_270_right_24_filled.png",
    ["text-direction-rotate270-right"] = "ic_fluent_text_direction_rotate_270_right_24_filled.png",
    ["text_direction_rotate270_right"] = "ic_fluent_text_direction_rotate_270_right_24_filled.png",
    ["textdirectionrotate90left"] = "ic_fluent_text_direction_rotate_90_left_24_filled.png",
    ["text-direction-rotate90-left"] = "ic_fluent_text_direction_rotate_90_left_24_filled.png",
    ["text_direction_rotate90_left"] = "ic_fluent_text_direction_rotate_90_left_24_filled.png",
    ["textdirectionrotate90ltr"] = "ic_fluent_text_direction_rotate_90_ltr_24_filled.png",
    ["text-direction-rotate90-ltr"] = "ic_fluent_text_direction_rotate_90_ltr_24_filled.png",
    ["text_direction_rotate90_ltr"] = "ic_fluent_text_direction_rotate_90_ltr_24_filled.png",
    ["textdirectionrotate90right"] = "ic_fluent_text_direction_rotate_90_right_24_filled.png",
    ["text-direction-rotate90-right"] = "ic_fluent_text_direction_rotate_90_right_24_filled.png",
    ["text_direction_rotate90_right"] = "ic_fluent_text_direction_rotate_90_right_24_filled.png",
    ["textdirectionrotate90rtl"] = "ic_fluent_text_direction_rotate_90_rtl_24_filled.png",
    ["text-direction-rotate90-rtl"] = "ic_fluent_text_direction_rotate_90_rtl_24_filled.png",
    ["text_direction_rotate90_rtl"] = "ic_fluent_text_direction_rotate_90_rtl_24_filled.png",
    ["textdirectionvertical"] = "ic_fluent_text_direction_vertical_24_filled.png",
    ["text-direction-vertical"] = "ic_fluent_text_direction_vertical_24_filled.png",
    ["text_direction_vertical"] = "ic_fluent_text_direction_vertical_24_filled.png",
    ["texteditstyle"] = "ic_fluent_text_edit_style_24_filled.png",
    ["text-edit-style"] = "ic_fluent_text_edit_style_24_filled.png",
    ["text_edit_style"] = "ic_fluent_text_edit_style_24_filled.png",
    ["texteditstylega"] = "ic_fluent_text_edit_style_ga_24_filled.png",
    ["text-edit-style-ga"] = "ic_fluent_text_edit_style_ga_24_filled.png",
    ["text_edit_style_ga"] = "ic_fluent_text_edit_style_ga_24_filled.png",
    ["texteffects"] = "ic_fluent_text_effects_24_filled.png",
    ["text-effects"] = "ic_fluent_text_effects_24_filled.png",
    ["text_effects"] = "ic_fluent_text_effects_24_filled.png",
    ["texteffectsga"] = "ic_fluent_text_effects_ga_24_filled.png",
    ["text-effects-ga"] = "ic_fluent_text_effects_ga_24_filled.png",
    ["text_effects_ga"] = "ic_fluent_text_effects_ga_24_filled.png",
    ["textexpand"] = "ic_fluent_text_expand_24_filled.png",
    ["text-expand"] = "ic_fluent_text_expand_24_filled.png",
    ["text_expand"] = "ic_fluent_text_expand_24_filled.png",
    ["textfield"] = "ic_fluent_text_field_24_filled.png",
    ["text-field"] = "ic_fluent_text_field_24_filled.png",
    ["text_field"] = "ic_fluent_text_field_24_filled.png",
    ["textfirstline"] = "ic_fluent_text_first_line_24_filled.png",
    ["text-first-line"] = "ic_fluent_text_first_line_24_filled.png",
    ["text_first_line"] = "ic_fluent_text_first_line_24_filled.png",
    ["textfont"] = "ic_fluent_text_font_24_filled.png",
    ["text-font"] = "ic_fluent_text_font_24_filled.png",
    ["text_font"] = "ic_fluent_text_font_24_filled.png",
    ["textfontsize"] = "ic_fluent_text_font_size_24_filled.png",
    ["text-font-size"] = "ic_fluent_text_font_size_24_filled.png",
    ["text_font_size"] = "ic_fluent_text_font_size_24_filled.png",
    ["textfootnote"] = "ic_fluent_text_footnote_24_filled.png",
    ["text-footnote"] = "ic_fluent_text_footnote_24_filled.png",
    ["text_footnote"] = "ic_fluent_text_footnote_24_filled.png",
    ["textfootnotegana"] = "ic_fluent_text_footnote_ga_na_24_filled.png",
    ["text-footnote-ga-na"] = "ic_fluent_text_footnote_ga_na_24_filled.png",
    ["text_footnote_ga_na"] = "ic_fluent_text_footnote_ga_na_24_filled.png",
    ["textgrammararrowleft"] = "ic_fluent_text_grammar_arrow_left_24_filled.png",
    ["text-grammar-arrow-left"] = "ic_fluent_text_grammar_arrow_left_24_filled.png",
    ["text_grammar_arrow_left"] = "ic_fluent_text_grammar_arrow_left_24_filled.png",
    ["textgrammararrowright"] = "ic_fluent_text_grammar_arrow_right_24_filled.png",
    ["text-grammar-arrow-right"] = "ic_fluent_text_grammar_arrow_right_24_filled.png",
    ["text_grammar_arrow_right"] = "ic_fluent_text_grammar_arrow_right_24_filled.png",
    ["textgrammarcheckmark"] = "ic_fluent_text_grammar_checkmark_24_filled.png",
    ["text-grammar-checkmark"] = "ic_fluent_text_grammar_checkmark_24_filled.png",
    ["text_grammar_checkmark"] = "ic_fluent_text_grammar_checkmark_24_filled.png",
    ["textgrammardismiss"] = "ic_fluent_text_grammar_dismiss_24_filled.png",
    ["text-grammar-dismiss"] = "ic_fluent_text_grammar_dismiss_24_filled.png",
    ["text_grammar_dismiss"] = "ic_fluent_text_grammar_dismiss_24_filled.png",
    ["textgrammarsettings"] = "ic_fluent_text_grammar_settings_24_filled.png",
    ["text-grammar-settings"] = "ic_fluent_text_grammar_settings_24_filled.png",
    ["text_grammar_settings"] = "ic_fluent_text_grammar_settings_24_filled.png",
    ["textgrammarwand"] = "ic_fluent_text_grammar_wand_24_filled.png",
    ["text-grammar-wand"] = "ic_fluent_text_grammar_wand_24_filled.png",
    ["text_grammar_wand"] = "ic_fluent_text_grammar_wand_24_filled.png",
    ["texthanging"] = "ic_fluent_text_hanging_24_filled.png",
    ["text-hanging"] = "ic_fluent_text_hanging_24_filled.png",
    ["text_hanging"] = "ic_fluent_text_hanging_24_filled.png",
    ["textheader1"] = "ic_fluent_text_header_1_24_filled.png",
    ["text-header1"] = "ic_fluent_text_header_1_24_filled.png",
    ["text_header1"] = "ic_fluent_text_header_1_24_filled.png",
    ["textheader2"] = "ic_fluent_text_header_2_24_filled.png",
    ["text-header2"] = "ic_fluent_text_header_2_24_filled.png",
    ["text_header2"] = "ic_fluent_text_header_2_24_filled.png",
    ["textheader3"] = "ic_fluent_text_header_3_24_filled.png",
    ["text-header3"] = "ic_fluent_text_header_3_24_filled.png",
    ["text_header3"] = "ic_fluent_text_header_3_24_filled.png",
    ["textindentdecrease"] = "ic_fluent_text_indent_decrease_24_filled.png",
    ["text-indent-decrease"] = "ic_fluent_text_indent_decrease_24_filled.png",
    ["text_indent_decrease"] = "ic_fluent_text_indent_decrease_24_filled.png",
    ["textindentdecreaseltr"] = "ic_fluent_text_indent_decrease_ltr_24_filled.png",
    ["text-indent-decrease-ltr"] = "ic_fluent_text_indent_decrease_ltr_24_filled.png",
    ["text_indent_decrease_ltr"] = "ic_fluent_text_indent_decrease_ltr_24_filled.png",
    ["textindentdecreasertl"] = "ic_fluent_text_indent_decrease_rtl_24_filled.png",
    ["text-indent-decrease-rtl"] = "ic_fluent_text_indent_decrease_rtl_24_filled.png",
    ["text_indent_decrease_rtl"] = "ic_fluent_text_indent_decrease_rtl_24_filled.png",
    ["textindentincrease"] = "ic_fluent_text_indent_increase_24_filled.png",
    ["text-indent-increase"] = "ic_fluent_text_indent_increase_24_filled.png",
    ["text_indent_increase"] = "ic_fluent_text_indent_increase_24_filled.png",
    ["textindentincreaseltr"] = "ic_fluent_text_indent_increase_ltr_24_filled.png",
    ["text-indent-increase-ltr"] = "ic_fluent_text_indent_increase_ltr_24_filled.png",
    ["text_indent_increase_ltr"] = "ic_fluent_text_indent_increase_ltr_24_filled.png",
    ["textindentincreasertl"] = "ic_fluent_text_indent_increase_rtl_24_filled.png",
    ["text-indent-increase-rtl"] = "ic_fluent_text_indent_increase_rtl_24_filled.png",
    ["text_indent_increase_rtl"] = "ic_fluent_text_indent_increase_rtl_24_filled.png",
    ["textitalic"] = "ic_fluent_text_italic_24_filled.png",
    ["text-italic"] = "ic_fluent_text_italic_24_filled.png",
    ["text_italic"] = "ic_fluent_text_italic_24_filled.png",
    ["textlinespacing"] = "ic_fluent_text_line_spacing_24_filled.png",
    ["text-line-spacing"] = "ic_fluent_text_line_spacing_24_filled.png",
    ["text_line_spacing"] = "ic_fluent_text_line_spacing_24_filled.png",
    ["textmore"] = "ic_fluent_text_more_24_filled.png",
    ["text-more"] = "ic_fluent_text_more_24_filled.png",
    ["text_more"] = "ic_fluent_text_more_24_filled.png",
    ["textnumberformat"] = "ic_fluent_text_number_format_24_filled.png",
    ["text-number-format"] = "ic_fluent_text_number_format_24_filled.png",
    ["text_number_format"] = "ic_fluent_text_number_format_24_filled.png",
    ["textnumberformatganada"] = "ic_fluent_text_number_format_ga_na_da_24_filled.png",
    ["text-number-format-ga-na-da"] = "ic_fluent_text_number_format_ga_na_da_24_filled.png",
    ["text_number_format_ga_na_da"] = "ic_fluent_text_number_format_ga_na_da_24_filled.png",
    ["textnumberlistltr"] = "ic_fluent_text_number_list_ltr_24_filled.png",
    ["text-number-list-ltr"] = "ic_fluent_text_number_list_ltr_24_filled.png",
    ["text_number_list_ltr"] = "ic_fluent_text_number_list_ltr_24_filled.png",
    ["textnumberlistrtl"] = "ic_fluent_text_number_list_rtl_24_filled.png",
    ["text-number-list-rtl"] = "ic_fluent_text_number_list_rtl_24_filled.png",
    ["text_number_list_rtl"] = "ic_fluent_text_number_list_rtl_24_filled.png",
    ["textparagraph"] = "ic_fluent_text_paragraph_24_filled.png",
    ["text-paragraph"] = "ic_fluent_text_paragraph_24_filled.png",
    ["text_paragraph"] = "ic_fluent_text_paragraph_24_filled.png",
    ["textparagraphdirection"] = "ic_fluent_text_paragraph_direction_24_filled.png",
    ["text-paragraph-direction"] = "ic_fluent_text_paragraph_direction_24_filled.png",
    ["text_paragraph_direction"] = "ic_fluent_text_paragraph_direction_24_filled.png",
    ["textpositionbehind"] = "ic_fluent_text_position_behind_24_filled.png",
    ["text-position-behind"] = "ic_fluent_text_position_behind_24_filled.png",
    ["text_position_behind"] = "ic_fluent_text_position_behind_24_filled.png",
    ["textpositionfront"] = "ic_fluent_text_position_front_24_filled.png",
    ["text-position-front"] = "ic_fluent_text_position_front_24_filled.png",
    ["text_position_front"] = "ic_fluent_text_position_front_24_filled.png",
    ["textpositionline"] = "ic_fluent_text_position_line_24_filled.png",
    ["text-position-line"] = "ic_fluent_text_position_line_24_filled.png",
    ["text_position_line"] = "ic_fluent_text_position_line_24_filled.png",
    ["textpositionsquare"] = "ic_fluent_text_position_square_24_filled.png",
    ["text-position-square"] = "ic_fluent_text_position_square_24_filled.png",
    ["text_position_square"] = "ic_fluent_text_position_square_24_filled.png",
    ["textpositionthrough"] = "ic_fluent_text_position_through_24_filled.png",
    ["text-position-through"] = "ic_fluent_text_position_through_24_filled.png",
    ["text_position_through"] = "ic_fluent_text_position_through_24_filled.png",
    ["textpositiontight"] = "ic_fluent_text_position_tight_24_filled.png",
    ["text-position-tight"] = "ic_fluent_text_position_tight_24_filled.png",
    ["text_position_tight"] = "ic_fluent_text_position_tight_24_filled.png",
    ["textpositiontopbottom"] = "ic_fluent_text_position_top_bottom_24_filled.png",
    ["text-position-top-bottom"] = "ic_fluent_text_position_top_bottom_24_filled.png",
    ["text_position_top_bottom"] = "ic_fluent_text_position_top_bottom_24_filled.png",
    ["textproofingtools"] = "ic_fluent_text_proofing_tools_24_filled.png",
    ["text-proofing-tools"] = "ic_fluent_text_proofing_tools_24_filled.png",
    ["text_proofing_tools"] = "ic_fluent_text_proofing_tools_24_filled.png",
    ["textproofingtoolsganada"] = "ic_fluent_text_proofing_tools_ga_na_da_24_filled.png",
    ["text-proofing-tools-ga-na-da"] = "ic_fluent_text_proofing_tools_ga_na_da_24_filled.png",
    ["text_proofing_tools_ga_na_da"] = "ic_fluent_text_proofing_tools_ga_na_da_24_filled.png",
    ["textproofingtoolszi"] = "ic_fluent_text_proofing_tools_zi_24_filled.png",
    ["text-proofing-tools-zi"] = "ic_fluent_text_proofing_tools_zi_24_filled.png",
    ["text_proofing_tools_zi"] = "ic_fluent_text_proofing_tools_zi_24_filled.png",
    ["textquote"] = "ic_fluent_text_quote_24_filled.png",
    ["text-quote"] = "ic_fluent_text_quote_24_filled.png",
    ["text_quote"] = "ic_fluent_text_quote_24_filled.png",
    ["textsortascending"] = "ic_fluent_text_sort_ascending_24_filled.png",
    ["text-sort-ascending"] = "ic_fluent_text_sort_ascending_24_filled.png",
    ["text_sort_ascending"] = "ic_fluent_text_sort_ascending_24_filled.png",
    ["textsortdescending"] = "ic_fluent_text_sort_descending_24_filled.png",
    ["text-sort-descending"] = "ic_fluent_text_sort_descending_24_filled.png",
    ["text_sort_descending"] = "ic_fluent_text_sort_descending_24_filled.png",
    ["textstrikethrough"] = "ic_fluent_text_strikethrough_24_filled.png",
    ["text-strikethrough"] = "ic_fluent_text_strikethrough_24_filled.png",
    ["text_strikethrough"] = "ic_fluent_text_strikethrough_24_filled.png",
    ["textstrikethroughs"] = "ic_fluent_text_strikethrough_s_24_filled.png",
    ["text-strikethrough-s"] = "ic_fluent_text_strikethrough_s_24_filled.png",
    ["text_strikethrough_s"] = "ic_fluent_text_strikethrough_s_24_filled.png",
    ["textsubscript"] = "ic_fluent_text_subscript_24_filled.png",
    ["text-subscript"] = "ic_fluent_text_subscript_24_filled.png",
    ["text_subscript"] = "ic_fluent_text_subscript_24_filled.png",
    ["textsuperscript"] = "ic_fluent_text_superscript_24_filled.png",
    ["text-superscript"] = "ic_fluent_text_superscript_24_filled.png",
    ["text_superscript"] = "ic_fluent_text_superscript_24_filled.png",
    ["textt"] = "ic_fluent_text_t_24_filled.png",
    ["text-t"] = "ic_fluent_text_t_24_filled.png",
    ["text_t"] = "ic_fluent_text_t_24_filled.png",
    ["textunderline"] = "ic_fluent_text_underline_24_filled.png",
    ["text-underline"] = "ic_fluent_text_underline_24_filled.png",
    ["text_underline"] = "ic_fluent_text_underline_24_filled.png",
    ["textwordcount"] = "ic_fluent_text_word_count_24_filled.png",
    ["text-word-count"] = "ic_fluent_text_word_count_24_filled.png",
    ["text_word_count"] = "ic_fluent_text_word_count_24_filled.png",
    ["textwrap"] = "ic_fluent_text_wrap_24_filled.png",
    ["text-wrap"] = "ic_fluent_text_wrap_24_filled.png",
    ["text_wrap"] = "ic_fluent_text_wrap_24_filled.png",
    ["textbox"] = "ic_fluent_textbox_24_filled.png",
    ["textboxalignbottom"] = "ic_fluent_textbox_align_bottom_24_filled.png",
    ["textbox-align-bottom"] = "ic_fluent_textbox_align_bottom_24_filled.png",
    ["textbox_align_bottom"] = "ic_fluent_textbox_align_bottom_24_filled.png",
    ["textboxalignbottomrotate90"] = "ic_fluent_textbox_align_bottom_rotate_90_24_filled.png",
    ["textbox-align-bottom-rotate90"] = "ic_fluent_textbox_align_bottom_rotate_90_24_filled.png",
    ["textbox_align_bottom_rotate90"] = "ic_fluent_textbox_align_bottom_rotate_90_24_filled.png",
    ["textboxaligncenter"] = "ic_fluent_textbox_align_center_24_filled.png",
    ["textbox-align-center"] = "ic_fluent_textbox_align_center_24_filled.png",
    ["textbox_align_center"] = "ic_fluent_textbox_align_center_24_filled.png",
    ["textboxalignmiddle"] = "ic_fluent_textbox_align_middle_24_filled.png",
    ["textbox-align-middle"] = "ic_fluent_textbox_align_middle_24_filled.png",
    ["textbox_align_middle"] = "ic_fluent_textbox_align_middle_24_filled.png",
    ["textboxalignmiddlerotate90"] = "ic_fluent_textbox_align_middle_rotate_90_24_filled.png",
    ["textbox-align-middle-rotate90"] = "ic_fluent_textbox_align_middle_rotate_90_24_filled.png",
    ["textbox_align_middle_rotate90"] = "ic_fluent_textbox_align_middle_rotate_90_24_filled.png",
    ["textboxaligntop"] = "ic_fluent_textbox_align_top_24_filled.png",
    ["textbox-align-top"] = "ic_fluent_textbox_align_top_24_filled.png",
    ["textbox_align_top"] = "ic_fluent_textbox_align_top_24_filled.png",
    ["textboxaligntoprotate90"] = "ic_fluent_textbox_align_top_rotate_90_24_filled.png",
    ["textbox-align-top-rotate90"] = "ic_fluent_textbox_align_top_rotate_90_24_filled.png",
    ["textbox_align_top_rotate90"] = "ic_fluent_textbox_align_top_rotate_90_24_filled.png",
    ["textboxmore"] = "ic_fluent_textbox_more_24_filled.png",
    ["textbox-more"] = "ic_fluent_textbox_more_24_filled.png",
    ["textbox_more"] = "ic_fluent_textbox_more_24_filled.png",
    ["textboxvertical"] = "ic_fluent_textbox_vertical_24_filled.png",
    ["textbox-vertical"] = "ic_fluent_textbox_vertical_24_filled.png",
    ["textbox_vertical"] = "ic_fluent_textbox_vertical_24_filled.png",
    ["thinking"] = "ic_fluent_thinking_24_filled.png",
    ["thumbdislike"] = "ic_fluent_thumb_dislike_24_filled.png",
    ["thumb-dislike"] = "ic_fluent_thumb_dislike_24_filled.png",
    ["thumb_dislike"] = "ic_fluent_thumb_dislike_24_filled.png",
    ["thumblike"] = "ic_fluent_thumb_like_24_filled.png",
    ["thumb-like"] = "ic_fluent_thumb_like_24_filled.png",
    ["thumb_like"] = "ic_fluent_thumb_like_24_filled.png",
    ["ticketdiagonal"] = "ic_fluent_ticket_diagonal_24_filled.png",
    ["ticket-diagonal"] = "ic_fluent_ticket_diagonal_24_filled.png",
    ["ticket_diagonal"] = "ic_fluent_ticket_diagonal_24_filled.png",
    ["tickethorizontal"] = "ic_fluent_ticket_horizontal_24_filled.png",
    ["ticket-horizontal"] = "ic_fluent_ticket_horizontal_24_filled.png",
    ["ticket_horizontal"] = "ic_fluent_ticket_horizontal_24_filled.png",
    ["timeandweather"] = "ic_fluent_time_and_weather_24_filled.png",
    ["time-and-weather"] = "ic_fluent_time_and_weather_24_filled.png",
    ["time_and_weather"] = "ic_fluent_time_and_weather_24_filled.png",
    ["timepicker"] = "ic_fluent_time_picker_24_filled.png",
    ["time-picker"] = "ic_fluent_time_picker_24_filled.png",
    ["time_picker"] = "ic_fluent_time_picker_24_filled.png",
    ["timeline"] = "ic_fluent_timeline_24_filled.png",
    ["timer10"] = "ic_fluent_timer_10_24_filled.png",
    ["timer"] = "ic_fluent_timer_24_filled.png",
    ["timer2"] = "ic_fluent_timer_2_24_filled.png",
    ["timer3"] = "ic_fluent_timer_3_24_filled.png",
    ["timeroff"] = "ic_fluent_timer_off_24_filled.png",
    ["timer-off"] = "ic_fluent_timer_off_24_filled.png",
    ["timer_off"] = "ic_fluent_timer_off_24_filled.png",
    ["toggleleft"] = "ic_fluent_toggle_left_24_filled.png",
    ["toggle-left"] = "ic_fluent_toggle_left_24_filled.png",
    ["toggle_left"] = "ic_fluent_toggle_left_24_filled.png",
    ["toggleright"] = "ic_fluent_toggle_right_24_filled.png",
    ["toggle-right"] = "ic_fluent_toggle_right_24_filled.png",
    ["toggle_right"] = "ic_fluent_toggle_right_24_filled.png",
    ["toolbox"] = "ic_fluent_toolbox_24_filled.png",
    ["tooltipquote"] = "ic_fluent_tooltip_quote_24_filled.png",
    ["tooltip-quote"] = "ic_fluent_tooltip_quote_24_filled.png",
    ["tooltip_quote"] = "ic_fluent_tooltip_quote_24_filled.png",
    ["topspeed"] = "ic_fluent_top_speed_24_filled.png",
    ["top-speed"] = "ic_fluent_top_speed_24_filled.png",
    ["top_speed"] = "ic_fluent_top_speed_24_filled.png",
    ["translate"] = "ic_fluent_translate_24_filled.png",
    ["transmission"] = "ic_fluent_transmission_24_filled.png",
    ["trophy"] = "ic_fluent_trophy_24_filled.png",
    ["tv"] = "ic_fluent_tv_24_filled.png",
    ["tvusb"] = "ic_fluent_tv_usb_24_filled.png",
    ["tv-usb"] = "ic_fluent_tv_usb_24_filled.png",
    ["tv_usb"] = "ic_fluent_tv_usb_24_filled.png",
    ["umbrella"] = "ic_fluent_umbrella_24_filled.png",
    ["uninstallapp"] = "ic_fluent_uninstall_app_24_filled.png",
    ["uninstall-app"] = "ic_fluent_uninstall_app_24_filled.png",
    ["uninstall_app"] = "ic_fluent_uninstall_app_24_filled.png",
    ["usbplug"] = "ic_fluent_usb_plug_24_filled.png",
    ["usb-plug"] = "ic_fluent_usb_plug_24_filled.png",
    ["usb_plug"] = "ic_fluent_usb_plug_24_filled.png",
    ["usbport"] = "ic_fluent_usb_port_24_filled.png",
    ["usb-port"] = "ic_fluent_usb_port_24_filled.png",
    ["usb_port"] = "ic_fluent_usb_port_24_filled.png",
    ["usbstick"] = "ic_fluent_usb_stick_24_filled.png",
    ["usb-stick"] = "ic_fluent_usb_stick_24_filled.png",
    ["usb_stick"] = "ic_fluent_usb_stick_24_filled.png",
    ["vault"] = "ic_fluent_vault_24_filled.png",
    ["vehiclebicycle"] = "ic_fluent_vehicle_bicycle_24_filled.png",
    ["vehicle-bicycle"] = "ic_fluent_vehicle_bicycle_24_filled.png",
    ["vehicle_bicycle"] = "ic_fluent_vehicle_bicycle_24_filled.png",
    ["vehiclebus"] = "ic_fluent_vehicle_bus_24_filled.png",
    ["vehicle-bus"] = "ic_fluent_vehicle_bus_24_filled.png",
    ["vehicle_bus"] = "ic_fluent_vehicle_bus_24_filled.png",
    ["vehiclecab"] = "ic_fluent_vehicle_cab_24_filled.png",
    ["vehicle-cab"] = "ic_fluent_vehicle_cab_24_filled.png",
    ["vehicle_cab"] = "ic_fluent_vehicle_cab_24_filled.png",
    ["vehiclecar"] = "ic_fluent_vehicle_car_24_filled.png",
    ["vehicle-car"] = "ic_fluent_vehicle_car_24_filled.png",
    ["vehicle_car"] = "ic_fluent_vehicle_car_24_filled.png",
    ["vehiclecarcollision"] = "ic_fluent_vehicle_car_collision_24_filled.png",
    ["vehicle-car-collision"] = "ic_fluent_vehicle_car_collision_24_filled.png",
    ["vehicle_car_collision"] = "ic_fluent_vehicle_car_collision_24_filled.png",
    ["vehicleship"] = "ic_fluent_vehicle_ship_24_filled.png",
    ["vehicle-ship"] = "ic_fluent_vehicle_ship_24_filled.png",
    ["vehicle_ship"] = "ic_fluent_vehicle_ship_24_filled.png",
    ["vehiclesubway"] = "ic_fluent_vehicle_subway_24_filled.png",
    ["vehicle-subway"] = "ic_fluent_vehicle_subway_24_filled.png",
    ["vehicle_subway"] = "ic_fluent_vehicle_subway_24_filled.png",
    ["vehicletruck"] = "ic_fluent_vehicle_truck_24_filled.png",
    ["vehicle-truck"] = "ic_fluent_vehicle_truck_24_filled.png",
    ["vehicle_truck"] = "ic_fluent_vehicle_truck_24_filled.png",
    ["vehicletruckprofile"] = "ic_fluent_vehicle_truck_profile_24_filled.png",
    ["vehicle-truck-profile"] = "ic_fluent_vehicle_truck_profile_24_filled.png",
    ["vehicle_truck_profile"] = "ic_fluent_vehicle_truck_profile_24_filled.png",
    ["video"] = "ic_fluent_video_24_filled.png",
    ["video360"] = "ic_fluent_video_360_24_filled.png",
    ["videoadd"] = "ic_fluent_video_add_24_filled.png",
    ["video-add"] = "ic_fluent_video_add_24_filled.png",
    ["video_add"] = "ic_fluent_video_add_24_filled.png",
    ["videobackgroundeffect"] = "ic_fluent_video_background_effect_24_filled.png",
    ["video-background-effect"] = "ic_fluent_video_background_effect_24_filled.png",
    ["video_background_effect"] = "ic_fluent_video_background_effect_24_filled.png",
    ["videoclip"] = "ic_fluent_video_clip_24_filled.png",
    ["video-clip"] = "ic_fluent_video_clip_24_filled.png",
    ["video_clip"] = "ic_fluent_video_clip_24_filled.png",
    ["videooff"] = "ic_fluent_video_off_24_filled.png",
    ["video-off"] = "ic_fluent_video_off_24_filled.png",
    ["video_off"] = "ic_fluent_video_off_24_filled.png",
    ["videoperson"] = "ic_fluent_video_person_24_filled.png",
    ["video-person"] = "ic_fluent_video_person_24_filled.png",
    ["video_person"] = "ic_fluent_video_person_24_filled.png",
    ["videopersoncall"] = "ic_fluent_video_person_call_24_filled.png",
    ["video-person-call"] = "ic_fluent_video_person_call_24_filled.png",
    ["video_person_call"] = "ic_fluent_video_person_call_24_filled.png",
    ["videopersonoff"] = "ic_fluent_video_person_off_24_filled.png",
    ["video-person-off"] = "ic_fluent_video_person_off_24_filled.png",
    ["video_person_off"] = "ic_fluent_video_person_off_24_filled.png",
    ["videopersonsparkle"] = "ic_fluent_video_person_sparkle_24_filled.png",
    ["video-person-sparkle"] = "ic_fluent_video_person_sparkle_24_filled.png",
    ["video_person_sparkle"] = "ic_fluent_video_person_sparkle_24_filled.png",
    ["videopersonstar"] = "ic_fluent_video_person_star_24_filled.png",
    ["video-person-star"] = "ic_fluent_video_person_star_24_filled.png",
    ["video_person_star"] = "ic_fluent_video_person_star_24_filled.png",
    ["videopersonstaroff"] = "ic_fluent_video_person_star_off_24_filled.png",
    ["video-person-star-off"] = "ic_fluent_video_person_star_off_24_filled.png",
    ["video_person_star_off"] = "ic_fluent_video_person_star_off_24_filled.png",
    ["videoplaypause"] = "ic_fluent_video_play_pause_24_filled.png",
    ["video-play-pause"] = "ic_fluent_video_play_pause_24_filled.png",
    ["video_play_pause"] = "ic_fluent_video_play_pause_24_filled.png",
    ["videoprohibited"] = "ic_fluent_video_prohibited_24_filled.png",
    ["video-prohibited"] = "ic_fluent_video_prohibited_24_filled.png",
    ["video_prohibited"] = "ic_fluent_video_prohibited_24_filled.png",
    ["videosecurity"] = "ic_fluent_video_security_24_filled.png",
    ["video-security"] = "ic_fluent_video_security_24_filled.png",
    ["video_security"] = "ic_fluent_video_security_24_filled.png",
    ["videoswitch"] = "ic_fluent_video_switch_24_filled.png",
    ["video-switch"] = "ic_fluent_video_switch_24_filled.png",
    ["video_switch"] = "ic_fluent_video_switch_24_filled.png",
    ["viewdesktop"] = "ic_fluent_view_desktop_24_filled.png",
    ["view-desktop"] = "ic_fluent_view_desktop_24_filled.png",
    ["view_desktop"] = "ic_fluent_view_desktop_24_filled.png",
    ["viewdesktopmobile"] = "ic_fluent_view_desktop_mobile_24_filled.png",
    ["view-desktop-mobile"] = "ic_fluent_view_desktop_mobile_24_filled.png",
    ["view_desktop_mobile"] = "ic_fluent_view_desktop_mobile_24_filled.png",
    ["voicemail"] = "ic_fluent_voicemail_24_filled.png",
    ["vote"] = "ic_fluent_vote_24_filled.png",
    ["walkietalkie"] = "ic_fluent_walkie_talkie_24_filled.png",
    ["walkie-talkie"] = "ic_fluent_walkie_talkie_24_filled.png",
    ["walkie_talkie"] = "ic_fluent_walkie_talkie_24_filled.png",
    ["wallet"] = "ic_fluent_wallet_24_filled.png",
    ["wallpaper"] = "ic_fluent_wallpaper_24_filled.png",
    ["wand"] = "ic_fluent_wand_24_filled.png",
    ["warning"] = "ic_fluent_warning_24_filled.png",
    ["weatherblowingsnow"] = "ic_fluent_weather_blowing_snow_24_filled.png",
    ["weather-blowing-snow"] = "ic_fluent_weather_blowing_snow_24_filled.png",
    ["weather_blowing_snow"] = "ic_fluent_weather_blowing_snow_24_filled.png",
    ["weathercloudy"] = "ic_fluent_weather_cloudy_24_filled.png",
    ["weather-cloudy"] = "ic_fluent_weather_cloudy_24_filled.png",
    ["weather_cloudy"] = "ic_fluent_weather_cloudy_24_filled.png",
    ["weatherdrizzle"] = "ic_fluent_weather_drizzle_24_filled.png",
    ["weather-drizzle"] = "ic_fluent_weather_drizzle_24_filled.png",
    ["weather_drizzle"] = "ic_fluent_weather_drizzle_24_filled.png",
    ["weatherduststorm"] = "ic_fluent_weather_duststorm_24_filled.png",
    ["weather-duststorm"] = "ic_fluent_weather_duststorm_24_filled.png",
    ["weather_duststorm"] = "ic_fluent_weather_duststorm_24_filled.png",
    ["weatherfog"] = "ic_fluent_weather_fog_24_filled.png",
    ["weather-fog"] = "ic_fluent_weather_fog_24_filled.png",
    ["weather_fog"] = "ic_fluent_weather_fog_24_filled.png",
    ["weatherhailday"] = "ic_fluent_weather_hail_day_24_filled.png",
    ["weather-hail-day"] = "ic_fluent_weather_hail_day_24_filled.png",
    ["weather_hail_day"] = "ic_fluent_weather_hail_day_24_filled.png",
    ["weatherhailnight"] = "ic_fluent_weather_hail_night_24_filled.png",
    ["weather-hail-night"] = "ic_fluent_weather_hail_night_24_filled.png",
    ["weather_hail_night"] = "ic_fluent_weather_hail_night_24_filled.png",
    ["weatherhaze"] = "ic_fluent_weather_haze_24_filled.png",
    ["weather-haze"] = "ic_fluent_weather_haze_24_filled.png",
    ["weather_haze"] = "ic_fluent_weather_haze_24_filled.png",
    ["weathermoon"] = "ic_fluent_weather_moon_24_filled.png",
    ["weather-moon"] = "ic_fluent_weather_moon_24_filled.png",
    ["weather_moon"] = "ic_fluent_weather_moon_24_filled.png",
    ["weathermoonoff"] = "ic_fluent_weather_moon_off_24_filled.png",
    ["weather-moon-off"] = "ic_fluent_weather_moon_off_24_filled.png",
    ["weather_moon_off"] = "ic_fluent_weather_moon_off_24_filled.png",
    ["weatherpartlycloudyday"] = "ic_fluent_weather_partly_cloudy_day_24_filled.png",
    ["weather-partly-cloudy-day"] = "ic_fluent_weather_partly_cloudy_day_24_filled.png",
    ["weather_partly_cloudy_day"] = "ic_fluent_weather_partly_cloudy_day_24_filled.png",
    ["weatherpartlycloudynight"] = "ic_fluent_weather_partly_cloudy_night_24_filled.png",
    ["weather-partly-cloudy-night"] = "ic_fluent_weather_partly_cloudy_night_24_filled.png",
    ["weather_partly_cloudy_night"] = "ic_fluent_weather_partly_cloudy_night_24_filled.png",
    ["weatherrain"] = "ic_fluent_weather_rain_24_filled.png",
    ["weather-rain"] = "ic_fluent_weather_rain_24_filled.png",
    ["weather_rain"] = "ic_fluent_weather_rain_24_filled.png",
    ["weatherrainshowersday"] = "ic_fluent_weather_rain_showers_day_24_filled.png",
    ["weather-rain-showers-day"] = "ic_fluent_weather_rain_showers_day_24_filled.png",
    ["weather_rain_showers_day"] = "ic_fluent_weather_rain_showers_day_24_filled.png",
    ["weatherrainshowersnight"] = "ic_fluent_weather_rain_showers_night_24_filled.png",
    ["weather-rain-showers-night"] = "ic_fluent_weather_rain_showers_night_24_filled.png",
    ["weather_rain_showers_night"] = "ic_fluent_weather_rain_showers_night_24_filled.png",
    ["weatherrainsnow"] = "ic_fluent_weather_rain_snow_24_filled.png",
    ["weather-rain-snow"] = "ic_fluent_weather_rain_snow_24_filled.png",
    ["weather_rain_snow"] = "ic_fluent_weather_rain_snow_24_filled.png",
    ["weathersnow"] = "ic_fluent_weather_snow_24_filled.png",
    ["weather-snow"] = "ic_fluent_weather_snow_24_filled.png",
    ["weather_snow"] = "ic_fluent_weather_snow_24_filled.png",
    ["weathersnowshowerday"] = "ic_fluent_weather_snow_shower_day_24_filled.png",
    ["weather-snow-shower-day"] = "ic_fluent_weather_snow_shower_day_24_filled.png",
    ["weather_snow_shower_day"] = "ic_fluent_weather_snow_shower_day_24_filled.png",
    ["weathersnowshowernight"] = "ic_fluent_weather_snow_shower_night_24_filled.png",
    ["weather-snow-shower-night"] = "ic_fluent_weather_snow_shower_night_24_filled.png",
    ["weather_snow_shower_night"] = "ic_fluent_weather_snow_shower_night_24_filled.png",
    ["weathersnowflake"] = "ic_fluent_weather_snowflake_24_filled.png",
    ["weather-snowflake"] = "ic_fluent_weather_snowflake_24_filled.png",
    ["weather_snowflake"] = "ic_fluent_weather_snowflake_24_filled.png",
    ["weathersqualls"] = "ic_fluent_weather_squalls_24_filled.png",
    ["weather-squalls"] = "ic_fluent_weather_squalls_24_filled.png",
    ["weather_squalls"] = "ic_fluent_weather_squalls_24_filled.png",
    ["weathersunny"] = "ic_fluent_weather_sunny_24_filled.png",
    ["weather-sunny"] = "ic_fluent_weather_sunny_24_filled.png",
    ["weather_sunny"] = "ic_fluent_weather_sunny_24_filled.png",
    ["weathersunnyhigh"] = "ic_fluent_weather_sunny_high_24_filled.png",
    ["weather-sunny-high"] = "ic_fluent_weather_sunny_high_24_filled.png",
    ["weather_sunny_high"] = "ic_fluent_weather_sunny_high_24_filled.png",
    ["weathersunnylow"] = "ic_fluent_weather_sunny_low_24_filled.png",
    ["weather-sunny-low"] = "ic_fluent_weather_sunny_low_24_filled.png",
    ["weather_sunny_low"] = "ic_fluent_weather_sunny_low_24_filled.png",
    ["weatherthunderstorm"] = "ic_fluent_weather_thunderstorm_24_filled.png",
    ["weather-thunderstorm"] = "ic_fluent_weather_thunderstorm_24_filled.png",
    ["weather_thunderstorm"] = "ic_fluent_weather_thunderstorm_24_filled.png",
    ["webasset"] = "ic_fluent_web_asset_24_filled.png",
    ["web-asset"] = "ic_fluent_web_asset_24_filled.png",
    ["web_asset"] = "ic_fluent_web_asset_24_filled.png",
    ["whiteboard"] = "ic_fluent_whiteboard_24_filled.png",
    ["wifi1"] = "ic_fluent_wifi_1_24_filled.png",
    ["wifi2"] = "ic_fluent_wifi_2_24_filled.png",
    ["wifi3"] = "ic_fluent_wifi_3_24_filled.png",
    ["wifi4"] = "ic_fluent_wifi_4_24_filled.png",
    ["wifilock"] = "ic_fluent_wifi_lock_24_filled.png",
    ["wifi-lock"] = "ic_fluent_wifi_lock_24_filled.png",
    ["wifi_lock"] = "ic_fluent_wifi_lock_24_filled.png",
    ["wifioff"] = "ic_fluent_wifi_off_24_filled.png",
    ["wifi-off"] = "ic_fluent_wifi_off_24_filled.png",
    ["wifi_off"] = "ic_fluent_wifi_off_24_filled.png",
    ["wifiprotected"] = "ic_fluent_wifi_protected_24_filled.png",
    ["wifi-protected"] = "ic_fluent_wifi_protected_24_filled.png",
    ["wifi_protected"] = "ic_fluent_wifi_protected_24_filled.png",
    ["wifiwarning"] = "ic_fluent_wifi_warning_24_filled.png",
    ["wifi-warning"] = "ic_fluent_wifi_warning_24_filled.png",
    ["wifi_warning"] = "ic_fluent_wifi_warning_24_filled.png",
    ["window"] = "ic_fluent_window_24_filled.png",
    ["windowarrowup"] = "ic_fluent_window_arrow_up_24_filled.png",
    ["window-arrow-up"] = "ic_fluent_window_arrow_up_24_filled.png",
    ["window_arrow_up"] = "ic_fluent_window_arrow_up_24_filled.png",
    ["windowdevtools"] = "ic_fluent_window_dev_tools_24_filled.png",
    ["window-dev-tools"] = "ic_fluent_window_dev_tools_24_filled.png",
    ["window_dev_tools"] = "ic_fluent_window_dev_tools_24_filled.png",
    ["windownew"] = "ic_fluent_window_new_24_filled.png",
    ["window-new"] = "ic_fluent_window_new_24_filled.png",
    ["window_new"] = "ic_fluent_window_new_24_filled.png",
    ["windowshield"] = "ic_fluent_window_shield_24_filled.png",
    ["window-shield"] = "ic_fluent_window_shield_24_filled.png",
    ["window_shield"] = "ic_fluent_window_shield_24_filled.png",
    ["wrench"] = "ic_fluent_wrench_24_filled.png",
    ["xboxconsole"] = "ic_fluent_xbox_console_24_filled.png",
    ["xbox-console"] = "ic_fluent_xbox_console_24_filled.png",
    ["xbox_console"] = "ic_fluent_xbox_console_24_filled.png",
    ["xray"] = "ic_fluent_xray_24_filled.png",
    ["zoomin"] = "ic_fluent_zoom_in_24_filled.png",
    ["zoom-in"] = "ic_fluent_zoom_in_24_filled.png",
    ["zoom_in"] = "ic_fluent_zoom_in_24_filled.png",
    ["zoomout"] = "ic_fluent_zoom_out_24_filled.png",
    ["zoom-out"] = "ic_fluent_zoom_out_24_filled.png",
    ["zoom_out"] = "ic_fluent_zoom_out_24_filled.png",
}

local base_url = 'https://raw.githubusercontent.com/EORScopeZ/slatelib/main/assets/fluent/'
local asset_cache: {[string]: string} = {}

local function getRequest()
    local env = getfenv()
    return env.request or env.http_request or (env.syn and env.syn.request) or (env.http and env.http.request) or (env.fluxus and env.fluxus.request)
end

function fluentIcons.get(name: string): string?
    if not name or type(name) ~= 'string' then
        return nil
    end

    local clean = string.lower(string.gsub(name, '[%s_%-]', ''))
    local pngFile = files[clean] or files[string.lower(name)]

    if not pngFile then
        return nil
    end

    if asset_cache[pngFile] then
        return asset_cache[pngFile]
    end

    local env = getfenv()
    local getcustomasset = env.getcustomasset or env.getsynasset
    local isfile = env.isfile
    local writefile = env.writefile
    local makefolder = env.makefolder

    if typeof(getcustomasset) == 'function' and typeof(writefile) == 'function' then
        local folder = 'slate_assets'
        local subfolder = 'slate_assets/fluent'
        local filePath = subfolder .. '/' .. pngFile

        if typeof(makefolder) == 'function' then
            pcall(makefolder, folder)
            pcall(makefolder, subfolder)
        end

        local fileExists = typeof(isfile) == 'function' and isfile(filePath)

        if not fileExists then
            local req = getRequest()
            if typeof(req) == 'function' then
                local success, res = pcall(req, {
                    Url = base_url .. pngFile,
                    Method = 'GET',
                })
                if success and res and res.StatusCode == 200 and res.Body then
                    pcall(writefile, filePath, res.Body)
                    fileExists = true
                end
            end
        end

        if fileExists then
            local ok, customUri = pcall(getcustomasset, filePath)
            if ok and typeof(customUri) == 'string' then
                asset_cache[pngFile] = customUri
                return customUri
            end
        end
    end

    return base_url .. pngFile
end

return fluentIcons

end)() end,
    [49] = function()local wax,script,require=ImportGlobals(49)local ImportGlobals return (function(...)local services = require(script.Parent.services)
local httpService = services.getService('HttpService')
local runService = services.getService('RunService')
local fileSystem = require(script.Parent.filesystem)
local assetResolver = require(script.Parent.assetResolver)
local log = require(script.Parent.log)
local path = require(script.Parent.path)

local function jsonEncode(data: unknown): string?
    local success, result = pcall(function()
        return httpService:JSONEncode(data)
    end)

    if success and type(result) == 'string' then
        return result
    else
        log.warn('Failed to encode JSON:', result)

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
        log.warn('Failed to decode JSON:', result)

        return nil
    end
end

local fontManager = {}

fontManager.__type = 'fontManager'

export type FontFace = {name: string, family: string, weight: number, style: string, assetId: string}
export type FontManifest = {name: string, faces: {FontFace}}
export type CachedFont = {customId: number | string, manifest: FontManifest, loadedFromDisk: boolean, variants: {[string]: Font}}
export type FontCache = {[number]: CachedFont}
export type FontResolverOptions = {fallbackFont: Font?, saveToDisk: boolean?, skipCache: boolean?}
type FontManagerState = {_debug: boolean, _pendingLoads: {[string]: {thread}}, rootFolder: string, assetResolver: assetResolver.AssetResolver, defaultOptions: FontResolverOptions, fontCache: FontCache?}
export type FontManager = FontManagerState&{resolve: (self:FontManager, id:number | string) -> Font?, loadFont: (self:FontManager, id:(number | string)?, fontWeight:Enum.FontWeight?, fontStyle:Enum.FontStyle?, saveToDisk:boolean?, skipCache:boolean?) -> Font?, getFontFromId: (self:FontManager, id:number | string) -> Font?}
export type fontManager = FontManager

local function validateManifest(manifest: unknown): FontManifest?
    local candidate = manifest::any

    if type(candidate) ~= 'table' or type(candidate.name) ~= 'string' or type(candidate.faces) ~= 'table' then
        return nil
    end

    candidate.name = path.sanitizeFile(candidate.name)

    if #candidate.name == 0 or #candidate.faces == 0 then
        return nil
    end

    for _, face in candidate.faces do
        if type(face) ~= 'table' or type(face.name) ~= 'string' or type(face.assetId) ~= 'string' then
            return nil
        end

        face.name = path.sanitizeFile(face.name)

        if #face.name == 0 then
            return nil
        end
    end

    return candidate::FontManifest
end

local fontSignatures = {
    '\0\1\0\0',
    'OTTO',
    'true',
    'ttcf',
    'wOFF',
    'wOF2',
}

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
    return tostring(fontWeight) .. '|' .. tostring(fontStyle)
end
local function resolveId(id: unknown): number?
    if type(id) == 'number' then
        return id
    end
    if type(id) == 'string' then
        return tonumber(id)
    end

    return nil
end

function fontManager.__index(self: FontManagerState, key: unknown): unknown
    local classMember = (fontManager::any)[key]

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

            for _, font in pairs(cached.variants or {})do
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
    local defaultResolverOptions = defaultOptions or {
        saveToDisk = true,
        skipCache = not useCache or false,
        fallbackFont = Font.fromEnum(Enum.Font.SourceSans),
    }
    local self = setmetatable({
        rootFolder = rootFolder,
        fontCache = if useCache then{}::FontCache else nil,
        assetResolver = assetResolver.new(useCache, assetContentDownloadUrl),
        defaultOptions = defaultResolverOptions,
        _debug = useDebug or runService:IsStudio() or false,
        _pendingLoads = {},
    }::FontManagerState, fontManager)::any

    pcall(fileSystem.ensureFolder, rootFolder)

    return self
end

local function fetchFont(
    self: FontManager,
    resolvedId: number,
    requestedFontWeight: Enum.FontWeight,
    requestedFontStyle: Enum.FontStyle,
    cacheKey: string
): Font?
    local manifestPath = self.rootFolder .. '/' .. resolvedId .. '.json'

    if typeof(fileSystem.isfile) ~= 'function' then
        return self.defaultOptions.fallbackFont
    end

    local possibleFontManifest: string? = nil
    local downloadedManifest = false

    if runService:IsStudio() and self._debug then
        log.warn(
[[Font manifest loading is not supported in Studio. Using default font manifest for testing.]])

        possibleFontManifest = 
[[{"name":"Inter","faces":[{"name":"Thin","weight":100,"style":"normal","assetId":"rbxassetid://12187277209"},{"name":"Extra Light","weight":200,"style":"normal","assetId":"rbxassetid://12187293441"},{"name":"Light","weight":300,"style":"normal","assetId":"rbxassetid://12187268450"},{"name":"Regular","weight":400,"style":"normal","assetId":"rbxassetid://12187266066"},{"name":"Medium","weight":500,"style":"normal","assetId":"rbxassetid://12187336822"},{"name":"Semi Bold","weight":600,"style":"normal","assetId":"rbxassetid://12187254443"},{"name":"Bold","weight":700,"style":"normal","assetId":"rbxassetid://12187275575"},{"name":"Extra Bold","weight":800,"style":"normal","assetId":"rbxassetid://12187267750"},{"name":"Black","weight":900,"style":"normal","assetId":"rbxassetid://12187359223"}]}]]
    elseif fileSystem.isfile(manifestPath) then
        local ok, contents = pcall(fileSystem.readfile, manifestPath)

        possibleFontManifest = ok and contents or nil
    else
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
                log.warn('Failed to parse font manifest for font id: ' .. tostring(resolvedId) .. '. Error: ' .. tostring(parsedManifest))
            end
        end
    else
        return self.defaultOptions.fallbackFont
    end
    if not fontManifest then
        if self._debug then
            log.warn('Font manifest is nil for font id: ' .. tostring(resolvedId))
        end

        pcall(fileSystem.delfile, manifestPath)

        return self.defaultOptions.fallbackFont
    end
    if downloadedManifest and possibleFontManifest then
        pcall(fileSystem.writefile, manifestPath, possibleFontManifest)
    end

    local fontDirectory = self.rootFolder .. '/' .. fontManifest.name
    local madeAllFontsLocal = true

    if not pcall(fileSystem.ensureFolder, fontDirectory) then
        return self.defaultOptions.fallbackFont
    end

    for i, face in ipairs(fontManifest.faces)do
        local fontFacePath = fontDirectory .. '/' .. face.name:gsub(' ', '-') .. '.ttf'

        if fileSystem.isfile(fontFacePath) then
            local readOk, existing = pcall(fileSystem.readfile, fontFacePath)

            if not readOk or type(existing) ~= 'string' or not isFontBody(existing) then
                pcall(fileSystem.delfile, fontFacePath)
            end
        end
        if not fileSystem.isfile(fontFacePath) then
            local fontFaceId = self.assetResolver:resolve(face.assetId)
            local fontFaceContent = if fontFaceId ~= nil then self.assetResolver:getAssetContentFromId(fontFaceId, false)else nil

            if not fontFaceContent or not isFontBody(fontFaceContent) then
                madeAllFontsLocal = false

                if self._debug then
                    log.warn('Font face content is missing or not a font for font id: ' .. tostring(resolvedId) .. ', face: ' .. face.name)
                end

                continue
            end

            pcall(fileSystem.writefile, fontFacePath, fontFaceContent)
        end

        local ok, uri = pcall(env.getcustomasset, fontFacePath)

        if ok and type(uri) == 'string' then
            fontManifest.faces[i].assetId = uri

            if self._debug then
                log.print('Loaded font face for id: ' .. tostring(resolvedId) .. ', face: ' .. face.name)
            end
        else
            madeAllFontsLocal = false

            if self._debug then
                log.warn('Failed to load font face for id: ' .. tostring(resolvedId) .. ', face: ' .. face.name)
            end
        end
    end

    if not madeAllFontsLocal then
        return self.defaultOptions.fallbackFont
    end

    local encodedManifest = jsonEncode(fontManifest)

    if not encodedManifest or not pcall(fileSystem.writefile, fontDirectory .. '/manifest.json', encodedManifest) then
        return self.defaultOptions.fallbackFont
    end

    local manifestOk, fontManifestId = pcall(env.getcustomasset, fontDirectory .. '/manifest.json')

    if not manifestOk or not fontManifestId then
        if self._debug then
            log.warn('Failed to load font manifest for id: ' .. tostring(resolvedId))
        end

        return self.defaultOptions.fallbackFont
    end

    local ok, loadedFont = pcall(Font.new, fontManifestId::any, requestedFontWeight, requestedFontStyle)

    if not ok or not loadedFont then
        if self._debug then
            log.warn('Failed to load font for id: ' .. tostring(resolvedId))
        end

        return self.defaultOptions.fallbackFont
    end

    local fontCache = self.fontCache

    if fontCache then
        fontCache[resolvedId] = {
            customId = fontManifestId,
            manifest = fontManifest,
            loadedFromDisk = true,
            variants = {[cacheKey] = loadedFont},
        }

        if self._debug then
            log.print('Cached font for id: ' .. tostring(resolvedId))
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
        log.warn('Invalid font id: ' .. tostring(id))

        return self.defaultOptions.fallbackFont
    end

    local fontCache = self.fontCache

    if fontCache and not skipCache then
        local cachedFont = fontCache[resolvedId]

        if cachedFont then
            local cachedVariant = cachedFont.variants and cachedFont.variants[cacheKey]

            if cachedVariant then
                if self._debug then
                    log.print('Loaded font from cache for id: ' .. tostring(resolvedId))
                end

                return cachedVariant
            end

            local ok, loadedFont = pcall(Font.new, cachedFont.customId::any, requestedFontWeight, requestedFontStyle)

            if ok and loadedFont then
                cachedFont.variants = cachedFont.variants or {}
                cachedFont.variants[cacheKey] = loadedFont

                if self._debug then
                    log.print('Loaded font variant from cache for id: ' .. tostring(resolvedId))
                end

                return loadedFont
            else
                if self._debug then
                    log.warn('Failed to load font from cache for id: ' .. tostring(resolvedId))
                end

                fontCache[resolvedId] = nil

                return self.defaultOptions.fallbackFont
            end
        end
    end
    if not saveToDisk then
        if self._debug then
            log.warn(
[[Font loading without saving to disk can be detected by Anti-cheats.]])
        end

        return self.defaultOptions.fallbackFont
    end

    local pendingLoads = self._pendingLoads
    local pendingKey = tostring(resolvedId) .. '|' .. cacheKey
    local waiting = pendingLoads[pendingKey]

    if waiting then
        table.insert(waiting, coroutine.running())

        return coroutine.yield()
    end

    pendingLoads[pendingKey] = {}

    local ok, result = pcall(fetchFont, self, resolvedId, requestedFontWeight, requestedFontStyle, cacheKey)
    local loadedFont = if ok then result else self.defaultOptions.fallbackFont

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
                log.print('Resolved font for id: ' .. tostring(resolvedId))
            end

            for _, font in pairs(cached.variants or {})do
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
    [50] = function()local wax,script,require=ImportGlobals(50)local ImportGlobals return (function(...)local functions = {}
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
    [51] = function()local wax,script,require=ImportGlobals(51)local ImportGlobals return (function(...)local fluentIcons = require(script.Parent.fluentIcons)
local constants = require(script.Parent.constants)

type AvatarCallback = (uri: string) -> ()
type PreloadCallback = (failed: number) -> ()

local image = {}

image.rewrites = {}
image.onBlock = nil

type PendingProperties = {[string]: boolean}
image.pending = {}

local imageProperties: {[string]: boolean} = {
    Image = true,
    HoverImage = true,
    PressedImage = true,
}

function image.preload(onSettled: PreloadCallback?): (boolean, number)
    if onSettled then
        task.defer(onSettled, 0)
    end

    return true, 0
end

function image.avatar(userId: number, onReady: AvatarCallback?): string
    local uri = `rbxthumb://type=AvatarHeadShot&id={userId}&w=48&h=48`

    if onReady then
        task.defer(onReady, uri)
    end

    return uri
end

function image.assign(instance: Instance, property: string, value: unknown)
    local target = instance::any

    if not imageProperties[property] then
        target[property] = value

        return
    end

    target[property] = image.resolve(value)
end

function image.resolve(value: unknown): string
    if value == nil or value == 0 or value == '' then
        return ''
    end

    if type(value) == 'number' then
        return `rbxthumb://type=Asset&id={value}&w=420&h=420`
    end

    if type(value) == 'string' then
        if string.sub(value, 1, 11) == 'rbxasset://' or string.sub(value, 1, 11) == 'rbxthumb://' or string.sub(value, 1, 7) == 'http://' or string.sub(value, 1, 8) == 'https://' then
            return value
        end

        local assetId = string.match(value, '^rbxassetid://(%d+)$')

        if assetId then
            return `rbxthumb://type=Asset&id={assetId}&w=420&h=420`
        end

        if string.match(value, '^%d+$') then
            return `rbxthumb://type=Asset&id={value}&w=420&h=420`
        end

        local fluentRes = fluentIcons.get(value)

        if fluentRes then
            if type(fluentRes) == 'number' or string.match(tostring(fluentRes), '^%d+$') then
                return `rbxthumb://type=Asset&id={fluentRes}&w=420&h=420`
            end

            return tostring(fluentRes)
        end

        local constId = constants.icons[value]

        if constId then
            return `rbxthumb://type=Asset&id={constId}&w=420&h=420`
        end

        return value
    end

    return ''
end

return image

end)() end,
    [52] = function()local wax,script,require=ImportGlobals(52)local ImportGlobals return (function(...)local filesystem = require(script.Parent.filesystem)
local path = require(script.Parent.path)
local variables = require(script.Parent.variables)
local constants = require(script.Parent.constants)

export type RewriteMap = {[number]: string}
export type CacheSettledCallback = (failed:number) -> ()
export type PreloadCallback = CacheSettledCallback
export type AvatarCallback = (uri:string) -> ()
export type OnCachedCallback = (id:number) -> ()
export type ThumbnailEntry = {state: string?, imageUrl: string?}
export type ThumbnailResponse = {data: {ThumbnailEntry}?}

local imageCache = {}
local cacheRoot = variables.fileSystemManager:getRootFolder()
local cacheFolder = variables.fileSystemManager:getAssetsFolder()
local assetResolver = variables.assetResolver
local assetBase = 
[[https://raw.githubusercontent.com/SiriusSoftwareLtd/rayfield-gen2/main/assets/]]
local headshotPx = 48
local thumbEndpoint = 
[[https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=%dx%d&format=Png&isCircular=false]]
local manifest: {[number]: string} = {}

for _, id in constants.icons do
    local iconId = id::number

    manifest[iconId] = assetBase .. tostring(iconId) .. '.png'
end

local manifestSize = 0

for _ in manifest do
    manifestSize += 1
end

imageCache.rewrites = {}::RewriteMap
imageCache.onCached = nil::OnCachedCallback?

local pngMagic = '\137PNG\r\n\26\n'

local function cacheFile(filePath: string, url: string): string?
    if type(getfenv().getcustomasset) ~= 'function' or typeof(filesystem.isfile) ~= 'function' then
        return nil
    end
    if not filesystem.isfile(filePath) then
        pcall(filesystem.ensureFolder, cacheRoot)
        pcall(filesystem.ensureFolder, cacheFolder)

        local body = assetResolver:getAssetContentFromUrl(url, filePath, false)

        if not body or string.sub(body, 1, 8) ~= pngMagic then
            return nil
        end
        if not pcall(filesystem.writefile, filePath, body) then
            return nil
        end
    end

    local ok, uri = pcall(getfenv().getcustomasset, filePath)

    return if ok and type(uri) == 'string'then uri else nil
end
local function avatarPath(userId: number): string
    return path.join(cacheFolder, 'avatar_' .. tostring(userId) .. '.png')
end
local function decodeThumbnailUrl(body: string): string?
    local decodeOk, parsed = pcall(function()
        return variables.httpService:JSONDecode(body)
    end)

    if not decodeOk or type(parsed) ~= 'table' then
        return nil
    end

    local data = (parsed::ThumbnailResponse).data

    if type(data) ~= 'table' then
        return nil
    end

    local entry = data[1]

    if type(entry) ~= 'table' then
        return nil
    end

    local thumbnail = entry::ThumbnailEntry

    if thumbnail.state == 'Completed' and type(thumbnail.imageUrl) == 'string' then
        return thumbnail.imageUrl
    end

    return nil
end
local function fetchAvatar(userId: number): string?
    local cdnUrl: string? = nil

    for attempt = 1, 4 do
        local body = assetResolver:getAssetContentFromUrl(string.format(thumbEndpoint, userId, headshotPx, headshotPx), 'avatar:' .. tostring(userId), attempt > 1)

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

local pendingAvatars: {[number]: {AvatarCallback}} = {}
local failedAvatars: {[number]: boolean} = {}

function imageCache.preload(onSettled: PreloadCallback?): (boolean,number)
    local env = getfenv()

    if type(env.getcustomasset) ~= 'function' or typeof(filesystem.isfile) ~= 'function' then
        if onSettled then
            task.defer(onSettled, manifestSize)
        end

        return false, manifestSize
    end

    local rewrites = imageCache.rewrites

    table.clear(rewrites)

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
    local spawning = true

    for id, url in manifest do
        local filePath = path.join(cacheFolder, tostring(id) .. '.png')
        local uri: string? = nil

        if filesystem.isfile(filePath) then
            local ok, res = pcall(env.getcustomasset, filePath)

            uri = if ok and type(res) == 'string'then res else nil
        end
        if uri then
            rewrites[id] = uri
        else
            missing += 1
            pending += 1

            task.spawn(function()
                local cached = cacheFile(filePath, url)

                if cached then
                    rewrites[id] = cached

                    if imageCache.onCached then
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
    if type(userId) ~= 'number' then
        return ''
    end
    if typeof(filesystem.isfile) ~= 'function' then
        return ''
    end

    local filePath = avatarPath(userId)

    if filesystem.isfile(filePath) then
        local ok, uri = pcall(getfenv().getcustomasset, filePath)

        if ok and type(uri) == 'string' then
            return uri
        end
    end
    if failedAvatars[userId] then
        return ''
    end

    local waiting = pendingAvatars[userId]

    if waiting then
        if onReady then
            table.insert(waiting, onReady)
        end

        return ''
    end
    if onReady then
        pendingAvatars[userId] = {onReady}

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
                    pcall(callback, uri)
                end
            end
        end)
    end

    return ''
end

return imageCache

end)() end,
    [53] = function()local wax,script,require=ImportGlobals(53)local ImportGlobals return (function(...)local layouts = {}
local topbarHeight = 64
local tabStripTop = topbarHeight - 1
local tabStripHeight = 38
local tabStripGap = 3

export type Mode = 'top' | 'sidebar'
export type Layout = {mode: Mode, topbarHeight: number, chromeHeight: number, pageDirection: Enum.FillDirection, fadeSize: UDim2, fadeTransparency: NumberSequence, fadeCorners: {string}?, tabStripTop: number?, tabStripHeight: number?, railWidth: number?, railCollapsedWidth: number?, railCollapseBelow: number?, rowHeight: number?, rowCornerRadius: number?, rowSpacing: number?, railPadding: number?, rowInset: number?, rowPadding: number?, rowContentSpacing: number?, rowIconSize: number?, footerHeight: number?, avatarSize: number?, cardTransparency: number?, cardStrokeRotation: number?, cardStrokeTransparency: NumberSequence?, cardCorners: {string}?}

layouts.top = {
    mode = 'top'::Mode,
    topbarHeight = topbarHeight,
    chromeHeight = tabStripTop + tabStripHeight + tabStripGap,
    tabStripTop = tabStripTop,
    tabStripHeight = tabStripHeight,
    pageDirection = Enum.FillDirection.Horizontal,
    fadeSize = UDim2.new(1, 0, -0.093, 100),
    fadeTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.4414, 0),
        NumberSequenceKeypoint.new(0.7007, 0.631),
        NumberSequenceKeypoint.new(1, 1),
    }),
}::Layout
layouts.sidebar = {
    mode = 'sidebar'::Mode,
    topbarHeight = topbarHeight,
    chromeHeight = topbarHeight,
    railWidth = 219,
    railCollapsedWidth = 64,
    railCollapseBelow = 589,
    rowHeight = 38,
    rowCornerRadius = 14,
    rowSpacing = 4,
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
    cardCorners = {
        'TopLeftRadius',
        'BottomRightRadius',
    },
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
    fadeCorners = {
        'BottomRightRadius',
    },
}::Layout

function layouts.get(mode: unknown): Layout?
    if mode == 'sidebar' then
        return layouts.sidebar
    elseif mode == 'top' then
        return layouts.top
    end

    return nil
end
function layouts.railWidthFor(layout: Layout, windowWidth: number): number
    if layout.mode ~= 'sidebar' then
        return 0
    end

    local full = layout.railWidth::number

    if windowWidth < (layout.railCollapseBelow::number) then
        return layout.railCollapsedWidth::number
    end

    return full
end

return layouts

end)() end,
    [54] = function()local wax,script,require=ImportGlobals(54)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local log = require(script.Parent.log)
local locale = {}

export type LocaleToken = {[any]: string}
export type Translator = (source:string, localeId:string) -> string?
export type TranslationTables = {[string]: {[string]: string}}

locale.strings = {}::TranslationTables
locale.current = 'en'
locale.translator = nil::Translator?

local tokenTag = {}

local function languageOf(id: string): string
    return string.match(id, '^(%a+)') or id
end

function locale.t(source: unknown): unknown
    if type(source) ~= 'string' or source == '' then
        return source
    end

    return {[tokenTag] = source}
end
function locale.isToken(value: unknown): boolean
    return type(value) == 'table' and type((value::{[any]: unknown})[tokenTag]) == 'string'
end
function locale.sourceOf(token: LocaleToken): string
    return token[tokenTag]
end
function locale.resolve(source: unknown): any
    if type(source) ~= 'string' then
        return source
    end
    if locale.translator then
        local ok, translated = pcall(locale.translator, source, locale.current)

        if ok and type(translated) == 'string' and translated ~= '' then
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
function locale.register(tables: TranslationTables?)
    if type(tables) ~= 'table' then
        return
    end

    for id, entries in tables do
        if type(id) == 'string' and type(entries) == 'table' then
            id = string.lower(id)

            local target = locale.strings[id]

            if not target then
                target = {}
                locale.strings[id] = target
            end

            for source, translated in entries do
                if type(source) == 'string' and type(translated) == 'string' then
                    target[source] = translated
                else
                    log.warn(`Slate: skipping a '{id}' translation, entries must be string to string.`)
                end
            end
        end
    end
end
function locale.setActive(localeId: string?): string
    locale.current = if type(localeId) == 'string' and localeId ~= ''then string.lower(localeId)else'en'

    return locale.current
end
function locale.detect(): string
    local id = variables.localizationService.RobloxLocaleId

    if type(id) == 'string' and id ~= '' then
        return string.lower(id)
    end

    return 'en'
end

return locale

end)() end,
    [55] = function()local wax,script,require=ImportGlobals(55)local ImportGlobals return (function(...)local function lockable<T>(class: T): T
    local target = class::any

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
    [56] = function()local wax,script,require=ImportGlobals(56)local ImportGlobals return (function(...)local runtime = require(script.Parent.runtime)
local log = {}

type SuppressPredicate = () -> boolean

local function defaultSecureModeSource(): boolean
    return runtime.secureMode
end

local secureModeSource: SuppressPredicate = defaultSecureModeSource
local suppressPredicate: SuppressPredicate? = nil

function log.setSecureModeSource(source: SuppressPredicate?)
    secureModeSource = if type(source) == 'function'then source else defaultSecureModeSource
end
function log.setSuppressPredicate(predicate: SuppressPredicate?)
    suppressPredicate = if type(predicate) == 'function'then predicate else nil
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
    [57] = function()local wax,script,require=ImportGlobals(57)local ImportGlobals return (function(...)local function moveable<T>(class: T): T
    local target = class::any

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
    [58] = function()local wax,script,require=ImportGlobals(58)local ImportGlobals return (function(...)local network = {}

network.__index = network

export type RequestFn = (...any) -> any

function network.getRequestFn(env: any?): RequestFn?
    env = env or getfenv()

    return env.request or env.http_request or (env.http and env.http.request) or (env.syn and env.syn.request) or (env.fluxus and env.fluxus.request)
end

return network

end)() end,
    [59] = function()local wax,script,require=ImportGlobals(59)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local TextService = variables.textService
local odometer = {}

odometer.__index = odometer

local stripLength = 20

local function measure(font, size, text)
    local params = Instance.new('GetTextBoundsParams')

    params.Text = text
    params.Font = font
    params.Size = size
    params.Width = math.huge

    local ok, bounds = pcall(TextService.GetTextBoundsAsync, TextService, params)

    return if ok then bounds else Vector2.new(size * 0.6, size)
end

local metricsCache = {}

local function digitMetrics(font, size)
    local key = tostring(font.Family) .. '|' .. tostring(font.Weight) .. '|' .. tostring(font.Style) .. '|' .. tostring(size)
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

    cached = {
        advance = advance,
        maxWidth = maxWidth,
    }
    metricsCache[key] = cached

    return cached
end

function odometer.new(window, container, opts)
    opts = opts or {}

    local self = setmetatable({
        window = window,
        container = container,
        textSize = opts.textSize or 16,
        transparency = opts.transparency or 1,
        duration = opts.duration or 0.55,
        slots = {},
        length = 0,
    }, odometer)

    self.roll = TweenInfo.new(self.duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    self.zIndex = math.max(container.ZIndex + 1, 6)
    self.height = math.ceil(self.textSize)

    local metrics = digitMetrics(window.theme.Font, self.textSize)

    self.advance = metrics.advance
    self.maxWidth = metrics.maxWidth

    window:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = opts.alignment or Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        Parent = container,
    })

    return self
end
function odometer:_reel(index)
    local slot = self.slots[index]

    if slot.reel then
        return slot.reel
    end

    local cell = self.window:Create('Frame', {
        Name = 'Reel',
        Size = UDim2.fromOffset(self.maxWidth, self.height),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = self.zIndex,
        Parent = self.container,
    })
    local strip = self.window:Create('Frame', {
        Size = UDim2.fromOffset(self.maxWidth, self.height),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = self.zIndex,
        Parent = cell,
    })

    for i = 0, stripLength - 1 do
        self.window:Create('TextLabel', {
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
        }, {
            TextColor3 = 'ContentColor',
            FontFace = 'Font',
        })
    end

    local reel = {
        cell = cell,
        strip = strip,
        digit = 0,
        target = 0,
        stripTween = nil,
        sizeTween = nil,
    }

    slot.reel = reel

    return reel
end
function odometer:_static(index)
    local slot = self.slots[index]

    if slot.static then
        return slot.static
    end

    local label = self.window:Create('TextLabel', {
        Name = 'Static',
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
    }, {
        TextColor3 = 'ContentColor',
        FontFace = 'Font',
    })

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
        targetIndex = a + (digit - a) % 10
    else
        startIndex = a + 10
        targetIndex = startIndex - (a - digit) % 10
    end

    reel.strip.Position = UDim2.new(0.5, 0, 0, -startIndex * self.height)
    reel.target = digit

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
function odometer:_putStatic(index, char)
    local label = self:_static(index)

    if not label.Visible then
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
function odometer:_render(text, animate, up)
    text = tostring(text)

    if text == self._lastText then
        return
    end

    self._lastText = text

    local chars = {}

    for _, code in utf8.codes(text)do
        table.insert(chars, utf8.char(code))
    end

    local n = #chars

    for i = 0, math.max(n, self.length) - 1 do
        self.slots[i] = self.slots[i] or {}

        if i < n then
            local char = chars[n - i]

            if char:match('%d') then
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
function odometer:to(text, up)
    self:_render(text, true, up)
end
function odometer:snap(text)
    self:_render(text, false, true)
end
function odometer:reveal(target, animate, info)
    self.transparency = target

    for _, slot in self.slots do
        if slot.static and slot.static.Visible then
            self.window:_reveal(slot.static, {TextTransparency = target}, animate, info)
        end
        if slot.reel then
            for _, lbl in slot.reel.strip:GetChildren()do
                if lbl:IsA('TextLabel') then
                    self.window:_reveal(lbl, {TextTransparency = target}, animate, info)
                end
            end
        end
    end
end

return odometer

end)() end,
    [60] = function()local wax,script,require=ImportGlobals(60)local ImportGlobals return (function(...)type OrderedElement = {main: GuiObject, descriptor: {main: GuiObject}?}

local function assignOrder(element: OrderedElement, order: number)
    element.main.LayoutOrder = order

    if element.descriptor then
        element.descriptor.main.LayoutOrder = order + 1
    end
end

return assignOrder

end)() end,
    [61] = function()local wax,script,require=ImportGlobals(61)local ImportGlobals return (function(...)local path = {}

function path.join(basePath: string, childPath: string?): string
    if not childPath or childPath == '' then
        return basePath
    end

    return basePath .. '/' .. childPath
end

local function stripTraversal(text: string): string
    local previous

    repeat
        previous = text
        text = text:gsub('%.%.', '')
    until text == previous

    return text
end

function path.sanitizeFolder(value: unknown): string
    local text = tostring(value):gsub('\\', '/'):gsub('[:<>"|?*%c]', '')

    text = stripTraversal(text):gsub('/+', '/')

    return (text:gsub('^/+', ''))
end
function path.sanitizeFile(value: unknown): string
    local text = tostring(value):gsub('[/\\]', ''):gsub('[:<>"|?*%c]', '')

    return stripTraversal(text)
end
function path.basename(value: unknown): string
    return tostring(value):match('[^/\\]+$') or tostring(value)
end
function path.stripExtension(value: unknown, extension: string?): string
    if extension and extension ~= '' then
        local text = tostring(value)

        if text:sub(-#extension) == extension then
            return text:sub(1, -#extension - 1)
        end

        return text
    end

    local base = tostring(value):match('^(.+)%.%w+$')

    return base or tostring(value)
end

return path

end)() end,
    [62] = function()local wax,script,require=ImportGlobals(62)local ImportGlobals return (function(...)local persistence = {}
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
    [63] = function()local wax,script,require=ImportGlobals(63)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local filesystem = require(script.Parent.filesystem)
local log = require(script.Parent.log)
local path = require(script.Parent.path)
local paths = require(script.Parent.persistencePaths)
local atomic = require(script.Parent.persistenceWrite)
local persistenceConfig = {}

type PersistedControl = {value: unknown, flag: string?, _canBeNil: boolean?, _serialize: ((PersistedControl) -> unknown)?, _deserialize: ((PersistedControl, unknown) -> ())?, Set: (PersistedControl, unknown) -> ()}
type ConfigWindow = {controls: {[string]: PersistedControl}, configuration: {fileName: string?, customFolder: string?}, name: string, _loading: boolean?, _loadedConfig: {[string]: unknown}?, _loadedConfigPath: string?}

function persistenceConfig.getPath(window: ConfigWindow, name: unknown?): (string?,string?)
    return paths.getConfigPath(window, name)
end
function persistenceConfig.save(window: ConfigWindow, name: unknown?): boolean
    local dir, fullPath = persistenceConfig.getPath(window, name)

    if not dir or not fullPath then
        log.warn("Slate: configuration name '" .. tostring(name) .. "' has no usable characters")

        return false
    end
    if typeof(filesystem.writefile) ~= 'function' then
        return false
    end

    local flags: {[string]: unknown} = {}

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
            log.warn("Slate: Failed to serialize flag '" .. tostring(flag) .. "' - " .. tostring(value))
        end
    end

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
        log.warn('Slate: Failed to encode configuration - ' .. tostring(encoded))

        return false
    end

    local ok, err = pcall(function()
        atomic.write(dir, fullPath, encoded)
    end)

    if not ok then
        log.warn('Slate: Failed to save configuration - ' .. tostring(err))

        return false
    end
    if window._loadedConfigPath == nil or window._loadedConfigPath == fullPath then
        window._loadedConfig = flags
        window._loadedConfigPath = fullPath
    end

    return true
end

local function decodeFile(fullPath: string): ({[string]: unknown}?,string?)
    if not filesystem.isfile(fullPath) then
        return nil, nil
    end

    local readOk, contents = pcall(filesystem.readfile, fullPath)

    if not readOk or type(contents) ~= 'string' then
        log.warn('Slate: Failed to read configuration file')

        return nil, nil
    end

    local decodeOk, parsed = pcall(variables.httpService.JSONDecode, variables.httpService, contents)

    if not decodeOk or type(parsed) ~= 'table' then
        return nil, contents
    end

    return parsed::{[string]: unknown}, contents
end
local function backupPathFor(fullPath: string): string
    local stem = path.stripExtension(fullPath, '.rfld')
    local candidate = stem .. ' (Incorrect Format).rfld'
    local index = 2

    while index <= 100 and filesystem.isfile(candidate) do
        candidate = stem .. ' (Incorrect Format ' .. index .. ').rfld'

        index += 1
    end

    return candidate
end

function persistenceConfig.load(window: ConfigWindow, name: unknown?): boolean
    local dir, fullPath = persistenceConfig.getPath(window, name)

    if not dir or not fullPath then
        log.warn("Slate: configuration name '" .. tostring(name) .. "' has no usable characters")

        return false
    end
    if typeof(filesystem.isfile) ~= 'function' then
        return false
    end

    local parsedFlags, raw = decodeFile(fullPath)

    if not parsedFlags and filesystem.isfile(fullPath) then
        local parked, parkedRaw = decodeFile(atomic.tempPathFor(fullPath))

        if parked and parkedRaw then
            parsedFlags = parked

            pcall(atomic.write, dir, fullPath, parkedRaw)
        end
    end
    if not parsedFlags then
        if raw then
            log.warn(
[[Slate: Configuration file has an invalid format, backing up and resetting]])

            local backupPath = backupPathFor(fullPath)

            pcall(function()
                filesystem.ensureDir(dir)
                filesystem.writefile(backupPath, raw)
                filesystem.delfile(fullPath)
            end)
        end

        return false
    end

    local flags = parsedFlags::{[string]: unknown}
    local wasLoading = window._loading

    window._loading = true

    local applyOk, applyErr = pcall(function()
        for flag, control in window.controls do
            persistenceConfig.applyTo(control, flags[flag])
        end
    end)

    window._loading = wasLoading

    if not applyOk then
        log.warn('Slate: Failed to apply configuration - ' .. tostring(applyErr))
    end

    window._loadedConfig = flags
    window._loadedConfigPath = fullPath

    return true
end
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
        log.warn("Slate: Failed to restore flag '" .. tostring(control.flag) .. "' - " .. tostring(err))
    end
end
function persistenceConfig.list(window: ConfigWindow): {string}
    local dir = persistenceConfig.getPath(window)
    local names: {string} = {}

    if not dir then
        return names
    end

    local ok, files = pcall(filesystem.listfiles, dir)

    if not ok or type(files) ~= 'table' then
        return names
    end

    for _, filePath in files do
        local file = path.basename(filePath)

        if file:sub(-5) == '.rfld' then
            local base = path.stripExtension(file, '.rfld')

            if base and base ~= '' and not base:find(' %(Incorrect Format[^%)]*%)$') then
                table.insert(names, base)
            end
        end
    end

    table.sort(names)

    return names
end
function persistenceConfig.delete(window: ConfigWindow, name: unknown): boolean
    if type(name) ~= 'string' or name == '' then
        return false
    end

    local _, fullPath = persistenceConfig.getPath(window, name)

    if not fullPath then
        return false
    end
    if typeof(filesystem.isfile) ~= 'function' or not filesystem.isfile(fullPath) then
        return false
    end

    pcall(filesystem.delfile, atomic.tempPathFor(fullPath))

    return (pcall(filesystem.delfile, fullPath))
end

return persistenceConfig

end)() end,
    [64] = function()local wax,script,require=ImportGlobals(64)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local path = require(script.Parent.path)
local paths = {}

type ConfigWindow = {configuration: {fileName: string?, customFolder: string?}, name: string}

function paths.getConfigPath(window: ConfigWindow, name: unknown?): (string?,string?)
    local dir = variables.fileSystemManager:getPath('Configurations')

    if window.configuration.customFolder then
        dir = path.join(dir, path.sanitizeFolder(window.configuration.customFolder))
    end
    if name ~= nil then
        local safe = path.sanitizeFile(name)

        if safe == '' then
            return nil, nil
        end

        return dir, path.join(dir, safe .. '.rfld')
    end

    local safe = path.sanitizeFile(window.configuration.fileName or window.name)

    if safe == '' then
        safe = path.sanitizeFile(window.name)
    end
    if safe == '' then
        safe = 'Configuration'
    end

    return dir, path.join(dir, safe .. '.rfld')
end
function paths.getSettingsPath(): (string,string)
    local dir = variables.fileSystemManager:getPath('Settings')

    return dir, path.join(dir, 'rayfield.rfld')
end

return paths

end)() end,
    [65] = function()local wax,script,require=ImportGlobals(65)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local filesystem = require(script.Parent.filesystem)
local paths = require(script.Parent.persistencePaths)
local atomic = require(script.Parent.persistenceWrite)
local enums = require(script.Parent.enums)
local persistenceSettings = {}

type SettingsWindow = {settings: {toggleKeybind: EnumItem, mouseOverride: boolean, keepOnScreen: boolean, welcomeToast: boolean, haptics: boolean, showProfile: boolean}}
type DecodedSettings = {toggleKeybind: {[number]: unknown}?, mouseOverride: unknown?, keepOnScreen: unknown?, welcomeToast: unknown?, haptics: unknown?, showProfile: unknown?}

function persistenceSettings.getSettingsPath(): (string,string)
    return paths.getSettingsPath()
end
function persistenceSettings.saveSettings(window: SettingsWindow): boolean
    local dir, fullPath = persistenceSettings.getSettingsPath()
    local data: {[string]: unknown} = {
        toggleKeybind = {
            tostring(window.settings.toggleKeybind.EnumType),
            window.settings.toggleKeybind.Value,
        }::{unknown},
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

local function decodeFile(fullPath: string): (DecodedSettings?,string?)
    local fileExists = false

    pcall(function()
        fileExists = filesystem.isfile(fullPath)
    end)

    if not fileExists then
        return nil, nil
    end

    local readOk, contents = pcall(filesystem.readfile, fullPath)

    if not readOk or type(contents) ~= 'string' then
        return nil, nil
    end

    local decodeOk, parsed = pcall(variables.httpService.JSONDecode, variables.httpService, contents)

    if not decodeOk or type(parsed) ~= 'table' then
        return nil, contents
    end

    return parsed::DecodedSettings, contents
end

function persistenceSettings.loadSettings(window: SettingsWindow): boolean
    local dir, fullPath = persistenceSettings.getSettingsPath()
    local settings = decodeFile(fullPath)

    if not settings then
        local parked, parkedRaw = decodeFile(atomic.tempPathFor(fullPath))

        if parked and parkedRaw then
            settings = parked

            pcall(atomic.write, dir, fullPath, parkedRaw)
        end
    end
    if not settings then
        return false
    end
    if settings.toggleKeybind then
        pcall(function()
            local enumName = tostring(settings.toggleKeybind[1]):gsub('^Enum%.', '')
            local enumType = (Enum::any)[enumName]

            if enumType then
                local enumItem = enums.itemFromValue(enumType, settings.toggleKeybind[2])

                if enumItem then
                    window.settings.toggleKeybind = enumItem
                end
            end
        end)
    end
    if type(settings.mouseOverride) == 'boolean' then
        window.settings.mouseOverride = settings.mouseOverride
    end
    if type(settings.keepOnScreen) == 'boolean' then
        window.settings.keepOnScreen = settings.keepOnScreen
    end
    if type(settings.welcomeToast) == 'boolean' then
        window.settings.welcomeToast = settings.welcomeToast
    end
    if type(settings.haptics) == 'boolean' then
        window.settings.haptics = settings.haptics
    end
    if type(settings.showProfile) == 'boolean' then
        window.settings.showProfile = settings.showProfile
    end

    return true
end

return persistenceSettings

end)() end,
    [66] = function()local wax,script,require=ImportGlobals(66)local ImportGlobals return (function(...)local filesystem = require(script.Parent.filesystem)
local persistenceWrite = {}
local parkedExtension = '.saving'

function persistenceWrite.tempPathFor(fullPath: string): string
    return fullPath .. parkedExtension
end
function persistenceWrite.write(
    dir: string,
    fullPath: string,
    contents: string
)
    local tempPath = persistenceWrite.tempPathFor(fullPath)

    filesystem.ensureDir(dir)
    filesystem.writefile(tempPath, contents)

    if filesystem.readfile(tempPath) ~= contents then
        error('parked copy did not write cleanly')
    end

    filesystem.writefile(fullPath, contents)
    pcall(filesystem.delfile, tempPath)
end

return persistenceWrite

end)() end,
    [67] = function()local wax,script,require=ImportGlobals(67)local ImportGlobals return (function(...)local services = require(script.Parent.services)

export type RuntimeState = {secureMode: boolean, coreGui: CoreGui, workspace: Workspace, runService: RunService, userInputService: UserInputService, guiService: GuiService, localPlayer: Player?, tweenService: TweenService, httpService: HttpService, textService: TextService, replicatedStorage: ReplicatedStorage, localizationService: LocalizationService, guiContainer: Instance}

local runtime = {}::RuntimeState

runtime.secureMode = (function()
    if typeof(getgenv) ~= 'function' then
        return false
    end

    local ok, val = pcall(function()
        return getgenv().RAYFIELD_SECURE
    end)

    return ok and val == true
end)()
runtime.coreGui = services.getService('CoreGui')::CoreGui
runtime.workspace = services.getService('Workspace')::Workspace
runtime.runService = services.getService('RunService')::RunService
runtime.userInputService = services.getService('UserInputService')::UserInputService
runtime.guiService = services.getService('GuiService')::GuiService
runtime.localPlayer = (services.getService('Players')::Players).LocalPlayer
runtime.tweenService = services.getService('TweenService')::TweenService
runtime.httpService = services.getService('HttpService')::HttpService
runtime.textService = services.getService('TextService')::TextService
runtime.replicatedStorage = services.getService('ReplicatedStorage')::ReplicatedStorage
runtime.localizationService = services.getService('LocalizationService')::LocalizationService
runtime.guiContainer = (function(): Instance
    if runtime.runService:IsStudio() then
        local player = runtime.localPlayer

        if player then
            return player.PlayerGui
        end

        return runtime.coreGui
    end
    if typeof(gethui) == 'function' then
        local ok, container = pcall(gethui)

        if ok and container then
            return container
        end
    end

    return runtime.coreGui
end)()

return runtime

end)() end,
    [68] = function()local wax,script,require=ImportGlobals(68)local ImportGlobals return (function(...)local services = {}

function services.getService(name)
    local service = game:GetService(name)

    return if cloneref then cloneref(service)else service
end

return services

end)() end,
    [69] = function()local wax,script,require=ImportGlobals(69)local ImportGlobals return (function(...)local variables = require(script.Parent.variables)
local textService = variables.textService
local textMetrics = {}
local widthCache: {[string]: number} = {}
local widthCacheCount = 0
local widthCacheCap = 1024

local function getTextBounds(params: GetTextBoundsParams): unknown
    local ok, bounds = pcall(function()
        return textService:GetTextBoundsAsync(params)
    end)

    return if ok then bounds else nil
end
local function boundAxis(bounds: unknown, axis: 'X' | 'Y'): number?
    if typeof(bounds) == 'Vector2' then
        return if axis == 'X'then bounds.X else bounds.Y
    end
    if type(bounds) == 'table' and type((bounds::any)[axis]) == 'number' then
        return (bounds::any)[axis]
    end

    return nil
end

function textMetrics.textWidth(font: Font, size: number, text: any): number
    text = tostring(text)

    local key = tostring(font.Family) .. '|' .. tostring(font.Weight) .. '|' .. tostring(font.Style) .. '|' .. tostring(size) .. '|' .. text
    local cached = widthCache[key]

    if cached then
        return cached
    end

    local params = Instance.new('GetTextBoundsParams')

    params.Text = text
    params.Font = font
    params.Size = size
    params.Width = math.huge

    local measuredWidth = boundAxis(getTextBounds(params), 'X')

    if not measuredWidth then
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
function textMetrics.textHeight(
    font: Font,
    size: number,
    text: any,
    width: number
): number
    local params = Instance.new('GetTextBoundsParams')

    params.Text = tostring(text)
    params.Font = font
    params.Size = size
    params.Width = width

    local measuredHeight = boundAxis(getTextBounds(params), 'Y')

    return if measuredHeight then math.ceil(measuredHeight)else size
end

return textMetrics

end)() end,
    [70] = function()local wax,script,require=ImportGlobals(70)local ImportGlobals return (function(...)local runtime = require(script.Parent.runtime)
local constants = require(script.Parent.constants)
local log = require(script.Parent.log)
local fileSystemManager = require(script.Parent.filesystemManager)
local assetResolver = require(script.Parent.assetResolver)
local fontManager = require(script.Parent.fontManager)

type RuntimeState = runtime.RuntimeState
type FileSystemManager = fileSystemManager.FileSystemManager
type AssetResolver = assetResolver.AssetResolver
type FontManager = fontManager.FontManager
export type VariablesState = RuntimeState&{fallbackFont: Font, fileSystemManager: FileSystemManager, assetResolver: AssetResolver, fontManager: FontManager, setFallbackFont: (font:Enum.Font | Font) -> (), brandFont: (weight:Enum.FontWeight?) -> Font}

local variables = table.clone(runtime)::VariablesState

log.setSecureModeSource(function()
    return variables.secureMode
end)

variables.fallbackFont = Font.fromEnum(Enum.Font.BuilderSans)
variables.fileSystemManager = fileSystemManager.new()
variables.assetResolver = assetResolver.new(true, assetResolver.Enum.AssetDownloadUrl.RoProxyDownloadUrl)::AssetResolver
variables.fontManager = fontManager.new(variables.fileSystemManager:getAssetsFolder('fonts'), false, true, assetResolver.Enum.AssetDownloadUrl.RoProxyDownloadUrl, {
    saveToDisk = true,
    skipCache = false,
    fallbackFont = variables.fallbackFont,
})::FontManager

function variables.setFallbackFont(font: Enum.Font | Font)
    if typeof(font) == 'EnumItem' then
        font = Font.fromEnum(font)
    end
    if typeof(font) == 'Font' then
        variables.fallbackFont = font
        variables.fontManager.defaultOptions.fallbackFont = font
    end
end
function variables.brandFont(weight: Enum.FontWeight?): Font
    if variables.secureMode then
        return Font.new(variables.fallbackFont.Family, weight)
    end

    return Font.new(constants.fontAsset, weight)
end

return variables

end)() end,
    [71] = function()local wax,script,require=ImportGlobals(71)local ImportGlobals return (function(...)local layouts = require(script.Parent.layouts)
local windowSizing = {}

export type Profile = {defaultSize: Vector2, minSize: Vector2, maxOccupancyX: number, maxOccupancyY: number?, marginFloorX: number, marginFloorY: number, topbarClearance: number?, maxAspectRatio: number, minAspectRatio: number?, widthCompensation: number?, chromeHeight: number}

local minPlausibleViewport = 200
local profiles = {
    top = {
        defaultSize = Vector2.new(740, 480),
        minSize = Vector2.new(580, 380),
        maxOccupancyX = 0.95,
        maxOccupancyY = 0.88,
        topbarClearance = 36,
        marginFloorX = 20,
        marginFloorY = 24,
        maxAspectRatio = 2.6,
        minAspectRatio = 1.2,
        chromeHeight = layouts.top.chromeHeight,
    }::Profile,
    sidebar = {
        defaultSize = Vector2.new(740, 480),
        minSize = Vector2.new(620, 380),
        maxOccupancyX = 0.95,
        maxOccupancyY = 0.88,
        marginFloorX = 20,
        marginFloorY = 24,
        maxAspectRatio = 2.6,
        minAspectRatio = 1.2,
        chromeHeight = layouts.sidebar.chromeHeight,
    }::Profile,
}

function windowSizing.profile(mode: layouts.Mode?): Profile
    if mode == 'sidebar' then
        return profiles.sidebar
    end

    return profiles.top
end
function windowSizing.pageHeight(windowHeight: number?, mode: layouts.Mode?): number
    local profile = windowSizing.profile(mode)
    local height = if windowHeight and windowHeight > 0 then windowHeight else profile.minSize.Y

    return math.max(height - profile.chromeHeight, 0)
end

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
local function deficit(actual: number, ideal: number, floor: number): number
    return math.clamp((ideal - actual) / (ideal - floor), 0, 1)
end
local function fitVertical(
    profile: Profile,
    availableX: number,
    availableY: number
): UDim2
    local height = math.floor(math.min(math.clamp(availableY, profile.minSize.Y, profile.defaultSize.Y), availableY))
    local lost = deficit(height, profile.defaultSize.Y, profile.minSize.Y)
    local width = math.max(profile.defaultSize.X + (profile.widthCompensation::number) * lost, profile.minSize.X)

    return UDim2.fromOffset(math.floor(math.min(width, availableX, height * profile.maxAspectRatio)), height)
end
local function fitHorizontal(
    profile: Profile,
    availableX: number,
    availableY: number
): UDim2
    local width = math.min(math.clamp(availableX, profile.minSize.X, profile.defaultSize.X), availableX)
    local height = math.min(math.clamp(availableY, profile.minSize.Y, profile.defaultSize.Y), availableY)

    height = math.floor(math.min(height, width / (profile.minAspectRatio::number)))
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
                31,
                1,
                {
                    "themes"
                },
                {
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
                    },
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
                        62,
                        2,
                        {
                            "persistence"
                        }
                    },
                    {
                        58,
                        2,
                        {
                            "network"
                        }
                    },
                    {
                        51,
                        2,
                        {
                            "image"
                        }
                    },
                    {
                        70,
                        2,
                        {
                            "variables"
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
                        57,
                        2,
                        {
                            "moveable"
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
                        59,
                        2,
                        {
                            "odometer"
                        }
                    },
                    {
                        56,
                        2,
                        {
                            "log"
                        }
                    },
                    {
                        65,
                        2,
                        {
                            "persistenceSettings"
                        }
                    },
                    {
                        66,
                        2,
                        {
                            "persistenceWrite"
                        }
                    },
                    {
                        48,
                        2,
                        {
                            "fluentIcons"
                        }
                    },
                    {
                        67,
                        2,
                        {
                            "runtime"
                        }
                    },
                    {
                        52,
                        2,
                        {
                            "imageCache"
                        }
                    },
                    {
                        49,
                        2,
                        {
                            "fontManager"
                        }
                    },
                    {
                        61,
                        2,
                        {
                            "path"
                        }
                    },
                    {
                        64,
                        2,
                        {
                            "persistencePaths"
                        }
                    },
                    {
                        63,
                        2,
                        {
                            "persistenceConfig"
                        }
                    },
                    {
                        71,
                        2,
                        {
                            "windowSizing"
                        }
                    },
                    {
                        40,
                        2,
                        {
                            "HapticEngine"
                        }
                    },
                    {
                        53,
                        2,
                        {
                            "layouts"
                        }
                    },
                    {
                        55,
                        2,
                        {
                            "lockable"
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
                        41,
                        2,
                        {
                            "assetResolver"
                        }
                    },
                    {
                        50,
                        2,
                        {
                            "functions"
                        }
                    },
                    {
                        69,
                        2,
                        {
                            "textMetrics"
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
                        60,
                        2,
                        {
                            "ordering"
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
                        54,
                        2,
                        {
                            "locale"
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
                        68,
                        2,
                        {
                            "services"
                        }
                    }
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
                        22,
                        2,
                        {
                            "stat"
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
                        4,
                        2,
                        {
                            "button"
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
                        30,
                        2,
                        {
                            "window"
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
                        6,
                        2,
                        {
                            "colorpicker"
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
                        11,
                        2,
                        {
                            "dropdown"
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
                        14,
                        2,
                        {
                            "keybind"
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
                        9,
                        2,
                        {
                            "divider"
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
                        21,
                        2,
                        {
                            "slider"
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
                        25,
                        2,
                        {
                            "tabSelector"
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
                        23,
                        2,
                        {
                            "tab"
                        }
                    },
                    {
                        26,
                        2,
                        {
                            "tag"
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
                        8,
                        2,
                        {
                            "descriptor"
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
                        12,
                        2,
                        {
                            "group"
                        }
                    },
                    {
                        15,
                        2,
                        {
                            "notification"
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
    [3] = 258,
    [4] = 351,
    [5] = 568,
    [6] = 796,
    [7] = 1984,
    [8] = 2345,
    [9] = 2403,
    [10] = 2547,
    [11] = 2737,
    [12] = 3974,
    [13] = 4177,
    [14] = 4452,
    [15] = 4927,
    [16] = 5250,
    [17] = 5956,
    [18] = 6429,
    [19] = 6783,
    [20] = 6876,
    [21] = 7133,
    [22] = 7719,
    [23] = 8383,
    [24] = 8689,
    [25] = 8827,
    [26] = 9163,
    [27] = 9322,
    [28] = 9473,
    [29] = 9874,
    [30] = 10303,
    [32] = 12905,
    [33] = 12940,
    [34] = 12975,
    [35] = 13040,
    [36] = 13075,
    [37] = 13127,
    [38] = 13162,
    [40] = 13214,
    [41] = 13323,
    [42] = 13506,
    [43] = 13525,
    [44] = 13582,
    [45] = 13613,
    [46] = 13878,
    [47] = 13920,
    [48] = 13954,
    [49] = 17900,
    [50] = 18361,
    [51] = 18376,
    [52] = 18475,
    [53] = 18735,
    [54] = 18826,
    [55] = 18927,
    [56] = 18946,
    [57] = 18991,
    [58] = 19024,
    [59] = 19039,
    [60] = 19381,
    [61] = 19394,
    [62] = 19449,
    [63] = 19466,
    [64] = 19715,
    [65] = 19757,
    [66] = 19876,
    [67] = 19904,
    [68] = 19956,
    [69] = 19967,
    [70] = 20051,
    [71] = 20099
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "WaxRuntime"

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