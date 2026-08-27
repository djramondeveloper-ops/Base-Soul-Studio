
local coords3, counter2, coords16, dataTable, coords18, coords4, coords19, coords10, coords15, coords8, coords5, coords9, coords22, coords17, coords2, coords7, coords6, coords21, coords12, coords20, coords14, coords11, coords13, counter, var1, var12
coords3 = IsDuplicityVersion
coords3 = coords3()
if coords3 then
    coords3 = GetPlayerPositionInRealTime66
    coords3()
end
usingattraction = false
playerloaded = true
oldframes = 100
oldtime = 0
currentfps = 100
coords3 = {}
coords3.gforce = false
coords3.topscan = false
coords3.vortex = false
coords3.detonator = false
coords3.boat = false
coords3.ferris = false
coords3.rollercoaster = false
coords3.shootingrange = false
coords3.bumpercars = false
coords3.prater = false
coords3.brakedance = false
coords3.slingshot = false
coords3.carousel = false
coords3.extasy = false
coords3.spinride = false
coords3.hauntedhouse = false
coords3.rollercoaster2 = false
coords3.cannon = false
tickets = coords3
coords3 = {}
coords3.owned = false
coords3.own = false
themeparkowned = coords3
nearbyticketmachineid = nil
inticketmachinemenu = false
ticketmachineid = nil
nearbystandid = nil
nearbythemepark = false
streamermodeactivated = false
inattractioncontrolmenu = false
attractioncontrolid = nil
attractioncontrolledid = nil
coords3 = vector3
counter2 = 0.0
coords16 = 0.0
dataTable = 0.0
coords3 = coords3(counter2, coords16, dataTable)
playercurrentcoords = coords3
coords3 = false
counter2 = Config
counter2 = counter2.ThemeParkPassTime
counter2 = counter2 * 60
coords16 = {}
dataTable = {}
coords18 = vector3
coords4 = -1640.79
coords19 = -1077.25
coords10 = 12.15
coords18 = coords18(coords4, coords19, coords10)
dataTable.coords = coords18
dataTable.heading = 225.5
coords18 = Config
coords18 = coords18.AttractionsSettings
coords18 = coords18.gforce
coords18 = coords18.ticketprice
dataTable.ticketprice = coords18
dataTable.attractionid = 1
dataTable.tickettype = 1
coords18 = Config
coords18 = coords18.AttractionsSettings
coords18 = coords18.gforce
coords18 = coords18.disable
dataTable.disabled = coords18
coords18 = {}
coords4 = vector3
coords19 = -1624.01
coords10 = -1072.69
coords15 = 12.03
coords4 = coords4(coords19, coords10, coords15)
coords18.coords = coords4
coords18.heading = 178.5
coords4 = Config
coords4 = coords4.AttractionsSettings
coords4 = coords4.topscan
coords4 = coords4.ticketprice
coords18.ticketprice = coords4
coords18.attractionid = 2
coords18.tickettype = 2
coords4 = Config
coords4 = coords4.AttractionsSettings
coords4 = coords4.topscan
coords4 = coords4.disable
coords18.disabled = coords4
coords4 = {}
coords19 = vector3
coords10 = -1643.14
coords15 = -1119.59
coords8 = 12.02
coords19 = coords19(coords10, coords15, coords8)
coords4.coords = coords19
coords4.heading = 137.5
coords19 = Config
coords19 = coords19.AttractionsSettings
coords19 = coords19.rollercoaster
coords19 = coords19.ticketprice
coords4.ticketprice = coords19
coords4.attractionid = 3
coords4.tickettype = 7
coords19 = Config
coords19 = coords19.AttractionsSettings
coords19 = coords19.rollercoaster
coords19 = coords19.disable
coords4.disabled = coords19
coords19 = {}
coords10 = vector3
coords15 = -1637.59
coords8 = -1102.01
coords5 = 12.02
coords10 = coords10(coords15, coords8, coords5)
coords19.coords = coords10
coords19.heading = 321.5
coords10 = Config
coords10 = coords10.AttractionsSettings
coords10 = coords10.shootingrange
coords10 = coords10.ticketprice
coords19.ticketprice = coords10
coords19.attractionid = 5
coords19.tickettype = 8
coords10 = Config
coords10 = coords10.AttractionsSettings
coords10 = coords10.shootingrange
coords10 = coords10.disable
coords19.disabled = coords10
coords10 = {}
coords15 = vector3
coords8 = -1669.85
coords5 = -1134.16
coords9 = 12.01
coords15 = coords15(coords8, coords5, coords9)
coords10.coords = coords15
coords10.heading = 247.5
coords15 = Config
coords15 = coords15.AttractionsSettings
coords15 = coords15.shootingrange
coords15 = coords15.ticketprice
coords10.ticketprice = coords15
coords10.attractionid = 5
coords10.tickettype = 8
coords15 = Config
coords15 = coords15.AttractionsSettings
coords15 = coords15.shootingrange
coords15 = coords15.disable
coords10.disabled = coords15
coords15 = {}
coords8 = vector3
coords5 = -1595.73
coords9 = -1098.3
coords22 = 12.01
coords8 = coords8(coords5, coords9, coords22)
coords15.coords = coords8
coords15.heading = 230.5
coords8 = Config
coords8 = coords8.AttractionsSettings
coords8 = coords8.shootingrange
coords8 = coords8.ticketprice
coords15.ticketprice = coords8
coords15.attractionid = 5
coords15.tickettype = 8
coords8 = Config
coords8 = coords8.AttractionsSettings
coords8 = coords8.shootingrange
coords8 = coords8.disable
coords15.disabled = coords8
coords8 = {}
coords5 = vector3
coords9 = -1697.91
coords22 = -1111.28
coords17 = 12.15
coords5 = coords5(coords9, coords22, coords17)
coords8.coords = coords5
coords8.heading = 137.5
coords5 = Config
coords5 = coords5.AttractionsSettings
coords5 = coords5.vortex
coords5 = coords5.ticketprice
coords8.ticketprice = coords5
coords8.attractionid = 7
coords8.tickettype = 3
coords5 = Config
coords5 = coords5.AttractionsSettings
coords5 = coords5.vortex
coords5 = coords5.disable
coords8.disabled = coords5
coords5 = {}
coords9 = vector3
coords22 = -1691.58
coords17 = -1093.49
coords2 = 12.15
coords9 = coords9(coords22, coords17, coords2)
coords5.coords = coords9
coords5.heading = 315.5
coords9 = Config
coords9 = coords9.AttractionsSettings
coords9 = coords9.ferris
coords9 = coords9.ticketprice
coords5.ticketprice = coords9
coords5.attractionid = 8
coords5.tickettype = 6
coords9 = Config
coords9 = coords9.AttractionsSettings
coords9 = coords9.ferris
coords9 = coords9.disable
coords5.disabled = coords9
coords9 = {}
coords22 = vector3
coords17 = -1688.31
coords2 = -1119.0
coords7 = 12.91
coords22 = coords22(coords17, coords2, coords7)
coords9.coords = coords22
coords9.heading = 69.5
coords22 = Config
coords22 = coords22.AttractionsSettings
coords22 = coords22.detonator
coords22 = coords22.ticketprice
coords9.ticketprice = coords22
coords9.attractionid = 9
coords9.tickettype = 4
coords22 = Config
coords22 = coords22.AttractionsSettings
coords22 = coords22.detonator
coords22 = coords22.disable
coords9.disabled = coords22
coords22 = {}
coords17 = vector3
coords2 = -1661.67
coords7 = -1118.84
coords6 = 12.02
coords17 = coords17(coords2, coords7, coords6)
coords22.coords = coords17
coords22.heading = 207.5
coords17 = Config
coords17 = coords17.AttractionsSettings
coords17 = coords17.boat
coords17 = coords17.ticketprice
coords22.ticketprice = coords17
coords22.attractionid = 10
coords22.tickettype = 5
coords17 = Config
coords17 = coords17.AttractionsSettings
coords17 = coords17.boat
coords17 = coords17.disable
coords22.disabled = coords17
coords17 = {}
coords2 = vector3
coords7 = -1601.14
coords6 = -1111.8
coords21 = 12.01
coords2 = coords2(coords7, coords6, coords21)
coords17.coords = coords2
coords17.heading = 48.5
coords2 = Config
coords2 = coords2.AttractionsSettings
coords2 = coords2.prater
coords2 = coords2.ticketprice
coords17.ticketprice = coords2
coords17.attractionid = 11
coords17.tickettype = 10
coords2 = Config
coords2 = coords2.AttractionsSettings
coords2 = coords2.prater
coords2 = coords2.disable
coords17.disabled = coords2
coords2 = {}
coords7 = vector3
coords6 = -1586.13
coords21 = -1104.63
coords12 = 12.01
coords7 = coords7(coords6, coords21, coords12)
coords2.coords = coords7
coords2.heading = 223.5
coords7 = Config
coords7 = coords7.AttractionsSettings
coords7 = coords7.brakedance
coords7 = coords7.ticketprice
coords2.ticketprice = coords7
coords2.attractionid = 12
coords2.tickettype = 11
coords7 = Config
coords7 = coords7.AttractionsSettings
coords7 = coords7.brakedance
coords7 = coords7.disable
coords2.disabled = coords7
coords7 = {}
coords6 = vector3
coords21 = -1584.4
coords12 = -1090.63
coords20 = 12.01
coords6 = coords6(coords21, coords12, coords20)
coords7.coords = coords6
coords7.heading = 312.5
coords6 = Config
coords6 = coords6.AttractionsSettings
coords6 = coords6.slingshot
coords6 = coords6.ticketprice
coords7.ticketprice = coords6
coords7.attractionid = 13
coords7.tickettype = 12
coords6 = Config
coords6 = coords6.AttractionsSettings
coords6 = coords6.slingshot
coords6 = coords6.disable
coords7.disabled = coords6
coords6 = {}
coords21 = vector3
coords12 = -1637.8
coords20 = -1163.99
coords14 = 12.01
coords21 = coords21(coords12, coords20, coords14)
coords6.coords = coords21
coords6.heading = 224.5
coords21 = Config
coords21 = coords21.AttractionsSettings
coords21 = coords21.carousel
coords21 = coords21.ticketprice
coords6.ticketprice = coords21
coords6.attractionid = 14
coords6.tickettype = 13
coords21 = Config
coords21 = coords21.AttractionsSettings
coords21 = coords21.carousel
coords21 = coords21.disable
coords6.disabled = coords21
coords21 = {}
coords12 = vector3
coords20 = -1640.83
coords14 = -1147.46
coords11 = 12.45
coords12 = coords12(coords20, coords14, coords11)
coords21.coords = coords12
coords21.heading = 47.5
coords12 = Config
coords12 = coords12.AttractionsSettings
coords12 = coords12.extasy
coords12 = coords12.ticketprice
coords21.ticketprice = coords12
coords21.attractionid = 15
coords21.tickettype = 14
coords12 = Config
coords12 = coords12.AttractionsSettings
coords12 = coords12.extasy
coords12 = coords12.disable
coords21.disabled = coords12
coords12 = {}
coords20 = vector3
coords14 = -1648.65
coords11 = -1181.3
coords13 = 12.01
coords20 = coords20(coords14, coords11, coords13)
coords12.coords = coords20
coords12.heading = 48.5
coords20 = Config
coords20 = coords20.AttractionsSettings
coords20 = coords20.spinride
coords20 = coords20.ticketprice
coords12.ticketprice = coords20
coords12.attractionid = 16
coords12.tickettype = 15
coords20 = Config
coords20 = coords20.AttractionsSettings
coords20 = coords20.spinride
coords20 = coords20.disable
coords12.disabled = coords20
coords20 = {}
coords14 = vector3
coords11 = -1603.71
coords13 = -1140.61
counter = 13.34
coords14 = coords14(coords11, coords13, counter)
coords20.coords = coords14
coords20.heading = 229.5
coords14 = Config
coords14 = coords14.AttractionsSettings
coords14 = coords14.hauntedhouse
coords14 = coords14.ticketprice
coords20.ticketprice = coords14
coords20.attractionid = 17
coords20.tickettype = 16
coords14 = Config
coords14 = coords14.AttractionsSettings
coords14 = coords14.hauntedhouse
coords14 = coords14.disable
coords20.disabled = coords14
coords14 = {}
coords11 = vector3
coords13 = -1625.51
counter = -1184.38
var1 = 12.01
coords11 = coords11(coords13, counter, var1)
coords14.coords = coords11
coords14.heading = 137.5
coords11 = Config
coords11 = coords11.AttractionsSettings
coords11 = coords11.rollercoaster2
coords11 = coords11.ticketprice
coords14.ticketprice = coords11
coords14.attractionid = 18
coords14.tickettype = 17
coords11 = Config
coords11 = coords11.AttractionsSettings
coords11 = coords11.rollercoaster2
coords11 = coords11.disable
coords14.disabled = coords11
coords11 = {}
coords13 = vector3
counter = -1644.85
var1 = -1188.88
var12 = 12.01
coords13 = coords13(counter, var1, var12)
coords11.coords = coords13
coords11.heading = 139.5
coords13 = Config
coords13 = coords13.AttractionsSettings
coords13 = coords13.cannon
coords13 = coords13.ticketprice
coords11.ticketprice = coords13
coords11.attractionid = 19
coords11.tickettype = 18
coords13 = Config
coords13 = coords13.AttractionsSettings
coords13 = coords13.cannon
coords13 = coords13.disable
coords11.disabled = coords13
coords16[1] = dataTable
coords16[2] = coords18
coords16[3] = coords4
coords16[4] = coords19
coords16[5] = coords10
coords16[6] = coords15
coords16[7] = coords8
coords16[8] = coords5
coords16[9] = coords9
coords16[10] = coords22
coords16[11] = coords17
coords16[12] = coords2
coords16[13] = coords7
coords16[14] = coords6
coords16[15] = coords21
coords16[16] = coords12
coords16[17] = coords20
coords16[18] = coords14
coords16[19] = coords11
ticketmachines = coords16
coords16 = {}
dataTable = {}
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.coords
dataTable.coords = coords18
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.rotation
dataTable.rotation = coords18
dataTable.attractionid = 3
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.label
dataTable.label = coords18
dataTable.using = false
dataTable.smokeactivated = false
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.disablesmoke
dataTable.smokedisabled = coords18
dataTable.turndisabled = false
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.disablemusic
dataTable.musicdisabled = coords18
dataTable.music = false
dataTable.musicurl = ""
dataTable.musicvolume = 100
dataTable.musichandler = nil
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.musiccoords
dataTable.musiccoords = coords18
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.musicmaxdistance
dataTable.musicmaxdistance = coords18
dataTable.handler = nil
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.smokecolor
dataTable.smokecolor = coords18
coords18 = Config
coords18 = coords18.ThemeParkControlMachineSettings
coords18 = coords18.attractions
coords18 = coords18.vortex
coords18 = coords18.smokelocations
dataTable.smokelocations = coords18
coords18 = {}
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.coords
coords18.coords = coords4
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.rotation
coords18.rotation = coords4
coords18.attractionid = 6
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.label
coords18.label = coords4
coords18.using = false
coords18.smokeactivated = false
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.disablesmoke
coords18.smokedisabled = coords4
coords18.turndisabled = true
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.disablemusic
coords18.musicdisabled = coords4
coords18.music = false
coords18.musicurl = ""
coords18.musicvolume = 100
coords18.musichandler = nil
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.musiccoords
coords18.musiccoords = coords4
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.musicmaxdistance
coords18.musicmaxdistance = coords4
coords18.handler = nil
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.smokecolor
coords18.smokecolor = coords4
coords4 = Config
coords4 = coords4.ThemeParkControlMachineSettings
coords4 = coords4.attractions
coords4 = coords4.bumpercars
coords4 = coords4.smokelocations
coords18.smokelocations = coords4
coords4 = {}
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.coords
coords4.coords = coords19
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.rotation
coords4.rotation = coords19
coords4.attractionid = 5
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.label
coords4.label = coords19
coords4.using = false
coords4.smokeactivated = false
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.disablesmoke
coords4.smokedisabled = coords19
coords4.turndisabled = false
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.disablemusic
coords4.musicdisabled = coords19
coords4.music = false
coords4.musicurl = ""
coords4.musicvolume = 100
coords4.musichandler = nil
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.musiccoords
coords4.musiccoords = coords19
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.musicmaxdistance
coords4.musicmaxdistance = coords19
coords4.handler = nil
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.smokecolor
coords4.smokecolor = coords19
coords19 = Config
coords19 = coords19.ThemeParkControlMachineSettings
coords19 = coords19.attractions
coords19 = coords19.boat
coords19 = coords19.smokelocations
coords4.smokelocations = coords19
coords19 = {}
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.coords
coords19.coords = coords10
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.rotation
coords19.rotation = coords10
coords19.attractionid = 8
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.label
coords19.label = coords10
coords19.using = false
coords19.smokeactivated = false
coords19.smokedisabled = true
coords19.turndisabled = false
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.disablemusic
coords19.musicdisabled = coords10
coords19.music = false
coords19.musicurl = ""
coords19.musicvolume = 100
coords19.musichandler = nil
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.musiccoords
coords19.musiccoords = coords10
coords10 = Config
coords10 = coords10.ThemeParkControlMachineSettings
coords10 = coords10.attractions
coords10 = coords10.rollercoaster
coords10 = coords10.musicmaxdistance
coords19.musicmaxdistance = coords10
coords19.handler = nil
coords10 = {}
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.coords
coords10.coords = coords15
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.rotation
coords10.rotation = coords15
coords10.attractionid = 4
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.label
coords10.label = coords15
coords10.using = false
coords10.smokeactivated = false
coords10.smokedisabled = true
coords10.turndisabled = false
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.disablemusic
coords10.musicdisabled = coords15
coords10.music = false
coords10.musicurl = ""
coords10.musicvolume = 100
coords10.musichandler = nil
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.musiccoords
coords10.musiccoords = coords15
coords15 = Config
coords15 = coords15.ThemeParkControlMachineSettings
coords15 = coords15.attractions
coords15 = coords15.detonator
coords15 = coords15.musicmaxdistance
coords10.musicmaxdistance = coords15
coords10.handler = nil
coords15 = {}
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.coords
coords15.coords = coords8
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.rotation
coords15.rotation = coords8
coords15.attractionid = 1
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.label
coords15.label = coords8
coords15.using = false
coords15.smokeactivated = false
coords15.smokedisabled = true
coords15.turndisabled = false
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.disablemusic
coords15.musicdisabled = coords8
coords15.music = false
coords15.musicurl = ""
coords15.musicvolume = 100
coords15.musichandler = nil
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.musiccoords
coords15.musiccoords = coords8
coords8 = Config
coords8 = coords8.ThemeParkControlMachineSettings
coords8 = coords8.attractions
coords8 = coords8.gforce
coords8 = coords8.musicmaxdistance
coords15.musicmaxdistance = coords8
coords15.handler = nil
coords8 = {}
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.coords
coords8.coords = coords5
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.rotation
coords8.rotation = coords5
coords8.attractionid = 2
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.label
coords8.label = coords5
coords8.using = false
coords8.smokeactivated = false
coords8.smokedisabled = true
coords8.turndisabled = false
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.disablemusic
coords8.musicdisabled = coords5
coords8.music = false
coords8.musicurl = ""
coords8.musicvolume = 100
coords8.musichandler = nil
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.musiccoords
coords8.musiccoords = coords5
coords5 = Config
coords5 = coords5.ThemeParkControlMachineSettings
coords5 = coords5.attractions
coords5 = coords5.topscan
coords5 = coords5.musicmaxdistance
coords8.musicmaxdistance = coords5
coords8.handler = nil
coords5 = {}
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.coords
coords5.coords = coords9
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.rotation
coords5.rotation = coords9
coords5.attractionid = 7
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.label
coords5.label = coords9
coords5.using = false
coords5.smokeactivated = false
coords5.smokedisabled = true
coords5.turndisabled = false
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.disablemusic
coords5.musicdisabled = coords9
coords5.music = false
coords5.musicurl = ""
coords5.musicvolume = 100
coords5.musichandler = nil
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.musiccoords
coords5.musiccoords = coords9
coords9 = Config
coords9 = coords9.ThemeParkControlMachineSettings
coords9 = coords9.attractions
coords9 = coords9.ferris
coords9 = coords9.musicmaxdistance
coords5.musicmaxdistance = coords9
coords5.handler = nil
coords9 = {}
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.coords
coords9.coords = coords22
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.rotation
coords9.rotation = coords22
coords9.attractionid = 9
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.label
coords9.label = coords22
coords9.using = false
coords9.smokeactivated = false
coords9.smokedisabled = true
coords9.turndisabled = false
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.disablemusic
coords9.musicdisabled = coords22
coords9.music = false
coords9.musicurl = ""
coords9.musicvolume = 100
coords9.musichandler = nil
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.musiccoords
coords9.musiccoords = coords22
coords22 = Config
coords22 = coords22.ThemeParkControlMachineSettings
coords22 = coords22.attractions
coords22 = coords22.prater
coords22 = coords22.musicmaxdistance
coords9.musicmaxdistance = coords22
coords9.handler = nil
coords22 = {}
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.coords
coords22.coords = coords17
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.rotation
coords22.rotation = coords17
coords22.attractionid = 10
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.label
coords22.label = coords17
coords22.using = false
coords22.smokeactivated = false
coords22.smokedisabled = true
coords22.turndisabled = false
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.disablemusic
coords22.musicdisabled = coords17
coords22.music = false
coords22.musicurl = ""
coords22.musicvolume = 100
coords22.musichandler = nil
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.musiccoords
coords22.musiccoords = coords17
coords17 = Config
coords17 = coords17.ThemeParkControlMachineSettings
coords17 = coords17.attractions
coords17 = coords17.brakedance
coords17 = coords17.musicmaxdistance
coords22.musicmaxdistance = coords17
coords22.handler = nil
coords17 = {}
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.coords
coords17.coords = coords2
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.rotation
coords17.rotation = coords2
coords17.attractionid = 11
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.label
coords17.label = coords2
coords17.using = false
coords17.smokeactivated = false
coords17.smokedisabled = true
coords17.turndisabled = false
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.disablemusic
coords17.musicdisabled = coords2
coords17.music = false
coords17.musicurl = ""
coords17.musicvolume = 100
coords17.musichandler = nil
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.musiccoords
coords17.musiccoords = coords2
coords2 = Config
coords2 = coords2.ThemeParkControlMachineSettings
coords2 = coords2.attractions
coords2 = coords2.slingshot
coords2 = coords2.musicmaxdistance
coords17.musicmaxdistance = coords2
coords17.handler = nil
coords2 = {}
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.coords
coords2.coords = coords7
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.rotation
coords2.rotation = coords7
coords2.attractionid = 12
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.label
coords2.label = coords7
coords2.using = false
coords2.smokeactivated = false
coords2.smokedisabled = true
coords2.turndisabled = false
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.disablemusic
coords2.musicdisabled = coords7
coords2.music = false
coords2.musicurl = ""
coords2.musicvolume = 100
coords2.musichandler = nil
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.musiccoords
coords2.musiccoords = coords7
coords7 = Config
coords7 = coords7.ThemeParkControlMachineSettings
coords7 = coords7.attractions
coords7 = coords7.carousel
coords7 = coords7.musicmaxdistance
coords2.musicmaxdistance = coords7
coords2.handler = nil
coords7 = {}
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.coords
coords7.coords = coords6
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.rotation
coords7.rotation = coords6
coords7.attractionid = 13
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.label
coords7.label = coords6
coords7.using = false
coords7.smokeactivated = false
coords7.smokedisabled = true
coords7.turndisabled = false
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.disablemusic
coords7.musicdisabled = coords6
coords7.music = false
coords7.musicurl = ""
coords7.musicvolume = 100
coords7.musichandler = nil
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.musiccoords
coords7.musiccoords = coords6
coords6 = Config
coords6 = coords6.ThemeParkControlMachineSettings
coords6 = coords6.attractions
coords6 = coords6.extasy
coords6 = coords6.musicmaxdistance
coords7.musicmaxdistance = coords6
coords7.handler = nil
coords6 = {}
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.coords
coords6.coords = coords21
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.rotation
coords6.rotation = coords21
coords6.attractionid = 14
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.label
coords6.label = coords21
coords6.using = false
coords6.smokeactivated = false
coords6.smokedisabled = true
coords6.turndisabled = false
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.disablemusic
coords6.musicdisabled = coords21
coords6.music = false
coords6.musicurl = ""
coords6.musicvolume = 100
coords6.musichandler = nil
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.musiccoords
coords6.musiccoords = coords21
coords21 = Config
coords21 = coords21.ThemeParkControlMachineSettings
coords21 = coords21.attractions
coords21 = coords21.spinride
coords21 = coords21.musicmaxdistance
coords6.musicmaxdistance = coords21
coords6.handler = nil
coords21 = {}
coords12 = Config
coords12 = coords12.ThemeParkControlMachineSettings
coords12 = coords12.attractions
coords12 = coords12.hauntedhouse
coords12 = coords12.coords
coords21.coords = coords12
coords12 = Config
coords12 = coords12.ThemeParkControlMachineSettings
coords12 = coords12.attractions
coords12 = coords12.hauntedhouse
coords12 = coords12.rotation
coords21.rotation = coords12
coords21.attractionid = 15
coords12 = Config
coords12 = coords12.ThemeParkControlMachineSettings
coords12 = coords12.attractions
coords12 = coords12.hauntedhouse
coords12 = coords12.label
coords21.label = coords12
coords21.using = false
coords21.smokeactivated = false
coords21.smokedisabled = true
coords21.turndisabled = false
coords21.musicdisabled = true
coords21.music = false
coords21.musicurl = ""
coords21.musicvolume = 100
coords21.musichandler = nil
coords12 = vector3
coords20 = 0.0
coords14 = 0.0
coords11 = 0.0
coords12 = coords12(coords20, coords14, coords11)
coords21.musiccoords = coords12
coords21.musicmaxdistance = 0.0
coords21.handler = nil
coords12 = {}
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.coords
coords12.coords = coords20
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.rotation
coords12.rotation = coords20
coords12.attractionid = 16
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.label
coords12.label = coords20
coords12.using = false
coords12.smokeactivated = false
coords12.smokedisabled = true
coords12.turndisabled = false
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.disablemusic
coords12.musicdisabled = coords20
coords12.music = false
coords12.musicurl = ""
coords12.musicvolume = 100
coords12.musichandler = nil
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.musiccoords
coords12.musiccoords = coords20
coords20 = Config
coords20 = coords20.ThemeParkControlMachineSettings
coords20 = coords20.attractions
coords20 = coords20.rollercoaster2
coords20 = coords20.musicmaxdistance
coords12.musicmaxdistance = coords20
coords12.handler = nil
coords20 = {}
coords14 = Config
coords14 = coords14.ThemeParkControlMachineSettings
coords14 = coords14.attractions
coords14 = coords14.cannon
coords14 = coords14.coords
coords20.coords = coords14
coords14 = Config
coords14 = coords14.ThemeParkControlMachineSettings
coords14 = coords14.attractions
coords14 = coords14.cannon
coords14 = coords14.rotation
coords20.rotation = coords14
coords20.attractionid = 17
coords14 = Config
coords14 = coords14.ThemeParkControlMachineSettings
coords14 = coords14.attractions
coords14 = coords14.cannon
coords14 = coords14.label
coords20.label = coords14
coords20.using = false
coords20.smokeactivated = false
coords20.smokedisabled = true
coords20.turndisabled = false
coords14 = Config
coords14 = coords14.ThemeParkControlMachineSettings
coords14 = coords14.attractions
coords14 = coords14.cannon
coords14 = coords14.disablemusic
coords20.musicdisabled = coords14
coords20.music = false
coords20.musicurl = ""
coords20.musicvolume = 100
coords20.musichandler = nil
coords14 = vector3
coords11 = 0.0
coords13 = 0.0
counter = 0.0
coords14 = coords14(coords11, coords13, counter)
coords20.musiccoords = coords14
coords20.musicmaxdistance = 0.0
coords20.handler = nil
coords16[1] = dataTable
coords16[2] = coords18
coords16[3] = coords4
coords16[4] = coords19
coords16[5] = coords10
coords16[6] = coords15
coords16[7] = coords8
coords16[8] = coords5
coords16[9] = coords9
coords16[10] = coords22
coords16[11] = coords17
coords16[12] = coords2
coords16[13] = coords7
coords16[14] = coords6
coords16[15] = coords21
coords16[16] = coords12
coords16[17] = coords20
controlmachines = coords16
coords16 = vector3
dataTable = -1646.97
coords18 = -1083.27
coords4 = 12.15
coords16 = coords16(dataTable, coords18, coords4)
inmanagmentmenu = false
nearbymanagmentmenu = false
parkcammanagment = nil
iteminhand = false
iteminhandtype = ""
iteminhandballonid = 1
dataTable = false

