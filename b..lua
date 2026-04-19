--[[
    VANH MENU PRO - LUAU CLIENT SCRIPT
    BẢN TÁCH RADAR: RADAR ĐỘC LẬP + KÉO THẢ TỰ DO + CHỈNH SIZE
    Dành riêng cho Đại ca Vanh :3
--]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanhMenuPro_IndependentRadar"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Cấu hình màu sắc
local THEME_COLOR = Color3.fromRGB(0, 200, 255)
local BG_COLOR = Color3.fromRGB(25, 25, 25)
local SECONDARY_BG = Color3.fromRGB(40, 40, 40)

-- Biến trạng thái chức năng
local SpeedEnabled, SpeedValue = false, 100 
local FlyEnabled, FlyValue = false, 50
local BodyGyro, BodyVelocity
local BrightEnabled, BrightValue = false, 5 -- Giá trị độ sáng tùy chỉnh
local OriginalBrightness, OriginalClockTime = Lighting.Brightness, Lighting.ClockTime
local OriginalAmbient = Lighting.OutdoorAmbient

-- Biến Radar
local RadarDistance = 500
local RadarSizeValue = 160 -- Kích thước mặc định

-- Hàm hỗ trợ kéo thả chung
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
end

-- ==========================================
-- MAIN MENU FRAME
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = THEME_COLOR

-- Header Menu
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header)
Title.Text = "VANH MENU PRO"; Title.Size = UDim2.new(1, -90, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

makeDraggable(MainFrame, Header)

-- Nút Thu nhỏ / Tắt
local function createTopBtn(text, color, pos)
    local btn = Instance.new("TextButton", Header)
    btn.Text = text; btn.Size = UDim2.new(0, 28, 0, 28); btn.Position = pos
    btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end
local MinBtn = createTopBtn("O", Color3.fromRGB(255, 160, 0), UDim2.new(1, -70, 0, 6))
local CloseBtn = createTopBtn("X", Color3.fromRGB(255, 70, 70), UDim2.new(1, -35, 0, 6))

-- Scroll Container
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -10, 1, -50); ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = THEME_COLOR
ScrollFrame.BorderSizePixel = 0
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout", ScrollFrame)
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding", ScrollFrame)
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 10)

-- Helper functions tạo UI hàng
local function createFeatureRow(name, layoutOrder)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 40); row.BackgroundColor3 = SECONDARY_BG; row.LayoutOrder = layoutOrder
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", row)
    label.Text = name; label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1, 1, 1); label.Font = Enum.Font.GothamMedium; label.TextSize = 14; label.TextXAlignment = Enum.TextXAlignment.Left
    local toggleBase = Instance.new("TextButton", row)
    toggleBase.Text = ""; toggleBase.Size = UDim2.new(0, 45, 0, 22); toggleBase.Position = UDim2.new(1, -55, 0.5, -11); toggleBase.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", toggleBase).CornerRadius = UDim.new(1, 0)
    local toggleDot = Instance.new("Frame", toggleBase)
    toggleDot.Size = UDim2.new(0, 18, 0, 18); toggleDot.Position = UDim2.new(0, 2, 0.5, -9); toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)
    return row, toggleBase, toggleDot
end

local function createControlRow(layoutOrder)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.95, 0, 0, 0); row.BackgroundColor3 = SECONDARY_BG; row.LayoutOrder = layoutOrder; row.Visible = false; row.ClipsDescendants = true
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local valLabel = Instance.new("TextLabel", row)
    valLabel.Size = UDim2.new(1, 0, 0, 45); valLabel.BackgroundTransparency = 1; valLabel.TextColor3 = Color3.new(1, 1, 1); valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 13
    local function createAdjustBtn(text, pos)
        local btn = Instance.new("TextButton", row)
        btn.Text = text; btn.Size = UDim2.new(0, 30, 0, 30); btn.Position = pos; btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.TextColor3 = THEME_COLOR; btn.Font = Enum.Font.GothamBold; btn.TextSize = 18; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end
    local minus = createAdjustBtn("-", UDim2.new(0, 10, 0, 7)); local plus = createAdjustBtn("+", UDim2.new(1, -40, 0, 7))
    return row, valLabel, minus, plus
