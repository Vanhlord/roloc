-- Tạo cái GUI chứa nút
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyMenu"
ScreenGui.Parent = game.CoreGui

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
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0

local CornerMain = Instance.new("UICorner")
CornerMain.CornerRadius = UDim.new(0, 10)
CornerMain.Parent = MainFrame

-- ==================== TITLE BAR ====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0

local CornerTitle = Instance.new("UICorner")
CornerTitle.CornerRadius = UDim.new(0, 10)
CornerTitle.Parent = TitleBar

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

-- Title Text ở giữa
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -200, 1, 0)
TitleText.Position = UDim2.new(0, 100, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚙️ MENU SYSTEM"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold

-- Nút ẩn menu (O)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Parent = TitleBar
HideButton.Size = UDim2.new(0, 35, 0, 35)
HideButton.Position = UDim2.new(1, -77, 0.5, -17)
HideButton.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 16
HideButton.Font = Enum.Font.GothamBold
HideButton.Text = "◯"
HideButton.BorderSizePixel = 0

local CornerHide = Instance.new("UICorner")
CornerHide.CornerRadius = UDim.new(0, 6)
CornerHide.Parent = HideButton

-- Nút đóng menu (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -37, 0.5, -17)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.BorderSizePixel = 0

local CornerClose = Instance.new("UICorner")
CornerClose.CornerRadius = UDim.new(0, 6)
CornerClose.Parent = CloseButton

-- ==================== BODY FRAME ====================
local BodyFrame = Instance.new("Frame")
BodyFrame.Name = "BodyFrame"
BodyFrame.Parent = MainFrame
BodyFrame.Size = UDim2.new(1, 0, 1, -50)
BodyFrame.Position = UDim2.new(0, 0, 0, 50)
BodyFrame.BackgroundTransparency = 1
BodyFrame.BorderSizePixel = 0

-- ==================== SIDEBAR (TRÁI) ====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = BodyFrame
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

-- UIListLayout cho Sidebar
local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.FillDirection = Enum.FillDirection.Vertical
SidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingBottom = UDim.new(0, 10)

-- ==================== CONTENT AREA (PHẢI) ====================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = BodyFrame
ContentArea.Size = UDim2.new(1, -160, 1, 0)
ContentArea.Position = UDim2.new(0, 160, 0, 0)
ContentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentArea.BorderSizePixel = 0

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

-- UIListLayout cho Content
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentArea
ContentLayout.Padding = UDim.new(0, 12)
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentArea
ContentPadding.PaddingLeft = UDim.new(0, 20)
ContentPadding.PaddingRight = UDim.new(0, 20)
ContentPadding.PaddingTop = UDim.new(0, 20)
ContentPadding.PaddingBottom = UDim.new(0, 20)

-- ==================== HÀM TẠO NÚT ====================
local function createSidebarButton(name, text)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 12
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button
    
    return Button
end

local function createFeatureButton(name, text)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = ContentArea
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.BorderSizePixel = 0
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

-- ==================== FEATURE BUTTONS (Chạy Nhanh) ====================
local SpeedToggleBtn = createFeatureButton("SpeedToggleBtn", "▶ BẬT CHẠY NHANH")
local SpeedInfoLabel = Instance.new("TextLabel")
SpeedInfoLabel.Parent = ContentArea
SpeedInfoLabel.Size = UDim2.new(1, 0, 0, 60)
SpeedInfoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
SpeedInfoLabel.TextSize = 12
SpeedInfoLabel.Font = Enum.Font.Gotham
SpeedInfoLabel.Text = "Tốc độ mặc định: 16\nTốc độ khi bật: 32\nNhấp nút để bật/tắt"
SpeedInfoLabel.TextWrapped = true
SpeedInfoLabel.Visible = false
SpeedInfoLabel.BorderSizePixel = 0

local SpeedCornerLabel = Instance.new("UICorner")
SpeedCornerLabel.CornerRadius = UDim.new(0, 6)
SpeedCornerLabel.Parent = SpeedInfoLabel

-- ==================== FEATURE BUTTONS (Bay) ====================
local FlyToggleBtn = createFeatureButton("FlyToggleBtn", "✈ BẬT CHẾ ĐỘ BAY")
local FlyInfoLabel = Instance.new("TextLabel")
FlyInfoLabel.Parent = ContentArea
FlyInfoLabel.Size = UDim2.new(1, 0, 0, 80)
FlyInfoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyInfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
FlyInfoLabel.TextSize = 12
FlyInfoLabel.Font = Enum.Font.Gotham
FlyInfoLabel.Text = "W/A/S/D: Di chuyển\nSpace: Bay lên\nCtrl: Bay xuống\nTốc độ: 50"
FlyInfoLabel.TextWrapped = true
FlyInfoLabel.Visible = false
FlyInfoLabel.BorderSizePixel = 0

local FlyCornerLabel = Instance.new("UICorner")
FlyCornerLabel.CornerRadius = UDim.new(0, 6)
FlyCornerLabel.Parent = FlyInfoLabel

-- ==================== FEATURE BUTTONS (Settings) ====================
local SpeedSliderLabel = Instance.new("TextLabel")
SpeedSliderLabel.Parent = ContentArea
SpeedSliderLabel.Size = UDim2.new(1, 0, 0, 50)
SpeedSliderLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSliderLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
SpeedSliderLabel.TextSize = 12
SpeedSliderLabel.Font = Enum.Font.Gotham
SpeedSliderLabel.Text = "⚙️ Tùy chỉnh tốc độ bay"
SpeedSliderLabel.Visible = false
SpeedSliderLabel.BorderSizePixel = 0

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SpeedSliderLabel

local DecreaseSpeedBtn = createFeatureButton("DecreaseSpeedBtn", "- Giảm Tốc Độ")
DecreaseSpeedBtn.Visible = false

local IncreaseSpeedBtn = createFeatureButton("IncreaseSpeedBtn", "+ Tăng Tốc Độ")
IncreaseSpeedBtn.Visible = false

local ReloadScriptBtn = createFeatureButton("ReloadScriptBtn", "🔄 Tải Phiên Bản Mới")
ReloadScriptBtn.Visible = false

-- ==================== FEATURE BUTTONS (Info) ====================
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = ContentArea
InfoLabel.Size = UDim2.new(1, 0, 0, 150)
InfoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfoLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
InfoLabel.TextSize = 11
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "VNA MENU SYSTEM v1.0\n\n📌 Các chức năng:\n• Chạy Nhanh: Tăng tốc độ di chuyển\n• Bay: Cho phép bay tự do\n\n💡 Gợi ý: Sử dụng nút ◯ để ẩn menu"
InfoLabel.TextWrapped = true
InfoLabel.Visible = false
InfoLabel.BorderSizePixel = 0

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 6)
InfoCorner.Parent = InfoLabel

