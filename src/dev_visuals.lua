-- // Clear
Bloom.Functions.ClearConnection("Player ESP", Bloom.Connections)
Bloom.Functions.ClearConnection("Dealer ESP", Bloom.Connections)
Bloom.Functions.ClearConnection("Register ESP", Bloom.Connections)
Bloom.Functions.ClearConnection("Safe ESP", Bloom.Connections)
Bloom.Functions.ClearConnection("Scrap ESP", Bloom.Connections)
Bloom.Functions.ClearConnection("Crate ESP", Bloom.Connections)

Bloom.Functions.ClearConnection("Player Added", Bloom.Connections)
Bloom.Functions.ClearConnection("Player Removing", Bloom.Connections)

Bloom.Functions.ClearConnection("Scrap Added", Bloom.Connections)
Bloom.Functions.ClearConnection("Scrap Removed", Bloom.Connections)

Bloom.Functions.ClearConnection("Camera Child Added", Bloom.Connections)
Bloom.Functions.ClearConnection("Camera Child Removed", Bloom.Connections)

-- #Region // Setup
local Visuals													= {} do
	Visuals.Players 											= {}
	Visuals.Dealers                  							= {}
	Visuals.FriendsWith											= {}

	Visuals.Registers                							= {}
	Visuals.Safes                    							= {}
	Visuals.Scraps                   							= {}
	Visuals.Crates                   							= {}

	Visuals.SkyBoxes 											= {}
	Visuals.HitMarkers 											= {}
end

do
	Bloom.Cooldowns.PlayerRate								 	= 0
	Bloom.Cooldowns.DealerRate									= 0

	Bloom.Cooldowns.RegisterRate								= 0
	Bloom.Cooldowns.SafeRate									= 0
	Bloom.Cooldowns.ScrapRate									= 0
	Bloom.Cooldowns.CrateRate									= 0
end

if isfile and isfile("pixel_font.font") then 
	delfile("pixel_font.font")
end;

if isfile and isfile("pixel-font.ttf") then 
	delfile("pixel-font.ttf");
end;

getgenv().Visuals = Visuals

local FP														= function()
	return (Bloom.Camera.CFrame.p - Bloom.Camera.Focus.p).Magnitude < 0.6
end

local ObjectVisible												= function(Model)
	for Index, Object in next, Model:GetChildren() do
		if (Object.Name == "HumanoidRootPart") then continue end
		if (string.find(Object.Name, "Foot")) then continue end
		if (string.find(Object.Name, "Leg")) then continue end
		if (not Object:IsA("BasePart")) then continue end

		if (Object.Transparency == 1) then print(Object.Name) return false end
	end

	return true
end

local GetBoundingBox											= function(Model)
	local Model 												= typeof(Model) == "Instance" and Model:GetDescendants() or Model
	local Orientation											= CFrame.new()

	local MinX, MinY, MinZ 										= math.huge, math.huge, math.huge
	local MaxX, MaxY, MaxZ 										= -math.huge, -math.huge, -math.huge

	for Index, Object in next, Model do
		if not Object:IsA("BasePart") then continue end

		local CFrame 											= Orientation:ToObjectSpace(Object.CFrame)
		local Size 												= Object.Size

		local SX, SY, SZ 										= Size.X, Size.Y, Size.Z
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CFrame:GetComponents()

		local WSX = 0.5 * (math.abs(R00) * SX + math.abs(R01) * SY + math.abs(R02) * SZ)
		local WSY = 0.5 * (math.abs(R10) * SX + math.abs(R11) * SY + math.abs(R12) * SZ)
		local WSZ = 0.5 * (math.abs(R20) * SX + math.abs(R21) * SY + math.abs(R22) * SZ)

		if MinX > X - WSX then MinX = X - WSX end
		if MinY > Y - WSY then MinY = Y - WSY end
		if MinZ > Z - WSZ then MinZ = Z - WSZ end
		if MaxX < X + WSX then MaxX = X + WSX end
		if MaxY < Y + WSY then MaxY = Y + WSY end
		if MaxZ < Z + WSZ then MaxZ = Z + WSZ end
	end

	local OMin, OMax 											= Vector3.new(MinX, MinY, MinZ), Vector3.new(MaxX, MaxY, MaxZ)
	local CFrame 												= Orientation - Orientation.p + Orientation:PointToWorldSpace((OMax+OMin) / 2)
	local Size 													= (OMax-OMin)

	return CFrame, Size
end

