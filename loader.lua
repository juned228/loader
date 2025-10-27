-- Unified Admin Script for Roblox
-- All features in single professional panel
-- Place this in StarterPlayerScripts or as a LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Admin variables
local defaultWalkSpeed = 16
local customWalkSpeed = 50
local isSpeedEnabled = false
local isAdminMode = true

-- Fly variables
local isFlying = false
local flySpeed = 100
local flyDirection = Vector3.new(0, 0, 0)
local bv = nil
local bg = nil

-- Jump variables
local isInfinityJumpEnabled = false
local isHighJumpEnabled = false
local defaultJumpPower = humanoid.JumpPower
local highJumpPower = 100

-- Store original values
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower

-- Create Unified GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedAdminPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Panel Container
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Parent = screenGui
mainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainPanel.BorderSizePixel = 0
mainPanel.Position = UDim2.new(1, -320, 0, 10)
mainPanel.Size = UDim2.new(0, 310, 0, 420)
mainPanel.Active = true
mainPanel.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainPanel

-- Header Section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Parent = mainPanel
headerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
headerFrame.BorderSizePixel = 0
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.Size = UDim2.new(1, 0, 0, 70)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Admin Shield Icon
local shieldIcon = Instance.new("ImageLabel")
shieldIcon.Name = "ShieldIcon"
shieldIcon.Parent = headerFrame
shieldIcon.BackgroundTransparency = 1
shieldIcon.Position = UDim2.new(0, 15, 0, 15)
shieldIcon.Size = UDim2.new(0, 40, 0, 40)
shieldIcon.Image = "rbxassetid://8964116993"
shieldIcon.ImageColor3 = Color3.fromRGB(255, 215, 0)

-- Admin Title
local adminLabel = Instance.new("TextLabel")
adminLabel.Name = "AdminLabel"
adminLabel.Parent = headerFrame
adminLabel.BackgroundTransparency = 1
adminLabel.Position = UDim2.new(0, 65, 0, 12)
adminLabel.Size = UDim2.new(0, 235, 0, 25)
adminLabel.Font = Enum.Font.GothamBold
adminLabel.Text = "🛡️ UNIFIED ADMIN PANEL"
adminLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
adminLabel.TextSize = 16
adminLabel.TextStrokeTransparency = 0
adminLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Status Indicator
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = headerFrame
statusLabel.Position = UDim2.new(0, 65, 0, 38)
statusLabel.Size = UDim2.new(0, 235, 0, 18)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "● All Systems Ready"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 12

-- Speed Control Section
local speedSection = Instance.new("Frame")
speedSection.Name = "SpeedSection"
speedSection.Parent = mainPanel
speedSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedSection.BorderSizePixel = 0
speedSection.Position = UDim2.new(0, 10, 0, 80)
speedSection.Size = UDim2.new(0, 290, 0, 90)

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedSection

-- Speed Header
local speedHeader = Instance.new("TextLabel")
speedHeader.Name = "SpeedHeader"
speedHeader.Parent = speedSection
speedHeader.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
speedHeader.BorderSizePixel = 0
speedHeader.Position = UDim2.new(0, 0, 0, 0)
speedHeader.Size = UDim2.new(1, 0, 0, 25)
speedHeader.Font = Enum.Font.GothamBold
speedHeader.Text = "🚀 SPEED CONTROL"
speedHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
speedHeader.TextSize = 12

local speedHeaderCorner = Instance.new("UICorner")
speedHeaderCorner.CornerRadius = UDim.new(0, 8)
speedHeaderCorner.Parent = speedHeader

-- Speed Toggle Button
local toggleSpeedButton = Instance.new("TextButton")
toggleSpeedButton.Name = "ToggleSpeedButton"
toggleSpeedButton.Parent = speedSection
toggleSpeedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
toggleSpeedButton.BorderSizePixel = 0
toggleSpeedButton.Position = UDim2.new(0, 10, 0, 30)
toggleSpeedButton.Size = UDim2.new(0, 130, 0, 28)
toggleSpeedButton.Font = Enum.Font.GothamBold
toggleSpeedButton.Text = "🚀 ACTIVATE"
toggleSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSpeedButton.TextSize = 11