end
-- ----------------------------------------------------------------------------------
--[[ 
    PHẦN CODE NÚT REJOIN TÁCH RỜI
    Đại ca chỉ cần dán đoạn này vào sau khi đã tạo ScrollFrame nhé!
--]]

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Tạo UI cho nút Rejoin (Dáng chuẩn, màu xinh)
local RejoinRow = Instance.new("Frame")
RejoinRow.Name = "RejoinRow"
RejoinRow.Size = UDim2.new(0.95, 0, 0, 40)
RejoinRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Màu tiệp với menu của Đại ca
RejoinRow.Parent = ScrollFrame -- Đảm bảo biến này trùng tên với ScrollFrame của Đại ca

local RejoinCorner = Instance.new("UICorner", RejoinRow)
RejoinCorner.CornerRadius = UDim.new(0, 8)

local RejoinBtn = Instance.new("TextButton", RejoinRow)
RejoinBtn.Size = UDim2.new(1, 0, 1, 0)
RejoinBtn.BackgroundTransparency = 1
RejoinBtn.Text = "Vào lại Server (Rejoin)"
RejoinBtn.TextColor3 = Color3.fromRGB(0, 200, 255) -- Màu xanh Neon cưng xỉu
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 14

-- 2. Chức năng Rejoin (Bấm phát đi luôn)
RejoinBtn.MouseButton1Click:Connect(function()
    -- Kiểm tra xem server có nhiều người không để chọn cách Teleport chuẩn nhất
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end)

-- ==========================================
-- INDEPENDENT RADAR
-- ==========================================
local RadarMain = Instance.new("Frame", ScreenGui)
RadarMain.Name = "IndependentRadar"
RadarMain.Size = UDim2.new(0, RadarSizeValue, 0, RadarSizeValue)
RadarMain.Position = UDim2.new(1, -200, 0, 50)
RadarMain.BackgroundColor3 = BG_COLOR
RadarMain.Active = true
Instance.new("UICorner", RadarMain).CornerRadius = UDim.new(1, 0)
local RadarStroke = Instance.new("UIStroke", RadarMain); RadarStroke.Color = THEME_COLOR; RadarStroke.Thickness = 2

local RadarHandle = Instance.new("Frame", RadarMain)
RadarHandle.Size = UDim2.new(1, 0, 1, 0); RadarHandle.BackgroundTransparency = 1
makeDraggable(RadarMain, RadarHandle)

local RadarCircle = Instance.new("Frame", RadarMain)
RadarCircle.Size = UDim2.new(0.9, 0, 0.9, 0); RadarCircle.Position = UDim2.new(0.5, 0, 0.5, 0); RadarCircle.AnchorPoint = Vector2.new(0.5, 0.5)
RadarCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", RadarCircle).CornerRadius = UDim.new(1, 0)
RadarCircle.ClipsDescendants = true

local CrossV = Instance.new("Frame", RadarCircle); CrossV.Size = UDim2.new(0, 1, 1, 0); CrossV.Position = UDim2.new(0.5, 0, 0, 0); CrossV.BackgroundColor3 = Color3.fromRGB(60, 60, 60); CrossV.BorderSizePixel = 0
local CrossH = Instance.new("Frame", RadarCircle); CrossH.Size = UDim2.new(1, 0, 0, 1); CrossH.Position = UDim2.new(0, 0, 0.5, 0); CrossH.BackgroundColor3 = Color3.fromRGB(60, 60, 60); CrossH.BorderSizePixel = 0

