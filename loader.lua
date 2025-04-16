--//loader

repeat task.wait() until game:IsLoaded()

makefolder("Bloom")
makefolder("Bloom/Logs")
makefolder("Bloom/Assets")
makefolder("Bloom/Games")
makefolder("Bloom/Themes")
makefolder("Bloom/Fonts")

if ({...})[1] == nil then ({...})[1] = "Public" end
if ({...})[2] == nil then ({...})[2] = true end
if ({...})[3] == nil then ({...})[3] = "" end

if Bloom and Bloom.Functions.Unload then Bloom.Functions.Unload() end

getgenv().Bloom                        = {}
Bloom.UI                               = {}
Bloom.Cooldowns                        = {}

Bloom.Functions                        = {}
Bloom.Connections                      = {}
Bloom.Hooks                            = {}
Bloom.Ticks                            = {}

Bloom.Data                             = { Start = tick(), Game = "" }
Bloom.Loader                           = { Version = ({...})[1], Greeting = ({...})[2], Identifier = ({...})[3] }

Bloom.Game                             = game
Bloom.Services                         = setmetatable({}, {
	__index = function(Self, Service)
		local Cache    					= Bloom.Game.GetService(Bloom.Game, Service)

		rawset(Self, Service, Cache)

		return Cache
	end
})

Bloom.Client                           = Bloom.Services.Players.LocalPlayer
Bloom.Camera                           = Bloom.Services.Workspace.CurrentCamera
Bloom.Mouse                            = Bloom.Client.GetMouse(Bloom.Client)
Bloom.Random                           = Random.new()
Bloom.Method                           = request

Bloom.Functions.SecureGet              = function(Link, Custom)
	local Success, Result               = pcall(Bloom.Method, Custom or {
		Url                             = Link,
		Method                          = "GET"
	})

	if not Success then writefile("Bloom/Logs/Bloom-[" .. os.time() .. "]-.log", Result) return game:Shutdown() end
	if not typeof(Result) == "table" then writefile("Bloom/Logs/Bloom-[" .. os.time() .. "]-.log", Result) return game:Shutdown() end

	return Result.Body
end

Bloom.Functions.DownloadAsset          = function(Path, Link)
	local Path                          = string.format("Bloom/Assets/%s", Path)
	local Directorys 				    = {}

	Path:gsub("([^/]+)", function(Directory)
		table.insert(Directorys, Directory)
	end)

	table.remove(Directorys, #Directorys)

	for _, Directory in next, Directorys do
		local Directory                 = table.concat(Directorys, "/", 1, _)

		if isfolder(Directory) then continue end

		makefolder(Directory)
	end

	if (not isfile(Path)) then
		writefile(Path, Bloom.Functions.SecureGet(Link))
	end

	return true
end

Bloom.Functions.GetAsset               = function(Path)
	if not isfile(string.format("Bloom/Assets/%s", Path)) then return "rbxassetid://0" end

	return getcustomasset(string.format("Bloom/Assets/%s", Path))
end

Bloom.Functions.ClearHooks             = function(Table)
	local MT                            = getrawmetatable(game)

	setreadonly(MT, false)

	if Table.NewIndex then MT.__newindex = Table.NewIndex end
	if Table.Namecall then MT.__namecall = Table.Namecall end
	if Table.Index then MT.__index = Table.Index end

	setreadonly(MT, true)
end

Bloom.Functions.ClearConnections 		= function(Table)
	for Name, Connection in next, Table do
		Bloom.Functions.ClearConnection(Name, Table)
	end
end

Bloom.Functions.ClearConnection 		= function(Name, Table)
	if Table[Name] then
		Table[Name]:Disconnect()
		Table[Name] = nil

		return true
	end

	return false
end

Bloom.Functions.NewConnection		    = function(Name, Table, Type, Callback)
	local Connection 					= Type:Connect(Callback)

	Table[Name]                         = Connection

	return Connection
end

if true then
	Bloom.Loader.Version = "Developers"
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/src/dev_uibloom.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/src/dev_visuals.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/src/skyboxes.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/src/dev_mainbloom.lua"))()
	--loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/COPICALITY/Bloom-crimclone-/refs/heads/main/Main/Frameworks/Telemetry/Developers.lua"))()
	-- doesn't exist lol	
	warn("dev version")
else
	Bloom.Loader.Version = "Buyers"
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/fatalespion/Bloom/refs/heads/main/UIBloom.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/fatalespion/Bloom/refs/heads/main/Visuals.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://gist.githubusercontent.com/ZYTRXS/ebb06c6e3dd54cb4c9e51a82fd6f6359/raw/6958218158ace4377dedce0e5a475fb1b392060e/bcc-skyboxes.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/fatalespion/Bloom/refs/heads/main/MainBloom.lua"))()
	loadstring(Bloom.Functions.SecureGet("https://raw.githubusercontent.com/COPICALITY/Bloom-crimclone-/refs/heads/main/Main/Frameworks/Telemetry/Developers.lua"))()
end	


