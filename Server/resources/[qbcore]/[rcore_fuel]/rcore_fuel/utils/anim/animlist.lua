--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

AnimationList = {
    cop2 = {
        "anim@amb@nightclub@peds@",
        "rcmme_amanda1_stand_loop_cop",
        AnimationOptions = {
            EmoteLoop = true,
        },
    },
    notepad2 = {
        "Scenario",
        "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
        "Notepad 2",
    },
    clean2 = {
        "amb@world_human_maid_clean@",
        "base",
        "Clean 2",
        AnimationOptions = {
            PropBone = 28422,
            PropPlacement = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 },
            EmoteMoving = true,
            Prop = "prop_sponge_01",
            EmoteLoop = true,
        },
    },
    jerrycan = {
        "weapon@w_sp_jerrycan",
        "fire",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
        },
    },
    nozzle_return = {
        "mp_common",
        "givetake1_a",
        AnimationOptions = {
            EmoteDuration = 1800,
        },
    },
    type2 = {
        "anim@heists@prison_heistig1_p1_guard_checks_bus",
        "loop",
        "Type 2",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true,
        },
    },
    type = {
        "anim@heists@prison_heiststation@cop_reactions",
        "cop_b_idle",
        "Type",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true,
        },
    },
    phone = {
        "cellphone@",
        "cellphone_text_read_base",
        "Phone",
        AnimationOptions = {
            PropBone = 28422,
            PropPlacement = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },
            EmoteMoving = true,
            Prop = "prop_npc_phone_02",
            EmoteLoop = true,
        },
    },
    boi = {
        "special_ped@jane@monologue_5@monologue_5c",
        "brotheradrianhasshown_2",
        "BOI",
        AnimationOptions = {
            EmoteDuration = 3000,
            EmoteMoving = true,
        },
    },
    namaste = {
        "timetable@amanda@ig_4",
        "ig_4_base",
        "Namaste",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true,
        },
    },
    comeatmebro = {
        "mini@triathlon",
        "want_some_of_this",
        "Come at me bro",
        AnimationOptions = {
            EmoteDuration = 2000,
            EmoteMoving = true,
        },
    },
    mechanic = {
        "mini@repair",
        "fixing_a_ped",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true,
        },
    },
    notepad = {
        "missheistdockssetup1clipboard@base",
        "base",
        AnimationOptions = {
            PropBone = 18905,
            SecondPropPlacement = { 0.11, -0.02, 0.001, -120.0, 0.0, 0.0 },
            EmoteMoving = true,
            EmoteLoop = true,
            PropPlacement = { 0.1, 0.02, 0.05, 10.0, 0.0, 0.0 },
            SecondProp = "prop_pencil_01",
            Prop = "prop_notepad_01",
            SecondPropBone = 58866,
        },
    },
    pickup = {
        "random@domestic",
        "pickup_low",
        "Pickup",
    },
    hold = {
        "anim@heists@box_carry@",
        "idle",
        "hold",
        AnimationOptions = {
            EmoteMoving = true,
            EmoteLoop = true,
        },
    },
    fueling = {
        "timetable@gardener@filling_can",
        "gar_ig_5_filling_can",
        AnimationOptions = {
            EmoteMoving = false,
            EmoteLoop = true,
        },
    },
}