local DotLayer = Instance.new("Frame", RadarCircle); DotLayer.Size = UDim2.new(1, 0, 1, 0); DotLayer.BackgroundTransparency = 1
local CenterPlayer = Instance.new("TextLabel", DotLayer)
CenterPlayer.Text = "▲"; CenterPlayer.Size = UDim2.new(0, 14, 0, 14); CenterPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterPlayer.AnchorPoint = Vector2.new(0.5, 0.5); CenterPlayer.BackgroundTransparency = 1
CenterPlayer.TextColor3 = THEME_COLOR; CenterPlayer.Font = Enum.Font.GothamBold; CenterPlayer.TextSize = 12

-- ==========================================
-- MENU CONTROLS
-- ==========================================

-- Hàng Radar Config
local RadarRow = Instance.new("Frame", ScrollFrame)
RadarRow.Size = UDim2.new(0.95, 0, 0, 140); RadarRow.BackgroundColor3 = SECONDARY_BG; RadarRow.LayoutOrder = 0
Instance.new("UICorner", RadarRow).CornerRadius = UDim.new(0, 8)

local RadarLabel = Instance.new("TextLabel", RadarRow)
RadarLabel.Text = "Cấu hình Radar"; RadarLabel.Size = UDim2.new(1, 0, 0, 25); RadarLabel.Position = UDim2.new(0, 0, 0, 5)
RadarLabel.BackgroundTransparency = 1; RadarLabel.TextColor3 = Color3.new(1, 1, 1); RadarLabel.Font = Enum.Font.GothamBold; RadarLabel.TextSize = 13
local RadarDistText = Instance.new("TextLabel", RadarRow)
RadarDistText.Text = "Tầm nhìn: 500M"; RadarDistText.Size = UDim2.new(1, 0, 0, 20); RadarDistText.Position = UDim2.new(0, 0, 0, 25)
RadarDistText.BackgroundTransparency = 1; RadarDistText.TextColor3 = THEME_COLOR; RadarDistText.Font = Enum.Font.GothamMedium; RadarDistText.TextSize = 11

local function createRadarBtn(text, pos, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Text = text; btn.Size = UDim2.new(0, 40, 0, 30); btn.Position = pos; btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 18; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end
local ZOut = createRadarBtn("-", UDim2.new(0, 15, 0, 42), RadarRow)
local ZIn = createRadarBtn("+", UDim2.new(1, -55, 0, 42), RadarRow)

ZIn.MouseButton1Click:Connect(function() RadarDistance = math.clamp(RadarDistance + 100, 100, 2000); RadarDistText.Text = "Tầm nhìn: "..RadarDistance.."M" end)
ZOut.MouseButton1Click:Connect(function() RadarDistance = math.clamp(RadarDistance - 100, 100, 2000); RadarDistText.Text = "Tầm nhìn: "..RadarDistance.."M" end)

local SizeLabel = Instance.new("TextLabel", RadarRow)
SizeLabel.Text = "Kích cỡ Radar"; SizeLabel.Size = UDim2.new(1, 0, 0, 25); SizeLabel.Position = UDim2.new(0, 0, 0, 80)
SizeLabel.BackgroundTransparency = 1; SizeLabel.TextColor3 = Color3.new(1, 1, 1); SizeLabel.Font = Enum.Font.GothamBold; SizeLabel.TextSize = 13
local RadarSizeText = Instance.new("TextLabel", RadarRow)
RadarSizeText.Text = "Size: "..RadarSizeValue.."PX"; RadarSizeText.Size = UDim2.new(1, 0, 0, 20); RadarSizeText.Position = UDim2.new(0, 0, 0, 100)
RadarSizeText.BackgroundTransparency = 1; RadarSizeText.TextColor3 = THEME_COLOR; RadarSizeText.Font = Enum.Font.GothamMedium; RadarSizeText.TextSize = 11

local SOut = createRadarBtn("-", UDim2.new(0, 15, 0, 100), RadarRow)
local SIn = createRadarBtn("+", UDim2.new(1, -55, 0, 100), RadarRow)

local function updateRadarSize(newSize)
    RadarSizeValue = newSize
    RadarMain.Size = UDim2.new(0, RadarSizeValue, 0, RadarSizeValue)
    RadarSizeText.Text = "Size: "..RadarSizeValue.."PX"
end
SIn.MouseButton1Click:Connect(function() updateRadarSize(math.clamp(RadarSizeValue + 20, 80, 300)) end)
SOut.MouseButton1Click:Connect(function() updateRadarSize(math.clamp(RadarSizeValue - 20, 80, 300)) end)

-- Feature Rows
local SpeedRow, SpeedToggle, SpeedDot = createFeatureRow("Chạy Nhanh", 1); SpeedRow.Parent = ScrollFrame
local SpeedControl, SpeedValLabel, SpeedMinus, SpeedPlus = createControlRow(2); SpeedControl.Parent = ScrollFrame
local FlyRow, FlyToggle, FlyDot = createFeatureRow("Bay (Fly)", 3); FlyRow.Parent = ScrollFrame
local FlyControl, FlyValLabel, FlyMinus, FlyPlus = createControlRow(4); FlyControl.Parent = ScrollFrame
local BrightRow, BrightToggle, BrightDot = createFeatureRow("Nhìn Đêm", 5); BrightRow.Parent = ScrollFrame
local BrightControl, BrightValLabel, BrightMinus, BrightPlus = createControlRow(6); BrightControl.Parent = ScrollFrame

-- LOGIC CƠ CHẾ CHUNG
local function updateToggleUI(enabled, dot, base, control)
    local targetPos = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    local targetColor = enabled and THEME_COLOR or Color3.fromRGB(60, 60, 60)
    TweenService:Create(dot, TweenInfo.new(0.3), {Position = targetPos}):Play()
    TweenService:Create(base, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    if enabled then
        control.Visible = true; TweenService:Create(control, TweenInfo.new(0.4), {Size = UDim2.new(0.95, 0, 0, 45)}):Play()
    else
        local t = TweenService:Create(control, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 0)}); t:Play()
        t.Completed:Connect(function() if not enabled then control.Visible = false end end)
    end
