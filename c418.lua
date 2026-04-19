--[[
    VNA LITE - RESPRAWN EDITION
    Actually fetches the latest script from GitHub.
    Now with Instant Respawn and Speed Slider!
]]

local GITHUB_URL = "https://raw.githubusercontent.com/Vanhlord/roloc/main/c418.lua"
local DEV_MODE = true -- Set to true to bypass GitHub and run local file directly

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Fallback parenting
local function getGuiParent()
    local success, gui = pcall(function() 
        return (gethui and gethui()) or game:FindService("CoreGui") or LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
    return (success and gui) or LocalPlayer:WaitForChild("PlayerGui")
end

-- ==================== BOOTSTRAPPER CHECK ====================
if not _G.VNA_BOOTSTRAPPED and not DEV_MODE then
    _G.VNA_BOOTSTRAPPED = true
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VNA_Loader"
    ScreenGui.DisplayOrder = 999999
    ScreenGui.Parent = getGuiParent()
    
    local StartupFrame = Instance.new("Frame")
    StartupFrame.Name = "StartupFrame"
    StartupFrame.Parent = ScreenGui
    StartupFrame.Size = UDim2.new(0, 300, 0, 150)
    StartupFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    StartupFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    StartupFrame.BorderSizePixel = 0
    Instance.new("UICorner", StartupFrame).CornerRadius = UDim.new(0, 15)
    
    local PulseLogo = Instance.new("TextLabel")
    PulseLogo.Parent = StartupFrame
    PulseLogo.Size = UDim2.new(0, 80, 0, 80)
    PulseLogo.Position = UDim2.new(0.5, 0, 0.4, 0)
    PulseLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    PulseLogo.BackgroundTransparency = 1
    PulseLogo.Text = "VNA"
    PulseLogo.TextColor3 = Color3.fromRGB(100, 200, 255)
    PulseLogo.TextSize = 30
    PulseLogo.Font = Enum.Font.GothamBold
    
    local SyncText = Instance.new("TextLabel")
    SyncText.Parent = StartupFrame
    SyncText.Size = UDim2.new(1, 0, 0, 30)
    SyncText.Position = UDim2.new(0, 0, 0.75, 0)
    SyncText.BackgroundTransparency = 1
    SyncText.Text = "FETCHING LATEST VERSION..."
    SyncText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SyncText.TextSize = 10
    SyncText.Font = Enum.Font.GothamMedium
    
    task.spawn(function()
        local count = 0
        while StartupFrame and StartupFrame.Parent do
            count = count + task.wait() * 4
            PulseLogo.Rotation = math.sin(count) * 10
            PulseLogo.TextTransparency = 0.3 + math.sin(count) * 0.2
        end
    end)
    
    local success, result = pcall(function()
        return game:HttpGet(GITHUB_URL)
    end)
    
    if success then
        SyncText.Text = "CLIENT LOADED!"
        SyncText.TextColor3 = Color3.fromRGB(100, 255, 150)
        task.wait(0.5)
        loadstring(result)() 
    else
        SyncText.Text = "SYNC FAILED! RUNNING LOCAL..."
        SyncText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1)
        _G.VNA_BOOTSTRAPPED = false
    end
    
    if success then return end 
end

_G.VNA_BOOTSTRAPPED = false

-- ==================== MAIN SCRIPT LOGIC ====================

local OldLoader = getGuiParent():FindFirstChild("VNA_Loader")
if OldLoader then OldLoader:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VNA_Lite_Final"
ScreenGui.ResetOnSpawn = true
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = getGuiParent()

local isSpeedEnabled = false
local isRespawnEnabled = false
local currentSpeedValue = 100

-- Ready Animation Frame
local ReadyFrame = Instance.new("Frame")
ReadyFrame.Parent = ScreenGui
ReadyFrame.Size = UDim2.new(0, 300, 0, 150)
ReadyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
ReadyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ReadyFrame.BorderSizePixel = 0
Instance.new("UICorner", ReadyFrame).CornerRadius = UDim.new(0, 15)

local ReadyLogo = Instance.new("TextLabel")
ReadyLogo.Parent = ReadyFrame
ReadyLogo.Size = UDim2.new(1, 0, 1, 0)
ReadyLogo.BackgroundTransparency = 1
ReadyLogo.Text = "VNA READY!"
ReadyLogo.TextColor3 = Color3.fromRGB(100, 255, 150)
ReadyLogo.TextSize = 24
ReadyLogo.Font = Enum.Font.GothamBold

