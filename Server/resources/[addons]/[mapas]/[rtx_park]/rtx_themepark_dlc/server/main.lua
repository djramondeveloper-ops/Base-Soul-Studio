
local dataTable3, dataTable15, dataTable16, dataTable23, dataTable18, dataTable4, dataTable19, dataTable12, dataTable14, dataTable10, dataTable6, dataTable11, dataTable24, dataTable17, dataTable2, dataTable9, dataTable7, dataTable22, dataTable13, dataTable20, var1
attractionlockdown = false
ESX = nil
QBCore = nil
dataTable3 = {}
playsersinthemepark = dataTable3
dataTable3 = {}
playerusingattraction = dataTable3
themeparkdisabled = false
dataTable3 = {}
dataTable3.owned = false
dataTable3.identifier = ""
dataTable3.balance = 0
dataTable3.parkid = 1
themeparkowned = dataTable3
dataTable3 = {}
dataTable3[1] = true
dataTable3[2] = true
dataTable3[3] = true
dataTable3[4] = true
dataTable3[5] = true
dataTable3[6] = true
dataTable3[7] = true
dataTable3[8] = true
dataTable3[9] = true
dataTable3[10] = true
dataTable3[11] = true
dataTable3[12] = true
dataTable3[13] = true
dataTable3[13] = true
dataTable3[14] = true
dataTable3[15] = true
dataTable3[16] = true
dataTable3[17] = true
dataTable3[18] = true
dataTable3[19] = true
themeparkattractionsopenstatus = dataTable3
dataTable3 = {}
dataTable15 = {}
dataTable16 = Config
dataTable16 = dataTable16.AttractionsSettings
dataTable16 = dataTable16.gforce
dataTable16 = dataTable16.ticketprice
dataTable15.ticketprice = dataTable16
dataTable15.attractionid = 1
dataTable15.tickettype = 1
dataTable16 = Config
dataTable16 = dataTable16.AttractionsSettings
dataTable16 = dataTable16.gforce
dataTable16 = dataTable16.disable
dataTable15.disabled = dataTable16
dataTable16 = {}
dataTable23 = Config
dataTable23 = dataTable23.AttractionsSettings
dataTable23 = dataTable23.topscan
dataTable23 = dataTable23.ticketprice
dataTable16.ticketprice = dataTable23
dataTable16.attractionid = 2
dataTable16.tickettype = 2
dataTable23 = Config
dataTable23 = dataTable23.AttractionsSettings
dataTable23 = dataTable23.topscan
dataTable23 = dataTable23.disable
dataTable16.disabled = dataTable23
dataTable23 = {}
dataTable18 = Config
dataTable18 = dataTable18.AttractionsSettings
dataTable18 = dataTable18.rollercoaster
dataTable18 = dataTable18.ticketprice
dataTable23.ticketprice = dataTable18
dataTable23.attractionid = 3
dataTable23.tickettype = 7
dataTable18 = Config
dataTable18 = dataTable18.AttractionsSettings
dataTable18 = dataTable18.rollercoaster
dataTable18 = dataTable18.disable
dataTable23.disabled = dataTable18
dataTable18 = {}
dataTable4 = Config
dataTable4 = dataTable4.AttractionsSettings
dataTable4 = dataTable4.shootingrange
dataTable4 = dataTable4.ticketprice
dataTable18.ticketprice = dataTable4
dataTable18.attractionid = 5
dataTable18.tickettype = 8
dataTable4 = Config
dataTable4 = dataTable4.AttractionsSettings
dataTable4 = dataTable4.shootingrange
dataTable4 = dataTable4.disable
dataTable18.disabled = dataTable4
dataTable4 = {}
dataTable19 = Config
dataTable19 = dataTable19.AttractionsSettings
dataTable19 = dataTable19.shootingrange
dataTable19 = dataTable19.ticketprice
dataTable4.ticketprice = dataTable19
dataTable4.attractionid = 5
dataTable4.tickettype = 8
dataTable19 = Config
dataTable19 = dataTable19.AttractionsSettings
dataTable19 = dataTable19.shootingrange
dataTable19 = dataTable19.disable
dataTable4.disabled = dataTable19
dataTable19 = {}
dataTable12 = Config
dataTable12 = dataTable12.AttractionsSettings
dataTable12 = dataTable12.shootingrange
dataTable12 = dataTable12.ticketprice
dataTable19.ticketprice = dataTable12
dataTable19.attractionid = 5
dataTable19.tickettype = 8
dataTable12 = Config
dataTable12 = dataTable12.AttractionsSettings
dataTable12 = dataTable12.shootingrange
dataTable12 = dataTable12.disable
dataTable19.disabled = dataTable12
dataTable12 = {}
dataTable14 = Config
dataTable14 = dataTable14.AttractionsSettings
dataTable14 = dataTable14.vortex
dataTable14 = dataTable14.ticketprice
dataTable12.ticketprice = dataTable14
dataTable12.attractionid = 7
dataTable12.tickettype = 3
dataTable14 = Config
dataTable14 = dataTable14.AttractionsSettings
dataTable14 = dataTable14.vortex
dataTable14 = dataTable14.disable
dataTable12.disabled = dataTable14
dataTable14 = {}
dataTable10 = Config
dataTable10 = dataTable10.AttractionsSettings
dataTable10 = dataTable10.ferris
dataTable10 = dataTable10.ticketprice
dataTable14.ticketprice = dataTable10
dataTable14.attractionid = 8
dataTable14.tickettype = 6
dataTable10 = Config
dataTable10 = dataTable10.AttractionsSettings
dataTable10 = dataTable10.ferris
dataTable10 = dataTable10.disable
dataTable14.disabled = dataTable10
dataTable10 = {}
dataTable6 = Config
dataTable6 = dataTable6.AttractionsSettings
dataTable6 = dataTable6.detonator
dataTable6 = dataTable6.ticketprice
dataTable10.ticketprice = dataTable6
dataTable10.attractionid = 9
dataTable10.tickettype = 4
dataTable6 = Config
dataTable6 = dataTable6.AttractionsSettings
dataTable6 = dataTable6.detonator
dataTable6 = dataTable6.disable
dataTable10.disabled = dataTable6
dataTable6 = {}
dataTable11 = Config
dataTable11 = dataTable11.AttractionsSettings
dataTable11 = dataTable11.boat
dataTable11 = dataTable11.ticketprice
dataTable6.ticketprice = dataTable11
dataTable6.attractionid = 10
dataTable6.tickettype = 5
dataTable11 = Config
dataTable11 = dataTable11.AttractionsSettings
dataTable11 = dataTable11.boat
dataTable11 = dataTable11.disable
dataTable6.disabled = dataTable11
dataTable11 = {}
dataTable24 = Config
dataTable24 = dataTable24.AttractionsSettings
dataTable24 = dataTable24.prater
dataTable24 = dataTable24.ticketprice
dataTable11.ticketprice = dataTable24
dataTable11.attractionid = 11
dataTable11.tickettype = 10
dataTable24 = Config
dataTable24 = dataTable24.AttractionsSettings
dataTable24 = dataTable24.prater
dataTable24 = dataTable24.disable
dataTable11.disabled = dataTable24
dataTable24 = {}
dataTable17 = Config
dataTable17 = dataTable17.AttractionsSettings
dataTable17 = dataTable17.brakedance
dataTable17 = dataTable17.ticketprice
dataTable24.ticketprice = dataTable17
dataTable24.attractionid = 12
dataTable24.tickettype = 11
dataTable17 = Config
dataTable17 = dataTable17.AttractionsSettings
dataTable17 = dataTable17.brakedance
dataTable17 = dataTable17.disable
dataTable24.disabled = dataTable17
dataTable17 = {}
dataTable2 = Config
dataTable2 = dataTable2.AttractionsSettings
dataTable2 = dataTable2.slingshot
dataTable2 = dataTable2.ticketprice
dataTable17.ticketprice = dataTable2
dataTable17.attractionid = 13
dataTable17.tickettype = 12
dataTable2 = Config
dataTable2 = dataTable2.AttractionsSettings
dataTable2 = dataTable2.slingshot
dataTable2 = dataTable2.disable
dataTable17.disabled = dataTable2
dataTable2 = {}
dataTable9 = Config
dataTable9 = dataTable9.AttractionsSettings
dataTable9 = dataTable9.carousel
dataTable9 = dataTable9.ticketprice
dataTable2.ticketprice = dataTable9
dataTable2.attractionid = 14
dataTable2.tickettype = 13
dataTable9 = Config
dataTable9 = dataTable9.AttractionsSettings
dataTable9 = dataTable9.carousel
dataTable9 = dataTable9.disable
dataTable2.disabled = dataTable9
dataTable9 = {}
dataTable7 = Config
dataTable7 = dataTable7.AttractionsSettings
dataTable7 = dataTable7.extasy
dataTable7 = dataTable7.ticketprice
dataTable9.ticketprice = dataTable7
dataTable9.attractionid = 15
dataTable9.tickettype = 14
dataTable7 = Config
dataTable7 = dataTable7.AttractionsSettings
dataTable7 = dataTable7.extasy
dataTable7 = dataTable7.disable
dataTable9.disabled = dataTable7
dataTable7 = {}
dataTable22 = Config
dataTable22 = dataTable22.AttractionsSettings
dataTable22 = dataTable22.spinride
dataTable22 = dataTable22.ticketprice
dataTable7.ticketprice = dataTable22
dataTable7.attractionid = 16
dataTable7.tickettype = 15
dataTable22 = Config
dataTable22 = dataTable22.AttractionsSettings
dataTable22 = dataTable22.spinride
dataTable22 = dataTable22.disable
dataTable7.disabled = dataTable22
dataTable22 = {}
dataTable13 = Config
dataTable13 = dataTable13.AttractionsSettings
dataTable13 = dataTable13.hauntedhouse
dataTable13 = dataTable13.ticketprice
dataTable22.ticketprice = dataTable13
dataTable22.attractionid = 17
dataTable22.tickettype = 16
dataTable13 = Config
dataTable13 = dataTable13.AttractionsSettings
dataTable13 = dataTable13.hauntedhouse
dataTable13 = dataTable13.disable
dataTable22.disabled = dataTable13
dataTable13 = {}
dataTable20 = Config
dataTable20 = dataTable20.AttractionsSettings
dataTable20 = dataTable20.rollercoaster2
dataTable20 = dataTable20.ticketprice
dataTable13.ticketprice = dataTable20
dataTable13.attractionid = 18
dataTable13.tickettype = 17
dataTable20 = Config
dataTable20 = dataTable20.AttractionsSettings
dataTable20 = dataTable20.rollercoaster2
dataTable20 = dataTable20.disable
dataTable13.disabled = dataTable20
dataTable20 = {}
var1 = Config
var1 = var1.AttractionsSettings
var1 = var1.cannon
var1 = var1.ticketprice
dataTable20.ticketprice = var1
dataTable20.attractionid = 19
dataTable20.tickettype = 18
var1 = Config
var1 = var1.AttractionsSettings
var1 = var1.cannon
var1 = var1.disable
dataTable20.disabled = var1
dataTable3[1] = dataTable15
dataTable3[2] = dataTable16
dataTable3[3] = dataTable23
dataTable3[4] = dataTable18
dataTable3[5] = dataTable4
dataTable3[6] = dataTable19
dataTable3[7] = dataTable12
dataTable3[8] = dataTable14
dataTable3[9] = dataTable10
dataTable3[10] = dataTable6
dataTable3[11] = dataTable11
dataTable3[12] = dataTable24
dataTable3[13] = dataTable17
dataTable3[14] = dataTable2
dataTable3[15] = dataTable9
dataTable3[16] = dataTable7
dataTable3[17] = dataTable22
dataTable3[18] = dataTable13
dataTable3[19] = dataTable20
ticketmachines = dataTable3
dataTable3 = {}
dataTable15 = {}
dataTable16 = Config
dataTable16 = dataTable16.ThemeParkControlMachineSettings
dataTable16 = dataTable16.attractions
dataTable16 = dataTable16.vortex
dataTable16 = dataTable16.label
dataTable15.label = dataTable16
dataTable15.smokeactivated = false
dataTable16 = Config
dataTable16 = dataTable16.ThemeParkControlMachineSettings
dataTable16 = dataTable16.attractions
dataTable16 = dataTable16.vortex
dataTable16 = dataTable16.disablesmoke
dataTable15.smokedisabled = dataTable16
dataTable15.turndisabled = false
dataTable16 = Config
dataTable16 = dataTable16.ThemeParkControlMachineSettings
dataTable16 = dataTable16.attractions
dataTable16 = dataTable16.vortex
dataTable16 = dataTable16.disablemusic
dataTable15.musicdisabled = dataTable16
dataTable15.music = false
dataTable15.musicurl = ""
dataTable15.musicvolume = 100
dataTable16 = Config
dataTable16 = dataTable16.ThemeParkControlMachineSettings
dataTable16 = dataTable16.attractions
dataTable16 = dataTable16.vortex
dataTable16 = dataTable16.smokecolor
dataTable15.smokecolor = dataTable16
dataTable16 = {}
dataTable23 = Config
dataTable23 = dataTable23.ThemeParkControlMachineSettings
dataTable23 = dataTable23.attractions
dataTable23 = dataTable23.vortex
dataTable23 = dataTable23.smokelocations
dataTable16[1] = dataTable23
dataTable15.smokelocations = dataTable16
dataTable15.taken = false
dataTable15.takenplayerid = nil
dataTable16 = {}
dataTable23 = Config
dataTable23 = dataTable23.ThemeParkControlMachineSettings
dataTable23 = dataTable23.attractions
dataTable23 = dataTable23.bumpercars
dataTable23 = dataTable23.label
dataTable16.label = dataTable23
dataTable16.smokeactivated = false
dataTable23 = Config
dataTable23 = dataTable23.ThemeParkControlMachineSettings
dataTable23 = dataTable23.attractions
dataTable23 = dataTable23.bumpercars
dataTable23 = dataTable23.disablesmoke
dataTable16.smokedisabled = dataTable23
dataTable16.turndisabled = true
dataTable23 = Config
dataTable23 = dataTable23.ThemeParkControlMachineSettings
dataTable23 = dataTable23.attractions
dataTable23 = dataTable23.bumpercars
dataTable23 = dataTable23.disablemusic
dataTable16.musicdisabled = dataTable23
dataTable16.music = false
dataTable16.musicurl = ""
dataTable16.musicvolume = 100
dataTable23 = Config
dataTable23 = dataTable23.ThemeParkControlMachineSettings
dataTable23 = dataTable23.attractions
dataTable23 = dataTable23.bumpercars
dataTable23 = dataTable23.smokecolor
dataTable16.smokecolor = dataTable23
dataTable23 = {}
dataTable18 = Config
dataTable18 = dataTable18.ThemeParkControlMachineSettings
dataTable18 = dataTable18.attractions
dataTable18 = dataTable18.bumpercars
dataTable18 = dataTable18.smokelocations
dataTable23[1] = dataTable18
dataTable16.smokelocations = dataTable23
dataTable16.taken = false
dataTable16.takenplayerid = nil
dataTable23 = {}
dataTable18 = Config
dataTable18 = dataTable18.ThemeParkControlMachineSettings
dataTable18 = dataTable18.attractions
dataTable18 = dataTable18.boat
dataTable18 = dataTable18.label
dataTable23.label = dataTable18
dataTable23.smokeactivated = false
dataTable18 = Config
dataTable18 = dataTable18.ThemeParkControlMachineSettings
dataTable18 = dataTable18.attractions
dataTable18 = dataTable18.boat
dataTable18 = dataTable18.disablesmoke
dataTable23.smokedisabled = dataTable18
dataTable23.turndisabled = false
dataTable18 = Config
dataTable18 = dataTable18.ThemeParkControlMachineSettings
dataTable18 = dataTable18.attractions
dataTable18 = dataTable18.boat
dataTable18 = dataTable18.disablemusic
dataTable23.musicdisabled = dataTable18
dataTable23.music = false
dataTable23.musicurl = ""
dataTable23.musicvolume = 100
dataTable18 = Config
dataTable18 = dataTable18.ThemeParkControlMachineSettings
dataTable18 = dataTable18.attractions
dataTable18 = dataTable18.boat
dataTable18 = dataTable18.smokecolor
dataTable23.smokecolor = dataTable18
dataTable23.taken = false
dataTable23.takenplayerid = nil
dataTable18 = {}
dataTable4 = Config
dataTable4 = dataTable4.ThemeParkControlMachineSettings
dataTable4 = dataTable4.attractions
dataTable4 = dataTable4.rollercoaster
dataTable4 = dataTable4.label
dataTable18.label = dataTable4
dataTable18.smokedisabled = true
dataTable18.turndisabled = false
dataTable4 = Config
dataTable4 = dataTable4.ThemeParkControlMachineSettings
dataTable4 = dataTable4.attractions
dataTable4 = dataTable4.rollercoaster
dataTable4 = dataTable4.disablemusic
dataTable18.musicdisabled = dataTable4
dataTable18.music = false
dataTable18.musicurl = ""
dataTable18.musicvolume = 100
dataTable18.taken = false
dataTable18.takenplayerid = nil
dataTable4 = {}
dataTable19 = Config
dataTable19 = dataTable19.ThemeParkControlMachineSettings
dataTable19 = dataTable19.attractions
dataTable19 = dataTable19.detonator
dataTable19 = dataTable19.label
dataTable4.label = dataTable19
dataTable4.smokedisabled = true
dataTable4.turndisabled = false
dataTable19 = Config
dataTable19 = dataTable19.ThemeParkControlMachineSettings
dataTable19 = dataTable19.attractions
dataTable19 = dataTable19.detonator
dataTable19 = dataTable19.disablemusic
dataTable4.musicdisabled = dataTable19
dataTable4.music = false
dataTable4.musicurl = ""
dataTable4.musicvolume = 100
dataTable4.taken = false
dataTable4.takenplayerid = nil
dataTable19 = {}
dataTable12 = Config
dataTable12 = dataTable12.ThemeParkControlMachineSettings
dataTable12 = dataTable12.attractions
dataTable12 = dataTable12.gforce
dataTable12 = dataTable12.label
dataTable19.label = dataTable12
dataTable19.smokedisabled = true
dataTable19.turndisabled = false
dataTable12 = Config
dataTable12 = dataTable12.ThemeParkControlMachineSettings
dataTable12 = dataTable12.attractions
dataTable12 = dataTable12.gforce
dataTable12 = dataTable12.disablemusic
dataTable19.musicdisabled = dataTable12
dataTable19.music = false
dataTable19.musicurl = ""
dataTable19.musicvolume = 100
dataTable19.taken = false
dataTable19.takenplayerid = nil
dataTable12 = {}
dataTable14 = Config
dataTable14 = dataTable14.ThemeParkControlMachineSettings
dataTable14 = dataTable14.attractions
dataTable14 = dataTable14.topscan
dataTable14 = dataTable14.label
dataTable12.label = dataTable14
dataTable12.smokedisabled = true
dataTable12.turndisabled = false
dataTable14 = Config
dataTable14 = dataTable14.ThemeParkControlMachineSettings
dataTable14 = dataTable14.attractions
dataTable14 = dataTable14.topscan
dataTable14 = dataTable14.disablemusic
dataTable12.musicdisabled = dataTable14
dataTable12.music = false
dataTable12.musicurl = ""
dataTable12.musicvolume = 100
dataTable12.taken = false
dataTable12.takenplayerid = nil
dataTable14 = {}
dataTable10 = Config
dataTable10 = dataTable10.ThemeParkControlMachineSettings
dataTable10 = dataTable10.attractions
dataTable10 = dataTable10.ferris
dataTable10 = dataTable10.label
dataTable14.label = dataTable10
dataTable14.smokedisabled = true
dataTable14.turndisabled = false
dataTable10 = Config
dataTable10 = dataTable10.ThemeParkControlMachineSettings
dataTable10 = dataTable10.attractions
dataTable10 = dataTable10.ferris
dataTable10 = dataTable10.disablemusic
dataTable14.musicdisabled = dataTable10
dataTable14.music = false
dataTable14.musicurl = ""
dataTable14.musicvolume = 100
dataTable14.taken = false
dataTable14.takenplayerid = nil
dataTable10 = {}
dataTable6 = Config
dataTable6 = dataTable6.ThemeParkControlMachineSettings
dataTable6 = dataTable6.attractions
dataTable6 = dataTable6.prater
dataTable6 = dataTable6.label
dataTable10.label = dataTable6
dataTable10.smokedisabled = true
dataTable10.turndisabled = false
dataTable6 = Config
dataTable6 = dataTable6.ThemeParkControlMachineSettings
dataTable6 = dataTable6.attractions
dataTable6 = dataTable6.prater
dataTable6 = dataTable6.disablemusic
dataTable10.musicdisabled = dataTable6
dataTable10.music = false
dataTable10.musicurl = ""
dataTable10.musicvolume = 100
dataTable10.taken = false
dataTable10.takenplayerid = nil
dataTable6 = {}
dataTable11 = Config
dataTable11 = dataTable11.ThemeParkControlMachineSettings
dataTable11 = dataTable11.attractions
dataTable11 = dataTable11.brakedance
dataTable11 = dataTable11.label
dataTable6.label = dataTable11
dataTable6.smokedisabled = true
dataTable6.turndisabled = false
dataTable11 = Config
dataTable11 = dataTable11.ThemeParkControlMachineSettings
dataTable11 = dataTable11.attractions
dataTable11 = dataTable11.brakedance
dataTable11 = dataTable11.disablemusic
dataTable6.musicdisabled = dataTable11
dataTable6.music = false
dataTable6.musicurl = ""
dataTable6.musicvolume = 100
dataTable6.taken = false
dataTable6.takenplayerid = nil
dataTable11 = {}
dataTable24 = Config
dataTable24 = dataTable24.ThemeParkControlMachineSettings
dataTable24 = dataTable24.attractions
dataTable24 = dataTable24.slingshot
dataTable24 = dataTable24.label
dataTable11.label = dataTable24
dataTable11.smokedisabled = true
dataTable11.turndisabled = false
dataTable24 = Config
dataTable24 = dataTable24.ThemeParkControlMachineSettings
dataTable24 = dataTable24.attractions
dataTable24 = dataTable24.slingshot
dataTable24 = dataTable24.disablemusic
dataTable11.musicdisabled = dataTable24
dataTable11.music = false
dataTable11.musicurl = ""
dataTable11.musicvolume = 100
dataTable11.taken = false
dataTable11.takenplayerid = nil
dataTable24 = {}
dataTable17 = Config
dataTable17 = dataTable17.ThemeParkControlMachineSettings
dataTable17 = dataTable17.attractions
dataTable17 = dataTable17.carousel
dataTable17 = dataTable17.label
dataTable24.label = dataTable17
dataTable24.smokedisabled = true
dataTable24.turndisabled = false
dataTable17 = Config
dataTable17 = dataTable17.ThemeParkControlMachineSettings
dataTable17 = dataTable17.attractions
dataTable17 = dataTable17.carousel
dataTable17 = dataTable17.disablemusic
dataTable24.musicdisabled = dataTable17
dataTable24.music = false
dataTable24.musicurl = ""
dataTable24.musicvolume = 100
dataTable24.taken = false
dataTable24.takenplayerid = nil
dataTable17 = {}
dataTable2 = Config
dataTable2 = dataTable2.ThemeParkControlMachineSettings
dataTable2 = dataTable2.attractions
dataTable2 = dataTable2.extasy
dataTable2 = dataTable2.label
dataTable17.label = dataTable2
dataTable17.smokedisabled = true
dataTable17.turndisabled = false
dataTable2 = Config
dataTable2 = dataTable2.ThemeParkControlMachineSettings
dataTable2 = dataTable2.attractions
dataTable2 = dataTable2.extasy
dataTable2 = dataTable2.disablemusic
dataTable17.musicdisabled = dataTable2
dataTable17.music = false
dataTable17.musicurl = ""
dataTable17.musicvolume = 100
dataTable17.taken = false
dataTable17.takenplayerid = nil
dataTable2 = {}
dataTable9 = Config
dataTable9 = dataTable9.ThemeParkControlMachineSettings
dataTable9 = dataTable9.attractions
dataTable9 = dataTable9.spinride
dataTable9 = dataTable9.label
dataTable2.label = dataTable9
dataTable2.smokedisabled = true
dataTable2.turndisabled = false
dataTable9 = Config
dataTable9 = dataTable9.ThemeParkControlMachineSettings
dataTable9 = dataTable9.attractions
dataTable9 = dataTable9.spinride
dataTable9 = dataTable9.disablemusic
dataTable2.musicdisabled = dataTable9
dataTable2.music = false
dataTable2.musicurl = ""
dataTable2.musicvolume = 100
dataTable2.taken = false
dataTable2.takenplayerid = nil
dataTable9 = {}
dataTable7 = Config
dataTable7 = dataTable7.ThemeParkControlMachineSettings
dataTable7 = dataTable7.attractions
dataTable7 = dataTable7.hauntedhouse
dataTable7 = dataTable7.label
dataTable9.label = dataTable7
dataTable9.smokedisabled = true
dataTable9.turndisabled = false
dataTable9.musicdisabled = true
dataTable9.music = false
dataTable9.musicurl = ""
dataTable9.musicvolume = 100
dataTable9.taken = false
dataTable9.takenplayerid = nil
dataTable7 = {}
dataTable22 = Config
dataTable22 = dataTable22.ThemeParkControlMachineSettings
dataTable22 = dataTable22.attractions
dataTable22 = dataTable22.rollercoaster2
dataTable22 = dataTable22.label
dataTable7.label = dataTable22
dataTable7.smokedisabled = true
dataTable7.turndisabled = false
dataTable22 = Config
dataTable22 = dataTable22.ThemeParkControlMachineSettings
dataTable22 = dataTable22.attractions
dataTable22 = dataTable22.rollercoaster2
dataTable22 = dataTable22.disablemusic
dataTable7.musicdisabled = dataTable22
dataTable7.music = false
dataTable7.musicurl = ""
dataTable7.musicvolume = 100
dataTable7.taken = false
dataTable7.takenplayerid = nil
dataTable22 = {}
dataTable13 = Config
dataTable13 = dataTable13.ThemeParkControlMachineSettings
dataTable13 = dataTable13.attractions
dataTable13 = dataTable13.cannon
dataTable13 = dataTable13.label
dataTable22.label = dataTable13
dataTable22.smokedisabled = true
dataTable22.turndisabled = false
dataTable22.musicdisabled = true
dataTable22.music = false
dataTable22.musicurl = ""
dataTable22.musicvolume = 100
dataTable22.taken = false
dataTable22.takenplayerid = nil
dataTable3[1] = dataTable15
dataTable3[2] = dataTable16
dataTable3[3] = dataTable23
dataTable3[4] = dataTable18
dataTable3[5] = dataTable4
dataTable3[6] = dataTable19
dataTable3[7] = dataTable12
dataTable3[8] = dataTable14
dataTable3[9] = dataTable10
dataTable3[10] = dataTable6
dataTable3[11] = dataTable11
dataTable3[12] = dataTable24
dataTable3[13] = dataTable17
dataTable3[14] = dataTable2
dataTable3[15] = dataTable9
dataTable3[16] = dataTable7
dataTable3[17] = dataTable22
controlmachines = dataTable3
dataTable3 = {}
playersiteminhand = dataTable3

