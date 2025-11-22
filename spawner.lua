local Library = loadstring(game:HttpGet('https://pastefy.app/sOFPrF6a/raw'))()

local api = loadstring(game:HttpGet('https://sdkapi-public.luarmor.net/library.lua'))()

api.script_id = 'cd22bffdfefc799f64ff2a0332d5adeb'

local Window = Library:Window({
	Title = 'Uras Spawner | Key System',
	Desc = 'Trax Spawner',
	Icon = 94425520075595,
	Theme = 'Trax',
	Config = {
		Keybind = Enum.KeyCode.T,
		Size = UDim2.new(0, 500, 0, 400),
	},
	CloseUIButton = {
		Enabled = true,
		Text = 'close',
	},
})
if isfile('Trax_Keys/Trax_Spawner') then
	script_key = readfile('Trax_Keys/Trax_Spawner')
	if script_key and api.check_key(script_key).code == 'KEY_VALID' then
		game:GetService('CoreGui')['Dummy Kawaii']:Destroy()
		api.load_script()
		if not _G.AutoLoad then
			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'Success',
				Text = 'Loaded with saved key',
				Duration = 5,
			})
		return
	end
end
end

local tab1 = Window:Tab({ Title = 'Get Key', Icon = 119591742504251 })
local tab2 = Window:Tab({ Title = 'Redeem', Icon = 139729696247144 })

tab1:Section({ Title = 'Get Key' })
tab2:Section({ Title = 'Enter Key' })

tab1:Code({
	Title = 'Get Key',
	Code = 'discord.gg/fmqb7UGkyd',
})

tab1:Button({
	Title = 'Copy Key Link',
	Desc = 'Copies the Discord invite',
	Callback = function()
		setclipboard('https://discord.gg/fmqb7UGkyd')
		Window:Notify({
			Title = 'Copied',
			Desc = 'Invite link copied to clipboard',
			Time = 4,
		})
	end,
})

local key = ''
tab2:Textbox({
	Title = 'Key',
	Desc = 'Enter your key',
	Placeholder = '',
	Value = '',
	ClearTextOnFocus = false,
	Callback = function(Text)
		key = tostring(Text or ''):gsub('%s+', '')
	end,
})

tab2:Button({
	Title = 'Activate',
	Desc = 'Check key',
	Callback = function()
		if #key ~= 32 then
			Window:Notify({ Title = 'Error', Desc = 'Invalid key', Time = 3 })
			return
		end

		script_key = key
		local status = api.check_key(script_key)

		if status.code == 'KEY_VALID' then
			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'Success',
				Text = 'Key valid',
				Duration = 5,
			})
			makefolder('Trax_Keys')
			writefile('Trax_Keys/Trax_Spawner', script_key)
			game:GetService('CoreGui')['Dummy Kawaii']:Destroy()

			api.load_script()
		elseif status.code == 'KEY_INCORRECT' then
			Window:Notify({
				Title = 'Error',
				Desc = 'Incorrect key/expired key',
				Time = 5,
			})
		elseif status.code == 'KEY_HWID_LOCKED' then
			Window:Notify({
				Title = 'HWID Locked',
				Desc = 'Reset HWID in the luarmor panel, or the key is already used',
				Time = 5,
			})
		else
			Window:Notify({
				Title = 'error',
				Desc = tostring(status.code or 'Try again later'),
				Time = 5,
			})
		end
	end,
})
