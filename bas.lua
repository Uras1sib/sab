-- AYARLAR
local beklemeSuresi = 3 -- Ekranın kaç saniye kalacağını buradan saniye olarak ayarla
local metin = "All script By Uras"

-- GUI OLUŞTURMA
local player = game.Players.LocalPlayer
local screenGui = script.Parent

-- Ekranın en üstündeki boşluğu (Roblox barını) kapatmak için:
screenGui.IgnoreGuiInset = true

-- Arka planı siyaha yakın gri yap ve tüm ekranı kapla
local frame = Instance.new("Frame")
frame.Name = "SplashFrame"
frame.Size = UDim2.new(1, 0, 1, 0) 
frame.Position = UDim2.new(0, 0, 0, 0)
-- Siyaha yakın gri: Color3.fromRGB(30, 30, 30)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) 
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Ortadaki metni ekle
local label = Instance.new("TextLabel")
label.Name = "UrasLabel"
label.Size = UDim2.new(1, 0, 0, 50)
label.Position = UDim2.new(0, 0, 0.5, -25) 
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255) -- Tam beyaz
label.TextSize = 50 -- Yazıyı biraz daha büyüttüm
label.Font = Enum.Font.SourceSansBold
label.Text = metin
label.Parent = frame

-- SÜRE AYARI VE SİLİNME
task.wait(beklemeSuresi)

-- Yavaşça yok olma efekti
for i = 0, 1, 0.1 do
    frame.BackgroundTransparency = i
    label.TextTransparency = i
    task.wait(0.05)
end

-- Tamamen kaldır
screenGui:Destroy()