local toggleSpeedCorner = Instance.new("UICorner")
toggleSpeedCorner.CornerRadius = UDim.new(0, 5)
toggleSpeedCorner.Parent = toggleSpeedButton

-- Speed Input
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Parent = speedSection
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedInput.BorderSizePixel = 0
speedInput.Position = UDim2.new(0, 150, 0, 30)
speedInput.Size = UDim2.new(0, 60, 0, 28)
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "Speed"
speedInput.Text = tostring(customWalkSpeed)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 11

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 5)
speedInputCorner.Parent = speedInput

-- Speed Display
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Name = "SpeedDisplay"
speedDisplay.Parent = speedSection
speedDisplay.BackgroundTransparency = 1
speedDisplay.Position = UDim2.new(0, 10, 0, 63)
speedDisplay.Size = UDim2.new(1, -20, 0, 20)
speedDisplay.Font = Enum.Font.Gotham
speedDisplay.Text = "Current: " .. originalWalkSpeed .. " | Target: " .. customWalkSpeed
speedDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
speedDisplay.TextSize = 10

-- Fly Control Section
local flySection = Instance.new("Frame")
flySection.Name = "FlySection"
flySection.Parent = mainPanel
flySection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
flySection.BorderSizePixel = 0
flySection.Position = UDim2.new(0, 10, 0, 180)
flySection.Size = UDim2.new(0, 290, 0, 90)

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flySection

-- Fly Header
local flyHeader = Instance.new("TextLabel")
flyHeader.Name = "FlyHeader"
flyHeader.Parent = flySection
flyHeader.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
flyHeader.BorderSizePixel = 0
flyHeader.Position = UDim2.new(0, 0, 0, 0)
flyHeader.Size = UDim2.new(1, 0, 0, 25)
flyHeader.Font = Enum.Font.GothamBold
flyHeader.Text = "✈️ FLY MODE"
flyHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
flyHeader.TextSize = 12

local flyHeaderCorner = Instance.new("UICorner")
flyHeaderCorner.CornerRadius = UDim.new(0, 8)
flyHeaderCorner.Parent = flyHeader

-- Fly Toggle Button
local toggleFlyButton = Instance.new("TextButton")
toggleFlyButton.Name = "ToggleFlyButton"
toggleFlyButton.Parent = flySection
toggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
toggleFlyButton.BorderSizePixel = 0
toggleFlyButton.Position = UDim2.new(0, 10, 0, 30)
toggleFlyButton.Size = UDim2.new(0, 130, 0, 28)
toggleFlyButton.Font = Enum.Font.GothamBold
toggleFlyButton.Text = "✈️ ENABLE FLY"
toggleFlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFlyButton.TextSize = 11

local toggleFlyCorner = Instance.new("UICorner")
toggleFlyCorner.CornerRadius = UDim.new(0, 5)
toggleFlyCorner.Parent = toggleFlyButton

-- Fly Speed Input
local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Name = "FlySpeedInput"
flySpeedInput.Parent = flySection
flySpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
flySpeedInput.BorderSizePixel = 0
flySpeedInput.Position = UDim2.new(0, 150, 0, 30)
flySpeedInput.Size = UDim2.new(0, 60, 0, 28)
flySpeedInput.Font = Enum.Font.Gotham
flySpeedInput.PlaceholderText = "FlySpd"
flySpeedInput.Text = tostring(flySpeed)
flySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedInput.TextSize = 11

local flySpeedInputCorner = Instance.new("UICorner")
flySpeedInputCorner.CornerRadius = UDim.new(0, 5)
flySpeedInputCorner.Parent = flySpeedInput

-- Fly Controls Info
local flyControlsInfo = Instance.new("TextLabel")
flyControlsInfo.Name = "FlyControlsInfo"
flyControlsInfo.Parent = flySection
flyControlsInfo.BackgroundTransparency = 1
flyControlsInfo.Position = UDim2.new(0, 10, 0, 63)
flyControlsInfo.Size = UDim2.new(1, -20, 0, 20)
flyControlsInfo.Font = Enum.Font.Gotham
flyControlsInfo.Text = "Controls: W/A/S/D/Space/Shift"
flyControlsInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
flyControlsInfo.TextSize = 10

