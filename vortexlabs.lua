--[[
    VORTEX LABS - ULTIMATE EDITION v10.0
    Discord: https://discord.gg/zS8KXaHtTE
    LTM ID: 85621847059032 | DUEL ID: 99606176102979
    LTM Script Updated to: ltm2.lua
]]

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- [[ KONFIGURASYON VE OYUN VERILERI ]] --
local VORTEX_DATA = {
    Name = "VORTEX LABS",
    Discord = "https://discord.gg/zS8KXaHtTE",
    KeyURL = "https://raw.githubusercontent.com/Uras1sib/sab/refs/heads/main/test.txt",
    
    Modes = {
        LTM = {
            ID = 85621847059032,
            Source = "https://raw.githubusercontent.com/Uras1sib/sab/refs/heads/main/ltm2.lua" -- Yeni Link
        },
        DUEL = {
            ID = 99606176102979,
            Source = "https://api.luarmor.net/files/v4/loaders/e8c2b7bdfd494b913839f58581a203f9.lua"
        }
    },
    
    Theme = {
        Main = Color3.fromRGB(10, 10, 14),
        Header = Color3.fromRGB(15, 15, 22),
        Accent = Color3.fromRGB(140, 0, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- [[ UI ENGINE ]] --
local Screen = Instance.new("ScreenGui")
Screen.Name = "VortexLabs_Final"
Screen.IgnoreGuiInset = true
Screen.ResetOnSpawn = false
Screen.Parent = (gethui and gethui()) or CoreGui

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0

-- [[ YARDIMCI MOTORLAR ]] --
local function Anim(obj, t, prop)
    local tw = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    tw:Play()
    return tw
end

-- BILDIRIM SISTEMI
local function Notify(title, msg, color)
    local n = Instance.new("Frame", Screen)
    n.Size = UDim2.new(0, 280, 0, 80)
    n.Position = UDim2.new(1, 20, 0.85, 0)
    n.BackgroundColor3 = VORTEX_DATA.Theme.Main
    n.BorderSizePixel = 0
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    
    local line = Instance.new("Frame", n)
    line.Size = UDim2.new(0, 4, 1, 0)
    line.BackgroundColor3 = color or VORTEX_DATA.Theme.Accent
    Instance.new("UICorner", line)

    local tL = Instance.new("TextLabel", n)
    tL.Size = UDim2.new(1, -30, 0, 30)
    tL.Position = UDim2.new(0, 15, 0, 10)
    tL.Text = title:upper()
    tL.TextColor3 = color or VORTEX_DATA.Theme.Accent
    tL.Font = Enum.Font.GothamBold
    tL.BackgroundTransparency = 1
    tL.TextXAlignment = "Left"

    local dL = Instance.new("TextLabel", n)
    dL.Size = UDim2.new(1, -30, 0, 40)
    dL.Position = UDim2.new(0, 15, 0, 35)
    dL.Text = msg
    dL.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    dL.Font = Enum.Font.Gotham
    dL.BackgroundTransparency = 1
    dL.TextXAlignment = "Left"
    dL.TextWrapped = true

    Anim(n, 0.6, {Position = UDim2.new(0.8, 0, 0.85, 0)})
    task.delay(4, function()
        Anim(n, 0.6, {Position = UDim2.new(1.2, 0, 0.85, 0)})
        task.wait(0.6)
        n:Destroy()
    end)
end

-- [[ GIRIS EKRANI ]] --
local function LaunchVortex()
    Anim(Blur, 1.2, {Size = 25})

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 280)
    Main.Position = UDim2.new(0.5, -200, 0.5, -140)
    Main.BackgroundColor3 = VORTEX_DATA.Theme.Main
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- Statik Çerçeve (Dönmeyen, Sabit Mor)
    local Border = Instance.new("UIStroke", Main)
    Border.Thickness = 2
    Border.Color = VORTEX_DATA.Theme.Accent
    Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Header
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = VORTEX_DATA.Theme.Header
    Header.BorderSizePixel = 0
    Instance.new("UICorner", Header)

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Text = VORTEX_DATA.Name
    Title.TextColor3 = VORTEX_DATA.Theme.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24
    Title.BackgroundTransparency = 1

    -- Key Box
    local K_Frame = Instance.new("Frame", Main)
    K_Frame.Size = UDim2.new(0.85, 0, 0, 50)
    K_Frame.Position = UDim2.new(0.075, 0, 0.42, 0)
    K_Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    K_Frame.BorderSizePixel = 0
    Instance.new("UICorner", K_Frame)

    local K_Input = Instance.new("TextBox", K_Frame)
    K_Input.Size = UDim2.new(1, -20, 1, 0)
    K_Input.Position = UDim2.new(0, 10, 0, 0)
    K_Input.PlaceholderText = "Erişim Anahtarını Buraya Girin..."
    K_Input.Text = ""
    K_Input.TextColor3 = Color3.new(1, 1, 1)
    K_Input.Font = Enum.Font.GothamMedium
    K_Input.BackgroundTransparency = 1

    -- BUTON MOTORU
    local function CreateButton(txt, pos, color, callback)
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0.4, 0, 0, 45)
        btn.Position = pos
        btn.Text = txt
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(callback)
    end

    -- GIRIS ISLEMI
    CreateButton("SİSTEME GİRİŞ", UDim2.new(0.075, 0, 0.68, 0), VORTEX_DATA.Theme.Accent, function()
        local inputKey = K_Input.Text
        local success, rawText = pcall(function() return game:HttpGet(VORTEX_DATA.KeyURL) end)

        if success and string.find(rawText, inputKey) and inputKey ~= "" then
            Notify("ONAYLANDI", "Vortex Labs yükleniyor...", Color3.fromRGB(0, 255, 120))
            Anim(Main, 0.8, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
            task.wait(0.8)
            Main:Destroy()
            Anim(Blur, 1, {Size = 0})

            -- OYUN ALGILAMA
            local pId = game.PlaceId
            local gId = game.GameId

            if pId == VORTEX_DATA.Modes.LTM.ID or gId == VORTEX_DATA.Modes.LTM.ID then
                Notify("LTM", "LTM2 Modu aktif ediliyor.", VORTEX_DATA.Theme.Accent)
                loadstring(game:HttpGet(VORTEX_DATA.Modes.LTM.Source))()
            elseif pId == VORTEX_DATA.Modes.DUEL.ID or gId == VORTEX_DATA.Modes.DUEL.ID then
                Notify("DUEL", "Duel (Luarmor) aktif ediliyor.", VORTEX_DATA.Theme.Accent)
                loadstring(game:HttpGet(VORTEX_DATA.Modes.DUEL.Source))()
            else
                Notify("HATA", "Bu oyun desteklenmiyor!", Color3.fromRGB(255, 50, 50))
            end
        else
            Notify("GEÇERSİZ", "Anahtar hatalı!", Color3.fromRGB(255, 50, 50))
        end
    end)

    -- DISCORD
    CreateButton("DISCORD", UDim2.new(0.525, 0, 0.68, 0), Color3.fromRGB(88, 101, 242), function()
        setclipboard(VORTEX_DATA.Discord)
        Notify("DISCORD", "Bağlantı kopyalandı.", Color3.fromRGB(88, 101, 242))
    end)
end

LaunchVortex()
