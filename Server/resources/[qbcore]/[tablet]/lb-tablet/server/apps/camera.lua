local cachedBaseUrl = nil

RegisterCallback("camera:getBaseUrl", function()
    if not cachedBaseUrl then
        cachedBaseUrl = GetConvar("web_baseUrl", "")
    end

    return cachedBaseUrl
end)

local mediaMimeTypes = {
    Audio = "audio",
    Image = "image",
    Video = "video"
}

RegisterCallback("camera:getPresignedUrl", function(source, mediaType)
    local mimeType = mediaMimeTypes[mediaType]
    if not mimeType then
        return
    end

    local uploadMethod = Config.UploadMethod[mediaType]

    if uploadMethod ~= "Fivemanage" then
        if GetPresignedUrl then
            return GetPresignedUrl(source, mediaType)
        end

        infoprint(
            "warning",
            "GetPresignedUrl has not been set up. Set it up in lb-tablet/server/custom/functions/functions.lua, or change your upload method to Fivemanage."
        )

        return
    end

    local requestPromise = promise.new()

    PerformHttpRequest(
        "https://fmapi.net/api/v2/presigned-url?fileType=" .. mimeType,
        function(statusCode, responseBody, responseHeaders, err)
            if statusCode ~= 200 then
                infoprint("error", "Failed to get presigned URL from Fivemanage for " .. mimeType)
                print("Status:", statusCode)
                print("Body:", responseBody)
                print("Headers:", json.encode(responseHeaders or {}, { indent = true }))

                if err then
                    print("Error:", err)
                end

                requestPromise:resolve()
                return
            end

            local decoded = json.decode(responseBody)
            requestPromise:resolve(decoded and decoded.data and decoded.data.presignedUrl)
        end,
        "GET",
        "",
        {
            Authorization = API_KEYS[mediaType]
        }
    )

    return Citizen.Await(requestPromise)
end)

RegisterCallback("camera:getUploadApiKey", function(_, mediaType)
    if not mediaType or not API_KEYS[mediaType] then
        return
    end

    return API_KEYS[mediaType]
end)

RegisterNetEvent("tablet:setListeningPeerId", function(peerId)
    if not Config.Voice.RecordNearby then
        return
    end

    local sourcePlayer = source
    local playerState = Player(sourcePlayer).state
    local previousPeerId = playerState.lbTabletListeningPeerId

    if previousPeerId then
        TriggerClientEvent("tablet:stoppedListening", -1, previousPeerId)
    end

    playerState.lbTabletListeningPeerId = peerId
    debugprint(sourcePlayer, "set lbTabletListeningPeerId to", peerId)

    if peerId then
        TriggerClientEvent("tablet:startedListening", -1, sourcePlayer, peerId)
    end
end)

local validPhotoMetadata = {
    selfie = true,
    import = true,
    screenshot = true
}

BaseCallback("camera:saveToGallery", function(source, tabletId, link, size, isVideo, metadata, shouldLog)
    if metadata and not validPhotoMetadata[metadata] then
        debugprint("Invalid metadata", metadata)
        metadata = nil
    end

    if not IsMediaLinkAllowed(link) then
        infoprint(
            "error",
            ("%s %s tried to save an image with a link that is not allowed:"):format(source, tabletId),
            link
        )
        return false
    end

    if shouldLog then
        Log(
            source,
            "TakePhoto",
            "info",
            L("BACKEND.LOGS.TOOK_" .. (isVideo and "VIDEO" or "PHOTO")),
            {
                link = link,
                size = size,
                metadata = metadata
            },
            link
        )
    end

    return MySQL.insert.await(
        "INSERT INTO lbtablet_photos (tablet_id, link, is_video, size, metadata) VALUES (?, ?, ?, ?, ?)",
        {
            tabletId,
            link,
            isVideo == true,
            size or 0,
            metadata
        }
    )
end)

BaseCallback("camera:deleteFromGallery", function(_, tabletId, photoIds)
    MySQL.update.await(
        "DELETE FROM lbtablet_photos WHERE tablet_id = ? AND id IN (?)",
        { tabletId, photoIds }
    )

    return true
end)

BaseCallback("camera:toggleFavourites", function(_, tabletId, shouldFavourite, photoIds)
    MySQL.update.await(
        "UPDATE lbtablet_photos SET is_favourite = ? WHERE tablet_id = ? AND id IN (?)",
        {
            shouldFavourite == true,
            tabletId,
            photoIds
        }
    )

    return true
end)

BaseCallback("camera:getLastPhoto", function(_, tabletId)
    return MySQL.scalar.await(
        "SELECT link FROM lbtablet_photos WHERE tablet_id = ? ORDER BY id DESC LIMIT 1",
        { tabletId }
    )
end)