local CalculateBox												= function(Object, Type, ...)	
	if (Object == nil) then return end
	if (Type == nil) then return end

	if (Type == "Dynamic") then
		local List 												= Object:GetChildren()

		for Index, Value in next, List do
			if Value:IsA("BasePart") then continue end

			table.remove(List, Index)
		end

		local Position, Size 									= GetBoundingBox(List)
		local MaxS 												= (Position * CFrame.new(Size / 2)).Position
		local MinS 												= (Position * CFrame.new(Size / -2)).Position

		local Visible 											= true
		local Points 											= {
			Vector3.new(MinS.X, MinS.Y, MinS.Z),
			Vector3.new(MinS.X, MaxS.Y, MinS.Z),
			Vector3.new(MaxS.X, MaxS.Y, MinS.Z),
			Vector3.new(MaxS.X, MinS.Y, MinS.Z),
			Vector3.new(MaxS.X, MaxS.Y, MaxS.Z),
			Vector3.new(MinS.X, MaxS.Y, MaxS.Z),
			Vector3.new(MinS.X, MinS.Y, MaxS.Z),
			Vector3.new(MaxS.X, MinS.Y, MaxS.Z)
		}

		for Index, Point in next, Points do Points[Index], Visible = Bloom.Camera:WorldToViewportPoint(Point) end

		if (not Visible) then return end

		local Left 												= math.huge
		local Top 												= math.huge
		local Right 											= 0
		local Bottom 											= 0

		for _, Point in next, Points do
			if (Point.X < Left) then Left = Point.X end
			if (Point.X > Right) then Right = Point.X end
			if (Point.Y < Top) then Top = Point.Y end
			if (Point.Y > Bottom) then Bottom = Point.Y end
		end

		return {
			["X"] = math.floor(Left),
			["Y"] = math.floor(Top),
			["W"] = math.floor(Right - Left),
			["H"] = math.floor(Bottom - Top)
		}
	end

	if (Type == "Static") then
		local Arguments 										= {...}
		local Primary 											= Arguments[1]
		local Offset 											= Arguments[2]
		local Range 											= Arguments[3]
		local Main, Visible 									= Bloom.Camera:WorldToViewportPoint(Primary.Position + Offset)

		if (not Visible) then return end

		local Scale 											= 1 / (Main.Z * math.tan(math.rad(Bloom.Camera.FieldOfView / 2)) * 2) * 1000
		local Width, Height 									= math.round(Range[1] * Scale), math.round(Range[2] * Scale)
		local X, Y 												= math.round(Main.X), math.round(Main.Y)

		local Size 												= Vector2.new(Width, Height)
		local Position 											= Vector2.new(math.round(X - Width / 2), math.round(Y - Height / 2))

		return {
			["X"] = Position.X,
			["Y"] = Position.Y,
			["W"] = Size.X,
			["H"] = Size.Y
		}
	end

	return
end

local SetProperty												= function(Object, Table)
	for Property, Value in next, Table do
		local Success, Error 									= pcall(function()
			Object[Property] 									= Value
		end)

		if (not Success) then
			-- Must be an invalid property
		end
	end
end

local NewDrawing												= function(Type, Properties)
	local Object 												= Drawing.new(Type)

	SetProperty(Object, Properties)

	return Object
end
-- #EndRegion

-- #Region // Main Functions

-- #Region // Skybox




-- #EndRegion

-- #Region // Hitmarkers
Visuals.HitMarkers = {}

local GetHitMarkers			                        			= function()
	local List 							                        = {}

	for Name, Table in next, Visuals.HitMarkers do
		table.insert(List, Name)
	end

	return List
end

local SetHitMarker = function(Name)
	return
end
-- #EndRegion

-- #Region // Insert
local SetViewModel 												= function(Object)
	if Object.Name ~= "ViewModel" then return end
	if not Object.Parent then return end

	getgenv().ViewModel											= Object

	getgenv().ViewModel.ChildAdded:Connect(function(Object)
		if Object.Name ~= "Tool" then return end

		getgenv().ViewModelTool									= Object

		Object.DescendantAdded:Connect(function(v)
			task.wait()

			if not Toggles.Viewmodel.Value then return end
			if not v:IsA("BasePart") then return end
			if not v:IsA("MeshPart") then return end

			v.Color 											= Options.ViewmodelToolColor.Value
			v.Material 											= Enum.Material[Options.ViewmodelToolsMaterial.Value]
			v.Transparency										= Options.ViewmodelToolTransparency.Value
		end)

		for i, v in next, Object:GetDescendants() do
			task.wait()

			if not Toggles.Viewmodel.Value then return end
			if not v:IsA("BasePart") then continue end
			if not v:IsA("MeshPart") then continue end

			v.Color 											= Options.ViewmodelToolColor.Value
			v.Material 											= Enum.Material[Options.ViewmodelToolsMaterial.Value]
			v.Transparency										= Options.ViewmodelToolTransparency.Value
		end
	end)
end

local NewPlayer 												= function(Player)
	if Player == Bloom.Client then return end

	Visuals.Players[Player]										= {
		Box 													= NewDrawing("Square", { ZIndex = 100, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 50, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		HealthBar 												= NewDrawing("Line", { ZIndex = 100, Thickness = 1, Color = Color3.fromRGB(0, 255, 157) }),
		HealthBarOutline 										= NewDrawing("Line", { ZIndex = 50, Thickness = 3, Color = Color3.fromRGB(0, 0, 0) }),

		Telemetry 												= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 1, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),

		Name 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 1, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Tool 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 1, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 1, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Health 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 1, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
	}

	if Player.IsFriendsWith(Player, Bloom.Client.UserId) then
		Visuals.FriendsWith[Player] = true
	else
		Visuals.FriendsWith[Player] = false
	end
end

local NewDealer													= function(Dealer)
	local Character												= Dealer:FindFirstChild("DealerMan") or Dealer:FindFirstChild("ArmoryMan")

	if (not Character) then return end

	Visuals.Dealers[Character]									= {
		Box 													= NewDrawing("Square", { ZIndex = 100, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 50, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		Type 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) })
	}
end

local NewRegister												= function(Register)
	if (not string.find(Register.Name, "Register")) then return end

	Visuals.Registers[Register]									= {
		Box 													= NewDrawing("Square", { ZIndex = 100, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 50, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		Type 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Status 													= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 100, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) })
	}
