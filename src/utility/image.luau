local fluentIcons = require(script.Parent.fluentIcons)
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

        local fluentId = fluentIcons.get(value)

        if fluentId then
            return `rbxthumb://type=Asset&id={fluentId}&w=420&h=420`
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
