local constants = {}

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
    banner = 106790631609801,
    config = 125823673784681,
    rayfield = 106790631609801,
    slate = 106790631609801,
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
