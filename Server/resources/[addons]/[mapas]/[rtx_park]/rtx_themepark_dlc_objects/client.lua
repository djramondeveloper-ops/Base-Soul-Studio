
local func3, strValue3, func, isDisabled
func3 = RegisterCommand
strValue3 = "playmyanim"

function func()
    local strValue2, strValue, condition, func2, var25, var2, var23, var27, var26, var24, var22, counter
    strValue2 = "export@head_000_r"
    strValue = "head_000_r"
    condition = RequestAnimDict
    func2 = strValue2
    condition(func2)
    while true do
        condition = HasAnimDictLoaded
        func2 = strValue2
        condition = condition(func2)
        if condition then
            break
        end
        condition = Wait
        func2 = 1
        condition(func2)
    end
    condition = PlayerPedId
    condition = condition()
    func2 = TaskPlayAnim
    var25 = condition
    var2 = strValue2
    var23 = strValue
    var27 = 4.0
    var26 = 4.0
    var24 = -1
    var22 = 1
    counter = 0.0
    func2(var25, var2, var23, var27, var26, var24, var22, counter)
    func2 = RemoveAnimDict
    var25 = strValue2
    func2(var25)
end
isDisabled = false
func3(strValue3, func, isDisabled)