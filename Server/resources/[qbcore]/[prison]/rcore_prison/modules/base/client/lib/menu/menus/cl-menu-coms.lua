local comsMenuId = MENU_ID_LIST.COMS_MENU

function OpenStartCOMS(_)
    DestroyAllMenus()

    local comsUser = COMSService.GetUser()
    local rows = {
        {
            header = _U("COMS_MENU.TITLE"),
            isMenuHeader = true
        }
    }

    if comsUser and next(comsUser) then
        if comsUser.state == "RETURN" then
            rows[#rows + 1] = {
                header = _U("COMS_MENU.REPORT_MISSION_TITLE"),
                description = _U("COMS_MENU.REPORT_MISSION_DESC"),
                order = #rows + 1,
                type = "button",
                params = {
                    isServer = true,
                    event = "rcore_prison:server:requestFinishPeroll"
                }
            }
        elseif comsUser.state == "IDLE" then
            rows[#rows + 1] = {
                header = _U("COMS_MENU.START_MISSION_TITLE"),
                description = _U("COMS_MENU.START_MISSION_DESC"),
                order = #rows + 1,
                type = "button",
                params = {
                    isServer = true,
                    event = "rcore_prison:server:requestComs"
                }
            }
        else
            dbg.menu("COMS is not in return state [%s]", comsUser.state)
            return
        end
    else
        rows[#rows + 1] = {
            header = _U("COMS_MENU.START_MISSION_TITLE"),
            description = _U("COMS_MENU.START_MISSION_DESC"),
            order = #rows + 1,
            type = "button",
            params = {
                isServer = true,
                event = "rcore_prison:server:requestComs"
            }
        }
    end

    Frontend:CreateMenu(
        comsMenuId,
        _U("COMS_MENU.TITLE"),
        rows,
        true
    )
end