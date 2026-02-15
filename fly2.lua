local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local flying = false
local speeds = 1
local tpwalking = false

-- --- INTRO ---
local function playIntro()
    local introGui = Instance.new("ScreenGui", player.PlayerGui)
    local introText = Instance.new("TextLabel", introGui)
    introText.Size = UDim2.new(1, 0, 1, 0)
    introText.BackgroundTransparency = 1
    introText.Text = "FLY by Uras"
    introText.TextColor3 = Color3.fromRGB(255, 255, 255)
    introText.TextSize = 60
    introText.Font = Enum.Font.GothamBold
    introText.TextTransparency = 1
    
    TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(1.5)
    TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1)
    introGui:Destroy()
end
task.spawn(playIntro)

-- --- GUI TASARIMI ---
local main = Instance.new("ScreenGui", player.PlayerGui)
main.Name = "UrasFlyV4"
main.ResetOnSpawn = false

local Frame = Instance.new("Frame", main)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 180, 0, 130)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "FLY by Uras"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local toggleGuiBtn = Instance.new("TextButton", Frame)
toggleGuiBtn.Size = UDim2.new(0, 25, 0, 25)
toggleGuiBtn.Position = UDim2.new(1, -30, 0, 5)
toggleGuiBtn.Text = "_"
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleGuiBtn)

local onof = Instance.new("TextButton", Frame)
onof.Size = UDim2.new(0.9, 0, 0, 35)
onof.Position = UDim2.new(0.05, 0, 0.3, 0)
onof.Text = "FLY: KAPALI (H)"
onof.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
onof.TextColor3 = Color3.fromRGB(255, 255, 255)
onof.Font = Enum.Font.GothamBold
Instance.new("UICorner", onof)

local speedLabel = Instance.new("TextLabel", Frame)
speedLabel.Size = UDim2.new(0.3, 0, 0, 30)
speedLabel.Position = UDim2.new(0.35, 0, 0.65, 0)
speedLabel.Text = "Hız: " .. speeds
speedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", speedLabel)

local plus = Instance.new("TextButton", Frame)
plus.Text = "+"; plus.Size = UDim2.new(0.2, 0, 0, 30); plus.Position = UDim2.new(0.7, 0, 0.65, 0); plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(60, 60, 60); plus.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", plus)

local mine = Instance.new("TextButton", Frame)
mine.Text = "-"; mine.Size = UDim2.new(0.2, 0, 0, 30); mine.Position = UDim2.new(0.1, 0, 0.65, 0); mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(60, 60, 60); mine.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", mine)

-- --- MEKANİZMA ---
function startFlyLoops()
    tpwalking = false
    task.wait(0.01)
    tpwalking = true
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = workspace.CurrentCamera
    
    for i = 1, speeds do
        task.spawn(function()
            while tpwalking and char.Parent and hum.Health > 0 do
                RunService.Heartbeat:Wait()
                local moveDir = hum.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Hem PC hem Mobil için Kameranın açısına göre yön belirleme
                    local direction = cam.CFrame:VectorToWorldSpace(cam.CFrame:VectorToObjectSpace(moveDir))
                    char:TranslateBy(direction * 0.4)
                end
            end
        end)
    end
end

function toggleFly()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    flying = not flying
    if flying then
        onof.Text = "FLY: AÇIK (H)"
        onof.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        hum.PlatformStand = true
        if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "UrasGyro"; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "UrasVel"; bv.maxForce = Vector3.new(9e9, 9e9, 9e9); bv.velocity = Vector3.new(0, 0.1, 0)
        
        startFlyLoops()
        
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
            -- Kapatıldığında temizlik (Havada asılı kalmayı önler)
            bg:Destroy()
            bv:Destroy()
        end)
    else
        onof.Text = "FLY: KAPALI (H)"
        onof.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        tpwalking = false
        hum.PlatformStand = false
        if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        
        -- Kalan objeleri zorla temizle
        if hrp:FindFirstChild("UrasGyro") then hrp.UrasGyro:Destroy() end
        if hrp:FindFirstChild("UrasVel") then hrp.UrasVel:Destroy() end
    end
end

-- --- BUTONLAR VE TUŞLAR ---
plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedLabel.Text = "Hız: " .. speeds
    if flying then startFlyLoops() end
end)

mine.MouseButton1Click:Connect(function()
    if speeds > 1 then
        speeds = speeds - 1
        speedLabel.Text = "Hız: " .. speeds
        if flying then startFlyLoops() end
    end
end)

onof.MouseButton1Click:Connect(toggleFly)

-- Minimize Mekanizması
local mini = false
toggleGuiBtn.MouseButton1Click:Connect(function()
    mini = not mini
    if mini then
        onof.Visible = false; speedLabel.Visible = false; plus.Visible = false; mine.Visible = false
        Frame:TweenSize(UDim2.new(0, 180, 0, 35), "Out", "Quad", 0.3)
        toggleGuiBtn.Text = "+"
    else
        Frame:TweenSize(UDim2.new(0, 180, 0, 130), "Out", "Quad", 0.3)
        task.wait(0.3)
        onof.Visible = true; speedLabel.Visible = true; plus.Visible = true; mine.Visible = true
        toggleGuiBtn.Text = "_"
    end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.H then toggleFly() end
end)

player.CharacterAdded:Connect(function() 
    flying = false 
    tpwalking = false 
end)
