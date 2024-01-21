repeat task.wait() until game:IsLoaded()

local lib = {
	Count = 0,
	ThemeColors = {
		clr1 = Color3.fromRGB(101, 181, 255),
		clr2 = Color3.fromRGB(103, 103, 255),
	},
	GuiBind = Enum.KeyCode.Delete,
	DropdownInvis = true
}

local GUI = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
GUI.ResetOnSpawn = false
GUI.Name = tostring(math.random())

function tweenColorBGR(obj, clr1, clr2)
	game.TweenService:Create(obj, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundColor3 = clr1
	}):Play()
	task.wait(.5)
	game.TweenService:Create(obj, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = clr2
	}):Play()
	task.wait(.5)
end
function tweenColorTXT(obj, clr1, clr2)
	game.TweenService:Create(obj, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		TextColor3 = clr1
	}):Play()
	task.wait(.5)
	game.TweenService:Create(obj, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextColor3 = clr2
	}):Play()
	task.wait(.5)
end
local notifCount = 0
function lib:NewNotification(Type, Thing, Time)
	spawn(function()
		local newNotif = Instance.new("TextLabel", GUI)
		newNotif.Size = UDim2.fromScale(0.2, 0.04)
		newNotif.Position = UDim2.fromScale(0.8, 0.9 - (notifCount / 10))
		if Type == "Toggle" then
			newNotif.Text = Thing.. " has been toggled"
		else
			newNotif.Text = Thing
		end
		newNotif.BorderSizePixel = 0
		newNotif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		newNotif.BackgroundTransparency = 0.7
		newNotif.TextColor3 = Color3.fromRGB(255,255,255)
		newNotif.TextSize = 17

		local newCorner = Instance.new("UICorner", newNotif)
		newCorner.CornerRadius = UDim.new(0, 5)
		notifCount += 1

		task.wait(Time)

		game.TweenService:Create(newNotif, TweenInfo.new(0.5), {
			Position = UDim2.fromScale(1, 1)
		}):Play()
		task.wait(.5)
		newNotif:Remove()
		notifCount -= 1
	end)
end

function lib:CreateWindow(name)
	local Text = Instance.new("TextLabel", GUI)
	Text.Position = UDim2.fromScale(0.1 + (lib.Count / 8), 0.1)
	Text.Size = UDim2.fromScale(0.1, 0.035)
	Text.BorderSizePixel = 0
	Text.Font = Enum.Font.Roboto
	Text.TextColor3 = Color3.fromRGB(255,255,255)
	Text.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Text.Text = name
	Text.Name = name
	Text.TextSize = 17
	Text.Visible = false
	Text.Active = true
	Text.Draggable = true

	local Modules = Instance.new("Frame", Text)
	Modules.Position = UDim2.fromScale(0,1)
	Modules.Size = UDim2.fromScale(1, 7)	
	Modules.BorderSizePixel = 0
	Modules.BackgroundTransparency = 1
	Modules.Name = "Modules"

	local sort = Instance.new("UIListLayout", Modules)

	game.UserInputService.InputBegan:Connect(function(k, gpe)
		if gpe then return end
		if k.KeyCode == lib.GuiBind then
			Text.Visible = not Text.Visible
		end
	end)

	lib.Count += 1
end

