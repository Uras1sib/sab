--// MM2 Role-Based ESP + Manual Chat Info (Button & J Key)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Temizlik
if CoreGui:FindFirstChild("MM2_Nexus_ESP") then CoreGui.MM2_Nexus_ESP:Destroy() end

_G.ESP_Enabled = true

--// Renk Ayarları
local Colors = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 255, 0),
    Innocent = Color3.fromRGB(0, 162, 255),
    Outline = Color3.fromRGB(255, 255, 255)
}

--// UI Oluşturma
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MM2_Nexus_ESP"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 130) -- Boyutu biraz büyüttüm
Main.Position = UDim2.new(0.1, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- ESP Toggle Butonu
local Status = Instance.new("TextButton", Main)
Status.Size = UDim2.new(0.8, 0, 0, 35)
Status.Position = UDim2.new(0.1, 0, 0.15, 0)
Status.Text = "ESP: ON (Y)"
Status.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Status.TextColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", Status)

-- Info Butonu (Yeni)
local InfoBtn = Instance.new("TextButton", Main)
InfoBtn.Size = UDim2.new(0.8, 0, 0, 35)
InfoBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
InfoBtn.Text = "SAY INFO (J)"
InfoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", InfoBtn)

--// Rol Bulma Fonksiyonu
local function GetPlayerRole(player)
    if not player or not player.Parent then return "Innocent" end
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if (character and character:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    elseif (character and character:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

--// Karakterin ağzından chate yazar
local function SendChatMessage(text)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then channel:SendAsync(text) end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
            chatEvent.SayMessageRequest:FireServer(text, "All")
        end
    end
end

--// Rolleri Duyurma Fonksiyonu
local function AnnounceRoles()
    local mName = "None"
    local sName = "None"

    for _, p in pairs(Players:GetPlayers()) do
        local role = GetPlayerRole(p)
        if role == "Murderer" then
            mName = p.Name
        elseif role == "Sheriff" then
            sName = p.Name
        end
    end

    local finalMessage = string.format("murderer: %s | sheriff: %s", mName, sName)
    SendChatMessage(finalMessage)
end

--// ESP Güncelleme
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("NexusHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "NexusHighlight"
                highlight.Parent = player.Character
            end
            
            local role = GetPlayerRole(player)
            highlight.Enabled = _G.ESP_Enabled
            highlight.FillColor = Colors[role]
            highlight.OutlineColor = Colors.Outline
            highlight.FillTransparency = 0.4
        end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.ESP_Enabled then UpdateESP() end
end)

--// ESP Aç/Kapat Mantığı
local function ToggleESP()
    _G.ESP_Enabled = not _G.ESP_Enabled
    Status.Text = _G.ESP_Enabled and "ESP: ON (Y)" or "ESP: OFF (Y)"
    Status.TextColor3 = _G.ESP_Enabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
    
    if not _G.ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("NexusHighlight") then
                p.Character.NexusHighlight.Enabled = false
            end
        end
    end
end

--// Tıklama ve Tuş Eventleri
Status.MouseButton1Click:Connect(ToggleESP)
InfoBtn.MouseButton1Click:Connect(AnnounceRoles)

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Y then
        ToggleESP()
    elseif i.KeyCode == Enum.KeyCode.J then
        AnnounceRoles()
    end
end)
