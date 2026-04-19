-- Tạo cái GUI chứa nút
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fallback parenting cho ScreenGui
local function getGuiParent()
    local success, gui = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui") end)
    if success then return gui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VNA_Menu_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = getGuiParent()

-- Biến trạng thái
local isMenuVisible = true
local isSpeedOn = false
local isFlying = false
local flySpeed = 50
local flyConnection = nil
local currentPage = "Speed"

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 500, 0, 330)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 5
MainFrame.Active = true -- Chặn click xuyên qua

local CornerMain = Instance.new("UICorner")
CornerMain.CornerRadius = UDim.new(0, 10)
CornerMain.Parent = MainFrame

-- ==================== DRAG FUNCTION ====================
local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==================== TITLE BAR ====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 6

local CornerTitle = Instance.new("UICorner")
CornerTitle.CornerRadius = UDim.new(0, 10)
CornerTitle.Parent = TitleBar

makeDraggable(MainFrame, TitleBar)

-- Logo VNA
local LogoText = Instance.new("TextLabel")
LogoText.Parent = TitleBar
LogoText.Size = UDim2.new(0, 80, 1, 0)
LogoText.Position = UDim2.new(0, 15, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "VNA"
LogoText.TextColor3 = Color3.fromRGB(100, 200, 255)
LogoText.TextSize = 24
LogoText.Font = Enum.Font.GothamBold
LogoText.ZIndex = 7

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -200, 1, 0)
TitleText.Position = UDim2.new(0, 100, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚙️ MENU SYSTEM"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.ZIndex = 7

-- Helper để tạo nút Title
local function createTitleButton(name, text, color, pos)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = TitleBar
    Button.Size = UDim2.new(0, 35, 0, 35)
    Button.Position = pos
    Button.BackgroundColor3 = color
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 18
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.ZIndex = 10 -- Cao nhất để ưu tiên click
    Button.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    return Button
end

local HideButton = createTitleButton("HideButton", "◯", Color3.fromRGB(50, 100, 150), UDim2.new(1, -77, 0.5, -17))
local CloseButton = createTitleButton("CloseButton", "✕", Color3.fromRGB(200, 60, 60), UDim2.new(1, -37, 0.5, -17))

-- ==================== BODY FRAME ====================
local BodyFrame = Instance.new("Frame")
BodyFrame.Name = "BodyFrame"
BodyFrame.Parent = MainFrame
BodyFrame.Size = UDim2.new(1, 0, 1, -50)
BodyFrame.Position = UDim2.new(0, 0, 0, 50)
BodyFrame.BackgroundTransparency = 1
BodyFrame.ZIndex = 5

-- ==================== SIDEBAR (TRÁI) ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = BodyFrame
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.ZIndex = 6

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)
SidebarPadding.PaddingTop = UDim.new(0, 10)

-- ==================== CONTENT AREA (PHẢI) ====================
-- Chuyển sang ScrollingFrame để tránh lỗi tràn nội dung trên mobile
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = BodyFrame
ContentArea.Size = UDim2.new(1, -140, 1, -10)
ContentArea.Position = UDim2.new(0, 135, 0, 5)
ContentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 6
ContentArea.ScrollBarThickness = 2
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0) -- Tự động điều chỉnh
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentArea
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentArea
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)

-- ==================== HÀM TẠO NÚT ====================
local function createSidebarButton(name, text)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 11
    Button.Font = Enum.Font.Gotham
    Button.ZIndex = 7
    Button.Text = text
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button
    
    return Button
end