function coords18(A0_2)
    local entityCoords2, playerPed5, coords, playerPed2, playerPed6
    entityCoords2 = AddTextEntry
    playerPed5 = "gtavclassicinteractionrtxtheme"
    coords = A0_2
    entityCoords2(playerPed5, coords)
    entityCoords2 = BeginTextCommandDisplayHelp
    playerPed5 = "gtavclassicinteractionrtxtheme"
    entityCoords2(playerPed5)
    entityCoords2 = EndTextCommandDisplayHelp
    playerPed5 = 0
    coords = false
    playerPed2 = true
    playerPed6 = -1
    entityCoords2(playerPed5, coords, playerPed2, playerPed6)
end
ShowGtaClassicInteraction = coords18

function coords18()
    local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2
    dataTable2 = true
    dataTable = dataTable2
    dataTable2 = Config
    dataTable2 = dataTable2.ThemeParkCanBeOwned
    if dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "coords"
        playerPed5 = "themeparkmanagment"
        coords = Config
        coords = coords.ThemeParkOwnedSettings
        coords = coords.themeparkcoords
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.ThemeParkOwnedSettings
        playerPed6 = playerPed6.themeparkdistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.openthemeparkmanagment
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.managmenticon
        entityCoords3 = "rtx_themepark:Global:ManagmentMenuTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = ipairs
    entityCoords2 = ticketmachines
    dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
    for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
        serverId = playerPed6.disabled
        if false == serverId then
            serverId = AddTargetZone
            playerPed4 = "coords"
            entityCoords3 = "themeparkticketbuy"
            playerPed = playerPed2
            playerPed3 = ""
            entityCoords3 = entityCoords3 .. playerPed .. playerPed3
            playerPed = playerPed6.coords
            playerPed3 = 0.0
            entityCoords = Config
            entityCoords = entityCoords.ThemeParkTicketMachineSettings
            entityCoords = entityCoords.usedistance
            isDisabled3 = Language
            isEnabled9 = Config
            isEnabled9 = isEnabled9.Language
            isDisabled3 = isDisabled3[isEnabled9]
            isDisabled3 = isDisabled3.openthemeparkticket
            isEnabled9 = Config
            isEnabled9 = isEnabled9.TargetIcons
            isEnabled9 = isEnabled9.ticketicon
            isEnabled5 = "rtx_themepark:Global:OpenTicketMachineTarget"
            serverId(playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5)
        end
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.bumpercars
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "coords"
        playerPed5 = "themeparkticketbumper"
        coords = bumperhandler
        coords = coords.coordsbuy
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.ThemeParkTicketMachineSettings
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.openthemeparkticket
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.ticketicon
        entityCoords3 = "rtx_themepark:Bumper:OpenTicketTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.rollercoaster
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = ipairs
        entityCoords2 = rollercoasterhandler
        entityCoords2 = entityCoords2.carts
        dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
        for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
            serverId = ipairs
            playerPed4 = playerPed6.platforms
            serverId, playerPed4, entityCoords3, playerPed = serverId(playerPed4)
            for playerPed3, entityCoords in serverId, playerPed4, entityCoords3, playerPed do
                isDisabled3 = AddTargetZone
                isEnabled9 = "coords"
                isEnabled5 = "themeparkrollercoasteruse"
                isEnabled4 = playerPed2
                isEnabled6 = "-"
                isEnabled = playerPed3
                isEnabled8 = ""
                isEnabled5 = isEnabled5 .. isEnabled4 .. isEnabled6 .. isEnabled .. isEnabled8
                isEnabled4 = entityCoords.coords
                isEnabled6 = 0.0
                isEnabled = Config
                isEnabled = isEnabled.AttractionsSettings
                isEnabled = isEnabled.rollercoaster
                isEnabled = isEnabled.usedistance
                isEnabled8 = Language
                isEnabled7 = Config
                isEnabled7 = isEnabled7.Language
                isEnabled8 = isEnabled8[isEnabled7]
                isEnabled8 = isEnabled8.bindrollercoasterseatuse
                isEnabled7 = Config
                isEnabled7 = isEnabled7.TargetIcons
                isEnabled7 = isEnabled7.seaticon
                isDisabled2 = "rtx_themepark:Rollercoaster:SeatUseTarget"
                isDisabled3(isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
            end
        end
    end
    dataTable2 = ipairs
    entityCoords2 = shooterhandler
    entityCoords2 = entityCoords2.shooters
    dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
    for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
        serverId = AddTargetZone
        playerPed4 = "coords"
        entityCoords3 = "themeparkshootingrangeuse"
        playerPed = playerPed2
        playerPed3 = ""
        entityCoords3 = entityCoords3 .. playerPed .. playerPed3
        playerPed = playerPed6.coords
        playerPed3 = 0.0
        entityCoords = Config
        entityCoords = entityCoords.AttractionsSettings
        entityCoords = entityCoords.shootingrange
        entityCoords = entityCoords.usedistance
        isDisabled3 = Language
        isEnabled9 = Config
        isEnabled9 = isEnabled9.Language
        isDisabled3 = isDisabled3[isEnabled9]
        isDisabled3 = isDisabled3.playshootingrange
        isEnabled9 = Config
        isEnabled9 = isEnabled9.TargetIcons
        isEnabled9 = isEnabled9.seaticon
        isEnabled5 = "rtx_themepark:Shooter:UseShooter"
        serverId(playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5)
    end
    dataTable2 = ipairs
    entityCoords2 = Config
    entityCoords2 = entityCoords2.Stands
    dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
    for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
        serverId = AddTargetZone
        playerPed4 = "coords"
        entityCoords3 = "themeparkstandbuy"
        playerPed = playerPed2
        playerPed3 = ""
        entityCoords3 = entityCoords3 .. playerPed .. playerPed3
        playerPed = playerPed6.coords
        playerPed3 = 0.0
        entityCoords = Config
        entityCoords = entityCoords.ThemeParkItemsSettings
        entityCoords = entityCoords.buydistance
        isDisabled3 = Language
        isEnabled9 = Config
        isEnabled9 = isEnabled9.Language
        isDisabled3 = isDisabled3[isEnabled9]
        isDisabled3 = isDisabled3.buyitem
        isEnabled9 = Config
        isEnabled9 = isEnabled9.TargetIcons
        isEnabled9 = isEnabled9.buyicon
        isEnabled5 = "rtx_themepark:Global:BuyStandItemTarget"
        serverId(playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.ThemeParkControlAttractions
    if dataTable2 then
        dataTable2 = ipairs
        entityCoords2 = controlmachines
        dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
        for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
            serverId = AddTargetZone
            playerPed4 = "coords"
            entityCoords3 = "themeparkcontrolmachineuse"
            playerPed = playerPed2
            playerPed3 = ""
            entityCoords3 = entityCoords3 .. playerPed .. playerPed3
            playerPed = playerPed6.coords
            playerPed3 = 0.0
            entityCoords = Config
            entityCoords = entityCoords.ThemeParkControlMachineSettings
            entityCoords = entityCoords.usedistance
            isDisabled3 = Language
            isEnabled9 = Config
            isEnabled9 = isEnabled9.Language
            isDisabled3 = isDisabled3[isEnabled9]
            isDisabled3 = isDisabled3.controlattraction
            isEnabled9 = Config
            isEnabled9 = isEnabled9.TargetIcons
            isEnabled9 = isEnabled9.controlicon
            isEnabled5 = "rtx_themepark:Global:ControlAttractionTarget"
            serverId(playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5)
        end
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.gforce
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkgforceuse"
        coords = "sempre_delperropier_gbooster_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.gforce
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:GForce:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.topscan
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparktopscanuse"
        coords = "sempre_delperropier_topscan_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.topscan
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:TopScan:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.vortex
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkvortexuse"
        coords = "sempre_delperropier_vortex_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.vortex
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Vortex:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.detonator
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkdetonatoruse"
        coords = "sempre_delperropier_detonator_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.detonator
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Detonator:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.boat
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkboatuse"
        coords = "sempre_delperropier_boat_lodka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.boat
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Boat:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.ferris
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkferrisuse"
        coords = "sempre_delperropier_ferris_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.ferris
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Ferris:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.rollercoaster
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkrollercoaster1use"
        coords = "ind_prop_dlc_roller_car"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.rollercoaster
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Rollercoaster:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.rollercoaster
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkrollercoaster12use"
        coords = "ind_prop_dlc_roller_car_02"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.rollercoaster
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Rollercoaster:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.prater
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkprateruse"
        coords = "sempre_delperropier_prater_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.prater
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Prater:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.brakedance
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkbreakdance1use"
        coords = "sempre_delperropier_breakdance_auticko"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.brakedance
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:BrakeDance:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.brakedance
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkbreakdance2use"
        coords = "sempre_delperropier_breakdance_auticko_01"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.brakedance
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:BrakeDance:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.slingshot
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkslingshotuse"
        coords = "sempre_delperropier_slingshot_sedacka"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.slingshot
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:SlingShot:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.carousel
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkcarouseluse"
        coords = "sempre_delperropier_carousel_horse"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.carousel
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Carousel:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.extasy
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkextasyuse"
        coords = "sempre_delperropier_extasy_seat"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.extasy
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Extasy:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.spinride
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkspinrideuse"
        coords = "sempre_delperropier_spinride_seat"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.spinride
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:SpinRide:SeatTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.hauntedhouse
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkhauntedhouseuse"
        coords = "sempre_delperropier_hauntedhouse_vozik"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.hauntedhouse
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:HauntedHouse:SeatUseTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.rollercoaster2
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "model"
        playerPed5 = "themeparkrollercoasteruse"
        coords = "sempre_delperropier_rollercoaster_vozik"
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.rollercoaster2
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Rollercoaster2:SeatUseTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
    dataTable2 = Config
    dataTable2 = dataTable2.AttractionsSettings
    dataTable2 = dataTable2.cannon
    dataTable2 = dataTable2.disable
    if false == dataTable2 then
        dataTable2 = AddTargetZone
        entityCoords2 = "coords"
        playerPed5 = "themeparkcannonuse"
        coords = vector3
        playerPed2 = -1648.38
        playerPed6 = -1195.84
        serverId = 14.2
        coords = coords(playerPed2, playerPed6, serverId)
        playerPed2 = 0.0
        playerPed6 = Config
        playerPed6 = playerPed6.AttractionsSettings
        playerPed6 = playerPed6.cannon
        playerPed6 = playerPed6.usedistance
        serverId = Language
        playerPed4 = Config
        playerPed4 = playerPed4.Language
        serverId = serverId[playerPed4]
        serverId = serverId.bindseatuse
        playerPed4 = Config
        playerPed4 = playerPed4.TargetIcons
        playerPed4 = playerPed4.seaticon
        entityCoords3 = "rtx_themepark:Cannon:SeatUseTarget"
        dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3)
    end
end
CreateTargets = coords18

function coords18()
    local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3
    dataTable2 = {}
    entityCoords2 = ipairs
    playerPed5 = GetActivePlayers
    playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3 = playerPed5()
    entityCoords2, playerPed5, coords, playerPed2 = entityCoords2(playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3)
    for playerPed6, serverId in entityCoords2, playerPed5, coords, playerPed2 do
        playerPed4 = GetPlayerPed
        entityCoords3 = serverId
        playerPed4 = playerPed4(entityCoords3)
        entityCoords3 = DoesEntityExist
        playerPed = playerPed4
        entityCoords3 = entityCoords3(playerPed)
        if entityCoords3 then
            entityCoords3 = table
            entityCoords3 = entityCoords3.insert
            playerPed = dataTable2
            playerPed3 = serverId
            entityCoords3(playerPed, playerPed3)
        end
    end
    return dataTable2
end
GetPlayers = coords18

function coords18(A0_2)
    local entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6
    if nil == A0_2 then
        entityCoords2 = GetEntityCoords
        playerPed5 = GetPlayerPed
        coords = tonumber
        playerPed2 = "-1"
        coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6 = coords(playerPed2)
        playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6 = playerPed5(coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6)
        entityCoords2 = entityCoords2(playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6)
        A0_2 = entityCoords2
    end
    entityCoords2 = GetPlayerFromCoords
    playerPed5 = A0_2
    entityCoords2 = entityCoords2(playerPed5)
    playerPed5 = tonumber
    coords = "-1"
    playerPed5 = playerPed5(coords)
    coords = tonumber
    playerPed2 = "-1"
    coords = coords(playerPed2)
    playerPed2 = 1
    playerPed6 = #entityCoords2
    serverId = 1
    for playerPed4 = playerPed2, playerPed6, serverId do
        entityCoords3 = entityCoords2[playerPed4]
        playerPed = PlayerId
        playerPed = playerPed()
        if entityCoords3 ~= playerPed then
            entityCoords3 = entityCoords2[playerPed4]
            playerPed = tonumber
            playerPed3 = "-1"
            playerPed = playerPed(playerPed3)
            if entityCoords3 ~= playerPed then
                entityCoords3 = GetEntityCoords
                playerPed = GetPlayerPed
                playerPed3 = entityCoords2[playerPed4]
                playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6 = playerPed(playerPed3)
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6)
                playerPed = GetDistanceBetweenCoords
                playerPed3 = entityCoords3.x
                entityCoords = entityCoords3.y
                isDisabled3 = entityCoords3.z
                isEnabled9 = A0_2.x
                isEnabled5 = A0_2.y
                isEnabled4 = A0_2.z
                isEnabled6 = true
                playerPed = playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6)
                playerPed3 = tonumber
                entityCoords = "-1"
                playerPed3 = playerPed3(entityCoords)
                if playerPed5 == playerPed3 or playerPed5 > playerPed then
                    coords = entityCoords2[playerPed4]
                    playerPed5 = playerPed
                end
            end
        end
    end
    playerPed2 = coords
    playerPed6 = playerPed5
    return playerPed2, playerPed6
