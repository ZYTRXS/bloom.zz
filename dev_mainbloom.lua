Bloom.Functions.ClearConnection("Input Started", Bloom.Connections)
Bloom.Functions.ClearConnection("Input Ended", Bloom.Connections)

Bloom.Functions.ClearConnection("Debris Added", Bloom.Connections)
Bloom.Functions.ClearConnection("VPart Added", Bloom.Connections)

Bloom.Functions.ClearConnection("Mouse Move", Bloom.Connections)
Bloom.Functions.ClearConnection("Main", Bloom.Connections)

warn("LOAD1")

local IsA                                                       = game.IsA
local GetChildren                                               = game.GetChildren
local WaitForChild                                              = game.WaitForChild
local FindFirstChild                                            = game.FindFirstChild
local FindFirstChildWhichIsA                                    = game.FindFirstChildWhichIsA

local NextInteger                                               = Bloom.Random.NextInteger
local NextNumber                                                = Bloom.Random.NextNumber
local WorldToScreenPoint                                        = Bloom.Camera.WorldToScreenPoint
local GetPlayers                                                = Bloom.Services.Players.GetPlayers
local Raycast                                                   = Bloom.Services.Workspace.Raycast

local RParams                                                   = RaycastParams.new()
local BParams                                                   = RaycastParams.new()
local TParams                                                   = RaycastParams.new()

local Toggles                                                   = getgenv().Toggles
local Options                                                   = getgenv().Options

local Projectiles                                               = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { Object = nil, BodyVelocity = nil, BodyGyro = nil } }
local Fly                                                       = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { BodyVelocity = nil, BodyGyro = nil } }

do
	TParams.FilterType                                          = Enum.RaycastFilterType.Exclude
	TParams.IgnoreWater                                         = true
	TParams.RespectCanCollide 								    = true
	TParams.FilterDescendantsInstances                          = { Bloom.Camera }
end do
	BParams.FilterType                                          = Enum.RaycastFilterType.Exclude
	BParams.IgnoreWater                                         = true
	BParams.RespectCanCollide                                   = true
	BParams.FilterDescendantsInstances                          = { Bloom.Services.Workspace.Characters, Bloom.Camera }
end do
	RParams.FilterType                                          = Enum.RaycastFilterType.Exclude
	RParams.IgnoreWater                                         = true
	RParams.RespectCanCollide                                   = true
end

-- #Region // Projectile - Fly
Bloom.Functions.NewConnection("VPart Added", Bloom.Connections, Bloom.Services.Workspace.Debris.VParts.ChildAdded, function(Object)
	task.wait()

	if (Object.Name == "RPG_Rocket" and Toggles.RLController.Value) then
		Bloom.Camera.CameraSubject 						    = Object
		Bloom.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)

		local BV 											    = Instance.new("BodyVelocity", Object)
		BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
		BV.Velocity 										    = Vector3.new()

		local BG 											    = Instance.new("BodyGyro", Object)
		BG.D 												    = 750
		BG.P 												    = 50000
		BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "GrenadeLauncherGrenade" and Toggles.GLController.Value) then
		Bloom.Camera.CameraSubject 						    = Object
		Bloom.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)

		local BV 											    = Instance.new("BodyVelocity", Object)
		BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
		BV.Velocity 										    = Vector3.new()

		local BG 											    = Instance.new("BodyGyro", Object)
		BG.D 												    = 750
		BG.P 												    = 50000
		BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "TransIgnore" and Toggles.C4Controller.Value) then
		Bloom.Camera.CameraSubject 						    = Object
		Bloom.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)

		local BV 											    = Instance.new("BodyVelocity", Object)
		BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
		BV.Velocity 										    = Vector3.new()

		local BG 											    = Instance.new("BodyGyro", Object)
		BG.D 												    = 750
		BG.P 												    = 50000
		BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end
end)

Bloom.Functions.NewConnection("Debris Added", Bloom.Connections, Bloom.Services.Workspace.Debris.ChildAdded, function(Object)
	task.wait()

	if (not FindFirstChild(Object, "Creator")) then return end
	if (Object.Creator.Value ~= Bloom.Client) then return end

	Projectiles.Current.BodyVelocity						    = nil
	Projectiles.Current.BodyGyro							    = nil
	Projectiles.Current.Object								    = nil

	Bloom.Camera.CameraSubject 							    = Bloom.Client.Character.Humanoid
	Bloom.Client.Character.HumanoidRootPart.Anchored 		    = false
end)

Bloom.Functions.NewConnection("Input Began", Bloom.Connections, Bloom.Services.UserInputService.InputBegan, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 1
		Fly.Forward 	                                        = 1
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = -1
		Fly.Backward 	                                        = -1
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 1
		Fly.Right 	                                            = 1
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = -1
		Fly.Left 	                                            = -1
	end
end)

Bloom.Functions.NewConnection("Input Ended", Bloom.Connections, Bloom.Services.UserInputService.InputEnded, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 0
		Fly.Forward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = 0
		Fly.Backward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 0
		Fly.Right 	                                            = 0
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = 0
		Fly.Left 	                                            = 0
	end
end)
-- #EndRegion

-- #Region // Checks Functions
Bloom.Functions.EquippedGun                                    = function(Character)
	local Character                                             = Character

	if not Character then return end

	if not FindFirstChildWhichIsA(Character, "Tool") then return false end
	if not FindFirstChild(FindFirstChildWhichIsA(Character, "Tool"), "Client") then return false end
	if not FindFirstChild(FindFirstChildWhichIsA(Character, "Tool"), "GunClient") then return false end

	return true
end

Bloom.Functions.EquippedMelee                                  = function(Character)
	local Character                                             = Character

	if not Character then return end

	if not FindFirstChildWhichIsA(Character, "Tool") then return false end
	if not FindFirstChild(FindFirstChildWhichIsA(Character, "Tool"), "Client") then return false end        
	if not FindFirstChild(FindFirstChildWhichIsA(Character, "Tool"), "MeleeClient") then return false end

	return true
end

Bloom.Functions.ValidCheck                                     = function(Character)
	local Character                                             = Character

	if not Character then return end

	if not FindFirstChild(Character, "Humanoid") then return false end
	if not FindFirstChild(Character, "HumanoidRootPart") then return false end
	if FindFirstChild(Character, "Humanoid").Health <= 0 then return false end

	return true
end

Bloom.Functions.ForceFieldCheck                                = function(Character)
	local Character                                             = Character

	if not Character then return end

	return FindFirstChildWhichIsA(Character, "ForceField") ~= nil
end
warn("LOAD2")

Bloom.Functions.DownedCheck                                    = function(Character)
	if not FindFirstChild(Bloom.Services.ReplicatedStorage.CharStats, Character.Name) then return true end

	return Bloom.Services.ReplicatedStorage.CharStats[Character.Name].Downed.Value
end

Bloom.Functions.FriendlyCheck                                  = function(Player)
	return Player.IsFriendsWith(Player, Bloom.Client.UserId)
end

Bloom.Functions.VisibleCheck                                   = function(Character, Limb, Method)
	if (Method == "Wallbang") and (Character.HumanoidRootPart.Position - Bloom.Client.Character.HumanoidRootPart.Position).Magnitude < 1000000 then return true end
	if (Method == "None") then return true end

	if not Bloom.Functions.EquippedGun(Bloom.Client.Character) then return false end

	local Tool                                                  = FindFirstChildWhichIsA(Bloom.Client.Character, "Tool")
	local Handle 												= FindFirstChild(Tool, "WeaponHandle") or FindFirstChild(Tool, "Handle")
	local FirePosition 											= Handle and FindFirstChild(Handle, "FirePos")

	if not Tool then return false end
	if not Handle then return false end
	if not FirePosition then return false end

	local Fire                                                  = (FirePosition.WorldCFrame * CFrame.new(0, 15, 0)).p
	local Result                                                = Bloom.Functions.Raycast(Fire, Limb.Position - Fire, {
		Bloom.Client.Character,
		Bloom.Camera,
		Character,

		Bloom.Services.Workspace.Debris,
		Bloom.Services.Workspace.Filter,
		Bloom.Services.Workspace.Characters,
		Bloom.Services.Workspace.Map.Parts.Grinders,

		FindFirstChild(Bloom.Services.Workspace.Map, "VendingMachines"),
		FindFirstChild(Bloom.Services.Workspace.Map, "StreetLights"),
		FindFirstChild(Bloom.Services.Workspace.Map, "BredMakurz"),
		FindFirstChild(Bloom.Services.Workspace.Map, "Security"),
		FindFirstChild(Bloom.Services.Workspace.Map, "Doors"),
		FindFirstChild(Bloom.Services.Workspace.Map, "Shopz"),
		FindFirstChild(Bloom.Services.Workspace.Map, "ATMz")
	})

	if Result then
		return false
	else
		return true
	end
