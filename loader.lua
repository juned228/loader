-- Minimal Admin Script for Roblox
-- Complex UI with monochrome design
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

-- Panel state variables
local isPanelVisible = false
local panelSize = UDim2.new(0, 320, 0, 460)
local logoButtonSize = UDim2.new(0, 50, 0, 50)

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

-- Color scheme (monochrome)
local colors = {
	primary = Color3.fromRGB(20, 20, 20),
	secondary = Color3.fromRGB(35, 35, 35),
	tertiary = Color3.fromRGB(50, 50, 50),
	accent = Color3.fromRGB(70, 70, 70),
	text = Color3.fromRGB(255, 255, 255),
	text_dim = Color3.fromRGB(180, 180, 180),
	active = Color3.fromRGB(100, 100, 100),
	inactive = Color3.fromRGB(40, 40, 40)
}

-- Create Minimal GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinimalAdminPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Logo Button (Main Element - Always Visible)
local logoButton = Instance.new("TextButton")
logoButton.Name = "LogoButton"
logoButton.Parent = screenGui
logoButton.BackgroundColor3 = colors.primary
logoButton.BorderSizePixel = 1
logoButton.BorderColor3 = colors.accent
logoButton.Position = UDim2.new(1, -60, 0, 20)
logoButton.Size = logoButtonSize
logoButton.Text = ""
logoButton.Active = true
logoButton.Draggable = true

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 25)
logoCorner.Parent = logoButton

-- Logo Container (for custom logo/text)
local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Parent = logoButton
logoContainer.BackgroundTransparency = 1
logoContainer.Position = UDim2.new(0, 0, 0, 0)
logoContainer.Size = UDim2.new(1, 0, 1, 0)

-- Option 1: Custom Text Logo
local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Parent = logoContainer
logoText.BackgroundTransparency = 1
logoText.Position = UDim2.new(0, 0, 0, 0)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Font = Enum.Font.GothamBold
logoText.Text = "JS" -- Juned System initials
logoText.TextColor3 = colors.text
logoText.TextSize = 18
logoText.TextScaled = true

-- Option 2: Logo Icon (commented by default, you can enable this)
--[[
local logoIcon = Instance.new("ImageLabel")
logoIcon.Name = "LogoIcon"
logoIcon.Parent = logoContainer
logoIcon.BackgroundTransparency = 1
logoIcon.Position = UDim2.new(0, 10, 0, 10)
logoIcon.Size = UDim2.new(0, 30, 0, 30)
logoIcon.Image = "rbxassetid://7733658448" -- Settings/gear icon
logoIcon.ImageColor3 = colors.text
--]]

-- Option 3: Combination Text + Icon (commented by default)
--[[
local logoIcon = Instance.new("ImageLabel")
logoIcon.Name = "LogoIcon"
logoIcon.Parent = logoContainer
logoIcon.BackgroundTransparency = 1
logoIcon.Position = UDim2.new(0, 5, 0, 5)
logoIcon.Size = UDim2.new(0, 20, 0, 20)
logoIcon.Image = "rbxassetid://7733658448"
logoIcon.ImageColor3 = colors.text

local logoSmallText = Instance.new("TextLabel")
logoSmallText.Name = "LogoSmallText"
logoSmallText.Parent = logoContainer
logoSmallText.BackgroundTransparency = 1
logoSmallText.Position = UDim2.new(0, 25, 0, 15)
logoSmallText.Size = UDim2.new(0, 20, 0, 20)
logoSmallText.Font = Enum.Font.GothamBold
logoSmallText.Text = "JS"
logoSmallText.TextColor3 = colors.text
logoSmallText.TextSize = 12
--]]

-- Status Indicator on Logo
local logoStatusIndicator = Instance.new("Frame")
logoStatusIndicator.Name = "LogoStatusIndicator"
logoStatusIndicator.Parent = logoButton
logoStatusIndicator.BackgroundColor3 = colors.text_dim
logoStatusIndicator.BorderSizePixel = 0
logoStatusIndicator.Position = UDim2.new(1, -8, 0, 8)
logoStatusIndicator.Size = UDim2.new(0, 6, 0, 6)

local logoStatusCorner = Instance.new("UICorner")
logoStatusCorner.CornerRadius = UDim.new(0.5, 0)
logoStatusCorner.Parent = logoStatusIndicator

-- Main Panel Container (Initially Hidden)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Parent = screenGui
mainPanel.BackgroundColor3 = colors.primary
mainPanel.BorderSizePixel = 1
mainPanel.BorderColor3 = colors.accent
mainPanel.Position = UDim2.new(1, -340, 0, 20)
mainPanel.Size = panelSize
mainPanel.Visible = false
mainPanel.Active = true
mainPanel.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4)
mainCorner.Parent = mainPanel

-- Scrolling Frame Container
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = mainPanel
scrollFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.Position = UDim2.new(0, 0, 0, 50) -- Start below header
scrollFrame.Size = UDim2.new(1, 0, 1, -50) -- Full size minus header
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = colors.accent
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BottomImage = "rbxasset://textures/Scroll/scroll-middle.png"
scrollFrame.MidImage = "rbxasset://textures/Scroll/scroll-middle.png"
scrollFrame.TopImage = "rbxasset://textures/Scroll/scroll-middle.png"
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Header Section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Parent = mainPanel
headerFrame.BackgroundColor3 = colors.secondary
headerFrame.BorderSizePixel = 0
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.Size = UDim2.new(1, 0, 0, 50)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 4)
headerCorner.Parent = headerFrame