function dataTable3(A0_2, ...)
    local strValue5, dataTable21
    strValue5 = string
    strValue5 = strValue5.format
    dataTable21 = Language
    dataTable21 = dataTable21[Config.Language]
    dataTable21 = dataTable21[A0_2]
    return strValue5(dataTable21, ...)
end
LanguageFile2 = dataTable3

function dataTable3(A0_2, ...)
    local strValue5, dataTable21, dataTable, dataTable8, isEnabled9
    strValue5 = tostring
    dataTable21 = LanguageFile2
    dataTable = A0_2
    dataTable8, isEnabled9 = ...
    dataTable21 = dataTable21(dataTable, dataTable8, isEnabled9)
    dataTable = dataTable21
    dataTable21 = dataTable21.gsub
    dataTable8 = "^%l"
    isEnabled9 = string
    isEnabled9 = isEnabled9.upper
    dataTable21, dataTable, dataTable8, isEnabled9 = dataTable21(dataTable, dataTable8, isEnabled9)
    return strValue5(dataTable21, dataTable, dataTable8, isEnabled9)
end
LanguageFile = dataTable3

function dataTable3(A0_2, A1_2)
    local dataTable21, dataTable, dataTable8
    if A1_2 and A1_2 > 0 then
        dataTable21 = 10
        dataTable21 = dataTable21 ^ A1_2
        dataTable = math
        dataTable = dataTable.floor
        dataTable8 = A0_2 * dataTable21
        dataTable8 = dataTable8 + 0.5
        dataTable = dataTable(dataTable8)
        dataTable = dataTable / dataTable21
        return dataTable
    end
    dataTable21 = math
    dataTable21 = dataTable21.floor
    dataTable = A0_2 + 0.5
    return dataTable21(dataTable)
