-- Thêm cái này vào trong chỗ Đại ca tạo nút
local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = MainFrame -- Thay bằng khung menu của Đại ca
SpeedButton.Size = UDim2.new(0, 100, 0, 30)
SpeedButton.Position = UDim2.new(0.5, -50, 0.5, 0) -- Chỉnh vị trí tùy ý Đại ca
SpeedButton.Text = "Chạy Nhanh (ON)"

-- Biến kiểm tra
local isSpeedOn = false

SpeedButton.MouseButton1Click:Connect(function()
    isSpeedOn = not isSpeedOn
    
    if isSpeedOn then
        SpeedButton.Text = "Chạy Nhanh (OFF)"
        -- Cho nhân vật chạy nhanh gấp 2 lần bình thường
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
    else
        SpeedButton.Text = "Chạy Nhanh (ON)"
        -- Trả về tốc độ mặc định
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)