-- Title Line
local titleLine = Instance.new("Frame")
titleLine.Name = "TitleLine"
titleLine.Parent = headerFrame
titleLine.BackgroundColor3 = colors.accent
titleLine.BorderSizePixel = 0
titleLine.Position = UDim2.new(0, 15, 0, 20)
titleLine.Size = UDim2.new(0, 4, 0, 15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = headerFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 25, 0, 10)
titleLabel.Size = UDim2.new(0, 280, 0, 30)
titleLabel.Font = Enum.Font.Code
titleLabel.Text = "JUNED SYSTEM"
titleLabel.TextColor3 = colors.text
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Draggable hint text
local dragHint = Instance.new("TextLabel")
dragHint.Name = "DragHint"
dragHint.Parent = headerFrame
dragHint.BackgroundTransparency = 1
dragHint.Position = UDim2.new(0, 0, 0, 30)
dragHint.Size = UDim2.new(1, 0, 0, 20)
dragHint.Font = Enum.Font.Code
dragHint.TextColor3 = colors.text_dim
dragHint.TextSize = 8
dragHint.TextTransparency = 0.5
dragHint.TextXAlignment = Enum.TextXAlignment.Center


-- Status indicator
local statusIndicator = Instance.new("Frame")
statusIndicator.Name = "StatusIndicator"
statusIndicator.Parent = headerFrame
statusIndicator.BackgroundColor3 = colors.text_dim
statusIndicator.BorderSizePixel = 0
statusIndicator.Position = UDim2.new(1, -65, 0, 20)
statusIndicator.Size = UDim2.new(0, 8, 0, 8)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0.5, 0)
statusCorner.Parent = statusIndicator

-- Speed Control Section
local speedSection = Instance.new("Frame")
speedSection.Name = "SpeedSection"
speedSection.Parent = scrollFrame
speedSection.BackgroundColor3 = colors.secondary
speedSection.BorderSizePixel = 1
speedSection.BorderColor3 = colors.tertiary
speedSection.Position = UDim2.new(0, 15, 0, 10)
speedSection.Size = UDim2.new(0, 290, 0, 100)

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 3)
speedCorner.Parent = speedSection

-- Speed Section Header
local speedSectionLabel = Instance.new("TextLabel")
speedSectionLabel.Name = "SpeedSectionLabel"
speedSectionLabel.Parent = speedSection
speedSectionLabel.BackgroundTransparency = 1
speedSectionLabel.Position = UDim2.new(0, 10, 0, 5)
speedSectionLabel.Size = UDim2.new(0, 270, 0, 20)
speedSectionLabel.Font = Enum.Font.Code
speedSectionLabel.Text = "[01] LOCOMOTION_CONTROL"
speedSectionLabel.TextColor3 = colors.text_dim
speedSectionLabel.TextSize = 11
speedSectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Switch Container
local toggleContainer = Instance.new("Frame")
toggleContainer.Name = "ToggleContainer"
toggleContainer.Parent = speedSection
toggleContainer.BackgroundTransparency = 1
toggleContainer.Position = UDim2.new(0, 10, 0, 30)
toggleContainer.Size = UDim2.new(0, 270, 0, 25)

-- Toggle Label
local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "ToggleLabel"
toggleLabel.Parent = toggleContainer
toggleLabel.BackgroundTransparency = 1
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.Size = UDim2.new(0, 200, 0, 25)
toggleLabel.Font = Enum.Font.Code
toggleLabel.Text = "SPEED_MODULATION"
toggleLabel.TextColor3 = colors.text
toggleLabel.TextSize = 12
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Switch Background
local toggleSwitchBg = Instance.new("Frame")
toggleSwitchBg.Name = "ToggleSwitchBg"
toggleSwitchBg.Parent = toggleContainer
toggleSwitchBg.BackgroundColor3 = colors.inactive
toggleSwitchBg.BorderSizePixel = 0
toggleSwitchBg.Position = UDim2.new(1, -50, 0, 2.5)
toggleSwitchBg.Size = UDim2.new(0, 45, 0, 20)

local toggleBgCorner = Instance.new("UICorner")
toggleBgCorner.CornerRadius = UDim.new(0, 10)
toggleBgCorner.Parent = toggleSwitchBg

-- Toggle Switch Handle
local toggleSwitch = Instance.new("Frame")
toggleSwitch.Name = "ToggleSwitch"
toggleSwitch.Parent = toggleSwitchBg
toggleSwitch.BackgroundColor3 = colors.text_dim
toggleSwitch.BorderSizePixel = 0
toggleSwitch.Position = UDim2.new(0, 2, 0, 2)
toggleSwitch.Size = UDim2.new(0, 16, 0, 16)

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleSwitch

-- Toggle Button (invisible but clickable)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = toggleContainer
toggleButton.BackgroundTransparency = 1
toggleButton.Position = UDim2.new(1, -50, 0, 0)
toggleButton.Size = UDim2.new(0, 45, 0, 25)
toggleButton.Text = ""
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 1

-- Speed Input Section
local speedInputSection = Instance.new("Frame")
speedInputSection.Name = "SpeedInputSection"
speedInputSection.Parent = speedSection
speedInputSection.BackgroundTransparency = 1
speedInputSection.Position = UDim2.new(0, 10, 0, 60)
speedInputSection.Size = UDim2.new(0, 270, 0, 30)

