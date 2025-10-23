-- 🧠 GUI oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "F2Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- 🎛️ Buton oluşturma
local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 60, 0, 40)
Button.Position = UDim2.new(0.5, -30, 0.5, -20)
Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
Button.Text = "F2"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.Active = true
Button.Draggable = true

-- 🖱️ Butona tıklayınca yapılacak işlem
Button.MouseButton1Click:Connect(function()
	print("F2 Butonuna tıklandı!")
	-- Buraya F2 işlevini ekle
end)

-- 🎹 Klavyeden F2’ye basınca yapılacak işlem
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
		print("F2 tuşuna basıldı!")
		-- Buraya F2 işlevini ekle
	end
end)