end
-- #EndRegion

-- #Region // Bloom Functions
Bloom.Functions.Unload                                         = function()
	cleardrawcache()
	Bloom.Functions.ClearConnections(Bloom.Connections)
	Bloom.Functions.ClearHooks(Bloom.Hooks)
end

Bloom.Functions.RandomString                                   = function(Length)
	local Result    = ""

	for i = 1, Length do
		Result = Result .. string.char(NextInteger(Bloom.Random, 97, 122))
	end

	return Result
end

Bloom.Functions.ReturnInteractiveProp                          = function(Folder, Max)
	local Prop                                                  = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Map[Folder]:GetChildren() do
		if not FindFirstChild(Object, "MainPart") then continue end

		if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Prop                                                    = Object
		Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Prop
end

Bloom.Functions.ReturnCash                                     = function(Max)
	local Cash                                                  = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Filter.SpawnedBread:GetChildren() do
		if (Object.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Cash                                                    = Object
		Distance                                                = (Object.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Cash
end

Bloom.Functions.ReturnScrap                                    = function(Max)
	local Scrap                                                 = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
		if not string.find(Object.Name, "S") then continue end
		if not Object.PrimaryPart then continue end
		if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Scrap                                                   = Object
		Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Scrap
end

Bloom.Functions.ReturnCrate                                    = function(Max)    
	local Crate                                                 = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
		if not string.find(Object.Name, "C") then continue end
		if not Object.PrimaryPart then continue end
		if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Crate                                                   = Object
		Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Crate
end

warn("LOAD2")

Bloom.Functions.ReturnTool                                     = function(Max)
	local Tool                                                  = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Filter.SpawnedTools:GetChildren() do
		if not Object.PrimaryPart then continue end
		if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Tool                                                    = Object
		Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Tool
end

Bloom.Functions.ReturnBreadMaker                               = function(Type, Max)
	local BreakMaker                                            = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Map.BredMakurz:GetChildren() do
		if not FindFirstChild(Object, "MainPart") then continue end
		if not FindFirstChild(Object, "Values") then continue end

		if not string.find(Object.Name, Type) then continue end
		if Object.Values.Broken.Value then continue end

		if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		BreakMaker                                              = Object
		Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return BreakMaker
end

Bloom.Functions.ReturnDoor                                     = function(Max)
	local Door                                                  = nil
	local Distance                                              = Max or math.huge

	local Client                                                = Bloom.Client
	local Character                                             = Client.Character

	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	for Index, Object in next, Bloom.Services.Workspace.Map.Doors:GetChildren() do
		if not FindFirstChild(Object, "DFrame") then continue end
		if not FindFirstChild(Object, "Values") then continue end
		if not FindFirstChild(Object.Values, "Locked") then continue end
		if not FindFirstChild(Object.Values, "Broken") then continue end

		if Object.Values.Broken.Value then continue end
		if not Object.Values.Locked.Value then continue end

		if (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

		Door                                                    = Object
		Distance                                                = (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude
	end

	return Door
end

Bloom.Functions.CreateChams 								= function(char)
	for _, Limbs in char:GetChildren() do
		if Limbs:IsA("Part") then

			local Player = Bloom.Services.Players:GetPlayerFromCharacter(char)
			local ChamInside = Instance.new("BoxHandleAdornment")
			local ChamOutside = Instance.new("BoxHandleAdornment")

			ChamInside.Color3 = Options.OccludedVC.Value
			ChamInside.Transparency = 0.6

			ChamInside.Adornee = Limbs
			ChamInside.Size = Limbs.Size
			ChamInside.AlwaysOnTop = true
			ChamInside.Parent = Limbs
			ChamInside.ZIndex = 5
			ChamInside.Visible = Toggles.ChamsV.Value

			ChamOutside.Color3 = Options.VisibleC.Value
			ChamOutside.Transparency = 0

			ChamOutside.Adornee = Limbs
			ChamOutside.Size = Vector3.new(Limbs.Size.X + 0.2, Limbs.Size.Y + 0.2, Limbs.Size.Z + 0.2)
			ChamOutside.AlwaysOnTop = true
			ChamOutside.Parent = Limbs
			ChamOutside.ZIndex = -1
			ChamOutside.Visible = Toggles.ChamsV.Value

			task.spawn(function()
				while ChamInside ~= nil do
					task.wait()

					ChamInside.Color3 = Options.OccludedVC.Value
					ChamOutside.Color3 = Bloom.Functions.TargetCheck(Player, "CHAMS") and Options.PlayerTC.Value or Bloom.Functions.PrioritizeCheck(Player, "CHAMS") and Options.PlayerPTC.Value or Bloom.Functions.FriendCheck(Player, "CHAMS") and Options.PlayerFTC.Value or Options.VisibleC.Value

					if Toggles.ChamsV.Value then
						ChamInside.Visible = Toggles.OccludedV.Value
						ChamOutside.Visible = Toggles.VisibleV.Value
					else
						ChamInside.Visible = false
						ChamInside.Visible = false
					end
				end
			end)
		end
	end
end

Bloom.Functions.LocalCharacter                                 = function(Character)
	local HumanoidRootPart                                      = WaitForChild(Character, "HumanoidRootPart")
	local Humanoid                                              = WaitForChild(Character, "Humanoid")
	local Torso                                                 = WaitForChild(Character, "Torso")
	local Head                                                  = WaitForChild(Character, "Head")
	local Part                                                  = WaitForChild(Torso, "Part")

	task.wait(0.5)

	for _, Connection in pairs(getconnections(HumanoidRootPart.ChildAdded)) do
		Connection:Disable()
	end

	for _, Connection in pairs(getconnections(HumanoidRootPart.DescendantAdded)) do
		Connection:Disable()
	end

	for _, Object in next, GetChildren(Torso) do
		if not IsA(Object, "Motor6D") then continue end

		Object:GetPropertyChangedSignal("Enabled"):Connect(function(Value)
			if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
			if Value then return end

			Object.Enabled                                      = true
		end)
	end

	Head.ChildAdded:Connect(function(Object)
		task.wait()

		if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
		if not string.find(Object.Name, "Scream") then return end

		Object:Destroy()
	end)

	Part.CanCollide                                             = false
	Bloom.Functions.SpinBot(Bloom.Client, Character)
end

Bloom.Functions.Shoot                                          = function(Target)
	if not isrbxactive() then return end
	if not Toggles.TriggerBot.Value then return end
	if not Bloom.Functions.EquippedGun(Character) then return end
	if Options.TriggerBotShootChance.Value <= NextInteger(Bloom.Random, 1, 100) then return end

	local Character                                             = Target
	local Target												= Bloom.Services.Players:GetPlayerFromCharacter(Target)
	local Tool 													= FindFirstChildWhichIsA(Bloom.Client.Character, "Tool")

	if Bloom.Functions.ForceFieldCheck(Character) then return end
	if Bloom.Functions.DownedCheck(Character) and Toggles.TriggerBotDowned.Value then return end
	if Bloom.Functions.FriendlyCheck(Target) and Toggles.TriggerBotFriendly.Value then return end

	Tool:Activate()

	task.wait()

	if not FindFirstChildWhichIsA(Bloom.Client.Character, "Tool") then return end

	Tool:Deactivate()
end

Bloom.Functions.GunAnimation                                   = function(Tool, Name)
	-- // Remake
end

Bloom.Functions.GunSound                                       = function(Tool, Directory, Name)
	if not FindFirstChild(Tool, "WeaponHandle") then return end
	if not FindFirstChild(Tool.WeaponHandle, Directory) then return end
	if not FindFirstChild(Tool.WeaponHandle[Directory], Name) then return end

	local Clone                                                 = Tool.WeaponHandle[Directory][Name]:Clone()
	Clone.Name                                                  = string.format("%s_Clone", Name)
	Clone.Parent                                                = Bloom.Client.Character.HumanoidRootPart
	Clone.PlaybackSpeed                                         = NextNumber(Bloom.Random, 0.8, 1.2)
	Clone:Play()

	Bloom.Services.Debris:AddItem(Clone, Clone.TimeLength)
end

Bloom.Functions.Raycast										= function(Origin, Direction, Blacklist)
	RParams.FilterDescendantsInstances                     	 	= Blacklist

	local Result 												= Raycast(Bloom.Services.Workspace, Origin, Direction, RParams)

	if Result and Result.Instance then
		table.insert(Blacklist, Result.Instance)

		if Result.Instance:FindFirstChild("FilterV") then
			return Bloom.Functions.Raycast(Origin, Direction, Blacklist)
		end

		if Result.Instance.Transparency == 1 then
			return Bloom.Functions.Raycast(Origin, Direction, Blacklist)
		end

		if not Result.Instance.CanCollide then
			return Bloom.Functions.Raycast(Origin, Direction, Blacklist)
		end

		if 
			Bloom.Services.CollectionService.HasTag(Bloom.Services.CollectionService, Result.Instance, "MainIgnorePart") or 
			Bloom.Services.CollectionService.HasTag(Bloom.Services.CollectionService, Result.Instance, "MainIgnorePart_1") or 
			Bloom.Services.CollectionService.HasTag(Bloom.Services.CollectionService, Result.Instance, "MainIgnorePart_2") or 
			Bloom.Services.CollectionService.HasTag(Bloom.Services.CollectionService, Result.Instance, "MainIgnorePart_3") 
		then

			return Bloom.Functions.Raycast(Origin, Direction, Blacklist)
		end

		return true
	else
		return false
	end
end

warn("LOAD3")

Bloom.Functions.Return = function(Methods, Checks, Lengths, Limbs)
	local Methods = Methods or { Get = "Character", Part = "Random", Visible = "Default" }
	local Checks = Checks or { Downed = true, Friendly = true }
	local Limbs = Limbs or {}

	local Target, Distance, Limb = nil, nil, nil

	local function IsInTable(tbl, player)
		for _, p in pairs(tbl) do
			if p == player then
				return true
			end
		end
		return false
	end

	local function TryFindTarget(PlayerList, useMouse)
		for Index, Player in next, GetPlayers(Bloom.Services.Players) do
			if Player == Bloom.Client then continue end
			if not IsInTable(PlayerList, Player.Name) then continue end

			if not Bloom.Functions.ValidCheck(Player.Character) then continue end
			if Bloom.Functions.ForceFieldCheck(Player.Character) then continue end
			if Checks.Downed and Bloom.Functions.DownedCheck(Player.Character) then continue end
			if Checks.Friendly and Bloom.Functions.FriendlyCheck(Player) then continue end

			local Total = #Limbs <= 0 and { Player.Character["Torso"] } or {}
			local Selected = nil
			local CharacterBetween = (Player.Character.HumanoidRootPart.Position - Bloom.Client.Character.HumanoidRootPart.Position).Magnitude

			if useMouse then
				local Data = {}
				local Vector, OnScreen = WorldToScreenPoint(Bloom.Camera, Player.Character.HumanoidRootPart.Position)
				local MouseBetween = (Vector2.new(Bloom.Mouse.X, Bloom.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
				if not OnScreen then continue end

				for _, Object in next, Limbs do
					if not FindFirstChild(Player.Character, Object) then continue end
					local Limb = FindFirstChild(Player.Character, Object)
					local Vector, OnScreen = WorldToScreenPoint(Bloom.Camera, Limb.Position)
					local Difference = (Vector2.new(Bloom.Mouse.X, Bloom.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
					table.insert(Total, Limb)
					if not OnScreen then continue end
					Data[Player.Character[Object]] = Difference
				end

				if not Selected then Selected = Player.Character["Torso"] end
				if not Distance then Distance = Lengths.Mouse end

				if (MouseBetween <= Distance) and (CharacterBetween <= Lengths.Character) then
					for LimbObj, Difference in next, Data do
						if not LimbObj then continue end
						if not Difference then continue end
						if Difference >= Distance then continue end
						Distance = Difference
						Selected = LimbObj
					end

					if Checks.Visible and not Bloom.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

					Target = Player.Character
					Distance = MouseBetween
					Limb = Selected
					return true
				end
			else
				for _, Object in next, Limbs do
					if not FindFirstChild(Player.Character, Object) then continue end
					table.insert(Total, Player.Character[Object])
				end

				if not Selected then Selected = Total[NextInteger(Bloom.Random, 1, #Total)] end
				if not Distance then Distance = Lengths.Character end

				if (CharacterBetween <= Distance) then
					if Checks.Visible and not Bloom.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

					Target = Player.Character
					Distance = CharacterBetween
					Limb = Selected
					return true
				end
			end
		end
		return false
	end

	local TargetPlayers = Options.TargetD.GetActiveValues(Options.TargetD)
	local PrioritizePlayers = Options.PrioritizeD.GetActiveValues(Options.PrioritizeD)

	if Methods.Get == "Mouse" then
		if not TryFindTarget(TargetPlayers, true) then
			if not TryFindTarget(PrioritizePlayers, true) then
				for Index, Player in next, GetPlayers(Bloom.Services.Players) do
					if Player == Bloom.Client then continue end
					if not Bloom.Functions.ValidCheck(Player.Character) then continue end
					if Bloom.Functions.ForceFieldCheck(Player.Character) then continue end
					if Checks.Downed and Bloom.Functions.DownedCheck(Player.Character) then continue end
					if Checks.Friendly and Bloom.Functions.FriendlyCheck(Player) then continue end

					local Data = {}
					local Total = #Limbs <= 0 and { Player.Character["Torso"] } or {}
					local Selected = nil

					local Vector, OnScreen = WorldToScreenPoint(Bloom.Camera, Player.Character.HumanoidRootPart.Position)
					local MouseBetween = (Vector2.new(Bloom.Mouse.X, Bloom.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
					local CharacterBetween = (Player.Character.HumanoidRootPart.Position - Bloom.Client.Character.HumanoidRootPart.Position).Magnitude

					if not OnScreen then continue end

					for _, Object in next, Limbs do
						if not FindFirstChild(Player.Character, Object) then continue end

						local Limb = FindFirstChild(Player.Character, Object)
						local Vector, OnScreen = WorldToScreenPoint(Bloom.Camera, Limb.Position)
						local Difference = (Vector2.new(Bloom.Mouse.X, Bloom.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude

						table.insert(Total, Limb)

						if not OnScreen then continue end

						Data[Player.Character[Object]] = Difference
					end

					if not Selected then Selected = Player.Character["Torso"] end
					if not Distance then Distance = Lengths.Mouse end

					if (MouseBetween <= Distance) and (CharacterBetween <= Lengths.Character) then
						for LimbObj, Difference in next, Data do
							if not LimbObj then continue end
							if not Difference then continue end
							if Difference >= Distance then continue end

							Distance = Difference
							Selected = LimbObj
						end

						if Checks.Visible and not Bloom.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

						Target = Player.Character
						Distance = MouseBetween
						Limb = Selected
					end
				end
			end
		end
	end

	if Methods.Get == "Character" then
		if not TryFindTarget(TargetPlayers, false) then
			if not TryFindTarget(PrioritizePlayers, false) then
				for Index, Player in next, GetPlayers(Bloom.Services.Players) do
					if Player == Bloom.Client then continue end
					if not Bloom.Functions.ValidCheck(Player.Character) then continue end
					if Bloom.Functions.ForceFieldCheck(Player.Character) then continue end
					if Checks.Downed and Bloom.Functions.DownedCheck(Player.Character) then continue end
					if Checks.Friendly and Bloom.Functions.FriendlyCheck(Player) then continue end

					local Total = #Limbs <= 0 and { Player.Character["Torso"] } or {}
					local Selected = nil
					local CharacterBetween = (Player.Character.HumanoidRootPart.Position - Bloom.Client.Character.HumanoidRootPart.Position).Magnitude

					for _, Object in next, Limbs do
						if not FindFirstChild(Player.Character, Object) then continue end
						table.insert(Total, Player.Character[Object])
					end

					if not Selected then Selected = Total[NextInteger(Bloom.Random, 1, #Total)] end
					if not Distance then Distance = Lengths.Character end

					if (CharacterBetween <= Distance) then
						if Checks.Visible and not Bloom.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

						Target = Player.Character
						Distance = CharacterBetween
						Limb = Selected
					end
				end
			end
		end
	end

	if not Target then return end
	if not Distance then return end
	if not Limb then return end

	return Target, Distance, Limb
end

-- #EndRegion

-- #Region // Main Functions
Bloom.Functions.ProjectileController                           = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not Projectiles.Current.BodyVelocity then return end
	if not Projectiles.Current.BodyGyro then return end
	if not Projectiles.Current.Object then return end

	if not isnetworkowner(Projectiles.Current.Object) then
		Projectiles.Current.BodyVelocity:Destroy()
		Projectiles.Current.BodyGyro:Destroy()
		Projectiles.Current.Object:Destroy()            

		return
	end

	Projectiles.Current.BodyGyro.CFrame 					    = Bloom.Camera.CFrame
	Projectiles.Current.BodyVelocity.Velocity				    = ((Bloom.Camera.CFrame.LookVector * Projectiles.Forward) + (Bloom.Camera.CFrame.LookVector * Projectiles.Backward) + (Bloom.Camera.CFrame.RightVector * Projectiles.Right) + (Bloom.Camera.CFrame.RightVector * Projectiles.Left)) * Options.ProjectileSpeed.Value
	Bloom.Camera.CFrame 									    = Projectiles.Current.Object.CFrame * CFrame.new(Vector3.new(0, 2, 3))
end

Bloom.Functions.FlyController                                  = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "HumanoidRootPart") then return end
	if not FindFirstChild(Character, "Humanoid") then return end

	if not Toggles.Fly.Value then return end
	if not Bloom.Cooldowns.Fly then Bloom.Cooldowns.Fly = tick() end

	if not Fly.Current then return end
	if not Fly.Current.BodyGyro then return end
	if not Fly.Current.BodyVelocity then return end

	Character.Humanoid.AutoRotate                               = false
	Fly.Current.BodyGyro.CFrame 					            = Bloom.Camera.CFrame
	Fly.Current.BodyVelocity.Velocity				            = ((Bloom.Camera.CFrame.LookVector * Fly.Forward) + (Bloom.Camera.CFrame.LookVector * Fly.Backward) + (Bloom.Camera.CFrame.RightVector * Fly.Right) + (Bloom.Camera.CFrame.RightVector * Fly.Left)) * Options.FlySpeed.Value

	if ((tick() - Bloom.Cooldowns.Fly) > 1) and (Options.FlyMethod.Value == "Bypass") then
		Bloom.Cooldowns.Fly                                    = tick()
		Bloom.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
			"-r__r2", 
			Vector3.new(0, 0, 0), 
			Character.HumanoidRootPart.CFrame
		)
	end
end

Bloom.Functions.Stats                                          = function(Client, Character)
	if not Client then return end
	if not Character then return end
	if not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end

	local Stats                                                 = FindFirstChild(Bloom.Services.ReplicatedStorage.CharStats, Client.Name)
	local Humanoid                                              = FindFirstChild(Character, "Humanoid")
	local HumanoidRootPart                                      = FindFirstChild(Character, "HumanoidRootPart")

	if not Bloom.Cooldowns.Stats then Bloom.Cooldowns.Stats = tick() end
	if not Stats then return end
	if not Humanoid then return end
	if not HumanoidRootPart then return end

	Stats.RagdollTime.Value                                     = 0
	Stats.RagdollTime.RagdollSwitch2.Value                      = false
	Stats.RagdollTime.RagdollSwitch.Value                       = false
	Stats.RagdollTime.SRagdolled.Value                          = false

	if ((tick() - Bloom.Cooldowns.Stats) > 1) and (Options.StatsMethod.Value == "Bypass") then
		Bloom.Cooldowns.Stats                                  = tick()
		Bloom.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
			"-r__r2", 
			Vector3.new(0, 0, 0), 
			Character.HumanoidRootPart.CFrame
		)
	end
end

Bloom.Functions.BHop                                           = function(Client, Character)
	if not Client then return end
	if not Character then return end
	if not Toggles.BHop.Value then return end
	if not FindFirstChild(Character, "HumanoidRootPart") then return end

	local Result                                                = Raycast(Bloom.Services.Workspace, Character.HumanoidRootPart.Position, Vector3.new(0, -3.25, 0), BParams)

	if not Result then return end
	if not Result.Instance then return end

	Character.HumanoidRootPart.Velocity                         = Vector3.new(Character.HumanoidRootPart.Velocity.X, 32.5, Character.HumanoidRootPart.Velocity.Z)
end

Bloom.Functions.Fly                                            = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not FindFirstChild(Character, "Humanoid") then return end
	if not FindFirstChild(Character, "HumanoidRootPart") then return end

	if Toggles.Fly.Value then
		if Fly.Current.BodyGyro then return end
		if Fly.Current.BodyVelocity then return end

		Fly.Current.BodyVelocity                                = Instance.new("BodyVelocity", Character.HumanoidRootPart)
		Fly.Current.BodyGyro                                    = Instance.new("BodyGyro", Character.HumanoidRootPart)

		Fly.Current.BodyGyro.MaxTorque                          = Vector3.new(math.huge, math.huge, math.huge)
		Fly.Current.BodyGyro.D                                  = 500
		Fly.Current.BodyGyro.P                                  = 90000

		Fly.Current.BodyVelocity.P                              = 1250
		Fly.Current.BodyVelocity.MaxForce                       = Vector3.new(math.huge, math.huge, math.huge)
		Fly.Current.BodyVelocity.Velocity                       = Vector3.new(0, 0, 0)

		Fly.Current.BodyGyro.Name                               = Bloom.Functions.RandomString(30)
		Fly.Current.BodyVelocity.Name                           = Bloom.Functions.RandomString(30)
	end

	if not Toggles.Fly.Value then
		if not Fly.Current.BodyGyro then return end
		if not Fly.Current.BodyVelocity then return end

		Fly.Current.BodyGyro:Destroy()
		Fly.Current.BodyVelocity:Destroy()

		Fly.Current.BodyGyro                                    = nil
		Fly.Current.BodyVelocity                                = nil

		Character.Humanoid.AutoRotate                           = true
	end
end

warn("LOAD4")

Bloom.Functions.SpinBot                                        = function(Client, Character)
	if not Client then return end
	if not Character then return end
	if not FindFirstChild(Character, "HumanoidRootPart") then return end

	if Toggles.SBot.Value then
		if FindFirstChild(Character.HumanoidRootPart, "SpinBot") then 
			Character.HumanoidRootPart.SpinBot.AngularVelocity  = Vector3.new(0, Options.SpinSpeed.Value ,0)

			return 
		end

		local Angular                                           = Instance.new("BodyAngularVelocity")
		Angular.Name                                            = "SpinBot"
		Angular.Parent                                          = Character.HumanoidRootPart
		Angular.MaxTorque                                       = Vector3.new(0, math.huge, 0)
		Angular.AngularVelocity                                 = Vector3.new(0, Options.SpinSpeed.Value ,0)
	end

	if not Toggles.SBot.Value then
		if not FindFirstChild(Character.HumanoidRootPart, "SpinBot") then return end

		Character.HumanoidRootPart.SpinBot:Destroy()
	end
end

Bloom.Functions.TriggerBot                                     = function(Client, Character)
	if not Client then return end
	if not Character then return end
	if not Toggles.TriggerBot.Value then return end

	local Delay 												= (Options.TriggerBotDelay.Value / 1000)
	local Randomized 											= (NextNumber(Bloom.Random, 0, Options.TriggerBotDelayBS.Value) / 1000)

	local Point 												= Bloom.Camera:ScreenPointToRay(Bloom.Mouse.X, Bloom.Mouse.Y)
	local Result 												= Raycast(Bloom.Services.Workspace, Point.Origin, Point.Direction * 500, TParams)

	if not Result then return end
	if not Result.Instance then return end
	if not Result.Instance.Parent then return end
	if not Result.Instance.Parent.Parent then return end

	local Target 												= Result.Instance
	local Player 												= Bloom.Services.Players:GetPlayerFromCharacter(Target.Parent)

	if Target.Name == "Handle" then
		TParams:AddToFilter(Target)

		return
	end

	if Target.Parent.Parent ~= Bloom.Services.Workspace.Characters then return end
	if not table.find(Options.TriggerBotParts:GetActiveValues(), Target.Name) then return end
	if not Bloom.Functions.VisibleCheck(Target.Parent, Target, "Default") then return end
	if (Player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude >= Options.TriggerBotDistance.Value then return end

	task.delay(Delay + Randomized, function()
		Bloom.Functions.Shoot(Target.Parent)
	end)
end

Bloom.Functions.AutoPickScraps                                 = function(Client, Character)
	if not Toggles.AutoPickScraps.Value then return end
	if Bloom.Cooldowns.PickUp then return end

	if not Client then return end
	if not Character then return end

	local Scrap                                                 = Bloom.Functions.ReturnScrap(Options.AutoPickRange.Value)

	if not Scrap then return end

	Bloom.Cooldowns.PickUp                                     = true

	task.wait(0.25 + Options.AutoPickDelay.Value)

	if not Scrap then Bloom.Cooldowns.PickUp = false return end

	Bloom.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Scrap:GetAttribute("jzu")))
	Bloom.Cooldowns.PickUp                                     = false
end

Bloom.Functions.AutoPickCrates                                 = function(Client, Character)
	if not Toggles.AutoPickCrates.Value then return end
	if Bloom.Cooldowns.PickUp then return end

	if not Client then return end
	if not Character then return end

	local Crate                                                 = Bloom.Functions.ReturnCrate(Options.AutoPickRange.Value)

	if not Crate then return end

	Bloom.Cooldowns.PickUp                                     = true

	task.wait(0.25 + Options.AutoPickDelay.Value)

	if not Crate then Bloom.Cooldowns.PickUp = false return end

	Bloom.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Crate:GetAttribute("jzu")))
	Bloom.Cooldowns.PickUp                                     = false
end

Bloom.Functions.AutoPickTools                                  = function(Client, Character)
	if not Toggles.AutoPickTools.Value then return end
	if Bloom.Cooldowns.PickUp then return end

	if not Client then return end
	if not Character then return end

	local Tool                                                  = Bloom.Functions.ReturnTool(Options.AutoPickRange.Value)

	if not Tool then return end

	Bloom.Cooldowns.PickUp                                     = true

	task.wait(0.25 + Options.AutoPickDelay.Value)

	if not Tool then Bloom.Cooldowns.PickUp = false return end

	Bloom.Services.ReplicatedStorage.Events.PIC_TLO:FireServer(Tool.PrimaryPart)
	Bloom.Cooldowns.PickUp                                     = false
end 

Bloom.Functions.AutoPickCash                                   = function(Client, Character)
	if not Toggles.AutoPickCash.Value then return end
	if Bloom.Cooldowns.PickUp then return end

	if not Client then return end
	if not Character then return end

	local Cash                                                  = Bloom.Functions.ReturnCash(Options.AutoPickRange.Value)

	if not Cash then return end

	Bloom.Cooldowns.PickUp                                     = true

	task.wait(0.25 + Options.AutoPickDelay.Value)

	if not Cash then Bloom.Cooldowns.PickUp = false return end

	Bloom.Services.ReplicatedStorage.Events.CZDPZUS:FireServer(Cash) 
	Bloom.Cooldowns.PickUp                                     = false
end 

Bloom.Functions.AutoBreakDoors                                 = function(Client, Character)
	if not Toggles.BreakDoors.Value then return end
	if Bloom.Cooldowns.BreakDoors then return end

	if not Client then return end
	if not Character then return end

	local Door                                                  = Bloom.Functions.ReturnDoor(10)
	local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
	local Seed                                                  = nil

	if not Door then return end
	if not Tool then return end

	Bloom.Cooldowns.BreakDoors                                 = true

	if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name == "Lockpick" then
		task.wait(0.5)

		Seed = Tool.Remote:InvokeServer("S", Door, "d")
		Tool.Remote:InvokeServer("D", Door, "d", Seed)
		Tool.Remote:InvokeServer("C")

		task.wait(0.45)

		Door.Events.Toggle:FireServer("Open", Door.Knob1)

		task.wait(0.05)
	end

	if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name ~= "Lockpick" and FindFirstChild(Character, "Right Leg") and Bloom.Functions.EquippedMelee(Character) then
		Seed = Bloom.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"DZDRRRKI",
			Door, 
			"Door"
		)

		task.wait(0.5)

		Bloom.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"2389ZFX33", 
			Seed, 
			false, 
			Character["Right Leg"], 
			Door.DoorBase, 
			Door, 
			Door.DoorBase.Position, 
			Door.DoorBase.Position
		)
	end

	task.wait(0.5)

	Bloom.Cooldowns.BreakDoors                                 = false
end

warn("LOAD5")

Bloom.Functions.AutoBreakSafes                                 = function(Client, Character)
	if not Toggles.BreakSafes.Value then return end
	if Bloom.Cooldowns.BreakSafes then return end

	if not Client then return end
	if not Character then return end

	local Safe                                                  = Bloom.Functions.ReturnBreadMaker("Safe", 15)
	local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
	local Seed                                                  = nil

	if not Safe then return end
	if not Tool then return end

	Bloom.Cooldowns.BreakSafes                                 = true

	if (Options.SafeMethod.Value == "Lockpick" or Options.SafeMethod.Value == "Both") and Tool.Name == "Lockpick" then
		Seed = Tool.Remote:InvokeServer("S", Safe, "s")
		Tool.Remote:InvokeServer("D", Safe, "s", Seed)
		Tool.Remote:InvokeServer("C")

		task.wait(0.5)
	end

	if (Options.SafeMethod.Value == "Melee" or Options.SafeMethod.Value == "Both") and Tool.Name == "Crowbar" then
		Seed = Bloom.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"DZDRRRKI",
			Safe, 
			"Register"
		)

		task.wait(0.5)

		Bloom.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"2389ZFX33", 
			Seed, 
			false, 
			Tool.Handle, 
			Safe.MainPart, 
			Safe, 
			Safe.MainPart.Position, 
			Safe.MainPart.Position
		)
	end

	task.wait(0.5)

	Bloom.Cooldowns.BreakSafes                                 = false
end

Bloom.Functions.AutoBreakRegisters                             = function(Client, Character)
	if not Toggles.BreakRegisters.Value then return end
	if Bloom.Cooldowns.BreakRegisters then return end

	if not Client then return end
	if not Character then return end

	local Register                                              = Bloom.Functions.ReturnBreadMaker("Register", 15)
	local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
	local Seed                                                  = nil

	if not Register then return end
	if not Tool then return end

	Bloom.Cooldowns.BreakRegisters                             = true

	if FindFirstChild(Character, "Right Arm") and Bloom.Functions.EquippedMelee(Character) then
		Seed = Bloom.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"DZDRRRKI",
			Register, 
			"Register"
		)

		task.wait(0.5)

		Bloom.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
			"\240\159\141\158", 
			tick(), 
			Tool, 
			"2389ZFX33", 
			Seed, 
			false, 
			Character["Right Arm"], 
			Register.MainPart, 
			Register, 
			Register.MainPart.Position, 
			Register.MainPart.Position
		)
	end

	task.wait(0.5)

	Bloom.Cooldowns.BreakRegisters                             = false
end

Bloom.Functions.AutoPickUp                                     = function(Client, Character)
	task.spawn(Bloom.Functions.AutoPickScraps, Client, Character)
	task.spawn(Bloom.Functions.AutoPickCrates, Client, Character)
	task.spawn(Bloom.Functions.AutoPickTools, Client, Character)
	task.spawn(Bloom.Functions.AutoPickCash, Client, Character)
end

Bloom.Functions.AutoBreak                                      = function(Client, Character)
	task.spawn(Bloom.Functions.AutoBreakDoors, Client, Character)
	task.spawn(Bloom.Functions.AutoBreakSafes, Client, Character)
	task.spawn(Bloom.Functions.AutoBreakRegisters, Client, Character)
end

Bloom.Functions.Reload                                         = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if Bloom.Cooldowns.Reload then return end
	if not Toggles.InstantReload.Value then return end
	if not Bloom.Functions.EquippedGun(Character) then return end

	Bloom.Cooldowns.Reload                                     = true

	local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
	local Values                                                = Tool.Values
	local Config                                                = require(Tool.Config)

	if (Values.Ammo.Value < (Config.MagSize - 1)) or (Values.StoredAmmo.Value ~= Config.StoredAmmo) then
		Bloom.Services.ReplicatedStorage.Events.GZ_R:FireServer(tick(), "KLWE89U0", Tool)
		Bloom.Services.ReplicatedStorage.Events.GZ_R:FireServer(tick(), "KLWE89U0", Tool)
	end

	task.wait(0.5)

	Bloom.Cooldowns.Reload                                     = false
end

Bloom.Functions.SprayAura                                      = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not Toggles.SprayAura.Value then return end
	if Bloom.Functions.DownedCheck(Character) then return end
	if Bloom.Cooldowns.SprayAura then return end

	local Target, Distance, Limb                                = Bloom.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.SprayAuraDowned.Value, Friendly = Toggles.SprayAuraFriendly.Value, Visible = false }, { Character = Options.SprayAuraDistance.Value }, { "Torso" })
	local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")

	if not Target then return end
	if not Distance then return end
	if not Limb then return end

	if not Tool then return end
	if Tool.Name ~= "Pepper-spray" then return end

	local Origin                                                = Character.HumanoidRootPart.Position
	local End                                                   = Limb.Position
	local Result                                                = Vector3.new(End.X, Origin.Y, End.Z)

	Bloom.Cooldowns.SprayAura                                  = true
	Character.HumanoidRootPart.CFrame                           = CFrame.lookAt(Origin, Result)

	Tool.RemoteEvent:FireServer("Spray", true)
	Tool.RemoteEvent:FireServer("Hit", Target)
	Tool.RemoteEvent:FireServer("Spray", false)

	task.wait()

	Bloom.Cooldowns.SprayAura                                  = false
end

Bloom.Functions.MeleeAura                                      = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not Toggles.MeleeAura.Value then return end
	if not Bloom.Functions.EquippedMelee(Character) then return end
	if Bloom.Functions.DownedCheck(Character) then return end
	if Bloom.Cooldowns.MeleeAura then return end

	local Target, Distance, Limb                                = Bloom.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.MeleeAuraDowned.Value, Friendly = Toggles.MeleeAuraFriendly.Value, Visible = false }, { Character = Options.MeleeAuraDistance.Value }, Options.MeleeAuraParts:GetActiveValues())
	local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
	local Config                                                = Tool and require(Tool.Config) or nil
	local Handle                                                = FindFirstChild(Tool, "Handle") or FindFirstChild(Tool, "WeaponHandle") or FindFirstChild(Character, "Right Arm")

	if not Target then return end
	if not Distance then return end
	if not Limb then return end

	if not Tool then return end
	if not Handle then return end

	Bloom.Cooldowns.MeleeAura                                  = true

	local Seed                                                  = Bloom.Services.ReplicatedStorage.Events["XMHH.1"]:InvokeServer(
		"\240\159\141\158", 
		tick(), 
		Tool, 
		"43TRFWJ", 
		"Normal", 
		tick(), 
		true
	)

	task.wait(Config.Mains["S1"].DebounceTime / 3)

	Bloom.Services.ReplicatedStorage.Events["XMHH2.1"]:FireServer(
		"\240\159\141\158", 
		tick(), 
		Tool, 
		"2389ZFX33",
		Seed, 
		true, 
		Handle,
		Limb, 
		Target, 
		Handle.Position, 
		Limb.Position
	)

	task.wait(0.15)

	Bloom.Cooldowns.MeleeAura                                  = false