-- Speed Label
local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Name = "SpeedValueLabel"
speedValueLabel.Parent = speedInputSection
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Position = UDim2.new(0, 0, 0, 5)
speedValueLabel.Size = UDim2.new(0, 80, 0, 20)
speedValueLabel.Font = Enum.Font.Code
speedValueLabel.Text = "VAL:" .. originalWalkSpeed
speedValueLabel.TextColor3 = colors.text_dim
speedValueLabel.TextSize = 10
speedValueLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Speed Input
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Parent = speedInputSection
speedInput.BackgroundColor3 = colors.tertiary
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = colors.accent
speedInput.Position = UDim2.new(0, 85, 0, 5)
speedInput.Size = UDim2.new(0, 60, 0, 20)
speedInput.Font = Enum.Font.Code
speedInput.PlaceholderText = "0-200"
speedInput.Text = tostring(customWalkSpeed)
speedInput.TextColor3 = colors.text
speedInput.TextSize = 10

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 2)
inputCorner.Parent = speedInput

-- Set Button
local setButton = Instance.new("TextButton")
setButton.Name = "SetButton"
setButton.Parent = speedInputSection
setButton.BackgroundColor3 = colors.tertiary
setButton.BorderSizePixel = 1
setButton.BorderColor3 = colors.accent
setButton.Position = UDim2.new(0, 150, 0, 5)
setButton.Size = UDim2.new(0, 40, 0, 20)
setButton.Font = Enum.Font.Code
setButton.Text = "SET"
setButton.TextColor3 = colors.text
setButton.TextSize = 10

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0, 2)
setCorner.Parent = setButton

-- Current Status
local currentStatusLabel = Instance.new("TextLabel")
currentStatusLabel.Name = "CurrentStatusLabel"
currentStatusLabel.Parent = speedInputSection
currentStatusLabel.BackgroundTransparency = 1
currentStatusLabel.Position = UDim2.new(0, 195, 0, 5)
currentStatusLabel.Size = UDim2.new(0, 75, 0, 20)
currentStatusLabel.Font = Enum.Font.Code
currentStatusLabel.Text = "CUR:OFF"
currentStatusLabel.TextColor3 = colors.text_dim
currentStatusLabel.TextSize = 10
currentStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Fly Control Section
local flySection = Instance.new("Frame")
flySection.Name = "FlySection"
flySection.Parent = scrollFrame
flySection.BackgroundColor3 = colors.secondary
flySection.BorderSizePixel = 1
flySection.BorderColor3 = colors.tertiary
flySection.Position = UDim2.new(0, 15, 0, 120)
flySection.Size = UDim2.new(0, 290, 0, 90)

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 3)
flyCorner.Parent = flySection

-- Fly Section Header
local flySectionLabel = Instance.new("TextLabel")
flySectionLabel.Name = "FlySectionLabel"
flySectionLabel.Parent = flySection
flySectionLabel.BackgroundTransparency = 1
flySectionLabel.Position = UDim2.new(0, 10, 0, 5)
flySectionLabel.Size = UDim2.new(0, 270, 0, 20)
flySectionLabel.Font = Enum.Font.Code
flySectionLabel.Text = "[02] FLY MODE"
flySectionLabel.TextColor3 = colors.text_dim
flySectionLabel.TextSize = 11
flySectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Fly Toggle Switch Container
local flyToggleContainer = Instance.new("Frame")
flyToggleContainer.Name = "FlyToggleContainer"
flyToggleContainer.Parent = flySection
flyToggleContainer.BackgroundTransparency = 1
flyToggleContainer.Position = UDim2.new(0, 10, 0, 30)
flyToggleContainer.Size = UDim2.new(0, 270, 0, 25)

-- Fly Toggle Label
local flyToggleLabel = Instance.new("TextLabel")
flyToggleLabel.Name = "FlyToggleLabel"
flyToggleLabel.Parent = flyToggleContainer
flyToggleLabel.BackgroundTransparency = 1
flyToggleLabel.Position = UDim2.new(0, 0, 0, 0)
flyToggleLabel.Size = UDim2.new(0, 200, 0, 25)
flyToggleLabel.Font = Enum.Font.Code
flyToggleLabel.Text = "FLY MODE"
flyToggleLabel.TextColor3 = colors.text
flyToggleLabel.TextSize = 12
flyToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Fly Toggle Switch Background
local flyToggleSwitchBg = Instance.new("Frame")
flyToggleSwitchBg.Name = "FlyToggleSwitchBg"
flyToggleSwitchBg.Parent = flyToggleContainer
flyToggleSwitchBg.BackgroundColor3 = colors.inactive
flyToggleSwitchBg.BorderSizePixel = 0
flyToggleSwitchBg.Position = UDim2.new(1, -50, 0, 2.5)
flyToggleSwitchBg.Size = UDim2.new(0, 45, 0, 20)

local flyToggleBgCorner = Instance.new("UICorner")
flyToggleBgCorner.CornerRadius = UDim.new(0, 10)
flyToggleBgCorner.Parent = flyToggleSwitchBg

-- Fly Toggle Switch Handle
local flyToggleSwitch = Instance.new("Frame")
flyToggleSwitch.Name = "FlyToggleSwitch"
flyToggleSwitch.Parent = flyToggleSwitchBg
flyToggleSwitch.BackgroundColor3 = colors.text_dim
flyToggleSwitch.BorderSizePixel = 0
flyToggleSwitch.Position = UDim2.new(0, 2, 0, 2)
flyToggleSwitch.Size = UDim2.new(0, 16, 0, 16)

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 8)
flyToggleCorner.Parent = flyToggleSwitch