end

local NewSafe													= function(Safe)
	if (not string.find(Safe.Name, "Safe")) then return end

	Visuals.Safes[Safe]											= {
		Box 													= NewDrawing("Square", { ZIndex = 1000, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 500, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		Type 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Rarity 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Status 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) })
	}
end

local NewScrap													= function(Scrap)
	if (not string.find(Scrap.Name, "S")) then return end

	Visuals.Scraps[Scrap]										= {
		Box 													= NewDrawing("Square", { ZIndex = 1000, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 500, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		Type 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) })
	}
end

local NewCrate													= function(Crate)
	if (not string.find(Crate.Name, "C")) then return end

	Visuals.Crates[Crate]										= {
		Box 													= NewDrawing("Square", { ZIndex = 1000, Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255) }),
		BoxOpacity 												= NewDrawing("Square", { ZIndex = 75, Thickness = 0, Filled = true, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.25 }),
		BoxOutline 												= NewDrawing("Square", { ZIndex = 500, Thickness = 3, Filled = false, Color = Color3.fromRGB(0, 0, 0) }),

		Type 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Rarity 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Status 													= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
		Distance 												= NewDrawing("Text", { ZIndex = 1000, Center = true, Outline = true, Font = 2, Size = 12, Color = Color3.fromRGB(255, 255, 255) }),
	}
end
-- #EndRegion

-- #Region // Remove
local CleanPlayer												= function(Player)
	if (not Visuals.Players[Player]) then return end

	for _, Drawing in next, Visuals.Players[Player] do
		Drawing:Remove()
	end

	Visuals.Players[Player] 									= nil
	Visuals.FriendsWith[Player]									= nil
end

local CleanCrate 												= function(Crate)
	if (not Visuals.Crates[Crate]) then return end

	for _, Drawing in next, Visuals.Crates[Crate] do
		Drawing:Remove()
	end

	Visuals.Crates[Crate] 										= nil
end

local CleanScrap 												= function(Scrap)
	if (not Visuals.Scraps[Scrap]) then return end

	for _, Drawing in next, Visuals.Scraps[Scrap] do
		Drawing:Remove()
	end

	Visuals.Scraps[Scrap] 										= nil
end

local NewPile 													= function(Pile)
	if (string.find(Pile.Name, "S")) then return NewScrap(Pile) end
	if (string.find(Pile.Name, "C")) then return NewCrate(Pile) end
end

local CleanPile 												= function(Pile)
	if (string.find(Pile.Name, "S")) then return CleanScrap(Pile) end
	if (string.find(Pile.Name, "C")) then return CleanCrate(Pile) end
end
-- #EndRegion

-- #EndRegion

-- #Region // Connections
Bloom.Functions.FP												= FP
Bloom.HitMarkers												= Visuals.HitMarkers

Bloom.Functions.GetHitMarkers									= GetHitMarkers
Bloom.Functions.SetHitMarker									= SetHitMarker

for i, Player in next, Bloom.Services.Players:GetPlayers() do
	NewPlayer(Player)
end

for i, Dealer in next, Bloom.Services.Workspace.Map.Shopz:GetChildren() do
	NewDealer(Dealer)
end

for i, Register in next, Bloom.Services.Workspace.Map.BredMakurz:GetChildren() do
	NewRegister(Register)
end

for i, Safe in next, Bloom.Services.Workspace.Map.BredMakurz:GetChildren() do
	NewSafe(Safe)
end

for i, Object in next, Bloom.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
	NewPile(Object)
end

Bloom.Functions.NewConnection("Player Added", Bloom.Connections, Bloom.Services.Players.PlayerAdded, NewPlayer)
Bloom.Functions.NewConnection("Player Removing", Bloom.Connections, Bloom.Services.Players.PlayerRemoving, CleanPlayer)

Bloom.Functions.NewConnection("Scrap Added", Bloom.Connections, Bloom.Services.Workspace.Filter.SpawnedPiles.ChildAdded, NewPile)
Bloom.Functions.NewConnection("Scrap Removed", Bloom.Connections, Bloom.Services.Workspace.Filter.SpawnedPiles.ChildRemoved, CleanPile)

Bloom.Functions.NewConnection("Camera Child Added", Bloom.Connections, Bloom.Camera.ChildAdded, SetViewModel)
Bloom.Functions.NewConnection("Camera Child Removed", Bloom.Connections, Bloom.Camera.ChildRemoved, SetViewModel)

Toggles.Viewmodel:OnChanged(function(V)
	if not Toggles.Viewmodel.Value then return end

	local Viewmodel											= getgenv().ViewModel
	local RightArm											= Viewmodel and Viewmodel:FindFirstChild("Right Arm")
	local LeftArm											= Viewmodel and Viewmodel:FindFirstChild("Left Arm")

	if RightArm then
		RightArm.Color										= Options.ViewmodelRArmColor.Value
		RightArm.Transparency								= Options.ViewmodelRArmTransparency.Value
		RightArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end

	if LeftArm then
		LeftArm.Color										= Options.ViewmodelLArmColor.Value
		LeftArm.Transparency								= Options.ViewmodelLArmTransparency.Value
		LeftArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end
end)