-- ==================== MAIN MENU UI ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 280) -- Increased for multiple buttons
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "VNA SYSTEM LITE"
TitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons (O & X)
local function createTitleBtn(text, color, pos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TitleBar
    Btn.Size = UDim2.new(0, 30, 0, 30)
    Btn.Position = pos
    Btn.BackgroundColor3 = color
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 16
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local MinimizedIcon = Instance.new("TextButton") 
local CloseBtn = createTitleBtn("✕", Color3.fromRGB(200, 60, 60), UDim2.new(1, -35, 0.5, -15), function() ScreenGui:Destroy() end)
local HideBtn = createTitleBtn("◯", Color3.fromRGB(50, 100, 150), UDim2.new(1, -70, 0.5, -15), function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

-- Draggable Handle
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame, TitleBar)

-- Helper để tạo nút Toggle to
local function createToggleBtn(name, text, pos)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Parent = MainFrame
    Btn.Size = UDim2.new(0.8, 0, 0, 45)
    Btn.Position = pos
    Btn.AnchorPoint = Vector2.new(0.5, 0.5)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Color3.fromRGB(60,60,60)
    Stroke.Thickness = 2
    return Btn, Stroke
end

-- 1. Nút Hồi Sinh Nhanh
local RespawnBtn, RespawnStroke = createToggleBtn("RespawnBtn", "BAT HOI SINH NHANH", UDim2.new(0.5, 0, 0, 75))
RespawnBtn.MouseButton1Click:Connect(function()
    isRespawnEnabled = not isRespawnEnabled
    local targetColor = isRespawnEnabled and Color3.fromRGB(150, 50, 150) or Color3.fromRGB(40, 40, 40)
    local targetText = isRespawnEnabled and "TAT HOI SINH NHANH" or "BAT HOI SINH NHANH"
    TweenService:Create(RespawnBtn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(RespawnStroke, TweenInfo.new(0.3), {Color = isRespawnEnabled and Color3.fromRGB(200, 100, 255) or Color3.fromRGB(60, 60, 60)}):Play()
    RespawnBtn.Text = targetText
end)

-- 2. Nút Chạy Nhanh
local SpeedBtn, SpeedStroke = createToggleBtn("SpeedBtn", "BAT CHAY NHANH", UDim2.new(0.5, 0, 0, 130))
SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = isSpeedEnabled and currentSpeedValue or 16
    end
    local targetColor = isSpeedEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
    local targetText = isSpeedEnabled and "TAT CHAY NHANH" or "BAT CHAY NHANH"
    TweenService:Create(SpeedBtn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(SpeedStroke, TweenInfo.new(0.3), {Color = isSpeedEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 60)}):Play()
    SpeedBtn.Text = targetText
end)

-- 3. Speed Slider
local SliderContainer = Instance.new("Frame")
SliderContainer.Parent = MainFrame
SliderContainer.Size = UDim2.new(0.8, 0, 0, 70)
SliderContainer.Position = UDim2.new(0.5, 0, 0, 205)
SliderContainer.AnchorPoint = Vector2.new(0.5, 0.5)
SliderContainer.BackgroundTransparency = 1

local ValueLabel = Instance.new("TextLabel")
ValueLabel.Parent = SliderContainer
ValueLabel.Size = UDim2.new(1, 0, 0, 20)
ValueLabel.Position = UDim2.new(0, 0, 0, 0)
ValueLabel.BackgroundTransparency = 1
ValueLabel.Text = "TỐC ĐỘ: " .. currentSpeedValue
ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ValueLabel.TextSize = 12
ValueLabel.Font = Enum.Font.GothamMedium

local SliderBar = Instance.new("Frame")
SliderBar.Parent = SliderContainer
SliderBar.Size = UDim2.new(1, 0, 0, 10)
SliderBar.Position = UDim2.new(0, 0, 0, 35)
SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderBar.BorderSizePixel = 0
Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBar
SliderFill.Size = UDim2.new(currentSpeedValue/999, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
SliderFill.BorderSizePixel = 0
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderThumb = Instance.new("Frame")
SliderThumb.Parent = SliderBar
SliderThumb.Size = UDim2.new(0, 18, 0, 18)
SliderThumb.Position = UDim2.new(currentSpeedValue/999, 0, 0.5, 0)
SliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderThumb.BorderSizePixel = 0
Instance.new("UICorner", SliderThumb).CornerRadius = UDim.new(1, 0)

local dragging = false
local function updateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    SliderThumb.Position = UDim2.new(pos, 0, 0.5, 0)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    currentSpeedValue = math.floor(pos * 999)
    ValueLabel.Text = "TỐC ĐỘ: " .. currentSpeedValue
    if isSpeedEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = currentSpeedValue
        end
    end
end

SliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ==================== BACKGROUND LOGIC (HEARTBEAT) ====================
RunService.Heartbeat:Connect(function()
    -- Hồi sinh nhanh logic
    if isRespawnEnabled then
        pcall(function()
            -- Cố gắng ép thời gian hồi sinh về 0
            game:GetService("Players").RespawnTime = 0
            if LocalPlayer.RespawnTime ~= 0 then
                LocalPlayer.RespawnTime = 0
            end
        end)
    end
end)

-- Minimized Icon
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.02, 0, 0.05, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizedIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
MinimizedIcon.Text = "VNA"
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.TextSize = 16
MinimizedIcon.Visible = false
Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinimizedIcon).Color = Color3.fromRGB(100, 200, 255)
MinimizedIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true; MinimizedIcon.Visible = false
end)

-- Transition to Menu
task.wait(0.8)
local fadeOut = TweenService:Create(ReadyFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
TweenService:Create(ReadyLogo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
fadeOut:Play()
fadeOut.Completed:Connect(function()
    ReadyFrame:Destroy()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 280, 0, 260)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 280)}):Play()
end)