-- Fly Toggle Button (invisible but clickable)
local flyToggleInvisibleButton = Instance.new("TextButton")
flyToggleInvisibleButton.Name = "FlyToggleInvisibleButton"
flyToggleInvisibleButton.Parent = flyToggleContainer
flyToggleInvisibleButton.BackgroundTransparency = 1
flyToggleInvisibleButton.Position = UDim2.new(1, -50, 0, 0)
flyToggleInvisibleButton.Size = UDim2.new(0, 45, 0, 25)
flyToggleInvisibleButton.Text = ""
flyToggleInvisibleButton.Font = Enum.Font.SourceSans
flyToggleInvisibleButton.TextSize = 1

-- Fly Speed Input
local flySpeedInput = Instance.new("TextBox")
flySpeedInput.Name = "FlySpeedInput"
flySpeedInput.Parent = flySection
flySpeedInput.BackgroundColor3 = colors.tertiary
flySpeedInput.BorderSizePixel = 1
flySpeedInput.BorderColor3 = colors.accent
flySpeedInput.Position = UDim2.new(0, 10, 0, 60)
flySpeedInput.Size = UDim2.new(0, 60, 0, 20)
flySpeedInput.Font = Enum.Font.Code
flySpeedInput.PlaceholderText="VELOCITY"
flySpeedInput.Text = tostring(flySpeed)
flySpeedInput.TextColor3 = colors.text
flySpeedInput.TextSize = 10

local flyInputCorner = Instance.new("UICorner")
flyInputCorner.CornerRadius = UDim.new(0, 2)
flyInputCorner.Parent = flySpeedInput

-- Fly Controls Info
local flyControlsInfo = Instance.new("TextLabel")
flyControlsInfo.Name = "FlyControlsInfo"
flyControlsInfo.Parent = flySection
flyControlsInfo.BackgroundTransparency = 1
flyControlsInfo.Position = UDim2.new(0, 10, 0, 60)
flyControlsInfo.Size = UDim2.new(0, 270, 0, 20)
flyControlsInfo.Font = Enum.Font.Code
flyControlsInfo.Text = "NAV: [W]FORWARD [S]BACKWARD [A]LEFT [D]RIGHT [SPACE]UP [SHIFT]DOWN"
flyControlsInfo.TextColor3 = colors.text_dim
flyControlsInfo.TextSize = 9

-- Jump Control Section
local jumpSection = Instance.new("Frame")
jumpSection.Name = "JumpSection"
jumpSection.Parent = scrollFrame
jumpSection.BackgroundColor3 = colors.secondary
jumpSection.BorderSizePixel = 1
jumpSection.BorderColor3 = colors.tertiary
jumpSection.Position = UDim2.new(0, 15, 0, 220)
jumpSection.Size = UDim2.new(0, 290, 0, 120)

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 3)
jumpCorner.Parent = jumpSection

-- Jump Section Header
local jumpSectionLabel = Instance.new("TextLabel")
jumpSectionLabel.Name = "JumpSectionLabel"
jumpSectionLabel.Parent = jumpSection
jumpSectionLabel.BackgroundTransparency = 1
jumpSectionLabel.Position = UDim2.new(0, 10, 0, 5)
jumpSectionLabel.Size = UDim2.new(0, 270, 0, 20)
jumpSectionLabel.Font = Enum.Font.Code
jumpSectionLabel.Text = "[03] VERTICAL_PROPULSION"
jumpSectionLabel.TextColor3 = colors.text_dim
jumpSectionLabel.TextSize = 11
jumpSectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Infinity Jump Toggle Container
local infinityToggleContainer = Instance.new("Frame")
infinityToggleContainer.Name = "InfinityToggleContainer"
infinityToggleContainer.Parent = jumpSection
infinityToggleContainer.BackgroundTransparency = 1
infinityToggleContainer.Position = UDim2.new(0, 10, 0, 30)
infinityToggleContainer.Size = UDim2.new(0, 270, 0, 25)

-- Infinity Toggle Label
local infinityToggleLabel = Instance.new("TextLabel")
infinityToggleLabel.Name = "InfinityToggleLabel"
infinityToggleLabel.Parent = infinityToggleContainer
infinityToggleLabel.BackgroundTransparency = 1
infinityToggleLabel.Position = UDim2.new(0, 0, 0, 0)
infinityToggleLabel.Size = UDim2.new(0, 200, 0, 25)
infinityToggleLabel.Font = Enum.Font.Code
infinityToggleLabel.Text = "INFINITE_JUMP"
infinityToggleLabel.TextColor3 = colors.text
infinityToggleLabel.TextSize = 11
infinityToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Infinity Toggle Switch Background
local infinityToggleSwitchBg = Instance.new("Frame")
infinityToggleSwitchBg.Name = "InfinityToggleSwitchBg"
infinityToggleSwitchBg.Parent = infinityToggleContainer
infinityToggleSwitchBg.BackgroundColor3 = colors.inactive
infinityToggleSwitchBg.BorderSizePixel = 0
infinityToggleSwitchBg.Position = UDim2.new(1, -50, 0, 2.5)
infinityToggleSwitchBg.Size = UDim2.new(0, 45, 0, 20)

