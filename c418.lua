-- Tạo cái GUI chứa nút
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyMenu"
ScreenGui.Parent = game.CoreGui -- Cái này bắt buộc để nó hiện trong game

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Tạo nút Speed
local SpeedButton = Instance.new("TextButton")
SpeedButton.Parent = MainFrame
SpeedButton.Size = UDim2.new(0, 160, 0, 40)
SpeedButton.Position = UDim2.new(0.5, -80, 0.5, -20)
SpeedButton.Text = "Chạy Nhanh (ON)"

-- Code xử lý chạy nhanh
local isSpeedOn = false
SpeedButton.MouseButton1Click:Connect(function()
    isSpeedOn = not isSpeedOn
    if isSpeedOn then
        SpeedButton.Text = "Chạy Nhanh (OFF)"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
    else
        SpeedButton.Text = "Chạy Nhanh (ON)"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)