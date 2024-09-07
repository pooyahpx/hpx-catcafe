print("hpx-CatCafe - CatCafe Script by POYAHPX")

Config = {}
Config.Debug = false -- false to remove green boxes

Config.SQL = 'oxmysql' 

Config.link = "qb-inventory/html/images/" --Set this to the image directory of your inventory script

Config.PatHeal = 2 			--how much you are healed by patting a cat, 2 hp seems resonable, enough not to be over powered and enough to draw people in.
							--set to 0 if you don't want to use this
Config.Items = {
    label = "Recipes",
    slots = 14,
    items = {
        [1] = { name = "sugar", price = 0, amount = 50, info = {}, type = "item", slot = 1, },
        [2] = { name = "flour", price = 0, amount = 50, info = {}, type = "item", slot = 2, },
        [3] = { name = "nori", price = 0, amount = 50, info = {}, type = "item", slot = 3, },
        [4] = { name = "tofu", price = 0, amount = 50, info = {}, type = "item", slot = 4, },
        [5] = { name = "onion", price = 0, amount = 50, info = {}, type = "item", slot = 5, },
        [6] = { name = "boba", price = 0, amount = 50, info = {}, type = "item", slot = 6, },
        [7] = { name = "mint", price = 0, amount = 50, info = {}, type = "item", slot = 7, },
        [8] = { name = "orange", price = 0, amount = 50, info = {}, type = "item", slot = 8, },
        [9] = { name = "strawberry", price = 0, amount = 50, info = {}, type = "item", slot = 9, },
        [10] = { name = "blueberry", price = 0, amount = 50, info = {}, type = "item", slot = 10, },
        [11] = { name = "milk", price = 0, amount = 50, info = {}, type = "item", slot = 11, },
        [12] = { name = "rice", price = 0, amount = 50, info = {}, type = "item", slot = 12, },
        [13] = { name = "sake", price = 0, amount = 50, info = {}, type = "item", slot = 13, },
        [14] = { name = "noodles", price = 0, amount = 50, info = {}, type = "item", slot = 14, },
    },
}

Config.Locations = {
    [1] = {
		zoneEnable = true,
        label = "Cat Cafe", -- Set this to the required job
        zones = {
		  vector2(-591.15808105469, -1087.8620605469),
		  vector2(-563.33447265625, -1087.8508300781),
		  vector2(-563.26678466797, -1045.1898193359),
		  vector2(-618.20904541016, -1044.2902832031),
		  vector2(-617.80517578125, -1079.7291259766),
		  vector2(-599.44097900391, -1079.6105957031)
        },
		blip = vector3(-581.06, -1066.22, 22.34),
		blipcolor = 48,
    },
}

Crafting = {}

Crafting.ChoppingBoard = {
	[1] = { ['bmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['blueberry'] = 1, }, },
	[2] = { ['gmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['mint'] = 1, }, },
	[3] = { ['omochi'] = { ['sugar'] = 1, ['flour'] = 1, ['orange'] = 1, }, },
	[4] = { ['pmochi'] = { ['sugar'] = 1, ['flour'] = 1, ['strawberry'] = 1, }, },
	[5] = { ['riceball'] = { ['rice'] = 1, ['nori'] = 1, }, },
	[6] = { ['bento'] = { ['rice'] = 1, ['nori'] = 1, ['tofu'] = 1, }, },
	[7] = { ['purrito'] = { ['rice'] = 1, ['flour'] = 1, ['onion'] = 1, }, },
}

Crafting.Oven = {
	[1] = { ['nekocookie'] = { ['flour'] = 1, ['milk'] = 1, }, },
	[2] = { ['nekodonut'] = { ['flour'] = 1, ['milk'] = 1, }, },
	[3] = { ['cake'] = { ['flour'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },	
	[4] = { ['cakepop'] = { ['flour'] = 1, ['milk'] = 1, ['sugar'] = 1, }, },
	[5] = { ['pancake'] = { ['flour'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[6] = { ['pizza'] = { ['flour'] = 1, ['milk'] = 1, }, },
}

Crafting.Coffee = {
	[1] = { ['coffee'] = { ["coffee"] = 0 }, },
	[2] = { ['nekolatte'] = { ["coffee"] = 0 },  },
	[3] = { ['bobatea'] = { ['boba'] = 1, ['milk'] = 1, }, },
	[4] = { ['bbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['sugar'] = 1, }, },
	[5] = { ['gbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[6] = { ['obobatea'] = { ['boba'] = 1, ['milk'] = 1, ['orange'] = 1, }, },
	[7] = { ['pbobatea'] = { ['boba'] = 1, ['milk'] = 1, ['strawberry'] = 1, }, },
	[8] = { ['mocha'] = { ['milk'] = 1, ['sugar'] = 1, }, },
}

Crafting.Hob = {
	[1] = { ['miso'] = { ['nori'] = 1, ['tofu'] = 1, ['onion'] = 1, }, },
	[2] = { ['ramen'] = { ['noodles'] = 1, ['onion'] = 1, }, },
	[3] = { ['noodlebowl'] = { ['noodles'] = 1, }, },
}
