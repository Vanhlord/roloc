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

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 250, 0, 280)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0

-- Thêm UICorner để bo tròn góc
local CornerMain = Instance.new("UICorner")
CornerMain.CornerRadius = UDim.new(0, 8)
CornerMain.Parent = MainFrame

-- ==================== TITLE BAR ====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0

local CornerTitle = Instance.new("UICorner")
CornerTitle.CornerRadius = UDim.new(0, 8)
CornerTitle.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚙️ MENU"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold

-- Nút ẩn menu (O)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Parent = TitleBar
HideButton.Size = UDim2.new(0, 32, 0, 32)
HideButton.Position = UDim2.new(1, -68, 0.5, -16)
HideButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 14
HideButton.Font = Enum.Font.GothamBold
HideButton.Text = "◯"
HideButton.BorderSizePixel = 0

local CornerHide = Instance.new("UICorner")
CornerHide.CornerRadius = UDim.new(0, 5)
CornerHide.Parent = HideButton

-- Nút đóng menu (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -32, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.BorderSizePixel = 0

local CornerClose = Instance.new("UICorner")
CornerClose.CornerRadius = UDim.new(0, 5)
CornerClose.Parent = CloseButton

-- ==================== CONTENT FRAME ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0

-- Thêm UIListLayout để sắp xếp nút tự động
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ContentFrame
ListLayout.Padding = UDim.new(0, 10)
ListLayout.FillDirection = Enum.FillDirection.Vertical
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Padding
local Padding = Instance.new("UIPadding")
Padding.Parent = ContentFrame
Padding.PaddingLeft = UDim.new(0, 15)
Padding.PaddingRight = UDim.new(0, 15)
Padding.PaddingTop = UDim.new(0, 15)
Padding.PaddingBottom = UDim.new(0, 15)

-- ==================== HÀM TẠO NÚT ====================
local function createButton(name, text)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Parent = ContentFrame
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    return Button
end

-- ==================== NÚT CHỨC NĂNG ====================
local SpeedButton = createButton("SpeedButton", "▶ Chạy Nhanh (OFF)")
local FlyButton = createButton("FlyButton", "✈ Bay (OFF)")

-- ==================== HÀM XỬ LÝ CHẠY NHANH ====================
SpeedButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        isSpeedOn = not isSpeedOn
        if isSpeedOn then
            SpeedButton.Text = "▶ Chạy Nhanh (ON)"
            SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            character.Humanoid.WalkSpeed = 32
        else
            SpeedButton.Text = "▶ Chạy Nhanh (OFF)"
            SpeedButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
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
    
    -- Tạo BodyVelocity để bay
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart
    
    local currentVelocity = Vector3.new(0, 0, 0)
    
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

FlyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        FlyButton.Text = "✈ Bay (ON)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        startFlying()
    else
        FlyButton.Text = "✈ Bay (OFF)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        stopFlying()
    end
end)

-- ==================== NÚT ẨN MENU ====================
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.Parent = ScreenGui
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.02, 0, 0.02, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
MinimizedIcon.TextSize = 24
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.Text = "⚙️"
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

-- ==================== XỬ LÝ KHOẢNG TRẮNG GIỮA NÚT ====================
local spacer = Instance.new("Frame")
spacer.Name = "Spacer"
spacer.Parent = ContentFrame
spacer.Size = UDim2.new(1, 0, 0, 10)
spacer.BackgroundTransparency = 1
spacer.BorderSizePixel = 0