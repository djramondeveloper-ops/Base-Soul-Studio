Dialog = type(_G.Dialog) == 'table' and _G.Dialog or {}

local activeDialogPromise = nil

local function RegisterDialogCallback(name, handler)
    assert(type(name) == "string", "Name must be a string")
    assert(type(handler) == "function", "Handler must be a function")

    RegisterNUICallback(name, function(data, cb)
        handler(data)
        cb("ok")
    end)
end

RegisterDialogCallback("closeDialog", function(_)
    dbg.critical("closeDialog")
    SetNuiFocus(false, false)
end)

RegisterDialogCallback("confirmDialog", function(_)
    dbg.critical("confirmDialog")
    SetNuiFocus(false, false)
end)

RegisterDialogCallback("dialogState", function(state)
    if activeDialogPromise then
        activeDialogPromise:resolve(state)
        activeDialogPromise = nil
    end
end)

function Dialog.Show(title, description, callback)
    local dialogPromise = promise.new()
    activeDialogPromise = dialogPromise

    SetNuiFocus(true, true)

    CreateThread(function()
        FrontendService.SendReactMessage("dialog", {
            visible = true,
            title = title,
            desc = description,
        })
    end, "cl-lib-dialog code name: Phoenix")

    local result = Citizen.Await(dialogPromise)

    if callback then
        callback(result)
    end
end

function Dialog.Hide()
    SetNuiFocus(false, false)

    FrontendService.SendReactMessage("dialog", {
        visible = false,
    })
end