local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- KOORDİNATLAR
local bases = {
    Base1 = Vector3.new(-353, -7, 74),
    Base2 = Vector3.new(-353, -7, 46)
}

-- ANA GUI (ÖLÜNCE GİTMEZ)
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "UrasTpGui"
screenGui.ResetOnSpawn = false

-- ANA PANEL (GİZLİ BAŞLAR)
local main = Instance.new("Frame", screenGui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 180, 0, 150)
main.Position = UDim2.new(0, -190, 0.5, -75) -- Ekranın dışında başlar
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0

-- Köşe Yuvarlatma
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "URAS TP GUI"
title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
local titleCorner = Instance.new("UICorner", title)

-- AÇMA/KAPAMA BUTONU (OK)
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Name = "OpenClose"
toggleBtn.Size = UDim2.new(0, 35, 0, 60)
toggleBtn.Position = UDim2.new(0, 5, 0.5, -30)
toggleBtn.Text = "▶" -- Başlangıç oku
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

local btnCorner = Instance.new("UICorner", toggleBtn)
btnCorner.CornerRadius = UDim.new(0, 8)

-- IŞINLANMA FONKSİYONU
local function teleport(target)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = CFrame.new(bases[target])
    end
end

-- BASE BUTONLARI OLUŞTURMA
local function createBtn(name, text, pos)
    local btn = Instance.new("TextButton", main)
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    
    -- Efekt: Üzerine gelince renk değişsin
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
    
    return btn
end

local btn1 = createBtn("Base1", "BASE 1'E GİT", UDim2.new(0, 10, 0, 50))
local btn2 = createBtn("Base2", "BASE 2'YE GİT", UDim2.new(0, 10, 0, 100))

btn1.MouseButton1Click:Connect(function() teleport("Base1") end)
btn2.MouseButton1Click:Connect(function() teleport("Base2") end)

-- AÇILIŞ/KAPANIŞ ANİMASYONU
local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    local targetPos = isOpen and UDim2.new(0, 45, 0.5, -75) or UDim2.new(0, -190, 0.5, -75)
    local btnPos = isOpen and UDim2.new(0, 230, 0.5, -30) or UDim2.new(0, 5, 0.5, -30)
    
    -- Frame Animasyonu
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
    -- Ok Butonu Animasyonu
    TweenService:Create(toggleBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = btnPos}):Play()
    
    toggleBtn.Text = isOpen and "◀" or "▶"
end)

print("Uras TP Gui başarıyla yüklendi!")
