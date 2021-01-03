local random = Random.new()
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}

function getRandomLetter()
	return letters[random:NextInteger(1,#letters)]
end

function getRandomString(length, includeCapitals)
	local length = length or 10
	local str = ''
	for i=1,length do
		local randomLetter = getRandomLetter()
		if includeCapitals and random:NextNumber() > .5 then
			randomLetter = string.upper(randomLetter)
		end
		str = str .. randomLetter
	end
	return str
end

local randomTitle = getRandomString(7, true)

local player = game:GetService("Players").LocalPlayer
local characterFolders = workspace.PlayerCharacters
local backpack = player:WaitForChild("Backpack")
local runService = game:GetService("RunService")
local EventCombat = game:GetService("ReplicatedStorage").Events.CombatRegister
local EventQuest = game:GetService("ReplicatedStorage").Events.Quest
local sequence = 1
local EventHaki = game:GetService("ReplicatedStorage").Events.Haki
local styleSeletect = {
	""
}
local fullCircle = 2 * math.pi
local halfCircle = math.pi
local autoFarmButton 
local radius = 3.2
local radius2 = 5
local tweenService = game:GetService("TweenService")
local tweenGlobal = nil
local speedMarineShip = 30
local attempts = game.ReplicatedStorage["Stats"..(game.Players.LocalPlayer.Name)].Stats.Attempts
local hitCooldown = time()
local actualCaptain = nil
local respawnShip = nil
local marineFarmDistance = 1000
local speedIslandTp = 50
local ships = workspace.Ships
local water = workspace:WaitForChild("Effects"):WaitForChild("Water")
local EventShip = game:GetService("ReplicatedStorage").Events.ShipEvents.Spawn
local nextCaptian = true
local speedAutoFarm = 30
local MarketPlaceService = game:GetService("MarketplaceService")
local NPC = workspace.NPCs
local myShip = nil
local captiansQueue = {
	
}
local vu = game:GetService("VirtualUser")
local npcFocused = nil
local fruitGot = false

local statsPlayer = game:GetService("ReplicatedStorage")["Stats"..player.Name]
local quests = statsPlayer.Quest

local fruits = {
	"Bomb",
	"Mera",
	"Hie",
	"Magu",
	"Pika",
	"Suke",
	"Bari",
	"Bomb",
	"Goro"
}

local inventoryItems = game:GetService("ReplicatedStorage"):WaitForChild("Stats"..player.Name):WaitForChild("Inventory"):WaitForChild("Inventory")
local EventStoreFruits = game:GetService("ReplicatedStorage").Events.FruitStorage

local questList = {
	["Bandits"] = {
		"Raphtalia",
		"Help Raphtalia"
	},
	["Bandit Boss"] = {
		"Ronny",
		"Help Ronny"
	},
	["Desert Bandits"] = {
		"Noah",
		"Help Noah"
	},
	["Lucid"] = {
		"Tyrone",
		"Take down Lucid"
	},
	["Krieg Pirates"] = {
		"Chef Rice",
		"Help Rice"
	},
	["Zou Inhabitants"] = {
		"Zen",
		"Help Zen"
	},
	["Corrupt Marines"] = {
		"Robert",
		"Help Robert"
	},
	["Sky district bandits"] = {
		"Vego",
		"Help vego"
	},
	["Castle Guards"] = {
		"Zhen",
		"Help zhen"
	},
	["Sky Guardians"] = {
		"Raze",
		"Help raze"
	}
}

local questDoing = {

}

local npcList = {
	"Bandit",
	"Bandit Boss",
	"Desert Bandit",
	"Lucid's Lad",
	"Lucid's Righthand",
	"Lucid",
	"Krieg Pirate",
	"Zou Inhabitant",
	"Corrupt Marine",
	"Monkey",
	"Sky District Bandit",
	"Castle Guard",
	"Sky Guardian"

}

local islands = {
	["Shells"] = Vector3.new(-533,13,-4548),
	["Orange"] = Vector3.new(-7005,5,-5339),
	["Zou"] = Vector3.new(-4338,7,-2546),
	["Colosseum"] = Vector3.new(-2020,7,-7634),
	["Starter"] = Vector3.new(964,9,1000),
	["Arlong"] = Vector3.new(506,13,-12935),
	["Sandora"] = Vector3.new(-1299,10,1156),
	["Sphinx"] = Vector3.new(-6280,5,-9832),
	["Mysterius"] = Vector3.new(2197,6,-8733),
	["Sky island"] = Vector3.new(9259,1703,-10846),
	["Roka"] = Vector3.new(5186,4,-5333),
	["Kori"] = Vector3.new(6633,118,2046),
	["Marine"] = Vector3.new(2763,6,-1044),
	["Barratie"] = Vector3.new(-3912,6,-5614)
}

local npcFarming = {

}

local styles = {
	["Melee"] = function(npc)
		local A_1 = 
			{
				[1] = "damage", 
				[2] = npc.HumanoidRootPart, 
				[3] = "Melee", 
				[4] = 
				{
					[1] = sequence, 
					[2] = "Ground", 
					[3] = "Melee"
				}
			}
		EventCombat:InvokeServer(A_1)
	end,
	["Rokushiki"] = function(npc)
		local A_1 = 
			{
				[1] = "damage", 
				[2] = npc.HumanoidRootPart, 
				[3] = "Melee", 
				[4] = 
				{
					[1] = sequence, 
					[2] = "Ground", 
					[3] = "Melee"
				}
			}
		EventCombat:InvokeServer(A_1)
	end,
	["BlackLeg"] = function(npc)
		local args = {
			[1] = {
				[1] = "damage",
				[2] = npc.HumanoidRootPart,
				[3] = "BlackLeg",
				[4] = {
					[1] = sequence,
					[2] = "Ground",
					[3] = "BlackLeg"
				}
			}
		}
		EventCombat:InvokeServer(unpack(args))
	end,
	["Katana"] = function(npc)
		local A_1 = 
			{
				[1] = "damage", 
				[2] = npc.HumanoidRootPart, 
				[3] = "Sword", 
				[4] = 
				{
					[1] = sequence, 
					[2] = "Ground", 
					[3] = "Sword"
				}
			}
		EventCombat:InvokeServer(A_1)
	end,
	["Electro"] =  function(npc)
		local A_1 = 
			{
				[1] = "damage", 
				[2] = npc.HumanoidRootPart, 
				[3] = "Melee", 
				[4] = 
				{
					[1] = sequence, 
					[2] = "Ground", 
					[3] = "Melee"
				}
			}
		EventCombat:InvokeServer(A_1)
	end,
	["Kiribachi"] = function(npc)
		local A_1 = 
			{
				[1] = "damage", 
				[2] = npc.HumanoidRootPart, 
				[3] = "Sword", 
				[4] = 
				{
					[1] = sequence, 
					[2] = "Ground", 
					[3] = "Sword"
				}
			}
		EventCombat:InvokeServer(A_1)
	end
}

local function getStyle(name)
	for _,v in pairs(player.Backpack:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then
			styleSeletect[1] = v.Name
			styleSeletect[2] = v
			return true
		end 
	end
	for _,v in pairs(player.Character:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then
			styleSeletect[1] = v.Name
			styleSeletect[2] = v
			return true
		end 
	end
	styleSeletect[2] = nil
	return false
end


local function getStyleEquiped()
	for _,v in pairs(player.Character:GetChildren()) do
		if v:IsA("Tool") and styles[v.Name] then
			styleSeletect[1] = v.Name
			styleSeletect[2] = v
			return true
		end 
	end
	styleSeletect[2] = nil
	return false
end


local function getClosestNpc()
	local distancenNow = nil
	for i,v in pairs(NPC:GetChildren())do
		if npcFarming[v.Name] then
			local c = (v.HumanoidRootPart.Position - player.Character:WaitForChild("HumanoidRootPart").Position).magnitude
			if distancenNow == nil then
				distancenNow = c
				npcFocused = v
			elseif c < distancenNow then
				distancenNow = c
				npcFocused = v
			end
		end
	end

	sequence = 1
	hitCooldown = time()
	radius = 13
end	

local function checkTrigered()
	local amount = 0
	local npcGot = nil
	for i,v in pairs(NPC:GetChildren()) do
		if npcFarming[v.Name] then
			if v:FindFirstChild("Info") and v.Info:FindFirstChild("Target") and v.Info.Target.Value and v.Info.Target.Value == player.Character:WaitForChild("HumanoidRootPart") then
				amount = amount + 1
				npcGot = v
			end
		end
	end
	if amount == 1 then
		npcFocused = npcGot
	end
end

local function getXAndZPositions(angle)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	return x, z
end


local function getNextCaptian()
	local s = ships:FindFirstChild(player.Name.."Ship")
	if not s then return end
	local rp = s:FindFirstChild("HumanoidRootPart")
	if not rp then
		return
	end
	for _,v in pairs(captiansQueue) do
		local rpCap = v:FindFirstChild("HumanoidRootPart")
		if not rpCap then return end
		if (rp.Position - rpCap.Position).magnitude <= marineFarmDistance then
			actualCaptain = v
			sequence = 1
			nextCaptian = false	
			break
		end
	end
end

local function foundChild(child)
	for i = 1, #captiansQueue do
		if captiansQueue[i] == child then
			return i
		end
	end
end

local function backacpkFruits()
	for _,v in pairs(backpack:GetChildren())do
		if v:IsA("Tool") and table.find(fruits,v.Name) and not string.find(inventoryItems.Value,v.Name) then
			return v
		end
	end
	return nil
end

local scriptFunctions
scriptFunctions = {
	["Auto Style"] = {
		false,
		function() 
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Auto Style"][1] do
				if styleSeletect[2] ~= nil then
					if styleSeletect[2].Parent == nil and player.Character.Parent == characterFolders then
						getStyle(styleSeletect[1])
					end
				elseif styleSeletect[2] == nil then
					getStyle(styleSeletect[1])
				end
				if not fruitGot then
				pcall(function()
					player.Character:WaitForChild("Humanoid"):EquipTool(styleSeletect[2])
				end)	
				end	
			end
		end
	},
	["Auto Npc"] = {
		false,
		function() 
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Auto Npc"][1] do
				if player.Character.Parent == characterFolders and not player.Character:FindFirstChild("SafeForceField") then
					
				pcall(function()
				if not npcFocused or npcFocused.Parent ~= NPC then
					getClosestNpc()
					
				end

				if scriptFunctions["Auto Quest"][1] then
					scriptFunctions["Auto Quest"][2]()
				end
					
				end)	
				
				if npcFocused and npcFocused.Parent == NPC then 
				
				pcall(function()
				local npcRp = npcFocused:FindFirstChild("HumanoidRootPart")
				if npcRp then 
				
				local distance = (npcRp.Position - player.Character:WaitForChild("HumanoidRootPart").Position).magnitude
				local timeTween = distance / speedAutoFarm
				local angle = 4 * (fullCircle / 4)
				local x, z = getXAndZPositions(angle)
				local position = (npcRp.CFrame * CFrame.new(x, 0, z)).p
				local lookAt = npcRp.Position
				tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
					CFrame = CFrame.new(position,lookAt)
				})
				tweenGlobal:Play()
				tweenGlobal.Completed:Wait()

				if time() - hitCooldown > 2 then
					radius = 3.2
					if distance <= 5 then
						checkTrigered()
						if styleSeletect[2] then
							styles[styleSeletect[1]](npcFocused)
						else
							if getStyleEquiped() then
								styles[styleSeletect[1]](npcFocused)
							end
						end
						sequence = sequence + 1
						if sequence == 5 then
							sequence = 1
							radius = 13
							hitCooldown = time()
						end
					end
					end
				end		
				end)
				end		
				else
					if tweenGlobal then
						tweenGlobal:Cancel()
					end
				end	
			end
		end
	},
	["Auto Quest"] = {
		false,
		function()
			if quests.CurrentQuest.Value == "None" and questDoing[1] then
				if player.QuestCD.Value then return end

				local questNpc
				local s,e = pcall(function()
					questNpc = NPC[questList[questDoing[1]][1]] 
				end)
				if not s then
					return
				end

				local distance = (questNpc.HumanoidRootPart.Position - player.Character:WaitForChild("HumanoidRootPart").Position).magnitude
				local timeTween = distance / speedAutoFarm
				tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
					CFrame = questNpc.HumanoidRootPart.CFrame - Vector3.new(3,0,3)
				})
				tweenGlobal:Play()
				tweenGlobal.Completed:Wait()
				local A_1 = 
					{
						[1] = "takequest", 
						[2] = questList[questDoing[1]][2]
					}
				EventQuest:InvokeServer(A_1)
			end
		end
	},
	["Marine Ships"] = {
		false,
		function()
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Marine Ships"][1] do
				
					
				if not myShip and ships:FindFirstChild(player.Name.."Ship") then
					myShip = ships:FindFirstChild(player.Name.."Ship")
				end
					
				if nextCaptian and not actualCaptain then
					getNextCaptian()
				end
				
				if actualCaptain and (actualCaptain.Parent == nil or actualCaptain.Parent ~= NPC) then
					table.remove(captiansQueue,foundChild(actualCaptain))
					actualCaptain = nil
					nextCaptian = true
					sequence = 1
					getNextCaptian()
				end
					
				if not myShip then
					if respawnShip then	
					repeat
						local distance = (player.Character:WaitForChild("HumanoidRootPart").Position - respawnShip.p).magnitude
						local timeTween = distance / 35		
						tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
							CFrame = respawnShip
						})
						tweenGlobal:Play()	
						runService.Heartbeat:Wait()		
					until not game.CoreGui[randomTitle] or not scriptFunctions["Marine Ships"][1] or respawnShip == nil or distance <= 4
					if scriptFunctions["Marine Ships"][1] then	
						EventShip:InvokeServer()	
				    end	
					end		
				end		
					
				if myShip and not myShip:WaitForChild("HumanoidRootPart").Anchored then
					myShip:WaitForChild("HumanoidRootPart").Anchored = true
				end
					
				if player.Character:WaitForChild("Humanoid").Sit then
					player.Character:WaitForChild("Humanoid").Sit = false
				end
					
				if not nextCaptian and actualCaptain then
					local npcRp = actualCaptain.HumanoidRootPart or nil
					if npcRp then
					
					local distance = (player.Character:WaitForChild("HumanoidRootPart").Position - npcRp.Position).magnitude
					local timeTween = distance / speedMarineShip
							
					if distance < 3 then
							
						local angle = 8 * (fullCircle / 8)
						local x, z = getXAndZPositions(angle)
						local position = (npcRp.CFrame * CFrame.new(x, 0, z)).p
						local lookAt = npcRp.Position
						tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
							CFrame = CFrame.new(position,lookAt)
						})
						tweenGlobal:Play()
								
						tweenGlobal.Completed:Wait()
						player.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)	
						if styleSeletect[2] then
							styles[styleSeletect[1]](actualCaptain)
						else
							if getStyleEquiped() then
								styles[styleSeletect[1]](actualCaptain)
							end
						end
						sequence = sequence + 1
						if sequence == 5 then
							sequence = 1
						end	
				   else	
						tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
							CFrame = npcRp.CFrame
						})
						tweenGlobal:Play()
						player.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,0,0)	
					end
				end
				end	
				
			end
		end
	},
	["Water walk"] = {
		false,
		function()
			local part = Instance.new("Part")
			part.Name = "walkWater"
			part.Size = water.Size + Vector3.new(0,50,0)
			part.Anchored = true
			part.CanCollide = true
			part.Transparency = 1
			part.Position = water.Position - Vector3.new(0,25,0) 
			part.Parent = workspace
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Water walk"][1] and part do
				part.Position = water.Position - Vector3.new(0,25,0) 
			end
			part:Destroy()
		end
	},
	["Auto store"] = {
		false,
		function()
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Auto store"][1] do
				local f = backacpkFruits()
				if f then
					fruitGot = true
					player.Character:WaitForChild("Humanoid"):EquipTool(f)
					EventStoreFruits:InvokeServer()
					fruitGot = false
				end	
				runService.Heartbeat:Wait()
			end
		end
	},
	["Auto Buso"] = {
		false,
		function()
			while runService.Heartbeat:Wait() and game.CoreGui[randomTitle] and scriptFunctions["Auto Buso"][1] do
				if statsPlayer:FindFirstChild("BusoBar") then
					local maxHaki = statsPlayer:FindFirstChild("BusoBar")
					if maxHaki and maxHaki.MaxValue > 0 then
						if maxHaki.Value == maxHaki.MaxValue then
							local A_1 = "Buso"
							EventHaki:FireServer(A_1)
						end
					end
				end
			end
		end
	}
}