end

-- Speed logic
task.spawn(function()
    while true do task.wait() if SpeedEnabled and not FlyEnabled then pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue end end) end end
end)
SpeedToggle.MouseButton1Click:Connect(function() SpeedEnabled = not SpeedEnabled; updateToggleUI(SpeedEnabled, SpeedDot, SpeedToggle, SpeedControl); if not SpeedEnabled then pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end end)
SpeedPlus.MouseButton1Click:Connect(function() SpeedValue = math.clamp(SpeedValue + 10, 0, 1000); SpeedValLabel.Text = "Tốc độ: "..SpeedValue end)
SpeedMinus.MouseButton1Click:Connect(function() SpeedValue = math.clamp(SpeedValue - 10, 0, 1000); SpeedValLabel.Text = "Tốc độ: "..SpeedValue end)
SpeedValLabel.Text = "Tốc độ: "..SpeedValue

-- Fly logic
local function stopFly() FlyEnabled = false; if BodyGyro then BodyGyro:Destroy() end; if BodyVelocity then BodyVelocity:Destroy() end; pcall(function() LocalPlayer.Character.Humanoid.PlatformStand = false end) end
FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled; updateToggleUI(FlyEnabled, FlyDot, FlyToggle, FlyControl)
    if FlyEnabled then
        local HRP = LocalPlayer.Character.HumanoidRootPart; local Hum = LocalPlayer.Character.Humanoid
        BodyGyro = Instance.new("BodyGyro", HRP); BodyGyro.P = 9e4; BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9); BodyGyro.cframe = HRP.CFrame
        BodyVelocity = Instance.new("BodyVelocity", HRP); BodyVelocity.velocity = Vector3.new(0,0,0); BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9); Hum.PlatformStand = true
        task.spawn(function()
            while FlyEnabled do RunService.RenderStepped:Wait(); local Camera = workspace.CurrentCamera
                if Hum.MoveDirection.Magnitude > 0 then
                    local camLook = Camera.CFrame.LookVector; local camRight = Camera.CFrame.RightVector
                    local moveDir = (camLook * Hum.MoveDirection:Dot(Vector3.new(camLook.X, 0, camLook.Z).Unit)) + (camRight * Hum.MoveDirection:Dot(Vector3.new(camRight.X, 0, camRight.Z).Unit))
                    BodyVelocity.velocity = moveDir * FlyValue
                else BodyVelocity.velocity = Vector3.new(0,0,0) end
                BodyGyro.cframe = Camera.CFrame
            end; stopFly()
        end)
    else stopFly() end
