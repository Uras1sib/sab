-- // GUI OLUŞTURMA \\ --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("HassasLagGui") then
    CoreGui.HassasLagGui:Destroy()
end

local HassasLagGui = Instance.new("ScreenGui")
HassasLagGui.Name = "HassasLagGui"
HassasLagGui.Parent = CoreGui
HassasLagGui.ResetOnSpawn = false

-- Ana Panel
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 200)
MainFrame.Position = UDim2.new(0.5, -135, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = HassasLagGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ UNLIMITED FPS DESTROYER ⚡"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Durum Yazısı
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Sistem Durumu: BEKLEMEDE"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame

-- Seviye Düşürme Butonu (-)
local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 50, 0, 35)
MinusBtn.Position = UDim2.new(0.2, -25, 0, 75)
MinusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
MinusBtn.TextSize = 22
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = MainFrame
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

-- DEĞER YAZMA KUTUSU (TextBox)
local LevelInput = Instance.new("TextBox")
LevelInput.Size = UDim2.new(0, 80, 0, 35)
LevelInput.Position = UDim2.new(0.5, -40, 0, 75)
LevelInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LevelInput.BorderSizePixel = 0
LevelInput.Text = "5"
LevelInput.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelInput.TextSize = 16
LevelInput.Font = Enum.Font.GothamBold
LevelInput.PlaceholderText = "Seviye"
LevelInput.ClearTextOnFocus = false
LevelInput.Parent = MainFrame
Instance.new("UICorner", LevelInput).CornerRadius = UDim.new(0, 6)

-- Seviye Arttırma Butonu (+)
local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 50, 0, 35)
PlusBtn.Position = UDim2.new(0.8, -25, 0, 75)
PlusBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
PlusBtn.TextSize = 22
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = MainFrame
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

-- AÇ / KAPAT BUTONU
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 220, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -110, 0, 130)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
ToggleBtn.Text = "SİSTEMİ TETİKLE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- // MOTOR MANTIĞI \\ --
local Active = false
local CurrentLevel = 5
local TrashFolder = workspace:FindFirstChild("GodModeLag") or Instance.new("Folder", workspace)
TrashFolder.Name = "GodModeLag"

local function updateUI()
    local stateText = Active and "YOK EDİLİYOR" or "BEKLEMEDE"
    StatusLabel.Text = "Sistem Durumu: " .. stateText
    LevelInput.Text = tostring(CurrentLevel)
    
    if Active then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
        ToggleBtn.Text = "SİSTEMİ DURDUR"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        ToggleBtn.Text = "SİSTEMİ TETİKLE"
    end
end

-- Elinle kutuya sayı yazıp Enter'a basınca tetiklenir
LevelInput.FocusLost:Connect(function(enterPressed)
    local num = tonumber(LevelInput.Text)
    if num then
        CurrentLevel = math.clamp(math.floor(num), 1, 100)
    end
    updateUI()
end)

-- Tek tek düşürme butonu
MinusBtn.MouseButton1Click:Connect(function()
    CurrentLevel = math.max(1, CurrentLevel - 1)
    updateUI()
end)

-- Tek tek arttırma butonu
PlusBtn.MouseButton1Click:Connect(function()
    CurrentLevel = math.min(100, CurrentLevel + 1)
    updateUI()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Active = not Active
    updateUI()
end)

-- Sınır Tanımayan FPS Düşürücü Döngü
task.spawn(function()
    while true do
        if Active then
            local BaseCount = math.floor(3^(CurrentLevel + 2))
            
            -- İşlemci (CPU) Matematiksel Baskı
            if CurrentLevel >= 15 then
                for i = 1, BaseCount * 0.1 do
                    local _ = math.sin(i) * math.cos(i) * math.tan(i) / math.sqrt(i)
                end
            end

            -- Ekran Kartı (GPU) Render Baskısı
            for i = 1, BaseCount do
                local part = Instance.new("Part")
                part.Size = Vector3.new(2, 2, 2)
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    part.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-15, 15), math.random(-5, 15), math.random(-15, 15))
                else
                    part.Position = Vector3.new(0, 100, 0)
                end
                
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromHSV(math.random(), 1, 1)
                part.CastShadow = true
                part.CanCollide = false
                part.Anchored = true
                part.Parent = TrashFolder
                
                if CurrentLevel >= 30 and i % 5 == 0 then
                    local light = Instance.new("PointLight")
                    light.Range = 20
                    light.Brightness = 10
                    light.Shadows = true
                    light.Parent = part
                end
            end
            
            if CurrentLevel >= 10 then
                RunService.RenderStepped:Wait()
            else
                task.wait(0.01)
            end
            
            if CurrentLevel < 40 then
                TrashFolder:ClearAllChildren()
            else
                if math.random(1, 5) == 1 then
                    TrashFolder:ClearAllChildren()
                end
            end
        else
            TrashFolder:ClearAllChildren()
            task.wait(0.1)
        end
    end
end)

updateUI()
