-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-input.lua
--  Engineered by Eazy Fxap
--  Original: 236 lines → Cleaned: 80 lines
-- =====================================================

function UI.CreateInput(self, data, enable, cb)
    if enable then
        UI:ParseInputData(data, function(result)
            if cb then cb(result) end
        end)
    end
end

function UI.ParseInputData(self, data, cb)
    local result = nil
    if Config.Input == Input.OX then
        result = UI:CreateOXInput(data)
    elseif Config.Input == Input.QB then
        result = UI:CreateQBInput(data)
    elseif Config.Input == Input.RCORE then
        result = UI:CreateRCOREInput(data)
    end
    cb(result)
end

function UI.CreateRCOREInput(self, data)
    local formattedInputs = {}
    for _, item in ipairs(data.inputs) do
        formattedInputs = {
            type = item.type or "input",
            label = item.text or "",
            description = item.description or "",
            required = item.isRequired or false
        }
        if item.icon then
            formattedInputs.icon = item.icon
        end
    end
    
    local title = data.header or "Dialog title"
    local desc = formattedInputs.label or "Dialog description"
    
    local p = promise.new()
    Input.Show(title, desc, function(response)
        Input.Hide()
        if response.state then
            p:resolve(response.amount)
        else
            p:resolve(nil)
        end
    end)
    
    return Citizen.Await(p)
end

function UI.CreateQBInput(self, data)
    if not data then return end
    return exports[Inputs.QB]:ShowInput(data)
end

function UI.CreateOXInput(self, data)
    if not data then return end
    if not lib then return end
    
    local formattedInputs = {}
    for _, item in ipairs(data.inputs) do
        local input = {
            type = item.type or "input",
            label = item.text or "",
            description = item.description or "",
            required = item.isRequired or false
        }
        if item.icon then
            input.icon = item.icon
        end
        table.insert(formattedInputs, input)
    end
    
    local title = data.header or "Dialog title"
    return lib.inputDialog(title, formattedInputs)
end