-- Jump Control Section
local jumpSection = Instance.new("Frame")
jumpSection.Name = "JumpSection"
jumpSection.Parent = mainPanel
jumpSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
jumpSection.BorderSizePixel = 0
jumpSection.Position = UDim2.new(0, 10, 0, 280)
jumpSection.Size = UDim2.new(0, 290, 0, 90)

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 8)
jumpCorner.Parent = jumpSection

-- Jump Header
local jumpHeader = Instance.new("TextLabel")
jumpHeader.Name = "JumpHeader"
jumpHeader.Parent = jumpSection
jumpHeader.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
jumpHeader.BorderSizePixel = 0
jumpHeader.Position = UDim2.new(0, 0, 0, 0)
jumpHeader.Size = UDim2.new(1, 0, 0, 25)
jumpHeader.Font = Enum.Font.GothamBold
jumpHeader.Text = "🦘 JUMP MODES"
jumpHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpHeader.TextSize = 12

local jumpHeaderCorner = Instance.new("UICorner")
jumpHeaderCorner.CornerRadius = UDim.new(0, 8)
jumpHeaderCorner.Parent = jumpHeader

-- Infinity Jump Button
local toggleInfinityJumpButton = Instance.new("TextButton")
toggleInfinityJumpButton.Name = "ToggleInfinityJumpButton"
toggleInfinityJumpButton.Parent = jumpSection
toggleInfinityJumpButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
toggleInfinityJumpButton.BorderSizePixel = 0
toggleInfinityJumpButton.Position = UDim2.new(0, 10, 0, 30)
toggleInfinityJumpButton.Size = UDim2.new(0, 130, 0, 28)
toggleInfinityJumpButton.Font = Enum.Font.GothamBold
toggleInfinityJumpButton.Text = "♾️ INFINITY JUMP"
toggleInfinityJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleInfinityJumpButton.TextSize = 10

local infinityJumpCorner = Instance.new("UICorner")
infinityJumpCorner.CornerRadius = UDim.new(0, 5)
infinityJumpCorner.Parent = toggleInfinityJumpButton

-- High Jump Button
local toggleHighJumpButton = Instance.new("TextButton")
toggleHighJumpButton.Name = "ToggleHighJumpButton"
toggleHighJumpButton.Parent = jumpSection
toggleHighJumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
toggleHighJumpButton.BorderSizePixel = 0
toggleHighJumpButton.Position = UDim2.new(0, 150, 0, 30)
toggleHighJumpButton.Size = UDim2.new(0, 130, 0, 28)
toggleHighJumpButton.Font = Enum.Font.GothamBold
toggleHighJumpButton.Text = "🔝 HIGH JUMP"
toggleHighJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleHighJumpButton.TextSize = 10

local highJumpCorner = Instance.new("UICorner")
highJumpCorner.CornerRadius = UDim.new(0, 5)
highJumpCorner.Parent = toggleHighJumpButton

-- Jump Status
local jumpStatus = Instance.new("TextLabel")
jumpStatus.Name = "JumpStatus"
jumpStatus.Parent = jumpSection
jumpStatus.BackgroundTransparency = 1
jumpStatus.Position = UDim2.new(0, 10, 0, 63)
jumpStatus.Size = UDim2.new(1, -20, 0, 20)
jumpStatus.Font = Enum.Font.Gotham
jumpStatus.Text = "Jump Power: " .. defaultJumpPower
jumpStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpStatus.TextSize = 10

-- Quick Controls Section
local quickControls = Instance.new("Frame")
quickControls.Name = "QuickControls"
quickControls.Parent = mainPanel
quickControls.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
quickControls.BorderSizePixel = 0
quickControls.Position = UDim2.new(0, 10, 0, 380)
quickControls.Size = UDim2.new(0, 290, 0, 30)