local function createFeatureButton(name, text)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = ContentArea
    Button.Size = UDim2.new(0.9, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.Gotham
    Button.ZIndex = 7
    Button.Text = text
    Button.Visible = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    return Button
end

-- ==================== SIDEBAR BUTTONS ====================
local SpeedPageBtn = createSidebarButton("SpeedPageBtn", "▶ Chạy Nhanh")
local FlyPageBtn = createSidebarButton("FlyPageBtn", "✈ Bay")
local SettingsPageBtn = createSidebarButton("SettingsPageBtn", "⚙️ Cài Đặt")
local InfoPageBtn = createSidebarButton("InfoPageBtn", "ℹ️ Thông Tin")

-- ==================== SPEED PAGE ====================
local SpeedToggleBtn = createFeatureButton("SpeedToggleBtn", "▶ BẬT CHẠY NHANH")
local SpeedInfoLabel = Instance.new("TextLabel")
SpeedInfoLabel.Parent = ContentArea
SpeedInfoLabel.Size = UDim2.new(0.9, 0, 0, 50)
SpeedInfoLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
SpeedInfoLabel.TextSize = 11
SpeedInfoLabel.Font = Enum.Font.Gotham
SpeedInfoLabel.Text = "Tốc độ: 16 -> 32\nBấm nút để thay đổi"
SpeedInfoLabel.ZIndex = 7
SpeedInfoLabel.Visible = false

local SC = Instance.new("UICorner")
SC.CornerRadius = UDim.new(0, 6)
SC.Parent = SpeedInfoLabel

-- ==================== FLY PAGE ====================
local FlyToggleBtn = createFeatureButton("FlyToggleBtn", "✈ BẬT CHẾ ĐỘ BAY")
local FlyInfoLabel = Instance.new("TextLabel")
FlyInfoLabel.Parent = ContentArea
FlyInfoLabel.Size = UDim2.new(0.9, 0, 0, 40)
FlyInfoLabel.BackgroundTransparency = 1
FlyInfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
FlyInfoLabel.TextSize = 11
FlyInfoLabel.Font = Enum.Font.Gotham
FlyInfoLabel.Text = "💡 Dùng các nút bên dưới để điều khiển"
FlyInfoLabel.ZIndex = 7
FlyInfoLabel.Visible = false

local FlyControlContainer = Instance.new("Frame")
FlyControlContainer.Parent = ContentArea
FlyControlContainer.Size = UDim2.new(1, 0, 0, 160)
FlyControlContainer.BackgroundTransparency = 1
FlyControlContainer.Visible = false
FlyControlContainer.ZIndex = 7

local ControlLayout = Instance.new("UIGridLayout")
ControlLayout.Parent = FlyControlContainer
ControlLayout.CellSize = UDim2.new(0.33, -5, 0.5, -5)
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Biến trạng thái nút
local buttonStates = {forward = false, backward = false, left = false, right = false, up = false, down = false}

local function createFlyControlButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = FlyControlContainer
    Button.BackgroundColor3 = Color3.fromRGB(60, 80, 100)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.ZIndex = 8
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    local function set(p) 
        Button.BackgroundColor3 = p and Color3.fromRGB(100, 150, 200) or Color3.fromRGB(60, 80, 100)
        callback(p) 
    end
    
    Button.MouseButton1Down:Connect(function() set(true) end)
    Button.MouseButton1Up:Connect(function() set(false) end)
    Button.TouchBegan:Connect(function() set(true) end)
    Button.TouchEnded:Connect(function() set(false) end)
    
    return Button
end

createFlyControlButton("▲ Tien", function(p) buttonStates.forward = p end)
createFlyControlButton("◀ Trai", function(p) buttonStates.left = p end)
createFlyControlButton("▶ Phai", function(p) buttonStates.right = p end)
createFlyControlButton("▼ Lui", function(p) buttonStates.backward = p end)
createFlyControlButton("⬆ Len", function(p) buttonStates.up = p end)
createFlyControlButton("⬇ Xuong", function(p) buttonStates.down = p end)

-- ==================== SETTINGS PAGE ====================
local SpeedSliderLabel = Instance.new("TextLabel")
SpeedSliderLabel.Parent = ContentArea
SpeedSliderLabel.Size = UDim2.new(0.9, 0, 0, 40)
SpeedSliderLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSliderLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
SpeedSliderLabel.TextSize = 11
SpeedSliderLabel.Font = Enum.Font.Gotham
SpeedSliderLabel.Text = "Tốc độ bay: " .. flySpeed
SpeedSliderLabel.ZIndex = 7
SpeedSliderLabel.Visible = false

local DecreaseSpeedBtn = createFeatureButton("DecreaseSpeedBtn", "- Giảm Tốc Độ")
local IncreaseSpeedBtn = createFeatureButton("IncreaseSpeedBtn", "+ Tăng Tốc Độ")
local ReloadScriptBtn = createFeatureButton("ReloadScriptBtn", "🔄 Tải Lại Script")

-- ==================== INFO PAGE ====================
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = ContentArea
InfoLabel.Size = UDim2.new(0.9, 0, 0, 120)
InfoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
InfoLabel.TextSize = 10
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "VNA MENU SYSTEM v1.1 - FIXED\n\n📌 Chức năng:\n• Chạy Nhanh\n• Bay (PC & Mobile)\n\n💡 Hướng dẫn: Dùng nút O để ẩn"
InfoLabel.TextWrapped = true
InfoLabel.Visible = false
InfoLabel.ZIndex = 7

-- ==================== LOGIC HÀM ====================
local function showPage(pageName)
    currentPage = pageName
    SpeedToggleBtn.Visible = false; SpeedInfoLabel.Visible = false
    FlyToggleBtn.Visible = false; FlyInfoLabel.Visible = false; FlyControlContainer.Visible = false
    SpeedSliderLabel.Visible = false; DecreaseSpeedBtn.Visible = false; IncreaseSpeedBtn.Visible = false; ReloadScriptBtn.Visible = false
    InfoLabel.Visible = false
    
    SpeedPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FlyPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SettingsPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InfoPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    if pageName == "Speed" then
        SpeedToggleBtn.Visible = true; SpeedInfoLabel.Visible = true
        SpeedPageBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif pageName == "Fly" then
        FlyToggleBtn.Visible = true; FlyInfoLabel.Visible = true; FlyControlContainer.Visible = true
        FlyPageBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    elseif pageName == "Settings" then
        SpeedSliderLabel.Visible = true; DecreaseSpeedBtn.Visible = true; IncreaseSpeedBtn.Visible = true; ReloadScriptBtn.Visible = true
        SettingsPageBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    elseif pageName == "Info" then
        InfoLabel.Visible = true
        InfoPageBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
    end
end

local function stopFlying()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bv = rootPart:FindFirstChild("VNABodyVelocity")
            if bv then bv:Destroy() end
        end
    end
end

local function startFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    stopFlying()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "VNABodyVelocity"
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not isFlying then stopFlying(); return end
        local camera = workspace.CurrentCamera
        local md = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or buttonStates.forward then md = md + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or buttonStates.backward then md = md - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or buttonStates.left then md = md - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or buttonStates.right then md = md + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or buttonStates.up then md = md + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or buttonStates.down then md = md - Vector3.new(0, 1, 0) end
        
        if md.Magnitude > 0 then md = md.Unit end
        bodyVelocity.Velocity = md * flySpeed
    end)
