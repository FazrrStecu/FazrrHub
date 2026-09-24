--[[
    ============================================
    FPS BOOSTER VVIP - SMART FILTER
    by AlgoxPDX | Owner: Tuan Fazrr
    Cuma matiin yang ga penting, visual tetep cakep
    Delta Executor / Redfinger AFK
    ============================================
]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local LP = Players.LocalPlayer

local boostOn = false
local saved = {}
local loopThread = nil
local touchedObjects = {}   -- simpan yg udah dimatiin biar ga scan ulang

-- ===== DAFTAR PUTIH (JANGAN DIMATIIN - PENTING) =====
local WHITELIST_CLASS = {
    ["Humanoid"] = true,
    ["BasePart"] = true,
    ["MeshPart"] = true,
    ["Decal"] = true,
    ["Texture"] = true,
    ["SurfaceGui"] = true,
    ["BillboardGui"] = true,
    ["ScreenGui"] = true,
    ["Sky"] = true,
    ["Atmosphere"] = true,
    ["ColorCorrectionEffect"] = true,
}

-- ===== DAFTAR HITAM (MATIIN - GA PENTING & BERAT) =====
local BLACKLIST_CLASS = {
    ["ParticleEmitter"] = true,      -- efek debu/asap numpuk
    ["Trail"] = true,                 -- jejak gerak
    ["Smoke"] = true,                 -- asap
    ["Fire"] = true,                  -- api partikel
    ["Sparkles"] = true,              -- kilau
    ["Beam"] = true,                  -- sinar laser
    ["Highlight"] = true,             -- outline objek
    ["SelectionBox"] = true,          -- kotak seleksi
    ["SelectionSphere"] = true,
    ["BlurEffect"] = true,            -- blur berat
    ["DepthOfFieldEffect"] = true,    -- fokus kamera
    ["SunRaysEffect"] = true,         -- sinar matahari
    ["BloomEffect"] = true,           -- glow berat
    ["Explosion"] = true,
}

-- ===== SAVE =====
local function saveAll()
    saved.GlobalShadows = Lighting.GlobalShadows
    saved.FogEnd = Lighting.FogEnd
    saved.Brightness = Lighting.Brightness
    saved.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    saved.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
    saved.ShadowSoftness = Lighting.ShadowSoftness
    saved.Quality = settings().Rendering.QualityLevel
    saved.MeshDetail = settings().Rendering.MeshPartDetailLevel
    saved.TerrainDeco = Terrain and Terrain.Decoration or true
end

-- ===== LIGHTING (soft, cuma matiin yg berat) =====
local function tuneLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 8000
    Lighting.Brightness = 2
    Lighting.EnvironmentDiffuseScale = 0.4
    Lighting.EnvironmentSpecularScale = 0.4
    Lighting.ShadowSoftness = 0

    for _, v in pairs(Lighting:GetChildren()) do
        pcall(function()
            if BLACKLIST_CLASS[v.ClassName] then
                v.Enabled = false
                touchedObjects[v] = true
            end
        end)
    end
end

-- ===== TERRAIN (matiin cuma dekorasi rumput) =====
local function tuneTerrain()
    if Terrain then
        pcall(function()
            Terrain.Decoration = false
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
        end)
    end
end

-- ===== OBJECT SCAN (SMART FILTER) =====
local function scanAndKill(parent)
    for _, obj in pairs(parent:GetDescendants()) do
        if touchedObjects[obj] then continue end
        pcall(function()
            if BLACKLIST_CLASS[obj.ClassName] then
                obj.Enabled = false
                touchedObjects[obj] = true
            end
        end)
    end
end

-- ===== RENDER (medium biar masih enak dilihat) =====
local function tuneRender()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level04
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level02
        settings().Rendering.EdtEnabled = false
    end)
end

-- ===== SELF (cuma matiin shadow karakter) =====
local function tuneSelf()
    local char = LP.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") then
                v.CastShadow = false
            elseif BLACKLIST_CLASS[v.ClassName] then
                v.Enabled = false
                touchedObjects[v] = true
            end
        end)
    end
end

-- ===== ON =====
local function enableBoost()
    if boostOn then return end
    boostOn = true
    saveAll()
    tuneLighting()
    tuneTerrain()
    scanAndKill(Workspace)
    scanAndKill(Lighting)
    tuneRender()
    tuneSelf()

    -- Auto scan objek baru tiap 8 detik (biar tetep stabil kalo ada spawn baru)
    loopThread = task.spawn(function()
        while boostOn do
            task.wait(8)
            if boostOn then
                scanAndKill(Workspace)
                tuneSelf()
            end
        end
    end)
end

-- ===== OFF =====
local function disableBoost()
    if not boostOn then return end
    boostOn = false
    if loopThread then pcall(function() task.cancel(loopThread) end)