end)
FlyPlus.MouseButton1Click:Connect(function() FlyValue = math.clamp(FlyValue + 10, 0, 500); FlyValLabel.Text = "Bay: "..FlyValue end)
FlyMinus.MouseButton1Click:Connect(function() FlyValue = math.clamp(FlyValue - 10, 0, 500); FlyValLabel.Text = "Bay: "..FlyValue end)
FlyValLabel.Text = "Bay: "..FlyValue

-- NightVision logic (Improved)
BrightToggle.MouseButton1Click:Connect(function() 
    BrightEnabled = not BrightEnabled; 
    updateToggleUI(BrightEnabled, BrightDot, BrightToggle, BrightControl); 
    if not BrightEnabled then 
        Lighting.Brightness = OriginalBrightness; 
        Lighting.ClockTime = OriginalClockTime; 
        Lighting.OutdoorAmbient = OriginalAmbient;
        Lighting.ExposureCompensation = 0
    end 
end)
BrightPlus.MouseButton1Click:Connect(function() 
    BrightValue = math.clamp(BrightValue + 1, 0, 20); 
    BrightValLabel.Text = "Độ sáng: "..BrightValue 
end)
BrightMinus.MouseButton1Click:Connect(function() 
    BrightValue = math.clamp(BrightValue - 1, 0, 20); 
    BrightValLabel.Text = "Độ sáng: "..BrightValue 
end)
BrightValLabel.Text = "Độ sáng: "..BrightValue

-- RENDER LOOP
local PlayerDots = {}
Players.PlayerRemoving:Connect(function(player) if PlayerDots[player] then PlayerDots[player]:Destroy(); PlayerDots[player] = nil end end)

RunService.RenderStepped:Connect(function()
    -- Cập nhật độ sáng dựa trên BrightValue
    if BrightEnabled then 
        Lighting.Brightness = BrightValue -- Trực tiếp sử dụng giá trị người dùng chọn
        Lighting.ClockTime = 14
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        -- Tỷ lệ Exposure theo BrightValue để tăng hiệu ứng
        Lighting.ExposureCompensation = math.clamp(BrightValue / 2, 0, 5) 
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHRP = LocalPlayer.Character.HumanoidRootPart; local camCFrame = workspace.CurrentCamera.CFrame
    local camLookXZ = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z).Unit
    local camRightXZ = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z).Unit
    local charLookXZ = Vector3.new(myHRP.CFrame.LookVector.X, 0, myHRP.CFrame.LookVector.Z).Unit
    CenterPlayer.Rotation = math.deg(math.atan2(camRightXZ:Dot(charLookXZ), camLookXZ:Dot(charLookXZ)))

    local mapRadius = (RadarMain.AbsoluteSize.X * 0.9) / 2
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not PlayerDots[player] then
                local dot = Instance.new("Frame", DotLayer); dot.Size = UDim2.new(0, 6, 0, 6); dot.AnchorPoint = Vector2.new(0.5, 0.5)
                dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50); Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
                PlayerDots[player] = dot
            end
            local dot = PlayerDots[player]
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local offset = player.Character.HumanoidRootPart.Position - myHRP.Position; local dist = offset.Magnitude
                if dist <= RadarDistance then
                    dot.Visible = true; local mapX = offset:Dot(camRightXZ); local mapY = -offset:Dot(camLookXZ)
                    local scale = mapRadius / RadarDistance; dot.Position = UDim2.new(0.5, mapX * scale, 0.5, mapY * scale)
                else dot.Visible = false end
            else dot.Visible = false end
        end
    end
end)

