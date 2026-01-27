local _G = _G or {}
_G.TsunamiEngelleyici = true
local wavesFolder = game.Workspace:WaitForChild("Waves")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- GUI Oluşturma
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UrasLTMGui"
screenGui.Parent = game.CoreGui

local mainButton = Instance.new("TextButton")
mainButton.Name = "ToggleButton"
mainButton.Parent = screenGui
mainButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
mainButton.Position = UDim2.new(0.85, 0, 0.4, 0)
mainButton.Size = UDim2.new(0, 160, 0, 60)
mainButton.Font = Enum.Font.GothamBold
mainButton.Text = "LTM SCRIPT\nBy Uras: ON"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 14
mainButton.AutoButtonColor = false -- Kendi animasyonumuzu yapacağız
mainButton.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainButton

-- Yumuşak Hareket/Renk Değişimi Fonksiyonu (Tween)
local function playTween(obj, properties)
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tweenService:Create(obj, info, properties):Play()
end

-- Hover (Üzerine Gelme) Animasyonları
mainButton.MouseEnter:Connect(function()
    playTween(mainButton, {Size = UDim2.new(0, 170, 0, 70), BackgroundTransparency = 0.2})
end)

mainButton.MouseLeave:Connect(function()
    playTween(mainButton, {Size = UDim2.new(0, 160, 0, 60), BackgroundTransparency = 0})
end)

-- Tıklama Fonksiyonu ve Animasyonu
mainButton.MouseButton1Click:Connect(function()
    -- Tıklama efekti (Küçül-Büyü)
    mainButton.Size = UDim2.new(0, 140, 0, 50)
    playTween(mainButton, {Size = UDim2.new(0, 170, 0, 70)})
    
    _G.TsunamiEngelleyici = not _G.TsunamiEngelleyici
    
    if _G.TsunamiEngelleyici then
        mainButton.Text = "LTM SCRIPT\nBy Uras: ON"
        playTween(mainButton, {BackgroundColor3 = Color3.fromRGB(0, 170, 127)})
    else
        mainButton.Text = "LTM SCRIPT\nBy Uras: OFF"
        playTween(mainButton, {BackgroundColor3 = Color3.fromRGB(170, 0, 0)})
    end
end)

-- Ana Döngü (Tsunami Yok Edici)
runService.Heartbeat:Connect(function()
    if _G.TsunamiEngelleyici == true then
        for _, wave in pairs(wavesFolder:GetChildren()) do
            local main = wave:FindFirstChild("Main", true)
            if main then
                main:Destroy()
            end
        end
    end
end)

print("Animasyonlu LTM SCRIPT By Uras Hazır!")