local function teleportFunction(position)
	local distance = (player.Character:WaitForChild("HumanoidRootPart").Position - position).magnitude
	local timeTween = distance / speedIslandTp
	tweenGlobal = tweenService:Create(player.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(timeTween,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{
		CFrame = CFrame.new(position)
	})
	tweenGlobal:Play()
end

local connections = {
	npcRemoved = NPC.ChildRemoved:Connect(function(child)
		if child == npcFocused then
			npcFocused = nil
		end
		if table.find(captiansQueue,child) then
			if child == actualCaptain then
				actualCaptain = nil
				nextCaptian = true
			end
			table.remove(captiansQueue,foundChild(child))
		end
	end),
	npcAdded = NPC.ChildAdded:Connect(function(child)
		if scriptFunctions["Marine Ships"][1] and not table.find(captiansQueue,child) and (child.Name == "Pirate Captain" or child.Name == "Marine Captain") and child:WaitForChild("Info"):WaitForChild("Hostile").Value then
			table.insert(captiansQueue,child)
		end
	end),
	antiAfk = player.Idled:connect(function()
		vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end),
	shipAdded = ships.ChildAdded:Connect(function(child)
		if child.Name == player.Name.."Ship" then
			myShip = child
		end
	end),
	shipRemoves = ships.ChildRemoved:Connect(function(child)
		if myShip and child == myShip then
			myShip = nil
		end
	end),
	died = player.CharacterAdded:Connect(function(character)
		if character.Parent == nil then
			character.AncestryChanged:Wait()
		end
	end)
}


local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local UI = Material.Load({
	Title = randomTitle,
	Style = 2,
	SizeX = 400,
	SizeY = 350,
	Theme = "Dark"
})

game.CoreGui:WaitForChild(randomTitle).ResetOnSpawn = false

local Misc = UI.New({
	Title = "Misc"
})

UI.Banner({
	Text = "YES THAT HAVE ANTI AFK,That is a free script for gpo, enjoy, F YOU PHOEYU I USE EXPLOIT WHEN I WANT G E T D U N K E D O N"            
})

local AutoFarms = UI.New({
	Title = "AutoFarms"
})

local IslandTp = UI.New({
	Title = "TP Islands"
})

Misc.Button({
	Text = "Info",
	Callback = function()
		UI.Banner({
			Text = "YES THAT HAVE ANTI AFK,That is a free script for gpo, enjoy, F YOU PHOEYU I USE EXPLOIT WHEN I WANT G E T D U N K E D O N"            
		})
	end,
})

Misc.Button({
	Text = "Check Attempts",
	Callback = function()
		UI.Banner({
			Text = "Attempts: "..attempts.Value
		})
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Click to check how much attempts you have, if you have more than 1 so gpo logged you and you will be banned soon, thanks god my script is 100% bypass and gpo cant detect"            
			})
		end,
	}
})

