--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                    FAZRR HUB - PREMIUM V1.1                  ║
    ║              Steal An Egg | Delta Executor                   ║
    ║                  Owner: Tuan Fazrr                           ║
    ╚══════════════════════════════════════════════════════════════╝
]]

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// UI PARENT (FIX: CoreGui kadang ke-block)
local UI_PARENT = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local Config = {
    AutoSteal = false,
    AutoPlace = false,
    AutoHatch = false,
    AutoTreadmill = false,
    GuardImmunity = false,
    RandomTiming = false,
    ESP_Egg = false,
    ESP_Pet = false,
    ESP_Player = false,
    BoostFPS = false,
    HideOwnerPlot = false,
    HideOtherEggs = false,
    NoClip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    MovementMode = "Tween",
    SelectBy = "Rarity",
    PlaceMode = "All",
    WebhookURL = "",
    WebhookAlerts = false,
    AutoLoad = false,
}

local ConfigFolder = "FazrrHub_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

--// ANTI DETECTION
local function bypassAntiCheat()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" then return nil end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end

        for _, v in pairs(getconnections(LocalPlayer.Idled)) do
            v:Disconnect()
        end

        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end
bypassAntiCheat()

--// WEBHOOK
local function sendWebhook(title, message, color)
    if not Config.WebhookAlerts or Config.WebhookURL == "" then return end
    pcall(function()
        request({
            Url = Config.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = title,
                    description = message,
                    color = color or 65280,
                    footer = {text = "Fazrr Hub | " .. os.date("%X")}
                }}
            })
        })
    end)
end

--// LOADING SCREEN
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "FazrrHub_Loading"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = UI_PARENT

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 500, 0, 300)
LoadingFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = LoadingGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 16)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Color3.fromRGB(138, 43, 226)
LoadingStroke.Thickness = 2
LoadingStroke.Parent = LoadingFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 60)
TitleLabel.Position = UDim2.new(0, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FAZRR HUB"
TitleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = LoadingFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
}
TitleGradient.Parent = TitleLabel

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, 0, 0, 25)
SubLabel.Position = UDim2.new(0, 0, 0, 90)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Premium Script | Steal An Egg | v1.1"
SubLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubLabel.TextScaled = true
SubLabel.Font = Enum.Font.Gotham
SubLabel.Parent = LoadingFrame

local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(0.8, 0, 0, 8)
ProgressBg.Position = UDim2.new(0.1, 0, 0.7, 0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = LoadingFrame

local ProgressBgCorner = Instance.new("UICorner")
ProgressBgCorner.CornerRadius = UDim.new(1, 0)
ProgressBgCorner.Parent = ProgressBg

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBg

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(1, 0)
ProgressBarCorner.Parent = ProgressBar

local ProgressGradient = Instance.new("UIGradient")
ProgressGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
}
ProgressGradient.Parent = ProgressBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.78, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = LoadingFrame

local loadingSteps = {"Initializing...", "Bypassing Anti-Cheat...", "Loading Remote...", "Injecting UI...", "Ready!"}
for i, step in ipairs(loadingSteps) do
    StatusLabel.Text = step
    TweenService:Create(ProgressBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(i / #loadingSteps, 0, 1, 0)
    }):Play()
    task.wait(0.5)
end
task.wait(0.3)
LoadingGui:Destroy()

--// MAIN UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FazrrHub_Main"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = UI_PARENT

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 14)
TitleBarCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "FAZRR HUB v1.1"
TitleText.TextColor3 = Color3.fromRGB(138, 43, 226)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local FloatingOrb = Instance.new("TextButton")
FloatingOrb.Size = UDim2.new(0, 50, 0, 50)
FloatingOrb.Position = UDim2.new(0, 20, 0.5, -25)
FloatingOrb.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
FloatingOrb.Text = "F"
FloatingOrb.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingOrb.Font = Enum.Font.GothamBold
FloatingOrb.TextSize = 24
FloatingOrb.BorderSizePixel = 0
FloatingOrb.Visible = true
FloatingOrb.Parent = ScreenGui

local OrbCorner = Instance.new("UICorner")
OrbCorner.CornerRadius = UDim.new(1, 0)
OrbCorner.Parent = FloatingOrb

