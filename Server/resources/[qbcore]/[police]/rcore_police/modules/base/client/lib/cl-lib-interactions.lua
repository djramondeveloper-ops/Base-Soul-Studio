-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-interactions.lua
--  Engineered by Eazy Fxap
--  Original: 35 lines → Cleaned: 20 lines
-- =====================================================

Interactions = {
    Entity = nil,
    FrontEntity = nil,
    MegaPhone = {
        state = false
    },
    PaperBag = {
        state = false
    },
    Escort = {
        TARGET_PLAYER_ESCORT_INITIATOR_STATE = false,
        TARGET_PLAYER_ESCORT_CITIZEN_STATE = false
    },
    Cuff = {
        TARGET_PLAYER_CUFF_STATE = false,
        TARGET_PLAYER_ANIM_DICT = "anim@move_m@prisoner_cuffed",
        TARGET_PLAYER_ANIM_DICT_NAME = "idle",
        TARGET_PLAYER_MODEL = "p_cs_cuffs_02_s",
        TARGET_PLAYER_BEING_CUFFED_ANIM_DICT = "mp_arrest_paired",
        TARGET_PLAYER_BEING_CUFFED_ANIM_DICT_NAME = "crook_p3"
    }
}
