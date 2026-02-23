-- [[ KUZENİNİN ÇALIŞTIRACAĞI KONTROL KODU ]] --

local SahipID = 2965642560 -- BURAYA KENDİ ID'Nİ YAZ (Örn: 1234567)
local KuzenIsmi = "0607enes" -- Kuzeninin adı

-- Sohbet Fonksiyonu
local function Konustur(mesaj)
    local chatService = game:GetService("TextChatService")
    if chatService.ChatVersion == Enum.ChatVersion.TextChatService then
        chatService.TextChannels.RBXGeneral:SendAsync(mesaj)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(mesaj, "All")
    end
end

-- Dinleme Mekanizması
game:GetService("Players").PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        if plr.UserId == SahipID then
            -- Komut: :say 0607enes mesaj
            local prefix = ":say " .. KuzenIsmi .. " "
            if msg:sub(1, #prefix):lower() == prefix:lower() then
                local icerik = msg:sub(#prefix + 1)
                Konustur(icerik)
            end
            
            -- Ekstra Komut: :jump 0607enes
            if msg:lower() == ":jump " .. KuzenIsmi:lower() then
                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end)
end)

-- Eğer zaten oyundaysan dinlemeyi başlat
for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
    if plr.UserId == SahipID then
        plr.Chatted:Connect(function(msg)
            local prefix = ":say " .. KuzenIsmi .. " "
            if msg:sub(1, #prefix):lower() == prefix:lower() then
                local icerik = msg:sub(#prefix + 1)
                Konustur(icerik)
            end
            if msg:lower() == ":jump " .. KuzenIsmi:lower() then
                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
            end
        end)
    end
end

print("Kuzen Kontrol Sistemi Aktif!")
