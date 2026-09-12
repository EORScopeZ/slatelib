local variables = require(script.utility.variables)
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