Options.ViewmodelRArmColor:OnChanged(function(V)
	if not Toggles.Viewmodel.Value then return end

	local Viewmodel											= getgenv().ViewModel
	local RightArm											= Viewmodel and Viewmodel:FindFirstChild("Right Arm")
	local LeftArm											= Viewmodel and Viewmodel:FindFirstChild("Left Arm")

	if RightArm then
		RightArm.Color										= Options.ViewmodelRArmColor.Value
		RightArm.Transparency								= Options.ViewmodelRArmTransparency.Value
		RightArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end

	if LeftArm then
		LeftArm.Color										= Options.ViewmodelLArmColor.Value
		LeftArm.Transparency								= Options.ViewmodelLArmTransparency.Value
		LeftArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end
end)

Options.ViewmodelLArmColor:OnChanged(function(V)
	if not Toggles.Viewmodel.Value then return end

	local Viewmodel											= getgenv().ViewModel
	local RightArm											= Viewmodel and Viewmodel:FindFirstChild("Right Arm")
	local LeftArm											= Viewmodel and Viewmodel:FindFirstChild("Left Arm")

	if RightArm then
		RightArm.Color										= Options.ViewmodelRArmColor.Value
		RightArm.Transparency								= Options.ViewmodelRArmTransparency.Value
		RightArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end

	if LeftArm then
		LeftArm.Color										= Options.ViewmodelLArmColor.Value
		LeftArm.Transparency								= Options.ViewmodelLArmTransparency.Value
		LeftArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end
end)

Options.ViewmodelToolColor:OnChanged(function(V)
	if not Toggles.Viewmodel.Value then return end
	if not getgenv().ViewModelTool then return end

	for i, v in next, ViewModelTool:GetDescendants() do
		task.wait()

		if not v:IsA("BasePart") then continue end
		if not v:IsA("MeshPart") then continue end

		v.Color 											= Options.ViewmodelToolColor.Value
		v.Material 											= Enum.Material[Options.ViewmodelToolsMaterial.Value]
		v.Transparency										= Options.ViewmodelToolTransparency.Value
	end
end)

Options.ViewmodelToolTransparency:OnChanged(function()
	if not Toggles.Viewmodel.Value then return end
	if not getgenv().ViewModelTool then return end

	for i, v in next, ViewModelTool:GetDescendants() do
		task.wait()

		if not v:IsA("BasePart") then continue end
		if not v:IsA("MeshPart") then continue end

		v.Color 											= Options.ViewmodelToolColor.Value
		v.Material 											= Enum.Material[Options.ViewmodelToolsMaterial.Value]
		v.Transparency										= Options.ViewmodelToolTransparency.Value
	end
end)

Options.ViewmodelToolsMaterial:OnChanged(function()
	if not Toggles.Viewmodel.Value then return end
	if not getgenv().ViewModelTool then return end

	for i, v in next, ViewModelTool:GetDescendants() do
		task.wait()

		if not v:IsA("BasePart") then continue end
		if not v:IsA("MeshPart") then continue end

		v.Color 											= Options.ViewmodelToolColor.Value
		v.Material 											= Enum.Material[Options.ViewmodelToolsMaterial.Value]
		v.Transparency										= Options.ViewmodelToolTransparency.Value
	end
end)

Options.ViewmodelArmsMaterial:OnChanged(function()
	if not Toggles.Viewmodel.Value then return end

	local Viewmodel											= getgenv().ViewModel
	local RightArm											= Viewmodel and Viewmodel:FindFirstChild("Right Arm")
	local LeftArm											= Viewmodel and Viewmodel:FindFirstChild("Left Arm")

	if RightArm then
		RightArm.Color										= Options.ViewmodelRArmColor.Value
		RightArm.Transparency								= Options.ViewmodelRArmTransparency.Value
		RightArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end

	if LeftArm then
		LeftArm.Color										= Options.ViewmodelLArmColor.Value
		LeftArm.Transparency								= Options.ViewmodelLArmTransparency.Value
		LeftArm.Material 									= Enum.Material[Options.ViewmodelArmsMaterial.Value]
	end
end)

SetViewModel(Bloom.Camera:FindFirstChild("ViewModel"))
-- DownloadHitMarkers()
-- #EndRegion

-- #Region // UI
Toggles.Ambience:OnChanged(function(V)
	if (V) then return end

	Bloom.Services.Lighting.Ambient							= Color3.fromRGB(0, 0, 0)
	Bloom.Services.Lighting.OutdoorAmbient						= Color3.fromRGB(128, 128, 128)

	Options.AmbienceColor1:SetValueRGB(Bloom.Services.Lighting.Ambient)
	Options.AmbienceColor2:SetValueRGB(Bloom.Services.Lighting.OutdoorAmbient)
end)

Toggles.Shift:OnChanged(function(V)
	if (V) then return end

	Bloom.Services.Lighting.ColorShift_Bottom					= Color3.fromRGB(0, 0, 0)
	Bloom.Services.Lighting.ColorShift_Top						= Color3.fromRGB(0, 0, 0)

	Options.ShiftColor1:SetValueRGB(Bloom.Services.Lighting.ColorShift_Bottom)
	Options.ShiftColor2:SetValueRGB(Bloom.Services.Lighting.ColorShift_Top)
end)

Toggles.ShadowMap:OnChanged(function(V)
	Bloom.Services.Lighting.GlobalShadows						= V and V or false
end)

Toggles.ForceTime:OnChanged(function(V)
	Bloom.Services.Lighting.ClockTime							= V and Options.SelectedTime or 14
end)