end
round = dataTable3
dataTable3 = Config
dataTable3 = dataTable3.Framework
if "esx" == dataTable3 then
    dataTable3 = Config
    dataTable3 = dataTable3.ESXFramework
    dataTable3 = dataTable3.newversion
    if true == dataTable3 then
        dataTable3 = exports
        dataTable15 = Config
        dataTable15 = dataTable15.ESXFramework
        dataTable15 = dataTable15.resourcename
        dataTable3 = dataTable3[dataTable15]
        dataTable15 = dataTable3
        dataTable3 = dataTable3.getSharedObject
        dataTable3 = dataTable3(dataTable15)
        ESX = dataTable3
    else
        dataTable3 = TriggerEvent
        dataTable15 = Config
        dataTable15 = dataTable15.ESXFramework
        dataTable15 = dataTable15.getsharedobject

        function dataTable16(A0_2)
            local strValue5
            ESX = A0_2
        end
        dataTable3(dataTable15, dataTable16)
    end
end
dataTable3 = Config
dataTable3 = dataTable3.Framework
if "qbcore" == dataTable3 then
    dataTable3 = exports
    dataTable15 = Config
    dataTable15 = dataTable15.QBCoreFrameworkResourceName
    dataTable3 = dataTable3[dataTable15]
    dataTable15 = dataTable3
    dataTable3 = dataTable3.GetCoreObject
    dataTable3 = dataTable3(dataTable15)
    QBCore = dataTable3
end
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:ParkSynchronize"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:ParkSynchronize"

function dataTable16()
    local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9
    index = source
    strValue5 = Config
    strValue5 = strValue5.ThemeParkCanBeOwned
    if strValue5 then
        strValue5 = Config
        strValue5 = strValue5.ThemeParkOwnedSettings
        strValue5 = strValue5.enablepermissionsystem
        if false == strValue5 then
            strValue5 = GetPlayerIdentifierRTX
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            dataTable21 = TriggerClientEvent
            dataTable = "rtx_themepark:Global:ParkOwned"
            dataTable8 = index
            isEnabled9 = themeparkowned
            isEnabled9 = isEnabled9.owned
            dataTable21(dataTable, dataTable8, isEnabled9)
            dataTable21 = themeparkowned
            dataTable21 = dataTable21.owned
            if true == dataTable21 then
                dataTable21 = themeparkowned
                dataTable21 = dataTable21.identifier
                if dataTable21 == strValue5 then
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Global:ParkOwn"
                    dataTable8 = index
                    isEnabled9 = true
                    dataTable21(dataTable, dataTable8, isEnabled9)
                end
            end
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:ParkResync"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:ParkResync"

function dataTable16()
    local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10, strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22
    index = source
    strValue5 = gforcehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:GForce:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:GForce:SeatDown"
        dataTable = -1
        dataTable8 = gforcehandler
        dataTable8 = dataTable8.seatdown
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = gforcehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = TriggerClientEvent
            isEnabled13 = "rtx_themepark:GForce:SynchronizeCageClientResync"
            value = index
            isEnabled6 = isEnabled9
            isEnabled4 = isEnabled3.cageclosed
            isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:GForce:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    strValue2 = value4.seattype
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                end
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:GForce:SynchronizeMovement"
        dataTable = index
        dataTable8 = gforcehandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = gforcehandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = gforcehandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:GForce:SynchronizeMovement"
        dataTable = index
        dataTable8 = gforcehandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = gforcehandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = gforcehandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    end
    strValue5 = topscanhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:TopScan:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = topscanhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:TopScan:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                end
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:TopScan:SynchronizeMovement"
        dataTable = index
        dataTable8 = {}
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation
        dataTable8.rot1 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation2
        dataTable8.rot2 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation3
        dataTable8.rot3 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation4
        dataTable8.rot4 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = topscanhandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:TopScan:SynchronizeMovement"
        dataTable = index
        dataTable8 = {}
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation
        dataTable8.rot1 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation2
        dataTable8.rot2 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation3
        dataTable8.rot3 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.currentrotation4
        dataTable8.rot4 = isEnabled9
        isEnabled9 = topscanhandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = topscanhandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    end
    strValue5 = vortexhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Vortex:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Vortex:SynchronizeCageClientResync"
        dataTable = index
        dataTable8 = vortexhandler
        dataTable8 = dataTable8.cageclosed
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = vortexhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Vortex:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Vortex:SynchronizeMovement"
        dataTable = index
        dataTable8 = vortexhandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = vortexhandler
        isEnabled9 = isEnabled9.currentrotation2
        isEnabled3 = vortexhandler
        isEnabled3 = isEnabled3.stagespeed
        isEnabled8 = vortexhandler
        isEnabled8 = isEnabled8.stagespeed2
        isEnabled13 = vortexhandler
        isEnabled13 = isEnabled13.stage
        value = vortexhandler
        value = value.stagedirection
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Vortex:SynchronizeMovement"
        dataTable = index
        dataTable8 = vortexhandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = vortexhandler
        isEnabled9 = isEnabled9.currentrotation2
        isEnabled3 = vortexhandler
        isEnabled3 = isEnabled3.stagespeed
        isEnabled8 = vortexhandler
        isEnabled8 = isEnabled8.stagespeed2
        isEnabled13 = vortexhandler
        isEnabled13 = isEnabled13.stage
        value = vortexhandler
        value = value.stagedirection
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
    end
    strValue5 = detonatorhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Detonator:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Detonator:SynchronizeCageClientResync"
        dataTable = index
        dataTable8 = detonatorhandler
        dataTable8 = dataTable8.cageclosed
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = detonatorhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Detonator:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Detonator:SynchronizeMovement"
        dataTable = index
        dataTable8 = detonatorhandler
        dataTable8 = dataTable8.currentheight
        isEnabled9 = detonatorhandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = detonatorhandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Detonator:SynchronizeMovement"
        dataTable = index
        dataTable8 = detonatorhandler
        dataTable8 = dataTable8.currentheight
        isEnabled9 = detonatorhandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = detonatorhandler
        isEnabled3 = isEnabled3.stage
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3)
    end
    strValue5 = boathandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Boat:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Boat:SynchronizeCageClientResync"
        dataTable = index
        dataTable8 = boathandler
        dataTable8 = dataTable8.cageclosed
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = boathandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Boat:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled10 = isEnabled3.seattype
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Boat:SynchronizeMovement"
        dataTable = index
        dataTable8 = boathandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = boathandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = boathandler
        isEnabled3 = isEnabled3.stage
        isEnabled8 = boathandler
        isEnabled8 = isEnabled8.stagedirection
        isEnabled13 = false
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Boat:SynchronizeMovement"
        dataTable = index
        dataTable8 = boathandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = boathandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = boathandler
        isEnabled3 = isEnabled3.stage
        isEnabled8 = boathandler
        isEnabled8 = isEnabled8.stagedirection
        isEnabled13 = false
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13)
    end
    strValue5 = ferrishandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Ferris:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = ferrishandler
        dataTable21 = dataTable21.cabins
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.players
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Ferris:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    strValue2 = value4.seattype
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                end
            end
        end
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Ferris:SynchronizeMovement"
        dataTable = index
        dataTable8 = ferrishandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = ferrishandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = true
        isEnabled8 = 0.0
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8)
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Ferris:SynchronizeMovement"
        dataTable = index
        dataTable8 = ferrishandler
        dataTable8 = dataTable8.currentrotation
        isEnabled9 = ferrishandler
        isEnabled9 = isEnabled9.stagespeed
        isEnabled3 = true
        isEnabled8 = 0.0
        strValue5(dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8)
    end
    strValue5 = rollercoasterhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Rollercoaster:SynchronizeStarted"
        dataTable = index
        dataTable8 = true
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = ipairs
        dataTable21 = rollercoasterhandler
        dataTable21 = dataTable21.carts
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.players
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    strValue2 = value4.seattype
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                end
            end
        end
    else
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Rollercoaster:AttractionEnded"
        dataTable = index
        strValue5(dataTable21, dataTable)
    end
    strValue5 = praterhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = praterhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Prater:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Global:AttractionUsing"
                    var25 = value4.takenplayerid
                    isEnabled5 = true
                    isEnabled10(strValue3, var25, isEnabled5)
                end
            end
        end
    end
    strValue5 = brakedancehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = brakedancehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.cabins
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = ipairs
                strValue3 = value4.seats
                isEnabled10, strValue3, var25, isEnabled5 = isEnabled10(strValue3)
                for isEnabled, isEnabled7 in isEnabled10, strValue3, var25, isEnabled5 do
                    condition = isEnabled7.taken
                    if true == condition then
                        condition = TriggerClientEvent
                        strValue2 = "rtx_themepark:BrakeDance:SynchronizeSeat"
                        var23 = index
                        isEnabled11 = isEnabled9
                        var24 = isEnabled4
                        var2 = isEnabled
                        isEnabled12 = true
                        var22 = isEnabled7.takenplayerid
                        condition(strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22)
                        condition = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        var23 = isEnabled7.takenplayerid
                        isEnabled11 = true
                        condition(strValue2, var23, isEnabled11)
                    end
                end
            end
        end
    end
    strValue5 = slingshothandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = slingshothandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:SlingShot:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
        end
    end
    strValue5 = carouselhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = carouselhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Carousel:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = true
                    isEnabled7 = value4.takenplayerid
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7)
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Global:AttractionUsing"
                    var25 = value4.takenplayerid
                    isEnabled5 = true
                    isEnabled10(strValue3, var25, isEnabled5)
                end
            end
        end
    end
    strValue5 = extasyhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = extasyhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.cabins
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = ipairs
                strValue3 = value4.seats
                isEnabled10, strValue3, var25, isEnabled5 = isEnabled10(strValue3)
                for isEnabled, isEnabled7 in isEnabled10, strValue3, var25, isEnabled5 do
                    condition = isEnabled7.taken
                    if true == condition then
                        condition = TriggerClientEvent
                        strValue2 = "rtx_themepark:Extasy:SynchronizeSeat"
                        var23 = index
                        isEnabled11 = isEnabled9
                        var24 = isEnabled4
                        var2 = isEnabled
                        isEnabled12 = true
                        var22 = isEnabled7.takenplayerid
                        condition(strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22)
                        condition = TriggerClientEvent
                        strValue2 = "rtx_themepark:Global:AttractionUsing"
                        var23 = isEnabled7.takenplayerid
                        isEnabled11 = true
                        condition(strValue2, var23, isEnabled11)
                    end
                end
            end
        end
    end
    strValue5 = spinridehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = spinridehandler
        dataTable21 = dataTable21.cabins
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:SpinRide:SynchronizeSeat"
                    var25 = index
                    isEnabled5 = isEnabled9
                    isEnabled = isEnabled4
                    isEnabled7 = true
                    condition = value4.takenplayerid
                    isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                    isEnabled10 = TriggerClientEvent
                    strValue3 = "rtx_themepark:Global:AttractionUsing"
                    var25 = value4.takenplayerid
                    isEnabled5 = true
                    isEnabled10(strValue3, var25, isEnabled5)
                end
            end
        end
    end
    strValue5 = hauntedhousehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = hauntedhousehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
        end
    end
    strValue5 = rollercoasterhandler2
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = rollercoasterhandler2
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = true
                value4 = isEnabled3.takenplayerid
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
        end
    end
    strValue5 = bumperhandler
    strValue5 = strValue5.currentplayers
    if strValue5 > 0 then
        strValue5 = pairs
        dataTable21 = bumperhandler
        dataTable21 = dataTable21.bumperplayers
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = TriggerClientEvent
            isEnabled13 = "rtx_themepark:Bumper:SynchronizeBumper"
            value = index
            isEnabled6 = isEnabled9
            isEnabled4 = isEnabled3.vehiclenetwork
            value4 = isEnabled3.seattaken
            isEnabled10 = isEnabled3.seattakenid
            strValue3 = isEnabled3.bumpercolor
            isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10, strValue3)
        end
    end
    strValue5 = Config
    strValue5 = strValue5.ThemeParkControlAttractions
    if strValue5 then
        strValue5 = ipairs
        dataTable21 = controlmachines
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.smokedisabled
            if false == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Global:ThemeParkControlSmokeHandlerClient"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = isEnabled3.smokeactivated
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Global:ThemeParkControlSmokeColorClient"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = isEnabled3.smokecolor
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
            end
            isEnabled8 = isEnabled3.music
            if true == isEnabled8 then
                isEnabled8 = TriggerClientEvent
                isEnabled13 = "rtx_themepark:Music:ThemeParkControlMusicPlayClient"
                value = index
                isEnabled6 = isEnabled9
                isEnabled4 = isEnabled3.musicurl
                value4 = isEnabled3.musicvolume
                isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
            end
            isEnabled8 = TriggerClientEvent
            isEnabled13 = "rtx_themepark:Music:ThemeParkControlMusicVolume"
            value = index
            isEnabled6 = isEnabled9
            isEnabled4 = isEnabled3.musicvolume
            isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = Config