local infinityToggleBgCorner = Instance.new("UICorner")
infinityToggleBgCorner.CornerRadius = UDim.new(0, 10)
infinityToggleBgCorner.Parent = infinityToggleSwitchBg

-- Infinity Toggle Switch Handle
local infinityToggleSwitch = Instance.new("Frame")
infinityToggleSwitch.Name = "InfinityToggleSwitch"
infinityToggleSwitch.Parent = infinityToggleSwitchBg
infinityToggleSwitch.BackgroundColor3 = colors.text_dim
infinityToggleSwitch.BorderSizePixel = 0
infinityToggleSwitch.Position = UDim2.new(0, 2, 0, 2)
infinityToggleSwitch.Size = UDim2.new(0, 16, 0, 16)

local infinityToggleCorner = Instance.new("UICorner")
infinityToggleCorner.CornerRadius = UDim.new(0, 8)
infinityToggleCorner.Parent = infinityToggleSwitch

-- Infinity Toggle Button (invisible but clickable)
local infinityToggleInvisibleButton = Instance.new("TextButton")
infinityToggleInvisibleButton.Name = "InfinityToggleInvisibleButton"
infinityToggleInvisibleButton.Parent = infinityToggleContainer
infinityToggleInvisibleButton.BackgroundTransparency = 1
infinityToggleInvisibleButton.Position = UDim2.new(1, -50, 0, 0)
infinityToggleInvisibleButton.Size = UDim2.new(0, 45, 0, 25)
infinityToggleInvisibleButton.Text = ""
infinityToggleInvisibleButton.Font = Enum.Font.SourceSans
infinityToggleInvisibleButton.TextSize = 1

-- High Jump Toggle Container
local highJumpToggleContainer = Instance.new("Frame")
highJumpToggleContainer.Name = "HighJumpToggleContainer"
highJumpToggleContainer.Parent = jumpSection
highJumpToggleContainer.BackgroundTransparency = 1
highJumpToggleContainer.Position = UDim2.new(0, 10, 0, 60)
highJumpToggleContainer.Size = UDim2.new(0, 270, 0, 25)

-- High Jump Toggle Label
local highJumpToggleLabel = Instance.new("TextLabel")
highJumpToggleLabel.Name = "HighJumpToggleLabel"
highJumpToggleLabel.Parent = highJumpToggleContainer
highJumpToggleLabel.BackgroundTransparency = 1
highJumpToggleLabel.Position = UDim2.new(0, 0, 0, 0)
highJumpToggleLabel.Size = UDim2.new(0, 200, 0, 25)
highJumpToggleLabel.Font = Enum.Font.Code
highJumpToggleLabel.Text = "AMPLIFIED_JUMP"
highJumpToggleLabel.TextColor3 = colors.text
highJumpToggleLabel.TextSize = 11
highJumpToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- High Jump Toggle Switch Background
local highJumpToggleSwitchBg = Instance.new("Frame")
highJumpToggleSwitchBg.Name = "HighJumpToggleSwitchBg"
highJumpToggleSwitchBg.Parent = highJumpToggleContainer
highJumpToggleSwitchBg.BackgroundColor3 = colors.inactive
highJumpToggleSwitchBg.BorderSizePixel = 0
highJumpToggleSwitchBg.Position = UDim2.new(1, -50, 0, 2.5)
highJumpToggleSwitchBg.Size = UDim2.new(0, 45, 0, 20)

local highJumpToggleBgCorner = Instance.new("UICorner")
highJumpToggleBgCorner.CornerRadius = UDim.new(0, 10)
highJumpToggleBgCorner.Parent = highJumpToggleSwitchBg

-- High Jump Toggle Switch Handle
local highJumpToggleSwitch = Instance.new("Frame")
highJumpToggleSwitch.Name = "HighJumpToggleSwitch"
highJumpToggleSwitch.Parent = highJumpToggleSwitchBg
highJumpToggleSwitch.BackgroundColor3 = colors.text_dim
highJumpToggleSwitch.BorderSizePixel = 0
highJumpToggleSwitch.Position = UDim2.new(0, 2, 0, 2)
highJumpToggleSwitch.Size = UDim2.new(0, 16, 0, 16)

local highJumpToggleCorner = Instance.new("UICorner")
highJumpToggleCorner.CornerRadius = UDim.new(0, 8)
highJumpToggleCorner.Parent = highJumpToggleSwitch

-- High Jump Toggle Button (invisible but clickable)
local highJumpToggleInvisibleButton = Instance.new("TextButton")
highJumpToggleInvisibleButton.Name = "HighJumpToggleInvisibleButton"
highJumpToggleInvisibleButton.Parent = highJumpToggleContainer
highJumpToggleInvisibleButton.BackgroundTransparency = 1
highJumpToggleInvisibleButton.Position = UDim2.new(1, -50, 0, 0)
highJumpToggleInvisibleButton.Size = UDim2.new(0, 45, 0, 25)
highJumpToggleInvisibleButton.Text = ""
highJumpToggleInvisibleButton.Font = Enum.Font.SourceSans
highJumpToggleInvisibleButton.TextSize = 1

