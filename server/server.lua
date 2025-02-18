local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	local food = { "bento", "blueberry", "donut", "miso", "strawberry", "rice", "noodlebowl", "ramen" }
    for k,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat6', source, item.name) end) end
	
	local food2 = { "bmochi", "pmochi", "gmochi", "omochi" }
    for k,v in pairs(food2) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat2', source, item.name) end) end

	local food3 = { "purrito" }
    for k,v in pairs(food3) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat3', source, item.name) end) end

	local food4 = { "nekocookie", "pizza", "pancake", "cakepop" }
    for k,v in pairs(food4) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat4', source, item.name) end) end

	local food5 = { "cake" }
    for k,v in pairs(food5) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat5', source, item.name) end) end

	local food6 = { "riceball" }
    for k,v in pairs(food6) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Eat6', source, item.name) end) end
	
	local drinks = { "bobatea", "bbobatea", "gbobatea", "pbobatea", "obobatea", "mocha" }
    for k,v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:Drink', source, item.name) end) end

	local drinkss = { "nekolatte" }
    for k,v in pairs(drinkss) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:DrinkNeko', source, item.name) end) end
	
	local alcohol = { "sake" }
    for k,v in pairs(alcohol) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-catcafe:client:DrinkAlcohol', source, item.name) end) end
end)

RegisterServerEvent('hpx-catcafe:GetFood', function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)

	amount = 1
	if data.craftable ~= nil then
		for k, v in pairs(data.craftable[tonumber(data.tablenumber)][tostring(data.item)]) do
			if Config.Debug then print("GetFood Table Result: craftable["..data.tablenumber.."]['"..data.item.."']['"..k.."']['"..v.."']") end	
		
			if v == 0 or v == nil then else
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(k)], "remove", v) 
				Player.Functions.RemoveItem(tostring(k), v)
			end
		end
		if data.craftable[tonumber(data.tablenumber)]["amount"] ~= nil then amount = data.craftable[tonumber(data.tablenumber)]["amount"] else amount = 1 end
	end

	Player.Functions.AddItem(data.item, amount, false, {["quality"] = nil})
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add", amount)
	
	if Config.Debug then print("Giving ["..src.."]: x"..amount.." "..data.item) end		
end)


QBCore.Functions.CreateCallback('hpx-catcafe:get', function(source, cb, item, tablenumber, craftable)
	local src = source
	local hasitem = nil
	local hasanyitem = nil
		for k, v in pairs(craftable[tonumber(tablenumber)][tostring(item)]) do
			if QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k) and QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k).amount >= v then 
				hasitem = true
				number = tostring(QBCore.Functions.GetPlayer(src).Functions.GetItemByName(k).amount)
			else
				hasitem = false 
				hasanyitem = false
				number = "0"
			end
			if Config.Debug then print("craftable["..tablenumber.."]['"..item.."']['"..k.."']['"..v.."'] = "..tostring(hasitem).." ("..tostring(number)..")") 
			hasitem = nil
			end		
		end
	if hasanyitem == false then cb(false)
	elseif hasanyitem == nil then cb(true) end
end)