end

warn("LOAD6")

Bloom.Functions.FinishAura                                     = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not Toggles.FinishAura.Value then return end
	if not Bloom.Functions.EquippedMelee(Character) then return end
	if Bloom.Functions.DownedCheck(Character) then return end
	if Bloom.Cooldowns.FinishAura then return end

	local Target, Distance, Limb                                = Bloom.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = false, Friendly = Toggles.FinishAuraFriendly.Value, Visible = false }, { Character = Options.FinishAuraDistance.Value }, { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" })
	local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
	local Handle                                                = FindFirstChild(Character, "Right Leg")

	if not Target then return end
	if not Distance then return end
	if not Limb then return end

	if not Tool then return end
	if not Handle then return end
	if not Bloom.Functions.DownedCheck(Character) then return end

	Bloom.Cooldowns.FinishAura                                 = true

	local Config                                                = require(Tool.Config)
	local Seed                                                  = Bloom.Services.ReplicatedStorage.Events["XMHH.1"]:InvokeServer(
		"\240\159\141\158", 
		tick(), 
		Tool, 
		"EXECQX"
	)

	task.wait(0.25)

	Bloom.Services.ReplicatedStorage.Events["XMHH2.1"]:FireServer(
		"\240\159\141\158", 
		tick(), 
		Tool, 
		"2389ZFX33", 
		Seed, 
		false, 
		Handle, 
		Limb, 
		Target, 
		Handle.Position, 
		Limb.Position
	)

	task.wait(0.15)

	Bloom.Cooldowns.FinishAura                                 = false
end

Bloom.Functions.RageBot                                        = function(Client, Character)
	if not Client then return end
	if not Character then return end

	if not Toggles.RageBot.Value then return end
	if not Bloom.Functions.EquippedGun(Character) then return end
	if Bloom.Functions.DownedCheck(Character) then return end

	local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
	local Handle 												= FindFirstChild(Tool, "WeaponHandle") or FindFirstChild(Tool, "Handle")
	local Config                                                = require(Tool.Config)

	if not Tool then return end
	if not Config then return end
	if Options.RageBotMode.Value == "Hold" and not Bloom.Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

	if ((tick() - Bloom.Cooldowns.RageBot) > ((Toggles.RageBotFasterHit.Value and 0.15) or (Toggles.RageBotInstantHit.Value and 0.005) or (1 / Config.FireRate))) and (Tool.Values.SERVER_Ammo.Value > 0) then
		Bloom.Cooldowns.RageBot                                = tick()

		local Target, Distance, Limb                            = Bloom.Functions.Return({ Get = "Character", Part = "Random", Visible = "Wallbang" }, { Downed = Toggles.RageBotDowned.Value, Friendly = Toggles.RageBotFriendly.Value, Visible = true }, { Character = Options.RageBotDistance.Value }, Options.RageBotParts:GetActiveValues())

		if not Target then return end
		if not Distance then return end
		if not Limb then return end

		if Toggles.RageBotAnimation.Value then Bloom.Functions.GunAnimation(Tool, "Fire") end
		if Toggles.RageBotSound.Value then Bloom.Functions.GunSound(Tool, "Muzzle", "FireSound1") end
		if Toggles.RageBotNotify.Value then Library:Notify(string.format("%s, %s Meters, %s", Target.Name, math.floor(Distance), Limb.Name)) end

		local FirePosition                                      = (Handle.FirePos.WorldCFrame * CFrame.new(0, 15, 0)).p
		local HitPositions                                      = {}

		local Key                                               = Bloom.Functions.RandomString(30)..0
		local Part1                                             = Instance.new("Part", Bloom.Camera.Bullets)
		Part1.Size                                              = Vector3.new(0.25, 0.25, 0.25)
		Part1.Transparency                                      = 1
		Part1.CanCollide                                        = false
		Part1.CFrame                                            = CFrame.new(FirePosition)
		Part1.Anchored                                          = true

		local Part2                                             = Instance.new("Part", Bloom.Camera.Bullets)
		Part2.Size                                              = Vector3.new(0.25, 0.25, 0.25)
		Part2.Transparency                                      = 0
		Part2.CanCollide                                        = false
		Part2.CFrame                                            = CFrame.new(Limb.Position)
		Part2.Anchored                                          = true
		Part2.Color                                             = Options.MainColor.Value

		local Attachment0                                       = Instance.new("Attachment", Part1)
		local Attachment1                                       = Instance.new("Attachment", Part2)

		local Beam                                              = Instance.new("Beam", Part1)
		Beam.FaceCamera                                         = true
		Beam.Color                                              = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.AccentColor.Value), ColorSequenceKeypoint.new(1, Options.AccentColor.Value), })
		Beam.Attachment0                                        = Attachment0
		Beam.Attachment1                                        = Attachment1
		Beam.LightEmission                                      = 0
		Beam.LightInfluence                                     = 0
		Beam.Width0                                             = 0.05
		Beam.Width1                                             = 0.05

		for Index = 1, Config.BulletsPerShot do table.insert(HitPositions, CFrame.new(FirePosition, Limb.Position).LookVector) end

		Bloom.Services.ReplicatedStorage.Events.GZ_S:FireServer(
			tick(),
			Key,
			Tool,
			"FDS9I83",
			FirePosition,
			HitPositions,
			false
		)

		task.wait(0.1)

		for Index, HitPosition in next, HitPositions do Bloom.Services.ReplicatedStorage.Events.ZFKLF_H:FireServer(
			"\240\159\166\146",
			tick(),
			Tool,
			Key,
			Index,
			Limb,
			Limb.Position,
			HitPosition,
			nil,
			nil,
			811.392
			) 
		end

		Tool.Hitmarker:Fire(Limb)
		Tool.Values.Ammo.Value                                  = Tool.Values.SERVER_Ammo.Value - 1
		Tool.Values.StoredAmmo.Value                            = Tool.Values.SERVER_StoredAmmo.Value

		task.delay(5, function()
			for i = 0.5, 1, 0.02 do
				task.wait()

				Beam.Transparency                               = NumberSequence.new(i)
				Part2.Transparency                              = i
			end

			Part1:Destroy()
			Part2:Destroy()
		end)
	end
