local QBCore = exports['qb-core']:GetCoreObject()

--Consumables
CreateThread(function()
	local food = { "bento", "blueberry", "cake", "nekocookie", "nekodonut", "riceball", "miso", "bmochi", "pmochi", "gmochi", "omochi", "strawberry", "rice", "cakepop", "pizza", "pancake", "purrito", "noodlebowl", "ramen" }
    for k,v in pairs(food) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-CatCafe:client:Eat', source, item.name) end) end
	
	local drinks = { "bobatea", "bbobatea", "gbobatea", "pbobatea", "obobatea", "nekolatte", "mocha" }
    for k,v in pairs(drinks) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-CatCafe:client:Drink', source, item.name) end) end
	
	local alcohol = { "sake" }
    for k,v in pairs(alcohol) do QBCore.Functions.CreateUseableItem(v, function(source, item) TriggerClientEvent('hpx-CatCafe:client:DrinkAlcohol', source, item.name) end) end
end)

RegisterServerEvent('hpx-CatCafe:GetFood', function(data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	--This grabs the table from client and removes the item requirements
	amount = 1
	if data.craftable ~= nil then
		for k, v in pairs(data.craftable[tonumber(data.tablenumber)][tostring(data.item)]) do
			if Config.Debug then print("GetFood Table Result: craftable["..data.tablenumber.."]['"..data.item.."']['"..k.."']['"..v.."']") end	
			-- if item requirement number = 0 then don't try to remove (this poorly allows crafting recipies with 0 requirements)
			if v == 0 or v == nil then else
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tostring(k)], "remove", v) 
				Player.Functions.RemoveItem(tostring(k), v)
			end
		end
		if data.craftable[tonumber(data.tablenumber)]["amount"] ~= nil then amount = data.craftable[tonumber(data.tablenumber)]["amount"] else amount = 1 end
	end
	--This should give the item, while the rest removes the requirements
	Player.Functions.AddItem(data.item, amount, false, {["quality"] = nil})
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "add", amount)
	
	if Config.Debug then print("Giving ["..src.."]: x"..amount.." "..data.item) end		
end)

---ITEM REQUIREMENT CHECKS
QBCore.Functions.CreateCallback('hpx-CatCafe:get', function(source, cb, item, tablenumber, craftable)
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