-- ==================== HÀM XỬ LÝ TRANG ====================
local function showPage(pageName)
    currentPage = pageName
    
    -- Ẩn tất cả
    SpeedToggleBtn.Visible = false
    SpeedInfoLabel.Visible = false
    FlyToggleBtn.Visible = false
    FlyInfoLabel.Visible = false
    SpeedSliderLabel.Visible = false
    DecreaseSpeedBtn.Visible = false
    IncreaseSpeedBtn.Visible = false
    InfoLabel.Visible = false
    
    -- Reset màu sidebar
    SpeedPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FlyPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SettingsPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InfoPageBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    if pageName == "Speed" then
        SpeedToggleBtn.Visible = true
        SpeedInfoLabel.Visible = true
        SpeedPageBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    elseif pageName == "Fly" then
        FlyToggleBtn.Visible = true
        FlyInfoLabel.Visible = true
        FlyPageBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    elseif pageName == "Settings" then
        SpeedSliderLabel.Visible = true
        DecreaseSpeedBtn.Visible = true
        IncreaseSpeedBtn.Visible = true
        ReloadScriptBtn.Visible = true
        SettingsPageBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    elseif pageName == "Info" then
        InfoLabel.Visible = true
        InfoPageBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
    end
end

-- ==================== SIDEBAR CLICK EVENTS ====================
SpeedPageBtn.MouseButton1Click:Connect(function()
    showPage("Speed")
end)

FlyPageBtn.MouseButton1Click:Connect(function()
    showPage("Fly")
end)

SettingsPageBtn.MouseButton1Click:Connect(function()
    showPage("Settings")
end)

InfoPageBtn.MouseButton1Click:Connect(function()
    showPage("Info")
end)

-- ==================== HÀM XỬ LÝ CHẠY NHANH ====================
SpeedToggleBtn.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        isSpeedOn = not isSpeedOn
        if isSpeedOn then
            SpeedToggleBtn.Text = "⏹ TẮT CHẠY NHANH"
            SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            character.Humanoid.WalkSpeed = 32
        else
            SpeedToggleBtn.Text = "▶ BẬT CHẠY NHANH"
            SpeedToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
            character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- ==================== HÀM XỬ LÝ BAY ====================
local function startFlying()
    local character = game.Players.LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart
    
    flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not isFlying then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        bodyVelocity.Velocity = moveDirection * flySpeed
    end)
end

local function stopFlying()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    local character = game.Players.LocalPlayer.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

FlyToggleBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        FlyToggleBtn.Text = "⏹ TẮT CHẾ ĐỘ BAY"
        FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        startFlying()
    else
        FlyToggleBtn.Text = "✈ BẬT CHẾ ĐỘ BAY"
        FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 200)
        stopFlying()
    end
end)

-- ==================== SETTINGS ====================
DecreaseSpeedBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    SpeedSliderLabel.Text = "⚙️ Tốc độ bay hiện tại: " .. flySpeed
end)

IncreaseSpeedBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    SpeedSliderLabel.Text = "⚙️ Tốc độ bay hiện tại: " .. flySpeed
end)

SpeedSliderLabel.Text = "⚙️ Tốc độ bay hiện tại: " .. flySpeed

-- ==================== RELOAD SCRIPT ====================
ReloadScriptBtn.MouseButton1Click:Connect(function()
    ReloadScriptBtn.Text = "⏳ ĐANG TẢI..."
    ReloadScriptBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    
    if isFlying then
        isFlying = false
        stopFlying()
    end
    
    task.wait(1)
    ScreenGui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanhlord/roloc/main/c418.lua"))()
end)

-- ==================== NÚT ẨN MENU ====================
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.02, 0, 0.02, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedIcon.TextColor3 = Color3.fromRGB(100, 200, 255)
MinimizedIcon.TextSize = 24
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.Text = "VNA"
MinimizedIcon.BorderSizePixel = 0
MinimizedIcon.Visible = false

local CornerIcon = Instance.new("UICorner")
CornerIcon.CornerRadius = UDim.new(0, 8)
CornerIcon.Parent = MinimizedIcon

HideButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    MinimizedIcon.Visible = not isMenuVisible
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    isMenuVisible = true
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
end)

-- ==================== NÚT ĐÓNG MENU ====================
CloseButton.MouseButton1Click:Connect(function()
    if isFlying then
        isFlying = false
        stopFlying()
    end
    ScreenGui:Destroy()
end)

-- ==================== MẬT ĐỊNH HIỂN THỊ TRANG ĐẦU ====================
showPage("Speed")