Toggles.ForceLatitude:OnChanged(function(V)
	Bloom.Services.Lighting.GeographicLatitude					= V and Options.SelectedLatitude.Value or 41.733
end)

Toggles.ForceDiffuse:OnChanged(function(V)
	Bloom.Services.Lighting.EnvironmentDiffuseScale			= V and Options.SelectedDiffuse.Value or 0
end)



Options.SelectedTime:OnChanged(function(V)
	if (not Toggles.ForceTime.Value) then return end

	Bloom.Services.Lighting.ClockTime							= Options.SelectedTime.Value
end)

Options.SelectedLatitude:OnChanged(function(V)
	if (not Toggles.ForceLatitude.Value) then return end

	Bloom.Services.Lighting.GeographicLatitude					= Options.SelectedLatitude.Value
end)

Options.ShiftColor1:OnChanged(function(V)
	if (not Toggles.Shift.Value) then return end

	Bloom.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Bloom.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.ShiftColor2:OnChanged(function(V)
	if (not Toggles.Shift.Value) then return end

	Bloom.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Bloom.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.AmbienceColor1:OnChanged(function(V)
	if (not Toggles.Ambience.Value) then return end

	Bloom.Services.Lighting.Ambient							= Options.AmbienceColor1.Value
	Bloom.Services.Lighting.OutdoorAmbient						= Options.AmbienceColor2.Value
end)

Options.AmbienceColor1:OnChanged(function(V)
	if (not Toggles.Ambience.Value) then return end

	Bloom.Services.Lighting.Ambient							= Options.AmbienceColor1.Value
	Bloom.Services.Lighting.OutdoorAmbient						= Options.AmbienceColor2.Value
end)


-- #endregion

-- #Region // Render

-- #Region // Players
Bloom.Functions.FriendCheck = function(Player, Type)
	local Displays											= Options.ColorDisplays.GetActiveValues(Options.ColorDisplays)



	if Toggles.PlayerFT.Value and table.find(Displays, Type) and Visuals.FriendsWith[Player]  then
		return true
	end

	return false
end

Bloom.Functions.PrioritizeCheck = function(Player, Type)
	local Displays											= Options.ColorDisplays.GetActiveValues(Options.ColorDisplays)
	local Displays2											= Options.PrioritizeD.GetActiveValues(Options.PrioritizeD)


	if Toggles.PlayerPT.Value and table.find(Displays, Type) and table.find(Displays2, Player.Name)  then
		return true
	end

	return false
end

Bloom.Functions.TargetCheck = function(Player, Type)
	local Displays											= Options.ColorDisplays.GetActiveValues(Options.ColorDisplays)
	local Displays2											= Options.TargetD.GetActiveValues(Options.TargetD)


	if Toggles.PlayerTT.Value and table.find(Displays, Type) and table.find(Displays2, Player.Name)  then
		return true
	end

	return false
end

Bloom.Functions.NewConnection("Player ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.PlayerRate) < ((Options.PlayerVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.PlayerRate									= tick()

	for Player, Data in next, Visuals.Players do
		if (not Toggles.PlayerV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Player) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Player.Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local TCharacter 										= Player.Character
		local THead												= TCharacter:FindFirstChild("Head")
		local THumanoid											= TCharacter:FindFirstChildWhichIsA("Humanoid")
		local THumanoidRootPart									= TCharacter:FindFirstChild("HumanoidRootPart")

		if (not THead) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not THumanoid) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not TCharacter) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not THumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local MaxHealth, Health 								= THumanoid.MaxHealth, THumanoid.Health
		local Distance 											= math.floor((HumanoidRootPart.Position - THumanoidRootPart.Position).Magnitude)
		local Check 											= ObjectVisible(TCharacter)
		local Tool 												= TCharacter:FindFirstChildWhichIsA("Tool")

		if (not Health) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not MaxHealth) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Check) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (Health <= 0) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (Distance > Options.PlayerVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Info 												= CalculateBox(TCharacter, "Static", THumanoidRootPart, Vector3.new(0, -0.5, 0), { 5, 7 })
		local Objects 											= {
			Top 												= {
				Data.Name
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {
				Data.Telemetry,
				Data.Tool
			},

			Follow 												= {
				Data.Health
			}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Objects) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W + 2, Info.H + 2)
		Data.Box.Position 										= Vector2.new(Info.X - 1, Info.Y - 1)
		Data.Box.Visible 										= Toggles.PlayerVBox.Value
		Data.Box.Color											= Options.PlayerBC.Value

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.PlayerVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= Options.PlayerBOC.Value

		-- Health Bar
		Data.HealthBarOutline.From 								= Data.BoxOutline.Position + Vector2.new(-4, -1)
		Data.HealthBarOutline.To 								= Data.BoxOutline.Position + Vector2.new(-4, Data.BoxOutline.Size.Y + 1)
		Data.HealthBarOutline.Visible 							= Toggles.PlayerVHealthBar.Value

		Data.HealthBar.From 									= Data.HealthBarOutline.To + Vector2.new(0, -1)
		Data.HealthBar.To 										= Data.HealthBarOutline.To:Lerp(Data.HealthBarOutline.From, Health / MaxHealth) + Vector2.new(0, 1)
		Data.HealthBar.Color 									= Options.PlayerHBLC.Value:Lerp(Options.PlayerHBFC.Value, Health / MaxHealth)
		Data.HealthBar.Visible 									= Data.HealthBarOutline.Visible

		-- Labels
		Data.Name.Text 											= Player.Name
		Data.Name.Visible 										= Toggles.PlayerVNameText.Value
		Data.Name.Color											= Bloom.Functions.TargetCheck(Player, "ESP") and Options.PlayerTC.Value or Bloom.Functions.PrioritizeCheck(Player, "ESP") and Options.PlayerPTC.Value or Bloom.Functions.FriendCheck(Player, "ESP") and Options.PlayerFTC.Value or Options.PlayerNTC.Value

		Data.Name.OutlineColor									= Options.PlayerNTOC.Value

		Data.Tool.Text 											= (Tool) and Tool.Name or ""
		Data.Tool.Visible 										= (Toggles.PlayerVToolText.Value and Tool) and true or false
		Data.Tool.Color											= Options.PlayerTTC.Value
		Data.Tool.OutlineColor									= Options.PlayerTTOC.Value

		Data.Distance.Text 										= string.format("[%sm]", Distance)
		Data.Distance.Visible 									= Toggles.PlayerVDistanceText.Value
		Data.Distance.Color										= Options.PlayerDTC.Value
		Data.Distance.OutlineColor								= Options.PlayerDTOC.Value

		Data.Health.Text 										= string.format("%s", math.floor(Health))
		Data.Health.Visible 									= Toggles.PlayerVHealthText.Value
		Data.Health.Color										= Options.PlayerHTC.Value
		Data.Health.OutlineColor								= Options.PlayerHTOC.Value

		Data.Telemetry.Text 									= "Bloom User"
		Data.Telemetry.Visible 									= (Toggles.PlayerVTelemetryText.Value and Telemetry and table.find(Telemetry.Users, Player.Name)) and true or false
		Data.Telemetry.Color									= Options.PlayerWTC.Value
		Data.Telemetry.OutlineColor								= Options.PlayerWTOC.Value

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.PlayerVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.Size)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)
-- #EndRegion