Misc.Button({
	Text = "Destroy",
	Callback = function()
		for _,v in pairs(connections) do
			v:Disconnect()
		end
		game.CoreGui[randomTitle]:Destroy()
		if workspace.walkWater then
			workspace.walkWater:Destroy()
		end
	end,
	Information = function(self)
		UI.Banner({
			Text = "This will delet the gui, use that when have a new update so you dont need rejoin"            
		})
	end,
})

Misc.Toggle({
	Text = "Auto Style equip",
	Callback = function(value)
		scriptFunctions["Auto Style"][1] = value
		if value then
			scriptFunctions["Auto Style"][2]()
		end
	end,
	Enabled = false
})

Misc.Dropdown({
	Text = "Choose your style",
	Callback = function(value)
		if not getStyle(value) then
			UI.Banner({
				Text = "You dont have "..value            
			})
			error("no")
			return
		end
	end,
	Options = {"Melee", "Rokushiki", "BlackLeg", "Katana", "Electro", "Kiribachi"}
})

Misc.Toggle({
	Text = "Water walk",
	Callback = function(value)
		scriptFunctions["Water walk"][1] = value
		if value then
			scriptFunctions["Water walk"][2]()
		end
	end,
	Enabled = false
})


local autoStoreButton 
autoStoreButton = Misc.Toggle({
	Text = "Auto store DF",
	Callback = function(value)
		local s,res = pcall(MarketPlaceService.UserOwnsGamePassAsync,MarketPlaceService,player.UserId,12776768)
		if value and not res then
			UI.Banner({
				Text = "You dont have the bag gamepass"            
			})
			autoStoreButton:SetState(false)
			error("you dont have df gamepass")
		end
		scriptFunctions["Auto store"][1] = value
		if value then
			scriptFunctions["Auto store"][2]()
		end
	end,
	Enabled = false
})

