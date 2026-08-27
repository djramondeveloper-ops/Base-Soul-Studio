
local counter2, dataTable, dataTable2, isDisabled, func2, strValue2, func3
counter2 = IsDuplicityVersion
counter2 = counter2()
if counter2 then
    counter2 = GetPlayerPositionInRealTime77
    counter2()
end
counter2 = 0
dataTable = Config
dataTable = dataTable.ThemeParkControlAttractions
if dataTable then
    dataTable = false
    dataTable2 = false
    isDisabled = false

    function func2(A0_2, A1_2)
        local entityCoords, strValue, numValue
        entityCoords = A1_2 or nil
        if not A1_2 then
            entityCoords = 0
        end
        strValue = 10
        entityCoords = strValue ^ entityCoords
        strValue = math
        strValue = strValue.floor
        numValue = A0_2 * entityCoords
        numValue = numValue + 0.5
        strValue = strValue(numValue)
        strValue = strValue / entityCoords
        return strValue
    end
    RoundNumber = func2

    function func2(A0_2, A1_2, A2_2)
        local strValue, numValue, numValue2, condition2, dataTable5, dataTable6, counter, var22
        strValue = controlmachines
        strValue = strValue[A2_2]
        strValue = strValue.musichandler
        if nil ~= strValue then
            numValue = SendNUIMessage
            numValue2 = {}
            numValue2.message = "stopsound"
            numValue2.soundid = A2_2
            condition2 = strValue.soundcategory
            numValue2.soundcategorytype = condition2
            numValue(numValue2)
            numValue = controlmachines
            numValue = numValue[A2_2]
            numValue.musichandler = nil
        end
        numValue = A0_2
        numValue2 = "classic"
        condition2 = string
        condition2 = condition2.find
        dataTable5 = A0_2
        dataTable6 = "youtube.com"
        condition2 = condition2(dataTable5, dataTable6)
        if condition2 then
            condition2 = string
            condition2 = condition2.find
            dataTable5 = A0_2
            dataTable6 = "^https://www.youtube.com"
            condition2 = condition2(dataTable5, dataTable6)
            if condition2 then
                condition2 = string
                condition2 = condition2.sub
                dataTable5 = A0_2
                dataTable6 = 33
                condition2 = condition2(dataTable5, dataTable6)
                dataTable5 = string
                dataTable5 = dataTable5.sub
                dataTable6 = condition2
                counter = 1
                var22 = 11
                dataTable5 = dataTable5(dataTable6, counter, var22)
                numValue = dataTable5
                numValue2 = "youtube"
            else
                condition2 = string
                condition2 = condition2.find
                dataTable5 = A0_2
                dataTable6 = "^https://youtube.com"
                condition2 = condition2(dataTable5, dataTable6)
                if condition2 then
                    condition2 = string
                    condition2 = condition2.sub
                    dataTable5 = A0_2
                    dataTable6 = 29
                    condition2 = condition2(dataTable5, dataTable6)
                    dataTable5 = string
                    dataTable5 = dataTable5.sub
                    dataTable6 = condition2
                    counter = 1
                    var22 = 11
                    dataTable5 = dataTable5(dataTable6, counter, var22)
                    numValue = dataTable5
                    numValue2 = "youtube"
                else
                    condition2 = string
                    condition2 = condition2.find
                    dataTable5 = A0_2
                    dataTable6 = "^http://youtube.com"
                    condition2 = condition2(dataTable5, dataTable6)
                    if condition2 then
                        condition2 = string
                        condition2 = condition2.sub
                        dataTable5 = A0_2
                        dataTable6 = 28
                        condition2 = condition2(dataTable5, dataTable6)
                        dataTable5 = string
                        dataTable5 = dataTable5.sub
                        dataTable6 = condition2
                        counter = 1
                        var22 = 11
                        dataTable5 = dataTable5(dataTable6, counter, var22)
                        numValue = dataTable5
                        numValue2 = "youtube"
                    else
                        condition2 = string
                        condition2 = condition2.find
                        dataTable5 = A0_2
                        dataTable6 = "^http://www.youtube.com"
                        condition2 = condition2(dataTable5, dataTable6)
                        if condition2 then
                            condition2 = string
                            condition2 = condition2.sub
                            dataTable5 = A0_2
                            dataTable6 = 33
                            condition2 = condition2(dataTable5, dataTable6)
                            dataTable5 = string
                            dataTable5 = dataTable5.sub
                            dataTable6 = condition2
                            counter = 1
                            var22 = 11
                            dataTable5 = dataTable5(dataTable6, counter, var22)
                            numValue = dataTable5
                            numValue2 = "youtube"
                        else
                            condition2 = string
                            condition2 = condition2.find
                            dataTable5 = A0_2
                            dataTable6 = "^www.youtube.com"
                            condition2 = condition2(dataTable5, dataTable6)
                            if condition2 then
                                condition2 = string
                                condition2 = condition2.sub
                                dataTable5 = A0_2
                                dataTable6 = 25
                                condition2 = condition2(dataTable5, dataTable6)
                                dataTable5 = string
                                dataTable5 = dataTable5.sub
                                dataTable6 = condition2
                                counter = 1
                                var22 = 11
                                dataTable5 = dataTable5(dataTable6, counter, var22)
                                numValue = dataTable5
                                numValue2 = "youtube"
                            else
                                condition2 = string
                                condition2 = condition2.find
                                dataTable5 = A0_2
                                dataTable6 = "^youtube.com"
                                condition2 = condition2(dataTable5, dataTable6)
                                if condition2 then
                                    condition2 = string
                                    condition2 = condition2.sub
                                    dataTable5 = A0_2
                                    dataTable6 = 21
                                    condition2 = condition2(dataTable5, dataTable6)
                                    dataTable5 = string
                                    dataTable5 = dataTable5.sub
                                    dataTable6 = condition2
                                    counter = 1
                                    var22 = 11
                                    dataTable5 = dataTable5(dataTable6, counter, var22)
                                    numValue = dataTable5
                                    numValue2 = "youtube"
                                end
                            end
                        end
                    end
                end
            end
        else
            condition2 = string
            condition2 = condition2.find
            dataTable5 = A0_2
            dataTable6 = "youtu.be"
            condition2 = condition2(dataTable5, dataTable6)
            if condition2 then
                soundsrcreformatedtype = "youtube"
                condition2 = string
                condition2 = condition2.find
                dataTable5 = A0_2
                dataTable6 = "^https://www.youtu.be"
                condition2 = condition2(dataTable5, dataTable6)
                if condition2 then
                    condition2 = string
                    condition2 = condition2.sub
                    dataTable5 = A0_2
                    dataTable6 = 22
                    condition2 = condition2(dataTable5, dataTable6)
                    dataTable5 = string
                    dataTable5 = dataTable5.sub
                    dataTable6 = condition2
                    counter = 1
                    var22 = 11
                    dataTable5 = dataTable5(dataTable6, counter, var22)
                    numValue = dataTable5
                    numValue2 = "youtube"
                else
                    condition2 = string
                    condition2 = condition2.find
                    dataTable5 = A0_2
                    dataTable6 = "^https://youtu.be"
                    condition2 = condition2(dataTable5, dataTable6)
                    if condition2 then
                        condition2 = string
                        condition2 = condition2.sub
                        dataTable5 = A0_2
                        dataTable6 = 18
                        condition2 = condition2(dataTable5, dataTable6)
                        dataTable5 = string
                        dataTable5 = dataTable5.sub
                        dataTable6 = condition2
                        counter = 1
                        var22 = 11
                        dataTable5 = dataTable5(dataTable6, counter, var22)
                        numValue = dataTable5
                        numValue2 = "youtube"
                    else
                        condition2 = string
                        condition2 = condition2.find
                        dataTable5 = A0_2
                        dataTable6 = "^http://youtu.be"
                        condition2 = condition2(dataTable5, dataTable6)
                        if condition2 then
                            condition2 = string
                            condition2 = condition2.sub
                            dataTable5 = A0_2
                            dataTable6 = 17
                            condition2 = condition2(dataTable5, dataTable6)
                            dataTable5 = string
                            dataTable5 = dataTable5.sub
                            dataTable6 = condition2
                            counter = 1
                            var22 = 11
                            dataTable5 = dataTable5(dataTable6, counter, var22)
                            numValue = dataTable5
                            numValue2 = "youtube"
                        else
                            condition2 = string
                            condition2 = condition2.find
                            dataTable5 = A0_2
                            dataTable6 = "^http://www.youtu.be"
                            condition2 = condition2(dataTable5, dataTable6)
                            if condition2 then
                                condition2 = string
                                condition2 = condition2.sub
                                dataTable5 = A0_2
                                dataTable6 = 21
                                condition2 = condition2(dataTable5, dataTable6)
                                dataTable5 = string
                                dataTable5 = dataTable5.sub
                                dataTable6 = condition2
                                counter = 1
                                var22 = 11
                                dataTable5 = dataTable5(dataTable6, counter, var22)
                                numValue = dataTable5
                                numValue2 = "youtube"
                            else
                                condition2 = string
                                condition2 = condition2.find
                                dataTable5 = A0_2
                                dataTable6 = "^www.youtu.be"
                                condition2 = condition2(dataTable5, dataTable6)
                                if condition2 then
                                    condition2 = string
                                    condition2 = condition2.sub
                                    dataTable5 = A0_2
                                    dataTable6 = 14
                                    condition2 = condition2(dataTable5, dataTable6)
                                    dataTable5 = string
                                    dataTable5 = dataTable5.sub
                                    dataTable6 = condition2
                                    counter = 1
                                    var22 = 11
                                    dataTable5 = dataTable5(dataTable6, counter, var22)
                                    numValue = dataTable5
                                    numValue2 = "youtube"
                                else
                                    condition2 = string
                                    condition2 = condition2.find
                                    dataTable5 = A0_2
                                    dataTable6 = "^youtu.be"
                                    condition2 = condition2(dataTable5, dataTable6)
                                    if condition2 then
                                        condition2 = string
                                        condition2 = condition2.sub
                                        dataTable5 = A0_2
                                        dataTable6 = 10
                                        condition2 = condition2(dataTable5, dataTable6)
                                        dataTable5 = string
                                        dataTable5 = dataTable5.sub
                                        dataTable6 = condition2
                                        counter = 1
                                        var22 = 11
                                        dataTable5 = dataTable5(dataTable6, counter, var22)
                                        numValue = dataTable5
                                        numValue2 = "youtube"
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        condition2 = controlmachines
        condition2 = condition2[A2_2]
        dataTable5 = {}
        dataTable5.soundsrc = numValue
        dataTable5.soundvolume = A1_2
        dataTable5.soundcategory = numValue2
        dataTable5.sounddetailsready = false
        dataTable5.soundname = ""
        dataTable5.soundtime = 0
        dataTable5.soundtimemax = 0
        condition2.musichandler = dataTable5
    end
    CreateSound = func2

    function func2(A0_2)
        local isEnabled, entityCoords, strValue, numValue, numValue2, condition2, dataTable5
        isEnabled = false
        entityCoords = ""
        strValue = string
        strValue = strValue.find
        numValue = A0_2
        numValue2 = "youtube.com"
        strValue = strValue(numValue, numValue2)
        if strValue then
            strValue = string
            strValue = strValue.find
            numValue = A0_2
            numValue2 = "^https://www.youtube.com"
            strValue = strValue(numValue, numValue2)
            if strValue then
                strValue = string
                strValue = strValue.sub
                numValue = A0_2
                numValue2 = 33
                strValue = strValue(numValue, numValue2)
                numValue = string
                numValue = numValue.sub
                numValue2 = strValue
                condition2 = 1
                dataTable5 = 11
                numValue = numValue(numValue2, condition2, dataTable5)
                entityCoords = numValue
                isEnabled = true
            else
                strValue = string
                strValue = strValue.find
                numValue = A0_2
                numValue2 = "^https://youtube.com"
                strValue = strValue(numValue, numValue2)
                if strValue then
                    strValue = string
                    strValue = strValue.sub
                    numValue = A0_2
                    numValue2 = 29
                    strValue = strValue(numValue, numValue2)
                    numValue = string
                    numValue = numValue.sub
                    numValue2 = strValue
                    condition2 = 1
                    dataTable5 = 11
                    numValue = numValue(numValue2, condition2, dataTable5)
                    entityCoords = numValue
                    isEnabled = true
                else
                    strValue = string
                    strValue = strValue.find
                    numValue = A0_2
                    numValue2 = "^http://youtube.com"
                    strValue = strValue(numValue, numValue2)
                    if strValue then
                        strValue = string
                        strValue = strValue.sub
                        numValue = A0_2
                        numValue2 = 28
                        strValue = strValue(numValue, numValue2)
                        numValue = string
                        numValue = numValue.sub
                        numValue2 = strValue
                        condition2 = 1
                        dataTable5 = 11
                        numValue = numValue(numValue2, condition2, dataTable5)
                        entityCoords = numValue
                        isEnabled = true
                    else
                        strValue = string
                        strValue = strValue.find
                        numValue = A0_2
                        numValue2 = "^http://www.youtube.com"
                        strValue = strValue(numValue, numValue2)
                        if strValue then
                            strValue = string
                            strValue = strValue.sub
                            numValue = A0_2
                            numValue2 = 33
                            strValue = strValue(numValue, numValue2)
                            numValue = string
                            numValue = numValue.sub
                            numValue2 = strValue
                            condition2 = 1
                            dataTable5 = 11
                            numValue = numValue(numValue2, condition2, dataTable5)
                            entityCoords = numValue
                            isEnabled = true
                        else
                            strValue = string
                            strValue = strValue.find
                            numValue = A0_2
                            numValue2 = "^www.youtube.com"
                            strValue = strValue(numValue, numValue2)
                            if strValue then
                                strValue = string
                                strValue = strValue.sub
                                numValue = A0_2
                                numValue2 = 25
                                strValue = strValue(numValue, numValue2)
                                numValue = string
                                numValue = numValue.sub
                                numValue2 = strValue
                                condition2 = 1
                                dataTable5 = 11
                                numValue = numValue(numValue2, condition2, dataTable5)
                                entityCoords = numValue
                                isEnabled = true
                            else
                                strValue = string
                                strValue = strValue.find
                                numValue = A0_2
                                numValue2 = "^youtube.com"
                                strValue = strValue(numValue, numValue2)
                                if strValue then
                                    strValue = string
                                    strValue = strValue.sub
                                    numValue = A0_2
                                    numValue2 = 21
                                    strValue = strValue(numValue, numValue2)
                                    numValue = string
                                    numValue = numValue.sub
                                    numValue2 = strValue
                                    condition2 = 1
                                    dataTable5 = 11
                                    numValue = numValue(numValue2, condition2, dataTable5)
                                    entityCoords = numValue
                                    isEnabled = true
                                end
                            end
                        end
                    end
                end
            end
        else
            strValue = string
            strValue = strValue.find
            numValue = A0_2
            numValue2 = "youtu.be"
            strValue = strValue(numValue, numValue2)
            if strValue then
                strValue = string
                strValue = strValue.find
                numValue = A0_2
                numValue2 = "^https://www.youtu.be"
                strValue = strValue(numValue, numValue2)
                if strValue then
                    strValue = string
                    strValue = strValue.sub
                    numValue = A0_2
                    numValue2 = 22
                    strValue = strValue(numValue, numValue2)
                    numValue = string
                    numValue = numValue.sub
                    numValue2 = strValue
                    condition2 = 1
                    dataTable5 = 11
                    numValue = numValue(numValue2, condition2, dataTable5)
                    entityCoords = numValue
                    isEnabled = true
                else
                    strValue = string
                    strValue = strValue.find
                    numValue = A0_2
                    numValue2 = "^https://youtu.be"
                    strValue = strValue(numValue, numValue2)
                    if strValue then
                        strValue = string
                        strValue = strValue.sub
                        numValue = A0_2
                        numValue2 = 18
                        strValue = strValue(numValue, numValue2)
                        numValue = string
                        numValue = numValue.sub
                        numValue2 = strValue
                        condition2 = 1
                        dataTable5 = 11
                        numValue = numValue(numValue2, condition2, dataTable5)
                        entityCoords = numValue
                        isEnabled = true
                    else
                        strValue = string
                        strValue = strValue.find
                        numValue = A0_2
                        numValue2 = "^http://youtu.be"
                        strValue = strValue(numValue, numValue2)
                        if strValue then
                            strValue = string
                            strValue = strValue.sub
                            numValue = A0_2
                            numValue2 = 17
                            strValue = strValue(numValue, numValue2)
                            numValue = string
                            numValue = numValue.sub
                            numValue2 = strValue
                            condition2 = 1
                            dataTable5 = 11
                            numValue = numValue(numValue2, condition2, dataTable5)
                            entityCoords = numValue
                            isEnabled = true
                        else
                            strValue = string
                            strValue = strValue.find
                            numValue = A0_2
                            numValue2 = "^http://www.youtu.be"
                            strValue = strValue(numValue, numValue2)
                            if strValue then
                                strValue = string
                                strValue = strValue.sub
                                numValue = A0_2
                                numValue2 = 21
                                strValue = strValue(numValue, numValue2)
                                numValue = string
                                numValue = numValue.sub
                                numValue2 = strValue
                                condition2 = 1
                                dataTable5 = 11
                                numValue = numValue(numValue2, condition2, dataTable5)
                                entityCoords = numValue
                                isEnabled = true
                            else
                                strValue = string
                                strValue = strValue.find
                                numValue = A0_2
                                numValue2 = "^www.youtu.be"
                                strValue = strValue(numValue, numValue2)
                                if strValue then
                                    strValue = string
                                    strValue = strValue.sub
                                    numValue = A0_2
                                    numValue2 = 14
                                    strValue = strValue(numValue, numValue2)
                                    numValue = string
                                    numValue = numValue.sub
                                    numValue2 = strValue
                                    condition2 = 1
                                    dataTable5 = 11
                                    numValue = numValue(numValue2, condition2, dataTable5)
                                    entityCoords = numValue
                                    isEnabled = true
                                else
                                    strValue = string
                                    strValue = strValue.find
                                    numValue = A0_2
                                    numValue2 = "^youtu.be"
                                    strValue = strValue(numValue, numValue2)
                                    if strValue then
                                        strValue = string
                                        strValue = strValue.sub
                                        numValue = A0_2
                                        numValue2 = 10
                                        strValue = strValue(numValue, numValue2)
                                        numValue = string
                                        numValue = numValue.sub
                                        numValue2 = strValue
                                        condition2 = 1
                                        dataTable5 = 11
                                        numValue = numValue(numValue2, condition2, dataTable5)
                                        entityCoords = numValue
                                        isEnabled = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if isEnabled then
            strValue = dataTable
            if false == strValue then
                strValue = false
                isDisabled = strValue
                strValue = false
                dataTable2 = strValue
                strValue = true
                dataTable = strValue
                strValue = SendNUIMessage
                numValue = {}
                numValue.message = "checkmusicurl"
                numValue.soundsrc = entityCoords
                strValue(numValue)
                while true do
                    strValue = dataTable2
                    if false ~= strValue then
                        break
                    end
                    strValue = Citizen
                    strValue = strValue.Wait
                    numValue = 0
                    strValue(numValue)
                end
                strValue = isDisabled
                return strValue
            else
                strValue = false
                return strValue
            end
        else
            strValue = false
            return strValue
        end
    end
    SoundUrlCheck = func2
    func2 = Citizen
    func2 = func2.CreateThread

    function strValue2()
        local isEnabled2, isEnabled, entityCoords, strValue, numValue, numValue2, condition2, dataTable5, dataTable6, counter, var22, condition4, counter3, condition5, condition3, func, dataTable3, condition, func4, dataTable4, var2
        while true do
            isEnabled2 = Citizen
            isEnabled2 = isEnabled2.Wait
            isEnabled = 500
            isEnabled2(isEnabled)
            isEnabled2 = nearbythemepark
            if isEnabled2 then
                isEnabled2 = false
                isEnabled = PlayerPedId
                isEnabled = isEnabled()
                entityCoords = GetEntityCoords
                strValue = isEnabled
                entityCoords = entityCoords(strValue)
                strValue = ipairs
                numValue = controlmachines
                strValue, numValue, numValue2, condition2 = strValue(numValue)
                for dataTable5, dataTable6 in strValue, numValue, numValue2, condition2 do
                    counter = dataTable6.musichandler
                    var22 = dataTable6.musichandler
                    if nil ~= var22 then
                        isEnabled2 = true
                        var22 = dataTable6.musiccoords
                        condition4 = entityCoords - var22
                        condition4 = #condition4
                        counter3 = counter.soundcategory
                        if "youtube" == counter3 then
                            counter3 = counter.soundvolume
                            condition5 = counter.soundvolume
                            condition5 = condition5 / 100
                            condition5 = condition5 * 1.0
                            condition3 = dataTable6.musicmaxdistance
                            condition3 = condition4 / condition3
                            func = condition3 * 100
                            dataTable3 = 100
                            dataTable3 = dataTable3 - func
                            condition = counter.soundvolume
                            condition = condition / 100
                            condition = condition * dataTable3
                            if condition > 0 then
                                func4 = math
                                func4 = func4.floor
                                dataTable4 = condition
                                func4 = func4(dataTable4)
                                counter3 = func4
                            else
                                counter3 = 0
                            end
                            func4 = dataTable6.musicmaxdistance
                            if condition3 > func4 then
                                func4 = SendNUIMessage
                                dataTable4 = {}
                                dataTable4.message = "playsound"
                                dataTable4.soundid = dataTable5
                                var2 = counter.soundsrc
                                dataTable4.soundsrc = var2
                                dataTable4.soundvolume = 0.0
                                var2 = counter.soundcategory
                                dataTable4.soundcategory = var2
                                func4(dataTable4)
                            else
                                func4 = streamermodeactivated
                                if true == func4 then
                                    func4 = SendNUIMessage
                                    dataTable4 = {}
                                    dataTable4.message = "playsound"
                                    dataTable4.soundid = dataTable5
                                    var2 = counter.soundsrc
                                    dataTable4.soundsrc = var2
                                    dataTable4.soundvolume = 0.0
                                    var2 = counter.soundcategory
                                    dataTable4.soundcategory = var2
                                    func4(dataTable4)
                                else
                                    func4 = SendNUIMessage
                                    dataTable4 = {}
                                    dataTable4.message = "playsound"
                                    dataTable4.soundid = dataTable5
                                    var2 = counter.soundsrc
                                    dataTable4.soundsrc = var2
                                    dataTable4.soundvolume = counter3
                                    var2 = counter.soundcategory
                                    dataTable4.soundcategory = var2
                                    func4(dataTable4)
                                end
                            end
                        else
                            counter3 = counter.soundvolume
                            counter3 = counter3 / 100
                            counter3 = counter3 * 1.0
                            condition5 = dataTable6.musicmaxdistance
                            condition5 = condition4 / condition5
                            condition3 = condition5 * 100
                            func = 100
                            func = func - condition3
                            dataTable3 = counter.soundvolume
                            dataTable3 = dataTable3 / 100
                            dataTable3 = dataTable3 * func
                            condition = dataTable3 / 100
                            condition = condition * 1.0
                            if dataTable3 > 0 then
                                func4 = RoundNumber
                                dataTable4 = condition
                                var2 = 2
                                func4 = func4(dataTable4, var2)
                                soundvolume = func4
                            else
                                soundvolume = 0.0
                            end
                            func4 = dataTable6.musicmaxdistance
                            if condition5 > func4 then
                                func4 = SendNUIMessage
                                dataTable4 = {}
                                dataTable4.message = "playsound"
                                dataTable4.soundid = dataTable5
                                var2 = counter.soundsrc
                                dataTable4.soundsrc = var2
                                dataTable4.soundvolume = 0.0
                                var2 = counter.soundcategory
                                dataTable4.soundcategory = var2
                                func4(dataTable4)
                            else
                                func4 = streamermodeactivated
                                if true == func4 then
                                    func4 = SendNUIMessage
                                    dataTable4 = {}
                                    dataTable4.message = "playsound"
                                    dataTable4.soundid = dataTable5
                                    var2 = counter.soundsrc
                                    dataTable4.soundsrc = var2
                                    dataTable4.soundvolume = 0.0
                                    var2 = counter.soundcategory
                                    dataTable4.soundcategory = var2
                                    func4(dataTable4)
                                else
                                    func4 = SendNUIMessage
                                    dataTable4 = {}
                                    dataTable4.message = "playsound"
                                    dataTable4.soundid = dataTable5
                                    var2 = counter.soundsrc
                                    dataTable4.soundsrc = var2
                                    var2 = soundvolume
                                    dataTable4.soundvolume = var2
                                    var2 = counter.soundcategory
                                    dataTable4.soundcategory = var2
                                    func4(dataTable4)
                                end
                            end
                        end
                    end
                end
                if false == isEnabled2 then
                    strValue = Citizen
                    strValue = strValue.Wait
                    numValue = 500
                    strValue(numValue)
                end
            else
                isEnabled2 = Citizen
                isEnabled2 = isEnabled2.Wait
                isEnabled = 1000
                isEnabled2(isEnabled)
                isEnabled2 = ipairs
                isEnabled = controlmachines
                isEnabled2, isEnabled, entityCoords, strValue = isEnabled2(isEnabled)
                for numValue, numValue2 in isEnabled2, isEnabled, entityCoords, strValue do
                    condition2 = numValue2.musichandler
                    dataTable5 = numValue2.musichandler
                    if nil ~= dataTable5 then
                        dataTable5 = SendNUIMessage
                        dataTable6 = {}
                        dataTable6.message = "playsound"
                        dataTable6.soundid = numValue
                        counter = condition2.soundsrc
                        dataTable6.soundsrc = counter
                        dataTable6.soundvolume = 0.0
                        counter = condition2.soundcategory
                        dataTable6.soundcategory = counter
                        dataTable5(dataTable6)
                    end
                end
            end
        end
    end
    func2(strValue2)
    func2 = RegisterNetEvent
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicPlayClient"
    func2(strValue2)
    func2 = AddEventHandler
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicPlayClient"

    function func3(A0_2, A1_2, A2_2)
        local strValue, numValue, numValue2, condition2
        strValue = CreateSound
        numValue = A1_2
        numValue2 = A2_2
        condition2 = A0_2
        strValue(numValue, numValue2, condition2)
    end
    func2(strValue2, func3)
    func2 = RegisterNetEvent
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicStopClient"
    func2(strValue2)
    func2 = AddEventHandler
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicStopClient"

    function func3(A0_2)
        local isEnabled, entityCoords, strValue, numValue
        isEnabled = controlmachines
        isEnabled = isEnabled[A0_2]
        isEnabled = isEnabled.musichandler
        if nil ~= isEnabled then
            isEnabled = controlmachines
            isEnabled = isEnabled[A0_2]
            isEnabled = isEnabled.musichandler
            entityCoords = SendNUIMessage
            strValue = {}
            strValue.message = "stopsound"
            strValue.soundid = A0_2
            numValue = isEnabled.soundcategory
            strValue.soundcategorytype = numValue
            entityCoords(strValue)
            entityCoords = controlmachines
            entityCoords = entityCoords[A0_2]
            entityCoords.musichandler = nil
            entityCoords = inattractioncontrolmenu
            if true == entityCoords then
                entityCoords = attractioncontrolledid
                if A0_2 == entityCoords then
                    entityCoords = SendNUIMessage
                    strValue = {}
                    strValue.message = "updateattractionmusiclabel"
                    strValue.musiclabel = ""
                    entityCoords(strValue)
                end
            end
        end
    end
    func2(strValue2, func3)
    func2 = RegisterNetEvent
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicVolume"
    func2(strValue2)
    func2 = AddEventHandler
    strValue2 = "rtx_themepark:Music:ThemeParkControlMusicVolume"

    function func3(A0_2, A1_2)
        local entityCoords, strValue
        entityCoords = controlmachines
        entityCoords = entityCoords[A0_2]
        entityCoords.musicvolume = A1_2
        strValue = controlmachines
        strValue = strValue[A0_2]
        strValue = strValue.musichandler
        if nil ~= strValue then
            strValue = controlmachines
            strValue = strValue[A0_2]
            strValue = strValue.musichandler
            strValue.soundvolume = A1_2
        end
    end
    func2(strValue2, func3)
    func2 = RegisterNUICallback
    strValue2 = "soundend"

    function func3(A0_2, A1_2)
        local entityCoords, strValue, numValue, numValue2, condition2
        entityCoords = controlmachines
        strValue = tonumber
        numValue = A0_2.soundid
        strValue = strValue(numValue)
        entityCoords = entityCoords[strValue]
        entityCoords = entityCoords.musichandler
        strValue = TriggerEvent
        numValue = "rtx_themepark:SoundEnded"
        numValue2 = entityCoords.soundsrc
        condition2 = entityCoords.soundcategory
        strValue(numValue, numValue2, condition2)
        strValue = SendNUIMessage
        numValue = {}
        numValue.message = "stopsound"
        numValue2 = tonumber
        condition2 = A0_2.soundid
        numValue2 = numValue2(condition2)
        numValue.soundid = numValue2
        numValue2 = entityCoords.soundcategory
        numValue.soundcategorytype = numValue2
        strValue(numValue)
        entityCoords = nil
        strValue = A1_2
        numValue = "ok"
        strValue(numValue)
    end
    func2(strValue2, func3)
    func2 = RegisterNUICallback
    strValue2 = "sounderror"

    function func3(A0_2, A1_2)
        local entityCoords, strValue, numValue, numValue2, condition2
        entityCoords = controlmachines
        strValue = tonumber
        numValue = A0_2.soundid
        strValue = strValue(numValue)
        entityCoords = entityCoords[strValue]
        entityCoords = entityCoords.musichandler
        strValue = SendNUIMessage
        numValue = {}
        numValue.message = "stopsound"
        numValue2 = tonumber
        condition2 = A0_2.soundid
        numValue2 = numValue2(condition2)
        numValue.soundid = numValue2
        numValue2 = entityCoords.soundcategory
        numValue.soundcategorytype = numValue2
        strValue(numValue)
        entityCoords = nil
        strValue = A1_2
        numValue = "ok"
        strValue(numValue)
    end
    func2(strValue2, func3)
    func2 = RegisterNUICallback
    strValue2 = "updatesounddata"

    function func3(A0_2, A1_2)
        local entityCoords, strValue, numValue, numValue2, condition2
        entityCoords = controlmachines
        strValue = tonumber
        numValue = A0_2.soundid
        strValue = strValue(numValue)
        entityCoords = entityCoords[strValue]
        entityCoords = entityCoords.musichandler
        strValue = tostring
        numValue = A0_2.soundname
        strValue = strValue(numValue)
        entityCoords.soundname = strValue
        strValue = tonumber
        numValue = A0_2.soundtime
        strValue = strValue(numValue)
        entityCoords.soundtime = strValue
        strValue = A0_2.soundtimemax
        if nil ~= strValue then
            strValue = tonumber
            numValue = A0_2.soundtimemax
            strValue = strValue(numValue)
            entityCoords.soundtimemax = strValue
        else
            entityCoords.soundtimemax = "stream"
        end
        entityCoords.sounddetailsready = true
        strValue = Citizen
        strValue = strValue.Wait
        numValue = 100
        strValue(numValue)
        strValue = SendNUIMessage
        numValue = {}
        numValue.message = "updatesounddata"
        numValue2 = tonumber
        condition2 = A0_2.soundid
        numValue2 = numValue2(condition2)
        numValue.soundid = numValue2
        numValue2 = entityCoords.soundcategory
        numValue.soundcategorytype = numValue2
        strValue(numValue)
        strValue = inattractioncontrolmenu
        if true == strValue then
            strValue = tonumber
            numValue = A0_2.soundid
            strValue = strValue(numValue)
            numValue = attractioncontrolledid
            if strValue == numValue then
                strValue = controlmachines
                numValue = tonumber
                numValue2 = A0_2.soundid
                numValue = numValue(numValue2)
                strValue = strValue[numValue]
                strValue = strValue.musichandler
                if nil ~= strValue then
                    numValue = SendNUIMessage
                    numValue2 = {}
                    numValue2.message = "updateattractionmusiclabel"
                    condition2 = entityCoords.soundname
                    numValue2.musiclabel = condition2
                    numValue(numValue2)
                else
                    numValue = SendNUIMessage
                    numValue2 = {}
                    numValue2.message = "updateattractionmusiclabel"
                    numValue2.musiclabel = ""
                    numValue(numValue2)
                end
            end
        end
        strValue = A1_2
        numValue = "ok"
        strValue(numValue)
    end
    func2(strValue2, func3)
    func2 = RegisterNUICallback
    strValue2 = "checkdone"

    function func3(A0_2, A1_2)
        local entityCoords, strValue
        entityCoords = A0_2.soundallowed
        isDisabled = entityCoords
        entityCoords = false
        dataTable = entityCoords
        entityCoords = true
        dataTable2 = entityCoords
        entityCoords = A1_2
        strValue = "ok"
        entityCoords(strValue)
    end
    func2(strValue2, func3)