-- #Region // Dealers
Bloom.Functions.NewConnection("Dealer ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.DealerRate) < ((Options.DealerVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.DealerRate									= tick()

	for Dealer, Data in next, Visuals.Dealers do
		if (not Toggles.DealerV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Dealer) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local TCharacter 										= Dealer
		local THead												= TCharacter:FindFirstChild("Head")
		local THumanoid											= TCharacter:FindFirstChildWhichIsA("Humanoid")
		local THumanoidRootPart									= TCharacter:FindFirstChild("HumanoidRootPart")

		if (not THead) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not THumanoid) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not TCharacter) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not THumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Distance 											= math.floor((HumanoidRootPart.Position - THumanoidRootPart.Position).Magnitude)
		local Type 												= string.gsub(TCharacter.Name, "Man", "")

		if (Distance > Options.DealerVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Type) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Info 												= CalculateBox(TCharacter, "Static", THumanoidRootPart, Vector3.new(0, -0.5, 0), { 5, 7 })
		local Objects 											= {
			Top 												= {
				Data.Type
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {},
			Follow 												= {}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W + 2, Info.H + 2)
		Data.Box.Position 										= Vector2.new(Info.X - 1, Info.Y - 1)
		Data.Box.Visible 										= Toggles.DealerVBox.Value
		Data.Box.Color											= (Type == "Armory" and Options.ArmoryBC.Value) or (Type == "Dealer" and Options.IllegalBC.Value)

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.DealerVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= (Type == "Armory" and Options.ArmoryBOC.Value) or (Type == "Dealer" and Options.IllegalBOC.Value)

		-- Labels
		Data.Type.Text 											= (Type == "Armory" and "Armory Dealer") or (Type == "Dealer" and "Illegal Dealer")
		Data.Type.Visible 										= Toggles.DealerVTypeText.Value
		Data.Type.Color											= Data.Box.Color
		Data.Type.OutlineColor									= Data.BoxOutline.Color

		Data.Distance.Text 										= string.format("[%sm]", Distance)
		Data.Distance.Visible 									= Toggles.DealerVDistanceText.Value
		Data.Distance.Color										= Data.Box.Color
		Data.Distance.OutlineColor								= Data.BoxOutline.Color

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.DealerVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.Size)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)
-- #EndRegion