AutoFarms.Slider({
	Text = "Auto farm speed",
	Callback = function(value)
		speedAutoFarm = value
	end,
	Min = 30,
	Max = 100,
	Def = 30
})

local autoHakiButton 
autoHakiButton = AutoFarms.Toggle({
	Text = "Auto Buso Haki",
	Callback = function(value)
		if value and not player:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Buso"):WaitForChild("BBar").Visible then
			UI.Banner({
				Text = "You dont have buso haki"            
			})
			autoHakiButton:SetState(false)
			error("you dont have haki")
		end
		scriptFunctions["Auto Buso"][1] = value
		if value then
			scriptFunctions["Auto Buso"][2]()
		end
	end,
	Enabled = false
})

AutoFarms.Toggle({
	Text = "NPCs",
	Callback = function(value)
		scriptFunctions["Auto Npc"][1] = value
		if value then
			scriptFunctions["Auto Npc"][2]()
		end
	end,
	Enabled = false
})

AutoFarms.DataTable({
	Text = "NPC List",
	Callback = function(data)
		for i,v in pairs(data)do
			npcFarming[i] = v
		end
	end,
	Options = {
		Bandit = false,
		["Bandit Boss"] = false,
		["Desert Bandit"] = false,
		["Lucid's Lad"] = false,
		["Lucid's Righthand"] = false,
		Lucid = false,
		["Krieg Pirate"] = false,
		["Zou Inhabitant"] = false,
		["Corrupt Marine"] = false,
		["Clown Pirate"] = false,
		["Monkey"] = false,
		["Sky District Bandit"] = false,
		["Castle Guard"] = false,
		["Sky Guardian"] = false
	}
})