end
dataTable = {}
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.gforce = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.topscan = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.vortex = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.detonator = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.boat = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.bumpercars = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.ferris = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.rollercoaster = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.prater = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.breakdance = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.slingshot = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.carousel = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.extasy = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.spinride = dataTable2
dataTable2 = {}
dataTable2.started = false
dataTable2.musicurl = ""
dataTable.rollercoaster2 = dataTable2

function dataTable2(A0_2, A1_2)
    local entityCoords, strValue, numValue, numValue2, condition2, dataTable5, dataTable6, counter
    entityCoords = dataTable
    entityCoords = entityCoords[A0_2]
    strValue = SendNUIMessage
    numValue = {}
    numValue.message = "stopsoundattraction"
    numValue.soundid = A0_2
    strValue(numValue)
    strValue = A1_2
    numValue = "classic"
    numValue2 = string
    numValue2 = numValue2.find
    condition2 = A1_2
    dataTable5 = "youtube.com"
    numValue2 = numValue2(condition2, dataTable5)
    if numValue2 then
        numValue2 = string
        numValue2 = numValue2.find
        condition2 = A1_2
        dataTable5 = "^https://www.youtube.com"
        numValue2 = numValue2(condition2, dataTable5)
        if numValue2 then
            numValue2 = string
            numValue2 = numValue2.sub
            condition2 = A1_2
            dataTable5 = 33
            numValue2 = numValue2(condition2, dataTable5)
            condition2 = string
            condition2 = condition2.sub
            dataTable5 = numValue2
            dataTable6 = 1
            counter = 11
            condition2 = condition2(dataTable5, dataTable6, counter)
            strValue = condition2
            numValue = "youtube"
        else
            numValue2 = string
            numValue2 = numValue2.find
            condition2 = A1_2
            dataTable5 = "^https://youtube.com"
            numValue2 = numValue2(condition2, dataTable5)
            if numValue2 then
                numValue2 = string
                numValue2 = numValue2.sub
                condition2 = A1_2
                dataTable5 = 29
                numValue2 = numValue2(condition2, dataTable5)
                condition2 = string
                condition2 = condition2.sub
                dataTable5 = numValue2
                dataTable6 = 1
                counter = 11
                condition2 = condition2(dataTable5, dataTable6, counter)
                strValue = condition2
                numValue = "youtube"
            else
                numValue2 = string
                numValue2 = numValue2.find
                condition2 = A1_2
                dataTable5 = "^http://youtube.com"
                numValue2 = numValue2(condition2, dataTable5)
                if numValue2 then
                    numValue2 = string
                    numValue2 = numValue2.sub
                    condition2 = A1_2
                    dataTable5 = 28
                    numValue2 = numValue2(condition2, dataTable5)
                    condition2 = string
                    condition2 = condition2.sub
                    dataTable5 = numValue2
                    dataTable6 = 1
                    counter = 11
                    condition2 = condition2(dataTable5, dataTable6, counter)
                    strValue = condition2
                    numValue = "youtube"
                else
                    numValue2 = string
                    numValue2 = numValue2.find
                    condition2 = A1_2
                    dataTable5 = "^http://www.youtube.com"
                    numValue2 = numValue2(condition2, dataTable5)
                    if numValue2 then
                        numValue2 = string
                        numValue2 = numValue2.sub
                        condition2 = A1_2
                        dataTable5 = 33
                        numValue2 = numValue2(condition2, dataTable5)
                        condition2 = string
                        condition2 = condition2.sub
                        dataTable5 = numValue2
                        dataTable6 = 1
                        counter = 11
                        condition2 = condition2(dataTable5, dataTable6, counter)
                        strValue = condition2
                        numValue = "youtube"
                    else
                        numValue2 = string
                        numValue2 = numValue2.find
                        condition2 = A1_2
                        dataTable5 = "^www.youtube.com"
                        numValue2 = numValue2(condition2, dataTable5)
                        if numValue2 then
                            numValue2 = string
                            numValue2 = numValue2.sub
                            condition2 = A1_2
                            dataTable5 = 25
                            numValue2 = numValue2(condition2, dataTable5)
                            condition2 = string
                            condition2 = condition2.sub
                            dataTable5 = numValue2
                            dataTable6 = 1
                            counter = 11
                            condition2 = condition2(dataTable5, dataTable6, counter)
                            strValue = condition2
                            numValue = "youtube"
                        else
                            numValue2 = string
                            numValue2 = numValue2.find
                            condition2 = A1_2
                            dataTable5 = "^youtube.com"
                            numValue2 = numValue2(condition2, dataTable5)
                            if numValue2 then
                                numValue2 = string
                                numValue2 = numValue2.sub
                                condition2 = A1_2
                                dataTable5 = 21
                                numValue2 = numValue2(condition2, dataTable5)
                                condition2 = string
                                condition2 = condition2.sub
                                dataTable5 = numValue2
                                dataTable6 = 1
                                counter = 11
                                condition2 = condition2(dataTable5, dataTable6, counter)
                                strValue = condition2
                                numValue = "youtube"
                            end
                        end
                    end
                end
            end
        end
    else
        numValue2 = string
        numValue2 = numValue2.find
        condition2 = A1_2
        dataTable5 = "youtu.be"
        numValue2 = numValue2(condition2, dataTable5)
        if numValue2 then
            soundsrcreformatedtype = "youtube"
            numValue2 = string
            numValue2 = numValue2.find
            condition2 = A1_2
            dataTable5 = "^https://www.youtu.be"
            numValue2 = numValue2(condition2, dataTable5)
            if numValue2 then
                numValue2 = string
                numValue2 = numValue2.sub
                condition2 = A1_2
                dataTable5 = 22
                numValue2 = numValue2(condition2, dataTable5)
                condition2 = string
                condition2 = condition2.sub
                dataTable5 = numValue2
                dataTable6 = 1
                counter = 11
                condition2 = condition2(dataTable5, dataTable6, counter)
                strValue = condition2
                numValue = "youtube"
            else
                numValue2 = string
                numValue2 = numValue2.find
                condition2 = A1_2
                dataTable5 = "^https://youtu.be"
                numValue2 = numValue2(condition2, dataTable5)
                if numValue2 then
                    numValue2 = string
                    numValue2 = numValue2.sub
                    condition2 = A1_2
                    dataTable5 = 18
                    numValue2 = numValue2(condition2, dataTable5)
                    condition2 = string
                    condition2 = condition2.sub
                    dataTable5 = numValue2
                    dataTable6 = 1
                    counter = 11
                    condition2 = condition2(dataTable5, dataTable6, counter)
                    strValue = condition2
                    numValue = "youtube"
                else
                    numValue2 = string
                    numValue2 = numValue2.find
                    condition2 = A1_2
                    dataTable5 = "^http://youtu.be"
                    numValue2 = numValue2(condition2, dataTable5)
                    if numValue2 then
                        numValue2 = string
                        numValue2 = numValue2.sub
                        condition2 = A1_2
                        dataTable5 = 17
                        numValue2 = numValue2(condition2, dataTable5)
                        condition2 = string
                        condition2 = condition2.sub
                        dataTable5 = numValue2
                        dataTable6 = 1
                        counter = 11
                        condition2 = condition2(dataTable5, dataTable6, counter)
                        strValue = condition2
                        numValue = "youtube"
                    else
                        numValue2 = string
                        numValue2 = numValue2.find
                        condition2 = A1_2
                        dataTable5 = "^http://www.youtu.be"
                        numValue2 = numValue2(condition2, dataTable5)
                        if numValue2 then
                            numValue2 = string
                            numValue2 = numValue2.sub
                            condition2 = A1_2
                            dataTable5 = 21
                            numValue2 = numValue2(condition2, dataTable5)
                            condition2 = string
                            condition2 = condition2.sub
                            dataTable5 = numValue2
                            dataTable6 = 1
                            counter = 11
                            condition2 = condition2(dataTable5, dataTable6, counter)
                            strValue = condition2
                            numValue = "youtube"
                        else
                            numValue2 = string
                            numValue2 = numValue2.find
                            condition2 = A1_2
                            dataTable5 = "^www.youtu.be"
                            numValue2 = numValue2(condition2, dataTable5)
                            if numValue2 then
                                numValue2 = string
                                numValue2 = numValue2.sub
                                condition2 = A1_2
                                dataTable5 = 14
                                numValue2 = numValue2(condition2, dataTable5)
                                condition2 = string
                                condition2 = condition2.sub
                                dataTable5 = numValue2
                                dataTable6 = 1
                                counter = 11
                                condition2 = condition2(dataTable5, dataTable6, counter)
                                strValue = condition2
                                numValue = "youtube"
                            else
                                numValue2 = string
                                numValue2 = numValue2.find
                                condition2 = A1_2
                                dataTable5 = "^youtu.be"
                                numValue2 = numValue2(condition2, dataTable5)
                                if numValue2 then
                                    numValue2 = string
                                    numValue2 = numValue2.sub
                                    condition2 = A1_2
                                    dataTable5 = 10
                                    numValue2 = numValue2(condition2, dataTable5)
                                    condition2 = string
                                    condition2 = condition2.sub
                                    dataTable5 = numValue2
                                    dataTable6 = 1
                                    counter = 11
                                    condition2 = condition2(dataTable5, dataTable6, counter)
                                    strValue = condition2
                                    numValue = "youtube"
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    entityCoords.started = true
    entityCoords.musicurl = strValue
