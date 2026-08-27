
Config = {}

-- Seoul Base: abertura somente pelo AdminControl > Prop Editor.
Config.command = nil
Config.keybind = nil
Config.freezeStatus = true
Config.locale = 'pt-br'
-- Mapas salvos com 'permanente' carregam automaticamente para todos os jogadores.
Config.permanentRuntime = true

Config.camera = {
    moveSpeed = 14.0,
    fastMultiplier = 6.0,
    slowMultiplier = 0.25,
    mouseSensitivity = 6.0,
    fov = 50.0,
}

Config.snap = {
    grid = false,
    gridSize = 0.5,
    surface = true,
    alignToNormal = false,
    angle = false,
    angleStep = 15.0,
    snap = false,
    snapRadius = 4.0,
    snapThreshold = 0.5,
}

Config.precise = {
    move = 0.05,
    moveFast = 0.5,
    rotate = 1.0,
    rotateFast = 15.0,
}

Config.placement = {
    maxRayDistance = 100.0,
    ghostAlpha = 150,
}

Config.objectDefaults = {
    lod = 500,
    alpha = 255,
    collision = true,
    frozen = true,
    visible = true,
}

Config.categories = {
    { key = 'props',      label = 'Props' },
    { key = 'urban',      label = 'Urban' },
    { key = 'nature',     label = 'Natureza & Vegetação' },
    { key = 'interior',   label = 'Interior' },
    { key = 'industrial', label = 'Industrial' },
    { key = 'lights',     label = 'Luzes' },
    { key = 'misc',       label = 'Diversos' },
}

Config.customProps = {}

Config.brush = {
    radius = 5.0,
    minRadius = 1.0,
    maxRadius = 40.0,
    density = 4,
    spacing = 1.5,
    randomYaw = true,
    alignToSurface = true,
    randomTilt = 6.0,
    scatterCount = 25,
    tickMs = 70,
}

Config.map = {
    image = 'map.png',
    minX = -4000.0, maxX = 4500.0,
    minY = -2250.0, maxY = 6250.0,
}
