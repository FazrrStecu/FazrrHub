--[[
    FAZRR HUB v1.2 - DELTA MINIMALIS
    Steal An Egg | Owner: Tuan Fazrr
]]

--// SIMPLE GUI (PASTI JALAN DI DELTA)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// HAPUS GUI LAMA
for _, v in ipairs(PlayerGui:GetChildren()) do
    if v.Name == "FazrrHub" then v:Destroy() end
end

--// CONFIG
local Config = {
    AutoSteal = false, GuardImmunity = false, RandomTiming = false,
    AutoTreadmill = false, AutoPlace = false, AutoHatch = false,
    ESP_Egg = false, ESP_Pet = false, ESP_Player = false,
    BoostFPS = false, NoClip = false,
    WalkSpeed = 16, JumpPower = 50,
    MovementMode = "Tween", SelectBy = "Rarity", PlaceMode = "All",
}

--// ANTI-AFK SIMPLE
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

--// MAIN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FazrrHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- FLOATING ORB
local Orb = Instance.new("TextButton")
Orb.Size = UDim2.new(0, 50, 0, 50)
Orb.Position = UDim2.new(0, 20, 0.5, -25)
Orb.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Orb.Text = "F"
Orb.TextColor3 = Color3.fromRGB(255, 255, 255)
Orb.Font = Enum.Font.GothamBold
Orb.TextSize = 24
Orb.BorderSizePixel = 0
Orb.Active = true
Orb.Draggable = true
Orb.Parent = ScreenGui

local OrbCorner = Instance.new("UICorner")
OrbCorner.CornerRadius = UDim.new(1, 0)
OrbCorner.Parent = Orb

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FAZRR HUB v1.2"
Title.TextColor3 = Color3.fromRGB(138, 43, 226)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- CLOSE BTN
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- TOGGLE
Orb.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    Orb.Visible = not MainFrame.Visible
end)

-- SCROLL CONTENT
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

-- TOGGLE BUILDER
local function addToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 60)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 60)
        btn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
end

-- BUTTON BUILDER
local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- SLIDER BUILDER
local function addSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fill

    local dragging = false
    local function update(input)
        local mx = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local pct = mx / sliderBg.AbsoluteSize.X
        local val = math.floor(min + (max - min) * pct)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        label.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    sliderBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i)
        end
    end)
    sliderBg.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
end

-- BUILD MENU
addToggle("Auto Steal", false, function(v) Config.AutoSteal = v end)
addToggle("Guard Immunity", false, function(v) Config.GuardImmunity = v end)
addToggle("Randomize Timing", false, function(v) Config.RandomTiming = v end)
addToggle("Auto Treadmill", false, function(v) Config.AutoTreadmill = v end)
addToggle("Auto Place Egg", false, function(v) Config.AutoPlace = v end)
addToggle("Auto Hatch Ready", false, function(v) Config.AutoHatch = v end)
addToggle("Egg ESP", false, function(v) Config.ESP_Egg = v end)
addToggle("Pet ESP", false, function(v) Config.ESP_Pet = v end)
addToggle("Player ESP", false, function(v) Config.ESP_Player = v end)
addToggle("Boost FPS", false, function(v)
    Config.BoostFPS = v
    if v then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
        end)
    end
end)
addToggle("No Clip", false, function(v)
    Config.NoClip = v
    if v then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end)

addSlider("WalkSpeed", 16, 500, 16, function(v)
    Config.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)
addSlider("JumpPower", 50, 500, 50, function(v)
    Config.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end)

addButton("Refresh Character", function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Config.WalkSpeed
            hum.JumpPower = Config.JumpPower
        end
    end
end)

addButton("Destroy GUI", function()
    ScreenGui:Destroy()
end)

-- REMOTE DETECTION
local RemoteCache = {}
local function findRemote(name)
    if RemoteCache[name] then return RemoteCache[name] end
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            if remote.Name:lower():find(name:lower()) then
                RemoteCache[name] = remote
                return remote
            end
        end
    end
    return nil
end

local function getEggs()
    local eggs = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("egg") or v.Name:lower():find("telur")) then
            table.insert(eggs, v)
        end
    end
    return eggs
end

local function getBase()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("base") then return v end
    end
    return nil
end

local function stealEgg(egg)
    if not egg or not egg.PrimaryPart then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = egg.PrimaryPart.Position
    local base = getBase()

    pcall(function()
        hrp.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
    end)

    if Config.RandomTiming then task.wait(math.random(1, 3)) end

    local grab = findRemote("grab") or findRemote("steal") or findRemote("pick")
    if grab then pcall(function() grab:FireServer(egg) end) end

    task.wait(0.2)

    if base then
        pcall(function()
            hrp.CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))
        end)
        local place = findRemote("place") or findRemote("deposit") or findRemote("put")
        if place then pcall(function() place:FireServer(egg) end) end
    end
end

-- MAIN LOOP
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoSteal then
            local eggs = getEggs()
            for _, egg in ipairs(eggs) do
                if egg and egg.Parent then stealEgg(egg) end
            end
        end
    end
end)

-- CHARACTER RESPAWN
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fazrr Hub v1.2",
        Text = "Script loaded! Tekan orb 'F' untuk buka menu.",
        Duration = 5
    })
end)