AutoFarms.Toggle({
	Text = "Auto Quest",
	Callback = function(value)
		scriptFunctions["Auto Quest"][1] = value
	end,
	Enabled = false
})

AutoFarms.Dropdown({
	Text = "Choose your quest",
	Callback = function(value)
		questDoing[1] = value
	end,
	Options = {"Bandits","Bandit Boss","Desert Bandits","Lucid","Krieg Pirates","Corrupt Marines","Zou Inhabitants","Clown Pirate","Sky district bandits","Castle Guards","Sky Guardians"}
})



AutoFarms.Slider({
	Text = "Marine farm speed",
	Callback = function(value)
		speedMarineShip = value
	end,
	Min = 30,
	Max = 120,
	Def = 30
})

AutoFarms.Slider({
	Text = "Marine farm distance",
	Callback = function(value)
		marineFarmDistance = value
	end,
	Min = 1000,
	Max = 2000,
	Def = 1000
})

AutoFarms.Toggle({
	Text = "Marine Ships",
	Callback = function(value)
		scriptFunctions["Marine Ships"][1] = value
		if value then
			scriptFunctions["Marine Ships"][2]()
		else
			respawnShip = nil
			if autoFarmButton then
				autoFarmButton:SetText("Respawn ship Position")
			end	
		end
	end,
	Enabled = false
})