local quickCorner = Instance.new("UICorner")
quickCorner.CornerRadius = UDim.new(0, 8)
quickCorner.Parent = quickControls

-- Speed Presets
local presetSpeeds = {25, 50, 100, 150}
for i, speed in ipairs(presetSpeeds) do
    local presetButton = Instance.new("TextButton")
    presetButton.Name = "Preset" .. speed
    presetButton.Parent = quickControls
    presetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    presetButton.BorderSizePixel = 0
    presetButton.Position = UDim2.new(0, 10 + (i-1) * 70, 0, 5)
    presetButton.Size = UDim2.new(0, 65, 0, 20)
    presetButton.Font = Enum.Font.GothamBold
    presetButton.Text = "Speed x" .. speed
    presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    presetButton.TextSize = 9

    local presetCorner = Instance.new("UICorner")
    presetCorner.CornerRadius = UDim.new(0, 4)
    presetCorner.Parent = presetButton

    presetButton.MouseButton1Click:Connect(function()
        updateCustomSpeed(speed)
        if not isSpeedEnabled then
            enableCustomSpeed()
        end
    end)

    presetButton.MouseEnter:Connect(function()
        TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
    end)

    presetButton.MouseLeave:Connect(function()
        TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
    end)
end

-- Functions
local function enableCustomSpeed()
    if isSpeedEnabled then return end

    isSpeedEnabled = true
    humanoid.WalkSpeed = customWalkSpeed
    toggleSpeedButton.Text = "🛑 DEACTIVATE"
    toggleSpeedButton.BackgroundColor3 = Color3.fromRGB(250, 50, 50)
    speedDisplay.Text = "Current: " .. customWalkSpeed .. " | Target: " .. customWalkSpeed

    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 135, 0, 28)}):Play()
    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 28)}):Play()

    updateStatus("Speed Activated", Color3.fromRGB(50, 255, 50))
end

local function disableCustomSpeed()
    if not isSpeedEnabled then return end

    isSpeedEnabled = false
    humanoid.WalkSpeed = originalWalkSpeed
    toggleSpeedButton.Text = "🚀 ACTIVATE"
    toggleSpeedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    speedDisplay.Text = "Current: " .. originalWalkSpeed .. " | Target: " .. customWalkSpeed

    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 135, 0, 28)}):Play()
    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 28)}):Play()

    updateStatus("Speed Deactivated", Color3.fromRGB(255, 150, 50))
end

local function updateCustomSpeed(newSpeed)
    local speed = tonumber(newSpeed)
    if speed and speed >= 1 and speed <= 200 then
        customWalkSpeed = speed
        speedInput.Text = tostring(speed)

        if isSpeedEnabled then
            humanoid.WalkSpeed = customWalkSpeed
            speedDisplay.Text = "Current: " .. customWalkSpeed .. " | Target: " .. customWalkSpeed
        else
            speedDisplay.Text = "Current: " .. originalWalkSpeed .. " | Target: " .. customWalkSpeed
        end
    else
        speedInput.Text = tostring(customWalkSpeed)
    end
end

-- Fly Functions
local function enableFly()
    if isFlying then return end

    isFlying = true
    toggleFlyButton.Text = "🛑 DISABLE FLY"
    toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

    -- Create fly components
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 5000
    bv.Parent = humanoid.RootPart

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 5000
    bg.Parent = humanoid.RootPart

    humanoid.PlatformStand = true

    updateStatus("Fly Mode Activated", Color3.fromRGB(100, 150, 255))
end

local function disableFly()
    if not isFlying then return end

    isFlying = false
    toggleFlyButton.Text = "✈️ ENABLE FLY"
    toggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)

    if bv then
        bv:Destroy()
        bv = nil
    end

    if bg then
        bg:Destroy()
        bg = nil
    end

    humanoid.PlatformStand = false

    updateStatus("Fly Mode Deactivated", Color3.fromRGB(255, 150, 50))
end

local function updateFlySpeed(newSpeed)
    local speed = tonumber(newSpeed)
    if speed and speed >= 10 and speed <= 500 then
        flySpeed = speed
        flySpeedInput.Text = tostring(speed)
    else
        flySpeedInput.Text = tostring(flySpeed)
    end