end
CreateSoundAttraction = dataTable2
dataTable2 = Citizen
dataTable2 = dataTable2.CreateThread

function isDisabled()
    local isEnabled2, isEnabled, entityCoords, strValue, numValue, numValue2, condition2, dataTable5, dataTable6, counter, var22, condition4, counter3, condition5, condition3, func, dataTable3, condition
    while true do
        isEnabled2 = Citizen
        isEnabled2 = isEnabled2.Wait
        isEnabled = 1000
        isEnabled2(isEnabled)
        isEnabled2 = nearbythemepark
        if isEnabled2 then
            isEnabled2 = counter2
            if isEnabled2 > 0 then
                isEnabled2 = pairs
                isEnabled = dataTable
                isEnabled2, isEnabled, entityCoords, strValue = isEnabled2(isEnabled)
                for numValue, numValue2 in isEnabled2, isEnabled, entityCoords, strValue do
                    condition2 = numValue2.started
                    if true == condition2 then
                        condition2 = Config
                        condition2 = condition2.AttractionsMusic
                        condition2 = condition2[numValue]
                        dataTable5 = condition2.coords
                        dataTable6 = playercurrentcoords
                        dataTable6 = dataTable6 - dataTable5
                        dataTable6 = #dataTable6
                        counter = condition2.musicvolume
                        var22 = condition2.musicvolume
                        var22 = var22 / 100
                        var22 = var22 * 1.0
                        condition4 = condition2.maxdistance
                        condition4 = dataTable6 / condition4
                        counter3 = condition4 * 100
                        condition5 = 100
                        condition5 = condition5 - counter3
                        condition3 = condition2.musicvolume
                        condition3 = condition3 / 100
                        condition3 = condition3 * condition5
                        if condition3 > 0 then
                            func = math
                            func = func.floor
                            dataTable3 = condition3
                            func = func(dataTable3)
                            counter = func
                        else
                            counter = 0
                        end
                        func = condition2.maxdistance
                        if condition4 > func then
                            func = SendNUIMessage
                            dataTable3 = {}
                            dataTable3.message = "playsoundattraction"
                            dataTable3.soundid = numValue
                            condition = numValue2.musicurl
                            dataTable3.soundsrc = condition
                            dataTable3.soundvolume = 0.0
                            func(dataTable3)
                        else
                            func = streamermodeactivated
                            if true == func then
                                func = SendNUIMessage
                                dataTable3 = {}
                                dataTable3.message = "playsoundattraction"
                                dataTable3.soundid = numValue
                                condition = numValue2.musicurl
                                dataTable3.soundsrc = condition
                                dataTable3.soundvolume = 0.0
                                func(dataTable3)
                            else
                                func = SendNUIMessage
                                dataTable3 = {}
                                dataTable3.message = "playsoundattraction"
                                dataTable3.soundid = numValue
                                condition = numValue2.musicurl
                                dataTable3.soundsrc = condition
                                dataTable3.soundvolume = counter
                                func(dataTable3)
                            end
                        end
                    else
                        condition2 = SendNUIMessage
                        dataTable5 = {}
                        dataTable5.message = "playsoundattraction"
                        dataTable5.soundid = numValue
                        dataTable6 = numValue2.musicurl
                        dataTable5.soundsrc = dataTable6
                        dataTable5.soundvolume = 0.0
                        condition2(dataTable5)
                    end
                end
            end
        end
    end
