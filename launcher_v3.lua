-- Cracked by Zytris

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

local repo = "https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/uilib/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()

local HttpService = game:GetService("HttpService")

local function LoadScript()
	local launcher = "https://raw.githubusercontent.com/ZYTRXS/bloom.zz/refs/heads/main/loader_v4.lua"
	loadstring((syn and syn.request or request)({
		Url=launcher,
		Method="GET"
	}).Body)()
end

local foundHwid = false

local cloneref = cloneref or function(ref) return ref end

if true then 
	if true then
		Library:Notify("✅ Valid")
		Library:Notify("Cracked by Zytris. End paid skidded hubs!")

		-- Remove this if you want
		cloneref(game:GetService("StarterGui")):SetCore("SendNotification", {
			Title = "Cracked by Zytris",
			Text = "Enjoy!",
			Icon = "rbxassetid://120557822972676",
			Duration = 10
		});
				
		LoadScript()
	end
end
