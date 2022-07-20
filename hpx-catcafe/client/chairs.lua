local QBCore = exports['qb-core']:GetCoreObject()

local catseat = 0
local sitting = false

Citizen.CreateThread(function()
	for k, v in pairs(Config.Chairs) do
		exports['qb-target']:AddBoxZone("CatChair"..k, v.location, v.width, v.height, { name="CatChair"..k, heading = v.heading, debugPoly=Config.Debug, minZ = v.minZ, maxZ = v.maxZ, }, 
			{ options = { { event = "hpx-CatCafe:Chair", icon = "fas fa-chair", label = "Sit Down", loc = v.location, head = v.heading, seat = v.seat }, },
			  distance = v.distance
		})
	end
end)

RegisterNetEvent('hpx-CatCafe:Chair', function(data)
	local canSit = true
	local sitting = false
	for k, v in pairs(QBCore.Functions.GetPlayersFromCoords(data.loc, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc)
		if dist <= 0.4 then TriggerEvent("QBCore:Notify", "Someone is already sitting there..") canSit = false end
	end
	if canSit then
		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z-0.5, data.head, 0, 1, true)
		catseat = data.seat
		sitting = true
	end
	while sitting do
		local ped = PlayerPedId()
		if sitting then 
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)

				if catseat == 1 then SetEntityCoords(ped, vector3(-575.37, -1059.79, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				if catseat == 2 then SetEntityCoords(ped, vector3(-575.34, -1063.39, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				if catseat == 3 then SetEntityCoords(ped, vector3(-575.49, -1067.04, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				
				if catseat == 4 then SetEntityCoords(ped, vector3(-585.72, -1064.75, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 5 then SetEntityCoords(ped, vector3(-585.75, -1065.69, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 6 then SetEntityCoords(ped, vector3(-585.84, -1066.7, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 7 then SetEntityCoords(ped, vector3(-585.79, -1067.64, 22.34)) SetEntityHeading(ped, 270.0) end
				
				catseat = 0
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)

Config.Chairs = {
	--Downstairs--
	--Booth1
	{ location = vector3(-573.04, -1058.81, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.92, -1058.82, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.06, -1060.7, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.91, -1060.72, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	--Booth2
	{ location = vector3(-572.98, -1062.46, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.84, -1062.45, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.05, -1064.37, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.89, -1064.37, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	--Booth3
	{ location = vector3(-573.0, -1066.11, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.9, -1066.1, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.07, -1068.03, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.87, -1068.01, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	--Fireside
	{ location = vector3(-580.84, -1051.22, 22.35), heading = 277.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-579.78, -1052.51, 22.35), heading = 329.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-577.61, -1052.6, 22.35), heading = 35.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-576.86, -1051.03, 22.35), heading = 108.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	--Center
	{ location = vector3(-579.72, -1062.12, 22.35), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-580.7, -1062.55, 22.35), heading = 45.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-581.02, -1063.46, 22.35), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-580.64, -1064.45, 22.35), heading = 135.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-579.71, -1064.79, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.67, -1064.47, 22.35), heading = 225.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.33, -1063.39, 22.35), heading = 270.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.76, -1062.34, 22.35), heading = 315.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	--Stools
	{ location = vector3(-586.18, -1064.68, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 4 },
	{ location = vector3(-586.17, -1065.69, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 5 },
	{ location = vector3(-586.15, -1066.68, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 6 },
	{ location = vector3(-586.17, -1067.69, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 7 },
	--Boss sofa
	{ location = vector3(-591.21, -1049.06, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-589.95, -1049.06, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	--Boss Room1
	{ location = vector3(-598.44, -1050.99, 22.35), heading = 270.0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-598.45, -1050.1, 22.35), heading = 270.0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-596.26, -1053.52, 22.35), heading = 0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	--Upstairs
	--Sofa1
	{ location = vector3(-573.72, -1052.29, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-573.73, -1053.45, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Corner Sofa
	{ location = vector3(-569.68, -1066.56, 26.62), heading = 90.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-569.7, -1068.13, 26.62), heading = 90.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-570.97, -1069.42, 26.62), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-572.61, -1069.4, 26.62), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Boss Room 2
	{ location = vector3(-577.09, -1065.14, 26.61), heading = 165.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.82, -1065.24, 26.61), heading = 200.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.24, -1067.83, 26.61), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Boss Room 3
	{ location = vector3(-577.0, -1062.6, 26.61), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-579.1, -1061.28, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-577.39, -1057.87, 26.61), heading = 180.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.59, -1057.9, 26.61), heading = 180.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
}

AddEventHandler('onResourceStop', function(r) 
	if r == GetCurrentResourceName() then for k, v in pairs(Config.Chairs) do exports['qb-target']:RemoveZone("CatChair"..k) end
	end 
end)