local MiniIcon = Instance.new("TextButton", ScreenGui)
MiniIcon.Size = UDim2.new(0, 50, 0, 50); MiniIcon.Position = UDim2.new(0, 20, 0, 20); MiniIcon.BackgroundColor3 = THEME_COLOR
MiniIcon.Text = "V"; MiniIcon.TextColor3 = Color3.new(1,1,1); MiniIcon.Font = Enum.Font.GothamBold; MiniIcon.TextSize = 25; MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1,0)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniIcon.Visible = true end)
MiniIcon.MouseButton1Click:Connect(function() MiniIcon.Visible = false; MainFrame.Visible = true end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

--[[ 
    PHẦN CODE NÚT TELE & BÁM NGƯỜI GẦN NHẤT
    Đại ca dán vào cuối file, dưới nút Rejoin nhé!
--]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TeleNearestEnabled = false
local TargetPlayer = nil
local TeleConnection = nil

-- 1. Hàm tìm người chơi gần nhất (Không tính bản thân)
local function getNearestPlayer()
    local nearest = nil
    local minDistance = math.huge
    local myPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not myPart then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myPart.Position).Magnitude
            if dist < minDistance then
                minDistance = dist
                nearest = player
            end
        end
    end
    return nearest
end

-- 2. Tạo UI cho nút Tele
local TeleRow = Instance.new("Frame")
TeleRow.Name = "TeleRow"
TeleRow.Size = UDim2.new(0.95, 0, 0, 40)
TeleRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TeleRow.LayoutOrder = 100 -- Nằm dưới nút Rejoin (99)
TeleRow.Parent = ScrollFrame -- Đảm bảo biến này trùng tên với ScrollFrame của Đại ca

local TeleCorner = Instance.new("UICorner", TeleRow)
TeleCorner.CornerRadius = UDim.new(0, 8)

local TeleBtn = Instance.new("TextButton", TeleRow)
TeleBtn.Size = UDim2.new(1, 0, 1, 0)
TeleBtn.BackgroundTransparency = 1
TeleBtn.Text = "Tele người ở gần: OFF"
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.GothamBold
TeleBtn.TextSize = 14

-- 3. Chức năng Bám Đuôi (Dính như sam)
TeleBtn.MouseButton1Click:Connect(function()
    TeleNearestEnabled = not TeleNearestEnabled
    
    if TeleNearestEnabled then
        TargetPlayer = getNearestPlayer()
        if TargetPlayer then
            TeleBtn.Text = "Đang bám: " .. TargetPlayer.Name
            TeleBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Đổi sang màu đỏ khi đang bám
            
            -- Bắt đầu vòng lặp bám đuôi
            TeleConnection = RunService.Heartbeat:Connect(function()
                if TeleNearestEnabled and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local char = LocalPlayer.Character
                    local targetHRP = TargetPlayer.Character.HumanoidRootPart
                    
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        -- Tính toán vị trí sau lưng 2 mét dựa trên hướng nhìn của mục tiêu
                        local backPos = targetHRP.CFrame * CFrame.new(0, 0, 2)
                        char.HumanoidRootPart.CFrame = backPos
                    end
                else
                    -- Nếu mục tiêu thoát game hoặc chết thì tự tắt
                    TeleNearestEnabled = false
                    if TeleConnection then TeleConnection:Disconnect() end
                    TeleBtn.Text = "Tele người ở gần: OFF"
                    TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end)
        else
            TeleNearestEnabled = false
            TeleBtn.Text = "Không tìm thấy ai!"
            task.wait(1)
            TeleBtn.Text = "Tele người ở gần: OFF"
        end
    else
        -- Tắt bám đuôi
        if TeleConnection then TeleConnection:Disconnect() end
        TeleBtn.Text = "Tele người ở gần: OFF"
        TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

--[[ 
    PHẦN CODE NÚT ESP XUYÊN TƯỜNG (VIỀN TRẮNG)
    Đại ca dán vào cuối file, dưới nút Tele nhé!
--]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPHighlights = {}

-- 1. Hàm cập nhật ESP (Quét và tạo viền)
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if ESPEnabled then
                if not ESPHighlights[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "VanhESP"
                    highlight.FillTransparency = 0.5 -- Độ trong suốt thân
                    highlight.FillColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                    ESPHighlights[player] = highlight
                end
            else
                if ESPHighlights[player] then
                    ESPHighlights[player]:Destroy()
                    ESPHighlights[player] = nil
                end
            end
        end
    end
end

-- 2. Tạo UI cho nút ESP
local ESPRow = Instance.new("Frame")
ESPRow.Name = "ESPRow"
ESPRow.Size = UDim2.new(0.95, 0, 0, 40)
ESPRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPRow.LayoutOrder = 101 -- Nằm dưới nút Tele (100)
ESPRow.Parent = ScrollFrame -- Đảm bảo biến này trùng tên với ScrollFrame của Đại ca

local ESPCorner = Instance.new("UICorner", ESPRow)
ESPCorner.CornerRadius = UDim.new(0, 8)

local ESPBtn = Instance.new("TextButton", ESPRow)
ESPBtn.Size = UDim2.new(1, 0, 1, 0)
ESPBtn.BackgroundTransparency = 1
ESPBtn.Text = "ESP Xuyên Tường: OFF"
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPBtn.Font = Enum.Font.GothamBold
ESPBtn.TextSize = 14

-- 3. Logic bật/tắt ESP
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPBtn.Text = "ESP Xuyên Tường: ON"
        ESPBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        ESPBtn.Text = "ESP Xuyên Tường: OFF"
        ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    updateESP()
end)

-- 4. Vòng lặp Render để giữ ESP luôn hoạt động
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

-- Dọn dẹp khi người chơi khác thoát
Players.PlayerRemoving:Connect(function(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end)

--[[ 
    PHẦN CODE NÚT KHÔNG TRỌNG LỰC THỰC THỤ (Space Physics)
    Đại ca dán vào cuối file, dưới các nút khác nhé!
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ZeroGravEnabled = false
local OriginalGravity = Workspace.Gravity

-- 1. Tạo UI cho nút Không Trọng Lực
local GravRow = Instance.new("Frame")
GravRow.Name = "GravRow"
GravRow.Size = UDim2.new(0.95, 0, 0, 40)
GravRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GravRow.LayoutOrder = 102
GravRow.Parent = ScrollFrame -- Đảm bảo biến này trùng tên với ScrollFrame của Đại ca

local GravCorner = Instance.new("UICorner", GravRow)
GravCorner.CornerRadius = UDim.new(0, 8)

local GravBtn = Instance.new("TextButton", GravRow)
GravBtn.Size = UDim2.new(1, 0, 1, 0)
GravBtn.BackgroundTransparency = 1
GravBtn.Text = "Không Trọng Lực: OFF"
GravBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GravBtn.Font = Enum.Font.GothamBold
GravBtn.TextSize = 14

-- 2. Logic điều khiển Trọng lực và Trạng thái nhân vật
GravBtn.MouseButton1Click:Connect(function()
    ZeroGravEnabled = not ZeroGravEnabled
    
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    
    if ZeroGravEnabled then
        -- Lưu lại trọng lực gốc
        OriginalGravity = Workspace.Gravity
        Workspace.Gravity = 0
        
        -- Làm nhân vật mất thăng bằng để trôi tự do
        if humanoid then
            humanoid.PlatformStand = true -- Tắt cơ chế đứng thẳng, nhân vật sẽ ngã và trôi
        end
        
        GravBtn.Text = "Không Trọng Lực: ON"
        GravBtn.TextColor3 = Color3.fromRGB(255, 160, 0)
    else
        -- Trả lại mọi thứ như cũ
        Workspace.Gravity = OriginalGravity
        
        if humanoid then
            humanoid.PlatformStand = false -- Đứng thẳng lại bình thường
        end
        
        GravBtn.Text = "Không Trọng Lực: OFF"
        GravBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