local OrbStroke = Instance.new("UIStroke")
OrbStroke.Color = Color3.fromRGB(0, 255, 255)
OrbStroke.Thickness = 2
OrbStroke.Parent = FloatingOrb

local orbDragging = false
local orbDragStart, orbStartPos

FloatingOrb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        orbDragging = true
        orbDragStart = input.Position
        orbStartPos = FloatingOrb.Position
    end
end)
FloatingOrb.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        orbDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if orbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - orbDragStart
        FloatingOrb.Position = UDim2.new(orbStartPos.X.Scale, orbStartPos.X.Offset + delta.X, orbStartPos.Y.Scale, orbStartPos.Y.Offset + delta.Y)
    end
end)

local function toggleUI()
    MainFrame.Visible = not MainFrame.Visible
    FloatingOrb.Visible = not MainFrame.Visible
end

FloatingOrb.MouseButton1Click:Connect(toggleUI)
MinimizeBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 130, 1, -50)
TabContainer.Position = UDim2.new(0, 5, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -55)
ContentContainer.Position = UDim2.new(0, 140, 0, 45)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentContainer

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.Parent = TabContainer

local tabs = {}
local activeTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    page.Visible = false
    page.Parent = ContentContainer

    local pageList = Instance.new("UIListLayout")
    pageList.Padding = UDim.new(0, 6)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = page

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 5)
    pagePadding.PaddingLeft = UDim.new(0, 5)
    pagePadding.PaddingRight = UDim.new(0, 5)
    pagePadding.Parent = page

    tabs[name] = {button = btn, page = page}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            t.button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeTab = name
    end)

    return page
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

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

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBg.BackgroundColor3 = default and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg

    local toggleDot = Instance.new("Frame")
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBg

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = toggleDot

    local state = default

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 60)
        }):Play()
        TweenService:Create(toggleDot, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        if callback then callback(state) end
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

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

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local value = default
    local dragging = false

    local function updateSlider(input)
        local mouseX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
        local percent = mouseX / sliderBg.AbsoluteSize.X
        value = math.floor(min + (max - min) * percent)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text .. ": " .. value
        if callback then callback(value) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    return frame
end

local function createDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 32)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 30, 0, 32)
    arrow.Position = UDim2.new(1, -35, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(138, 43, 226)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local expanded = false
    local selected = default

    local optionContainer = Instance.new("Frame")
    optionContainer.Size = UDim2.new(1, 0, 0, #options * 28)
    optionContainer.Position = UDim2.new(0, 0, 0, 32)
    optionContainer.BackgroundTransparency = 1
    optionContainer.Parent = frame

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.BorderSizePixel = 0
        optBtn.Parent = optionContainer

        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            label.Text = text .. ": " .. selected
            frame.Size = UDim2.new(1, -10, 0, 32)
            expanded = false
            if callback then callback(selected) end
        end)
    end

    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        frame.Size = expanded and UDim2.new(1, -10, 0, 32 + #options * 28) or UDim2.new(1, -10, 0, 32)
    end)

    return frame
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

local function createInput(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.new(0, 10, 0, 0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = frame

    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)

    return box
end

--// TAB 1: AUTO STEAL
local autoStealPage = createTab("Auto Steal")
createToggle(autoStealPage, "Auto Steal", false, function(v) Config.AutoSteal = v end)
createToggle(autoStealPage, "Guard Immunity", false, function(v) Config.GuardImmunity = v end)
createToggle(autoStealPage, "Randomize Timing", false, function(v) Config.RandomTiming = v end)
createToggle(autoStealPage, "Auto Treadmill (No Eggs)", false, function(v) Config.AutoTreadmill = v end)
createDropdown(autoStealPage, "Select By", {"Rarity", "Name", "Mutation", "Value/Weight"}, "Rarity", function(v) Config.SelectBy = v end)
createDropdown(autoStealPage, "Movement Mode", {"Tween", "Fly", "Semi Teleport"}, "Tween", function(v) Config.MovementMode = v end)

--// TAB 2: AUTO PLACE
local autoPlacePage = createTab("Auto Place")
createToggle(autoPlacePage, "Auto Place Egg", false, function(v) Config.AutoPlace = v end)
createToggle(autoPlacePage, "Auto Hatch Ready", false, function(v) Config.AutoHatch = v end)
createDropdown(autoPlacePage, "Place Mode", {"All", "Selects"}, "All", function(v) Config.PlaceMode = v end)

--// TAB 3: ESP
local espPage = createTab("ESP")
createToggle(espPage, "Egg ESP", false, function(v) Config.ESP_Egg = v end)
createToggle(espPage, "Pet ESP", false, function(v) Config.ESP_Pet = v end)
createToggle(espPage, "Player ESP", false, function(v) Config.ESP_Player = v end)

--// TAB 4: PERFORMANCE
local perfPage = createTab("Performance")
createToggle(perfPage, "Boost FPS", false, function(v)
    Config.BoostFPS = v
    if v then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") then obj.Enabled = false end
        end
    end
end)
createToggle(perfPage, "Hide Owner Plot", false, function(v) Config.HideOwnerPlot = v end)
createToggle(perfPage, "Hide Other Eggs Placed", false, function(v) Config.HideOtherEggs = v end)

--// TAB 5: MOVEMENT
local movePage = createTab("Movement")
createSlider(movePage, "WalkSpeed", 16, 500, 16, function(v)
    Config.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)
createSlider(movePage, "JumpPower", 50, 500, 50, function(v)
    Config.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end)
createToggle(movePage, "No Clip", false, function(v)
    Config.NoClip = v
    if v then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

--// TAB 6: WEBHOOK
local webhookPage = createTab("Webhook")
createToggle(webhookPage, "Enable Webhook Alerts", false, function(v) Config.WebhookAlerts = v end)
createInput(webhookPage, "Webhook URL", function(v) Config.WebhookURL = v end)

--// TAB 7: CONFIG
local configPage = createTab("Config")
createInput(configPage, "Config Name", function(v) end)
createButton(configPage, "Save Config", function()
    writefile(ConfigFolder .. "/config.json", HttpService:JSONEncode(Config))
    sendWebhook("Config Saved", "Config berhasil disimpan!", 65280)
end)
createButton(configPage, "Load Config", function()
    if isfile(ConfigFolder .. "/config.json") then
        local data = HttpService:JSONDecode(readfile(ConfigFolder .. "/config.json"))
        for k, v in pairs(data) do Config[k] = v end
    end
end)
createButton(configPage, "Delete Config", function()
    if isfile(ConfigFolder .. "/config.json") then delfile(ConfigFolder .. "/config.json") end
end)

--// REMOTE DETECTION (V1.1 - REMOTE ASLI)
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

local function getGrabRemote()
    return findRemote("grab") or findRemote("steal") or findRemote("pick")
end

local function getPlaceRemote()
    return findRemote("place") or findRemote("deposit") or findRemote("put")
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
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = egg.PrimaryPart.Position
    local base = getBase()

    if Config.MovementMode == "Tween" then
        local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
        tween:Play()
        tween.Completed:Wait()
    else
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    end

    if Config.RandomTiming then task.wait(math.random(1, 3)) end

    local grabRemote = getGrabRemote()
    if grabRemote then
        pcall(function() grabRemote:FireServer(egg) end)
    end

    task.wait(0.2)

    if base then
        if Config.MovementMode == "Tween" then
            local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))})
            tween:Play()
            tween.Completed:Wait()
        else
            hrp.CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))
        end

        local placeRemote = getPlaceRemote()
        if placeRemote then
            pcall(function() placeRemote:FireServer(egg) end)
        end
    end
end

--// MAIN LOOP
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

--// AUTO LOAD CONFIG
if Config.AutoLoad and isfile(ConfigFolder .. "/config.json") then
    pcall(function()
        local data = HttpService:JSONDecode(readfile(ConfigFolder .. "/config.json"))
        for k, v in pairs(data) do Config[k] = v end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Config.WalkSpeed ~= 16 then char:WaitForChild("Humanoid").WalkSpeed = Config.WalkSpeed end
    if Config.JumpPower ~= 50 then char:WaitForChild("Humanoid").JumpPower = Config.JumpPower end
end)

sendWebhook("Fazrr Hub v1.1 Loaded", "Script berhasil di-load!", 65280)

StarterGui:SetCore("SendNotification", {
    Title = "Fazrr Hub v1.1",
    Text = "Script loaded! Tekan orb 'F' untuk buka menu.",
    Duration = 5
})
