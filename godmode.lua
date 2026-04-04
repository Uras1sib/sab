-- Steal a Brainrot: Ultimate God Mode & Defense (No Speed Version)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local godModeActive = false

-- 1. UI OLUŞTURMA (Ölünce gitmemesi için ResetOnSpawn = false)
local sg = Instance.new("ScreenGui")
sg.Name = "GodModeGui"
sg.ResetOnSpawn = false 
sg.Parent = player.PlayerGui

local txt = Instance.new("TextLabel", sg)
txt.Size = UDim2.new(0, 200, 0, 40)
txt.Position = UDim2.new(0.5, -100, 0, 50)
txt.Font = Enum.Font.SourceSansBold
txt.TextSize = 20
txt.TextColor3 = Color3.new(1, 1, 1)

-- 2. KARAKTER GÜNCELLEME FONKSİYONU
local char, hum

local function updateCharacter(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")

    -- Can sabitleme bağlantısı
    hum.HealthChanged:Connect(function()
        if godModeActive and hum then
            hum.Health = hum.MaxHealth
        end
    end)
end

if player.Character then updateCharacter(player.Character) end
player.CharacterAdded:Connect(updateCharacter)

-- 3. DOKUNULMAZLIK DÖNGÜSÜ
runService.Stepped:Connect(function()
    if godModeActive and char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanTouch = false 
            end
        end
    end
end)

-- UI Güncelleme (Renk ve Metin)
runService.RenderStepped:Connect(function()
    txt.BackgroundColor3 = godModeActive and Color3.new(0, 0.7, 0) or Color3.new(0.7, 0, 0)
    txt.Text = "GOD MODE: " .. (godModeActive and "AÇIK" or "KAPALI")
end)

-- 4. TUŞ KONTROLÜ (Hız kodları kaldırıldı)
userInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Z then
        godModeActive = not godModeActive
        
        if godModeActive then
            print("GOD MODE: AKTIF")
        else
            print("GOD MODE: KAPALI")
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanTouch = true end
                end
            end
        end
    end
end)
