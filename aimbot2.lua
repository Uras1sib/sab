local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // AYARLAR
local AimEnabled = false
local AimPart = "Head"
local ToggleKey = Enum.KeyCode.T

-- Kalıcı olarak etkilenmeyecek ve listede gözükmeyecek kişi
local PermanentSafe = "uraskral7" 

-- Dinamik Whitelist (Tıklanarak eklenenler)
local WhitelistedPlayers = {}

-- // GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusAimPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AIM PANEL & WHITELIST"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
ToggleBtn.Text = "Aim: KAPALI (T)"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = MainFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame

-- // FONKSİYONLAR

local function toggleAim()
    AimEnabled = not AimEnabled
    ToggleBtn.Text = AimEnabled and "Aim: ACIK (T)" or "Aim: KAPALI (T)"
    ToggleBtn.BackgroundColor3 = AimEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end

local function updateList()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in pairs(Players:GetPlayers()) do
        -- Kendini ve kalıcı güvenli kişiyi listeye ekleme
        if player == LocalPlayer or player.Name == PermanentSafe then continue end
        
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(1, 0, 0, 25)
        pBtn.Text = player.Name
        pBtn.Parent = PlayerListFrame
        
        if WhitelistedPlayers[player.Name] then
            pBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        else
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        pBtn.MouseButton1Click:Connect(function()
            if WhitelistedPlayers[player.Name] then
                WhitelistedPlayers[player.Name] = nil
                pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            else
                WhitelistedPlayers[player.Name] = true
                pBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
        end)
    end
end

local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        -- Filtre: Kendin değilse, Kalıcı Güvenli değilse ve Listede seçili değilse
        if p ~= LocalPlayer and p.Name ~= PermanentSafe and not WhitelistedPlayers[p.Name] and p.Character and p.Character:FindFirstChild(AimPart) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local d = (p.Character[AimPart].Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    closest = p.Character[AimPart]
                    dist = d
                end
            end
        end
    end
    return closest
end

-- // EVENTLER
ToggleBtn.MouseButton1Click:Connect(toggleAim)
UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == ToggleKey then toggleAim() end end)
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

RunService.RenderStepped:Connect(function()
    if AimEnabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
