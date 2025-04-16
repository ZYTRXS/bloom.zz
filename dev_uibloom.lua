-- // Clear
if Bloom.Functions.CleanUp then Bloom.Functions.CleanUp() end

local Repository												= "https://raw.githubusercontent.com/fatalespion/Fondra/refs/heads/main/"

local Library 													= loadstring(Bloom.Functions.SecureGet(Repository .. "Library.lua"))()
local ThemeManager 												= loadstring(Bloom.Functions.SecureGet(Repository .. "ThemeManager.lua"))()
local SaveManager 												= loadstring(Bloom.Functions.SecureGet(Repository .. "SaveManager.lua"))()

do
	Bloom.Data.FOV                                             = Drawing.new("Circle")
	Bloom.Data.FOV.Radius                                      = 30
	Bloom.Data.FOV.Visible                                     = false
	Bloom.Data.FOV.Thickness                                   = 2
end

local Window 													= Library:CreateWindow({
	Title 														= "Bloom.cc",
	Center 														= true,
	AutoShow 													= true,
	TabPadding 													= 1,
	MenuFadeTime 												= 0.1
})

local RageBot													= Window:AddTab("Ragebot") do
	local Main 												= RageBot:AddLeftGroupbox("Main") do
		Main:AddToggle("RageBot", {
			Text                = "Enabled",
			Default             = false
		}):AddKeyPicker("RageBotKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Rage Bot",
			NoUI 				= false
		})

		Main:AddToggle("RageBotFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		Main:AddToggle("RageBotDowned", {
			Text                = "Downed Check",
			Default             = false
		})

		Main:AddDivider()

		Main:AddToggle("RageBotFasterHit", {
			Text                = "Faster Hit",
			Default             = false,
			Risky               = true
		}):AddKeyPicker("FasterHitKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Faster Hit",
			NoUI 				= false
		})

		Main:AddToggle("RageBotInstantHit", {
			Text                = "Instant Hit",
			Default             = false,
			Risky               = true
		}):AddKeyPicker("InstantHitKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Instant Hit",
			NoUI 				= false
		})

		Main:AddDivider()

		Main:AddToggle("RageBotNotify", {
			Text                = "Hit Notify",
			Default             = false
		})

		Main:AddToggle("RageBotAnimation", {
			Text                = "Fire Animation",
			Default             = false
		})

		Main:AddToggle("RageBotSound", {
			Text                = "Fire Sound",
			Default             = false
		})

		Main:AddDivider()

		Main:AddDropdown("RageBotMode", {
			Values              = {"Auto", "Hold"},
			Default             = 1,
			Multi               = false,
			AllowNull           = false,
			Text                = "Mode"
		})

		Main:AddDropdown("RageBotParts", {
			Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
			Default             = 1,
			Multi               = true,
			AllowNull           = false,
			Text                = "Hit Parts"
		})

		Main:AddSlider("RageBotDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 2000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})

		Main:AddDivider()

		Main:AddDropdown("PrioritizeD", {
			Values              = {},
			Default             = 0,
			Multi               = true,
			AllowNull           = true,
			SpecialType			= "Player",
			Text                = "Prioritize"
		})

		Main:AddDropdown("TargetD", {
			Values              = {},
			Default             = 0,
			Multi               = true,
			AllowNull           = true,
			SpecialType			= "Player",
			Text                = "Target"
		})
	end
end

local Main1 												= RageBot:AddRightGroupbox("Movement & AA") do
	Main1:AddToggle("SBot", {
		Text                = "Spin Bot",
		Default             = false
	}):AddKeyPicker("SpinBotKey", {
		Default 			= "Esc",
		SyncToggleState 	= true,
		Mode 				= "Toggle",

		Text 				= "Spin Bot",
		NoUI 				= false
	})

	Main1:AddToggle("HAnti", {
		Text                = "Head AA",
		Default             = false
	}):AddKeyPicker("HAntiKey", {
		Default 			= "Esc",
		SyncToggleState 	= true,
		Mode 				= "Toggle",

		Text 				= "Head AA",
		NoUI 				= false
	})

	Main1:AddDivider()

	Main1:AddToggle("BHop", {
		Text                = "Bunny Hop",
		Default             = false
	}):AddKeyPicker("BunnyHopKey", {
		Default 			= "Esc",
		SyncToggleState 	= true,
		Mode 				= "Toggle",

		Text 				= "Bunny Hop",
		NoUI 				= false
	})
end


local LegitBot													= Window:AddTab("LegitBot") do
	local Main2 												= LegitBot:AddLeftGroupbox("Main") do
		Main2:AddToggle("LegitBot", {
			Text                = "Enabled",
			Default             = false
		}):AddKeyPicker("LegitBotKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Legit Bot",
			NoUI 				= false
		})

		Main2:AddToggle("LegitBotFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		Main2:AddToggle("LegitBotDowned", {
			Text                = "Downed Check",
			Default             = false
		})

		Main2:AddToggle("LegitBotFOV", {
			Text                = "Show FOV",
			Default             = false
		})

		Main2:AddDivider()

		Main2:AddDropdown("LegitBotParts", {
			Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
			Default             = 1,
			Multi               = true,
			AllowNull           = false,
			Text                = "Hit Parts"
		})

		Main2:AddSlider("LegitBotRadius", {
			Text                = "Radius",
			Min                 = 0,
			Max                 = 500,
			Default             = 100,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " PX",
		})

		Main2:AddSlider("LegitBotDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 2000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})

		Main2:AddSlider("LegitBotHitChance", {
			Text                = "Hit Chance",
			Min                 = 0,
			Max                 = 100,
			Default             = 100,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "%",
		})
	end

	local MeleeAura 												= RageBot:AddRightGroupbox("Melee Aura") do
		MeleeAura:AddToggle("MeleeAura", {
			Text                = "Enabled",
			Default             = false
		})

		MeleeAura:AddToggle("MeleeAuraFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		MeleeAura:AddToggle("MeleeAuraDowned", {
			Text                = "Downed Check",
			Default             = false
		})

		MeleeAura:AddDivider()

		MeleeAura:AddDropdown("MeleeAuraParts", {
			Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
			Default             = 1,
			Multi               = true,
			AllowNull           = false,
			Text                = "Hit Parts"
		})

		MeleeAura:AddSlider("MeleeAuraDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 15,
			Default             = 15,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local TriggerBot 												= LegitBot:AddRightGroupbox("TriggerBot") do
		TriggerBot:AddToggle("TriggerBot", {
			Text                = "Enabled",
			Default             = false
		}):AddKeyPicker("TriggerBotKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Trigger Bot",
			NoUI 				= false
		})

		TriggerBot:AddToggle("TriggerBotFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		TriggerBot:AddToggle("TriggerBotDowned", {
			Text                = "Downed Check",
			Default             = false
		})

		TriggerBot:AddDivider()

		TriggerBot:AddDropdown("TriggerBotParts", {
			Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
			Default             = 1,
			Multi               = true,
			AllowNull           = false,
			Text                = "Hit Parts"
		})

		TriggerBot:AddSlider("TriggerBotDelay", {
			Text                = "Shoot Delay",
			Min                 = 0,
			Max                 = 1000,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		TriggerBot:AddSlider("TriggerBotDelayBS", {
			Text                = "Delay Between Shots",
			Min                 = 0,
			Max                 = 100,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		TriggerBot:AddSlider("TriggerBotDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 2000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})

		TriggerBot:AddSlider("TriggerBotShootChance", {
			Text                = "Shoot Chance",
			Min                 = 0,
			Max                 = 100,
			Default             = 100,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "%",
		})
	end

	local FinishAura 											= RageBot:AddLeftGroupbox("Finish Aura") do
		FinishAura:AddToggle("FinishAura", {
			Text                = "Enabled",
			Default             = false
		})

		FinishAura:AddToggle("FinishAuraFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		FinishAura:AddSlider("FinishAuraDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 10,
			Default             = 10,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local GunMods 												= RageBot:AddRightGroupbox("Gun Mods") do
		GunMods:AddSlider("RecoilPercentage", {
			Text                = "Recoil",
			Min                 = 0,
			Max                 = 100,
			Default             = 100,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "%",
		})

		GunMods:AddSlider("SpreadPercentage", {
			Text                = "Spread",
			Min                 = 0,
			Max                 = 100,
			Default             = 100,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "%",
		})
	end

	local SprayAura 											= RageBot:AddLeftGroupbox("Spray Aura") do
		SprayAura:AddToggle("SprayAura", {
			Text                = "Enabled",
			Default             = false
		})

		SprayAura:AddToggle("SprayAuraFriendly", {
			Text                = "Friendly Check",
			Default             = false
		})

		SprayAura:AddToggle("SprayAuraDowned", {
			Text                = "Downed Check",
			Default             = false
		})

		SprayAura:AddDivider()

		SprayAura:AddSlider("SprayAuraDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 15,
			Default             = 15,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Projectile 											= RageBot:AddRightGroupbox("Projectile Controllers") do
		Projectile:AddToggle("GLController", {
			Text                = "Grenade Launcher",
			Default             = false
		})

		Projectile:AddToggle("HLController", {
			Text                = "Hallow's Launcher",
			Default             = false
		})

		Projectile:AddToggle("RLController", {
			Text                = "Rocket Launcher",
			Default             = false
		})

		Projectile:AddToggle("C4Controller", {
			Text                = "C4",
			Default             = false
		})

		Projectile:AddDivider()

		Projectile:AddSlider("ProjectileSpeed", {
			Text                = "Projectiles Speed",
			Min                 = 0,
			Max                 = 200,
			Default             = 25,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})
	end
end

local Visual 													= Window:AddTab("Visual") do
	local Player 												= Visual:AddLeftGroupbox("Player") do
		Player:AddToggle("PlayerV", {
			Text                = "Enabled",
			Default             = false
		})

		Player:AddToggle("PlayerVBox", {
			Text                = "Box",
			Default             = false
		}):AddColorPicker("PlayerBC", { 
			Title               = "Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("PlayerBOC", { 
			Title               = "Box Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Player:AddToggle("PlayerVHealthBar", {
			Text                = "Health Bar",
			Default             = false
		}):AddColorPicker("PlayerHBLC", { 
			Title               = "Health Low",
			Default             = Color3.fromRGB(255, 92, 51)
		}):AddColorPicker("PlayerHBFC", { 
			Title               = "Health Full",
			Default             = Color3.fromRGB(0, 255, 157)
		})

		Player:AddToggle("PlayerVNameText", {
			Text                = "Name Text",
			Default             = false
		}):AddColorPicker("PlayerNTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)

		}):AddColorPicker("PlayerNTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})


		Player:AddToggle("PlayerVToolText", {
			Text                = "Tool Text",
			Default             = false
		}):AddColorPicker("PlayerTTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("PlayerTTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Player:AddToggle("PlayerVHealthText", {
			Text                = "Health Text",
			Default             = false
		}):AddColorPicker("PlayerHTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("PlayerHTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Player:AddToggle("PlayerVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		}):AddColorPicker("PlayerDTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("PlayerDTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Player:AddToggle("PlayerVTelemetryText", {
			Text                = "Telemetry Text",
			Default             = false
		}):AddColorPicker("PlayerWTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("PlayerWTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Player:AddDivider()

		Player:AddDropdown("ColorDisplays", {
			Values              = {"ESP", "CHAMS"},
			Default             = 1,
			Multi               = true,
			AllowNull           = true,
			Text                = "Display"
		})

		Player:AddToggle("PlayerFT", {
			Text                = "Friendly",
			Tooltip = "Displays if the player is your friend.",
			Default             = false
		}):AddColorPicker("PlayerFTC", { 
			Title               = "Color",
			Default             = Color3.fromRGB(141, 255, 92)
		})	

		Player:AddToggle("PlayerPT", {
			Text                = "Prioritize",
			Tooltip = "Displays if the player is on your prioritize list.",
			Default             = false
		}):AddColorPicker("PlayerPTC", { 
			Title               = "Color",
			Default             = Color3.fromRGB(255, 249, 66)
		})

		Player:AddToggle("PlayerTT", {
			Text                = "Target",
			Tooltip = "Displays if the player is on your target list.",
			Default             = false
		}):AddColorPicker("PlayerTC", { 
			Title               = "Color",
			Default             = Color3.fromRGB(255, 64, 64)
		})

		Player:AddDivider()

		Player:AddSlider("PlayerVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("PlayerVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Player:AddSlider("PlayerVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("PlayerVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 2000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Chams 												= Visual:AddRightGroupbox("Chams") do
		Chams:AddToggle("ChamsV", {
			Text                = "Enabled",
			Default             = false
		})

		Chams:AddToggle("OccludedV", {
			Text                = "Occluded",
			Default             = false
		}):AddColorPicker("OccludedVC", { 
			Title               = "Occluded",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Chams:AddToggle("VisibleV", {
			Text                = "Visible",
			Default             = false
		}):AddColorPicker("VisibleC", { 
			Title               = "Visible",
			Default             = Color3.fromRGB(30, 106, 220)
		})
	end

	local Dealer 												= Visual:AddRightGroupbox("Dealer") do
		Dealer:AddToggle("DealerV", {
			Text                = "Enabled",
			Default             = false
		})

		Dealer:AddToggle("DealerVBox", {
			Text                = "Box",
			Default             = false
		})

		Dealer:AddToggle("DealerVTypeText", {
			Text                = "Type Text",
			Default             = false
		})

		Dealer:AddToggle("DealerVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		})

		Dealer:AddDivider()

		Dealer:AddLabel("Illegal"):AddColorPicker("IllegalBC", { 
			Title               = "Dealer Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("IllegalBOC", { 
			Title               = "Dealer Box Outline",
			Default             = Color3.fromRGB(255, 166, 0)
		})

		Dealer:AddLabel("Armory"):AddColorPicker("ArmoryBC", { 
			Title               = "Dealer Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("ArmoryBOC", { 
			Title               = "Dealer Box Outline",
			Default             = Color3.fromRGB(0, 119, 255)
		})

		Dealer:AddDivider()

		Dealer:AddSlider("DealerVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Dealer:AddSlider("DealerVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Dealer:AddSlider("DealerVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Dealer:AddSlider("DealerVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 2000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Register 												= Visual:AddLeftGroupbox("Register") do
		Register:AddToggle("RegisterV", {
			Text                = "Enabled",
			Default             = false
		})

		Register:AddToggle("RegisterVBox", {
			Text                = "Box",
			Default             = false
		}):AddColorPicker("RegisterBC", { 
			Title               = "Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("RegisterBOC", { 
			Title               = "Box Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Register:AddToggle("RegisterVTypeText", {
			Text                = "Type Text",
			Default             = false
		}):AddColorPicker("RegisterTTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("RegisterTTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Register:AddToggle("RegisterVStatusText", {
			Text                = "Status Text",
			Default             = false
		}):AddColorPicker("RegisterSTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("RegisterSTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Register:AddToggle("RegisterVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		}):AddColorPicker("RegisterDTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("RegisterDTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Register:AddToggle("RegisterVBrokenCheck", {
			Text                = "Broken Check",
			Default             = false
		})

		Register:AddDivider()

		Register:AddSlider("RegisterVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Register:AddSlider("RegisterVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Register:AddSlider("RegisterVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Register:AddSlider("RegisterVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 1000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Safe 													= Visual:AddRightGroupbox("Safe") do
		Safe:AddToggle("SafeV", {
			Text                = "Enabled",
			Default             = false
		})

		Safe:AddToggle("SafeVBox", {
			Text                = "Box",
			Default             = false
		})

		Safe:AddToggle("SafeVTypeText", {
			Text                = "Type Text",
			Default             = false
		})

		Safe:AddToggle("SafeVStatusText", {
			Text                = "Status Text",
			Default             = false
		})

		Safe:AddToggle("SafeVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		})

		Safe:AddToggle("SafeVRarityText", {
			Text                = "Rarity Text",
			Default             = false
		})

		Safe:AddToggle("SafeVBrokenCheck", {
			Text                = "Broken Check",
			Default             = false
		})

		Safe:AddDivider()

		Safe:AddLabel("Small"):AddColorPicker("SafeSBC", { 
			Title               = "Safe Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("SafeSBOC", { 
			Title               = "Safe Box Outline",
			Default             = Color3.fromRGB(0, 255, 224)
		})

		Safe:AddLabel("Big"):AddColorPicker("SafeBBC", { 
			Title               = "Safe Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("SafeBBOC", { 
			Title               = "Safe Box Outline",
			Default             = Color3.fromRGB(255, 58, 58)
		})

		Safe:AddDivider()

		Safe:AddDropdown("SafeVSize", {
			Values              = {"Big", "Small"}, 
			Default             = 1,
			Multi               = true,
			AllowNull           = false,
			Text                = "Size"
		})

		Safe:AddSlider("SafeVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Safe:AddSlider("SafeVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Safe:AddSlider("SafeVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Safe:AddSlider("SafeVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 1000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Scrap 												= Visual:AddLeftGroupbox("Scrap") do
		Scrap:AddToggle("ScrapV", {
			Text                = "Enabled",
			Default             = false
		})

		Scrap:AddToggle("ScrapVBox", {
			Text                = "Box",
			Default             = false
		}):AddColorPicker("ScrapBC", { 
			Title               = "Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("ScrapBOC", { 
			Title               = "Box Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Scrap:AddToggle("ScrapVTypeText", {
			Text                = "Type Text",
			Default             = false
		}):AddColorPicker("ScrapTTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("ScrapTTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Scrap:AddToggle("ScrapVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		}):AddColorPicker("ScrapDTC", { 
			Title               = "Text",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("ScrapDTOC", { 
			Title               = "Text Outline",
			Default             = Color3.fromRGB(0, 0, 0)
		})

		Scrap:AddDivider()

		Scrap:AddSlider("ScrapVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Scrap:AddSlider("ScrapVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Scrap:AddSlider("ScrapVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Scrap:AddSlider("ScrapVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 1000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local Crate 												= Visual:AddRightGroupbox("Crate") do
		Crate:AddToggle("CrateV", {
			Text                = "Enabled",
			Default             = false
		})

		Crate:AddToggle("CrateVBox", {
			Text                = "Box",
			Default             = false
		})

		Crate:AddToggle("CrateVTypeText", {
			Text                = "Type Text",
			Default             = false
		})

		Crate:AddToggle("CrateVDistanceText", {
			Text                = "Distance Text",
			Default             = false
		})

		Crate:AddToggle("CrateVRarityText", {
			Text                = "Rarity Text",
			Default             = false
		})

		Crate:AddDivider()

		Crate:AddLabel("Green"):AddColorPicker("CrateGBC", { 
			Title               = "Safe Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("CrateGBOC", { 
			Title               = "Safe Box Outline",
			Default             = Color3.fromRGB(0, 255, 224)
		})

		Crate:AddLabel("Red"):AddColorPicker("CrateRBC", { 
			Title               = "Safe Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("CrateRBOC", { 
			Title               = "Safe Box Outline",
			Default             = Color3.fromRGB(255, 58, 58)
		})

		Crate:AddLabel("Gold"):AddColorPicker("CrateLBC", { 
			Title               = "Safe Box",
			Default             = Color3.fromRGB(255, 255, 255)
		}):AddColorPicker("CrateLBOC", { 
			Title               = "Safe Box Outline",
			Default             = Color3.fromRGB(255, 174, 0)
		})

		Crate:AddDivider()

		Crate:AddDropdown("CrateVRarities", {
			Values              = {"Gold", "Red", "Green"}, 
			Default             = 2,
			Multi               = true,
			AllowNull           = false,
			Text                = "Rarities"
		})

		Crate:AddSlider("CrateVOBT", {
			Text                = "Overlay Box Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.4,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Crate:AddSlider("CrateVUpdateRate", {
			Text                = "Update Rate",
			Min                 = 0,
			Max                 = 500,
			Default             = 150,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " MS",
		})

		Crate:AddSlider("CrateVFont", {
			Text                = "Font",
			Min                 = 0,
			Max                 = 3,
			Default             = 1,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Crate:AddSlider("CrateVMaxDistance", {
			Text                = "Distance",
			Min                 = 0,
			Max                 = 1000,
			Default             = 500,
			Rounding            = 0,
			Compact             = true,
			Suffix              = " Meters",
		})
	end

	local World 												= Visual:AddLeftGroupbox("World") do
		World:AddToggle("Ambience", {
			Text                = "Ambience",
			Default             = false
		}):AddColorPicker("AmbienceColor1", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Ambience 1",
			Transparency        = 0,
		}):AddColorPicker("AmbienceColor2", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Ambience 2",
			Transparency        = 0,
		})

		World:AddToggle("Shift", {
			Text                = "Color Shift",
			Default             = false
		}):AddColorPicker("ShiftColor1", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Shift Color 1",
			Transparency        = 0,
		}):AddColorPicker("ShiftColor2", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Shift Color 2",
			Transparency        = 0,
		})

		World:AddToggle("SkyBox", {
			Text                = "Sky Box",
			Default             = false
		})

		World:AddToggle("ShadowMap", {
			Text                = "Shadow Map",
			Default             = true
		})

		World:AddToggle("ForceTime", {
			Text                = "Force Time",
			Default             = false
		})

		World:AddToggle("ForceLatitude", {
			Text                = "Force Latitude",
			Default             = false
		})

		World:AddToggle("ForceDiffuse", {
			Text                = "Force Diffuse",
			Default             = false
		})

		World:AddDivider()

		World:AddDropdown("SelectedSkyBox", {
			Values              = {"Default"}, 
			Default             = 0,
			Multi               = false,
			Text                = "Sky Box"
		})

		World:AddButton({
			Text                = "Refresh List",
			DoubleClick         = false,
			Func                = function()
				Options.SelectedSkyBox:SetValues(Bloom.Functions.GetSkyBoxes())
				Options.SelectedSkyBox:SetValue("Default")
			end
		})

		World:AddDivider()

		World:AddSlider("SelectedTime", {
			Text                = "Time",
			Min                 = 0,
			Max                 = 24,
			Default             = 12,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		World:AddSlider("SelectedLatitude", {
			Text                = "Latitude",
			Min                 = -90,
			Max                 = 90,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		World:AddSlider("SelectedDiffuse", {
			Text                = "Diffuse",
			Min                 = 0,
			Max                 = 1,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})
	end

	local Viewmodel 											= Visual:AddRightGroupbox("Viewmodel") do
		Viewmodel:AddToggle("Viewmodel", {
			Text                = "Enabled",
			Default             = false
		}):AddColorPicker("ViewmodelToolColor", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Tools Color",
			Transparency        = 0,
		}):AddColorPicker("ViewmodelRArmColor", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Right Arm Color",
			Transparency        = 0,
		}):AddColorPicker("ViewmodelLArmColor", {
			Default             = Color3.fromRGB(0, 99, 228),
			Title               = "Left Arm Color",
			Transparency        = 0,
		})

		Viewmodel:AddDivider()

		Viewmodel:AddSlider("ViewmodelToolTransparency", {
			Text                = "Tool Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddSlider("ViewmodelRArmTransparency", {
			Text                = "Right Arm Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddSlider("ViewmodelLArmTransparency", {
			Text                = "Left Arm Transparency",
			Min                 = 0,
			Max                 = 1,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddDivider()

		Viewmodel:AddSlider("ViewmodelXOffset", {
			Text                = "X Offset",
			Min                 = -25,
			Max                 = 25,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddSlider("ViewmodelYOffset", {
			Text                = "Y Offset",
			Min                 = -25,
			Max                 = 25,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddSlider("ViewmodelZOffset", {
			Text                = "Z Offset",
			Min                 = -25,
			Max                 = 25,
			Default             = 0,
			Rounding            = 2,
			Compact             = true,
			Suffix              = "",
		})

		Viewmodel:AddDivider()

		Viewmodel:AddDropdown("ViewmodelArmsMaterial", {
			Values              = {"SmoothPlastic", "ForceField"}, 
			Default             = 1,
			Multi               = false,
			Text                = "Arms Material"
		})

		Viewmodel:AddDropdown("ViewmodelToolsMaterial", {
			Values              = {"SmoothPlastic", "ForceField"}, 
			Default             = 1,
			Multi               = false,
			Text                = "Tools Material"
		})
	end
end

local Misc = Window:AddTab("Misc") do 
	local Player 											    = Misc:AddLeftGroupbox("Player") do        
		Player:AddToggle("Fly", {
			Text                = "Fly",
			Default             = false
		}):AddKeyPicker("FlyKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Fly",
			NoUI 				= false
		})

		Player:AddToggle("Noclip", {
			Text                = "Noclip",
			Default             = false
		}):AddKeyPicker("NoclipKey", {
			Default 			= "Esc",
			SyncToggleState 	= true,
			Mode 				= "Toggle",

			Text 				= "Noclip",
			NoUI 				= false
		})

		Player:AddToggle("WalkSpeed", {
			Text                = "Walk Speed",
			Default             = false
		})

		Player:AddToggle("JumpPower", {
			Text                = "Jump Power",
			Default             = false
		})

		Player:AddToggle("InstantReload", {
			Text                = "Instant Reload",
			Default             = false
		})

		Player:AddToggle("Stamina", {
			Text                = "Infinite Stamina",
			Default             = false
		})

		Player:AddToggle("NoFail", {
			Text                = "No Lockpick Fail",
			Default             = false
		})

		Player:AddDivider()

		Player:AddDropdown("Disablers", {
			Values              = {"Grinders", "Barbwires", "Drowning", "Ragdoll", "Fall Damage", "Flashes", "Smokes"},
			Default             = 0,
			Multi               = true,
			AllowNull           = false,
			Text                = "Disablers"
		})

		Player:AddDivider()

		Player:AddDropdown("StatsMethod", {
			Values              = {"Default", "Bypass"},
			Default             = 2,
			Multi               = false,
			AllowNull           = false,
			Text                = "Stats Method"
		})

		Player:AddDivider()

		Player:AddDropdown("FlyMethod", {
			Values              = {"Default", "Bypass"},
			Default             = 2,
			Multi               = false,
			AllowNull           = false,
			Text                = "Fly Method"
		})

		Player:AddDivider()

		Player:AddSlider("FlySpeed", {
			Text                = "Fly Speed",
			Min                 = 0,
			Max                 = 100,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("SpinSpeed", {
			Text                = "Spin Speed",
			Min                 = 0,
			Max                 = 50,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("LagAmount", {
			Text                = "Lag Amount",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.25,
			Rounding            = 3,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("WalkSpeed", {
			Text                = "Walk Speed",
			Min                 = 0,
			Max                 = 70,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})

		Player:AddSlider("JumpPower", {
			Text                = "Jump Power",
			Min                 = 0,
			Max                 = 100,
			Default             = 50,
			Rounding            = 0,
			Compact             = true,
			Suffix              = "",
		})
	end

	local TabBox  											    = Misc:AddRightTabbox() do
		local Auto = TabBox:AddTab("Pickup") do
			Auto:AddToggle("AutoPickScraps", {
				Text            = "Auto Pickup Scraps",
				Default         = false
			})

			Auto:AddToggle("AutoPickCrates", {
				Text            = "Auto Pickup Crates",
				Default         = false
			})

			Auto:AddToggle("AutoPickTools", {
				Text            = "Auto Pickup Tools",
				Default         = false
			})

			Auto:AddToggle("AutoPickCash", {
				Text            = "Auto Pickup Cash",
				Default         = false
			})

			Auto:AddDivider()

			Auto:AddSlider("AutoPickRange", {
				Text            = "Range",
				Min             = 5,
				Max             = 10,
				Default         = 5,
				Rounding        = 2,
				Compact         = true,
				Suffix          = " Meters",
			}) 

			Auto:AddSlider("AutoPickDelay", {
				Text            = "Delay",
				Min             = 0.25,
				Max             = 5,
				Default         = 0.25,
				Rounding        = 2,
				Compact         = true,
				Suffix          = " Seconds",
			}) 
		end

		local Break = TabBox:AddTab("Break") do
			Break:AddToggle("BreakDoors", {
				Text            = "Doors",
				Default         = false
			})

			Break:AddToggle("BreakSafes", {
				Text            = "Safes",
				Default         = false
			})

			Break:AddToggle("BreakRegisters", {
				Text            = "Registers",
				Default         = false
			})

			Break:AddDivider()

			Break:AddDropdown("SafeMethod", {
				Values          = {"Melee", "Lockpick", "Both"},
				Default         = 1,
				Multi           = false,
				AllowNull       = false,
				Text            = "Safe Method"
			})

			Break:AddDivider()

			Break:AddDropdown("DoorMethod", {
				Values          = {"Melee", "Lockpick", "Both"},
				Default         = 1,
				Multi           = false,
				AllowNull       = false,
				Text            = "Door Method"
			})

			Break:AddButton({
				Text            = "Fix",
				DoubleClick     = false,
				Func            = function()
					Bloom.Cooldowns.BreakSafes                 = false
					Bloom.Cooldowns.BreakRegisters             = false
					Bloom.Cooldowns.BreakDoors                 = false
				end
			})
		end
	end

	local Misc 											        = Misc:AddRightGroupbox("Misc") do        
		Misc:AddToggle("ChatLogs", {
			Text                = "Show Chat Logs",
			Default             = false
		})

		Misc:AddToggle("InfinitePepperSpray", {
			Text                = "Infinite Pepper Spray",
			Default             = false
		})

		Misc:AddDivider()

		Misc:AddToggle("CustomHitMarker", {
			Text                = "Custom Hit Marker",
			Default             = false
		})

		Misc:AddSlider("CustomHitMarkerVolume", {
			Text                = "Volume",
			Min                 = 0,
			Max                 = 1,
			Default             = 0.5,
			Rounding            = 2,
			Compact             = true,
		})

		Misc:AddDropdown("SelectedHitMarker", {
			Values              = {"Default"},
			Default             = 1,
			Multi               = false,
			AllowNull           = false,
			Text                = "Sound"
		})

		Misc:AddButton({
			Text                = "Refresh List",
			DoubleClick         = false,
			Func                = function()
				Options.SelectedHitMarker:SetValues(Bloom.Functions.GetHitMarkers()) 
				Options.SelectedHitMarker:SetValue("Default")
			end
		})
	end
end


if true then
	
	local Developer = Window:AddTab("Developer") do 
		local DevTab 											        = Developer:AddLeftGroupbox("Redeem")
		DevTab:AddDropdown("SubscriptionType", {
			Values              = {"30 seconds", "1 hour", "5 hours", "12 hours", "1 day", "3 days", "15 days", "1 month", "3 months", "1 year", "lifetime"},
			Default             = 1,
			Multi               = false,
			AllowNull           = false,
			Text                = "Type"
		})

		DevTab:AddButton({
			Text                = "Create Subscription Key",
			DoubleClick         = true,
			Func                = function()
				local HttpService = game:GetService("HttpService")

				local durations = {
					["30 seconds"] = 30,
					["1 hour"] = 3600,
					["5 hours"] = 18000,
					["12 hours"] = 43200,
					["1 day"] = 86400,
					["3 days"] = 259200,
					["15 days"] = 1296000,
					["1 month"] = 2592000,
					["3 months"] = 7776000,
					["1 year"] = 31536000,
					["lifetime"] = 9999999999
				}


				local function generateSegment()
					local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
					local segment = ""
					for i = 1, 4 do
						local randIndex = math.random(1, #chars)
						segment = segment .. chars:sub(randIndex, randIndex)
					end
					return segment
				end

				local function createSubscriptionKey(durationType)
					local duration = durations[durationType]
					if not duration then
						error("Invalid duration type")
					end
					local key = string.format("%s-%s-%s-%s.ZZ", generateSegment(), generateSegment(), generateSegment(), generateSegment())
					local expiryTime = os.time() + duration
					local expiryISO = os.date("!%Y-%m-%dT%H:%M:%SZ", expiryTime)

					return {
						key = key,
						time = expiryISO,
						type = durationType
					}
				end

				-- LMAO
				local API_URL = "https://pwiwrrjeyoxefllnirtp.supabase.co/rest/v1/"
				local API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3aXdycmpleW94ZWZsbG5pcnRwIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NDA0ODI0OSwiZXhwIjoyMDU5NjI0MjQ5fQ.PZUkTKg74TyyugoebttoDDeHsadKzu2UsVzuEpFJ0cc"

				local function API(method, databaseName, postdata)
					local response

					if method == "GET" then
						response = request({
							Url = API_URL..databaseName,
							Method = method,
							Headers = {
								["apikey"] = API_KEY,
								["Authorization"] = "Bearer " .. API_KEY,
								["Content-Type"] = "application/json",
								["Prefer"] = "return=representation" 
							},
						})
					elseif method == "DELETE" then
						response = request({
							Url = API_URL .. "rpc/delete_key",
							Method = "POST",
							Headers = {
								["apikey"] = API_KEY,
								["Authorization"] = "Bearer " .. API_KEY,
								["Content-Type"] = "application/json",
							},
							Body = HttpService:JSONEncode({
								input_key = databaseName,
							}),
						})
					else
						local jsonData
						local success, errorMessage = pcall(function()
							jsonData = HttpService:JSONEncode(postdata)
						end)

						response = request({
							Url = API_URL..databaseName,
							Method = method,
							Headers = {
								["apikey"] = API_KEY,
								["Authorization"] = "Bearer " .. API_KEY,
								["Content-Type"] = "application/json",
								["Prefer"] = "return=representation" 
							},
							Body = jsonData
						})
					end

					return response
				end


				API("POST", "subscription_keys", {
					createSubscriptionKey(Options.SubscriptionType.Value)
				})
			end
		})
	end
end

local Settings = Window:AddTab("Settings") do end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("Bloom/Themes")
SaveManager:SetFolder("Bloom/Games/Criminality")

SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()

SaveManager:BuildConfigSection(Settings)
ThemeManager:BuildThemeSection(Settings)

Library.SaveManager             = SaveManager
Library.ThemeManager            = ThemeManager

Library:Notify(string.format("Loaded UI.lua in %.4f MS", tick() - Bloom.Data.Start))