-- Jump Power Display
local jumpPowerDisplay = Instance.new("TextLabel")
jumpPowerDisplay.Name = "JumpPowerDisplay"
jumpPowerDisplay.Parent = jumpSection
jumpPowerDisplay.BackgroundTransparency = 1
jumpPowerDisplay.Position = UDim2.new(0, 10, 0, 90)
jumpPowerDisplay.Size = UDim2.new(0, 270, 0, 20)
jumpPowerDisplay.Font = Enum.Font.Code
jumpPowerDisplay.Text = "POWER: " .. defaultJumpPower .. " | STATUS: INACTIVE"
jumpPowerDisplay.TextColor3 = colors.text
jumpPowerDisplay.TextSize = 9

-- Quick Controls Section
local quickControls = Instance.new("Frame")
quickControls.Name = "QuickControls"
quickControls.Parent = scrollFrame
quickControls.BackgroundColor3 = colors.secondary
quickControls.BorderSizePixel = 1
quickControls.BorderColor3 = colors.tertiary
quickControls.Position = UDim2.new(0, 15, 0, 350)
quickControls.Size = UDim2.new(0, 290, 0, 75)

local quickCorner = Instance.new("UICorner")
quickCorner.CornerRadius = UDim.new(0, 3)
quickCorner.Parent = quickControls

-- Quick Controls Header
local quickHeader = Instance.new("TextLabel")
quickHeader.Name = "QuickHeader"
quickHeader.Parent = quickControls
quickHeader.BackgroundTransparency = 1
quickHeader.Position = UDim2.new(0, 10, 0, 5)
quickHeader.Size = UDim2.new(0, 270, 0, 20)
quickHeader.Font = Enum.Font.Code
quickHeader.Text = "[04] RAPID_PRESETS"
quickHeader.TextColor3 = colors.text_dim
quickHeader.TextSize = 11
quickHeader.TextXAlignment = Enum.TextXAlignment.Left

-- Preset Buttons
local presetSpeeds = {25, 50, 100, 150}
for i, speed in ipairs(presetSpeeds) do
	local presetButton = Instance.new("TextButton")
	presetButton.Name = "Preset" .. speed
	presetButton.Parent = quickControls
	presetButton.BackgroundColor3 = colors.tertiary
	presetButton.BorderSizePixel = 1
	presetButton.BorderColor3 = colors.accent
	presetButton.Position = UDim2.new(0, 10 + (i-1) * 70, 0, 30)
	presetButton.Size = UDim2.new(0, 65, 0, 20)
	presetButton.Font = Enum.Font.Code
	presetButton.Text = "SPEED_" .. speed
	presetButton.TextColor3 = colors.text
	presetButton.TextSize = 9

	local presetCorner = Instance.new("UICorner")
	presetCorner.CornerRadius = UDim.new(0, 2)
	presetCorner.Parent = presetButton

	presetButton.MouseButton1Click:Connect(function()
		updateCustomSpeed(speed)
		if not isSpeedEnabled then
			enableCustomSpeed()
		end
	end)

	presetButton.MouseEnter:Connect(function()
		TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
	end)

	presetButton.MouseLeave:Connect(function()
		TweenService:Create(presetButton, TweenInfo.new(0.1), {BackgroundColor3 = colors.tertiary}):Play()
	end)
end

-- Functions
local function togglePanelVisibility()
	isPanelVisible = not isPanelVisible

	if isPanelVisible then
		-- Show panel
		mainPanel.Visible = true

		-- Position panel relative to logo button (only if not already positioned)
		local currentX = mainPanel.Position.X.Offset
		local currentY = mainPanel.Position.Y.Offset
		if currentX == -340 and currentY == 20 then
			local logoPos = logoButton.Position
			mainPanel.Position = UDim2.new(logoPos.X.Scale, logoPos.X.Offset - 280, logoPos.Y.Scale, logoPos.Y.Offset + 60)
		end

		-- Smooth fade in animation
		mainPanel.BackgroundTransparency = 1
		for i = 1, 10 do
			mainPanel.BackgroundTransparency = 1 - (i * 0.1)
			task.wait(0.02)
		end

		-- Rotate logo container to indicate active state
		TweenService:Create(logoContainer, TweenInfo.new(0.3), {Rotation = 90}):Play()

		-- Update logo status indicator
		logoStatusIndicator.BackgroundColor3 = colors.text
		TweenService:Create(logoStatusIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 8, 0, 8)}):Play()

		showNotification("PANEL_STATE: VISIBLE")
	else
		-- Hide panel
		mainPanel.BackgroundTransparency = 1
		mainPanel.Visible = false

		-- Rotate logo container back to normal
		TweenService:Create(logoContainer, TweenInfo.new(0.3), {Rotation = 0}):Play()

		-- Update logo status indicator
		logoStatusIndicator.BackgroundColor3 = colors.text_dim
		TweenService:Create(logoStatusIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 6, 0, 6)}):Play()

		showNotification("PANEL_STATE: HIDDEN")
	end
end

local function updateToggleSwitch(enabled)
	if enabled then
		TweenService:Create(toggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 27, 0, 2)}):Play()
		TweenService:Create(toggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.active}):Play()
		toggleSwitch.BackgroundColor3 = colors.text
	else
		TweenService:Create(toggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0, 2)}):Play()
		TweenService:Create(toggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.inactive}):Play()
		toggleSwitch.BackgroundColor3 = colors.text_dim
	end
end

local function updateFlyToggleSwitch(enabled)
	if enabled then
		TweenService:Create(flyToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 27, 0, 2)}):Play()
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.active}):Play()
		flyToggleSwitch.BackgroundColor3 = colors.text
	else
		TweenService:Create(flyToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0, 2)}):Play()
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.inactive}):Play()
		flyToggleSwitch.BackgroundColor3 = colors.text_dim
	end
