local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // AYARLAR
local AimEnabled = false
local TeamCheck = true
local AimPart = "Head"
local ToggleKey = Enum.KeyCode.T

-- // BEYAZ LİSTE (Buradaki isimlere kilitlenmez)
local Whitelist = {
    "uraskral7", -- Arkadaşının tam kullanıcı adını buraya yaz
    "0607enes",
    LocalPlayer.Name -- Kendini otomatik ekler
}

-- // GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "AimControlGui"
ScreenGui.Parent = game:GetService("CoreGui") -- Resetlendiğinde gitmemesi için

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Position = UDim2.new(0, 50, 0, 50)
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Aim: KAPALI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Draggable = true -- Butonu ekranda istediğin yere çekebilirsin

-- // FONKSİYONLAR

local function isWhitelisted(player)
    for _, name in pairs(Whitelist) do
        if player.Name == name then
            return true
        end
    end
    return false
end

local function toggleAim()
    AimEnabled = not AimEnabled
    if AimEnabled then
        ToggleButton.Text = "Aim: ACIK"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleButton.Text = "Aim: KAPALI"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        -- Whitelist ve mesafe kontrolü
        if player ~= LocalPlayer and not isWhitelisted(player) and player.Character and player.Character:FindFirstChild(AimPart) then
            if TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local distance = (player.Character[AimPart].Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = player.Character[AimPart]
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- // EVENTLER

-- GUI Buton Tıklama
ToggleButton.MouseButton1Click:Connect(toggleAim)

-- T Tuşu Basımı
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == ToggleKey then
        toggleAim()
    end
end)

-- Ana Döngü
RunService.RenderStepped:Connect(function()
    if AimEnabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