end
GetClosestPlayer = coords18

function coords18(A0_2, A1_2)
    local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled
    playerPed5 = GetPlayers
    playerPed5 = playerPed5()
    coords = {}
    if nil == A0_2 then
        playerPed2 = GetEntityCoords
        playerPed6 = GetPlayerPed
        serverId = tonumber
        playerPed4 = "-1"
        serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled = serverId(playerPed4)
        playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled = playerPed6(serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled)
        playerPed2 = playerPed2(playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled)
        A0_2 = playerPed2
    end
    if nil == A1_2 then
        playerPed2 = tonumber
        playerPed6 = "5.0"
        playerPed2 = playerPed2(playerPed6)
        A1_2 = playerPed2
    end
    playerPed2 = pairs
    playerPed6 = playerPed5
    playerPed2, playerPed6, serverId, playerPed4 = playerPed2(playerPed6)
    for entityCoords3, playerPed in playerPed2, playerPed6, serverId, playerPed4 do
        playerPed3 = GetPlayerPed
        entityCoords = playerPed
        playerPed3 = playerPed3(entityCoords)
        entityCoords = GetEntityCoords
        isDisabled3 = playerPed3
        entityCoords = entityCoords(isDisabled3)
        isDisabled3 = GetDistanceBetweenCoords
        isEnabled9 = entityCoords
        isEnabled5 = A0_2.x
        isEnabled4 = A0_2.y
        isEnabled6 = A0_2.z
        isEnabled = true
        isDisabled3 = isDisabled3(isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled)
        if A1_2 >= isDisabled3 then
            isEnabled9 = table
            isEnabled9 = isEnabled9.insert
            isEnabled5 = coords
            isEnabled4 = playerPed
            isEnabled9(isEnabled5, isEnabled4)
        end
    end
    return coords
end
GetPlayerFromCoords = coords18

function coords18(A0_2, ...)
    local entityCoords2, playerPed5, coords
    entityCoords2 = string
    entityCoords2 = entityCoords2.format
    playerPed5 = Language
    coords = Config
    coords = coords.Language
    playerPed5 = playerPed5[coords]
    playerPed5 = playerPed5[A0_2]
    coords = ...
    return entityCoords2(playerPed5, coords)
end
LanguageFile2 = coords18

function coords18(A0_2, ...)
    local entityCoords2, playerPed5, coords, playerPed2, playerPed6
    entityCoords2 = tostring
    playerPed5 = LanguageFile2
    coords = A0_2
    playerPed2, playerPed6 = ...
    playerPed5 = playerPed5(coords, playerPed2, playerPed6)
    coords = playerPed5
    playerPed5 = playerPed5.gsub
    playerPed2 = "^%l"
    playerPed6 = string
    playerPed6 = playerPed6.upper
    playerPed5, coords, playerPed2, playerPed6 = playerPed5(coords, playerPed2, playerPed6)
    return entityCoords2(playerPed5, coords, playerPed2, playerPed6)
end
LanguageFile = coords18

function coords18(A0_2, A1_2)
    local playerPed5, coords, playerPed2
    if A1_2 and A1_2 > 0 then
        playerPed5 = 10
        playerPed5 = playerPed5 ^ A1_2
        coords = math
        coords = coords.floor
        playerPed2 = A0_2 * playerPed5
        playerPed2 = playerPed2 + 0.5
        coords = coords(playerPed2)
        coords = coords / playerPed5
        return coords
    end
    playerPed5 = math
    playerPed5 = playerPed5.floor
    coords = A0_2 + 0.5
    return playerPed5(coords)
end
round = coords18

function coords18()
    local dataTable2, entityCoords2
    dataTable2 = usingattraction
    return dataTable2
end
IsPlayerOnRide = coords18
coords18 = false

function coords4()
    local dataTable2, entityCoords2, playerPed5, coords
    dataTable2 = coords18
    if false == dataTable2 then
        dataTable2 = true
        coords18 = dataTable2
        dataTable2 = AddBlipForCoord
        entityCoords2 = Config
        entityCoords2 = entityCoords2.ThemeParkBlip
        entityCoords2 = entityCoords2.blipcoords
        entityCoords2 = entityCoords2.x
        playerPed5 = Config
        playerPed5 = playerPed5.ThemeParkBlip
        playerPed5 = playerPed5.blipcoords
        playerPed5 = playerPed5.y
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipcoords
        coords = coords.z
        dataTable2 = dataTable2(entityCoords2, playerPed5, coords)
        entityCoords2 = SetBlipSprite
        playerPed5 = dataTable2
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipiconid
        entityCoords2(playerPed5, coords)
        entityCoords2 = SetBlipDisplay
        playerPed5 = dataTable2
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipdisplay
        entityCoords2(playerPed5, coords)
        entityCoords2 = SetBlipScale
        playerPed5 = dataTable2
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipscale
        entityCoords2(playerPed5, coords)
        entityCoords2 = SetBlipColour
        playerPed5 = dataTable2
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipcolor
        entityCoords2(playerPed5, coords)
        entityCoords2 = SetBlipAsShortRange
        playerPed5 = dataTable2
        coords = Config
        coords = coords.ThemeParkBlip
        coords = coords.blipshortrange
        entityCoords2(playerPed5, coords)
        entityCoords2 = BeginTextCommandSetBlipName
        playerPed5 = "STRING"
        entityCoords2(playerPed5)
        entityCoords2 = AddTextComponentSubstringPlayerName
        playerPed5 = Config
        playerPed5 = playerPed5.ThemeParkBlip
        playerPed5 = playerPed5.bliptext
        entityCoords2(playerPed5)
        entityCoords2 = EndTextCommandSetBlipName
        playerPed5 = dataTable2
        entityCoords2(playerPed5)
    end
end
CreateThemeParkBlip = coords4
coords4 = RegisterNetEvent
coords19 = "rtx_themepark:Global:AttractionUsing"
coords4(coords19)
coords4 = AddEventHandler
coords19 = "rtx_themepark:Global:AttractionUsing"

function coords10(A0_2)
    local entityCoords2, playerPed5, coords
    usingattraction = A0_2
    entityCoords2 = TriggerServerEvent
    playerPed5 = "rtx_themepark:Global:UsingAttractionPlayer"
    coords = A0_2
    entityCoords2(playerPed5, coords)
end
coords4(coords19, coords10)
coords4 = RegisterNetEvent
coords19 = "rtx_themepark:Notify"
coords4(coords19)
coords4 = AddEventHandler
coords19 = "rtx_themepark:Notify"

function coords10(A0_2)
    local entityCoords2, playerPed5
    entityCoords2 = Notify
    playerPed5 = A0_2
    entityCoords2(playerPed5)
end
coords4(coords19, coords10)
coords4 = RegisterNetEvent
coords19 = "rtx_themepark:Global:TicketHandler"
coords4(coords19)
coords4 = AddEventHandler
coords19 = "rtx_themepark:Global:TicketHandler"

function coords10(A0_2, A1_2)
    local playerPed5
    if 1 == A0_2 then
        playerPed5 = tickets
        playerPed5.gforce = A1_2
    elseif 2 == A0_2 then
        playerPed5 = tickets
        playerPed5.topscan = A1_2
    elseif 3 == A0_2 then
        playerPed5 = tickets
        playerPed5.vortex = A1_2
    elseif 4 == A0_2 then
        playerPed5 = tickets
        playerPed5.detonator = A1_2
    elseif 5 == A0_2 then
        playerPed5 = tickets
        playerPed5.boat = A1_2
    elseif 6 == A0_2 then
        playerPed5 = tickets
        playerPed5.ferris = A1_2
    elseif 7 == A0_2 then
        playerPed5 = tickets
        playerPed5.rollercoaster = A1_2
    elseif 8 == A0_2 then
        playerPed5 = tickets
        playerPed5.shootingrange = A1_2
    elseif 9 == A0_2 then
        playerPed5 = tickets
        playerPed5.bumpercars = A1_2
    elseif 10 == A0_2 then
        playerPed5 = tickets
        playerPed5.prater = A1_2
    elseif 11 == A0_2 then
        playerPed5 = tickets
        playerPed5.brakedance = A1_2
    elseif 12 == A0_2 then
        playerPed5 = tickets
        playerPed5.slingshot = A1_2
    elseif 13 == A0_2 then
        playerPed5 = tickets
        playerPed5.carousel = A1_2
    elseif 14 == A0_2 then
        playerPed5 = tickets
        playerPed5.extasy = A1_2
    elseif 15 == A0_2 then
        playerPed5 = tickets
        playerPed5.spinride = A1_2
    elseif 16 == A0_2 then
        playerPed5 = tickets
        playerPed5.hauntedhouse = A1_2
    elseif 17 == A0_2 then
        playerPed5 = tickets
        playerPed5.rollercoaster2 = A1_2
    elseif 18 == A0_2 then
        playerPed5 = tickets
        playerPed5.cannon = A1_2
    end
end
coords4(coords19, coords10)
coords4 = RegisterNetEvent
coords19 = "rtx_themepark:Global:OpenTicketMachineMenuClient"
coords4(coords19)
coords4 = AddEventHandler
coords19 = "rtx_themepark:Global:OpenTicketMachineMenuClient"

function coords10(A0_2)
    local entityCoords2, playerPed5, coords, playerPed2
    entityCoords2 = inticketmachinemenu
    if false == entityCoords2 then
        entityCoords2 = SendNUIMessage
        playerPed5 = {}
        playerPed5.message = "updateinterfacedata"
        coords = Config
        coords = coords.InterfaceColor
        playerPed5.interfacecolordata = coords
        coords = tostring
        playerPed2 = GetCurrentResourceName
        playerPed2 = playerPed2()
        coords = coords(playerPed2)
        playerPed5.themeparkresourcenamedata = coords
        entityCoords2(playerPed5)
        entityCoords2 = ticketmachines
        entityCoords2 = entityCoords2[A0_2]
        ticketmachineid = A0_2
        inticketmachinemenu = true
        playerPed5 = SetNuiFocus
        coords = true
        playerPed2 = true
        playerPed5(coords, playerPed2)
        playerPed5 = SendNUIMessage
        coords = {}
        coords.message = "attractionbuyticketshow"
        playerPed2 = entityCoords2.ticketprice
        coords.ticketprice = playerPed2
        playerPed5(coords)
    end
end
coords4(coords19, coords10)
coords4 = Config
coords4 = coords4.Target
if true == coords4 then
    coords4 = RegisterNetEvent
    coords19 = "rtx_themepark:Global:OpenTicketMachineTarget"
    coords4(coords19)
    coords4 = AddEventHandler
    coords19 = "rtx_themepark:Global:OpenTicketMachineTarget"

    function coords10()
        local dataTable2, entityCoords2, playerPed5
        dataTable2 = inticketmachinemenu
        if false == dataTable2 then
            dataTable2 = usingattraction
            if false == dataTable2 then
                dataTable2 = nearbyticketmachineid
                if nil ~= dataTable2 then
                    dataTable2 = iteminhand
                    if false == dataTable2 then
                        dataTable2 = TriggerServerEvent
                        entityCoords2 = "rtx_themepark:Global:OpenTicketMachineMenu"
                        playerPed5 = nearbyticketmachineid
                        dataTable2(entityCoords2, playerPed5)
                    else
                        dataTable2 = Notify
                        entityCoords2 = Language
                        playerPed5 = Config
                        playerPed5 = playerPed5.Language
                        entityCoords2 = entityCoords2[playerPed5]
                        entityCoords2 = entityCoords2.iteminhand
                        dataTable2(entityCoords2)
                    end
                end
            end
        end
    end
    coords4(coords19, coords10)
    coords4 = RegisterNetEvent
    coords19 = "rtx_themepark:Global:BuyStandItemTarget"
    coords4(coords19)
    coords4 = AddEventHandler
    coords19 = "rtx_themepark:Global:BuyStandItemTarget"

    function coords10()
        local dataTable2, entityCoords2, playerPed5
        dataTable2 = iteminhand
        if false == dataTable2 then
            dataTable2 = nearbystandid
            if nil ~= dataTable2 then
                dataTable2 = TriggerServerEvent
                entityCoords2 = "rtx_themepark:Global:BuyItemToHand"
                playerPed5 = nearbystandid
                dataTable2(entityCoords2, playerPed5)
                nearbystandid = nil
            end
        end
    end
    coords4(coords19, coords10)
end
coords4 = {}
coords19 = RegisterNetEvent
coords10 = "rtx_themepark:Global:InHandItem"
coords19(coords10)
coords19 = AddEventHandler
coords10 = "rtx_themepark:Global:InHandItem"

function coords15(A0_2, A1_2)
    local playerPed5, coords
    if "hotdog" == A0_2 then
        playerPed5 = IncreaseHunger
        coords = "hotdog"
        playerPed5(coords)
    elseif "juice" == A0_2 then
        playerPed5 = IncreaseHunger
        coords = "juice"
        playerPed5(coords)
    elseif "burger" == A0_2 then
        playerPed5 = IncreaseHunger
        coords = "burger"
        playerPed5(coords)
    elseif "popcorn" == A0_2 then
        playerPed5 = SendNUIMessage
        coords = {}
        coords.message = "iteminhandshow"
        playerPed5(coords)
        iteminhand = true
        iteminhandtype = A0_2
    elseif "cotton" == A0_2 then
        playerPed5 = SendNUIMessage
        coords = {}
        coords.message = "iteminhandshow"
        playerPed5(coords)
        iteminhand = true
        iteminhandtype = A0_2
    elseif "balloon" == A0_2 then
        playerPed5 = SendNUIMessage
        coords = {}
        coords.message = "iteminhandshow"
        playerPed5(coords)
        iteminhandballonid = A1_2
        iteminhand = true
        iteminhandtype = A0_2
    end
end
coords19(coords10, coords15)
coords19 = RegisterNetEvent
coords10 = "rtx_themepark:Global:InHandItemRemoveInterface"
coords19(coords10)
coords19 = AddEventHandler
coords10 = "rtx_themepark:Global:InHandItemRemoveInterface"

function coords15()
    local dataTable2, entityCoords2, playerPed5
    dataTable2 = SendNUIMessage
    entityCoords2 = {}
    entityCoords2.message = "hideiteminhand"
    dataTable2(entityCoords2)
    iteminhand = false
    dataTable2 = PlayerPedId
    dataTable2 = dataTable2()
    entityCoords2 = ClearPedTasks
    playerPed5 = dataTable2
    entityCoords2(playerPed5)
end
coords19(coords10, coords15)
coords19 = RegisterNetEvent
coords10 = "rtx_themepark:Global:GiveHandItem"
coords19(coords10)
coords19 = AddEventHandler
coords10 = "rtx_themepark:Global:GiveHandItem"