end

local function updateInfinityToggleSwitch(enabled)
	if enabled then
		TweenService:Create(infinityToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 27, 0, 2)}):Play()
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.active}):Play()
		infinityToggleSwitch.BackgroundColor3 = colors.text
	else
		TweenService:Create(infinityToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0, 2)}):Play()
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.inactive}):Play()
		infinityToggleSwitch.BackgroundColor3 = colors.text_dim
	end
end

local function updateHighJumpToggleSwitch(enabled)
	if enabled then
		TweenService:Create(highJumpToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 27, 0, 2)}):Play()
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.active}):Play()
		highJumpToggleSwitch.BackgroundColor3 = colors.text
	else
		TweenService:Create(highJumpToggleSwitch, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0, 2)}):Play()
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = colors.inactive}):Play()
		highJumpToggleSwitch.BackgroundColor3 = colors.text_dim
	end
end

local function updateStatus(active)
	if active then
		statusIndicator.BackgroundColor3 = colors.text
		TweenService:Create(statusIndicator, TweenInfo.new(0.5), {Size = UDim2.new(0, 12, 0, 12)}):Play()
	else
		statusIndicator.BackgroundColor3 = colors.text_dim
		TweenService:Create(statusIndicator, TweenInfo.new(0.5), {Size = UDim2.new(0, 8, 0, 8)}):Play()
	end
end

local function enableCustomSpeed()
	if isSpeedEnabled then return end

	isSpeedEnabled = true
	humanoid.WalkSpeed = customWalkSpeed
	updateToggleSwitch(true)
	speedValueLabel.Text = "VAL:" .. customWalkSpeed
	currentStatusLabel.Text = "CUR:ON"
	currentStatusLabel.TextColor3 = colors.text
	updateStatus(true)

	showNotification("SPEED_MODULATION: ENABLED")
end

local function disableCustomSpeed()
	if not isSpeedEnabled then return end

	isSpeedEnabled = false
	humanoid.WalkSpeed = originalWalkSpeed
	updateToggleSwitch(false)
	speedValueLabel.Text = "VAL:" .. originalWalkSpeed
	currentStatusLabel.Text = "CUR:OFF"
	currentStatusLabel.TextColor3 = colors.text_dim
	updateStatus(false)

	showNotification("SPEED_MODULATION: DISABLED")
end

local function updateCustomSpeed(newSpeed)
	local speed = tonumber(newSpeed)
	if speed and speed >= 1 and speed <= 200 then
		customWalkSpeed = speed
		speedInput.Text = tostring(speed)

		if isSpeedEnabled then
			humanoid.WalkSpeed = customWalkSpeed
			speedValueLabel.Text = "VAL:" .. customWalkSpeed
		end
	else
		speedInput.Text = tostring(customWalkSpeed)
	end
end

local function showNotification(message)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "[SYSTEM] " .. message;
		Color = colors.text;
		Font = Enum.Font.Code;
	})
end

-- Fly Functions
local function enableFly()
	if isFlying then return end

	isFlying = true
	updateFlyToggleSwitch(true)

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

	showNotification("FLY MODE: ENABLED")
end

local function disableFly()
	if not isFlying then return end

	isFlying = false
	updateFlyToggleSwitch(false)

	if bv then
		bv:Destroy()
		bv = nil
	end

	if bg then
		bg:Destroy()
		bg = nil
	end

	humanoid.PlatformStand = false

	showNotification("FLY MODE: DISABLED")
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
	updateInfinityToggleSwitch(true)

	showNotification("INFINITE_JUMP: ENABLED")
end

local function disableInfinityJump()
	if not isInfinityJumpEnabled then return end

	isInfinityJumpEnabled = false
	updateInfinityToggleSwitch(false)

	showNotification("INFINITE_JUMP: DISABLED")
end

local function enableHighJump()
	if isHighJumpEnabled then return end

	isHighJumpEnabled = true
	humanoid.JumpPower = highJumpPower
	updateHighJumpToggleSwitch(true)
	jumpPowerDisplay.Text = "POWER: " .. highJumpPower .. " | STATUS: ACTIVE"

	showNotification("AMPLIFIED_JUMP: ENABLED")
end

local function disableHighJump()
	if not isHighJumpEnabled then return end

	isHighJumpEnabled = false
	humanoid.JumpPower = originalJumpPower
	updateHighJumpToggleSwitch(false)
	jumpPowerDisplay.Text = "POWER: " .. originalJumpPower .. " | STATUS: INACTIVE"

	showNotification("AMPLIFIED_JUMP: DISABLED")
end

-- Button Events
-- Logo button for show/hide panel
logoButton.MouseButton1Click:Connect(function()
	togglePanelVisibility()
end)

-- Logo button hover effects
logoButton.MouseEnter:Connect(function()
	TweenService:Create(logoText, TweenInfo.new(0.2), {TextColor3 = colors.active}):Play()
	TweenService:Create(logoButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
end)

logoButton.MouseLeave:Connect(function()
	TweenService:Create(logoText, TweenInfo.new(0.2), {TextColor3 = colors.text}):Play()
	TweenService:Create(logoButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.primary}):Play()
end)