end
dataTable2(isDisabled)
dataTable2 = RegisterNetEvent
isDisabled = "rtx_themepark:Global:MusicStartAttraction"
dataTable2(isDisabled)
dataTable2 = AddEventHandler
isDisabled = "rtx_themepark:Global:MusicStartAttraction"

function func2(A0_2, A1_2)
    local entityCoords, strValue, numValue, numValue2
    entityCoords = Config
    entityCoords = entityCoords.AttractionsMusic
    entityCoords = entityCoords[A0_2]
    entityCoords = entityCoords.playlist
    entityCoords = entityCoords[A1_2]
    entityCoords = entityCoords.musicurl
    strValue = Config
    strValue = strValue.AttractionsMusic
    strValue = strValue[A0_2]
    strValue = strValue.disable
    if false == strValue then
        strValue = CreateSoundAttraction
        numValue = A0_2
        numValue2 = entityCoords
        strValue(numValue, numValue2)
        strValue = counter2
        strValue = strValue + 1
        counter2 = strValue
    end
end
dataTable2(isDisabled, func2)
dataTable2 = RegisterNetEvent
isDisabled = "rtx_themepark:Global:MusicStopAttraction"
dataTable2(isDisabled)
dataTable2 = AddEventHandler
isDisabled = "rtx_themepark:Global:MusicStopAttraction"

function func2(A0_2)
    local isEnabled, entityCoords, strValue
    isEnabled = dataTable
    isEnabled = isEnabled[A0_2]
    entityCoords = Config
    entityCoords = entityCoords.AttractionsMusic
    entityCoords = entityCoords[A0_2]
    entityCoords = entityCoords.disable
    if false == entityCoords then
        isEnabled.started = false
        entityCoords = SendNUIMessage
        strValue = {}
        strValue.message = "stopsoundattraction"
        strValue.soundid = A0_2
        entityCoords(strValue)
        entityCoords = counter2
        entityCoords = entityCoords - 1
        counter2 = entityCoords
    end
end
dataTable2(isDisabled, func2)