dataTable3 = dataTable3.ThemeParkCanBeOwned
if dataTable3 then

    function dataTable3()
        local index, strValue5, dataTable21, dataTable
        index = MySQL
        index = index.Async
        index = index.fetchAll
        strValue5 = "SELECT * FROM owned_themepark"
        dataTable21 = {}

        function dataTable(A0_3)
            local func, strValue4, dataTable5, isDisabled, key2, value2, var32, var3
            func = ipairs
            strValue4 = A0_3
            func, strValue4, dataTable5, isDisabled = func(strValue4)
            for key2, value2 in func, strValue4, dataTable5, isDisabled do
                if 1 == key2 then
                    var32 = themeparkowned
                    var32.owned = true
                    var32 = themeparkowned
                    var3 = value2.identifier
                    var32.identifier = var3
                    var32 = themeparkowned
                    var3 = value2.balance
                    var32.balance = var3
                    var32 = themeparkowned
                    var3 = value2.id
                    var32.parkid = var3
                end
            end
            func = Config
            func = func.ThemeParkOwnedSettings
            func = func.enablepermissionsystem
            if true == func then
                func = themeparkowned
                func = func.owned
                if false == func then
                    func = MySQL
                    func = func.Async
                    func = func.execute
                    strValue4 = "INSERT INTO owned_themepark (identifier, balance) VALUES (@identifier, @balance)"
                    dataTable5 = {}
                    dataTable5["@identifier"] = ""
                    dataTable5["@balance"] = 0

                    function isDisabled(A0_4)
                        local func2
                        func2 = themeparkowned
                        func2.owned = true
                    end
                    func(strValue4, dataTable5, isDisabled)
                end
            end
        end
        index(strValue5, dataTable21, dataTable)
    end
    ThemeParkCheckOwned = dataTable3

    function dataTable3(A0_2)
        local strValue5, dataTable21, dataTable, dataTable8
        strValue5 = MySQL
        strValue5 = strValue5.Sync
        strValue5 = strValue5.execute
        dataTable21 = "UPDATE owned_themepark SET identifier = @identifier WHERE id = @id"
        dataTable = {}
        dataTable8 = themeparkowned
        dataTable8 = dataTable8.parkid
        dataTable["@id"] = dataTable8
        dataTable["@identifier"] = A0_2
        strValue5(dataTable21, dataTable)
    end
    UpdateParkOwner = dataTable3

    function dataTable3(A0_2)
        local strValue5, dataTable21, dataTable, dataTable8
        strValue5 = MySQL
        strValue5 = strValue5.Sync
        strValue5 = strValue5.execute
        dataTable21 = "UPDATE owned_themepark SET balance = @balance WHERE id = @id"
        dataTable = {}
        dataTable8 = themeparkowned
        dataTable8 = dataTable8.parkid
        dataTable["@id"] = dataTable8
        dataTable["@balance"] = A0_2
        strValue5(dataTable21, dataTable)
    end
    UpdateParkMoney = dataTable3

    function dataTable3()
        local index, strValue5, dataTable21, dataTable
        index = MySQL
        index = index.Async
        index = index.execute
        strValue5 = "DELETE FROM owned_themepark WHERE id = @id"
        dataTable21 = {}
        dataTable = themeparkowned
        dataTable = dataTable.parkid
        dataTable21["@id"] = dataTable

        function dataTable(A0_3)
            local func, strValue4, dataTable5, isDisabled
            func = themeparkowned
            func.owned = false
            func = TriggerClientEvent
            strValue4 = "rtx_themepark:Global:ParkOwned"
            dataTable5 = -1
            isDisabled = false
            func(strValue4, dataTable5, isDisabled)
            func = TriggerClientEvent
            strValue4 = "rtx_themepark:Global:ParkOwn"
            dataTable5 = -1
            isDisabled = false
            func(strValue4, dataTable5, isDisabled)
        end
        index(strValue5, dataTable21, dataTable)
    end
    RemoveParkOwnership = dataTable3

    function dataTable3(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9
        dataTable21 = MySQL
        dataTable21 = dataTable21.Async
        dataTable21 = dataTable21.execute
        dataTable = "INSERT INTO owned_themepark (identifier, balance) VALUES (@identifier, @balance)"
        dataTable8 = {}
        dataTable8["@identifier"] = A1_2
        dataTable8["@balance"] = 0

        function isEnabled9(A0_3)
            local func, strValue4, dataTable5, isDisabled
            func = MySQL
            func = func.Async
            func = func.fetchAll
            strValue4 = "SELECT * FROM owned_themepark"
            dataTable5 = {}

            function isDisabled(A0_4)
                local func2, strValue, var43, isEnabled2, key, value3, var42, var4
                func2 = ipairs
                strValue = A0_4
                func2, strValue, var43, isEnabled2 = func2(strValue)
                for key, value3 in func2, strValue, var43, isEnabled2 do
                    if 1 == key then
                        var42 = themeparkowned
                        var42.owned = true
                        var42 = themeparkowned
                        var4 = value3.identifier
                        var42.identifier = var4
                        var42 = themeparkowned
                        var4 = value3.balance
                        var42.balance = var4
                        var42 = themeparkowned
                        var4 = value3.id
                        var42.parkid = var4
                    end
                end
                func2 = TriggerClientEvent
                strValue = "rtx_themepark:Global:ParkOwned"
                var43 = -1
                isEnabled2 = true
                func2(strValue, var43, isEnabled2)
                func2 = TriggerClientEvent
                strValue = "rtx_themepark:Global:ParkOwn"
                var43 = A0_2
                isEnabled2 = true
                func2(strValue, var43, isEnabled2)
            end
            func(strValue4, dataTable5, isDisabled)
        end
        dataTable21(dataTable, dataTable8, isEnabled9)
    end
    BuyThemePark = dataTable3
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:OpenThemeParkManagmentMenu"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:OpenThemeParkManagmentMenu"

    function dataTable16()
        local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9
        index = source
        strValue5 = themeparkowned
        strValue5 = strValue5.owned
        if true ~= strValue5 then
            strValue5 = Config
            strValue5 = strValue5.ThemeParkOwnedSettings
            strValue5 = strValue5.enablepermissionsystem
            if true ~= strValue5 then
                goto lbl_41
            end
        end
        strValue5 = Config
        strValue5 = strValue5.ThemeParkOwnedSettings
        strValue5 = strValue5.enablepermissionsystem
        if true == strValue5 then
            strValue5 = GetPlayerPermissionsManagment
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            if strValue5 then
                dataTable21 = TriggerClientEvent
                dataTable = "rtx_themepark:Global:OpenThemeParkManagmentMenuClient"
                dataTable8 = index
                isEnabled9 = themeparkowned
                isEnabled9 = isEnabled9.balance
                dataTable21(dataTable, dataTable8, isEnabled9)
            end
        else
            strValue5 = GetPlayerIdentifierRTX
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            dataTable21 = themeparkowned
            dataTable21 = dataTable21.identifier
            if dataTable21 == strValue5 then
                dataTable21 = TriggerClientEvent
                dataTable = "rtx_themepark:Global:OpenThemeParkManagmentMenuClient"
                dataTable8 = index
                isEnabled9 = themeparkowned
                isEnabled9 = isEnabled9.balance
                dataTable21(dataTable, dataTable8, isEnabled9)
            end
        end
        ::lbl_41::
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractions"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractions"

    function dataTable16()
        local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9
        index = source
        strValue5 = themeparkowned
        strValue5 = strValue5.owned
        if true ~= strValue5 then
            strValue5 = Config
            strValue5 = strValue5.ThemeParkOwnedSettings
            strValue5 = strValue5.enablepermissionsystem
            if true ~= strValue5 then
                goto lbl_39
            end
        end
        strValue5 = Config
        strValue5 = strValue5.ThemeParkOwnedSettings
        strValue5 = strValue5.enablepermissionsystem
        if true == strValue5 then
            strValue5 = GetPlayerPermissionsManagment
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            if strValue5 then
                dataTable21 = TriggerClientEvent
                dataTable = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractionsClient"
                dataTable8 = index
                isEnabled9 = themeparkattractionsopenstatus
                dataTable21(dataTable, dataTable8, isEnabled9)
            end
        else
            strValue5 = GetPlayerIdentifierRTX
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            dataTable21 = themeparkowned
            dataTable21 = dataTable21.identifier
            if dataTable21 == strValue5 then
                dataTable21 = TriggerClientEvent
                dataTable = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractionsClient"
                dataTable8 = index
                isEnabled9 = themeparkattractionsopenstatus
                dataTable21(dataTable, dataTable8, isEnabled9)
            end
        end
        ::lbl_39::
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:UpdateAttractionStatus"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:UpdateAttractionStatus"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8
        dataTable21 = source
        dataTable = themeparkowned
        dataTable = dataTable.owned
        if true ~= dataTable then
            dataTable = Config
            dataTable = dataTable.ThemeParkOwnedSettings
            dataTable = dataTable.enablepermissionsystem
            if true ~= dataTable then
                goto lbl_37
            end
        end
        dataTable = Config
        dataTable = dataTable.ThemeParkOwnedSettings
        dataTable = dataTable.enablepermissionsystem
        if true == dataTable then
            dataTable = GetPlayerPermissionsManagment
            dataTable8 = dataTable21
            dataTable = dataTable(dataTable8)
            if dataTable and nil ~= A0_2 then
                dataTable8 = themeparkattractionsopenstatus
                dataTable8[A0_2] = A1_2
            end
        else
            dataTable = GetPlayerIdentifierRTX
            dataTable8 = dataTable21
            dataTable = dataTable(dataTable8)
            dataTable8 = themeparkowned
            dataTable8 = dataTable8.identifier
            if dataTable8 == dataTable and nil ~= A0_2 then
                dataTable8 = themeparkattractionsopenstatus
                dataTable8[A0_2] = A1_2
            end
        end
        ::lbl_37::
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:BuyThemePark"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:BuyThemePark"

    function dataTable16()
        local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        index = source
        strValue5 = themeparkowned
        strValue5 = strValue5.owned
        if false == strValue5 then
            strValue5 = Config
            strValue5 = strValue5.ThemeParkOwnedSettings
            strValue5 = strValue5.enablepermissionsystem
            if false == strValue5 then
                strValue5 = GetMoneyRTX
                dataTable21 = index
                strValue5 = strValue5(dataTable21)
                dataTable21 = Config
                dataTable21 = dataTable21.ThemeParkOwnedSettings
                dataTable21 = dataTable21.themeparkprice
                if strValue5 >= dataTable21 then
                    dataTable21 = themeparkowned
                    dataTable21.owned = true
                    dataTable21 = RemoveMoneyRTX
                    dataTable = index
                    dataTable8 = Config
                    dataTable8 = dataTable8.ThemeParkOwnedSettings
                    dataTable8 = dataTable8.themeparkprice
                    dataTable21(dataTable, dataTable8)
                    dataTable21 = GetPlayerIdentifierRTX
                    dataTable = index
                    dataTable21 = dataTable21(dataTable)
                    dataTable = themeparkowned
                    dataTable.identifier = dataTable21
                    dataTable = TriggerClientEvent
                    dataTable8 = "rtx_themepark:Notify"
                    isEnabled9 = index
                    isEnabled3 = LanguageFile
                    isEnabled8 = "youboughtthemepark"
                    isEnabled13 = Config
                    isEnabled13 = isEnabled13.ThemeParkOwnedSettings
                    isEnabled13 = isEnabled13.themeparkprice
                    isEnabled3, isEnabled8, isEnabled13 = isEnabled3(isEnabled8, isEnabled13)
                    dataTable(dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                    dataTable = BuyThemePark
                    dataTable8 = index
                    isEnabled9 = dataTable21
                    dataTable(dataTable8, isEnabled9)
                else
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Notify"
                    dataTable8 = index
                    isEnabled9 = Language
                    isEnabled3 = Config
                    isEnabled3 = isEnabled3.Language
                    isEnabled9 = isEnabled9[isEnabled3]
                    isEnabled9 = isEnabled9.nomoneyenoughthemeparkbuy
                    dataTable21(dataTable, dataTable8, isEnabled9)
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkManagmentWithdraw"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkManagmentWithdraw"

    function dataTable16()
        local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8
        index = source
        strValue5 = themeparkowned
        strValue5 = strValue5.owned
        if true ~= strValue5 then
            strValue5 = Config
            strValue5 = strValue5.ThemeParkOwnedSettings
            strValue5 = strValue5.enablepermissionsystem
            if true ~= strValue5 then
                goto lbl_109
            end
        end
        strValue5 = Config
        strValue5 = strValue5.ThemeParkOwnedSettings
        strValue5 = strValue5.enablepermissionsystem
        if true == strValue5 then
            strValue5 = GetPlayerPermissionsManagment
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            if strValue5 then
                dataTable21 = themeparkowned
                dataTable21 = dataTable21.balance
                if dataTable21 > 0 then
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Notify"
                    dataTable8 = index
                    isEnabled9 = LanguageFile
                    isEnabled3 = "youwithdrawthemepark"
                    isEnabled8 = themeparkowned
                    isEnabled8 = isEnabled8.balance
                    isEnabled9, isEnabled3, isEnabled8 = isEnabled9(isEnabled3, isEnabled8)
                    dataTable21(dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8)
                    dataTable21 = AddMoneyRTX
                    dataTable = index
                    dataTable8 = themeparkowned
                    dataTable8 = dataTable8.balance
                    dataTable21(dataTable, dataTable8)
                    dataTable21 = themeparkowned
                    dataTable21.balance = 0
                    dataTable21 = UpdateParkMoney
                    dataTable = themeparkowned
                    dataTable = dataTable.balance
                    dataTable21(dataTable)
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Global:ManagmentMenuUpdate"
                    dataTable8 = index
                    isEnabled9 = themeparkowned
                    isEnabled9 = isEnabled9.balance
                    dataTable21(dataTable, dataTable8, isEnabled9)
                else
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Notify"
                    dataTable8 = index
                    isEnabled9 = Language
                    isEnabled3 = Config
                    isEnabled3 = isEnabled3.Language
                    isEnabled9 = isEnabled9[isEnabled3]
                    isEnabled9 = isEnabled9.nomoneywithdrawthemepark
                    dataTable21(dataTable, dataTable8, isEnabled9)
                end
            end
        else
            strValue5 = GetPlayerIdentifierRTX
            dataTable21 = index
            strValue5 = strValue5(dataTable21)
            dataTable21 = themeparkowned
            dataTable21 = dataTable21.identifier
            if dataTable21 == strValue5 then
                dataTable21 = themeparkowned
                dataTable21 = dataTable21.balance
                if dataTable21 > 0 then
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Notify"
                    dataTable8 = index
                    isEnabled9 = LanguageFile
                    isEnabled3 = "youwithdrawthemepark"
                    isEnabled8 = themeparkowned
                    isEnabled8 = isEnabled8.balance
                    isEnabled9, isEnabled3, isEnabled8 = isEnabled9(isEnabled3, isEnabled8)
                    dataTable21(dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8)
                    dataTable21 = AddMoneyRTX
                    dataTable = index
                    dataTable8 = themeparkowned
                    dataTable8 = dataTable8.balance
                    dataTable21(dataTable, dataTable8)
                    dataTable21 = themeparkowned
                    dataTable21.balance = 0
                    dataTable21 = UpdateParkMoney
                    dataTable = themeparkowned
                    dataTable = dataTable.balance
                    dataTable21(dataTable)
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Global:ManagmentMenuUpdate"
                    dataTable8 = index
                    isEnabled9 = themeparkowned
                    isEnabled9 = isEnabled9.balance
                    dataTable21(dataTable, dataTable8, isEnabled9)
                else
                    dataTable21 = TriggerClientEvent
                    dataTable = "rtx_themepark:Notify"
                    dataTable8 = index
                    isEnabled9 = Language
                    isEnabled3 = Config
                    isEnabled3 = isEnabled3.Language
                    isEnabled9 = isEnabled9[isEnabled3]
                    isEnabled9 = isEnabled9.nomoneywithdrawthemepark
                    dataTable21(dataTable, dataTable8, isEnabled9)
                end
            end
        end
        ::lbl_109::
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:SellThemePark"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:SellThemePark"

    function dataTable16()
        local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        index = source
        strValue5 = Config
        strValue5 = strValue5.ThemeParkOwnedSettings
        strValue5 = strValue5.disablesell
        if false == strValue5 then
            strValue5 = Config
            strValue5 = strValue5.ThemeParkOwnedSettings
            strValue5 = strValue5.enablepermissionsystem
            if false == strValue5 then
                strValue5 = themeparkowned
                strValue5 = strValue5.owned
                if true == strValue5 then
                    strValue5 = GetPlayerIdentifierRTX
                    dataTable21 = index
                    strValue5 = strValue5(dataTable21)
                    dataTable21 = themeparkowned
                    dataTable21 = dataTable21.identifier
                    if dataTable21 == strValue5 then
                        dataTable21 = round
                        dataTable = Config
                        dataTable = dataTable.ThemeParkOwnedSettings
                        dataTable = dataTable.themeparkprice
                        dataTable8 = Config
                        dataTable8 = dataTable8.ThemeParkOwnedSettings
                        dataTable8 = dataTable8.sellmultipler
                        dataTable = dataTable * dataTable8
                        dataTable8 = 0
                        dataTable21 = dataTable21(dataTable, dataTable8)
                        dataTable = themeparkowned
                        dataTable.owned = false
                        dataTable = themeparkowned
                        dataTable.identifier = ""
                        dataTable = TriggerClientEvent
                        dataTable8 = "rtx_themepark:Notify"
                        isEnabled9 = index
                        isEnabled3 = LanguageFile
                        isEnabled8 = "yousoldthemepark"
                        isEnabled13 = dataTable21
                        isEnabled3, isEnabled8, isEnabled13 = isEnabled3(isEnabled8, isEnabled13)
                        dataTable(dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                        dataTable = AddMoneyRTX
                        dataTable8 = index
                        isEnabled9 = dataTable21
                        dataTable(dataTable8, isEnabled9)
                        dataTable = TriggerClientEvent
                        dataTable8 = "rtx_themepark:Global:ParkOwn"
                        isEnabled9 = index
                        isEnabled3 = false
                        dataTable(dataTable8, isEnabled9, isEnabled3)
                        dataTable = TriggerClientEvent
                        dataTable8 = "rtx_themepark:Global:ParkOwned"
                        isEnabled9 = -1
                        isEnabled3 = false
                        dataTable(dataTable8, isEnabled9, isEnabled3)
                        dataTable = RemoveParkOwnership
                        dataTable()
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:TransferThemePark"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:TransferThemePark"

    function dataTable16(A0_2)
        local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        strValue5 = source
        dataTable21 = Config
        dataTable21 = dataTable21.ThemeParkOwnedSettings
        dataTable21 = dataTable21.disabletransfer
        if false == dataTable21 then
            dataTable21 = Config
            dataTable21 = dataTable21.ThemeParkOwnedSettings
            dataTable21 = dataTable21.enablepermissionsystem
            if false == dataTable21 then
                dataTable21 = themeparkowned
                dataTable21 = dataTable21.owned
                if true == dataTable21 then
                    dataTable21 = GetPlayerIdentifierRTX
                    dataTable = strValue5
                    dataTable21 = dataTable21(dataTable)
                    dataTable = themeparkowned
                    dataTable = dataTable.identifier
                    if dataTable == dataTable21 then
                        dataTable = GetPlayerIdentifierRTX
                        dataTable8 = A0_2
                        dataTable = dataTable(dataTable8)
                        dataTable8 = themeparkowned
                        dataTable8.identifier = dataTable
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Notify"
                        isEnabled3 = strValue5
                        isEnabled8 = Language
                        isEnabled13 = Config
                        isEnabled13 = isEnabled13.Language
                        isEnabled8 = isEnabled8[isEnabled13]
                        isEnabled8 = isEnabled8.youtransferthemepark
                        dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Notify"
                        isEnabled3 = A0_2
                        isEnabled8 = Language
                        isEnabled13 = Config
                        isEnabled13 = isEnabled13.Language
                        isEnabled8 = isEnabled8[isEnabled13]
                        isEnabled8 = isEnabled8.themeparkransferredto
                        dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Global:ParkOwn"
                        isEnabled3 = strValue5
                        isEnabled8 = false
                        dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Global:ParkOwn"
                        isEnabled3 = A0_2
                        isEnabled8 = true
                        dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        dataTable8 = UpdateParkOwner
                        isEnabled9 = dataTable
                        dataTable8(isEnabled9)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = Citizen
    dataTable3 = dataTable3.CreateThread

    function dataTable15()
        local index, strValue5
        index = ThemeParkCheckOwned
        index()
    end
    dataTable3(dataTable15)
end
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:OpenTicketMachineMenu"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:OpenTicketMachineMenu"

function dataTable16(A0_2)
    local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8
    strValue5 = source
    if nil ~= A0_2 then
        dataTable21 = ticketmachines
        dataTable21 = dataTable21[A0_2]
        dataTable = dataTable21.disabled
        if false == dataTable then
            dataTable = themeparkdisabled
            if false == dataTable then
                dataTable = themeparkattractionsopenstatus
                dataTable8 = dataTable21.attractionid
                dataTable = dataTable[dataTable8]
                if true == dataTable then
                    dataTable = TriggerClientEvent
                    dataTable8 = "rtx_themepark:Global:OpenTicketMachineMenuClient"
                    isEnabled9 = strValue5
                    isEnabled3 = A0_2
                    dataTable(dataTable8, isEnabled9, isEnabled3)
                else
                    dataTable = TriggerClientEvent
                    dataTable8 = "rtx_themepark:Notify"
                    isEnabled9 = strValue5
                    isEnabled3 = Language
                    isEnabled8 = Config
                    isEnabled8 = isEnabled8.Language
                    isEnabled3 = isEnabled3[isEnabled8]
                    isEnabled3 = isEnabled3.attractionclosed
                    dataTable(dataTable8, isEnabled9, isEnabled3)
                end
            end
        else
            dataTable = TriggerClientEvent
            dataTable8 = "rtx_themepark:Notify"
            isEnabled9 = strValue5
            isEnabled3 = Language
            isEnabled8 = Config
            isEnabled8 = isEnabled8.Language
            isEnabled3 = isEnabled3[isEnabled8]
            isEnabled3 = isEnabled3.attractionclosed
            dataTable(dataTable8, isEnabled9, isEnabled3)
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:ThemeParkBuyTicket"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:ThemeParkBuyTicket"

function dataTable16(A0_2)
    local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value
    strValue5 = source
    if nil ~= A0_2 then
        dataTable21 = ticketmachines
        dataTable21 = dataTable21[A0_2]
        dataTable = dataTable21.disabled
        if false == dataTable then
            dataTable = themeparkdisabled
            if false == dataTable then
                dataTable = themeparkattractionsopenstatus
                dataTable8 = dataTable21.attractionid
                dataTable = dataTable[dataTable8]
                if true == dataTable then
                    dataTable = GetMoneyRTX
                    dataTable8 = strValue5
                    dataTable = dataTable(dataTable8)
                    dataTable8 = dataTable21.ticketprice
                    if dataTable >= dataTable8 then
                        dataTable8 = RemoveMoneyRTX
                        isEnabled9 = strValue5
                        isEnabled3 = dataTable21.ticketprice
                        dataTable8(isEnabled9, isEnabled3)
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Notify"
                        isEnabled3 = strValue5
                        isEnabled8 = LanguageFile
                        isEnabled13 = "ticketthemeparkbought"
                        value = dataTable21.ticketprice
                        isEnabled8, isEnabled13, value = isEnabled8(isEnabled13, value)
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Global:TicketHandler"
                        isEnabled3 = strValue5
                        isEnabled8 = dataTable21.tickettype
                        isEnabled13 = true
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                        dataTable8 = Config
                        dataTable8 = dataTable8.ThemeParkCanBeOwned
                        if dataTable8 then
                            dataTable8 = round
                            isEnabled9 = dataTable21.ticketprice
                            isEnabled3 = Config
                            isEnabled3 = isEnabled3.ThemeParkOwnedSettings
                            isEnabled3 = isEnabled3.ticketmultipler
                            isEnabled9 = isEnabled9 * isEnabled3
                            isEnabled3 = 0
                            dataTable8 = dataTable8(isEnabled9, isEnabled3)
                            isEnabled9 = themeparkowned
                            isEnabled3 = themeparkowned
                            isEnabled3 = isEnabled3.balance
                            isEnabled3 = isEnabled3 + dataTable8
                            isEnabled9.balance = isEnabled3
                            isEnabled9 = UpdateParkMoney
                            isEnabled3 = themeparkowned
                            isEnabled3 = isEnabled3.balance
                            isEnabled9(isEnabled3)
                        end
                    else
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Notify"
                        isEnabled3 = strValue5
                        isEnabled8 = LanguageFile
                        isEnabled13 = "nomoneyenoughthemeparkattraction"
                        value = dataTable21.ticketprice
                        isEnabled8, isEnabled13, value = isEnabled8(isEnabled13, value)
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
                    end
                else
                    dataTable = TriggerClientEvent
                    dataTable8 = "rtx_themepark:Notify"
                    isEnabled9 = strValue5
                    isEnabled3 = Language
                    isEnabled8 = Config
                    isEnabled8 = isEnabled8.Language
                    isEnabled3 = isEnabled3[isEnabled8]
                    isEnabled3 = isEnabled3.attractionclosed
                    dataTable(dataTable8, isEnabled9, isEnabled3)
                end
            end
        else
            dataTable = TriggerClientEvent
            dataTable8 = "rtx_themepark:Notify"
            isEnabled9 = strValue5
            isEnabled3 = Language
            isEnabled8 = Config
            isEnabled8 = isEnabled8.Language
            isEnabled3 = isEnabled3[isEnabled8]
            isEnabled3 = isEnabled3.attractionclosed
            dataTable(dataTable8, isEnabled9, isEnabled3)
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:GiveItemInHand"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:GiveItemInHand"

function dataTable16(A0_2, A1_2, A2_2)
    local dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value
    dataTable = source
    dataTable8 = playersiteminhand
    dataTable8 = dataTable8[dataTable]
    if nil ~= dataTable8 then
        dataTable8 = playerusingattraction
        dataTable8 = dataTable8[A0_2]
        if nil == dataTable8 then
            dataTable8 = playersiteminhand
            dataTable8 = dataTable8[A0_2]
            if nil == dataTable8 then
                dataTable8 = playersiteminhand
                dataTable8[dataTable] = nil
                dataTable8 = playersiteminhand
                dataTable8[A0_2] = true
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Global:GiveHandItem"
                isEnabled3 = -1
                isEnabled8 = A0_2
                isEnabled13 = A1_2
                value = A2_2
                dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Global:InHandItem"
                isEnabled3 = A0_2
                isEnabled8 = A1_2
                isEnabled13 = A2_2
                dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Global:RemoveHandItem"
                isEnabled3 = -1
                isEnabled8 = dataTable
                dataTable8(isEnabled9, isEnabled3, isEnabled8)
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Global:InHandItemRemoveInterface"
                isEnabled3 = dataTable
                dataTable8(isEnabled9, isEnabled3)
            else
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Notify"
                isEnabled3 = dataTable
                isEnabled8 = Language
                isEnabled13 = Config
                isEnabled13 = isEnabled13.Language
                isEnabled8 = isEnabled8[isEnabled13]
                isEnabled8 = isEnabled8.thisplayerhaveitem
                dataTable8(isEnabled9, isEnabled3, isEnabled8)
            end
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:RemoveItemInHand"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:RemoveItemInHand"

function dataTable16(A0_2, A1_2)
    local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
    dataTable21 = source
    dataTable = playersiteminhand
    dataTable = dataTable[dataTable21]
    if nil ~= dataTable then
        dataTable = playersiteminhand
        dataTable[dataTable21] = nil
        dataTable = TriggerClientEvent
        dataTable8 = "rtx_themepark:Global:InHandItemRemoveInterface"
        isEnabled9 = dataTable21
        dataTable(dataTable8, isEnabled9)
        dataTable = TriggerClientEvent
        dataTable8 = "rtx_themepark:Global:RemoveHandItemThrow"
        isEnabled9 = -1
        isEnabled3 = dataTable21
        isEnabled8 = A0_2
        isEnabled13 = A1_2
        dataTable(dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13)
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:BuyItemToHand"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:BuyItemToHand"

function dataTable16(A0_2)
    local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6
    strValue5 = source
    if nil ~= A0_2 then
        dataTable21 = playersiteminhand
        dataTable21 = dataTable21[strValue5]
        if nil == dataTable21 then
            dataTable21 = Config
            dataTable21 = dataTable21.Stands
            dataTable21 = dataTable21[A0_2]
            dataTable = GetMoneyRTX
            dataTable8 = strValue5
            dataTable = dataTable(dataTable8)
            dataTable8 = dataTable21.itemprice
            if dataTable >= dataTable8 then
                dataTable8 = RemoveMoneyRTX
                isEnabled9 = strValue5
                isEnabled3 = dataTable21.itemprice
                dataTable8(isEnabled9, isEnabled3)
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Notify"
                isEnabled3 = strValue5
                isEnabled8 = LanguageFile
                isEnabled13 = "itemthemeparkbought"
                value = dataTable21.itemprice
                isEnabled6 = dataTable21.standtype
                isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13, value, isEnabled6)
                dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6)
                dataTable8 = playersiteminhand
                dataTable8[strValue5] = true
                dataTable8 = math
                dataTable8 = dataTable8.random
                isEnabled9 = 1
                isEnabled3 = 4
                dataTable8 = dataTable8(isEnabled9, isEnabled3)
                isEnabled9 = TriggerClientEvent
                isEnabled3 = "rtx_themepark:Global:GiveHandItem"
                isEnabled8 = -1
                isEnabled13 = strValue5
                value = dataTable21.standtype
                isEnabled6 = dataTable8
                isEnabled9(isEnabled3, isEnabled8, isEnabled13, value, isEnabled6)
                isEnabled9 = TriggerClientEvent
                isEnabled3 = "rtx_themepark:Global:InHandItem"
                isEnabled8 = strValue5
                isEnabled13 = dataTable21.standtype
                value = dataTable8
                isEnabled9(isEnabled3, isEnabled8, isEnabled13, value)
                isEnabled9 = Config
                isEnabled9 = isEnabled9.ThemeParkCanBeOwned
                if isEnabled9 then
                    isEnabled9 = round
                    isEnabled3 = dataTable21.itemprice
                    isEnabled8 = Config
                    isEnabled8 = isEnabled8.ThemeParkOwnedSettings
                    isEnabled8 = isEnabled8.itemmultipler
                    isEnabled3 = isEnabled3 * isEnabled8
                    isEnabled8 = 0
                    isEnabled9 = isEnabled9(isEnabled3, isEnabled8)
                    isEnabled3 = themeparkowned
                    isEnabled8 = themeparkowned
                    isEnabled8 = isEnabled8.balance
                    isEnabled8 = isEnabled8 + isEnabled9
                    isEnabled3.balance = isEnabled8
                    isEnabled3 = UpdateParkMoney
                    isEnabled8 = themeparkowned
                    isEnabled8 = isEnabled8.balance
                    isEnabled3(isEnabled8)
                end
                isEnabled9 = dataTable21.standtype
                if "hotdog" == isEnabled9 then
                    isEnabled9 = Citizen
                    isEnabled9 = isEnabled9.Wait
                    isEnabled3 = 5000
                    isEnabled9(isEnabled3)
                    isEnabled9 = TriggerClientEvent
                    isEnabled3 = "rtx_themepark:Global:InHandItemRemoveInterface"
                    isEnabled8 = strValue5
                    isEnabled9(isEnabled3, isEnabled8)
                    isEnabled9 = TriggerClientEvent
                    isEnabled3 = "rtx_themepark:Global:RemoveHandItem"
                    isEnabled8 = -1
                    isEnabled13 = strValue5
                    isEnabled9(isEnabled3, isEnabled8, isEnabled13)
                    isEnabled9 = playersiteminhand
                    isEnabled9[strValue5] = nil
                else
                    isEnabled9 = dataTable21.standtype
                    if "juice" == isEnabled9 then
                        isEnabled9 = Citizen
                        isEnabled9 = isEnabled9.Wait
                        isEnabled3 = 7000
                        isEnabled9(isEnabled3)
                        isEnabled9 = TriggerClientEvent
                        isEnabled3 = "rtx_themepark:Global:InHandItemRemoveInterface"
                        isEnabled8 = strValue5
                        isEnabled9(isEnabled3, isEnabled8)
                        isEnabled9 = TriggerClientEvent
                        isEnabled3 = "rtx_themepark:Global:RemoveHandItem"
                        isEnabled8 = -1
                        isEnabled13 = strValue5
                        isEnabled9(isEnabled3, isEnabled8, isEnabled13)
                        isEnabled9 = playersiteminhand
                        isEnabled9[strValue5] = nil
                    else
                        isEnabled9 = dataTable21.standtype
                        if "burger" == isEnabled9 then
                            isEnabled9 = Citizen
                            isEnabled9 = isEnabled9.Wait
                            isEnabled3 = 5000
                            isEnabled9(isEnabled3)
                            isEnabled9 = TriggerClientEvent
                            isEnabled3 = "rtx_themepark:Global:InHandItemRemoveInterface"
                            isEnabled8 = strValue5
                            isEnabled9(isEnabled3, isEnabled8)
                            isEnabled9 = TriggerClientEvent
                            isEnabled3 = "rtx_themepark:Global:RemoveHandItem"
                            isEnabled8 = -1
                            isEnabled13 = strValue5
                            isEnabled9(isEnabled3, isEnabled8, isEnabled13)
                            isEnabled9 = playersiteminhand
                            isEnabled9[strValue5] = nil
                        end
                    end
                end
            else
                dataTable8 = TriggerClientEvent
                isEnabled9 = "rtx_themepark:Notify"
                isEnabled3 = strValue5
                isEnabled8 = LanguageFile
                isEnabled13 = "nomoneyenoughthemeparkitem"
                value = dataTable21.itemprice
                isEnabled6 = dataTable21.standtype
                isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13, value, isEnabled6)
                dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6)
            end
        else
            dataTable21 = TriggerClientEvent
            dataTable = "rtx_themepark:Notify"
            dataTable8 = strValue5
            isEnabled9 = Language
            isEnabled3 = Config
            isEnabled3 = isEnabled3.Language
            isEnabled9 = isEnabled9[isEnabled3]
            isEnabled9 = isEnabled9.youhaveitemalready
            dataTable21(dataTable, dataTable8, isEnabled9)
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = Config
dataTable3 = dataTable3.ThemeParkControlAttractions
if dataTable3 then
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:StartAttractionPlayer"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:StartAttractionPlayer"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10
        dataTable21 = source
        if nil ~= A0_2 then
            dataTable = controlmachines
            dataTable = dataTable[A0_2]
            dataTable8 = dataTable.taken
            if true == dataTable8 then
                dataTable8 = dataTable.takenplayerid
                if dataTable8 == dataTable21 then
                    if 1 == A1_2 then
                        dataTable8 = gforcehandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = gforcehandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:GForce:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartGForce
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 2 == A1_2 then
                        dataTable8 = topscanhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = topscanhandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:TopScan:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartTopScan
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 3 == A1_2 then
                        dataTable8 = vortexhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = vortexhandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:Vortex:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartVortex
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 4 == A1_2 then
                        dataTable8 = detonatorhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = detonatorhandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:Detonator:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartDetonator
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 5 == A1_2 then
                        dataTable8 = boathandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = boathandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:Boat:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartBoat
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 7 == A1_2 then
                        dataTable8 = ferrishandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = ferrishandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:Ferris:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartFerris
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 8 == A1_2 then
                        dataTable8 = rollercoasterhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = rollercoasterhandler
                            dataTable8.started = true
                            dataTable8 = pairs
                            isEnabled9 = playsersinthemepark
                            dataTable8, isEnabled9, isEnabled3, isEnabled8 = dataTable8(isEnabled9)
                            for isEnabled13, value in dataTable8, isEnabled9, isEnabled3, isEnabled8 do
                                isEnabled6 = TriggerClientEvent
                                isEnabled4 = "rtx_themepark:Rollercoaster:SynchronizeStarted"
                                value4 = value
                                isEnabled10 = true
                                isEnabled6(isEnabled4, value4, isEnabled10)
                            end
                            dataTable8 = StartRollercoaster
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 9 == A1_2 then
                        dataTable8 = praterhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = praterhandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction10
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 10 == A1_2 then
                        dataTable8 = brakedancehandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = brakedancehandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction11
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 11 == A1_2 then
                        dataTable8 = slingshothandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = slingshothandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction12
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 12 == A1_2 then
                        dataTable8 = carouselhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = carouselhandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction13
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 13 == A1_2 then
                        dataTable8 = extasyhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = extasyhandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction14
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 14 == A1_2 then
                        dataTable8 = spinridehandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = spinridehandler
                            dataTable8.started = true
                            dataTable8 = StartAttraction15
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 15 == A1_2 then
                        dataTable8 = hauntedhousehandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = hauntedhousehandler
                            dataTable8.started = true
                            dataTable8 = StartHauntedHouse
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 16 == A1_2 then
                        dataTable8 = rollercoasterhandler2
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = rollercoasterhandler2
                            dataTable8.started = true
                            dataTable8 = StartRollercoaster2
                            dataTable8()
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    elseif 17 == A1_2 then
                        dataTable8 = cannonhandler
                        dataTable8 = dataTable8.started
                        if false == dataTable8 then
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = LanguageFile
                            isEnabled13 = "youstartedattraction"
                            value = dataTable.label
                            isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10 = isEnabled8(isEnabled13, value)
                            dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                            dataTable8 = cannonhandler
                            dataTable8.started = true
                            dataTable8 = StartCannon
                            isEnabled9 = GlobalState
                            isEnabled9 = isEnabled9["attraction18 - playerid"]
                            dataTable8(isEnabled9)
                        else
                            dataTable8 = TriggerClientEvent
                            isEnabled9 = "rtx_themepark:Notify"
                            isEnabled3 = dataTable21
                            isEnabled8 = Language
                            isEnabled13 = Config
                            isEnabled13 = isEnabled13.Language
                            isEnabled8 = isEnabled8[isEnabled13]
                            isEnabled8 = isEnabled8.attractioninprogress
                            dataTable8(isEnabled9, isEnabled3, isEnabled8)
                        end
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkOpenControlMenu"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkOpenControlMenu"

    function dataTable16(A0_2)
        local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        strValue5 = source
        if nil ~= A0_2 then
            dataTable21 = controlmachines
            dataTable21 = dataTable21[A0_2]
            dataTable = dataTable21.taken
            if false == dataTable then
                dataTable = GetPlayerPermissionsControlAttraction
                dataTable8 = strValue5
                dataTable = dataTable(dataTable8)
                if dataTable then
                    dataTable21.taken = true
                    dataTable21.takenplayerid = strValue5
                    dataTable8 = TriggerClientEvent
                    isEnabled9 = "rtx_themepark:Global:ThemeParkOpenControlMenuClient"
                    isEnabled3 = strValue5
                    isEnabled8 = A0_2
                    dataTable8(isEnabled9, isEnabled3, isEnabled8)
                else
                    dataTable8 = TriggerClientEvent
                    isEnabled9 = "rtx_themepark:Notify"
                    isEnabled3 = strValue5
                    isEnabled8 = Language
                    isEnabled13 = Config
                    isEnabled13 = isEnabled13.Language
                    isEnabled8 = isEnabled8[isEnabled13]
                    isEnabled8 = isEnabled8.nopermission
                    dataTable8(isEnabled9, isEnabled3, isEnabled8)
                end
            else
                dataTable = TriggerClientEvent
                dataTable8 = "rtx_themepark:Notify"
                isEnabled9 = strValue5
                isEnabled3 = Language
                isEnabled8 = Config
                isEnabled8 = isEnabled8.Language
                isEnabled3 = isEnabled3[isEnabled8]
                isEnabled3 = isEnabled3.attractioncontrolled
                dataTable(dataTable8, isEnabled9, isEnabled3)
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkOpenControlMenuClose"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkOpenControlMenuClose"

    function dataTable16(A0_2)
        local strValue5, dataTable21, dataTable
        strValue5 = source
        if nil ~= A0_2 then
            dataTable21 = controlmachines
            dataTable21 = dataTable21[A0_2]
            dataTable = dataTable21.taken
            if true == dataTable then
                dataTable = dataTable21.takenplayerid
                if dataTable == strValue5 then
                    dataTable21.taken = false
                    dataTable21.takenplayerid = nil
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkControlSmokeHandler"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkControlSmokeHandler"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        dataTable21 = source
        if nil ~= A0_2 then
            dataTable = controlmachines
            dataTable = dataTable[A0_2]
            dataTable8 = dataTable.taken
            if true == dataTable8 then
                dataTable8 = dataTable.takenplayerid
                if dataTable8 == dataTable21 then
                    dataTable8 = dataTable.smokedisabled
                    if false == dataTable8 then
                        dataTable.smokeactivated = A1_2
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Global:ThemeParkControlSmokeHandlerClient"
                        isEnabled3 = -1
                        isEnabled8 = A0_2
                        isEnabled13 = A1_2
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkControlSmokeColor"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkControlSmokeColor"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        dataTable21 = source
        if nil ~= A0_2 then
            dataTable = controlmachines
            dataTable = dataTable[A0_2]
            dataTable8 = dataTable.taken
            if true == dataTable8 then
                dataTable8 = dataTable.takenplayerid
                if dataTable8 == dataTable21 then
                    dataTable8 = dataTable.smokedisabled
                    if false == dataTable8 then
                        dataTable.smokecolor = A1_2
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Global:ThemeParkControlSmokeColorClient"
                        isEnabled3 = -1
                        isEnabled8 = A0_2
                        isEnabled13 = A1_2
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicPlay"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicPlay"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value
        dataTable21 = source
        if nil ~= A0_2 then
            dataTable = controlmachines
            dataTable = dataTable[A0_2]
            dataTable8 = dataTable.taken
            if true == dataTable8 then
                dataTable8 = dataTable.takenplayerid
                if dataTable8 == dataTable21 then
                    dataTable8 = dataTable.musicdisabled
                    if false == dataTable8 then
                        dataTable.music = true
                        dataTable.musicurl = A1_2
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Music:ThemeParkControlMusicPlayClient"
                        isEnabled3 = -1
                        isEnabled8 = A0_2
                        isEnabled13 = A1_2
                        value = dataTable.musicvolume
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13, value)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicVolume"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicVolume"

    function dataTable16(A0_2, A1_2)
        local dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13
        dataTable21 = source
        if nil ~= A0_2 then
            dataTable = controlmachines
            dataTable = dataTable[A0_2]
            dataTable8 = dataTable.taken
            if true == dataTable8 then
                dataTable8 = dataTable.takenplayerid
                if dataTable8 == dataTable21 then
                    dataTable8 = dataTable.musicdisabled
                    if false == dataTable8 and A1_2 >= 0 and A1_2 <= 100 then
                        dataTable.musicvolume = A1_2
                        dataTable8 = TriggerClientEvent
                        isEnabled9 = "rtx_themepark:Music:ThemeParkControlMusicVolume"
                        isEnabled3 = -1
                        isEnabled8 = A0_2
                        isEnabled13 = A1_2
                        dataTable8(isEnabled9, isEnabled3, isEnabled8, isEnabled13)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
    dataTable3 = RegisterServerEvent
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicStop"
    dataTable3(dataTable15)
    dataTable3 = AddEventHandler
    dataTable15 = "rtx_themepark:Global:ThemeParkControlMusicStop"

    function dataTable16(A0_2)
        local strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3
        strValue5 = source
        if nil ~= A0_2 then
            dataTable21 = controlmachines
            dataTable21 = dataTable21[A0_2]
            dataTable = dataTable21.taken
            if true == dataTable then
                dataTable = dataTable21.takenplayerid
                if dataTable == strValue5 then
                    dataTable = dataTable21.musicdisabled
                    if false == dataTable then
                        dataTable21.music = false
                        dataTable21.musicurl = ""
                        dataTable = TriggerClientEvent
                        dataTable8 = "rtx_themepark:Music:ThemeParkControlMusicStopClient"
                        isEnabled9 = -1
                        isEnabled3 = A0_2
                        dataTable(dataTable8, isEnabled9, isEnabled3)
                    end
                end
            end
        end
    end
    dataTable3(dataTable15, dataTable16)