function coords15(A0_2, A1_2, A2_2)
    local coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3
    coords = GetPlayerFromServerId
    playerPed2 = A0_2
    coords = coords(playerPed2)
    if -1 ~= coords then
        playerPed2 = GetPlayerPed
        playerPed6 = coords
        playerPed2 = playerPed2(playerPed6)
        playerPed6 = DoesEntityExist
        serverId = playerPed2
        playerPed6 = playerPed6(serverId)
        if playerPed6 then
            playerPed6 = coords4
            playerPed6 = playerPed6[A0_2]
            if nil ~= playerPed6 then
                playerPed6 = DoesEntityExist
                serverId = coords4
                serverId = serverId[A0_2]
                playerPed6 = playerPed6(serverId)
                if playerPed6 then
                    playerPed6 = DeleteEntity
                    serverId = coords4
                    serverId = serverId[A0_2]
                    playerPed6(serverId)
                end
            end
            if "hotdog" == A1_2 then
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = GetHashKey
                playerPed4 = "prop_cs_hotdog_02"
                serverId = serverId(playerPed4)
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 60309
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = -0.03
                isEnabled9 = 0.01
                isEnabled5 = -0.01
                isEnabled4 = 95.1071
                isEnabled6 = 94.7001
                isEnabled = -66.9179
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "mp_player_inteat@burger"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "mp_player_int_eat_burger"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
                playerPed = IncreaseHunger
                playerPed3 = "hotdog"
                playerPed(playerPed3)
            elseif "juice" == A1_2 then
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = GetHashKey
                playerPed4 = "prop_plastic_cup_02"
                serverId = serverId(playerPed4)
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 28422
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = 0.0
                isEnabled9 = 0.0
                isEnabled5 = 0.0
                isEnabled4 = 0.0
                isEnabled6 = 0.0
                isEnabled = 0.0
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "amb@world_human_drinking@coffee@male@idle_a"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "idle_a"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
                playerPed = IncreaseHunger
                playerPed3 = "juice"
                playerPed(playerPed3)
            elseif "burger" == A1_2 then
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = GetHashKey
                playerPed4 = "prop_cs_burger_01"
                serverId = serverId(playerPed4)
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 18905
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = 0.13
                isEnabled9 = 0.05
                isEnabled5 = 0.02
                isEnabled4 = -50.0
                isEnabled6 = 16.0
                isEnabled = 60.0
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "mp_player_inteat@burger"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "mp_player_int_eat_burger"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
                playerPed = IncreaseHunger
                playerPed3 = "burger"
                playerPed(playerPed3)
            elseif "popcorn" == A1_2 then
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = GetHashKey
                playerPed4 = "sempre_delperropier_popcorn_box"
                serverId = serverId(playerPed4)
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 60309
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = 0.103
                isEnabled9 = 0.015
                isEnabled5 = 0.072
                isEnabled4 = -99.949997
                isEnabled6 = 0.0
                isEnabled = 10.4
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "impexp_int - 0"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "mp_m_waremech_01_dual - 0"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
            elseif "cotton" == A1_2 then
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = GetHashKey
                playerPed4 = "sempre_delperropier_candycotton_prop"
                serverId = serverId(playerPed4)
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 60309
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = -0.049
                isEnabled9 = 0.024
                isEnabled5 = 0.018
                isEnabled4 = 62.349998
                isEnabled6 = 0.0
                isEnabled = 20.299999
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "anim@heists@humane_labs@finale@keycards"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "ped_a_enter_loop"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
            elseif "balloon" == A1_2 then
                iteminhandballonid = A2_2
                playerPed6 = GetEntityCoords
                serverId = playerPed2
                playerPed6 = playerPed6(serverId)
                serverId = ""
                if 1 == A2_2 then
                    playerPed4 = GetHashKey
                    entityCoords3 = "sempre_delperropier_balloon_b"
                    playerPed4 = playerPed4(entityCoords3)
                    serverId = playerPed4
                elseif 2 == A2_2 then
                    playerPed4 = GetHashKey
                    entityCoords3 = "sempre_delperropier_balloon_g"
                    playerPed4 = playerPed4(entityCoords3)
                    serverId = playerPed4
                elseif 3 == A2_2 then
                    playerPed4 = GetHashKey
                    entityCoords3 = "sempre_delperropier_balloon_p"
                    playerPed4 = playerPed4(entityCoords3)
                    serverId = playerPed4
                elseif 4 == A2_2 then
                    playerPed4 = GetHashKey
                    entityCoords3 = "sempre_delperropier_balloon_r"
                    playerPed4 = playerPed4(entityCoords3)
                    serverId = playerPed4
                end
                playerPed4 = RequestModel
                entityCoords3 = serverId
                playerPed4(entityCoords3)
                while true do
                    playerPed4 = HasModelLoaded
                    entityCoords3 = serverId
                    playerPed4 = playerPed4(entityCoords3)
                    if playerPed4 then
                        break
                    end
                    playerPed4 = RequestModel
                    entityCoords3 = serverId
                    playerPed4(entityCoords3)
                    playerPed4 = Citizen
                    playerPed4 = playerPed4.Wait
                    entityCoords3 = 5
                    playerPed4(entityCoords3)
                end
                playerPed4 = coords4
                entityCoords3 = CreateObject
                playerPed = serverId
                playerPed3 = playerPed6.x
                entityCoords = playerPed6.y
                isDisabled3 = playerPed6.z
                isDisabled3 = isDisabled3 + 0.2
                isEnabled9 = false
                isEnabled5 = true
                isEnabled4 = true
                entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                playerPed4[A0_2] = entityCoords3
                playerPed4 = GetPedBoneIndex
                entityCoords3 = playerPed2
                playerPed = 60309
                playerPed4 = playerPed4(entityCoords3, playerPed)
                entityCoords3 = AttachEntityToEntity
                playerPed = coords4
                playerPed = playerPed[A0_2]
                playerPed3 = playerPed2
                entityCoords = playerPed4
                isDisabled3 = -0.062
                isEnabled9 = 0.031
                isEnabled5 = 0.038
                isEnabled4 = 63.599998
                isEnabled6 = 0.0
                isEnabled = 18.049999
                isEnabled8 = true
                isEnabled7 = true
                isDisabled2 = false
                isEnabled2 = true
                isDisabled4 = 1
                isEnabled3 = true
                entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3)
                entityCoords3 = "anim@heists@humane_labs@finale@keycards"
                while true do
                    playerPed = HasAnimDictLoaded
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    if playerPed then
                        break
                    end
                    playerPed = RequestAnimDict
                    playerPed3 = entityCoords3
                    playerPed(playerPed3)
                    playerPed = Citizen
                    playerPed = playerPed.Wait
                    playerPed3 = 5
                    playerPed(playerPed3)
                end
                playerPed = TaskPlayAnim
                playerPed3 = playerPed2
                entityCoords = entityCoords3
                isDisabled3 = "ped_a_enter_loop"
                isEnabled9 = 8.0
                isEnabled5 = 8.0
                isEnabled4 = -1
                isEnabled6 = 51
                isEnabled = 0
                isEnabled8 = 0
                isEnabled7 = 0
                isDisabled2 = 0
                playerPed(playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2)
            end
        end
    end
end
coords19(coords10, coords15)
coords19 = RegisterNetEvent
coords10 = "rtx_themepark:Global:RemoveHandItem"
coords19(coords10)
coords19 = AddEventHandler
coords10 = "rtx_themepark:Global:RemoveHandItem"

function coords15(A0_2, A1_2, A2_2)
    local coords, playerPed2, playerPed6, serverId
    coords = GetPlayerFromServerId
    playerPed2 = A0_2
    coords = coords(playerPed2)
    if -1 ~= coords then
        playerPed2 = GetPlayerPed
        playerPed6 = coords
        playerPed2 = playerPed2(playerPed6)
        playerPed6 = DoesEntityExist
        serverId = playerPed2
        playerPed6 = playerPed6(serverId)
        if playerPed6 then
            playerPed6 = coords4
            playerPed6 = playerPed6[A0_2]
            if nil ~= playerPed6 then
                playerPed6 = DoesEntityExist
                serverId = coords4
                serverId = serverId[A0_2]
                playerPed6 = playerPed6(serverId)
                if playerPed6 then
                    playerPed6 = DeleteEntity
                    serverId = coords4
                    serverId = serverId[A0_2]
                    playerPed6(serverId)
                end
                playerPed6 = ClearPedTasks
                serverId = playerPed2
                playerPed6(serverId)
            end
        end
    end
end
coords19(coords10, coords15)
coords19 = RegisterNetEvent
coords10 = "rtx_themepark:Global:RemoveHandItemThrow"
coords19(coords10)
coords19 = AddEventHandler
coords10 = "rtx_themepark:Global:RemoveHandItemThrow"

function coords15(A0_2, A1_2, A2_2)
    local coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7
    coords = GetPlayerFromServerId
    playerPed2 = A0_2
    coords = coords(playerPed2)
    if -1 ~= coords then
        playerPed2 = GetPlayerPed
        playerPed6 = coords
        playerPed2 = playerPed2(playerPed6)
        playerPed6 = DoesEntityExist
        serverId = playerPed2
        playerPed6 = playerPed6(serverId)
        if playerPed6 then
            playerPed6 = coords4
            playerPed6 = playerPed6[A0_2]
            if nil ~= playerPed6 then
                playerPed6 = DoesEntityExist
                serverId = coords4
                serverId = serverId[A0_2]
                playerPed6 = playerPed6(serverId)
                if playerPed6 then
                    playerPed6 = DeleteEntity
                    serverId = coords4
                    serverId = serverId[A0_2]
                    playerPed6(serverId)
                end
                playerPed6 = ClearPedTasks
                serverId = playerPed2
                playerPed6(serverId)
                if "baloon" == A1_2 then
                    playerPed6 = ""
                    if 1 == A2_2 then
                        serverId = GetHashKey
                        playerPed4 = "sempre_delperropier_balloon_b"
                        serverId = serverId(playerPed4)
                        playerPed6 = serverId
                    elseif 2 == A2_2 then
                        serverId = GetHashKey
                        playerPed4 = "sempre_delperropier_balloon_g"
                        serverId = serverId(playerPed4)
                        playerPed6 = serverId
                    elseif 3 == A2_2 then
                        serverId = GetHashKey
                        playerPed4 = "sempre_delperropier_balloon_p"
                        serverId = serverId(playerPed4)
                        playerPed6 = serverId
                    elseif 4 == A2_2 then
                        serverId = GetHashKey
                        playerPed4 = "sempre_delperropier_balloon_r"
                        serverId = serverId(playerPed4)
                        playerPed6 = serverId
                    end
                    serverId = RequestModel
                    playerPed4 = playerPed6
                    serverId(playerPed4)
                    while true do
                        serverId = HasModelLoaded
                        playerPed4 = playerPed6
                        serverId = serverId(playerPed4)
                        if serverId then
                            break
                        end
                        serverId = RequestModel
                        playerPed4 = playerPed6
                        serverId(playerPed4)
                        serverId = Citizen
                        serverId = serverId.Wait
                        playerPed4 = 5
                        serverId(playerPed4)
                    end
                    serverId = GetPedBoneIndex
                    playerPed4 = playerPed2
                    entityCoords3 = 60309
                    serverId = serverId(playerPed4, entityCoords3)
                    playerPed4 = GetWorldPositionOfEntityBone
                    entityCoords3 = playerPed2
                    playerPed = serverId
                    playerPed4 = playerPed4(entityCoords3, playerPed)
                    entityCoords3 = CreateObject
                    playerPed = playerPed6
                    playerPed3 = playerPed4.x
                    entityCoords = playerPed4.y
                    isDisabled3 = playerPed4.z
                    isEnabled9 = false
                    isEnabled5 = true
                    isEnabled4 = true
                    entityCoords3 = entityCoords3(playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4)
                    playerPed = FreezeEntityPosition
                    playerPed3 = entityCoords3
                    entityCoords = true
                    playerPed(playerPed3, entityCoords)
                    playerPed = GetEntityCoords
                    playerPed3 = entityCoords3
                    playerPed = playerPed(playerPed3)
                    playerPed3 = playerPed.z
                    entityCoords = playerPed.z
                    entityCoords = entityCoords + 100.0
                    isDisabled3 = ClearPedTasks
                    isEnabled9 = playerPed2
                    isDisabled3(isEnabled9)
                    while playerPed3 < entityCoords do
                        isDisabled3 = Citizen
                        isDisabled3 = isDisabled3.Wait
                        isEnabled9 = 25
                        isDisabled3(isEnabled9)
                        playerPed3 = playerPed3 + 0.1
                        isDisabled3 = SetEntityCoordsNoOffset
                        isEnabled9 = entityCoords3
                        isEnabled5 = playerPed.x
                        isEnabled4 = playerPed.y
                        isEnabled6 = playerPed3
                        isEnabled = true
                        isEnabled8 = false
                        isEnabled7 = false
                        isDisabled3(isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7)
                    end
                    isDisabled3 = DeleteEntity
                    isEnabled9 = entityCoords3
                    isDisabled3(isEnabled9)
                end
            end
        end
    end
end
coords19(coords10, coords15)
coords19 = RegisterNUICallback
coords10 = "buythemeparkticket"

function coords15(A0_2, A1_2)
    local playerPed5, coords, playerPed2
    playerPed5 = inticketmachinemenu
    if true == playerPed5 then
        playerPed5 = ticketmachineid
        if nil ~= playerPed5 then
            playerPed5 = TriggerServerEvent
            coords = "rtx_themepark:Global:ThemeParkBuyTicket"
            playerPed2 = ticketmachineid
            playerPed5(coords, playerPed2)
            ticketmachineid = nil
            inticketmachinemenu = false
            playerPed5 = SetNuiFocus
            coords = false
            playerPed2 = false
            playerPed5(coords, playerPed2)
            playerPed5 = SendNUIMessage
            coords = {}
            coords.message = "hideticket"
            playerPed5(coords)
        end
    end
    playerPed5 = A1_2
    coords = "ok"
    playerPed5(coords)
end
coords19(coords10, coords15)
coords19 = RegisterNUICallback
coords10 = "closethemeparkticket"

function coords15(A0_2, A1_2)
    local playerPed5, coords, playerPed2
    playerPed5 = inticketmachinemenu
    if true == playerPed5 then
        ticketmachineid = nil
        inticketmachinemenu = false
        playerPed5 = SetNuiFocus
        coords = false
        playerPed2 = false
        playerPed5(coords, playerPed2)
        playerPed5 = SendNUIMessage
        coords = {}
        coords.message = "hideticket"
        playerPed5(coords)
    end
    playerPed5 = A1_2
    coords = "ok"
    playerPed5(coords)
end
coords19(coords10, coords15)
coords19 = Citizen
coords19 = coords19.CreateThread

function coords10()
    local dataTable2, entityCoords2
    while true do
        dataTable2 = NetworkIsPlayerActive
        entityCoords2 = PlayerId
        entityCoords2 = entityCoords2()
        dataTable2 = dataTable2(entityCoords2)
        if dataTable2 then
            dataTable2 = NetworkIsSessionStarted
            dataTable2 = dataTable2()
            if dataTable2 then
                break
            end
        end
        dataTable2 = Citizen
        dataTable2 = dataTable2.Wait
        entityCoords2 = 250
        dataTable2(entityCoords2)
        dataTable2 = GetFrameCount
        dataTable2 = dataTable2()
        oldframes = dataTable2
        dataTable2 = GetGameTimer
        dataTable2 = dataTable2()
        oldtime = dataTable2
    end
    while true do
        dataTable2 = GetGameTimer
        dataTable2 = dataTable2()
        currenttime = dataTable2
        dataTable2 = GetFrameCount
        dataTable2 = dataTable2()
        currentframes = dataTable2
        dataTable2 = currenttime
        entityCoords2 = oldtime
        dataTable2 = dataTable2 - entityCoords2
        entityCoords2 = 1000
        if dataTable2 > entityCoords2 then
            dataTable2 = currentframes
            entityCoords2 = oldframes
            dataTable2 = dataTable2 - entityCoords2
            dataTable2 = dataTable2 - 1
            currentfps = dataTable2
            dataTable2 = currenttime
            oldtime = dataTable2
            dataTable2 = currentframes
            oldframes = dataTable2
        end
        dataTable2 = usingattraction
        if false == dataTable2 then
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 1000
            dataTable2(entityCoords2)
        else
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 50
            dataTable2(entityCoords2)
        end
        dataTable2 = nearbythemepark
        if false == dataTable2 then
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 500
            dataTable2(entityCoords2)
        end
    end
end
coords19(coords10)
coords19 = Citizen
coords19 = coords19.CreateThread

function coords10()
    local dataTable2, entityCoords2, playerPed5, coords
    while true do
        dataTable2 = Citizen
        dataTable2 = dataTable2.Wait
        entityCoords2 = 1000
        dataTable2(entityCoords2)
        dataTable2 = NetworkIsSessionStarted
        dataTable2 = dataTable2()
        if dataTable2 then
            dataTable2 = NetworkIsPlayerActive
            entityCoords2 = PlayerId
            entityCoords2, playerPed5, coords = entityCoords2()
            dataTable2 = dataTable2(entityCoords2, playerPed5, coords)
            if dataTable2 then
                dataTable2 = SendNUIMessage
                entityCoords2 = {}
                entityCoords2.message = "updateinterfacedata"
                playerPed5 = Config
                playerPed5 = playerPed5.InterfaceColor
                entityCoords2.interfacecolordata = playerPed5
                playerPed5 = tostring
                coords = GetCurrentResourceName
                coords = coords()
                playerPed5 = playerPed5(coords)
                entityCoords2.themeparkresourcenamedata = playerPed5
                dataTable2(entityCoords2)
                return
            end
        end
    end
end
coords19(coords10)
coords19 = Citizen
coords19 = coords19.CreateThread

function coords10()
    local dataTable2, entityCoords2, playerPed5
    while true do
        dataTable2 = Citizen
        dataTable2 = dataTable2.Wait
        entityCoords2 = 500
        dataTable2(entityCoords2)
        dataTable2 = nearbythemepark
        if true == dataTable2 then
            dataTable2 = PlayerPedId
            dataTable2 = dataTable2()
            entityCoords2 = GetEntityCoords
            playerPed5 = dataTable2
            entityCoords2 = entityCoords2(playerPed5)
            playercurrentcoords = entityCoords2
        else
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 1000
            dataTable2(entityCoords2)
        end
    end
end
coords19(coords10)
coords19 = false

function coords10()
    local dataTable2, entityCoords2
    dataTable2 = coords19
    if dataTable2 then
        return
    end
    dataTable2 = true
    coords19 = dataTable2
    dataTable2 = TriggerServerEvent
    entityCoords2 = "rtx_themepark:Global:ParkSynchronize"
    dataTable2(entityCoords2)
    dataTable2 = dataTable
    if false == dataTable2 then
        dataTable2 = Config
        dataTable2 = dataTable2.Target
        if true == dataTable2 then
            dataTable2 = CreateTargets
            dataTable2()
        end
    end
    dataTable2 = Config
    dataTable2 = dataTable2.ThemeParkBlip
    dataTable2 = dataTable2.blip
    if true == dataTable2 then
        dataTable2 = CreateThemeParkBlip
        dataTable2()
    end
end
InitializeThemePark = coords10
coords10 = AddEventHandler
coords15 = "playerSpawned"

function coords8()
    local dataTable2, entityCoords2
    dataTable2 = Citizen
    dataTable2 = dataTable2.CreateThread

    function entityCoords2()
        local condition, func
        condition = Citizen
        condition = condition.Wait
        func = 2000
        condition(func)
        condition = InitializeThemePark
        condition()
    end
    dataTable2(entityCoords2)
end
coords10(coords15, coords8)
coords10 = AddEventHandler
coords15 = "onClientResourceStart"

function coords8(A0_2)
    local entityCoords2, playerPed5
    entityCoords2 = GetCurrentResourceName
    entityCoords2 = entityCoords2()
    if A0_2 == entityCoords2 then
        entityCoords2 = Citizen
        entityCoords2 = entityCoords2.CreateThread

        function playerPed5()
            local condition, func
            while true do
                condition = NetworkIsPlayerActive
                func = PlayerId
                func = func()
                condition = condition(func)
                if condition then
                    condition = DoesEntityExist
                    func = PlayerPedId
                    func = func()
                    condition = condition(func)
                    if condition then
                        break
                    end
                end
                condition = Citizen
                condition = condition.Wait
                func = 500
                condition(func)
            end
            condition = Citizen
            condition = condition.Wait
            func = 1000
            condition(func)
            condition = InitializeThemePark
            condition()
        end
        entityCoords2(playerPed5)
    end
end
coords10(coords15, coords8)
coords10 = Citizen
coords10 = coords10.CreateThread

