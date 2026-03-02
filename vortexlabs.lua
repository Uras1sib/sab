--[[
    VORTEX LABS - SECURITY UPDATED v10.1
    Key Source: keysystem.txt
    Discord: https://discord.gg/zS8KXaHtTE
]]

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local VORTEX_DATA = {
    Name = "VORTEX LABS",
    Discord = "https://discord.gg/zS8KXaHtTE",
    -- YENI KEY LINKI BURADA:
    KeyURL = "https://raw.githubusercontent.com/Uras1sib/sab/refs/heads/main/keysystem.txt",
    Modes = {
        LTM = {ID = 85621847059032, Source = "https://raw.githubusercontent.com/Uras1sib/sab/refs/heads/main/ltm2.lua"},
        DUEL = {ID = 99606176102979, Source = "https://api.luarmor.net/files/v4/loaders/e8c2b7bdfd494b913839f58581a203f9.lua"}
    },
    Theme = {
        Main = Color3.fromRGB(10, 10, 14),
        Header = Color3.fromRGB(15, 15, 22),
        Accent = Color3.fromRGB(140, 0, 255)
    }
}

local Screen = Instance.new("ScreenGui")
Screen.Name = "VortexLabs_Secure"
Screen.Parent = (gethui and gethui()) or CoreGui

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0

local function Notify(title, msg, color)
    local n = Instance.new("Frame", Screen)
    n.Size = UDim2.new(0, 280, 0, 80)
    n.Position = UDim2.new(1, 20, 0.85, 0)
    n.BackgroundColor3 = VORTEX_DATA.Theme.Main
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    
    local line = Instance.new("Frame", n)
    line.Size = UDim2.new(0, 4, 1, 0); line.BackgroundColor3 = color or VORTEX_DATA.Theme.Accent
    Instance.new("UICorner", line)

    local tL = Instance.new("TextLabel", n)
    tL.Size = UDim2.new(1, -30, 0, 30); tL.Position = UDim2.new(0, 15, 0, 10)
    tL.Text = title:upper(); tL.TextColor3 = color or VORTEX_DATA.Theme.Accent; tL.Font = Enum.Font.GothamBold; tL.BackgroundTransparency = 1; tL.TextXAlignment = "Left"

    local dL = Instance.new("TextLabel", n)
    dL.Size = UDim2.new(1, -30, 0, 40); dL.Position = UDim2.new(0, 15, 0, 35)
    dL.Text = msg; dL.TextColor3 = Color3.new(0.8, 0.8, 0.8); dL.Font = Enum.Font.Gotham; dL.BackgroundTransparency = 1; dL.TextXAlignment = "Left"; dL.TextWrapped = true

    TweenService:Create(n, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.8, 0, 0.85, 0)}):Play()
    task.delay(4, function()
        TweenService:Create(n, TweenInfo.new(0.6), {Position = UDim2.new(1.2, 0, 0.85, 0)}):Play()
        task.wait(0.6); n:Destroy()
    end)
end

local function LaunchVortex()
    TweenService:Create(Blur, TweenInfo.new(1.2), {Size = 25}):Play()

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 280)
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.BackgroundColor3 = VORTEX_DATA.Theme.Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local Border = Instance.new("UIStroke", Main)
    Border.Thickness = 2; Border.Color = VORTEX_DATA.Theme.Accent

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 70); Title.Text = VORTEX_DATA.Name; Title.TextColor3 = VORTEX_DATA.Theme.Accent
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.BackgroundTransparency = 1

    local K_Frame = Instance.new("Frame", Main)
    K_Frame.Size = UDim2.new(0.85, 0, 0, 50); K_Frame.Position = UDim2.new(0.075, 0, 0.42, 0)
    K_Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26); Instance.new("UICorner", K_Frame)

    local K_Input = Instance.new("TextBox", K_Frame)
    K_Input.Size = UDim2.new(1, -20, 1, 0); K_Input.Position = UDim2.new(0, 10, 0, 0)
    K_Input.PlaceholderText = "Erişim Anahtarını Girin..."; K_Input.Text = ""; K_Input.TextColor3 = Color3.new(1, 1, 1)
    K_Input.BackgroundTransparency = 1; K_Input.Font = Enum.Font.GothamMedium

    local function CreateButton(txt, pos, color, callback)
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0.4, 0, 0, 45); btn.Position = pos; btn.Text = txt
        btn.BackgroundColor3 = color; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(callback)
    end

    CreateButton("GİRİŞ YAP", UDim2.new(0.075, 0, 0.68, 0), VORTEX_DATA.Theme.Accent, function()
        local inputKey = K_Input.Text
        local success, rawText = pcall(function() return game:HttpGet(VORTEX_DATA.KeyURL) end)

        if success and inputKey ~= "" then
            local keyFound = false
            for line in rawText:gmatch("[^\r\n]+") do
                if line:gsub("%s+", "") == inputKey then -- Boşlukları temizleyerek kontrol
                    keyFound = true
                    break
                end
            end

            if keyFound then
                Notify("ONAYLANDI", "Vortex Labs yükleniyor...", Color3.fromRGB(0, 255, 120))
                Main:Destroy(); TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()

                if game.PlaceId == VORTEX_DATA.Modes.LTM.ID then
                    loadstring(game:HttpGet(VORTEX_DATA.Modes.LTM.Source))()
                elseif game.PlaceId == VORTEX_DATA.Modes.DUEL.ID then
                    loadstring(game:HttpGet(VORTEX_DATA.Modes.DUEL.Source))()
                else
                    Notify("HATA", "Oyun ID desteklenmiyor!", Color3.fromRGB(255, 50, 50))
                end
            else
                Notify("GEÇERSİZ", "Yanlış anahtar girdiniz!", Color3.fromRGB(255, 50, 50))
            end
        else
            Notify("HATA", "Key listesi alınamadı!", Color3.fromRGB(255, 50, 50))
        end
    end)

    CreateButton("DISCORD", UDim2.new(0.525, 0, 0.68, 0), Color3.fromRGB(88, 101, 242), function()
        setclipboard(VORTEX_DATA.Discord)
        Notify("DISCORD", "Link kopyalandı.", Color3.fromRGB(88, 101, 242))
    end)
end

LaunchVortex()
