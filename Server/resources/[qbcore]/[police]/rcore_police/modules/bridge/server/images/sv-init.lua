-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local imageServiceConfigs = {
    [Images.FIVEMERR] = {
        url = "https://api.fivemerr.com/v1/media/images",
        authType = "header",
        authKey = "Authorization"
    },
    [Images.FIVEMANAGE] = {
        url = "https://api.fivemanage.com/api/image",
        authType = "header",
        authKey = "Authorization"
    },
}
local function getServiceConfig(service)
    local config = imageServiceConfigs[service]
    if not config then
        if service == Images.CUSTOM then
            return {
                url = ServerConfig.Image.CustomConfig.url,
                authType = ServerConfig.Image.CustomConfig.authType or "header",
                authKey = ServerConfig.Image.CustomConfig.authType == "query" and "key" or "Authorization"
            }
        else
            dbg.critical("Unknown image service: %s", service)
            return nil
        end
    end
    return config
end
local function buildUploadOptions(serviceConfig)
    local options = {
        encoding = ServerConfig.Image.Settings.encoding or "webp",
        maxWidth = ServerConfig.Image.Settings.maxWidth or 1920,
        maxHeight = ServerConfig.Image.Settings.maxHeight or 1080,
        quality = ServerConfig.Image.Settings.quality or 0.6,
        headers = {
            [serviceConfig.authKey] = ServerConfig.Image.ApiKey
        }
    }
    return options
end
ImageService.Upload = function(playerId, callback, metadata, responseType)
    if not isResourcePresentProvideless("screencapture") then
        return dbg.critical("ImageService: Cannot upload since, you are not running screencapture resource!")
    end
    if not ServerConfig.Image.ApiKey or ServerConfig.Image.ApiKey == "" then
        return dbg.critical("ImageService: Undefined Api key for in ServerConfig.Image.ApiKey!")
    end
    if not playerId then
        dbg.critical("ImageService.Upload: playerId is required")
        if callback then callback(nil, "Player ID is required") end
        return
    end
    if not ServerConfig or not ServerConfig.Image then
        dbg.critical("ImageService.Upload: ServerConfig.Image is not configured")
        if callback then callback(nil, "Image service not configured") end
        return
    end
    local service = ServerConfig.Image.Service
    if not service or service == "" then
        dbg.critical("ImageService.Upload: No image service specified in ServerConfig.Image.Service")
        if callback then callback(nil, "No image service configured") end
        return
    end
    local serviceConfig = getServiceConfig(service)
    if not serviceConfig then
        dbg.critical("ImageService.Upload: Failed to get service config for %s", service)
        if callback then callback(nil, "Invalid service configuration") end
        return
    end
    local uploadUrl = serviceConfig.url
    if not uploadUrl or uploadUrl == "" then
        dbg.critical("ImageService.Upload: Upload URL is empty for service %s", service)
        if callback then callback(nil, "Upload URL not configured") end
        return
    end
    local options = buildUploadOptions(serviceConfig)
    local responseTypeToUse = responseType or "blob"
    dbg.debug("ImageService.Upload: Uploading image via %s service to %s", service, uploadUrl)
    local success, errorMsg = pcall(function()
        exports.screencapture:remoteUpload(playerId, uploadUrl, options, function(data)
            if data and (data.url or data.link) then
                local imageUrl = data.url or data.link
                dbg.debug("ImageService.Upload: Successfully uploaded image: %s", imageUrl)
                if callback then
                    callback({ url = imageUrl, data = data }, nil, metadata)
                end
            else
                dbg.critical("ImageService.Upload: Failed to upload image via %s - No URL in response", service)
                if callback then
                    callback(nil, "Upload failed - No URL returned", metadata)
                end
            end
        end, responseTypeToUse)
    end)
    if not success then
        dbg.critical("ImageService.Upload: Error calling screencapture export: %s", errorMsg)
        if callback then callback(nil, "Screencapture export error: " .. tostring(errorMsg)) end
    end
end