function coords15()
    local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6
    while true do
        dataTable2 = Citizen
        dataTable2 = dataTable2.Wait
        entityCoords2 = 2500
        dataTable2(entityCoords2)
        dataTable2 = NetworkIsSessionStarted
        dataTable2 = dataTable2()
        if dataTable2 then
            dataTable2 = NetworkIsPlayerActive
            entityCoords2 = PlayerId
            entityCoords2, playerPed5, coords, playerPed2, playerPed6 = entityCoords2()
            dataTable2 = dataTable2(entityCoords2, playerPed5, coords, playerPed2, playerPed6)
            if dataTable2 then
                dataTable2 = PlayerPedId
                dataTable2 = dataTable2()
                entityCoords2 = GetEntityCoords
                playerPed5 = dataTable2
                entityCoords2 = entityCoords2(playerPed5)
                playerPed5 = coords16
                playerPed5 = entityCoords2 - playerPed5
                playerPed5 = #playerPed5
                coords = Config
                coords = coords.MaximumParkDistance
                if playerPed5 < coords then
                    coords = nearbythemepark
                    if false == coords then
                        nearbythemepark = true
                        coords = TriggerServerEvent
                        playerPed2 = "rtx_themepark:Global:ParkResync"
                        coords(playerPed2)
                        coords = TriggerServerEvent
                        playerPed2 = "rtx_themepark:Global:NearbyThemeParkHandler"
                        playerPed6 = true
                        coords(playerPed2, playerPed6)
                        coords = IsIplActive
                        playerPed2 = "ferris_finale_anim"
                        coords = coords(playerPed2)
                        if coords then
                            coords = RemoveIpl
                            playerPed2 = "ferris_finale_anim"
                            coords(playerPed2)
                        end
                    end
                else
                    coords = nearbythemepark
                    if true == coords then
                        coords = TriggerServerEvent
                        playerPed2 = "rtx_themepark:Global:NearbyThemeParkHandler"
                        playerPed6 = false
                        coords(playerPed2, playerPed6)
                        nearbythemepark = false
                    end
                end
            end
        end
    end
end
coords10(coords15)
coords10 = Config
coords10 = coords10.ThemeParkCanBeOwned
if coords10 then
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ParkOwned"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ParkOwned"

    function coords8(A0_2)
        local entityCoords2
        entityCoords2 = themeparkowned
        entityCoords2.owned = A0_2
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ParkOwn"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ParkOwn"

    function coords8(A0_2)
        local entityCoords2
        entityCoords2 = themeparkowned
        entityCoords2.own = A0_2
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ManagmentMenuUpdate"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ManagmentMenuUpdate"

    function coords8(A0_2)
        local entityCoords2, playerPed5
        entityCoords2 = inmanagmentmenu
        if true == entityCoords2 then
            entityCoords2 = SendNUIMessage
            playerPed5 = {}
            playerPed5.message = "updateparkbalance"
            playerPed5.parkbalance = A0_2
            entityCoords2(playerPed5)
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuClient"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuClient"

    function coords8(A0_2)
        local entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords
        entityCoords2 = inmanagmentmenu
        if false == entityCoords2 then
            inmanagmentmenu = true
            entityCoords2 = SetNuiFocus
            playerPed5 = true
            coords = true
            entityCoords2(playerPed5, coords)
            entityCoords2 = CreateCamWithParams
            playerPed5 = "DEFAULT_SCRIPTED_CAMERA"
            coords = -1673.0793255157
            playerPed2 = -1102.1116497344
            playerPed6 = 140.49196777344
            serverId = -89.811023622751
            playerPed4 = 0.0
            entityCoords3 = -129.70078587532
            playerPed = 78.0
            playerPed3 = true
            entityCoords = 2
            entityCoords2 = entityCoords2(playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords)
            parkcammanagment = entityCoords2
            entityCoords2 = SetCamActive
            playerPed5 = parkcammanagment
            coords = true
            entityCoords2(playerPed5, coords)
            entityCoords2 = RenderScriptCams
            playerPed5 = true
            coords = 2500
            playerPed2 = 2500
            playerPed6 = true
            serverId = false
            entityCoords2(playerPed5, coords, playerPed2, playerPed6, serverId)
            entityCoords2 = Citizen
            entityCoords2 = entityCoords2.Wait
            playerPed5 = 2500
            entityCoords2(playerPed5)
            entityCoords2 = SendNUIMessage
            playerPed5 = {}
            playerPed5.message = "updateinterfacedata"
            coords = Config
            coords = coords.InterfaceColor
            playerPed5.interfacecolordata = coords
            coords = tostring
            playerPed2 = GetCurrentResourceName
            playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords = playerPed2()
            coords = coords(playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords)
            playerPed5.themeparkresourcenamedata = coords
            entityCoords2(playerPed5)
            entityCoords2 = Config
            entityCoords2 = entityCoords2.ThemeParkOwnedSettings
            entityCoords2 = entityCoords2.enablepermissionsystem
            if false == entityCoords2 then
                entityCoords2 = SendNUIMessage
                playerPed5 = {}
                playerPed5.message = "parkmanagmentmainshow"
                playerPed5.parkbalance = A0_2
                coords = Config
                coords = coords.ThemeParkOwnedSettings
                coords = coords.disablesell
                playerPed5.selldisable = coords
                coords = Config
                coords = coords.ThemeParkOwnedSettings
                coords = coords.disabletransfer
                playerPed5.transferdisable = coords
                entityCoords2(playerPed5)
            else
                entityCoords2 = SendNUIMessage
                playerPed5 = {}
                playerPed5.message = "parkmanagmentmainshow"
                playerPed5.parkbalance = A0_2
                playerPed5.selldisable = true
                playerPed5.transferdisable = true
                entityCoords2(playerPed5)
            end
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractionsClient"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractionsClient"

    function coords8(A0_2)
        local entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords
        entityCoords2 = inmanagmentmenu
        if true == entityCoords2 then
            entityCoords2 = ipairs
            playerPed5 = A0_2
            entityCoords2, playerPed5, coords, playerPed2 = entityCoords2(playerPed5)
            for playerPed6, serverId in entityCoords2, playerPed5, coords, playerPed2 do
                playerPed4 = SendNUIMessage
                entityCoords3 = {}
                entityCoords3.message = "changeattractionstatus"
                playerPed = "parkattractionopendata"
                playerPed3 = playerPed6
                entityCoords = ""
                playerPed = playerPed .. playerPed3 .. entityCoords
                entityCoords3.attractionstatusname = playerPed
                entityCoords3.attractionhandler = serverId
                playerPed4(entityCoords3)
            end
        end
    end
    coords10(coords15, coords8)
    coords10 = Config
    coords10 = coords10.Target
    if true == coords10 then
        coords10 = RegisterNetEvent
        coords15 = "rtx_themepark:Global:ManagmentMenuTarget"
        coords10(coords15)
        coords10 = AddEventHandler
        coords15 = "rtx_themepark:Global:ManagmentMenuTarget"

        function coords8()
            local dataTable2, entityCoords2, playerPed5
            dataTable2 = inmanagmentmenu
            if false == dataTable2 then
                dataTable2 = usingattraction
                if false == dataTable2 then
                    dataTable2 = nearbymanagmentmenu
                    if true == dataTable2 then
                        dataTable2 = iteminhand
                        if false == dataTable2 then
                            dataTable2 = themeparkowned
                            dataTable2 = dataTable2.owned
                            if false == dataTable2 then
                                dataTable2 = Config
                                dataTable2 = dataTable2.ThemeParkOwnedSettings
                                dataTable2 = dataTable2.enablepermissionsystem
                                if false == dataTable2 then
                                    inmanagmentmenu = true
                                    dataTable2 = SetNuiFocus
                                    entityCoords2 = true
                                    playerPed5 = true
                                    dataTable2(entityCoords2, playerPed5)
                                    dataTable2 = SendNUIMessage
                                    entityCoords2 = {}
                                    entityCoords2.message = "parkbuyshow"
                                    playerPed5 = Config
                                    playerPed5 = playerPed5.ThemeParkOwnedSettings
                                    playerPed5 = playerPed5.themeparkprice
                                    entityCoords2.parkprice = playerPed5
                                    dataTable2(entityCoords2)
                                end
                            else
                                dataTable2 = themeparkowned
                                dataTable2 = dataTable2.own
                                if true ~= dataTable2 then
                                    dataTable2 = Config
                                    dataTable2 = dataTable2.ThemeParkOwnedSettings
                                    dataTable2 = dataTable2.enablepermissionsystem
                                end
                                if true == dataTable2 then
                                    dataTable2 = TriggerServerEvent
                                    entityCoords2 = "rtx_themepark:Global:OpenThemeParkManagmentMenu"
                                    dataTable2(entityCoords2)
                                end
                            end
                        else
                            dataTable2 = Notify
                            entityCoords2 = Language
                            playerPed5 = Config
                            playerPed5 = playerPed5.Language
                            entityCoords2 = entityCoords2[playerPed5]
                            entityCoords2 = entityCoords2.iteminhand
                            dataTable2(entityCoords2)
                        end
                    end
                end
            end
        end
        coords10(coords15, coords8)
    end
    coords10 = Citizen
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 0
            dataTable2(entityCoords2)
            dataTable2 = true
            entityCoords2 = false
            playerPed5 = inmanagmentmenu
            if false == playerPed5 then
                playerPed5 = usingattraction
                if false == playerPed5 then
                    playerPed5 = nearbythemepark
                    if true == playerPed5 then
                        playerPed5 = themeparkowned
                        playerPed5 = playerPed5.owned
                        if false ~= playerPed5 then
                            playerPed5 = themeparkowned
                            playerPed5 = playerPed5.own
                            if true ~= playerPed5 then
                                playerPed5 = Config
                                playerPed5 = playerPed5.ThemeParkOwnedSettings
                                playerPed5 = playerPed5.enablepermissionsystem
                                if true ~= playerPed5 then
                                    goto lbl_43
                                end
                            end
                        end
                        playerPed5 = playercurrentcoords
                        coords = Config
                        coords = coords.ThemeParkOwnedSettings
                        coords = coords.themeparkcoords
                        playerPed5 = playerPed5 - coords
                        playerPed5 = #playerPed5
                        coords = Config
                        coords = coords.ThemeParkOwnedSettings
                        coords = coords.themeparkdistance
                        if playerPed5 < coords then
                            entityCoords2 = true
                            nearbymanagmentmenu = true
                        end
                    end
                end
            end
            ::lbl_43::
            if entityCoords2 then
                dataTable2 = false
                playerPed5 = Config
                playerPed5 = playerPed5.Target
                if false == playerPed5 then
                    playerPed5 = themeparkowned
                    playerPed5 = playerPed5.owned
                    if false == playerPed5 then
                        playerPed5 = Config
                        playerPed5 = playerPed5.ThemeParkOwnedSettings
                        playerPed5 = playerPed5.enablepermissionsystem
                        if false == playerPed5 then
                            playerPed5 = Config
                            playerPed5 = playerPed5.ThemeParkInteractionSystem
                            if 1 == playerPed5 then
                                playerPed5 = SendNUIMessage
                                coords = {}
                                coords.message = "infonotifyshow"
                                playerPed2 = Language
                                playerPed6 = Config
                                playerPed6 = playerPed6.Language
                                playerPed2 = playerPed2[playerPed6]
                                playerPed2 = playerPed2.pressforbuythemeparkinteract
                                coords.infonotifytext = playerPed2
                                playerPed5(coords)
                            else
                                playerPed5 = Config
                                playerPed5 = playerPed5.ThemeParkInteractionSystem
                                if 2 == playerPed5 then
                                    playerPed5 = DrawText3D
                                    coords = Config
                                    coords = coords.ThemeParkOwnedSettings
                                    coords = coords.themeparkcoords
                                    coords = coords.x
                                    playerPed2 = Config
                                    playerPed2 = playerPed2.ThemeParkOwnedSettings
                                    playerPed2 = playerPed2.themeparkcoords
                                    playerPed2 = playerPed2.y
                                    playerPed6 = Config
                                    playerPed6 = playerPed6.ThemeParkOwnedSettings
                                    playerPed6 = playerPed6.themeparkcoords
                                    playerPed6 = playerPed6.z
                                    playerPed6 = playerPed6 + 1.0
                                    serverId = Language
                                    playerPed4 = Config
                                    playerPed4 = playerPed4.Language
                                    serverId = serverId[playerPed4]
                                    serverId = serverId.pressforbuythemepark
                                    playerPed5(coords, playerPed2, playerPed6, serverId)
                                else
                                    playerPed5 = Config
                                    playerPed5 = playerPed5.ThemeParkInteractionSystem
                                    if 3 == playerPed5 then
                                        playerPed5 = ShowGtaClassicInteraction
                                        coords = Language
                                        playerPed2 = Config
                                        playerPed2 = playerPed2.Language
                                        coords = coords[playerPed2]
                                        coords = coords.pressforbuythemeparkinteractclassic
                                        playerPed5(coords)
                                    end
                                end
                            end
                        end
                    else
                        playerPed5 = themeparkowned
                        playerPed5 = playerPed5.own
                        if true ~= playerPed5 then
                            playerPed5 = Config
                            playerPed5 = playerPed5.ThemeParkOwnedSettings
                            playerPed5 = playerPed5.enablepermissionsystem
                        end
                        if true == playerPed5 then
                            playerPed5 = Config
                            playerPed5 = playerPed5.ThemeParkInteractionSystem
                            if 1 == playerPed5 then
                                playerPed5 = SendNUIMessage
                                coords = {}
                                coords.message = "infonotifyshow"
                                playerPed2 = Language
                                playerPed6 = Config
                                playerPed6 = playerPed6.Language
                                playerPed2 = playerPed2[playerPed6]
                                playerPed2 = playerPed2.pressformanagmentthemeparkinteract
                                coords.infonotifytext = playerPed2
                                playerPed5(coords)
                            else
                                playerPed5 = Config
                                playerPed5 = playerPed5.ThemeParkInteractionSystem
                                if 2 == playerPed5 then
                                    playerPed5 = DrawText3D
                                    coords = Config
                                    coords = coords.ThemeParkOwnedSettings
                                    coords = coords.themeparkcoords
                                    coords = coords.x
                                    playerPed2 = Config
                                    playerPed2 = playerPed2.ThemeParkOwnedSettings
                                    playerPed2 = playerPed2.themeparkcoords
                                    playerPed2 = playerPed2.y
                                    playerPed6 = Config
                                    playerPed6 = playerPed6.ThemeParkOwnedSettings
                                    playerPed6 = playerPed6.themeparkcoords
                                    playerPed6 = playerPed6.z
                                    playerPed6 = playerPed6 + 1.0
                                    serverId = Language
                                    playerPed4 = Config
                                    playerPed4 = playerPed4.Language
                                    serverId = serverId[playerPed4]
                                    serverId = serverId.pressformanagmentthemepark
                                    playerPed5(coords, playerPed2, playerPed6, serverId)
                                else
                                    playerPed5 = Config
                                    playerPed5 = playerPed5.ThemeParkInteractionSystem
                                    if 3 == playerPed5 then
                                        playerPed5 = ShowGtaClassicInteraction
                                        coords = Language
                                        playerPed2 = Config
                                        playerPed2 = playerPed2.Language
                                        coords = coords[playerPed2]
                                        playerPed2 = "pressformanagmentthemeparkinteractclassic"
                                        coords = coords[playerPed2]
                                        playerPed5(coords)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                nearbymanagmentmenu = false
                playerPed5 = Config
                playerPed5 = playerPed5.ThemeParkInteractionSystem
                if 1 == playerPed5 then
                    playerPed5 = SendNUIMessage
                    coords = {}
                    coords.message = "hide"
                    playerPed5(coords)
                end
            end
            if dataTable2 then
                playerPed5 = Citizen
                playerPed5 = playerPed5.Wait
                coords = 1000
                playerPed5(coords)
            end
        end
    end
    coords10(coords15)
    coords10 = RegisterNUICallback
    coords15 = "closemanagment"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = SetNuiFocus
            coords = false
            playerPed2 = false
            playerPed5(coords, playerPed2)
            playerPed5 = themeparkowned
            playerPed5 = playerPed5.owned
            if false == playerPed5 then
                playerPed5 = Config
                playerPed5 = playerPed5.ThemeParkOwnedSettings
                playerPed5 = playerPed5.enablepermissionsystem
                if false == playerPed5 then
                    playerPed5 = SendNUIMessage
                    coords = {}
                    coords.message = "hideparkbuy"
                    playerPed5(coords)
                end
            else
                playerPed5 = themeparkowned
                playerPed5 = playerPed5.own
                if true ~= playerPed5 then
                    playerPed5 = Config
                    playerPed5 = playerPed5.ThemeParkOwnedSettings
                    playerPed5 = playerPed5.enablepermissionsystem
                    if true ~= playerPed5 then
                        goto lbl_48
                    end
                end
                playerPed5 = DestroyCam
                coords = parkcammanagment
                playerPed2 = false
                playerPed5(coords, playerPed2)
                playerPed5 = RenderScriptCams
                coords = false
                playerPed2 = 2500
                playerPed6 = 2500
                serverId = true
                playerPed4 = false
                playerPed5(coords, playerPed2, playerPed6, serverId, playerPed4)
                playerPed5 = SendNUIMessage
                coords = {}
                coords.message = "hidemanagmentmenu"
                playerPed5(coords)
            end
            ::lbl_48::
            inmanagmentmenu = false
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "buythemepark"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            inmanagmentmenu = false
            playerPed5 = SetNuiFocus
            coords = false
            playerPed2 = false
            playerPed5(coords, playerPed2)
            playerPed5 = SendNUIMessage
            coords = {}
            coords.message = "hideparkbuy"
            playerPed5(coords)
            playerPed5 = TriggerServerEvent
            coords = "rtx_themepark:Global:BuyThemePark"
            playerPed5(coords)
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "withdrawthemepark"

    function coords8(A0_2, A1_2)
        local playerPed5, coords
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = themeparkowned
            playerPed5 = playerPed5.own
            if true ~= playerPed5 then
                playerPed5 = Config
                playerPed5 = playerPed5.ThemeParkOwnedSettings
                playerPed5 = playerPed5.enablepermissionsystem
                if true ~= playerPed5 then
                    goto lbl_16
                end
            end
            playerPed5 = TriggerServerEvent
            coords = "rtx_themepark:Global:ThemeParkManagmentWithdraw"
            playerPed5(coords)
        end
        ::lbl_16::
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "sellthemepark"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = Config
            playerPed5 = playerPed5.ThemeParkOwnedSettings
            playerPed5 = playerPed5.disablesell
            if false == playerPed5 then
                playerPed5 = themeparkowned
                playerPed5 = playerPed5.own
                if true == playerPed5 then
                    playerPed5 = Config
                    playerPed5 = playerPed5.ThemeParkOwnedSettings
                    playerPed5 = playerPed5.enablepermissionsystem
                    if false == playerPed5 then
                        playerPed5 = themeparkowned
                        playerPed5.own = false
                        playerPed5 = TriggerServerEvent
                        coords = "rtx_themepark:Global:SellThemePark"
                        playerPed5(coords)
                        inmanagmentmenu = false
                        playerPed5 = DestroyCam
                        coords = parkcammanagment
                        playerPed2 = false
                        playerPed5(coords, playerPed2)
                        playerPed5 = RenderScriptCams
                        coords = false
                        playerPed2 = 2500
                        playerPed6 = 2500
                        serverId = true
                        playerPed4 = false
                        playerPed5(coords, playerPed2, playerPed6, serverId, playerPed4)
                        playerPed5 = SendNUIMessage
                        coords = {}
                        coords.message = "hidemanagmentmenu"
                        playerPed5(coords)
                        playerPed5 = SetNuiFocus
                        coords = false
                        playerPed2 = false
                        playerPed5(coords, playerPed2)
                    end
                end
            else
                inmanagmentmenu = false
                playerPed5 = DestroyCam
                coords = parkcammanagment
                playerPed2 = false
                playerPed5(coords, playerPed2)
                playerPed5 = RenderScriptCams
                coords = false
                playerPed2 = 2500
                playerPed6 = 2500
                serverId = true
                playerPed4 = false
                playerPed5(coords, playerPed2, playerPed6, serverId, playerPed4)
                playerPed5 = SendNUIMessage
                coords = {}
                coords.message = "hidemanagmentmenu"
                playerPed5(coords)
                playerPed5 = SetNuiFocus
                coords = false
                playerPed2 = false
                playerPed5(coords, playerPed2)
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "transferthemepark"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = Config
            playerPed5 = playerPed5.ThemeParkOwnedSettings
            playerPed5 = playerPed5.disabletransfer
            if false == playerPed5 then
                playerPed5 = Config
                playerPed5 = playerPed5.ThemeParkOwnedSettings
                playerPed5 = playerPed5.enablepermissionsystem
                if false == playerPed5 then
                    playerPed5 = themeparkowned
                    playerPed5 = playerPed5.own
                    if true == playerPed5 then
                        playerPed5 = GetClosestPlayer
                        playerPed5, coords = playerPed5()
                        if -1 ~= playerPed5 then
                            playerPed2 = Config
                            playerPed2 = playerPed2.ThemeParkOwnedSettings
                            playerPed2 = playerPed2.themeparkmaxtransferdistance
                            if coords < playerPed2 then
                                playerPed2 = themeparkowned
                                playerPed2.own = false
                                playerPed2 = TriggerServerEvent
                                playerPed6 = "rtx_themepark:Global:TransferThemePark"
                                serverId = GetPlayerServerId
                                playerPed4 = playerPed5
                                serverId, playerPed4, entityCoords3, playerPed = serverId(playerPed4)
                                playerPed2(playerPed6, serverId, playerPed4, entityCoords3, playerPed)
                                inmanagmentmenu = false
                                playerPed2 = DestroyCam
                                playerPed6 = parkcammanagment
                                serverId = false
                                playerPed2(playerPed6, serverId)
                                playerPed2 = RenderScriptCams
                                playerPed6 = false
                                serverId = 2500
                                playerPed4 = 2500
                                entityCoords3 = true
                                playerPed = false
                                playerPed2(playerPed6, serverId, playerPed4, entityCoords3, playerPed)
                                playerPed2 = SendNUIMessage
                                playerPed6 = {}
                                playerPed6.message = "hidemanagmentmenu"
                                playerPed2(playerPed6)
                                playerPed2 = SetNuiFocus
                                playerPed6 = false
                                serverId = false
                                playerPed2(playerPed6, serverId)
                            end
                        else
                            playerPed2 = Notify
                            playerPed6 = Language
                            serverId = Config
                            serverId = serverId.Language
                            playerPed6 = playerPed6[serverId]
                            playerPed6 = playerPed6.noplayernearbymanagment
                            playerPed2(playerPed6)
                        end
                    end
                end
            else
                inmanagmentmenu = false
                playerPed5 = DestroyCam
                coords = parkcammanagment
                playerPed2 = false
                playerPed5(coords, playerPed2)
                playerPed5 = RenderScriptCams
                coords = false
                playerPed2 = 2500
                playerPed6 = 2500
                serverId = true
                playerPed4 = false
                playerPed5(coords, playerPed2, playerPed6, serverId, playerPed4)
                playerPed5 = SendNUIMessage
                coords = {}
                coords.message = "hidemanagmentmenu"
                playerPed5(coords)
                playerPed5 = SetNuiFocus
                coords = false
                playerPed2 = false
                playerPed5(coords, playerPed2)
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "parkmanagmentsattractions"

    function coords8(A0_2, A1_2)
        local playerPed5, coords
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = themeparkowned
            playerPed5 = playerPed5.own
            if true ~= playerPed5 then
                playerPed5 = Config
                playerPed5 = playerPed5.ThemeParkOwnedSettings
                playerPed5 = playerPed5.enablepermissionsystem
                if true ~= playerPed5 then
                    goto lbl_21
                end
            end
            playerPed5 = SendNUIMessage
            coords = {}
            coords.message = "parkmanagmentshow"
            playerPed5(coords)
            playerPed5 = TriggerServerEvent
            coords = "rtx_themepark:Global:OpenThemeParkManagmentMenuAttractions"
            playerPed5(coords)
        end
        ::lbl_21::
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "updateattractionstatus"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6
        playerPed5 = inmanagmentmenu
        if true == playerPed5 then
            playerPed5 = A0_2.attractionid
            if nil ~= playerPed5 then
                playerPed5 = themeparkowned
                playerPed5 = playerPed5.own
                if true ~= playerPed5 then
                    playerPed5 = Config
                    playerPed5 = playerPed5.ThemeParkOwnedSettings
                    playerPed5 = playerPed5.enablepermissionsystem
                    if true ~= playerPed5 then
                        goto lbl_23
                    end
                end
                playerPed5 = TriggerServerEvent
                coords = "rtx_themepark:Global:UpdateAttractionStatus"
                playerPed2 = tonumber
                playerPed6 = A0_2.attractionid
                playerPed2 = playerPed2(playerPed6)
                playerPed6 = A0_2.attractionstatushandler
                playerPed5(coords, playerPed2, playerPed6)
            end
        end
        ::lbl_23::
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = Config
    coords10 = coords10.Target
    if false == coords10 then
        coords10 = RegisterCommand
        coords15 = "openthemeparkmanagmentmenu"

        function coords8()
            local dataTable2, entityCoords2, playerPed5
            dataTable2 = inmanagmentmenu
            if false == dataTable2 then
                dataTable2 = usingattraction
                if false == dataTable2 then
                    dataTable2 = nearbymanagmentmenu
                    if true == dataTable2 then
                        dataTable2 = iteminhand
                        if false == dataTable2 then
                            dataTable2 = themeparkowned
                            dataTable2 = dataTable2.owned
                            if false == dataTable2 then
                                dataTable2 = Config
                                dataTable2 = dataTable2.ThemeParkOwnedSettings
                                dataTable2 = dataTable2.enablepermissionsystem
                                if false == dataTable2 then
                                    inmanagmentmenu = true
                                    dataTable2 = SetNuiFocus
                                    entityCoords2 = true
                                    playerPed5 = true
                                    dataTable2(entityCoords2, playerPed5)
                                    dataTable2 = SendNUIMessage
                                    entityCoords2 = {}
                                    entityCoords2.message = "parkbuyshow"
                                    playerPed5 = Config
                                    playerPed5 = playerPed5.ThemeParkOwnedSettings
                                    playerPed5 = playerPed5.themeparkprice
                                    entityCoords2.parkprice = playerPed5
                                    dataTable2(entityCoords2)
                                end
                            else
                                dataTable2 = themeparkowned
                                dataTable2 = dataTable2.own
                                if true ~= dataTable2 then
                                    dataTable2 = Config
                                    dataTable2 = dataTable2.ThemeParkOwnedSettings
                                    dataTable2 = dataTable2.enablepermissionsystem
                                end
                                if true == dataTable2 then
                                    dataTable2 = TriggerServerEvent
                                    entityCoords2 = "rtx_themepark:Global:OpenThemeParkManagmentMenu"
                                    dataTable2(entityCoords2)
                                end
                            end
                        else
                            dataTable2 = Notify
                            entityCoords2 = Language
                            playerPed5 = Config
                            playerPed5 = playerPed5.Language
                            entityCoords2 = entityCoords2[playerPed5]
                            entityCoords2 = entityCoords2.iteminhand
                            dataTable2(entityCoords2)
                        end
                    end
                end
            end
        end
        coords10(coords15, coords8)
        coords10 = RegisterKeyMapping
        coords15 = "openthemeparkmanagmentmenu"
        coords8 = Language
        coords5 = Config
        coords5 = coords5.Language
        coords8 = coords8[coords5]
        coords8 = coords8.openthemeparkmanagment
        coords5 = "keyboard"
        coords9 = Config
        coords9 = coords9.ThemeParkOwnedSettings
        coords9 = coords9.openmanagmentkey
        coords10(coords15, coords8, coords5, coords9)
    end
