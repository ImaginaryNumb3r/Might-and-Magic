local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Leave the Cave",
	[3] = "Chest",
	[4] = "Button",
	[5] = "Lever",
	[6] = "Vault",
	[7] = "Cabinet",
	[8] = "Switch",
	[9] = "",
	[10] = "Bookcase",
	[11] = "",
	[12] = "Ore Vein",
	[13] = "Cave In !",
	[14] = "You Successfully disarm the trap",
	[15] = "",
	[16] = "Take a Drink",
	[17] = "Not Very Refreshing",
	[18] = "Refreshing",
}
table.copy(TXT, evt.str, true)

-- Deactivate all standard events
Game.MapEvtLines.Count = 0


evt.hint[3] = evt.str[1]  -- "Door"
evt.map[3] = function()
	evt.SetDoorState{Id = 1, State = 0}
end

evt.hint[176] = evt.str[3]  -- "Chest"
evt.map[176] = function()
	evt.OpenChest(1)
end

evt.hint[177] = evt.str[3]  -- "Chest"
evt.map[177] = function()
	evt.OpenChest(2)
end

evt.hint[178] = evt.str[3]  -- "Chest"
evt.map[178] = function()
	evt.OpenChest(3)
end

evt.hint[179] = evt.str[3]  -- "Chest"
evt.map[179] = function()
	evt.OpenChest(4)
end

evt.hint[180] = evt.str[3]  -- "Chest"
evt.map[180] = function()
	evt.OpenChest(5)
end

evt.hint[181] = evt.str[3]  -- "Chest"
evt.map[181] = function()
	evt.OpenChest(6)
end

evt.hint[182] = evt.str[3]  -- "Chest"
evt.map[182] = function()
	evt.OpenChest(7)
end

evt.hint[183] = evt.str[3]  -- "Chest"
evt.map[183] = function()
	evt.OpenChest(8)
end

evt.hint[184] = evt.str[3]  -- "Chest"
evt.map[184] = function()
	evt.OpenChest(9)
end

evt.hint[185] = evt.str[3]  -- "Chest"
evt.map[185] = function()
	evt.OpenChest(10)
end

evt.hint[186] = evt.str[3]  -- "Chest"
evt.map[186] = function()
	evt.OpenChest(11)
end

evt.hint[187] = evt.str[3]  -- "Chest"
evt.map[187] = function()
	evt.OpenChest(12)
end

evt.hint[188] = evt.str[3]  -- "Chest"
evt.map[188] = function()
	evt.OpenChest(13)
end

evt.hint[189] = evt.str[3]  -- "Chest"
evt.map[189] = function()
	evt.OpenChest(14)
end

evt.hint[190] = evt.str[3]  -- "Chest"
evt.map[190] = function()
	evt.OpenChest(15)
end

evt.hint[191] = evt.str[3]  -- "Chest"
evt.map[191] = function()
	evt.OpenChest(16)
end

evt.hint[192] = evt.str[3]  -- "Chest"
evt.map[192] = function()
	evt.OpenChest(17)
end

evt.hint[193] = evt.str[3]  -- "Chest"
evt.map[193] = function()
	evt.OpenChest(18)
end

evt.hint[194] = evt.str[3]  -- "Chest"
evt.map[194] = function()
	evt.OpenChest(19)
end

evt.hint[195] = evt.str[3]  -- "Chest"
evt.map[195] = function()
	evt.OpenChest(0)
end

evt.hint[196] = evt.str[12]  -- "Ore Vein"
evt.map[196] = function()
	local i
	if evt.Cmp("MapVar14", 1) then
		return
	end
	i = Game.Rand() % 6
	if i == 3 then
		evt.Add("Inventory", 689)         -- "Kergar-laced ore"
		goto _9
	elseif i == 4 then
		evt.DamagePlayer{Player = "All", DamageType = const.Damage.Fire, Damage = 50}
		evt.StatusText(13)         -- "Cave In !"
		goto _8
	elseif i == 5 then
		goto _8
	end
	evt.Add("Inventory", 688)         -- "Phylt-laced ore"
::_9::
	evt.Set("MapVar14", 1)
	evt.SetTexture{Facet = 2, Name = "cwb1"}
	do return end
::_8::
	evt.Add("Inventory", 690)         -- "Erudine-laced ore"
	goto _9
end

function events.LoadMap()
	if evt.Cmp("MapVar14", 1) then
		evt.SetTexture{Facet = 2, Name = "cwb1"}
	end
end

evt.hint[197] = evt.str[12]  -- "Ore Vein"
evt.map[197] = function()
	local i
	if evt.Cmp("MapVar15", 1) then
		return
	end
	i = Game.Rand() % 6
	if i == 3 then
		evt.Add("Inventory", 689)         -- "Kergar-laced ore"
		goto _9
	elseif i == 4 then
		evt.DamagePlayer{Player = "All", DamageType = const.Damage.Fire, Damage = 50}
		evt.StatusText(13)         -- "Cave In !"
		goto _8
	elseif i == 5 then
		goto _8
	end
	evt.Add("Inventory", 688)         -- "Phylt-laced ore"
::_9::
	evt.Set("MapVar15", 1)
	evt.SetTexture{Facet = 3, Name = "cwb1"}
	do return end
::_8::
	evt.Add("Inventory", 690)         -- "Erudine-laced ore"
	goto _9
end

function events.LoadMap()
	if evt.Cmp("MapVar15", 1) then
		evt.SetTexture{Facet = 3, Name = "cwb1"}
	end
end

evt.hint[198] = evt.str[12]  -- "Ore Vein"
evt.map[198] = function()
	local i
	if evt.Cmp("MapVar16", 1) then
		return
	end
	i = Game.Rand() % 6
	if i == 3 then
		evt.Add("Inventory", 689)         -- "Kergar-laced ore"
		goto _9
	elseif i == 4 then
		evt.DamagePlayer{Player = "All", DamageType = const.Damage.Fire, Damage = 50}
		evt.StatusText(13)         -- "Cave In !"
		goto _8
	elseif i == 5 then
		goto _8
	end
	evt.Add("Inventory", 688)         -- "Phylt-laced ore"
::_9::
	evt.Set("MapVar16", 1)
	evt.SetTexture{Facet = 4, Name = "cwb1"}
	do return end
::_8::
	evt.Add("Inventory", 690)         -- "Erudine-laced ore"
	goto _9
end

function events.LoadMap()
	if evt.Cmp("MapVar16", 1) then
		evt.SetTexture{Facet = 4, Name = "cwb1"}
	end
end

evt.map[451] = function()
	evt.MoveToMap{X = 1664, Y = 6336, Z = 1, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "0"}
end

evt.map[452] = function()
	evt.MoveToMap{X = 992, Y = 8544, Z = -320, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "0"}
end

evt.hint[501] = evt.str[2]  -- "Leave the Cave"
evt.map[501] = function()
	evt.MoveToMap{X = 20890, Y = -3119, Z = 1, Direction = 896, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 3, Name = "Out12.odm"}
end

evt.hint[502] = evt.str[2]  -- "Leave the Cave"
evt.map[502] = function()
	evt.MoveToMap{X = 2324, Y = 7371, Z = 1644, Direction = 1428, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 3, Name = "D07.blv"}
end

