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

MaterialList = {
    Default = -1775485061,
    Concrete = 1187676648,
    ConcretePothole = 359120722,
    ConcreteDusty = -1084640111,
    Tarmac = 282940568,
    TarmacPainted = -1301352528,
    TarmacPothole = 1886546517,
    RumbleStrip = -250168275,
    BreezeBlock = -954112554,
    Rock = -840216541,
    RockMossy = -124769592,
    Stone = 765206029,
    Cobblestone = 576169331,
    Brick = 1639053622,
    Marble = 1945073303,
    PavingSlab = 1907048430,
    SandstoneSolid = 592446772,
    SandstoneBrittle = 1913209870,
    SandLoose = -1595148316,
    SandCompact = 510490462,
    SandWet = 909950165,
    SandTrack = -1907520769,
    SandUnderwater = -1136057692,
    SandDryDeep = 509508168,
    SandWetDeep = 1288448767,
    Ice = -786060715,
    IceTarmac = -1931024423,
    SnowLoose = -1937569590,
    SnowCompact = -878560889,
    SnowDeep = 1619704960,
    SnowTarmac = 1550304810,
    GravelSmall = 951832588,
    GravelLarge = 2128369009,
    GravelDeep = -356706482,
    GravelTrainTrack = 1925605558,
    DirtTrack = -1885547121,
    MudHard = -1942898710,
    MudPothole = 312396330,
    MudSoft = 1635937914,
    MudUnderwater = -273490167,
    MudDeep = 1109728704,
    Marsh = 223086562,
    MarshDeep = 1584636462,
    Soil = -700658213,
    ClayHard = 1144315879,
    ClaySoft = 560985072,
    GrassLong = -461750719,
    Grass = 1333033863,
    GrassShort = -1286696947,
    Hay = -1833527165,
    Bushes = 581794674,
    Twigs = -913351839,
    Leaves = -2041329971,
    TreeBark = -1915425863,
    Woodchips = -309121453,
    WoodSolidSmall = -399872228,
    WoodSolidMedium = 555004797,
    WoodSolidLarge = 815762359,
    WoodSolidPolished = 126470059,
    WoodFloorDusty = -749452322,
    WoodHollowSmall = 1993976879,
    WoodHollowMedium = -365476163,
    WoodHollowLarge = -925419289,
    WoodChipboard = 1176309403,
    WoodOldCreaky = 722686013,
    WoodHighDensity = -1742843392,
    WoodLattice = 2011204130,
    Ceramic = -1186320715,
    RoofTile = 1755188853,
    RoofFelt = -1417164731,
    Fibreglass = 1354180827,
    Tarpaulin = -642658848,
    Plastic = -2073312001,
    PlasticHollow = 627123000,
    PlasticHighDensity = -1625995479,
    PlasticClear = -1859721013,
    PlasticHollowClear = 772722531,
    PlasticHighDensityClear = -1338473170,
    FibreglassHollow = -766055098,
    Rubber = -145735917,
    RubberHollow = -783934672,
    Linoleum = 289630530,
    Laminate = 1845676458,
    Cloth = 122789469,
    PlasterSolid = -574122433,
    PlasterBrittle = -251888898,
    CardboardSheet = 236511221,
    CardboardBox = -1409054440,
    Paper = 474149820,
    Foam = 808719444,
    FeatherPillow = 1341866303,
    Polystyrene = -1756927331,
    Leather = -570470900,
    Tvscreen = 1429989756,
    SlattedBlinds = 673696729,
    GlassShootThrough = 937503243,
    GlassBulletproof = 244521486,
    GlassOpaque = 1500272081,
    Perspex = -1619794068,
    CarpetSolid = 669292054,
    CarpetSolidDusty = 158576196,
    CarpetFloorboard = -1396484943,
    CarPlastic = 2137197282,
    CarSofttop = -979647862,
    CarSofttopClear = 2130571536,
    CarGlassWeak = 1247281098,
    CarGlassMedium = 602884284,
    CarGlassStrong = 1070994698,
    CarGlassBulletproof = -1721915930,
    CarGlassOpaque = 513061559,
    Water = 435688960,
    Blood = 5236042,
    Oil = -634481305,
    Petrol = -1634184340,
    FreshMeat = 868733839,
    DriedMeat = -1445160429,
    EmissiveGlass = 1501078253,
    EmissivePlastic = 1059629996,
    VfxMetalElectrified = -309134265,
    VfxMetalWaterTower = 611561919,
    VfxMetalSteam = -691277294,
    VfxMetalFlame = 332778253,
    PhysNoFriction = 1666473731,
    PhysGolfBall = -1693813558,
    PhysTennisBall = -256704763,
    PhysCaster = -235302683,
    PhysCasterRusty = 2016463089,
    PhysCarVoid = 1345867677,
    PhysPedCapsule = -291631035,
    PhysElectricFence = -1170043733,
    PhysElectricMetal = -2013761145,
    PhysBarbedWire = -1543323456,
    PhysPooltableSurface = 605776921,
    PhysPooltableCushion = 972939963,
    PhysPooltableBall = -748341562,
    Buttocks = 483400232,
    ThighLeft = -460535871,
    ShinLeft = 652772852,
    FootLeft = 1926285543,
    ThighRight = -236981255,
    ShinRight = -446036155,
    FootRight = -1369136684,
    Spine0 = -1922286884,
    Spine1 = -1140112869,
    Spine2 = 1457572381,
    Spine3 = 32752644,
    ClavicleLeft = -1469616465,
    UpperArmLeft = -510342358,
    LowerArmLeft = 1045062756,
    HandLeft = 113101985,
    ClavicleRight = -1557288998,
    UpperArmRight = 1501153539,
    LowerArmRight = 1777921590,
    HandRight = 2000961972,
    Neck = 1718294164,
    Head = -735392753,
    AnimalDefault = 286224918,
    CarEngine = -1916939624,
    Puddle = 999829011,
    ConcretePavement = 2015599386,
    BrickPavement = -1147361576,
    PhysDynamicCoverBound = -2047468855,
    VfxWoodBeerBarrel = 998201806,
    WoodHighFriction = -2140087047,
    RockNoinst = 127813971,
    BushesNoinst = 1441114862,
    MetalSolidRoadSurface = -729112334,
    StuntRampSurface = -2088174996,
    MetalSolidSmall = -1447280105,
    MetalSolidMedium = -365631240,
    MetalSolidLarge = 752131025,
    MetalHollowSmall = 15972667,
    MetalHollowMedium = 1849540536,
    MetalHollowLarge = -583213831,
    MetalChainlinkSmall = 762193613,
    MetalChainlinkLarge = 125958708,
    MetalCorrugatedIron = 834144982,
    MetalGrille = -426118011,
    MetalRailing = 2100727187,
    MetalDuct = 1761524221,
    MetalGarageDoor = -231260695,
    MetalManhole = -754997699,
    CarMetal = -93061983,
}

