local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local flying = false
local speed = 50

-- --- GUI OLUŞTURMA (Ölünce silinmez) ---
local screenGui = player.PlayerGui:FindFirstChild("ProFlyGui") or Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "ProFlyGui"
screenGui.ResetOnSpawn = false 

if screenGui:FindFirstChild("MainFrame") then screenGui.MainFrame:Destroy() end

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 160, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true 
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "FLY by Uras"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0.35, 0)
flyButton.Text = "UÇUŞ: KAPALI (H)"
flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", flyButton)

local speedInput = Instance.new("TextBox", mainFrame)
speedInput.Size = UDim2.new(0.9, 0, 0, 30)
speedInput.Position = UDim2.new(0.05, 0, 0.65, 0)
speedInput.PlaceholderText = "Hız Yaz..."
speedInput.Text = tostring(speed)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", speedInput)

-- --- ANA UÇUŞ FONKSİYONU ---
function toggleFly()
	-- Her seferinde güncel karakteri al
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or not hum then return end

	flying = not flying

	if flying then
		flyButton.Text = "UÇUŞ: AÇIK (H)"
		flyButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
		hum.PlatformStand = true
		
		-- Eski kalıntıları temizle
		if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
		if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end

		local bg = Instance.new("BodyGyro", hrp)
		bg.Name = "FlyGyro"
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Name = "FlyVelocity"
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

		task.spawn(function()
			while flying and char.Parent and hum.Health > 0 do
				RunService.RenderStepped:Wait()
				local camera = workspace.CurrentCamera
				
				if hum.MoveDirection.Magnitude > 0 then
					-- PC ve Mobil uyumlu yön hesaplama
					local look = camera.CFrame.LookVector
					local right = camera.CFrame.RightVector
					local moveDir = hum.MoveDirection
					
					bv.velocity = moveDir * speed
					bg.cframe = CFrame.new(hrp.Position, hrp.Position + moveDir)
				else
					bv.velocity = Vector3.new(0, 0.1, 0)
					bg.cframe = camera.CFrame
				end
			end
			-- Karakter ölürse veya fly kapatılırsa temizle
			flying = false
			flyButton.Text = "UÇUŞ: KAPALI (H)"
			flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
			if bg then bg:Destroy() end
			if bv then bv:Destroy() end
			if hum then hum.PlatformStand = false end
		end)
	end
end

-- --- KONTROLLER ---
UserInputService.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.H then toggleFly() end
end)

flyButton.MouseButton1Click:Connect(toggleFly)

speedInput.FocusLost:Connect(function()
	speed = tonumber(speedInput.Text) or speed
	speedInput.Text = tostring(speed)
end)

-- Öldüğünde Fly durumunu sıfırla ki buton düzgün çalışsın
player.CharacterAdded:Connect(function()
	flying = false
	flyButton.Text = "UÇUŞ: KAPALI (H)"
	flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)