end

-- Jump Functions
local function enableInfinityJump()
    if isInfinityJumpEnabled then return end

    isInfinityJumpEnabled = true
    toggleInfinityJumpButton.Text = "♾️ INFINITY [ON]"
    toggleInfinityJumpButton.BackgroundColor3 = Color3.fromRGB(200, 150, 255)

    updateStatus("Infinity Jump Enabled", Color3.fromRGB(150, 100, 255))
end

local function disableInfinityJump()
    if not isInfinityJumpEnabled then return end

    isInfinityJumpEnabled = false
    toggleInfinityJumpButton.Text = "♾️ INFINITY JUMP"
    toggleInfinityJumpButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)

    updateStatus("Infinity Jump Disabled", Color3.fromRGB(255, 150, 50))
end

local function enableHighJump()
    if isHighJumpEnabled then return end

    isHighJumpEnabled = true
    humanoid.JumpPower = highJumpPower
    toggleHighJumpButton.Text = "🔝 HIGH [ON]"
    toggleHighJumpButton.BackgroundColor3 = Color3.fromRGB(255, 150, 200)
    jumpStatus.Text = "Jump Power: " .. highJumpPower

    updateStatus("High Jump Enabled", Color3.fromRGB(255, 100, 150))
end

local function disableHighJump()
    if not isHighJumpEnabled then return end

    isHighJumpEnabled = false
    humanoid.JumpPower = originalJumpPower
    toggleHighJumpButton.Text = "🔝 HIGH JUMP"
    toggleHighJumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
    jumpStatus.Text = "Jump Power: " .. originalJumpPower

    updateStatus("High Jump Disabled", Color3.fromRGB(255, 150, 50))
end

local function updateStatus(message, color)
    statusLabel.Text = "● " .. message
    statusLabel.TextColor3 = color

    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[ADMIN] " .. message;
        Color = color;
        Font = Enum.Font.GothamBold;
    })
end

-- Button Events
toggleSpeedButton.MouseButton1Click:Connect(function()
    if isSpeedEnabled then
        disableCustomSpeed()
    else
        enableCustomSpeed()
    end
end)

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateCustomSpeed(speedInput.Text)
    end
end)

toggleFlyButton.MouseButton1Click:Connect(function()
    if isFlying then
        disableFly()
    else
        enableFly()
    end
end)

flySpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateFlySpeed(flySpeedInput.Text)
    end
end)

toggleInfinityJumpButton.MouseButton1Click:Connect(function()
    if isInfinityJumpEnabled then
        disableInfinityJump()
    else
        enableInfinityJump()
    end
end)

toggleHighJumpButton.MouseButton1Click:Connect(function()
    if isHighJumpEnabled then
        disableHighJump()
    else
        enableHighJump()
    end
end)