-- Main panel drag start feedback
mainPanel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		-- Change header color to indicate dragging
		TweenService:Create(headerFrame, TweenInfo.new(0.1), {BackgroundColor3 = colors.tertiary}):Play()
		-- Show drag hint
		TweenService:Create(dragHint, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	end
end)

-- Main panel drag end feedback
mainPanel.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		-- Restore header color
		TweenService:Create(headerFrame, TweenInfo.new(0.1), {BackgroundColor3 = colors.secondary}):Play()
		-- Hide drag hint
		TweenService:Create(dragHint, TweenInfo.new(0.2), {TextTransparency = 0.5}):Play()
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	if isSpeedEnabled then
		disableCustomSpeed()
	else
		enableCustomSpeed()
	end
end)

setButton.MouseButton1Click:Connect(function()
	updateCustomSpeed(speedInput.Text)
end)

speedInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		updateCustomSpeed(speedInput.Text)
	end
end)

-- Fly toggle button event
flyToggleInvisibleButton.MouseButton1Click:Connect(function()
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

-- Infinity jump toggle button event
infinityToggleInvisibleButton.MouseButton1Click:Connect(function()
	if isInfinityJumpEnabled then
		disableInfinityJump()
	else
		enableInfinityJump()
	end
end)

-- High jump toggle button event
highJumpToggleInvisibleButton.MouseButton1Click:Connect(function()
	if isHighJumpEnabled then
		disableHighJump()
	else
		enableHighJump()
	end
end)

-- Hover Effects
toggleButton.MouseEnter:Connect(function()
	TweenService:Create(toggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
end)

toggleButton.MouseLeave:Connect(function()
	if isSpeedEnabled then
		TweenService:Create(toggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
	else
		TweenService:Create(toggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.inactive}):Play()
	end
end)

setButton.MouseEnter:Connect(function()
	TweenService:Create(setButton, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
end)

setButton.MouseLeave:Connect(function()
	TweenService:Create(setButton, TweenInfo.new(0.1), {BackgroundColor3 = colors.tertiary}):Play()
end)

-- Fly toggle hover effects
flyToggleInvisibleButton.MouseEnter:Connect(function()
	if isFlying then
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	else
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	end
end)

flyToggleInvisibleButton.MouseLeave:Connect(function()
	if isFlying then
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
	else
		TweenService:Create(flyToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.inactive}):Play()
	end
end)

-- Infinity jump toggle hover effects
infinityToggleInvisibleButton.MouseEnter:Connect(function()
	if isInfinityJumpEnabled then
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	else
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	end
end)

infinityToggleInvisibleButton.MouseLeave:Connect(function()
	if isInfinityJumpEnabled then
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
	else
		TweenService:Create(infinityToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.inactive}):Play()
	end
end)

-- High jump toggle hover effects
highJumpToggleInvisibleButton.MouseEnter:Connect(function()
	if isHighJumpEnabled then
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	else
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
	end
end)

highJumpToggleInvisibleButton.MouseLeave:Connect(function()
	if isHighJumpEnabled then
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.active}):Play()
	else
		TweenService:Create(highJumpToggleSwitchBg, TweenInfo.new(0.1), {BackgroundColor3 = colors.inactive}):Play()
	end
end)

-- Fly Control (FIXED: W now goes forward, S goes backward)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not isFlying then return end

	if input.KeyCode == Enum.KeyCode.W then
		flyDirection = Vector3.new(0, 0, 1)   -- Forward (positive Z)
	elseif input.KeyCode == Enum.KeyCode.S then
		flyDirection = Vector3.new(0, 0, -1)  -- Backward (negative Z)
	elseif input.KeyCode == Enum.KeyCode.A then
		flyDirection = Vector3.new(-1, 0, 0)  -- Left
	elseif input.KeyCode == Enum.KeyCode.D then
		flyDirection = Vector3.new(1, 0, 0)   -- Right
	elseif input.KeyCode == Enum.KeyCode.Space then
		flyDirection = Vector3.new(0, 1, 0)   -- Up
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		flyDirection = Vector3.new(0, -1, 0)  -- Down
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

	-- Speed toggle
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

	-- Reset panel position
	if input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		local logoPos = logoButton.Position
		mainPanel.Position = UDim2.new(logoPos.X.Scale, logoPos.X.Offset - 280, logoPos.Y.Scale, logoPos.Y.Offset + 60)
		showNotification("PANEL_POSITION: RESET")
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
		speedValueLabel.Text = "VAL:" .. originalWalkSpeed
		showNotification("SYSTEM_RESET: COMPLETE")
	end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	originalWalkSpeed = humanoid.WalkSpeed
	originalJumpPower = humanoid.JumpPower
	speedValueLabel.Text = "VAL:" .. originalWalkSpeed
	jumpPowerDisplay.Text = "POWER: " .. originalJumpPower .. " | STATUS: INACTIVE"

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

print("[SYSTEM] .SYSTEM: INITIALIZED")
print("[KEYBINDS] X:SPEED F:FLY J:INFINITE_JUMP H:HIGH_JUMP")
print("[PANEL] CLICK_LOGO:TOGGLE_PANEL DRAG_HEADER:MOVE_PANEL CTRL+P:RESET_POSITION")
print("[RESET] CTRL+R: SYSTEM_RESET")
print("[SCROLLING] USE_MOUSE_WHEEL_OR_SCROLLBAR")
print("[FLIGHT_CONTROLS] W:FORWARD S:BACKWARD A:LEFT D:RIGHT SPACE:UP SHIFT:DOWN") 
