--[[
    VNA LITE - BOOTSTRAPPER EDITION
    Actually fetches the latest script from GitHub.
]]

local GITHUB_URL = "https://raw.githubusercontent.com/Vanhlord/roloc/main/c418.lua"
local DEV_MODE = false -- Set to true to bypass GitHub and run local file directly

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
    _G.VNA_BOOTSTRAPPED = true -- Flag to let the next run know it's the real one
    
    -- Create temporary Startup UI
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
    
    -- Simple spin/pulse animation
    task.spawn(function()
        local count = 0
        while StartupFrame and StartupFrame.Parent do
            count = count + task.wait() * 4
            PulseLogo.Rotation = math.sin(count) * 10
            PulseLogo.TextTransparency = 0.3 + math.sin(count) * 0.2
        end
    end)
    
    -- Actual fetch
    local success, result = pcall(function()
        return game:HttpGet(GITHUB_URL)
    end)
    
    if success then
        SyncText.Text = "CLIENT LOADED!"
        SyncText.TextColor3 = Color3.fromRGB(100, 255, 150)
        task.wait(0.5)
        loadstring(result)() -- Execute the remote code
    else
        SyncText.Text = "SYNC FAILED! RUNNING LOCAL..."
        SyncText.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(1)
        _G.VNA_BOOTSTRAPPED = false
        -- Fallback: proceed with local script logic
    end
    
    -- If successful, loadstring() will run the code below in a DIFFERENT thread.
    -- We must STOP this thread here.
    if success then return end 
end

-- Clear flag for next manual run
_G.VNA_BOOTSTRAPPED = false

-- ==================== MAIN SCRIPT LOGIC (THE "REAL" ONE) ====================

-- Cleanup previous loader if it exists
local OldLoader = getGuiParent():FindFirstChild("VNA_Loader")
if OldLoader then OldLoader:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VNA_Lite_Final"
ScreenGui.ResetOnSpawn = true
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = getGuiParent()

local isSpeedEnabled = false

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
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
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

local MinimizedIcon = Instance.new("TextButton") -- Forward dec
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

-- Speed Button
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = MainFrame
SpeedBtn.Size = UDim2.new(0.8, 0, 0, 60)
SpeedBtn.Position = UDim2.new(0.5, 0, 0.65, 0)
SpeedBtn.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SpeedBtn.TextSize = 16
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.Text = "BAT CHAY NHANH"
SpeedBtn.BorderSizePixel = 0
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0, 10)
local SpeedStroke = Instance.new("UIStroke", SpeedBtn)
SpeedStroke.Color = Color3.fromRGB(60,60,60)
SpeedStroke.Thickness = 2

SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = isSpeedEnabled and 32 or 16
    end
    local targetColor = isSpeedEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 40)
    local targetText = isSpeedEnabled and "TAT CHAY NHANH" or "BAT CHAY NHANH"
    TweenService:Create(SpeedBtn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(SpeedStroke, TweenInfo.new(0.3), {Color = isSpeedEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 60)}):Play()
    SpeedBtn.Text = targetText
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
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
end)

-- Transition to Menu
task.wait(0.8)
local fadeOut = TweenService:Create(ReadyFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
TweenService:Create(ReadyLogo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
fadeOut:Play()
fadeOut.Completed:Connect(function()
    ReadyFrame:Destroy()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 280, 0, 160)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 180)}):Play()
end)