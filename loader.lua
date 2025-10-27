local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- WalkSpeed variables
local defaultWalkSpeed = 16
local customWalkSpeed = 50
local isSpeedEnabled = false

-- Store original walkspeed
local originalWalkSpeed = humanoid.WalkSpeed

-- Create GUI for walkspeed controls
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalkSpeedControls"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(1, -160, 0, 10)
mainFrame.Size = UDim2.new(0, 150, 0, 120)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Speed Control"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = mainFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
toggleButton.BorderSizePixel = 0
toggleButton.Position = UDim2.new(0, 10, 0, 35)
toggleButton.Size = UDim2.new(0, 130, 0, 30)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "Enable Speed"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 12

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton

-- Current speed display
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 10, 0, 70)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Current: " .. originalWalkSpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 11

-- Speed input
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Parent = mainFrame
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
speedInput.BorderSizePixel = 0
speedInput.Position = UDim2.new(0, 10, 0, 95)
speedInput.Size = UDim2.new(0, 130, 0, 20)
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "Enter speed (1-100)"
speedInput.Text = tostring(customWalkSpeed)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 11

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 3)
inputCorner.Parent = speedInput

-- Functions
local function enableCustomSpeed()
    if isSpeedEnabled then return end

    isSpeedEnabled = true
    humanoid.WalkSpeed = customWalkSpeed
    toggleButton.Text = "Disable Speed"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    speedLabel.Text = "Current: " .. customWalkSpeed

    print("Custom speed enabled: " .. customWalkSpeed)
end

local function disableCustomSpeed()
    if not isSpeedEnabled then return end

    isSpeedEnabled = false
    humanoid.WalkSpeed = originalWalkSpeed
    toggleButton.Text = "Enable Speed"
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    speedLabel.Text = "Current: " .. originalWalkSpeed

    print("Speed disabled - reverted to: " .. originalWalkSpeed)
end

local function updateCustomSpeed(newSpeed)
    local speed = tonumber(newSpeed)
    if speed and speed >= 1 and speed <= 100 then
        customWalkSpeed = speed
        speedInput.Text = tostring(speed)

        if isSpeedEnabled then
            humanoid.WalkSpeed = customWalkSpeed
            speedLabel.Text = "Current: " .. customWalkSpeed
        end

        print("Speed updated to: " .. customWalkSpeed)
    else
        speedInput.Text = tostring(customWalkSpeed)
        warn("Invalid speed! Please enter a number between 1 and 100")
    end
end

-- Button events
toggleButton.MouseButton1Click:Connect(function()
    if isSpeedEnabled then
        disableCustomSpeed()
    else
        enableCustomSpeed()
    end
end)

-- Speed input events
speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateCustomSpeed(speedInput.Text)
    end
end)

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Toggle with X key
    if input.KeyCode == Enum.KeyCode.X then
        if isSpeedEnabled then
            disableCustomSpeed()
        else
            enableCustomSpeed()
        end
    end

    -- Reset with R key
    if input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        disableCustomSpeed()
        customWalkSpeed = 50
        speedInput.Text = tostring(customWalkSpeed)
        print("Speed reset to default: 50")
    end
end)

-- Update original walkspeed when character respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed

    -- Disable speed on respawn for safety
    if isSpeedEnabled then
        disableCustomSpeed()
    end
end)

-- Auto-disable on death
humanoid.Died:Connect(function()
    if isSpeedEnabled then
        disableCustomSpeed()
    end
end)

-- Smooth transition animations
local function animateSpeedChange(targetSpeed)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local speedTween = TweenService:Create(humanoid, tweenInfo, {WalkSpeed = targetSpeed})
    speedTween:Play()
end

-- Button hover effects
toggleButton.MouseEnter:Connect(function()
    local hoverColor = isSpeedEnabled and Color3.fromRGB(220, 120, 120) or Color3.fromRGB(120, 120, 220)
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

toggleButton.MouseLeave:Connect(function()
    local normalColor = isSpeedEnabled and Color3.fromRGB(200, 100, 100) or Color3.fromRGB(100, 100, 200)
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
end)

-- Preset speeds for quick access
local presets = {10, 25, 50, 75, 100}

local function createPresetButtons()
    local presetFrame = Instance.new("Frame")
    presetFrame.Name = "PresetFrame"
    presetFrame.Parent = screenGui
    presetFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    presetFrame.BorderSizePixel = 0
    presetFrame.Position = UDim2.new(1, -160, 0, 140)
    presetFrame.Size = UDim2.new(0, 150, 0, 60)
    presetFrame.Visible = false

    local presetCorner = Instance.new("UICorner")
    presetCorner.CornerRadius = UDim.new(0, 8)
    presetCorner.Parent = presetFrame

    for i, speed in ipairs(presets) do
        local presetButton = Instance.new("TextButton")
        presetButton.Name = "Preset" .. speed
        presetButton.Parent = presetFrame
        presetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        presetButton.BorderSizePixel = 0
        presetButton.Position = UDim2.new(0, 5 + ((i-1) % 3) * 48, 0, 5 + math.floor((i-1) / 3) * 25)
        presetButton.Size = UDim2.new(0, 45, 0, 20)
        presetButton.Font = Enum.Font.Gotham
        presetButton.Text = tostring(speed)
        presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        presetButton.TextSize = 10

        local presetCorner = Instance.new("UICorner")
        presetCorner.CornerRadius = UDim.new(0, 3)
        presetCorner.Parent = presetButton

        presetButton.MouseButton1Click:Connect(function()
            updateCustomSpeed(speed)
            if not isSpeedEnabled then
                enableCustomSpeed()
            end
        end)

        presetButton.MouseEnter:Connect(function()
            TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 110)}):Play()
        end)

        presetButton.MouseLeave:Connect(function()
            TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
        end)
    end

    return presetFrame
end

local presetFrame = createPresetButtons()

-- Add preset toggle button
local presetToggleButton = Instance.new("TextButton")
presetToggleButton.Name = "PresetToggleButton"
presetToggleButton.Parent = mainFrame
presetToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
presetToggleButton.BorderSizePixel = 0
presetToggleButton.Position = UDim2.new(0, 10, 0, 0)
presetToggleButton.Size = UDim2.new(0, 20, 0, 20)
presetToggleButton.Font = Enum.Font.Gotham
presetToggleButton.Text = "▼"
presetToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
presetToggleButton.TextSize = 12

local presetToggleCorner = Instance.new("UICorner")
presetToggleCorner.CornerRadius = UDim.new(0, 3)
presetToggleCorner.Parent = presetToggleButton

local presetsVisible = false
presetToggleButton.MouseButton1Click:Connect(function()
    presetsVisible = not presetsVisible
    presetFrame.Visible = presetsVisible
    presetToggleButton.Text = presetsVisible and "▲" or "▼"
end)

print("WalkSpeed script loaded successfully!")
print("Press X to toggle speed, or click the button")
print("Ctrl+R to reset to default (50)")
print("Enter custom speed (1-100) in the input field")