end
coords10 = Config
coords10 = coords10.ThemeParkDisableTicketSystem
if false == coords10 then
    coords10 = Citizen
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 0
            dataTable2(entityCoords2)
            dataTable2 = true
            entityCoords2 = false
            playerPed5 = -1
            coords = nil
            playerPed2 = nearbythemepark
            if true == playerPed2 then
                playerPed2 = ipairs
                playerPed6 = ticketmachines
                playerPed2, playerPed6, serverId, playerPed4 = playerPed2(playerPed6)
                for entityCoords3, playerPed in playerPed2, playerPed6, serverId, playerPed4 do
                    playerPed3 = playerPed.disabled
                    if false == playerPed3 then
                        playerPed3 = playercurrentcoords
                        entityCoords = playerPed.coords
                        playerPed3 = playerPed3 - entityCoords
                        playerPed3 = #playerPed3
                        if playerPed3 < 20.0 then
                            entityCoords = Config
                            entityCoords = entityCoords.ThemeParkTicketMachineSettings
                            entityCoords = entityCoords.usedistance
                            if playerPed3 < entityCoords and (-1 == playerPed5 or playerPed5 > playerPed3) then
                                playerPed5 = playerPed3
                                entityCoords2 = true
                                coords = entityCoords3
                            end
                        end
                    end
                end
            end
            if entityCoords2 then
                nearbyticketmachineid = coords
                playerPed2 = usingattraction
                if false == playerPed2 then
                    playerPed2 = inticketmachinemenu
                    if false == playerPed2 then
                        dataTable2 = false
                        playerPed2 = Config
                        playerPed2 = playerPed2.Target
                        if false == playerPed2 then
                            playerPed2 = ticketmachines
                            playerPed6 = nearbyticketmachineid
                            playerPed2 = playerPed2[playerPed6]
                            playerPed6 = Config
                            playerPed6 = playerPed6.ThemeParkInteractionSystem
                            if 1 == playerPed6 then
                                playerPed6 = SendNUIMessage
                                serverId = {}
                                serverId.message = "infonotifyshow"
                                playerPed4 = Language
                                entityCoords3 = Config
                                entityCoords3 = entityCoords3.Language
                                playerPed4 = playerPed4[entityCoords3]
                                playerPed4 = playerPed4.pressforbuyticketthemeparkinteract
                                serverId.infonotifytext = playerPed4
                                playerPed6(serverId)
                            else
                                playerPed6 = Config
                                playerPed6 = playerPed6.ThemeParkInteractionSystem
                                if 2 == playerPed6 then
                                    playerPed6 = DrawText3D
                                    serverId = playerPed2.coords
                                    serverId = serverId.x
                                    playerPed4 = playerPed2.coords
                                    playerPed4 = playerPed4.y
                                    entityCoords3 = playerPed2.coords
                                    entityCoords3 = entityCoords3.z
                                    entityCoords3 = entityCoords3 + 1.0
                                    playerPed = Language
                                    playerPed3 = Config
                                    playerPed3 = playerPed3.Language
                                    playerPed = playerPed[playerPed3]
                                    playerPed = playerPed.pressforbuyticketthemepark
                                    playerPed6(serverId, playerPed4, entityCoords3, playerPed)
                                else
                                    playerPed6 = Config
                                    playerPed6 = playerPed6.ThemeParkInteractionSystem
                                    if 3 == playerPed6 then
                                        playerPed6 = ShowGtaClassicInteraction
                                        serverId = Language
                                        playerPed4 = Config
                                        playerPed4 = playerPed4.Language
                                        serverId = serverId[playerPed4]
                                        playerPed4 = "pressforbuyticketthemeparkinteractclassic"
                                        serverId = serverId[playerPed4]
                                        playerPed6(serverId)
                                    end
                                end
                            end
                        end
                    end
                else
                    playerPed2 = Config
                    playerPed2 = playerPed2.ThemeParkInteractionSystem
                    if 1 == playerPed2 then
                        playerPed2 = nearbyticketmachineid
                        if nil ~= playerPed2 then
                            playerPed2 = SendNUIMessage
                            playerPed6 = {}
                            playerPed6.message = "hide"
                            playerPed2(playerPed6)
                        end
                    end
                end
            else
                playerPed2 = Config
                playerPed2 = playerPed2.ThemeParkInteractionSystem
                if 1 == playerPed2 then
                    playerPed2 = nearbyticketmachineid
                    if nil ~= playerPed2 then
                        playerPed2 = SendNUIMessage
                        playerPed6 = {}
                        playerPed6.message = "hide"
                        playerPed2(playerPed6)
                    end
                end
                nearbyticketmachineid = nil
            end
            if dataTable2 then
                playerPed2 = Citizen
                playerPed2 = playerPed2.Wait
                playerPed6 = 1000
                playerPed2(playerPed6)
            end
        end
    end
    coords10(coords15)
end
coords10 = Citizen
coords10 = coords10.CreateThread

function coords15()
    local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords
    while true do
        dataTable2 = Citizen
        dataTable2 = dataTable2.Wait
        entityCoords2 = 0
        dataTable2(entityCoords2)
        dataTable2 = true
        entityCoords2 = false
        playerPed5 = -1
        coords = nil
        playerPed2 = iteminhand
        if false == playerPed2 then
            playerPed2 = nearbythemepark
            if true == playerPed2 then
                playerPed2 = ipairs
                playerPed6 = Config
                playerPed6 = playerPed6.Stands
                playerPed2, playerPed6, serverId, playerPed4 = playerPed2(playerPed6)
                for entityCoords3, playerPed in playerPed2, playerPed6, serverId, playerPed4 do
                    playerPed3 = playercurrentcoords
                    entityCoords = playerPed.coords
                    playerPed3 = playerPed3 - entityCoords
                    playerPed3 = #playerPed3
                    if playerPed3 < 20.0 then
                        entityCoords = Config
                        entityCoords = entityCoords.ThemeParkItemsSettings
                        entityCoords = entityCoords.buydistance
                        if playerPed3 < entityCoords then
                            if -1 ~= playerPed5 then
                                entityCoords = Config
                                entityCoords = entityCoords.ThemeParkItemsSettings
                                entityCoords = entityCoords.buydistance
                                if not (playerPed5 > entityCoords) then
                                    goto lbl_42
                                end
                            end
                            playerPed5 = playerPed3
                            entityCoords2 = true
                            coords = entityCoords3
                        end
                    end
                    ::lbl_42::
                end
            end
        end
        if entityCoords2 then
            nearbystandid = coords
            playerPed2 = usingattraction
            if false == playerPed2 then
                dataTable2 = false
                playerPed2 = Config
                playerPed2 = playerPed2.Target
                if false == playerPed2 then
                    playerPed2 = Config
                    playerPed2 = playerPed2.Stands
                    playerPed6 = nearbystandid
                    playerPed2 = playerPed2[playerPed6]
                    playerPed6 = Config
                    playerPed6 = playerPed6.ThemeParkInteractionSystem
                    if 1 == playerPed6 then
                        playerPed6 = SendNUIMessage
                        serverId = {}
                        serverId.message = "infonotifyshow"
                        playerPed4 = LanguageFile
                        entityCoords3 = "pressforbuyitemthemeparkinteract"
                        playerPed = playerPed2.standtype
                        playerPed4 = playerPed4(entityCoords3, playerPed)
                        serverId.infonotifytext = playerPed4
                        playerPed6(serverId)
                    else
                        playerPed6 = Config
                        playerPed6 = playerPed6.ThemeParkInteractionSystem
                        if 2 == playerPed6 then
                            playerPed6 = DrawText3D
                            serverId = playerPed2.coords
                            serverId = serverId.x
                            playerPed4 = playerPed2.coords
                            playerPed4 = playerPed4.y
                            entityCoords3 = playerPed2.coords
                            entityCoords3 = entityCoords3.z
                            entityCoords3 = entityCoords3 + 1.0
                            playerPed = LanguageFile
                            playerPed3 = "pressforbuyitemthemepark"
                            entityCoords = playerPed2.standtype
                            playerPed, playerPed3, entityCoords = playerPed(playerPed3, entityCoords)
                            playerPed6(serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords)
                        else
                            playerPed6 = Config
                            playerPed6 = playerPed6.ThemeParkInteractionSystem
                            if 3 == playerPed6 then
                                playerPed6 = ShowGtaClassicInteraction
                                serverId = LanguageFile
                                playerPed4 = "pressforbuyitemthemeparkinteractclassic"
                                entityCoords3 = playerPed2.standtype
                                serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords = serverId(playerPed4, entityCoords3)
                                playerPed6(serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords)
                            end
                        end
                    end
                end
            else
                playerPed2 = Config
                playerPed2 = playerPed2.ThemeParkInteractionSystem
                if 1 == playerPed2 then
                    playerPed2 = nearbystandid
                    if nil ~= playerPed2 then
                        playerPed2 = SendNUIMessage
                        playerPed6 = {}
                        playerPed6.message = "hide"
                        playerPed2(playerPed6)
                    end
                end
            end
        else
            playerPed2 = Config
            playerPed2 = playerPed2.ThemeParkInteractionSystem
            if 1 == playerPed2 then
                playerPed2 = nearbystandid
                if nil ~= playerPed2 then
                    playerPed2 = SendNUIMessage
                    playerPed6 = {}
                    playerPed6.message = "hide"
                    playerPed2(playerPed6)
                end
            end
            nearbystandid = nil
        end
        if dataTable2 then
            playerPed2 = Citizen
            playerPed2 = playerPed2.Wait
            playerPed6 = 1000
            playerPed2(playerPed6)
        end
    end
end
coords10(coords15)
coords10 = Config
coords10 = coords10.Target
if false == coords10 then
    coords10 = RegisterCommand
    coords15 = "openthemeparkticketmenu"

    function coords8()
        local dataTable2, entityCoords2, playerPed5
        dataTable2 = inticketmachinemenu
        if false == dataTable2 then
            dataTable2 = usingattraction
            if false == dataTable2 then
                dataTable2 = nearbyticketmachineid
                if nil ~= dataTable2 then
                    dataTable2 = iteminhand
                    if false == dataTable2 then
                        dataTable2 = TriggerServerEvent
                        entityCoords2 = "rtx_themepark:Global:OpenTicketMachineMenu"
                        playerPed5 = nearbyticketmachineid
                        dataTable2(entityCoords2, playerPed5)
                    else
                        dataTable2 = Notify
                        entityCoords2 = Language
                        playerPed5 = Config
                        playerPed5 = playerPed5.Language
                        entityCoords2 = entityCoords2[playerPed5]
                        entityCoords2 = entityCoords2.iteminhand
                        dataTable2(entityCoords2)
                    end
                end
            end
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterKeyMapping
    coords15 = "openthemeparkticketmenu"
    coords8 = Language
    coords5 = Config
    coords5 = coords5.Language
    coords8 = coords8[coords5]
    coords8 = coords8.openthemeparkticket
    coords5 = "keyboard"
    coords9 = Config
    coords9 = coords9.ThemeParkTicketMachineSettings
    coords9 = coords9.usekey
    coords10(coords15, coords8, coords5, coords9)
end
coords10 = RegisterCommand
coords15 = "giveparkitem"

function coords8()
    local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId
    dataTable2 = iteminhand
    if true == dataTable2 then
        dataTable2 = iteminhandtype
        if "popcorn" ~= dataTable2 then
            dataTable2 = iteminhandtype
            if "cotton" ~= dataTable2 then
                dataTable2 = iteminhandtype
                if "balloon" ~= dataTable2 then
                    goto lbl_38
                end
            end
        end
        dataTable2 = GetClosestPlayer
        dataTable2, entityCoords2 = dataTable2()
        if -1 ~= dataTable2 then
            playerPed5 = Config
            playerPed5 = playerPed5.ThemeParkItemsSettings
            playerPed5 = playerPed5.givedistance
            if entityCoords2 < playerPed5 then
                playerPed5 = TriggerServerEvent
                coords = "rtx_themepark:Global:GiveItemInHand"
                playerPed2 = GetPlayerServerId
                playerPed6 = dataTable2
                playerPed2 = playerPed2(playerPed6)
                playerPed6 = iteminhandtype
                serverId = iteminhandballonid
                playerPed5(coords, playerPed2, playerPed6, serverId)
            end
        else
            playerPed5 = Notify
            coords = Language
            playerPed2 = Config
            playerPed2 = playerPed2.Language
            coords = coords[playerPed2]
            coords = coords.noplayernearbyitem
            playerPed5(coords)
        end
    end
    ::lbl_38::
