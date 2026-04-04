-- Steal a Brainrot: Optimized God Mode (Draggable & Clickable)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local godModeActive = false

-- 1. UI OLUŞTURMA
local sg = Instance.new("ScreenGui")
sg.Name = "MiniGodModeGui"
sg.ResetOnSpawn = false 
sg.Parent = player.PlayerGui

local mainBtn = Instance.new("TextButton")
mainBtn.Name = "ToggleButton"
mainBtn.Parent = sg
mainBtn.Size = UDim2.new(0, 120, 0, 35) -- Daha küçük boyut
mainBtn.Position = UDim2.new(0.5, -60, 0.1, 0)
mainBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
mainBtn.BorderSizePixel = 0
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 14
mainBtn.TextColor3 = Color3.new(1, 1, 1)
mainBtn.Text = "GOD: KAPALI"
mainBtn.AutoButtonColor = true

-- Yuvarlatılmış köşeler
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainBtn

-- 2. SÜRÜKLENEBİLİR YAPMA ÖZELLİĞİ
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 3. ÖLÜMSÜZLÜK MANTIĞI
local char, hum

local function updateCharacter(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")

    hum.HealthChanged:Connect(function()
        if godModeActive and hum then
            hum.Health = hum.MaxHealth
        end
    end)
end

if player.Character then updateCharacter(player.Character) end
player.CharacterAdded:Connect(updateCharacter)

runService.Stepped:Connect(function()
    if godModeActive and char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanTouch = false 
            end
        end
    end
end)

-- 4. AÇMA / KAPATMA FONKSİYONU
local function toggleGodMode()
    godModeActive = not godModeActive
    
    if godModeActive then
        mainBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        mainBtn.Text = "GOD: AÇIK"
        print("GOD MODE: AKTIF")
    else
        mainBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        mainBtn.Text = "GOD: KAPALI"
        print("GOD MODE: KAPALI")
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanTouch = true end
            end
        end
    end
end

-- Tıklama ve Tuş (Z) Dinleyicileri
mainBtn.MouseButton1Click:Connect(toggleGodMode)

userInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Z then
        toggleGodMode()
    end
end)
