local QBCore = exports['qb-core']:GetCoreObject()

PlayerJob = {}
local onDuty = false
local alcoholCount = 0

local function installCheck()
	local items = { "bmochi", "pmochi", "gmochi", "omochi", "bobatea", "bbobatea", "gbobatea", "obobatea", "nekolatte", "sake",
					"miso", "cake", "bento", "riceball", "nekocookie", "nekodonut", "boba", "flour", "rice", "sugar", "nori", "blueberry", "strawberry",
					"orange", "mint", "tofu", "mocha", "cakepop", "pancake", "pizza", "purrito", "noodlebowl", "noodles", "ramen", "milk", "onion" }
	for k, v in pairs(items) do if QBCore.Shared.Items[v] == nil then print("Missing Item from QBCore.Shared.Items: '"..v.."'") end end
	if QBCore.Shared.Jobs["catcafe"] == nil then print("Error: Job role not found - 'catcafe'") end
	if Config.Debug then print((#Config.Chairs).." Total seating locations") print((#items).." Items required") end
end

local function jobCheck()
	canDo = true
	if not onDuty then TriggerEvent('QBCore:Notify', "Not clocked in!", 'error') canDo = false end
	return canDo
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
		installCheck()
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then if PlayerData.job.name == "catcafe" then TriggerServerEvent("QBCore:ToggleDuty") end end
    end)
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate') AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end) 
RegisterNetEvent('QBCore:Client:SetDuty') AddEventHandler('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource)
	installCheck()
    if GetCurrentResourceName() == resource then
		QBCore.Functions.GetPlayerData(function(PlayerData)
			PlayerJob = PlayerData.job
			if PlayerData.job.name == "catcafe" then onDuty = PlayerJob.onduty end 
		end)
    end
end)

CreateThread(function()
	local bossroles = {}
	for k, v in pairs(QBCore.Shared.Jobs["catcafe"].grades) do
		if QBCore.Shared.Jobs["catcafe"].grades[k].isboss == true then
			if bossroles["catcafe"] ~= nil then
				if bossroles["catcafe"] > tonumber(k) then bossroles["catcafe"] = tonumber(k) end
			else bossroles["catcafe"] = tonumber(k)	end
		end
	end
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].zoneEnable then
			JobLocation = PolyZone:Create(Config.Locations[k].zones, { name = Config.Locations[k].label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside) if not isPointInside and onDuty and PlayerJob.name == "catcafe" then TriggerServerEvent("QBCore:ToggleDuty") end end)	
		end
	end
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].zoneEnable then
			blip = AddBlipForCoord(Config.Locations[k].blip)	
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 89)
			SetBlipColour(blip, Config.Locations[k].blipcolor)
			SetBlipScale(blip, 0.7)
			SetBlipDisplay(blip, 6)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString("CatCafe")
			EndTextCommandSetBlipName(blip)
		end
	end
	--Stashes
	exports['qb-target']:AddBoxZone("CatPrepared", vector3(-587.4, -1059.6, 23.45), 2.0, 2.5, { name="CatPrepared", heading = 270.0, debugPoly=Config.Debug, minZ=21.45, maxZ=23.45 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-box-open", label = "Prepared Food", stash = "Shelf" }, },  distance = 2.0 })
	--FRIDGE
	exports['qb-target']:AddBoxZone("CatFridge", vector3(-588.06, -1067.1, 22.34), 3.5, 0.5, { name="CatFridge", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=23.84 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-temperature-low", label = "Open Fridge", stash = "Fridge", job = "catcafe" }, }, distance = 1.0 })		
	exports['qb-target']:AddBoxZone("CatFridge2", vector3(-590.67, -1068.1, 22.34), 2.0, 0.6, { name="CatFridge2", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=23.84 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-temperature-low", label = "Open Fridge", stash = "Fridge2", job = "catcafe"  }, }, distance = 1.0 })
	--WARESTORAGE
	exports['qb-target']:AddBoxZone("CatStorage", vector3(-598.0, -1068.47, 22.34), 4.0, 1.5, { name="CatStorage", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "hpx-CatCafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatStorage2", vector3(-598.25, -1065.61, 22.34), 4.0, 1.5, { name="CatStorage2", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "hpx-CatCafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatStorage3", vector3(-598.31, -1062.79, 22.34), 4.0, 1.5, { name="CatStorage3", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "hpx-CatCafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	--Sinks
	exports['qb-target']:AddBoxZone("CatWash1", vector3(-587.89, -1062.58, 22.36), 0.7, 0.7, { name="CatWash1", heading = 0, debugPoly=Config.Debug, minZ=19.11, maxZ=23.11 }, 
		{ options = { { event = "hpx-CatCafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.5	})		
	exports['qb-target']:AddBoxZone("CatWash2", vector3(-570.23, -1051.41, 22.34), 0.5, 0.5, { name="CatWash2", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, }, 
		{ options = { { event = "hpx-CatCafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.2	})		
	exports['qb-target']:AddBoxZone("CatWash3", vector3(-570.25, -1056.98, 22.34), 0.5, 0.5, { name="CatWash3", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, },
		{ options = { { event = "hpx-CatCafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.2 })
	--Oven
	exports['qb-target']:AddBoxZone("CatOven", vector3(-590.66, -1059.13, 22.34), 2.5, 0.6, { name="CatOven", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, }, 
		{ options = { { event = "hpx-CatCafe:Menu:Oven", icon = "fas fa-temperature-high", label = "Use Oven", job = "catcafe" }, }, distance = 2.0 })
	--Hob
	exports['qb-target']:AddBoxZone("CatHob", vector3(-591.02, -1056.56, 22.36), 1.5, 0.6, { name="CatHob", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, }, 
		{ options = { { event = "hpx-CatCafe:Menu:Hob", icon = "fas fa-temperature-high", label = "Use Hob", job = "catcafe" }, }, distance = 2.0 })
	--Trays
	exports['qb-target']:AddBoxZone("CatCounter", vector3(-584.01, -1059.27, 22.34), 0.6, 0.6, { name="CatCounter", heading = 0, debugPoly=Config.Debug, minZ=19.04, maxZ=23.04 }, 
		{ options = { { event = "hpx-CatCafe:Stash", icon = "fas fa-hamburger", label = "Open Counter", stash = "Counter" }, }, distance = 2.0	})	
	exports['qb-target']:AddBoxZone("CatCounter2", vector3(-584.04, -1062.05, 22.34), 0.6, 0.6, { name="CatCounter2", heading = 0, debugPoly=Config.Debug, minZ=19.04, maxZ=23.04 }, 
		{ options = { { event = "hpx-CatCafe:Stash", icon = "fas fa-hamburger", label = "Open Counter", stash = "Counter2" }, }, distance = 2.0	})
	--Payments
	exports['qb-target']:AddBoxZone("CatReceipt1", vector3(-584.07, -1058.69, 22.34), 0.5, 0.5, { name="CatReceipt1", heading = 0, debugPoly=Config.Debug, minZ = 19.04, maxZ = 23.04, }, 
		{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = "Charge Customer", job = "catcafe",
						img = "<center><p><img src=https://i.imgur.com/03eA7N0.png width=100px></p>"
					}, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatReceipt2", vector3(-584.09, -1061.47, 22.34), 0.5, 0.5, { name="CatReceipt2", heading = 0, debugPoly=Config.Debug, minZ = 19.04, maxZ = 23.04, }, 
		{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = "Charge Customer", job = "catcafe",
						img = "<center><p><img src=https://i.imgur.com/03eA7N0.png width=100px></p>"
					}, }, distance = 2.0 })	
	--Coffee
	exports['qb-target']:AddBoxZone("CatCoffee", vector3(-586.8, -1061.89, 22.34), 0.7, 0.5, { name="CatCoffee", heading = 0, debugPoly=Config.Debug, minZ=21.99, maxZ=23.19 }, 
		{ options = { { event = "hpx-CatCafe:Menu:Coffee", icon = "fas fa-mug-hot", label = "Pour Coffee", job = "catcafe" }, }, distance = 2.0 })
	--Chopping Board
	exports['qb-target']:AddBoxZone("CatBoard", vector3(-590.94, -1063.16, 22.36), 1.5, 0.6, { name="CatBoard", heading = 0, debugPoly=Config.Debug, minZ=18.96, maxZ=22.96, }, 
		{ options = { { event = "hpx-CatCafe:Menu:ChoppingBoard", icon = "fas fa-utensils", label = "Prepare Food", job = "catcafe" }, }, distance = 2.0 })	
	--Tables
	exports['qb-target']:AddBoxZone("CatTable", vector3(-573.43, -1059.76, 22.49), 1.9, 1.0, { name="CatTable", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_1" }, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatTable2", vector3(-573.44, -1063.45, 22.34), 1.9, 1.0, { name="CatTable2", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_2" }, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatTable3", vector3(-573.41, -1067.09, 22.49), 1.9, 1.0, { name="CatTable3", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_3" }, }, distance = 2.0 })
	exports['qb-target']:AddBoxZone("CatTable4", vector3(-578.68, -1051.09, 22.35), 1.2, 0.9, { name="CatTable4", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "hpx-CatCafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_4" }, }, distance = 2.0 })	
	--Clockin
	exports['qb-target']:AddBoxZone("CatClockin", vector3(-594.34, -1053.35, 22.34), 3.5, 0.5, { name="CatClockin", heading = 0, debugPoly=Config.Debug, minZ=22.19, maxZ=23.79 }, 
		{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = "Toggle Duty", job = "catcafe" },
					  --{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-clipboard-check", label = "Open Bossmenu", job = bossroles, }, 
					}, distance = 2.0 })
end)

RegisterNetEvent('hpx-CatCafe:washHands', function()
    QBCore.Functions.Progressbar('washing_hands', 'Washing hands', 5000, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
	{ animDict = "mp_arresting", anim = "a_uncuff", flags = 8, }, {}, {}, function()
		TriggerEvent('QBCore:Notify', "You've washed your hands!", 'success')
    end, function() -- Cancel
        TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Cancelled", 'error')
    end)
end)

RegisterNetEvent('hpx-CatCafe:MakeItem', function(data)
	if data.craftable then
		for k, v in pairs(data.craftable[data.tablenumber]) do
			QBCore.Functions.TriggerCallback('hpx-CatCafe:get', function(amount)
				if not amount then TriggerEvent('QBCore:Notify', "You don't have the correct ingredients", 'error') else TriggerEvent("hpx-CatCafe:FoodProgress", data) end		
			end, data.item, data.tablenumber, data.craftable)
		end
	end
end)

RegisterNetEvent('hpx-CatCafe:Stash', function(data) TriggerServerEvent("inventory:server:OpenInventory", "stash", "CatCafe_"..data.stash) TriggerEvent("inventory:client:SetCurrentStash", "CatCafe_"..data.stash) end)

RegisterNetEvent('hpx-CatCafe:Shop', function() if not jobCheck() then return else TriggerServerEvent("inventory:server:OpenInventory", "shop", "catcafe", Config.Items) end end)

RegisterNetEvent('hpx-CatCafe:FoodProgress', function(data)
	QBCore.Functions.Progressbar('making_food', data.bartext..QBCore.Shared.Items[data.item].label, data.time, false, false, {
		disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
		{ animDict = data.animDict,	anim = data.anim, flags = 8, }, 
	{}, {}, function()  
		TriggerServerEvent('hpx-CatCafe:GetFood', data)
		StopAnimTask(GetPlayerPed(-1), data.animDict, data.anim, 1.0)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('QBCore:Notify', "Cancelled!", 'error')
	end)
end)

RegisterNetEvent('hpx-CatCafe:Menu:ChoppingBoard', function()
	if not jobCheck() then return end
	local ChopMenu = {}
	ChopMenu[#ChopMenu + 1] = { header = "Chopping Board", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.ChoppingBoard do
			for k, v in pairs(Crafting.ChoppingBoard[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.ChoppingBoard[i]["img"] ~= nil then setheader = Crafting.ChoppingBoard[i]["img"]..setheader end
					for l, b in pairs(Crafting.ChoppingBoard[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
					end
					ChopMenu[#ChopMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
												params = { event = "hpx-CatCafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.ChoppingBoard,
														   bartext = "Preparing a ", time = 7000, animDict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_b_idle" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(ChopMenu)
end)

RegisterNetEvent('hpx-CatCafe:Menu:Oven', function()
	if not jobCheck() then return end
	local OvenMenu = {}
	OvenMenu[#OvenMenu + 1] = { header = "Oven Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Oven do
			for k, v in pairs(Crafting.Oven[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.Oven[i]["img"] ~= nil then setheader = Crafting.Oven[i]["img"]..setheader end
					for l, b in pairs(Crafting.Oven[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					OvenMenu[#OvenMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
												params = { event = "hpx-CatCafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Oven,
														   bartext = "Preparing a ", time = 5000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(OvenMenu)
end)

RegisterNetEvent('hpx-CatCafe:Menu:Coffee', function()
	if not jobCheck() then return end
	local CoffeeMenu = {}
	CoffeeMenu[#CoffeeMenu + 1] = { header = "Coffee Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Coffee do
			for k, v in pairs(Crafting.Coffee[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.Coffee[i]["img"] ~= nil then setheader = Crafting.Coffee[i]["img"]..setheader end
					for l, b in pairs(Crafting.Coffee[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					CoffeeMenu[#CoffeeMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
													params = { event = "hpx-CatCafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Coffee,
															   bartext = "Pouring a ", time = 3000, animDict = "mp_ped_interaction", anim = "handshake_guy_a" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(CoffeeMenu)
end)

RegisterNetEvent('hpx-CatCafe:Menu:Hob', function()
	if not jobCheck() then return end
	local HobMenu = {}
	HobMenu[#HobMenu + 1] = { header = "Hob Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Hob do
			for k, v in pairs(Crafting.Hob[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = QBCore.Shared.Items[k].label
					if Crafting.Hob[i]["img"] ~= nil then setheader = Crafting.Hob[i]["img"]..setheader end
					for l, b in pairs(Crafting.Hob[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					HobMenu[#HobMenu + 1] = { header = "<img src=nui://"..Config.link..QBCore.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
											  params = { event = "hpx-CatCafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Hob,
														 bartext = "Preparing a ", time = 7000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['qb-menu']:openMenu(HobMenu)
end)


RegisterNetEvent('hpx-CatCafe:client:DrinkAlcohol', function(itemName)
	TriggerEvent('animations:client:EmoteCommandStart', {"flute"})
    QBCore.Functions.Progressbar("snort_coke", "Drinking "..QBCore.Shared.Items[itemName].label.."..", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
        TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
		if QBCore.Shared.Items[itemName].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst) end
		if QBCore.Shared.Items[itemName].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger) end
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
			AlienEffect()
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end)

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    local ped = PlayerPedId()
    RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
    while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do Citizen.Wait(0) end
    SetPedCanRagdoll( ped, true )
    ShakeGameplayCam('DRUNK_SHAKE', 2.80)
    SetTimecycleModifier("Drunk")
    SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", true)
    SetPedMotionBlur(ped, true)
    SetPedIsDrunk(ped, true)
    Wait(1500)
    SetPedToRagdoll(ped, 5000, 1000, 1, false, false, false )
    Wait(13500)
    SetPedToRagdoll(ped, 5000, 1000, 1, false, false, false )
    Wait(120500)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetPedMotionBlur(ped, false)
    AnimpostfxStopAll()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(45000, 60000))    
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end

RegisterNetEvent('hpx-CatCafe:client:Drink', function(itemName)
	TriggerEvent('animations:client:EmoteCommandStart', {"coffee"})
	QBCore.Functions.Progressbar("drink_something", "Drinking "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
		if QBCore.Shared.Items[itemName].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst) end
		if QBCore.Shared.Items[itemName].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger) end
	end)
end)

RegisterNetEvent('hpx-CatCafe:client:Eat', function(itemName)
	TriggerEvent('animations:client:EmoteCommandStart', {"burger"})
    QBCore.Functions.Progressbar("eat_something", "Eating "..QBCore.Shared.Items[itemName].label.."..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		if QBCore.Shared.Items[itemName].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst) end
		if QBCore.Shared.Items[itemName].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger) end
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

AddEventHandler('onResourceStop', function(resource) 
	if resource == GetCurrentResourceName() then
		exports['qb-target']:RemoveZone("CatTable") 
		exports['qb-target']:RemoveZone("CatTable2") 
		exports['qb-target']:RemoveZone("CatTable3") 
		exports['qb-target']:RemoveZone("CatTable4") 
		exports['qb-target']:RemoveZone("CatBoard") 
		exports['qb-target']:RemoveZone("CatCoffee") 
		exports['qb-target']:RemoveZone("CatReceipt2") 
		exports['qb-target']:RemoveZone("CatReceipt1") 
		exports['qb-target']:RemoveZone("CatCounter2") 
		exports['qb-target']:RemoveZone("CatCounter") 
		exports['qb-target']:RemoveZone("CatHob") 
		exports['qb-target']:RemoveZone("CatOven") 
		exports['qb-target']:RemoveZone("CatClockin")
		exports['qb-target']:RemoveZone("CatWash3")
		exports['qb-target']:RemoveZone("CatWash2")
		exports['qb-target']:RemoveZone("CatWash1")
		exports['qb-target']:RemoveZone("CatStorage3")
		exports['qb-target']:RemoveZone("CatStorage2")
		exports['qb-target']:RemoveZone("CatStorage")
		exports['qb-target']:RemoveZone("CatFridge2")
		exports['qb-target']:RemoveZone("CatFridge")
		exports['qb-target']:RemoveZone("CatPrepared")
	end
end)