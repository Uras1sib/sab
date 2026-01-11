local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

-- --- GELİŞMİŞ SÜRÜKLENEBİLİR MENÜ ---
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "ProFlyGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 160, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "FLY KONTROL"
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

-- --- UÇUŞ SİSTEMİ (YÖN ODAKLI) ---
local bv, bg

function toggleFly()
	flying = not flying
	if flying then
		flyButton.Text = "UÇUŞ: AÇIK (H)"
		flyButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
		humanoid.PlatformStand = true
		
		bg = Instance.new("BodyGyro", root)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		
		bv = Instance.new("BodyVelocity", root)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		
		task.spawn(function()
			while flying do
				local dt = RunService.RenderStepped:Wait()
				local camera = workspace.CurrentCamera
				
				local moveDir = humanoid.MoveDirection
				
				if moveDir.Magnitude > 0 then
					local lookVec = camera.CFrame.LookVector
					
					-- Hareket yönünü hesapla
					local finalVelocity = (camera.CFrame:VectorToWorldSpace(Vector3.new(
						(UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
						0,
						(UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
					))).Unit
					
					-- Mobil Joystick uyumluluğu
					if finalVelocity.Magnitude == 0 or tostring(finalVelocity.X) == "nan" then
						finalVelocity = moveDir
					end

					bv.velocity = finalVelocity * speed
					
					-- Karakteri gittiği yöne (yukarı/aşağı/sağa/sola) döndür
					bg.cframe = CFrame.new(root.Position, root.Position + bv.velocity)
				else
					bv.velocity = Vector3.new(0, 0.1, 0)
					bg.cframe = camera.CFrame
				end
			end
			
			if bg then bg:Destroy() end
			if bv then bv:Destroy() end
			humanoid.PlatformStand = false
		end)
	else
		flyButton.Text = "UÇUŞ: KAPALI (H)"
		flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	end
end

-- --- TUŞ KONTROLÜ (H TUŞU) ---
UserInputService.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.H then -- Burada H tuşu ayarlandı
		toggleFly()
	end
end)

flyButton.MouseButton1Click:Connect(toggleFly)

speedInput.FocusLost:Connect(function()
	speed = tonumber(speedInput.Text) or speed
	speedInput.Text = tostring(speed)
end)
