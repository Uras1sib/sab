-- Ekran arayüzünü oluştur (Direkt CoreGui'ye atar, ölünce gitmez)
local ScreenGui = Instance.new("ScreenGui")
local SpinButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "HeliSpinGui"

SpinButton.Parent = ScreenGui
SpinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpinButton.Position = UDim2.new(0.1, 0, 0.1, 0) -- Ekranın sol üstü
SpinButton.Size = UDim2.new(0, 150, 0, 50)
SpinButton.Font = Enum.Font.SourceSansBold
SpinButton.Text = "SPIN: KAPALI"
SpinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinButton.TextSize = 18
SpinButton.Draggable = true -- Eski ama executorlarda çalışan sürükleme özelliği
SpinButton.Active = true
SpinButton.Selectable = true

-- Köşeleri yuvarla
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = SpinButton

local spinning = false
local bodyAngularVelocity = nil

SpinButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    spinning = not spinning

    if spinning then
        SpinButton.Text = "SPIN: AÇIK"
        SpinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Kırmızı
        
        -- Eğer önceden kalma varsa temizle
        if rootPart:FindFirstChild("HeliSpin") then rootPart.HeliSpin:Destroy() end
        
        -- Dönüş gücü ekle
        bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.Name = "HeliSpin"
        bodyAngularVelocity.MaxTorque = Vector3.new(0, 1000000, 0) -- Sadece Y ekseni
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 100, 0) -- Hız: 100
        bodyAngularVelocity.Parent = rootPart
    else
        SpinButton.Text = "SPIN: KAPALI"
        SpinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Gri
        
        if rootPart:FindFirstChild("HeliSpin") then
            rootPart.HeliSpin:Destroy()
        end
    end
end)

-- Karakter ölünce spin'i temizleme (Hata vermemesi için)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    spinning = false
    SpinButton.Text = "SPIN: KAPALI"
    SpinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)