end
-- #EndRegion

-- #Region // Hooks

for Index, Data in next, getgc(true) do
	if typeof(Data) == "table" and typeof(rawget(Data, "CX1")) == "function" then
		Data.CX1 = function() end

		continue
	end

	if typeof(Data) == "table" and rawget(Data, "Detected") and typeof(rawget(Data, "Detected")) == "function" then    
		hookfunction(Data["Detected"], function(Action, Info, NoCrash)
			if rawequal(Action, "_") then return true end
			if rawequal(Info, "_") then return true end

			return task.wait(9e9)
		end)

		continue
	end

	--if typeof(Data) == 'table' then
	--	if Data.S then
	--		if typeof(Data.S) == 'number' then
	--			Toggles.Stamina:OnChanged(function(V)
	--				if V then
	--					Data.S = 2^1023
	--				else
	--					Data.S = 100
	--				end
	--			end)
	--		end
	--	end
	--end
end

local OriginialSoundID = Bloom.Services.ReplicatedStorage.Storage.FrameworkStuff.Flashbang.SoundId

local Namecall; Namecall                                        = hookmetamethod(game, "__namecall", function(Self, ...)
	local Arguments                                             = {...}
	local Name                                                  = tostring(Self)
	local Method                                                = getnamecallmethod()
	local Calling                                               = getcallingscript()
	local self = Arguments[1]

	if Method == "FireServer" and not checkcaller() then
		local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

		if Name == "TK_DGM" and Arguments[2] == "Drown" and table.find(Disablers, "Drowning") then return end
		if Name == "__DFfDD" and Arguments[1] == "G_Gh" and table.find(Disablers, "Grinders") then return end
		if Name == "__DFfDD" and Arguments[1] == "BHHh" and table.find(Disablers, "Barbwires") then return end
		if Name == "__DFfDD" and Arguments[1] == "__--r" or Arguments[1] == "-r__r2" and table.find(Disablers, "Ragdoll") then return end
		if Name == "__DFfDD" and Arguments[1] == "FlllD" or Arguments[1] == "FllH" and table.find(Disablers, "Fall Damage") then return end
	end

	if Method == "InvokeServer" and not checkcaller() then if Name == "Remote" and Arguments[1] == "E" and Toggles.NoFail.Value then return end end

	if Method == "Raycast" and not checkcaller() and Bloom.Functions.ValidCheck(Bloom.Client.Character) and Bloom.Functions.EquippedGun(Bloom.Client.Character) and Toggles.LegitBot.Value then
		if (Calling.Name ~= "Visuals") then return Namecall(Self, unpack(Arguments)) end

		local Chance                                            = NextInteger(Bloom.Random, 1, 100)
		local Target, Distance, Limb                            = Bloom.Functions.Return({ Get = "Mouse", Part = "Random", Visible = "Check" }, { Downed = Toggles.LegitBotDowned.Value, Friendly = Toggles.LegitBotFriendly.Value, Visible = true }, { Character = Options.LegitBotDistance.Value, Mouse = Options.LegitBotRadius.Value }, Options.LegitBotParts.GetActiveValues(Options.LegitBotParts))

		if not Target or not Distance or not Limb then return Namecall(Self, unpack(Arguments)) end

		Arguments[2]                                            = (Limb.Position - Arguments[1]).Unit * 1000000000

		return Namecall(Self, unpack(Arguments))
	end

	return Namecall(Self, unpack(Arguments))
end)

