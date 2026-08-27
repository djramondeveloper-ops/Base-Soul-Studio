if not Config.LiveEdit or not Config.LiveEdit.Enabled then
    return
end

local documents = {}
local clients = {}

local function BroadcastToDocument(documentId, eventName, excludedSource, ...)
    local document = documents[documentId]
    if not document or not document.sources then
        return
    end

    for i = 1, #document.sources do
        local targetSource = document.sources[i]

        if targetSource ~= excludedSource then
            TriggerLatentClientEvent(eventName, targetSource, -1, documentId, ...)
        end
    end
end

local function SendExistingAwarenessToClient(source)
    local clientState = clients[source]
    local documentId = clientState and clientState.document

    if not clientState or not documentId or not documents[documentId] then
        return
    end

    local sources = documents[documentId].sources or {}

    for i = 1, #sources do
        local otherSource = sources[i]
        local otherClientState = clients[otherSource]

        if otherSource ~= source and otherClientState and otherClientState.document == documentId and otherClientState.awareness then
            TriggerClientEvent(
                "liveEdit:awarenessUpdate",
                source,
                documentId,
                otherClientState.clientId,
                otherClientState.awareness
            )
        end
    end
end

local function RemoveClientFromDocument(source)
    local clientState = clients[source]
    local documentId = clientState and clientState.document

    if not clientState or not documentId then
        return
    end

    local document = documents[documentId]
    if not document then
        return
    end

    BroadcastToDocument(documentId, "liveEdit:awarenessUpdate", source, clientState.clientId)

    for i = 1, #document.sources do
        if document.sources[i] == source then
            table.remove(document.sources, i)
            break
        end
    end

    clients[source] = nil

    if #document.sources == 0 then
        documents[documentId] = nil
    end
end

BaseCallback("liveEdit:getDocument", function(source, _, documentId, clientId)
    RemoveClientFromDocument(source)

    local document = documents[documentId]

    if document then
        local alreadyPresent = false

        for i = 1, #document.sources do
            if document.sources[i] == source then
                alreadyPresent = true
                break
            end
        end

        if not alreadyPresent then
            document.sources[#document.sources + 1] = source
        end
    else
        documents[documentId] = {
            sources = { source },
            data = nil
        }
    end

    clients[source] = {
        document = documentId,
        clientId = clientId
    }

    return documents[documentId].data
end)

BaseCallback("liveEdit:crdtUpdate", function(source, _, documentId, data)
    local document = documents[documentId]

    if not document then
        return debugprint("crdtUpdate: Document not found", documentId)
    end

    document.data = data
    BroadcastToDocument(documentId, "liveEdit:crdtBroadcast", source, data)

    return true
end)

RegisterNetEvent("liveEdit:updateAwareness", function(documentId, clientId, awareness)
    local source = source
    local clientState = clients[source]

    if not clientState then
        return
    end

    clientState.awareness = awareness
    BroadcastToDocument(documentId, "liveEdit:awarenessUpdate", source, clientId, awareness)
end)

RegisterNetEvent("liveEdit:leaveDocument", function()
    RemoveClientFromDocument(source)
end)

RegisterNetEvent("liveEdit:saveFullDocState", function(documentId, data)
    local document = documents[documentId]

    if not document then
        return debugprint("saveFullDocState: Document not found", documentId)
    end

    document.data = data
end)

RegisterNetEvent("liveEdit:refreshAwareness", function()
    local source = source

    Wait(500)
    SendExistingAwarenessToClient(source)
end)

OnPlayerDisconnect(function(source)
    RemoveClientFromDocument(source)
end)