end

-- ==================== EVENTS ====================
SpeedPageBtn.MouseButton1Click:Connect(function() showPage("Speed") end)
FlyPageBtn.MouseButton1Click:Connect(function() showPage("Fly") end)
SettingsPageBtn.MouseButton1Click:Connect(function() showPage("Settings") end)
InfoPageBtn.MouseButton1Click:Connect(function() showPage("Info") end)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        isSpeedOn = not isSpeedOn
        char.Humanoid.WalkSpeed = isSpeedOn and 32 or 16
        SpeedToggleBtn.Text = isSpeedOn and "⏹ TAT CHAY NHANH" or "▶ BAT CHAY NHANH"
        SpeedToggleBtn.BackgroundColor3 = isSpeedOn and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(50, 50, 50)
    end
end)

FlyToggleBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    FlyToggleBtn.Text = isFlying and "⏹ TAT CHE DO BAY" or "✈ BAT CHE DO BAY"
    FlyToggleBtn.BackgroundColor3 = isFlying and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(50, 50, 50)
    if isFlying then startFlying() else stopFlying() end
end)

DecreaseSpeedBtn.MouseButton1Click:Connect(function() flySpeed = math.max(10, flySpeed-10); SpeedSliderLabel.Text = "Tốc độ bay: "..flySpeed end)
IncreaseSpeedBtn.MouseButton1Click:Connect(function() flySpeed = math.min(200, flySpeed+10); SpeedSliderLabel.Text = "Tốc độ bay: "..flySpeed end)

-- UI Control
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Parent = ScreenGui; MinimizedIcon.Size = UDim2.new(0, 50, 0, 50); MinimizedIcon.Position = UDim2.new(0.02, 0, 0.02, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(30,30,30); MinimizedIcon.TextColor3 = Color3.fromRGB(100,200,255); MinimizedIcon.Text = "VNA"; MinimizedIcon.Visible = false; MinimizedIcon.ZIndex = 100
Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(0, 8)

HideButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    MinimizedIcon.Visible = not isMenuVisible
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    isMenuVisible = true; MainFrame.Visible = true; MinimizedIcon.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    stopFlying(); ScreenGui:Destroy()
end)

ReloadScriptBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy(); task.wait(0.5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanhlord/roloc/main/c418.lua"))()
end)

-- Character Persistence
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if isSpeedOn then hum.WalkSpeed = 32 end
    if isFlying then isFlying = false; stopFlying(); FlyToggleBtn.Text = "✈ BAT CHE DO BAY" end
end)

showPage("Speed")