end
coords10(coords15, coords8)
coords10 = RegisterKeyMapping
coords15 = "giveparkitem"
coords8 = Language
coords5 = Config
coords5 = coords5.Language
coords8 = coords8[coords5]
coords8 = coords8.giveplayeritem
coords5 = "keyboard"
coords9 = Config
coords9 = coords9.ThemeParkItemsSettings
coords9 = coords9.givekey
coords10(coords15, coords8, coords5, coords9)
coords10 = RegisterCommand
coords15 = "throwparkitem"

function coords8()
    local dataTable2, entityCoords2, playerPed5, coords
    dataTable2 = iteminhand
    if true == dataTable2 then
        dataTable2 = iteminhandtype
        if "popcorn" ~= dataTable2 then
            dataTable2 = iteminhandtype
            if "cotton" ~= dataTable2 then
                dataTable2 = iteminhandtype
                if "balloon" ~= dataTable2 then
                    goto lbl_32
                end
            end
        end
        dataTable2 = SendNUIMessage
        entityCoords2 = {}
        entityCoords2.message = "hideiteminhand"
        dataTable2(entityCoords2)
        dataTable2 = iteminhandtype
        if "balloon" == dataTable2 then
            dataTable2 = TriggerServerEvent
            entityCoords2 = "rtx_themepark:Global:RemoveItemInHand"
            playerPed5 = "baloon"
            coords = iteminhandballonid
            dataTable2(entityCoords2, playerPed5, coords)
        else
            dataTable2 = TriggerServerEvent
            entityCoords2 = "rtx_themepark:Global:RemoveItemInHand"
            playerPed5 = "normal"
            coords = nil
            dataTable2(entityCoords2, playerPed5, coords)
        end
    end
    ::lbl_32::
end
coords10(coords15, coords8)
coords10 = RegisterKeyMapping
coords15 = "throwparkitem"
coords8 = Language
coords5 = Config
coords5 = coords5.Language
coords8 = coords8[coords5]
coords8 = coords8.throwitem
coords5 = "keyboard"
coords9 = Config
coords9 = coords9.ThemeParkItemsSettings
coords22 = "throwkey"
coords9 = coords9[coords22]
coords10(coords15, coords8, coords5, coords9)
coords10 = Config
coords10 = coords10.Target
coords15 = false
if coords10 == coords15 then
    coords10 = RegisterCommand
    coords15 = "buythemeparkitem"

    function coords8()
        local dataTable2, entityCoords2, playerPed5
        dataTable2 = iteminhand
        if false == dataTable2 then
            dataTable2 = nearbystandid
            if nil ~= dataTable2 then
                dataTable2 = TriggerServerEvent
                entityCoords2 = "rtx_themepark:Global:BuyItemToHand"
                playerPed5 = nearbystandid
                dataTable2(entityCoords2, playerPed5)
                nearbystandid = nil
            end
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterKeyMapping
    coords15 = "buythemeparkitem"
    coords8 = Language
    coords5 = Config
    coords5 = coords5.Language
    coords8 = coords8[coords5]
    coords8 = coords8.throwitem
    coords5 = "keyboard"
    coords9 = Config
    coords9 = coords9.ThemeParkItemsSettings
    coords22 = "buykey"
    coords9 = coords9[coords22]
    coords10(coords15, coords8, coords5, coords9)
end
coords10 = Config
coords15 = "ThemeParkControlAttractions"
coords10 = coords10[coords15]
if coords10 then
    coords10 = RegisterNUICallback
    coords15 = "updatesmokecolor"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.smokedisabled
                if false == coords then
                    coords = playerPed5.smokecolor
                    playerPed2 = tonumber
                    playerPed6 = A0_2.colorR
                    playerPed2 = playerPed2(playerPed6)
                    coords.r = playerPed2
                    coords = playerPed5.smokecolor
                    playerPed2 = tonumber
                    playerPed6 = A0_2.colorG
                    playerPed2 = playerPed2(playerPed6)
                    coords.g = playerPed2
                    coords = playerPed5.smokecolor
                    playerPed2 = tonumber
                    playerPed6 = A0_2.colorB
                    playerPed2 = playerPed2(playerPed6)
                    coords.b = playerPed2
                    coords = TriggerServerEvent
                    playerPed2 = "rtx_themepark:Global:ThemeParkControlSmokeColor"
                    playerPed6 = attractioncontrolledid
                    serverId = playerPed5.smokecolor
                    coords(playerPed2, playerPed6, serverId)
                end
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "smokecontrol"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.smokedisabled
                if false == coords then
                    coords = A0_2.smokehandler
                    if true == coords then
                        coords = playerPed5.smokeactivated
                        if false == coords then
                            playerPed5.smokeactivated = true
                            coords = TriggerServerEvent
                            playerPed2 = "rtx_themepark:Global:ThemeParkControlSmokeHandler"
                            playerPed6 = attractioncontrolledid
                            serverId = true
                            coords(playerPed2, playerPed6, serverId)
                        end
                    else
                        coords = A0_2.smokehandler
                        if false == coords then
                            coords = playerPed5.smokeactivated
                            if true == coords then
                                playerPed5.smokeactivated = false
                                coords = TriggerServerEvent
                                playerPed2 = "rtx_themepark:Global:ThemeParkControlSmokeHandler"
                                playerPed6 = attractioncontrolledid
                                serverId = false
                                coords(playerPed2, playerPed6, serverId)
                            end
                        end
                    end
                end
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "closecontrolmenu"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = TriggerServerEvent
                coords = "rtx_themepark:Global:ThemeParkOpenControlMenuClose"
                playerPed2 = attractioncontrolledid
                playerPed5(coords, playerPed2)
                attractioncontrolledid = nil
                inattractioncontrolmenu = false
                playerPed5 = SetNuiFocus
                coords = false
                playerPed2 = false
                playerPed5(coords, playerPed2)
                playerPed5 = SendNUIMessage
                coords = {}
                coords.message = "hideattractioncontrol"
                playerPed5(coords)
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "attractionnewurl"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.musicdisabled
                if false == coords then
                    coords = tostring
                    playerPed2 = A0_2.musicurldata
                    coords = coords(playerPed2)
                    playerPed2 = false
                    playerPed6 = string
                    playerPed6 = playerPed6.find
                    serverId = coords
                    playerPed4 = "youtube.com"
                    playerPed6 = playerPed6(serverId, playerPed4)
                    if playerPed6 then
                        playerPed6 = string
                        playerPed6 = playerPed6.find
                        serverId = coords
                        playerPed4 = "^https://www.youtube.com"
                        playerPed6 = playerPed6(serverId, playerPed4)
                        if playerPed6 then
                            playerPed2 = true
                        else
                            playerPed6 = string
                            playerPed6 = playerPed6.find
                            serverId = coords
                            playerPed4 = "^https://youtube.com"
                            playerPed6 = playerPed6(serverId, playerPed4)
                            if playerPed6 then
                                playerPed2 = true
                            else
                                playerPed6 = string
                                playerPed6 = playerPed6.find
                                serverId = coords
                                playerPed4 = "^http://youtube.com"
                                playerPed6 = playerPed6(serverId, playerPed4)
                                if playerPed6 then
                                    playerPed2 = true
                                else
                                    playerPed6 = string
                                    playerPed6 = playerPed6.find
                                    serverId = coords
                                    playerPed4 = "^http://www.youtube.com"
                                    playerPed6 = playerPed6(serverId, playerPed4)
                                    if playerPed6 then
                                        playerPed2 = true
                                    else
                                        playerPed6 = string
                                        playerPed6 = playerPed6.find
                                        serverId = coords
                                        playerPed4 = "^www.youtube.com"
                                        playerPed6 = playerPed6(serverId, playerPed4)
                                        if playerPed6 then
                                            playerPed2 = true
                                        else
                                            playerPed6 = string
                                            playerPed6 = playerPed6.find
                                            serverId = coords
                                            playerPed4 = "^youtube.com"
                                            playerPed6 = playerPed6(serverId, playerPed4)
                                            if playerPed6 then
                                                playerPed2 = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        playerPed6 = string
                        playerPed6 = playerPed6.find
                        serverId = coords
                        playerPed4 = "youtu.be"
                        playerPed6 = playerPed6(serverId, playerPed4)
                        if playerPed6 then
                            playerPed6 = string
                            playerPed6 = playerPed6.find
                            serverId = coords
                            playerPed4 = "^https://www.youtu.be"
                            playerPed6 = playerPed6(serverId, playerPed4)
                            if playerPed6 then
                                playerPed2 = true
                            else
                                playerPed6 = string
                                playerPed6 = playerPed6.find
                                serverId = coords
                                playerPed4 = "^https://youtu.be"
                                playerPed6 = playerPed6(serverId, playerPed4)
                                if playerPed6 then
                                    playerPed2 = true
                                else
                                    playerPed6 = string
                                    playerPed6 = playerPed6.find
                                    serverId = coords
                                    playerPed4 = "^http://youtu.be"
                                    playerPed6 = playerPed6(serverId, playerPed4)
                                    if playerPed6 then
                                        playerPed2 = true
                                    else
                                        playerPed6 = string
                                        playerPed6 = playerPed6.find
                                        serverId = coords
                                        playerPed4 = "^http://www.youtu.be"
                                        playerPed6 = playerPed6(serverId, playerPed4)
                                        if playerPed6 then
                                            playerPed2 = true
                                        else
                                            playerPed6 = string
                                            playerPed6 = playerPed6.find
                                            serverId = coords
                                            playerPed4 = "^www.youtu.be"
                                            playerPed6 = playerPed6(serverId, playerPed4)
                                            if playerPed6 then
                                                playerPed2 = true
                                            else
                                                playerPed6 = string
                                                playerPed6 = playerPed6.find
                                                serverId = coords
                                                playerPed4 = "^youtu.be"
                                                playerPed6 = playerPed6(serverId, playerPed4)
                                                if playerPed6 then
                                                    playerPed2 = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            playerPed6 = string
                            playerPed6 = playerPed6.find
                            serverId = coords
                            playerPed4 = ".mp3"
                            playerPed6 = playerPed6(serverId, playerPed4)
                            if playerPed6 then
                                playerPed6 = string
                                playerPed6 = playerPed6.find
                                serverId = coords
                                playerPed4 = ".mp3"
                                playerPed6 = playerPed6(serverId, playerPed4)
                                if playerPed6 then
                                    playerPed6 = string
                                    playerPed6 = playerPed6.find
                                    serverId = coords
                                    playerPed4 = "https://"
                                    playerPed6 = playerPed6(serverId, playerPed4)
                                    if playerPed6 then
                                        playerPed2 = true
                                    else
                                        playerPed6 = string
                                        playerPed6 = playerPed6.find
                                        serverId = coords
                                        playerPed4 = "https://"
                                        playerPed6 = playerPed6(serverId, playerPed4)
                                        if playerPed6 then
                                            playerPed2 = true
                                        else
                                            playerPed6 = string
                                            playerPed6 = playerPed6.find
                                            serverId = coords
                                            playerPed4 = "http://"
                                            playerPed6 = playerPed6(serverId, playerPed4)
                                            if playerPed6 then
                                                playerPed2 = true
                                            else
                                                playerPed6 = string
                                                playerPed6 = playerPed6.find
                                                serverId = coords
                                                playerPed4 = "www."
                                                playerPed6 = playerPed6(serverId, playerPed4)
                                                if playerPed6 then
                                                    playerPed2 = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if playerPed2 then
                        playerPed6 = string
                        playerPed6 = playerPed6.find
                        serverId = coords
                        playerPed4 = "youtube.com"
                        playerPed6 = playerPed6(serverId, playerPed4)
                        if not playerPed6 then
                            playerPed6 = string
                            playerPed6 = playerPed6.find
                            serverId = coords
                            playerPed4 = "youtu.be"
                            playerPed6 = playerPed6(serverId, playerPed4)
                            if not playerPed6 then
                                goto lbl_223
                            end
                        end
                        playerPed6 = SoundUrlCheck
                        serverId = coords
                        playerPed6 = playerPed6(serverId)
                        if true == playerPed6 then
                            serverId = TriggerServerEvent
                            playerPed4 = "rtx_themepark:Global:ThemeParkControlMusicPlay"
                            entityCoords3 = attractioncontrolledid
                            playerPed = coords
                            serverId(playerPed4, entityCoords3, playerPed)
                        else
                            serverId = Notify
                            playerPed4 = Language
                            entityCoords3 = Config
                            entityCoords3 = entityCoords3.Language
                            playerPed4 = playerPed4[entityCoords3]
                            playerPed4 = playerPed4.youtubeblock
                            serverId(playerPed4)
                            goto lbl_236
                        end
                        goto lbl_236
                        ::lbl_223::
                        do
                            playerPed6 = TriggerServerEvent
                            serverId = "rtx_themepark:Global:ThemeParkControlMusicPlay"
                            playerPed4 = attractioncontrolledid
                            entityCoords3 = coords
                            playerPed6(serverId, playerPed4, entityCoords3)
                        end
                    else
                        playerPed6 = Notify
                        serverId = Language
                        playerPed4 = Config
                        playerPed4 = playerPed4.Language
                        serverId = serverId[playerPed4]
                        serverId = serverId.notsupported
                        playerPed6(serverId)
                    end
                end
            end
        end
        ::lbl_236::
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "volumechange"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.musicdisabled
                if false == coords then
                    coords = tonumber
                    playerPed2 = A0_2.volumedata
                    coords = coords(playerPed2)
                    if coords >= 0 and coords <= 100 then
                        playerPed2 = TriggerServerEvent
                        playerPed6 = "rtx_themepark:Global:ThemeParkControlMusicVolume"
                        serverId = attractioncontrolledid
                        playerPed4 = coords
                        playerPed2(playerPed6, serverId, playerPed4)
                    end
                end
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "stopmusic"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.musicdisabled
                if false == coords then
                    coords = SendNUIMessage
                    playerPed2 = {}
                    playerPed2.message = "updateattractionmusiclabel"
                    playerPed2.musiclabel = ""
                    coords(playerPed2)
                    coords = TriggerServerEvent
                    playerPed2 = "rtx_themepark:Global:ThemeParkControlMusicStop"
                    playerPed6 = attractioncontrolledid
                    coords(playerPed2, playerPed6)
                end
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNUICallback
    coords15 = "startattraction"

    function coords8(A0_2, A1_2)
        local playerPed5, coords, playerPed2, playerPed6, serverId
        playerPed5 = inattractioncontrolmenu
        if true == playerPed5 then
            playerPed5 = attractioncontrolledid
            if nil ~= playerPed5 then
                playerPed5 = controlmachines
                coords = attractioncontrolledid
                playerPed5 = playerPed5[coords]
                coords = playerPed5.turndisabled
                if false == coords then
                    coords = TriggerServerEvent
                    playerPed2 = "rtx_themepark:Global:StartAttractionPlayer"
                    playerPed6 = attractioncontrolledid
                    serverId = playerPed5.attractionid
                    coords(playerPed2, playerPed6, serverId)
                end
            end
        end
        playerPed5 = A1_2
        coords = "ok"
        playerPed5(coords)
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ThemeParkControlSmokeHandlerClient"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ThemeParkControlSmokeHandlerClient"

    function coords8(A0_2, A1_2)
        local playerPed5
        if nil ~= A0_2 then
            playerPed5 = controlmachines
            playerPed5 = playerPed5[A0_2]
            playerPed5.smokeactivated = A1_2
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ThemeParkControlSmokeColorClient"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ThemeParkControlSmokeColorClient"

    function coords8(A0_2, A1_2)
        local playerPed5
        if nil ~= A0_2 then
            playerPed5 = controlmachines
            playerPed5 = playerPed5[A0_2]
            playerPed5.smokecolor = A1_2
        end
    end
    coords10(coords15, coords8)
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ThemeParkOpenControlMenuClient"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ThemeParkOpenControlMenuClient"

    function coords8(A0_2)
        local entityCoords2, playerPed5, coords, playerPed2
        entityCoords2 = iteminhand
        if false == entityCoords2 then
            entityCoords2 = inattractioncontrolmenu
            if false == entityCoords2 and nil ~= A0_2 then
                inattractioncontrolmenu = true
                attractioncontrolledid = A0_2
                entityCoords2 = SetNuiFocus
                playerPed5 = true
                coords = true
                entityCoords2(playerPed5, coords)
                entityCoords2 = controlmachines
                entityCoords2 = entityCoords2[A0_2]
                playerPed5 = SendNUIMessage
                coords = {}
                coords.message = "parkattractionshow"
                playerPed2 = entityCoords2.label
                coords.attractionname = playerPed2
                playerPed2 = entityCoords2.smokecolor
                coords.smokecolor = playerPed2
                playerPed2 = entityCoords2.smokedisabled
                coords.smokedisabled = playerPed2
                playerPed2 = entityCoords2.turndisabled
                coords.turndisabled = playerPed2
                playerPed2 = entityCoords2.musicdisabled
                coords.musicdisabled = playerPed2
                playerPed2 = entityCoords2.musicvolume
                coords.musicvolumedata = playerPed2
                playerPed5(coords)
                playerPed5 = entityCoords2.musichandler
                if nil ~= playerPed5 then
                    playerPed5 = SendNUIMessage
                    coords = {}
                    coords.message = "updateattractionmusiclabel"
                    playerPed2 = entityCoords2.musichandler
                    playerPed2 = playerPed2.soundname
                    coords.musiclabel = playerPed2
                    playerPed5(coords)
                else
                    playerPed5 = SendNUIMessage
                    coords = {}
                    coords.message = "updateattractionmusiclabel"
                    coords.musiclabel = ""
                    playerPed5(coords)
                end
            end
        end
    end
    coords10(coords15, coords8)
    coords10 = _ENV
    coords15 = "Citizen"
    coords10 = coords10[coords15]
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3, isDisabled
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 1000
            dataTable2(entityCoords2)
            dataTable2 = nearbythemepark
            if dataTable2 then
                dataTable2 = ipairs
                entityCoords2 = controlmachines
                dataTable2, entityCoords2, playerPed5, coords = dataTable2(entityCoords2)
                for playerPed2, playerPed6 in dataTable2, entityCoords2, playerPed5, coords do
                    serverId = DoesEntityExist
                    playerPed4 = playerPed6.handler
                    serverId = serverId(playerPed4)
                    if serverId then
                        serverId = FreezeEntityPosition
                        playerPed4 = playerPed6.handler
                        entityCoords3 = true
                        serverId(playerPed4, entityCoords3)
                    else
                        serverId = GetHashKey
                        playerPed4 = "sempre_delperropier_control"
                        serverId = serverId(playerPed4)
                        playerPed4 = RequestModel
                        entityCoords3 = serverId
                        playerPed4(entityCoords3)
                        while true do
                            playerPed4 = HasModelLoaded
                            entityCoords3 = serverId
                            playerPed4 = playerPed4(entityCoords3)
                            if playerPed4 then
                                break
                            end
                            playerPed4 = RequestModel
                            entityCoords3 = serverId
                            playerPed4(entityCoords3)
                            playerPed4 = Citizen
                            playerPed4 = playerPed4.Wait
                            entityCoords3 = 5
                            playerPed4(entityCoords3)
                        end
                        playerPed4 = CreateObjectNoOffset
                        entityCoords3 = serverId
                        playerPed = playerPed6.coords
                        playerPed = playerPed.x
                        playerPed3 = playerPed6.coords
                        playerPed3 = playerPed3.y
                        entityCoords = playerPed6.coords
                        entityCoords = entityCoords.z
                        isDisabled3 = false
                        isEnabled9 = true
                        isEnabled5 = true
                        playerPed4 = playerPed4(entityCoords3, playerPed, playerPed3, entityCoords, isDisabled3, isEnabled9, isEnabled5)
                        playerPed6.handler = playerPed4
                        playerPed4 = SetEntityRotation
                        entityCoords3 = playerPed6.handler
                        playerPed = playerPed6.rotation
                        playerPed = playerPed.x
                        playerPed3 = playerPed6.rotation
                        playerPed3 = playerPed3.y
                        entityCoords = playerPed6.rotation
                        entityCoords = entityCoords.z
                        playerPed4(entityCoords3, playerPed, playerPed3, entityCoords)
                        playerPed4 = FreezeEntityPosition
                        entityCoords3 = playerPed6.handler
                        playerPed = true
                        playerPed4(entityCoords3, playerPed)
                    end
                    serverId = playerPed6.smokedisabled
                    if false == serverId then
                        serverId = ipairs
                        playerPed4 = playerPed6.smokelocations
                        serverId, playerPed4, entityCoords3, playerPed = serverId(playerPed4)
                        for playerPed3, entityCoords in serverId, playerPed4, entityCoords3, playerPed do
                            isDisabled3 = playerPed6.smokeactivated
                            if true == isDisabled3 then
                                isDisabled3 = playercurrentcoords
                                isEnabled9 = entityCoords.coords
                                isDisabled3 = isDisabled3 - isEnabled9
                                isDisabled3 = #isDisabled3
                                if not (isDisabled3 < 100.0) then
                                    goto lbl_193
                                end
                                isEnabled9 = SetWindSpeed
                                isEnabled5 = 0.0
                                isEnabled9(isEnabled5)
                                isEnabled9 = SetWindDirection
                                isEnabled5 = 0.0
                                isEnabled9(isEnabled5)
                                isEnabled9 = DoesParticleFxLoopedExist
                                isEnabled5 = entityCoords.handler
                                isEnabled9 = isEnabled9(isEnabled5)
                                if isEnabled9 then
                                    isEnabled9 = SetParticleFxLoopedColour
                                    isEnabled5 = entityCoords.handler
                                    isEnabled4 = playerPed6.smokecolor
                                    isEnabled4 = isEnabled4.r
                                    isEnabled4 = isEnabled4 / 255
                                    isEnabled4 = isEnabled4 + 0.0
                                    isEnabled6 = playerPed6.smokecolor
                                    isEnabled6 = isEnabled6.g
                                    isEnabled6 = isEnabled6 / 255
                                    isEnabled6 = isEnabled6 + 0.0
                                    isEnabled = playerPed6.smokecolor
                                    isEnabled = isEnabled.b
                                    isEnabled = isEnabled / 255
                                    isEnabled = isEnabled + 0.0
                                    isEnabled8 = 0
                                    isEnabled9(isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8)
                                else
                                    isEnabled9 = RequestNamedPtfxAsset
                                    isEnabled5 = "scr_ar_planes"
                                    isEnabled9(isEnabled5)
                                    while true do
                                        isEnabled9 = HasNamedPtfxAssetLoaded
                                        isEnabled5 = "scr_ar_planes"
                                        isEnabled9 = isEnabled9(isEnabled5)
                                        if isEnabled9 then
                                            break
                                        end
                                        isEnabled9 = Citizen
                                        isEnabled9 = isEnabled9.Wait
                                        isEnabled5 = 5
                                        isEnabled9(isEnabled5)
                                        isEnabled9 = RequestNamedPtfxAsset
                                        isEnabled5 = "scr_ar_planes"
                                        isEnabled9(isEnabled5)
                                    end
                                    isEnabled9 = UseParticleFxAsset
                                    isEnabled5 = "scr_ar_planes"
                                    isEnabled9(isEnabled5)
                                    isEnabled9 = UseParticleFxAssetNextCall
                                    isEnabled5 = "scr_ar_planes"
                                    isEnabled9(isEnabled5)
                                    isEnabled9 = StartParticleFxLoopedAtCoord
                                    isEnabled5 = "scr_ar_trail_smoke"
                                    isEnabled4 = entityCoords.coords
                                    isEnabled4 = isEnabled4.x
                                    isEnabled6 = entityCoords.coords
                                    isEnabled6 = isEnabled6.y
                                    isEnabled = entityCoords.coords
                                    isEnabled = isEnabled.z
                                    isEnabled8 = 0.0
                                    isEnabled7 = 0.0
                                    isDisabled2 = 0.0
                                    isEnabled2 = entityCoords.scale
                                    isDisabled4 = false
                                    isEnabled3 = false
                                    isDisabled = false
                                    isEnabled9 = isEnabled9(isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8, isEnabled7, isDisabled2, isEnabled2, isDisabled4, isEnabled3, isDisabled)
                                    entityCoords.handler = isEnabled9
                                    isEnabled9 = SetParticleFxLoopedColour
                                    isEnabled5 = entityCoords.handler
                                    isEnabled4 = playerPed6.smokecolor
                                    isEnabled4 = isEnabled4.r
                                    isEnabled4 = isEnabled4 / 255
                                    isEnabled4 = isEnabled4 + 0.0
                                    isEnabled6 = playerPed6.smokecolor
                                    isEnabled6 = isEnabled6.g
                                    isEnabled6 = isEnabled6 / 255
                                    isEnabled6 = isEnabled6 + 0.0
                                    isEnabled = playerPed6.smokecolor
                                    isEnabled = isEnabled.b
                                    isEnabled = isEnabled / 255
                                    isEnabled = isEnabled + 0.0
                                    isEnabled8 = 0
                                    isEnabled9(isEnabled5, isEnabled4, isEnabled6, isEnabled, isEnabled8)
                                    isEnabled9 = SetParticleFxLoopedAlpha
                                    isEnabled5 = entityCoords.handler
                                    isEnabled4 = 0.05
                                    isEnabled9(isEnabled5, isEnabled4)
                                end
                            else
                                isDisabled3 = DoesParticleFxLoopedExist
                                isEnabled9 = entityCoords.handler
                                isDisabled3 = isDisabled3(isEnabled9)
                                if isDisabled3 then
                                    isDisabled3 = StopParticleFxLooped
                                    isEnabled9 = entityCoords.handler
                                    isEnabled5 = 0
                                    isDisabled3(isEnabled9, isEnabled5)
                                end
                            end
                            ::lbl_193::
                        end
                    end
                end
            end
        end
    end
    coords10(coords15)
    coords10 = _ENV
    coords15 = "Citizen"
    coords10 = coords10[coords15]
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2, playerPed5, coords, playerPed2, playerPed6, serverId, playerPed4, entityCoords3, playerPed, playerPed3, entityCoords
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 0
            dataTable2(entityCoords2)
            dataTable2 = true
            entityCoords2 = false
            playerPed5 = -1
            coords = nil
            playerPed2 = nearbythemepark
            if playerPed2 then
                playerPed2 = ipairs
                playerPed6 = controlmachines
                playerPed2, playerPed6, serverId, playerPed4 = playerPed2(playerPed6)
                for entityCoords3, playerPed in playerPed2, playerPed6, serverId, playerPed4 do
                    playerPed3 = playercurrentcoords
                    entityCoords = playerPed.coords
                    playerPed3 = playerPed3 - entityCoords
                    playerPed3 = #playerPed3
                    if playerPed3 < 20.0 then
                        entityCoords = Config
                        entityCoords = entityCoords.ThemeParkControlMachineSettings
                        entityCoords = entityCoords.usedistance
                        if playerPed3 < entityCoords and (-1 == playerPed5 or playerPed5 > playerPed3) then
                            playerPed5 = playerPed3
                            entityCoords2 = true
                            coords = entityCoords3
                        end
                    end
                end
            end
            if entityCoords2 then
                attractioncontrolid = coords
                playerPed2 = usingattraction
                if false == playerPed2 then
                    playerPed2 = inattractioncontrolmenu
                    if false == playerPed2 then
                        dataTable2 = false
                        playerPed2 = Config
                        playerPed2 = playerPed2.Target
                        if false == playerPed2 then
                            playerPed2 = controlmachines
                            playerPed6 = attractioncontrolid
                            playerPed2 = playerPed2[playerPed6]
                            playerPed6 = Config
                            playerPed6 = playerPed6.ThemeParkInteractionSystem
                            if 1 == playerPed6 then
                                playerPed6 = SendNUIMessage
                                serverId = {}
                                serverId.message = "infonotifyshow"
                                playerPed4 = Language
                                entityCoords3 = Config
                                entityCoords3 = entityCoords3.Language
                                playerPed4 = playerPed4[entityCoords3]
                                playerPed4 = playerPed4.pressforcontrolthemeparkinteract
                                serverId.infonotifytext = playerPed4
                                playerPed6(serverId)
                            else
                                playerPed6 = Config
                                playerPed6 = playerPed6.ThemeParkInteractionSystem
                                if 2 == playerPed6 then
                                    playerPed6 = DrawText3D
                                    serverId = playerPed2.coords
                                    serverId = serverId.x
                                    playerPed4 = playerPed2.coords
                                    playerPed4 = playerPed4.y
                                    entityCoords3 = playerPed2.coords
                                    entityCoords3 = entityCoords3.z
                                    entityCoords3 = entityCoords3 + 1.0
                                    playerPed = Language
                                    playerPed3 = Config
                                    playerPed3 = playerPed3.Language
                                    playerPed = playerPed[playerPed3]
                                    playerPed = playerPed.pressforcontrolthemepark
                                    playerPed6(serverId, playerPed4, entityCoords3, playerPed)
                                else
                                    playerPed6 = Config
                                    playerPed6 = playerPed6.ThemeParkInteractionSystem
                                    if 3 == playerPed6 then
                                        playerPed6 = ShowGtaClassicInteraction
                                        serverId = Language
                                        playerPed4 = Config
                                        playerPed4 = playerPed4.Language
                                        serverId = serverId[playerPed4]
                                        serverId = serverId.pressforcontrolthemeparkinteractclassic
                                        playerPed6(serverId)
                                    end
                                end
                            end
                        end
                    end
                else
                    playerPed2 = Config
                    playerPed2 = playerPed2.ThemeParkInteractionSystem
                    if 1 == playerPed2 then
                        playerPed2 = attractioncontrolid
                        if nil ~= playerPed2 then
                            playerPed2 = SendNUIMessage
                            playerPed6 = {}
                            playerPed6.message = "hide"
                            playerPed2(playerPed6)
                        end
                    end
                end
            else
                playerPed2 = Config
                playerPed2 = playerPed2.ThemeParkInteractionSystem
                if 1 == playerPed2 then
                    playerPed2 = attractioncontrolid
                    if nil ~= playerPed2 then
                        playerPed2 = SendNUIMessage
                        playerPed6 = {}
                        playerPed6.message = "hide"
                        playerPed2(playerPed6)
                    end
                end
                attractioncontrolid = nil
            end
            if dataTable2 then
                playerPed2 = Citizen
                playerPed2 = playerPed2.Wait
                playerPed6 = 1000
                playerPed2(playerPed6)
            end
        end
    end
    coords10(coords15)
    coords10 = _ENV
    coords15 = "Config"
    coords10 = coords10[coords15]
    coords15 = "Target"
    coords10 = coords10[coords15]
    coords15 = true
    if coords10 == coords15 then
        coords10 = RegisterNetEvent
        coords15 = "rtx_themepark:Global:ControlAttractionTarget"
        coords10(coords15)
        coords10 = AddEventHandler
        coords15 = "rtx_themepark:Global:ControlAttractionTarget"

        function coords8()
            local dataTable2, entityCoords2, playerPed5
            dataTable2 = iteminhand
            if false == dataTable2 then
                dataTable2 = inattractioncontrolmenu
                if false == dataTable2 then
                    dataTable2 = attractioncontrolid
                    if nil ~= dataTable2 then
                        dataTable2 = TriggerServerEvent
                        entityCoords2 = "rtx_themepark:Global:ThemeParkOpenControlMenu"
                        playerPed5 = attractioncontrolid
                        dataTable2(entityCoords2, playerPed5)
                    end
                end
            end
        end
        coords10(coords15, coords8)
    else
        coords10 = RegisterCommand
        coords15 = "opencontrolmenu"

        function coords8()
            local dataTable2, entityCoords2, playerPed5
            dataTable2 = iteminhand
            if false == dataTable2 then
                dataTable2 = inattractioncontrolmenu
                if false == dataTable2 then
                    dataTable2 = attractioncontrolid
                    if nil ~= dataTable2 then
                        dataTable2 = TriggerServerEvent
                        entityCoords2 = "rtx_themepark:Global:ThemeParkOpenControlMenu"
                        playerPed5 = attractioncontrolid
                        dataTable2(entityCoords2, playerPed5)
                    end
                end
            end
        end
        coords10(coords15, coords8)
        coords10 = RegisterKeyMapping
        coords15 = "opencontrolmenu"
        coords8 = _ENV
        coords5 = "Language"
        coords8 = coords8[coords5]
        coords5 = _ENV
        coords9 = "Config"
        coords5 = coords5[coords9]
        coords9 = "Language"
        coords5 = coords5[coords9]
        coords8 = coords8[coords5]
        coords5 = "controlattraction"
        coords8 = coords8[coords5]
        coords5 = "keyboard"
        coords9 = _ENV
        coords22 = "Config"
        coords9 = coords9[coords22]
        coords22 = "ThemeParkControlMachineSettings"
        coords9 = coords9[coords22]
        coords9 = coords9.usekey
        coords10(coords15, coords8, coords5, coords9)
    end