for _, smokes in workspace.Debris:GetChildren() do
	if smokes.Name == "SmokeExplosion" then
		local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

		if table.find(Disablers, "Smokes") then
			smokes.Particle1.Enabled = false
			smokes.Particle2.Enabled = false
		end
	end
end

task.spawn(function()
	while wait() do
		local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

		if table.find(Disablers, "Flashes") then
			if Bloom.Client.PlayerGui:FindFirstChild("FlashedGui") then
				Bloom.Client.PlayerGui:FindFirstChild("FlashedGui").Enabled = false

				for _, blureffect in Bloom.Camera:GetChildren() do
					if blureffect.Name == "BlindEffect" then
						blureffect:Destroy()
					end
				end

				Bloom.Services.ReplicatedStorage.Storage.FrameworkStuff.Flashbang.SoundId = ""
			end
		else
			Bloom.Services.ReplicatedStorage.Storage.FrameworkStuff.Flashbang.SoundId = OriginialSoundID
		end
	end
end)

workspace.Debris.ChildAdded:Connect(function(child)
	local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

	if child.Name == "SmokeExplosion" then
		if table.find(Disablers, "Smokes") then
			child.Particle1.Enabled = false
			child.Particle2.Enabled = false
		end
	end
end)

warn("LOAD7")