-- Hover Effects
toggleSpeedButton.MouseEnter:Connect(function()
    local hoverColor = isSpeedEnabled and Color3.fromRGB(255, 75, 75) or Color3.fromRGB(70, 170, 255)
    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

toggleSpeedButton.MouseLeave:Connect(function()
    local normalColor = isSpeedEnabled and Color3.fromRGB(250, 50, 50) or Color3.fromRGB(50, 150, 250)
    TweenService:Create(toggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
end)

toggleFlyButton.MouseEnter:Connect(function()
    local hoverColor = isFlying and Color3.fromRGB(255, 75, 75) or Color3.fromRGB(120, 170, 255)
    TweenService:Create(toggleFlyButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

toggleFlyButton.MouseLeave:Connect(function()
    local normalColor = isFlying and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 150, 255)
    TweenService:Create(toggleFlyButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
end)

toggleInfinityJumpButton.MouseEnter:Connect(function()
    local hoverColor = isInfinityJumpEnabled and Color3.fromRGB(220, 170, 255) or Color3.fromRGB(170, 120, 255)
    TweenService:Create(toggleInfinityJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

toggleInfinityJumpButton.MouseLeave:Connect(function()
    local normalColor = isInfinityJumpEnabled and Color3.fromRGB(200, 150, 255) or Color3.fromRGB(150, 100, 255)
    TweenService:Create(toggleInfinityJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
end)

toggleHighJumpButton.MouseEnter:Connect(function()
    local hoverColor = isHighJumpEnabled and Color3.fromRGB(255, 170, 220) or Color3.fromRGB(255, 120, 170)
    TweenService:Create(toggleHighJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

toggleHighJumpButton.MouseLeave:Connect(function()
    local normalColor = isHighJumpEnabled and Color3.fromRGB(255, 150, 200) or Color3.fromRGB(255, 100, 150)
    TweenService:Create(toggleHighJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
end)

-- Fly Control
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not isFlying then return end

    if input.KeyCode == Enum.KeyCode.W then
        flyDirection = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        flyDirection = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        flyDirection = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        flyDirection = Vector3.new(1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.Space then
        flyDirection = Vector3.new(0, 1, 0)
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        flyDirection = Vector3.new(0, -1, 0)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed or not isFlying then return end

    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or
       input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
        flyDirection = Vector3.new(0, 0, 0)
    end
end)

-- Fly Movement Loop
RunService.Heartbeat:Connect(function()
    if isFlying and bv and humanoid.RootPart then
        local camera = Workspace.CurrentCamera
        local moveDirection = flyDirection

        if moveDirection ~= Vector3.new(0, 0, 0) then
            local cameraDirection = camera.CFrame.LookVector
            local adjustedDirection = (cameraDirection * moveDirection.Z + camera.CFrame.RightVector * moveDirection.X + Vector3.new(0, moveDirection.Y, 0)).Unit
            bv.Velocity = adjustedDirection * flySpeed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end

        bg.CFrame = camera.CFrame
    end
end)

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if isInfinityJumpEnabled then
        humanoid.Jump = true
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Keyboard Shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Speed toggles
    if input.KeyCode == Enum.KeyCode.X then
        if isSpeedEnabled then
            disableCustomSpeed()
        else
            enableCustomSpeed()
        end
    end

    -- Fly toggle
    if input.KeyCode == Enum.KeyCode.F then
        if isFlying then
            disableFly()
        else
            enableFly()
        end
    end

    -- Jump toggles
    if input.KeyCode == Enum.KeyCode.J then
        if isInfinityJumpEnabled then
            disableInfinityJump()
        else
            enableInfinityJump()
        end
    end

    if input.KeyCode == Enum.KeyCode.H then
        if isHighJumpEnabled then
            disableHighJump()
        else
            enableHighJump()
        end
    end

    -- Reset all
    if input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        disableCustomSpeed()
        disableFly()
        disableInfinityJump()
        disableHighJump()
        customWalkSpeed = 50
        flySpeed = 100
        speedInput.Text = tostring(customWalkSpeed)
        flySpeedInput.Text = tostring(flySpeed)
        speedDisplay.Text = "Current: " .. originalWalkSpeed .. " | Target: " .. customWalkSpeed
        updateStatus("All Features Reset", Color3.fromRGB(255, 255, 0))
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
    speedDisplay.Text = "Current: " .. originalWalkSpeed .. " | Target: " .. customWalkSpeed
    jumpStatus.Text = "Jump Power: " .. originalJumpPower

    -- Reset all features on respawn
    disableCustomSpeed()
    disableFly()
    disableInfinityJump()
    disableHighJump()
end)

-- Auto-disable on death
humanoid.Died:Connect(function()
    if isSpeedEnabled then disableCustomSpeed() end
    if isFlying then disableFly() end
    if isInfinityJumpEnabled then disableInfinityJump() end
    if isHighJumpEnabled then disableHighJump() end
end)

print("🛡️ Unified Admin Panel loaded successfully!")
print("Features: Speed, Fly, Infinity Jump, High Jump - All in One Panel!")
print("Shortcuts: X=Speed, F=Fly, J=Infinity Jump, H=High Jump")
print("Ctrl+R = Reset All Features")
print("Fly Controls: W/A/S/D/Space/Shift")