end
coords10 = _ENV
coords15 = "Config"
coords10 = coords10[coords15]
coords15 = "ThemeParkPass"
coords10 = coords10[coords15]
if coords10 then
    coords10 = RegisterNetEvent
    coords15 = "rtx_themepark:Global:ThemeParkPassActivate"
    coords10(coords15)
    coords10 = AddEventHandler
    coords15 = "rtx_themepark:Global:ThemeParkPassActivate"

    function coords8()
        local dataTable2, entityCoords2
        dataTable2 = true
        coords3 = dataTable2
        dataTable2 = Config
        dataTable2 = dataTable2.ThemeParkPassTime
        dataTable2 = dataTable2 * 60
        counter2 = dataTable2
    end
    coords10(coords15, coords8)
    coords10 = _ENV
    coords15 = "Citizen"
    coords10 = coords10[coords15]
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2, playerPed5
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 0
            dataTable2(entityCoords2)
            dataTable2 = coords3
            if true == dataTable2 then
                dataTable2 = nearbythemepark
                if dataTable2 then
                    dataTable2 = Citizen
                    dataTable2 = dataTable2.Wait
                    entityCoords2 = 1000
                    dataTable2(entityCoords2)
                    dataTable2 = counter2
                    if dataTable2 >= 1 then
                        dataTable2 = counter2
                        dataTable2 = dataTable2 - 1
                        counter2 = dataTable2
                        dataTable2 = tickets
                        dataTable2.gforce = true
                        dataTable2 = tickets
                        dataTable2.topscan = true
                        dataTable2 = tickets
                        dataTable2.vortex = true
                        dataTable2 = tickets
                        dataTable2.detonator = true
                        dataTable2 = tickets
                        dataTable2.boat = true
                        dataTable2 = tickets
                        dataTable2.ferris = true
                        dataTable2 = tickets
                        dataTable2.rollercoaster = true
                        dataTable2 = tickets
                        dataTable2.prater = true
                        dataTable2 = tickets
                        dataTable2.brakedance = true
                        dataTable2 = tickets
                        dataTable2.slingshot = true
                        dataTable2 = tickets
                        dataTable2.carousel = true
                        dataTable2 = tickets
                        dataTable2.extasy = true
                        dataTable2 = tickets
                        dataTable2.spinride = true
                        dataTable2 = tickets
                        dataTable2.hauntedhouse = true
                        dataTable2 = tickets
                        dataTable2.rollercoaster2 = true
                        dataTable2 = tickets
                        dataTable2.cannon = true
                    else
                        dataTable2 = 0
                        counter2 = dataTable2
                        dataTable2 = false
                        coords3 = dataTable2
                        dataTable2 = Notify
                        entityCoords2 = Language
                        playerPed5 = Config
                        playerPed5 = playerPed5.Language
                        entityCoords2 = entityCoords2[playerPed5]
                        entityCoords2 = entityCoords2.themeparkpassexpired
                        dataTable2(entityCoords2)
                        dataTable2 = tickets
                        dataTable2.gforce = false
                        dataTable2 = tickets
                        dataTable2.topscan = false
                        dataTable2 = tickets
                        dataTable2.vortex = false
                        dataTable2 = tickets
                        dataTable2.detonator = false
                        dataTable2 = tickets
                        dataTable2.boat = false
                        dataTable2 = tickets
                        dataTable2.ferris = false
                        dataTable2 = tickets
                        dataTable2.rollercoaster = false
                        dataTable2 = tickets
                        dataTable2.prater = false
                        dataTable2 = tickets
                        dataTable2.brakedance = false
                        dataTable2 = tickets
                        dataTable2.slingshot = false
                        dataTable2 = tickets
                        dataTable2.carousel = false
                        dataTable2 = tickets
                        dataTable2.extasy = false
                        dataTable2 = tickets
                        dataTable2.spinride = false
                        dataTable2 = tickets
                        dataTable2.hauntedhouse = false
                        dataTable2 = tickets
                        dataTable2.rollercoaster2 = false
                        dataTable2 = tickets
                        dataTable2.cannon = false
                    end
                end
            else
                dataTable2 = Citizen
                dataTable2 = dataTable2.Wait
                entityCoords2 = 1500
                dataTable2(entityCoords2)
            end
        end
    end
    coords10(coords15)
end
coords10 = _ENV
coords15 = "Config"
coords10 = coords10[coords15]
coords10 = coords10.ThemeParkDisableTicketSystem
if coords10 then
    coords10 = _ENV
    coords15 = "Citizen"
    coords10 = coords10[coords15]
    coords10 = coords10.CreateThread

    function coords15()
        local dataTable2, entityCoords2
        while true do
            dataTable2 = Citizen
            dataTable2 = dataTable2.Wait
            entityCoords2 = 0
            dataTable2(entityCoords2)
            dataTable2 = nearbythemepark
            if dataTable2 then
                dataTable2 = Citizen
                dataTable2 = dataTable2.Wait
                entityCoords2 = 1000
                dataTable2(entityCoords2)
                dataTable2 = tickets
                dataTable2.gforce = true
                dataTable2 = tickets
                dataTable2.topscan = true
                dataTable2 = tickets
                dataTable2.vortex = true
                dataTable2 = tickets
                dataTable2.detonator = true
                dataTable2 = tickets
                dataTable2.boat = true
                dataTable2 = tickets
                dataTable2.ferris = true
                dataTable2 = tickets
                dataTable2.rollercoaster = true
                dataTable2 = tickets
                dataTable2.prater = true
                dataTable2 = tickets
                dataTable2.brakedance = true
                dataTable2 = tickets
                dataTable2.slingshot = true
                dataTable2 = tickets
                dataTable2.carousel = true
                dataTable2 = tickets
                dataTable2.extasy = true
                dataTable2 = tickets
                dataTable2.spinride = true
                dataTable2 = tickets
                dataTable2.hauntedhouse = true
                dataTable2 = tickets
                dataTable2.rollercoaster2 = true
                dataTable2 = tickets
                dataTable2.cannon = true
            else
                dataTable2 = Citizen
                dataTable2 = dataTable2.Wait
                entityCoords2 = 1500
                dataTable2(entityCoords2)
            end
        end
    end
    coords10(coords15)
end