local NewIndex; NewIndex										= hookmetamethod(game, "__newindex", function(Self, Index, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Index)
	local Result 												= tostring(Value)
	local Sky 													= Bloom.SkyBoxes[Options.SelectedSkyBox.Value] or nil

	-- Lighting
	if (Name == "Lighting") and (Method == "Ambient") and (Self == Bloom.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "OutdoorAmbient") and (Self == Bloom.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Bottom") and (Self == Bloom.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Top") and (Self == Bloom.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "GlobalShadows") and (Self == Bloom.Services.Lighting) then
		return NewIndex(Self, Index, Toggles.ShadowMap.Value)
	end

	if (Name == "Lighting") and (Method == "ClockTime") and (Self == Bloom.Services.Lighting) and (Toggles.ForceTime.Value) then
		return NewIndex(Self, Index, Options.SelectedTime.Value)
	end

	if (Name == "Lighting") and (Method == "GeographicLatitude") and (Self == Bloom.Services.Lighting) and (Toggles.ForceLatitude.Value) then
		return NewIndex(Self, Index, Options.SelectedLatitude.Value)
	end

	if (Name == "Lighting") and (Method == "EnvironmentDiffuseScale") and (Self == Bloom.Services.Lighting) and (Toggles.ForceDiffuse.Value) then
		return NewIndex(Self, Index, Options.SelectedDiffuse.Value)
	end

	-- Atmosphere
	if (Name == "Atmosphere") and (Method == "Decay") and (Self.Parent == Bloom.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Decay"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Color") and (Self.Parent == Bloom.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Color"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Glare") and (Self.Parent == Bloom.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Glare"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Haze") and (Self.Parent == Bloom.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Haze"] or Value)
	end

	-- Viewmodel
	if (Name == "Left Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Bloom.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmColor.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Bloom.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmColor.Value or Value)
	end

	if (Name == "Left Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Bloom.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmTransparency.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Bloom.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmTransparency.Value or Value)
	end

	if (Name == "Left Arm" or Name == "Right Arm") and (Method == "Material") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Bloom.Functions.FP() then
		return NewIndex(Self, Index, Enum.Material[Options.ViewmodelArmsMaterial.Value] or Value)
	end

	-- Character
	if (Name == "HumanoidRootPart" or Name == "Torso" or Name == "Head") and (Method == "CanCollide") and (Self.Parent == Bloom.Client.Character) and (Toggles.Noclip.Value) then
		return NewIndex(Self, Index, false)
	end

	if (Name == "Humanoid") and (Method == "WalkSpeed") and (Self.Parent == Bloom.Client.Character) and (Toggles.WalkSpeed.Value) then
		return NewIndex(Self, Index, Options.WalkSpeed.Value or Value)
	end

	if (Name == "Humanoid") and (Method == "JumpPower") and (Self.Parent == Bloom.Client.Character) and (Toggles.JumpPower.Value) then
		return NewIndex(Self, Index, Options.JumpPower.Value or Value)
	end

	if (Name == "ROTROOT") and (Method == "Parent") and (Result == "Currents") and (Toggles.SprayAura.Value) then
		return NewIndex(Self, Index, nil)
	end

	return NewIndex(Self, Index, Value)
end)

local Index; Index                                             	= hookmetamethod(game, "__index", function(Self, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Value)
	local Calling 												= getcallingscript()

	if (Name == "FP_Offset") and (Method == "Value") and (not checkcaller()) and (Toggles.Viewmodel.Value) then
		return Vector3.new(Options.ViewmodelXOffset.Value / 7, Options.ViewmodelYOffset.Value / 7, Options.ViewmodelZOffset.Value / 7)
	end

	if (Name == "Ammo") and (Method == "Value") and (string.find(Self.Parent.Name, "Pepper")) and (not checkcaller()) and (Toggles.InfinitePepperSpray.Value) then
		return 100
	end

	return Index(Self, Value)
end)

local gmt = getrawmetatable(game)
if gmt then
	setreadonly(gmt, false)
	local oldNamecall = gmt.__namecall

	gmt.__namecall = newcclosure(function(self, ...)
		local args = {...}
		local method = getnamecallmethod()

		if tostring(method) == "FireServer" and tostring(self) == "MOVZREP" then
			if Toggles.HAnti.Value then
				args[1][1][3] = CFtoObjectSpace(Bloom.Client.Character.HumanoidRootPart.CFrame, workspace.CurrentCamera.CFrame).LookVector.Unit * Vector3.new(0, -50, 0)
			end
		end

		return oldNamecall(self, unpack(args))
	end)
	setreadonly(gmt, true)
end

--hookfunction(Config, function(Tool)
--	local GunData                                               = {}
--	local Config                                                = require(WaitForChild(Tool, "Config"))

--for Index, Value in next, Config do
--	if (Index == "Recoil") or (string.find(Index, "_Max")) or (string.find(Index, "_Min")) then
--		GunData[Index]                                      = Value * (Options.RecoilPercentage.Value / 100)

--		continue
--	end

--	if (Index == "Spread") then
--		GunData[Index]                                      = Value * (Options.SpreadPercentage.Value / 100)

--		continue
--	end

--	GunData[Index]                                          = Value
--end

--	return GunData
--end)

Bloom.Hooks.Namecall                                           = Namecall
Bloom.Hooks.NewIndex                                           = NewIndex
Bloom.Hooks.Index                                              = Index
-- #EndRegion

-- #Region // Handler
do
	Bloom.Cooldowns.RageBot                                    = 0
end

task.spawn(Bloom.Functions.LocalCharacter, Bloom.Client.Character)

--Options.SelectedSkyBox:SetValues(Bloom.Functions.GetSkyBoxes())
--Options.SelectedSkyBox:SetValue("Default")
--Options.SelectedHitMarker:SetValues(Bloom.Functions.GetHitMarkers())
--Options.SelectedHitMarker:SetValue("Default")

Toggles.RageBot:OnChanged(function(V)
	if not V then return end

	if Toggles.LegitBot.Value then Toggles.LegitBot:SetValue(false) Library:Notify("Turned off LegitBot because RageBot has been turned on.") end
end)

Toggles.LegitBot:OnChanged(function(V)
	if not V then return end

	if Toggles.RageBot.Value then Toggles.RageBot:SetValue(false) Library:Notify("Turned off RageBot because LegitBot has been turned on.") end
end)

Toggles.Fly:OnChanged(function(V)
	Bloom.Functions.Fly(Bloom.Client, Bloom.Client.Character)
end)

Toggles.SBot:OnChanged(function(V)
	Bloom.Functions.SpinBot(Bloom.Client, Bloom.Client.Character)
end)

for _, players in workspace.Characters:GetChildren() do
	if players ~= Bloom.Client.Character then
		Bloom.Functions.CreateChams(players)
	end
end

workspace.Characters.ChildAdded:Connect(function(players)
	if players ~= Bloom.Client.Character then 
		Bloom.Functions.CreateChams(players)
	end
end)

Toggles.ChatLogs:OnChanged(function(V)
	game.TextChatService.ChatWindowConfiguration.Enabled = V
end)

Options.SpinSpeed:OnChanged(function(V)
	Bloom.Functions.SpinBot(Bloom.Client, Bloom.Client.Character)
end)

Bloom.Functions.NewConnection("CharacterAdded", Bloom.Connections, Bloom.Client.CharacterAdded, Bloom.Functions.LocalCharacter)
Bloom.Functions.NewConnection("Mouse Move", Bloom.Connections, Bloom.Mouse.Move, function()
	local Gun 													= Bloom.Functions.EquippedGun(Bloom.Client.Character)

	Bloom.Data.FOV.Position									= Bloom.Services.UserInputService:GetMouseLocation()
	Bloom.Data.FOV.Color                                       = Options.AccentColor.Value
	Bloom.Data.FOV.Radius                                      = Options.LegitBotRadius.Value
	Bloom.Data.FOV.Visible										= Toggles.LegitBotFOV.Value and Toggles.LegitBot.Value and Gun
end)

warn("LOAD8")

Bloom.Functions.NewConnection("Main", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	task.spawn(Bloom.Functions.ProjectileController, Bloom.Client, Bloom.Client.Character)
	task.spawn(Bloom.Functions.FlyController, Bloom.Client, Bloom.Client.Character)

	if Bloom.Functions.ValidCheck(Bloom.Client.Character) then
		task.spawn(Bloom.Functions.BHop, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.Stats, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.TriggerBot, Bloom.Client, Bloom.Client.Character)

		task.spawn(Bloom.Functions.AutoPickUp, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.AutoBreak, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.Reload, Bloom.Client, Bloom.Client.Character)

		task.spawn(Bloom.Functions.RageBot, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.SprayAura, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.MeleeAura, Bloom.Client, Bloom.Client.Character)
		task.spawn(Bloom.Functions.FinishAura, Bloom.Client, Bloom.Client.Character)
	end
end)

local MouseUI 												= Bloom.Client.PlayerGui.MouseGUI

MouseUI.HitmarkerSound.Changed:Connect(function()

	if MouseUI.HitmarkerSound.Playing then
		if Toggles.CustomHitMarker.Value then
			MouseUI.HitmarkerSound:Stop()
			local Clone                                                 = Instance.new("Sound")
			Clone.Parent                                                = MouseUI
			Clone.SoundId 						    = Bloom.Functions.SetHitMarker(Options.SelectedHitMarker.Value)
			Clone.Volume						    = Options.CustomHitMarkerVolume.Value
			Clone:Play()
			print(Clone.Playing)
			
			Bloom.Services.Debris:AddItem(Clone, 2)
		end
	end
end)

Bloom.Client.PlayerGui.ChildAdded:Connect(function(Child)
	if Child.Name == "MouseGUI" then
		local MouseUI 												= Bloom.Client.PlayerGui.MouseGUI

		MouseUI.HitmarkerSound.Changed:Connect(function()

			if MouseUI.HitmarkerSound.Playing then
				if Toggles.CustomHitMarker.Value then
					MouseUI.HitmarkerSound:Stop()
					local Clone                                                 = Instance.new("Sound")
					Clone.Parent                                                = MouseUI
					Clone.SoundId 						    = Bloom.Functions.SetHitMarker(Options.SelectedHitMarker.Value)
					Clone.Volume						    = Options.CustomHitMarkerVolume.Value
					Clone:Play()
					print(Clone.Playing)
						
					Bloom.Services.Debris:AddItem(Clone, 2)
				end
			end
		end)
	end
end)


warn("LOAD10")

Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Bloom.Data.Start))
Library.SaveManager:LoadAutoloadConfig()
-- #EndRegion
warn("LOAD9")