end
dataTable3 = AddEventHandler
dataTable15 = "playerDropped"

function dataTable16()
    local index, strValue5, dataTable21, dataTable, dataTable8, isEnabled9, isEnabled3, isEnabled8, isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10, strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22
    index = source
    strValue5 = playersiteminhand
    strValue5 = strValue5[index]
    if nil ~= strValue5 then
        strValue5 = playersiteminhand
        strValue5[index] = nil
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Global:RemoveHandItem"
        dataTable = -1
        dataTable8 = index
        strValue5(dataTable21, dataTable, dataTable8)
    end
    strValue5 = bumperhandler
    strValue5 = strValue5.bumperplayers
    strValue5 = strValue5[index]
    if nil ~= strValue5 then
        strValue5 = bumperhandler
        dataTable21 = bumperhandler
        dataTable21 = dataTable21.currentplayers
        dataTable21 = dataTable21 - 1
        strValue5.currentplayers = dataTable21
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Bumper:BumperEndClient"
        dataTable = -1
        dataTable8 = index
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = TriggerClientEvent
        dataTable21 = "rtx_themepark:Global:ObjectDelete"
        dataTable = -1
        dataTable8 = bumperhandler
        dataTable8 = dataTable8.bumperplayers
        dataTable8 = dataTable8[index]
        dataTable8 = dataTable8.vehiclenetwork
        strValue5(dataTable21, dataTable, dataTable8)
        strValue5 = bumperhandler
        strValue5 = strValue5.bumperplayers
        strValue5[index] = nil
    end
    strValue5 = gforcehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = gforcehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:GForce:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        strValue2 = value4.seattype
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                        value4.taken = false
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = topscanhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = topscanhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:TopScan:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                        value4.taken = false
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = vortexhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = vortexhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Vortex:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
                    isEnabled3.taken = false
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
    strValue5 = detonatorhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = detonatorhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Detonator:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
                    isEnabled3.taken = false
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
    strValue5 = boathandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = boathandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Boat:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled10 = isEnabled3.seattype
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4, isEnabled10)
                    isEnabled3.taken = false
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
    strValue5 = ferrishandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = ferrishandler
        dataTable21 = dataTable21.cabins
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.players
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Ferris:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = true
                        condition = value4.takenplayerid
                        strValue2 = value4.seattype
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                        value4.taken = false
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = rollercoasterhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = rollercoasterhandler
        dataTable21 = dataTable21.carts
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.players
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Rollercoaster:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        strValue2 = value4.seattype
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition, strValue2)
                        value4.taken = false
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = praterhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = praterhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        value4.taken = false
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Prater:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Prater:SeatExit"
                        var25 = value4.takenplayerid
                        isEnabled5 = true
                        isEnabled10(strValue3, var25, isEnabled5)
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = praterhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = praterhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        value4.taken = false
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Prater:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Prater:SeatExit"
                        var25 = value4.takenplayerid
                        isEnabled5 = true
                        isEnabled10(strValue3, var25, isEnabled5)
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = brakedancehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = brakedancehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.cabins
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = ipairs
                strValue3 = value4.seats
                isEnabled10, strValue3, var25, isEnabled5 = isEnabled10(strValue3)
                for isEnabled, isEnabled7 in isEnabled10, strValue3, var25, isEnabled5 do
                    condition = isEnabled7.taken
                    if true == condition then
                        condition = isEnabled7.takenplayerid
                        if condition == index then
                            isEnabled7.taken = false
                            condition = TriggerClientEvent
                            strValue2 = "rtx_themepark:BrakeDance:SynchronizeSeat"
                            var23 = -1
                            isEnabled11 = isEnabled9
                            var24 = isEnabled4
                            var2 = isEnabled
                            isEnabled12 = false
                            var22 = isEnabled7.takenplayerid
                            condition(strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22)
                            condition = TriggerClientEvent
                            strValue2 = "rtx_themepark:BrakeDance:SeatExit"
                            var23 = isEnabled7.takenplayerid
                            isEnabled11 = true
                            condition(strValue2, var23, isEnabled11)
                            isEnabled7.takenplayerid = nil
                        end
                    end
                end
            end
        end
    end
    strValue5 = slingshothandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = slingshothandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled3.taken = false
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:SlingShot:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:SlingShot:SeatExit"
                    value = isEnabled3.takenplayerid
                    isEnabled6 = true
                    isEnabled8(isEnabled13, value, isEnabled6)
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
    strValue5 = carouselhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = carouselhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        value4.taken = false
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Carousel:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = false
                        isEnabled7 = value4.takenplayerid
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7)
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:Carousel:SeatExit"
                        var25 = value4.takenplayerid
                        isEnabled5 = true
                        isEnabled10(strValue3, var25, isEnabled5)
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = extasyhandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = extasyhandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.cabins
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = ipairs
                strValue3 = value4.seats
                isEnabled10, strValue3, var25, isEnabled5 = isEnabled10(strValue3)
                for isEnabled, isEnabled7 in isEnabled10, strValue3, var25, isEnabled5 do
                    condition = isEnabled7.taken
                    if true == condition then
                        condition = isEnabled7.takenplayerid
                        if condition == index then
                            isEnabled7.taken = false
                            condition = TriggerClientEvent
                            strValue2 = "rtx_themepark:Extasy:SynchronizeSeat"
                            var23 = -1
                            isEnabled11 = isEnabled9
                            var24 = isEnabled4
                            var2 = isEnabled
                            isEnabled12 = false
                            var22 = isEnabled7.takenplayerid
                            condition(strValue2, var23, isEnabled11, var24, var2, isEnabled12, var22)
                            condition = TriggerClientEvent
                            strValue2 = "rtx_themepark:Extasy:SeatExit"
                            var23 = isEnabled7.takenplayerid
                            isEnabled11 = true
                            condition(strValue2, var23, isEnabled11)
                            isEnabled7.takenplayerid = nil
                        end
                    end
                end
            end
        end
    end
    strValue5 = spinridehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = spinridehandler
        dataTable21 = dataTable21.cabins
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = ipairs
            isEnabled13 = isEnabled3.seats
            isEnabled8, isEnabled13, value, isEnabled6 = isEnabled8(isEnabled13)
            for isEnabled4, value4 in isEnabled8, isEnabled13, value, isEnabled6 do
                isEnabled10 = value4.taken
                if true == isEnabled10 then
                    isEnabled10 = value4.takenplayerid
                    if isEnabled10 == index then
                        value4.taken = false
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:SpinRide:SynchronizeSeat"
                        var25 = -1
                        isEnabled5 = isEnabled9
                        isEnabled = isEnabled4
                        isEnabled7 = false
                        condition = value4.takenplayerid
                        isEnabled10(strValue3, var25, isEnabled5, isEnabled, isEnabled7, condition)
                        isEnabled10 = TriggerClientEvent
                        strValue3 = "rtx_themepark:SpinRide:SeatExit"
                        var25 = value4.takenplayerid
                        isEnabled5 = true
                        isEnabled10(strValue3, var25, isEnabled5)
                        value4.takenplayerid = nil
                    end
                end
            end
        end
    end
    strValue5 = hauntedhousehandler
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = hauntedhousehandler
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled3.taken = false
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:HauntedHouse:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:HauntedHouse:SeatExit"
                    value = isEnabled3.takenplayerid
                    isEnabled6 = true
                    isEnabled4 = true
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
    strValue5 = rollercoasterhandler2
    strValue5 = strValue5.started
    if true == strValue5 then
        strValue5 = ipairs
        dataTable21 = rollercoasterhandler2
        dataTable21 = dataTable21.seats
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled3.taken = false
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Rollercoaster2:SynchronizeSeat"
                    value = -1
                    isEnabled6 = isEnabled9
                    isEnabled4 = false
                    value4 = isEnabled3.takenplayerid
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4, value4)
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Rollercoaster2:SeatExit"
                    value = isEnabled3.takenplayerid
                    isEnabled6 = true
                    isEnabled4 = true
                    isEnabled8(isEnabled13, value, isEnabled6, isEnabled4)
                    isEnabled8 = TriggerClientEvent
                    isEnabled13 = "rtx_themepark:Global:AttractionUsing"
                    value = isEnabled3.takenplayerid
                    isEnabled6 = false
                    isEnabled8(isEnabled13, value, isEnabled6)
                    isEnabled3.takenplayerid = nil
                    isEnabled3.seattype = 1
                end
            end
        end
    end
    strValue5 = Config
    strValue5 = strValue5.ThemeParkControlAttractions
    if strValue5 then
        strValue5 = ipairs
        dataTable21 = controlmachines
        strValue5, dataTable21, dataTable, dataTable8 = strValue5(dataTable21)
        for isEnabled9, isEnabled3 in strValue5, dataTable21, dataTable, dataTable8 do
            isEnabled8 = isEnabled3.taken
            if true == isEnabled8 then
                isEnabled8 = isEnabled3.takenplayerid
                if isEnabled8 == index then
                    isEnabled3.taken = false
                    isEnabled3.takenplayerid = nil
                end
            end
        end
    end