-- #Region // Register
Bloom.Functions.NewConnection("Register ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.RegisterRate) < ((Options.RegisterVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.RegisterRate								= tick()

	for Register, Data in next, Visuals.Registers do
		if (not Toggles.RegisterV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Register) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local MainPart 											= Register:FindFirstChild("MainPart")
		local Values 											= Register:FindFirstChild("Values")

		if (not MainPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Values) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Distance											= math.floor((MainPart.Position - HumanoidRootPart.Position).Magnitude)
		local Broken 											= Values.Broken.Value

		if (Distance > Options.RegisterVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end		
		if (Toggles.RegisterVBrokenCheck.Value and Broken) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Info 												= CalculateBox(Register, "Static", MainPart, Vector3.new(0, 0, 0), { 3.5, 3.5 })
		local Objects 											= {
			Top 												= {
				Data.Status,
				Data.Type
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {},
			Follow 												= {}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W + 2, Info.H + 2)
		Data.Box.Position 										= Vector2.new(Info.X - 1, Info.Y - 1)
		Data.Box.Visible 										= Toggles.RegisterVBox.Value
		Data.Box.Color											= Options.RegisterBC.Value

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.RegisterVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= Options.RegisterBOC.Value

		-- Labels
		Data.Type.Text 											= "Register"
		Data.Type.Visible 										= Toggles.RegisterVTypeText.Value
		Data.Type.Color											= Options.RegisterTTC.Value
		Data.Type.OutlineColor									= Options.RegisterTTOC.Value

		Data.Distance.Text 										= string.format("[%sm]", Distance)
		Data.Distance.Visible 									= Toggles.RegisterVDistanceText.Value
		Data.Distance.Color										= Options.RegisterDTC.Value
		Data.Distance.OutlineColor								= Options.RegisterDTOC.Value

		Data.Status.Text 										= string.format("Status: %s", Broken and "Broken" or "Not Broken")
		Data.Status.Visible 									= Toggles.RegisterVStatusText.Value
		Data.Status.Color										= Options.RegisterSTC.Value
		Data.Status.OutlineColor								= Options.RegisterSTOC.Value

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.RegisterVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.TextBounds.Y)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)
-- #EndRegion

-- #Region // Safe
Bloom.Functions.NewConnection("Safe ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.SafeRate) < ((Options.SafeVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.SafeRate									= tick()

	for Safe, Data in next, Visuals.Safes do
		if (not Toggles.SafeV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Safe) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local MainPart 											= Safe:FindFirstChild("MainPart")
		local Values 											= Safe:FindFirstChild("Values")

		if (not MainPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Values) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Distance											= math.floor((MainPart.Position - HumanoidRootPart.Position).Magnitude)
		local Broken 											= Values.Broken.Value
		local Type 												= (string.find(Safe.Name, "Small") and "Small") or (string.find(Safe.Name, "Medium") and "Big")

		if (Distance > Options.SafeVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end		
		if (Toggles.SafeVBrokenCheck.Value and Broken) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not table.find(Options.SafeVSize:GetActiveValues(), Type)) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Info 												= CalculateBox(Safe, "Static", MainPart, Vector3.new(0, 0, 0), Type == "Small" and { 4, 4 } or { 5, 5 })
		local Objects 											= {
			Top 												= {
				Data.Status,
				Data.Rarity,
				Data.Type
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {},
			Follow 												= {}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W, Info.H)
		Data.Box.Position 										= Vector2.new(Info.X, Info.Y)
		Data.Box.Visible 										= Toggles.SafeVBox.Value
		Data.Box.Color											= (Type == "Big" and Options.SafeBBC.Value) or (Type == "Small" and Options.SafeSBC.Value)

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.SafeVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= (Type == "Big" and Options.SafeBBOC.Value) or (Type == "Small" and Options.SafeSBOC.Value)

		-- Objects
		Data.Type.Text 											= "Safe"
		Data.Type.Visible 										= Toggles.SafeVTypeText.Value
		Data.Type.Color											= Data.Box.Color
		Data.Type.OutlineColor									= Data.BoxOutline.Color

		Data.Rarity.Text 										= string.format("Size: %s", Type)
		Data.Rarity.Visible 									= Toggles.SafeVRarityText.Value
		Data.Rarity.Color										= Data.Box.Color
		Data.Rarity.OutlineColor								= Data.BoxOutline.Color

		Data.Status.Text 										= string.format("Status: %s", Values.Broken.Value and "Broken" or "Not Broken")
		Data.Status.Visible 									= Toggles.SafeVStatusText.Value
		Data.Status.Color										= Data.Box.Color
		Data.Status.OutlineColor								= Data.BoxOutline.Color

		Data.Distance.Text 										= string.format("%s Studs", Distance)
		Data.Distance.Visible 									= Toggles.SafeVDistanceText.Value
		Data.Distance.Color										= Data.Box.Color
		Data.Distance.OutlineColor								= Data.BoxOutline.Color

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.SafeVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.TextBounds.Y)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)
-- #EndRegion

-- #Region // Scrap
Bloom.Functions.NewConnection("Scrap ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.ScrapRate) < ((Options.ScrapVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.ScrapRate									= tick()

	for Scrap, Data in next, Visuals.Scraps do		
		if (not Toggles.ScrapV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Scrap) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local MainPart 											= Scrap.PrimaryPart
		local Distance 											= math.floor((MainPart.Position - HumanoidRootPart.Position).Magnitude)

		if (not MainPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (Distance > Options.ScrapVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end		

		local Info 												= CalculateBox(Scrap, "Static", MainPart, Vector3.new(0, 0, 0), { 3.5, 3.5 })
		local Objects 											= {
			Top 												= {
				Data.Type
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {},
			Follow 												= {}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W, Info.H)
		Data.Box.Position 										= Vector2.new(Info.X, Info.Y)
		Data.Box.Visible 										= Toggles.ScrapVBox.Value
		Data.Box.Color											= Options.ScrapBC.Value

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.ScrapVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= Options.ScrapBOC.Value

		-- Objects
		Data.Type.Text 											= "Scrap"
		Data.Type.Visible 										= Toggles.ScrapVTypeText.Value
		Data.Type.Color											= Data.Box.Color
		Data.Type.OutlineColor									= Data.BoxOutline.Color

		Data.Distance.Text 										= string.format("%s Studs", Distance)
		Data.Distance.Visible 									= Toggles.ScrapVDistanceText.Value
		Data.Distance.Color										= Data.Box.Color
		Data.Distance.OutlineColor								= Data.BoxOutline.Color

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.ScrapVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.TextBounds.Y)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)
-- #EndRegion

-- #Region // Crate
Bloom.Functions.NewConnection("Crate ESP", Bloom.Connections, Bloom.Services.RunService.RenderStepped, function(Delta)
	if (tick() - Bloom.Cooldowns.CrateRate) < ((Options.CrateVUpdateRate.Value / 60) / 60) then return end

	Bloom.Cooldowns.CrateRate									= tick()	

	for Crate, Data in next, Visuals.Crates do		
		if (not Toggles.CrateV.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Crate) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Character 										= Bloom.Client.Character
		local HumanoidRootPart 									= Character:FindFirstChild("HumanoidRootPart")

		if (not Character) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not HumanoidRootPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local MainPart 											= Crate.PrimaryPart
		local Distance 											= math.floor((MainPart.Position - HumanoidRootPart.Position).Magnitude)
		local Color 											= tostring(MainPart.Particle.Color)
		local Type 												= (Color == "0 0.184314 1 0.4 0 1 0.184314 1 0.4 0 " and "Green") or (Color == "0 1 0.184314 0.184314 0 1 1 0.184314 0.184314 0 " and "Red") or (Color == "0 1 0.666667 0 0 1 1 0.666667 0 0 " and "Gold")

		if (not MainPart) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Color) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (not Type) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end
		if (Distance > Options.CrateVMaxDistance.Value) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end		
		if (not table.find(Options.CrateVRarities:GetActiveValues(), Type)) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		local Info 												= CalculateBox(Crate, "Static", MainPart, Vector3.new(0, 0, 0), { 6, 4 })
		local Objects 											= {
			Top 												= {
				Data.Rarity, 
				Data.Type
			},

			Bottom 												= {
				Data.Distance
			},

			Side 												= {},
			Follow 												= {}
		}

		if (not Info) then for _, Drawing in next, Data do if Drawing.Visible == false then continue end Drawing.Visible = false end continue end

		-- Box
		Data.Box.Size 											= Vector2.new(Info.W + 2, Info.H + 2)
		Data.Box.Position 										= Vector2.new(Info.X - 1, Info.Y - 1)
		Data.Box.Visible 										= Toggles.CrateVBox.Value
		Data.Box.Color											= (Type == "Green" and Options.CrateGBC.Value) or (Type == "Red" and Options.CrateRBC.Value) or (Type == "Gold" and Options.CrateLBC.Value)

		Data.BoxOpacity.Size 									= Data.Box.Size
		Data.BoxOpacity.Position 								= Data.Box.Position
		Data.BoxOpacity.Visible 								= Data.Box.Visible
		Data.BoxOpacity.Transparency							= Options.CrateVOBT.Value

		Data.BoxOutline.Size 									= Data.Box.Size
		Data.BoxOutline.Position 								= Data.Box.Position
		Data.BoxOutline.Visible 								= Data.Box.Visible
		Data.BoxOutline.Color									= (Type == "Green" and Options.CrateGBOC.Value) or (Type == "Red" and Options.CrateRBOC.Value) or (Type == "Gold" and Options.CrateLBOC.Value)

		-- Objects
		Data.Type.Text 											= "Crate"
		Data.Type.Visible 										= Toggles.CrateVTypeText.Value
		Data.Type.Color											= Data.Box.Color
		Data.Type.OutlineColor									= Data.BoxOutline.Color

		Data.Rarity.Text 										= string.format("Rarity: %s", Type)
		Data.Rarity.Visible 									= Toggles.CrateVRarityText.Value
		Data.Rarity.Color										= Data.Box.Color
		Data.Rarity.OutlineColor								= Data.BoxOutline.Color

		Data.Distance.Text 										= string.format("%s Studs", Distance)
		Data.Distance.Visible 									= Toggles.CrateVDistanceText.Value
		Data.Distance.Color										= Data.Box.Color
		Data.Distance.OutlineColor								= Data.BoxOutline.Color

		-- Order
		for Direction, List in next, Objects do
			local Skips 										= 0

			for Index, Object in next, List do
				if (not Object.Visible) then Skips += 1 continue end

				local Index 									= (Index - Skips)
				local Direction									= Direction
				local Object 									= Object

				Object.Font 									= Options.CrateVFont.Value

				if (Direction == "Top") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y - 2 - (Index * Object.Size))
				end

				if (Direction == "Bottom") then
					Object.Center								= true
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X / 2, Data.BoxOutline.Position.Y + Data.BoxOutline.Size.Y + ((Index - 1) * Object.Size))
				end

				if (Direction == "Side") then
					Object.Center								= false
					Object.Position								= Vector2.new(Data.BoxOutline.Position.X + Data.BoxOutline.Size.X + 3, Data.BoxOutline.Position.Y + (Index - 1) * Object.TextBounds.Y)
				end

				if (Direction == "Follow") then
					Object.Center								= false
					Object.Position								= Data.HealthBar.To + Vector2.new(-2 - Object.TextBounds.X, -2)
				end
			end
		end
	end
end)

task.spawn(function() -- IS FRIENDS LOOP CHECK
	while wait(5) do
		for Player, Data in Visuals.Players do
			if Player.IsFriendsWith(Player, Bloom.Client.UserId) then
				Visuals.FriendsWith[Player] = true
			else
				Visuals.FriendsWith[Player] = false
			end
		end
	end
end)

-- #EndRegion

-- #EndRegion

Library:Notify(string.format("Loaded Visual.lua in %.4f MS", tick() - Bloom.Data.Start))