local clothMaterials = {
    [MaterialList.Cloth] = true,
    [MaterialList.CarpetSolidDusty] = true,
    [MaterialList.CarpetFloorboard] = true,
    [MaterialList.CarpetSolid] = true,
}

local woodMaterials = {
    [MaterialList.Woodchips] = true,
    [MaterialList.WoodSolidSmall] = true,
    [MaterialList.WoodSolidMedium] = true,
    [MaterialList.WoodSolidLarge] = true,
    [MaterialList.WoodSolidPolished] = true,
    [MaterialList.WoodFloorDusty] = true,
    [MaterialList.WoodHollowSmall] = true,
    [MaterialList.WoodHollowMedium] = true,
    [MaterialList.WoodHollowLarge] = true,
    [MaterialList.WoodChipboard] = true,
    [MaterialList.WoodOldCreaky] = true,
    [MaterialList.WoodHighDensity] = true,
    [MaterialList.WoodLattice] = true,
}

local metalMaterials = {
    [MaterialList.MetalSolidSmall] = true,
    [MaterialList.MetalSolidMedium] = true,
    [MaterialList.MetalSolidLarge] = true,
    [MaterialList.MetalHollowSmall] = true,
    [MaterialList.MetalHollowMedium] = true,
    [MaterialList.MetalHollowLarge] = true,
    [MaterialList.MetalChainlinkSmall] = true,
    [MaterialList.MetalChainlinkLarge] = true,
    [MaterialList.MetalCorrugatedIron] = true,
    [MaterialList.MetalGrille] = true,
    [MaterialList.MetalRailing] = true,
    [MaterialList.MetalDuct] = true,
    [MaterialList.MetalGarageDoor] = true,
    [MaterialList.MetalManhole] = true,
    [MaterialList.CarMetal] = true,
}

local hardSandMaterials = {
    [MaterialList.SandstoneSolid] = true,
    [MaterialList.SandDryDeep] = true,
}

local softSandMaterials = {
    [MaterialList.SandstoneBrittle] = true,
    [MaterialList.SandLoose] = true,
    [MaterialList.SandCompact] = true,
    [MaterialList.SandTrack] = true,
}

local grassMaterials = {
    [MaterialList.GrassLong] = true,
    [MaterialList.Grass] = true,
    [MaterialList.GrassShort] = true,
}

local wetMaterials = {
    [MaterialList.SandUnderwater] = true,
    [MaterialList.MudUnderwater] = true,
    [MaterialList.SandWet] = true,
    [MaterialList.Blood] = true,
    [MaterialList.Oil] = true,
    [MaterialList.Petrol] = true,
    [MaterialList.SandWetDeep] = true,
}

local waterMaterials = {
    [MaterialList.Water] = true,
    [MaterialList.Puddle] = true,
}

function IsMaterialAnyClothes(materialHash)
    return clothMaterials[materialHash] ~= nil
end

function IsMaterialAnyWood(materialHash)
    return woodMaterials[materialHash] ~= nil
end

function IsMaterialAnyMetal(materialHash)
    return metalMaterials[materialHash] ~= nil
end

function IsMaterialAnyHardSand(materialHash)
    return hardSandMaterials[materialHash]
end

function IsMaterialAnySoftSand(materialHash)
    return softSandMaterials[materialHash]
end

function IsMaterialAnyGrass(materialHash)
    return grassMaterials[materialHash]
end

function IsMaterialAnyWet(materialHash)
    return wetMaterials[materialHash]
end

function IsMaterialAnyWater(materialHash)
    return waterMaterials[materialHash]
end

function GetMaterialType(materialHash)
    if IsMaterialAnyWood(materialHash) then
        return MaterialType.WOOD
    end

    if IsMaterialAnyClothes(materialHash) then
        return MaterialType.CLOTHES
    end

    if IsMaterialAnyMetal(materialHash) then
        return MaterialType.METAL
    end

    if IsMaterialAnyHardSand(materialHash) then
        return MaterialType.HARD_SAND
    end

    if IsMaterialAnySoftSand(materialHash) then
        return MaterialType.SOFT_SAND
    end

    if IsMaterialAnyGrass(materialHash) then
        return MaterialType.GRASS
    end

    if IsMaterialAnyWet(materialHash) then
        return MaterialType.WET
    end

    if IsMaterialAnyWater(materialHash) then
        return MaterialType.WATER
    end

    return MaterialType.NONE
end