function lib:MakeButton(tab)
	local enabled = false

	local name = tab["Name"]
	local func = tab["Function"]
	local ntab = tab["Tab"]
	local keyc = tab["KeyBind"]
	local path = GUI[ntab].Modules

	local button = Instance.new("TextButton", GUI[ntab].Modules)
	local dropdown = Instance.new("Frame", button)

	local buttonFunctions = {
		Enabled = enabled,
		Toggle = function(e)
			if e then
				enabled = e
			else
				enabled = not enabled
			end
			if enabled then
				lib:NewNotification("Toggle", name, 3)
				spawn(function()
					repeat
						tweenColorBGR(button, lib.ThemeColors.clr1, lib.ThemeColors.clr2)
						task.wait()
					until (not enabled)
				end)
			else
				lib:NewNotification("Toggle", name, 3)
				spawn(function()
					repeat task.wait() until (button.BackgroundColor3 == lib.ThemeColors.clr2)
					game.TweenService:Create(button, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(75, 75, 75)
					}):Play()
				end)
			end
			func(enabled)
		end,
		newToggle = function(tab2)
			local enabled2 = false
			local name2 = tab2["Name"]
			local func2 = tab2["Function"]

			local button2 = Instance.new("TextButton", dropdown)

			local buttonFunctions2 = {
				Toggle = function(e)
					if e then
						enabled2 = e
					else
						enabled2 = not enabled2
					end
					func2(enabled2)
					if enabled2 then
						spawn(function()
							repeat
								tweenColorBGR(button2, lib.ThemeColors.clr1, lib.ThemeColors.clr2)
								task.wait()
							until (not enabled2)
						end)
					else
						spawn(function()
							repeat task.wait() until (button2.BackgroundColor3 == lib.ThemeColors.clr2)
							game.TweenService:Create(button2, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
								BackgroundColor3 = Color3.fromRGB(40, 40, 40)
							}):Play()
						end)
					end
				end,
			}

			button2.Size = UDim2.fromScale(1, .2)
			button2.Position = UDim2.fromScale(0,0)
			button2.BorderSizePixel = 0
			button2.Font = Enum.Font.Roboto
			button2.TextColor3 = Color3.fromRGB(255,255,255)
			button2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			button2.Text = name2
			button2.Name = name2
			button2.TextSize = 17
			button2.AutoButtonColor = false

			button2.MouseButton1Down:Connect(function()
				buttonFunctions2.Toggle()
			end)
		end,
		newTextBox = function(tab2)
			local name2 = tab2["Name"]
			local func2 = tab2["Function"]

			local textbox = Instance.new("TextBox", dropdown)

			local buttonFunctions2 = {
				Toggle = function(e)
					func2(textbox.Text)
				end,
			}

			textbox.Size = UDim2.fromScale(1, .2)
			textbox.Position = UDim2.fromScale(0,0)
			textbox.BorderSizePixel = 0
			textbox.Font = Enum.Font.Roboto
			textbox.TextColor3 = Color3.fromRGB(255,255,255)
			textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			textbox.Text = name2
			textbox.Name = name2
			textbox.TextSize = 17

			textbox.FocusLost:Connect(function()
				buttonFunctions2.Toggle()
				textbox.Text = name2.. " : "..textbox.Text
			end)
		end,
	}

	button.Size = UDim2.fromScale(1, .12)
	button.Position = UDim2.fromScale(0,0)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.Roboto
	button.TextColor3 = Color3.fromRGB(255,255,255)
	button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
	button.Text = name
	button.Name = name
	button.TextSize = 17
	button.AutoButtonColor = false

	dropdown.Size = UDim2.fromScale(1, 5)
	dropdown.Position = UDim2.fromScale(0,1)
	dropdown.BorderSizePixel = 0
	dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	dropdown.Name = "dropdown"
	dropdown.Visible = false
	if lib.DropdownInvis then
		dropdown.BackgroundTransparency = 1
	else
		dropdown.BackgroundTransparency = 0
	end
	--

	local dropuilist = Instance.new("UIListLayout", dropdown)

	button.MouseButton1Down:Connect(function()
		buttonFunctions.Toggle()
	end)

	button.MouseButton2Down:Connect(function()
		for i,v in pairs(path:GetChildren()) do
			if v:IsA("UIListLayout") then continue end
			if v.Name ~= name then
				v.Visible = not v.Visible
			end
		end

		dropdown.Visible = not dropdown.Visible
	end)

	game.UserInputService.InputBegan:Connect(function(key, gpe)
		if gpe then return end
		if keyc == nil then return end
		if key.KeyCode == keyc then
			buttonFunctions.Toggle()
		end
	end)

	return buttonFunctions
end