autoFarmButton = AutoFarms.Button({
	Text = "Respawn ship Position",
	Callback = function()
		respawnShip = player.Character:WaitForChild("HumanoidRootPart").CFrame
		autoFarmButton:SetText(tostring(player.Character:WaitForChild("HumanoidRootPart").Position))
	end,
	Menu = {
	Information = function(self)
		UI.Banner({
			Text = "When your ship get destroyed you will go to that position and spawn again, just click on button while you are on the position you want respawn"            
		})
	end
	}	
})

IslandTp.Slider({
	Text = "Island tp speed",
	Callback = function(value)
		speedIslandTp = value
	end,
	Min = 50,
	Max = 100,
	Def = 50
})

IslandTp.Button({
	Text = "Starter Island",
	Callback = function()
		teleportFunction(islands["Starter"])
	end,
	Menu = {
	Information = function(self)
		UI.Banner({
			Text = "Teleport you to start island"            
		})
	end
	}	
})

IslandTp.Button({
	Text = "Shells town",
	Callback = function()
		teleportFunction(islands["Shells"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to shells town island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Orange town",
	Callback = function()
		teleportFunction(islands["Orange"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Orange town island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Zou Island",
	Callback = function()
		teleportFunction(islands["Zou"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Zou island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Colosseum Island",
	Callback = function()
		teleportFunction(islands["Colosseum"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Colosseum island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Arlong Island",
	Callback = function()
		teleportFunction(islands["Arlong"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Arlong island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Sandora Island",
	Callback = function()
		teleportFunction(islands["Sandora"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Sandora island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Sphinx Island",
	Callback = function()
		teleportFunction(islands["Sphinx"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Sphinx island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Rokushiki Island",
	Callback = function()
		teleportFunction(islands["Mysterius"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Rokushiki island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Sky Island",
	Callback = function()
		teleportFunction(islands["Sky island"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Sky island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Roka Island",
	Callback = function()
		teleportFunction(islands["Roka"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Roka island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Kori Island/Yeti",
	Callback = function()
		teleportFunction(islands["Kori"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Kori/Yeti island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Marine Island",
	Callback = function()
		teleportFunction(islands["Marine"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Marine island"            
			})
		end
	}	
})

IslandTp.Button({
	Text = "Barratie Island",
	Callback = function()
		teleportFunction(islands["Barratie"])
	end,
	Menu = {
		Information = function(self)
			UI.Banner({
				Text = "Teleport you to Barratie island"            
			})
		end
	}	
})