local mediaTypeKeys = {
    "videos",
    "photos",
    "favouritesVideos",
    "favouritesPhotos",
    "selfiesVideos",
    "selfiesPhotos",
    "screenshotsVideos",
    "screenshotsPhotos",
    "importsVideos",
    "importsPhotos",
    "duplicatesPhotos",
    "duplicatesVideos"
}

BaseCallback("camera:getHomePageData", function(_, tabletId)
    local mediaCounts = MySQL.single.await([[
        SELECT
            SUM(is_video = 1) AS videos,
            SUM(is_video = 0) AS photos,
            SUM(is_video = 1 AND is_favourite = 1) AS favouritesVideos,
            SUM(is_video = 0 AND is_favourite = 1) AS favouritesPhotos,
            SUM(metadata = 'selfie' AND is_video = 1) AS selfiesVideos,
            SUM(metadata = 'selfie' AND is_video = 0) AS selfiesPhotos,
            SUM(metadata = 'screenshot' AND is_video = 1) AS screenshotsVideos,
            SUM(metadata = 'screenshot' AND is_video = 0) AS screenshotsPhotos,
            SUM(metadata = 'import' AND is_video = 1) AS importsVideos,
            SUM(metadata = 'import' AND is_video = 0) AS importsPhotos
        FROM lbtablet_photos
        WHERE tablet_id = ?
    ]], { tabletId })

    local uniquePhotoCount = MySQL.scalar.await([[
        SELECT COUNT(DISTINCT link)
        FROM lbtablet_photos
        WHERE tablet_id = ? AND is_video = 0
    ]], { tabletId })

    mediaCounts.duplicatesPhotos = mediaCounts.photos - uniquePhotoCount

    local uniqueVideoCount = MySQL.scalar.await([[
        SELECT COUNT(DISTINCT link)
        FROM lbtablet_photos
        WHERE tablet_id = ? AND is_video = 1
    ]], { tabletId })

    mediaCounts.duplicatesVideos = mediaCounts.videos - uniqueVideoCount

    for i = 1, #mediaTypeKeys do
        local key = mediaTypeKeys[i]
        mediaCounts[key] = tonumber(mediaCounts[key] or 0)
    end

    if mediaCounts.duplicatesPhotos > 0 then
        mediaCounts.duplicatesPhotos = mediaCounts.duplicatesPhotos + 1
    end

    if mediaCounts.duplicatesVideos > 0 then
        mediaCounts.duplicatesVideos = mediaCounts.duplicatesVideos + 1
    end

    local albums = {}

    local recentAlbum = {
        id = "recents",
        title = L("APPS.PHOTOS.RECENTS"),
        videoCount = mediaCounts.videos,
        photoCount = mediaCounts.photos,
        cover = MySQL.scalar.await(
            "SELECT link FROM lbtablet_photos WHERE tablet_id = ? ORDER BY id DESC LIMIT 1",
            { tabletId }
        ),
        removable = false
    }

    local favouritesAlbum = {
        id = "favourites",
        title = L("APPS.PHOTOS.FAVOURITES"),
        videoCount = mediaCounts.favouritesVideos,
        photoCount = mediaCounts.favouritesPhotos,
        cover = MySQL.scalar.await(
            "SELECT link FROM lbtablet_photos WHERE tablet_id = ? AND is_favourite = 1 ORDER BY id DESC LIMIT 1",
            { tabletId }
        ),
        removable = false
    }

    albums[1] = recentAlbum
    albums[2] = favouritesAlbum

    local customAlbums = MySQL.query.await([[
        SELECT
            pa.id,
            pa.title,
            (SELECT lp.link FROM lbtablet_photos lp WHERE lp.id = MAX(ap.photo_id)) AS cover,
            SUM(CASE WHEN pp.is_video = 1 THEN 1 ELSE 0 END) AS videoCount,
            SUM(CASE WHEN pp.is_video = 0 THEN 1 ELSE 0 END) AS photoCount
        FROM
            lbtablet_photo_albums pa
        LEFT JOIN
            lbtablet_photo_album_photos ap ON ap.album_id = pa.id
        LEFT JOIN
            lbtablet_photos pp ON pp.id = ap.photo_id
        WHERE
            pa.tablet_id = ?
        GROUP BY
            pa.id
        ORDER BY
            pa.id ASC
    ]], { tabletId })

    for i = 1, #customAlbums do
        local album = customAlbums[i]
        album.removable = true
        albums[#albums + 1] = album
    end

    for i = 1, #albums do
        local album = albums[i]
        album.count = album.photoCount + album.videoCount
    end

    return {
        albums = albums,
        mediaTypes = mediaCounts
    }
end, {
    albums = {},
    mediaTypes = {}
})

BaseCallback("camera:getPhotos", function(_, tabletId, filters, page, lastId)
    if not filters.showVideos and not filters.showPhotos then
        debugprint("not showing either videos nor photos, returning")
        return {}
    end

    local params = { tabletId }
    local query = "SELECT id, link, is_video, size, metadata, is_favourite, created_at FROM lbtablet_photos WHERE tablet_id = ?"

    if filters.showPhotos ~= filters.showVideos then
        query = query .. " AND is_video = ?"
        params[#params + 1] = filters.showVideos == true
    end

    if filters.favourites then
        query = query .. " AND is_favourite = 1"
    end

    if filters.type then
        query = query .. " AND metadata = ?"
        params[#params + 1] = filters.type
    elseif filters.album then
        query = query .. " AND id IN (select ap.photo_id FROM lbtablet_photo_album_photos ap WHERE ap.album_id = ?)"
        params[#params + 1] = filters.album
    end

    if filters.duplicates then
        query = query .. [[
            AND link IN (
                SELECT link
                FROM lbtablet_photos
                WHERE tablet_id = ?
                GROUP BY link
                HAVING COUNT(1) > 1
            )
        ]]
        params[#params + 1] = tabletId
    end

    local perPage = clamp(filters.perPage or 30, 1, 32)

    if lastId then
        query = query .. " AND id < ? ORDER BY id DESC limit ?"
        params[#params + 1] = lastId
    else
        query = query .. " ORDER BY id DESC limit ?, ?"
        params[#params + 1] = (page or 0) * perPage
    end

    params[#params + 1] = perPage

    return MySQL.query.await(query, params)
end)

BaseCallback("camera:createAlbum", function(_, tabletId, title)
    return MySQL.insert.await(
        "INSERT INTO lbtablet_photo_albums (tablet_id, title) VALUES (?, ?)",
        { tabletId, title }
    )
end)

BaseCallback("camera:renameAlbum", function(_, tabletId, albumId, newTitle)
    return MySQL.update.await(
        "UPDATE lbtablet_photo_albums SET title = ? WHERE tablet_id = ? AND id = ?",
        { newTitle, tabletId, albumId }
    ) > 0
end)

BaseCallback("camera:deleteAlbum", function(_, tabletId, albumId)
    return MySQL.update.await(
        "DELETE FROM lbtablet_photo_albums WHERE tablet_id = ? AND id = ?",
        { tabletId, albumId }
    ) > 0
end)

BaseCallback("camera:addToAlbum", function(_, tabletId, albumId, photoIds)
    local albumExists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_photo_albums WHERE tablet_id = ? AND id = ?",
        { tabletId, albumId }
    )

    if not albumExists then
        return false
    end

    MySQL.update.await(
        "INSERT IGNORE INTO lbtablet_photo_album_photos (album_id, photo_id) SELECT ?, id FROM lbtablet_photos WHERE tablet_id = ? AND id IN (?)",
        { albumId, tabletId, photoIds }
    )

    return true
end)

BaseCallback("camera:removeFromAlbum", function(_, tabletId, albumId, photoIds)
    local albumExists = MySQL.scalar.await(
        "SELECT 1 FROM lbtablet_photo_albums WHERE tablet_id = ? AND id = ?",
        { tabletId, albumId }
    )

    if not albumExists then
        return false
    end

    MySQL.update.await(
        "DELETE FROM lbtablet_photo_album_photos WHERE album_id = ? AND photo_id IN (?)",
        { albumId, photoIds }
    )

    return true
end)

BaseCallback("camera:getPhoneAlbum", function(source)
    if not Config.LBPhone then
        return false
    end

    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return false
    end

    local albumData = MySQL.single.await([[
        SELECT
            SUM(is_video = 1) AS videoCount,
            SUM(is_video = 0) AS photoCount,
            (SELECT link FROM phone_photos WHERE phone_number = ? ORDER BY id DESC LIMIT 1) AS cover
        FROM
            phone_photos
        WHERE
            phone_number = ?
    ]], { phoneNumber, phoneNumber })

    albumData.photoCount = tonumber(albumData.photoCount or 0) or 0
    albumData.videoCount = tonumber(albumData.videoCount or 0) or 0
    albumData.count = albumData.photoCount + albumData.videoCount

    return albumData
end, false)

BaseCallback("camera:importFromPhone", function(source, tabletId, photoIds)
    if not Config.LBPhone then
        return false
    end

    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return false
    end

    MySQL.update.await(
        "INSERT IGNORE INTO lbtablet_photos (tablet_id, link, is_video, size, metadata) SELECT ?, link, is_video, size, metadata FROM phone_photos WHERE phone_number = ? AND id IN (?)",
        { tabletId, phoneNumber, photoIds }
    )

    return true
end)