end
dataTable3(dataTable15, dataTable16)

function dataTable3()
    local index, strValue5
    index = print
    strValue5 = "[RTX THEME PARK DLC] - Thank you by Hari - Deverlopment"
    index(strValue5)
end
authorized = dataTable3
dataTable3 = Citizen
dataTable3 = dataTable3.CreateThread

function dataTable15()
    local index, strValue5
    index = authorized
    index()
end
dataTable3(dataTable15)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:NearbyThemeParkHandler"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:NearbyThemeParkHandler"

function dataTable16(A0_2)
    local strValue5, dataTable21
    strValue5 = source
    if true == A0_2 then
        dataTable21 = playsersinthemepark
        dataTable21 = dataTable21[strValue5]
        if nil == dataTable21 then
            dataTable21 = playsersinthemepark
            dataTable21[strValue5] = strValue5
        end
    elseif false == A0_2 then
        dataTable21 = playsersinthemepark
        dataTable21 = dataTable21[strValue5]
        if nil ~= dataTable21 then
            dataTable21 = playsersinthemepark
            dataTable21[strValue5] = nil
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = RegisterServerEvent
dataTable15 = "rtx_themepark:Global:UsingAttractionPlayer"
dataTable3(dataTable15)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:UsingAttractionPlayer"

function dataTable16(A0_2)
    local strValue5, dataTable21
    strValue5 = source
    if true == A0_2 then
        dataTable21 = playerusingattraction
        dataTable21 = dataTable21[strValue5]
        if nil == dataTable21 then
            dataTable21 = playerusingattraction
            dataTable21[strValue5] = true
        end
    elseif false == A0_2 then
        dataTable21 = playerusingattraction
        dataTable21 = dataTable21[strValue5]
        if nil ~= dataTable21 then
            dataTable21 = playerusingattraction
            dataTable21[strValue5] = nil
        end
    end
end
dataTable3(dataTable15, dataTable16)
dataTable3 = AddEventHandler
dataTable15 = "rtx_themepark:Global:StartAttractionGlobal"

function dataTable16(A0_2)
    local strValue5, dataTable21
    if 1 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:Prater:Start"
        strValue5(dataTable21)
    elseif 2 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:BrakeDance:Start"
        strValue5(dataTable21)
    elseif 3 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:SlingShot:Start"
        strValue5(dataTable21)
    elseif 4 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:Carousel:Start"
        strValue5(dataTable21)
    elseif 5 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:Extasy:Start"
        strValue5(dataTable21)
    elseif 6 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:SpinRide:Start"
        strValue5(dataTable21)
    elseif 7 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:HauntedHouse:Start"
        strValue5(dataTable21)
    elseif 8 == A0_2 then
        strValue5 = TriggerEvent
        dataTable21 = "rtx_themepark:Rollercoaster2:Start"
        strValue5(dataTable21)
    end
end
dataTable3(dataTable15, dataTable16)