local TXT = Localize{
	[0] = " ",
	[1] = "Chest ",
	[2] = "Barrel",
	[3] = "Well",
	[4] = "Drink from the Well",
	[5] = "Fountain",
	[6] = "Drink from the Fountain",
	[7] = "House",
	[8] = "",
	[9] = "Tent",
	[10] = "Hut",
	[11] = "Refreshing!",
	[12] = "Boat",
	[13] = "Dock",
	[14] = "Drink",
	[15] = "Button",
	[16] = "",
	[17] = "",
	[18] = "",
	[19] = "",
	[20] = "Ambush",
	[21] = "This Door is Locked",
	[22] = "",
	[23] = "",
	[24] = "",
	[25] = "Hall of the Pit",
	[26] = "Watchtower 6",
	[27] = "",
	[28] = "",
	[29] = "",
	[30] = "Enter the Hall of the Pit",
	[31] = "Enter Watchtower 6",
	[32] = "",
	[33] = "",
	[34] = "",
	[35] = "Temple",
	[36] = "Guilds",
	[37] = "Stables",
	[38] = "Docks",
	[39] = "Shops",
	[40] = "",
	[41] = "Castle Harmondy",
	[42] = "East ",
	[43] = "North ",
	[44] = "West",
	[45] = "South ",
	[46] = "Harmondale",
	[47] = "",
	[48] = "",
	[49] = "",
	[50] = "Obelisk",
	[51] = " a_eetcoa",
	[52] = "Shrine",
	[53] = "Altar",
	[54] = "You Pray",
	[55] = "",
	[56] = "",
	[57] = "",
	[58] = "",
	[59] = "",
	[60] = "",
	[61] = "",
	[62] = "",
	[63] = "",
	[64] = "",
	[65] = "",
	[66] = "",
	[67] = "",
	[68] = "",
	[69] = "",
	[70] = "+2 Intellect (Permanent)",
	[71] = "+5 Fire Resistance (Permanent)",
	[72] = "+10 Personality (Temporary)",
	[73] = "You Feel Great!!",
	[74] = "+10 Fire Resistance (Temporary)",
	[75] = "Haven't you had enough ?",
	[76] = "Do you think that's such a good idea ?",
	[77] = "+10 Mind, Earth, and Body Resistance(Permanent)",
}
table.copy(TXT, evt.str, true)

-- Deactivate all standard events
Game.MapEvtLines.Count = 0


evt.hint[1] = evt.str[100]  -- ""
evt.map[1] = function()  -- function events.LoadMap()
	evt.Set("MapVar29", 5)
	if evt.Cmp("QBits", 99) then         -- Chose the path of Light
		goto _6
	end
	if evt.Cmp("QBits", 270) then         -- Your friends are mad at you 
		if not evt.Cmp("Counter10", 720) then
			goto _6
		end
		evt.Subtract("QBits", 270)         -- Your friends are mad at you 
		evt.Set("MapVar4", 0)
		evt.SetMonGroupBit{NPCGroup = 4, Bit = const.MonsterBits.Hostile, On = false}         -- "Guards"
	else
		if evt.Cmp("MapVar4", 2) then
			goto _7
		end
	end
::_8::
	evt.SetMonGroupBit{NPCGroup = 5, Bit = const.MonsterBits.Hostile, On = true}         -- "Generic Monster Group for Dungeons"
	do return end
::_6::
	evt.Set("MapVar4", 2)
::_7::
	evt.SetMonGroupBit{NPCGroup = 4, Bit = const.MonsterBits.Hostile, On = true}         -- "Guards"
	goto _8
end

events.LoadMap = evt.map[1].last

evt.house[3] = 46  -- "The Blackened Vial"
evt.map[3] = function()
	evt.EnterHouse(46)         -- "The Blackened Vial"
end

evt.house[4] = 46  -- "The Blackened Vial"
evt.map[4] = function()
end

evt.house[5] = 57  -- "Faithful Steeds"
evt.map[5] = function()
	evt.EnterHouse(57)         -- "Faithful Steeds"
end

evt.house[6] = 57  -- "Faithful Steeds"
evt.map[6] = function()
end

evt.house[7] = 78  -- "Temple of Dark"
evt.map[7] = function()
	evt.EnterHouse(78)         -- "Temple of Dark"
end

evt.house[8] = 78  -- "Temple of Dark"
evt.map[8] = function()
end

evt.house[9] = 111  -- "The Snobbish Goblin"
evt.map[9] = function()
	evt.EnterHouse(111)         -- "The Snobbish Goblin"
end

evt.house[10] = 111  -- "The Snobbish Goblin"
evt.map[10] = function()
end

evt.house[11] = 157  -- "Master Guild of Spirit"
evt.map[11] = function()
	evt.EnterHouse(157)         -- "Master Guild of Spirit"
end

evt.house[12] = 157  -- "Master Guild of Spirit"
evt.map[12] = function()
end

evt.house[13] = 169  -- "Guild of Twilight"
evt.map[13] = function()
	evt.EnterHouse(169)         -- "Guild of Twilight"
end

evt.house[14] = 169  -- "Guild of Twilight"
evt.map[14] = function()
end

evt.house[15] = 33  -- "Death's Door"
evt.map[15] = function()
	evt.EnterHouse(33)         -- "Death's Door"
end

evt.house[16] = 33  -- "Death's Door"
evt.map[16] = function()
end

evt.hint[51] = evt.str[7]  -- "House"
evt.house[52] = 331  -- "Karrand Residence"
evt.map[52] = function()
	evt.EnterHouse(331)         -- "Karrand Residence"
end

evt.house[53] = 332  -- "Cleareye's Home"
evt.map[53] = function()
	evt.EnterHouse(332)         -- "Cleareye's Home"
end

evt.house[54] = 333  -- "Foestryke Residence"
evt.map[54] = function()
	evt.EnterHouse(333)         -- "Foestryke Residence"
end

evt.house[55] = 334  -- "Oxhide Residence"
evt.map[55] = function()
	evt.EnterHouse(334)         -- "Oxhide Residence"
end

evt.house[56] = 335  -- "Shadowrunner's Home"
evt.map[56] = function()
	evt.EnterHouse(335)         -- "Shadowrunner's Home"
end

evt.house[57] = 336  -- "Kedrin Residence"
evt.map[57] = function()
	evt.EnterHouse(336)         -- "Kedrin Residence"
end

evt.house[58] = 337  -- "Botham's Home"
evt.map[58] = function()
	evt.EnterHouse(337)         -- "Botham's Home"
end

evt.house[59] = 338  -- "Mogren Residence"
evt.map[59] = function()
	evt.EnterHouse(338)         -- "Mogren Residence"
end

evt.house[60] = 339  -- "Draken Residence"
evt.map[60] = function()
	evt.EnterHouse(339)         -- "Draken Residence"
end

evt.house[61] = 340  -- "Harli's Place"
evt.map[61] = function()
	evt.EnterHouse(340)         -- "Harli's Place"
end

evt.house[62] = 341  -- "Nevermore Residence"
evt.map[62] = function()
	evt.EnterHouse(341)         -- "Nevermore Residence"
end

evt.house[63] = 342  -- "Wiseman Residence"
evt.map[63] = function()
	evt.EnterHouse(342)         -- "Wiseman Residence"
end

evt.house[64] = 343  -- "Nightcrawler Residence"
evt.map[64] = function()
	evt.EnterHouse(343)         -- "Nightcrawler Residence"
end

evt.house[65] = 344  -- "Felburn's House"
evt.map[65] = function()
	evt.EnterHouse(344)         -- "Felburn's House"
end

evt.house[66] = 345  -- "Undershadow's Home"
evt.map[66] = function()
	evt.EnterHouse(345)         -- "Undershadow's Home"
end

evt.house[67] = 346  -- "Slicer's House"
evt.map[67] = function()
	evt.EnterHouse(346)         -- "Slicer's House"
end

evt.house[68] = 347  -- "Falk Residence"
evt.map[68] = function()
	evt.EnterHouse(347)         -- "Falk Residence"
end

evt.house[69] = 497  -- "Putnam Residence"
evt.map[69] = function()
	evt.EnterHouse(497)         -- "Putnam Residence"
end

evt.house[70] = 498  -- "Hawker Residence"
evt.map[70] = function()
	evt.EnterHouse(498)         -- "Hawker Residence"
end

evt.house[71] = 499  -- "Avalanche's"
evt.map[71] = function()
	evt.EnterHouse(499)         -- "Avalanche's"
end

evt.hint[151] = evt.str[1]  -- "Chest "
evt.map[151] = function()
	evt.OpenChest(1)
end

evt.hint[152] = evt.str[1]  -- "Chest "
evt.map[152] = function()
	evt.OpenChest(2)
end

evt.hint[153] = evt.str[1]  -- "Chest "
evt.map[153] = function()
	evt.OpenChest(3)
end

evt.hint[154] = evt.str[1]  -- "Chest "
evt.map[154] = function()
	evt.OpenChest(4)
end

evt.hint[155] = evt.str[1]  -- "Chest "
evt.map[155] = function()
	evt.OpenChest(5)
end

evt.hint[156] = evt.str[1]  -- "Chest "
evt.map[156] = function()
	evt.OpenChest(6)
end

evt.hint[157] = evt.str[1]  -- "Chest "
evt.map[157] = function()
	evt.OpenChest(7)
end

evt.hint[158] = evt.str[1]  -- "Chest "
evt.map[158] = function()
	evt.OpenChest(8)
end

evt.hint[159] = evt.str[1]  -- "Chest "
evt.map[159] = function()
	evt.OpenChest(9)
end

evt.hint[160] = evt.str[1]  -- "Chest "
evt.map[160] = function()
	evt.OpenChest(10)
end

evt.hint[161] = evt.str[1]  -- "Chest "
evt.map[161] = function()
	evt.OpenChest(11)
end

evt.hint[162] = evt.str[1]  -- "Chest "
evt.map[162] = function()
	evt.OpenChest(12)
end

evt.hint[163] = evt.str[1]  -- "Chest "
evt.map[163] = function()
	evt.OpenChest(13)
end

evt.hint[164] = evt.str[1]  -- "Chest "
evt.map[164] = function()
	evt.OpenChest(14)
end

evt.hint[165] = evt.str[1]  -- "Chest "
evt.map[165] = function()
	evt.OpenChest(15)
end

evt.hint[166] = evt.str[1]  -- "Chest "
evt.map[166] = function()
	evt.OpenChest(16)
end

evt.hint[167] = evt.str[1]  -- "Chest "
evt.map[167] = function()
	evt.OpenChest(17)
end

evt.hint[168] = evt.str[1]  -- "Chest "
evt.map[168] = function()
	evt.OpenChest(18)
end

evt.hint[169] = evt.str[1]  -- "Chest "
evt.map[169] = function()
	evt.OpenChest(19)
	if not evt.Cmp("QBits", 68) then         -- Placed Golem right leg
		if not evt.Cmp("QBits", 223) then         -- Right leg - I lost it
			evt.Add("QBits", 223)         -- Right leg - I lost it
		end
	end
end

evt.hint[170] = evt.str[1]  -- "Chest "
evt.map[170] = function()
	evt.OpenChest(0)
	if not evt.Cmp("QBits", 67) then         -- Placed Golem left leg
		if not evt.Cmp("QBits", 224) then         -- Left leg - I lost it
			evt.Add("QBits", 224)         -- Left leg - I lost it
		end
	end
end

evt.hint[201] = evt.str[3]  -- "Well"
evt.hint[202] = evt.str[4]  -- "Drink from the Well"
evt.map[202] = function()
	if not evt.Cmp("BankGold", 99) then
		if not evt.Cmp("Gold", 199) then
			if not evt.Cmp("MapVar19", 1) then
				evt.Add("Gold", 200)
				evt.Set("MapVar19", 1)
			end
		end
	end
	evt.StatusText(11)         -- "Refreshing!"
end

RefillTimer(function()
	evt.Set("MapVar19", 0)
end, const.Week, true)

evt.hint[203] = evt.str[4]  -- "Drink from the Well"
evt.map[203] = function()
	if evt.Cmp("PlayerBits", 9) then
		evt.StatusText(11)         -- "Refreshing!"
		return
	end
	if not evt.Cmp("AutonotesBits", 14) then         -- "2 points of permanent Intellect from the southern village well in Deyja."
		evt.Add("AutonotesBits", 14)         -- "2 points of permanent Intellect from the southern village well in Deyja."
	end
	evt.Add("BaseIntellect", 2)
	evt.Add("PlayerBits", 9)
	evt.StatusText(70)         -- "+2 Intellect (Permanent)"
end

evt.hint[204] = evt.str[4]  -- "Drink from the Well"
evt.map[204] = function()
	if evt.Cmp("PlayerBits", 11) then
		evt.StatusText(11)         -- "Refreshing!"
		return
	end
	if not evt.Cmp("AutonotesBits", 16) then         -- "10 points of temporary Personality from the well near the Temple of the Dark in Moulder in Deyja."
		evt.Add("AutonotesBits", 16)         -- "10 points of temporary Personality from the well near the Temple of the Dark in Moulder in Deyja."
	end
	evt.Add("PersonalityBonus", 10)
	evt.Add("PlayerBits", 11)
	evt.StatusText(72)         -- "+10 Personality (Temporary)"
end

Timer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 11)
end, const.Day, 1*const.Hour)

evt.hint[205] = evt.str[4]  -- "Drink from the Well"
evt.map[205] = function()
	if evt.Cmp("PlayerBits", 12) then
		evt.StatusText(11)         -- "Refreshing!"
		return
	end
	if not evt.Cmp("AutonotesBits", 17) then         -- "10 points of temporary Fire resistance from the well in the south side of Moulder in Deyja."
		evt.Add("AutonotesBits", 17)         -- "10 points of temporary Fire resistance from the well in the south side of Moulder in Deyja."
	end
	evt.Add("FireResBonus", 10)
	evt.Add("PlayerBits", 12)
	evt.StatusText(74)         -- "+10 Fire Resistance (Temporary)"
end

Timer(function()
	evt.ForPlayer("All")
	evt.Subtract("PlayerBits", 12)
end, const.Day, 1*const.Hour)

evt.hint[206] = evt.str[4]  -- "Drink from the Well"
evt.map[206] = function()
	local i
	if not evt.Cmp("Drunk", 0) then
		evt.Set("Drunk", 0)
		evt.StatusText(73)         -- "You Feel Great!!"
	else
		i = Game.Rand() % 2
		if i == 1 then
			evt.StatusText(75)         -- "Haven't you had enough ?"
		else
			evt.StatusText(76)         -- "Do you think that's such a good idea ?"
		end
	end
end

evt.hint[207] = evt.str[4]  -- "Drink from the Well"
evt.map[207] = function()
	if evt.Cmp("FireResistance", 5) then
		goto _8
	end
	if evt.Cmp("PlayerBits", 10) then
		goto _8
	end
	if not evt.Cmp("AutonotesBits", 15) then         -- "5 points of permanent Fire resistance from the well in the western village in Deyja."
		evt.Add("AutonotesBits", 15)         -- "5 points of permanent Fire resistance from the well in the western village in Deyja."
	end
	evt.Add("FireResistance", 5)
	evt.Add("PlayerBits", 10)
	evt.StatusText(71)         -- "+5 Fire Resistance (Permanent)"
	do return end
::_8::
	evt.StatusText(11)         -- "Refreshing!"
end

evt.hint[451] = evt.str[52]  -- "Shrine"
evt.hint[452] = evt.str[53]  -- "Altar"
evt.map[452] = function()
	if evt.Cmp("PlayerBits", 26) then
		evt.StatusText(54)         -- "You Pray"
	else
		evt.Add("MindResistance", 10)
		evt.Add("EarthResistance", 10)
		evt.Add("BodyResistance", 10)
		evt.Add("PlayerBits", 26)
		evt.StatusText(77)         -- "+10 Mind, Earth, and Body Resistance(Permanent)"
	end
end

evt.hint[453] = evt.str[50]  -- "Obelisk"
evt.map[453] = function()
	if not evt.Cmp("QBits", 167) then         -- Visited Obelisk in Area 5
		evt.StatusText(51)         -- " a_eetcoa"
		evt.Add("AutonotesBits", 117)         -- "Obelisk message #4: a_eetcoa"
		evt.ForPlayer("All")
		evt.Add("QBits", 167)         -- Visited Obelisk in Area 5
	end
end

evt.hint[454] = evt.str[100]  -- ""
evt.map[454] = function()
	local i
	if not evt.Cmp("QBits", 249) then         -- Don't get ambushed
		i = Game.Rand() % 2
		if i == 1 then
			evt.Set("MapVar29", 5)
		else
			evt.SpeakNPC(122)         -- "Lunius Shador"
			evt.Set("MapVar29", 0)
		end
	end
end

evt.hint[455] = evt.str[100]  -- ""
evt.map[455] = function()
	if not evt.Cmp("MapVar29", 5) then
		if evt.Cmp("QBits", 249) then         -- Don't get ambushed
			evt.Set("MapVar29", 5)
		else
			evt.Add("QBits", 249)         -- Don't get ambushed
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 10, X = -2760, Y = -15344, Z = 2464, NPCGroup = 15, unk = 0}         -- "Group walkers in the Tularean forest"
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 10, X = -4560, Y = -16632, Z = 2464, NPCGroup = 15, unk = 0}         -- "Group walkers in the Tularean forest"
			evt.SetMonGroupBit{NPCGroup = 15, Bit = const.MonsterBits.Hostile, On = true}         -- "Group walkers in the Tularean forest"
			evt.Set("MapVar29", 5)
		end
	end
	evt.SetNPCTopic{NPC = 122, Index = 0, Event = 513}         -- "Lunius Shador" : "Pay 1000 Gold"
	evt.SetNPCTopic{NPC = 122, Index = 1, Event = 514}         -- "Lunius Shador" : "Don't Pay"
end

evt.hint[456] = evt.str[100]  -- ""
evt.map[456] = function()
	if not evt.Cmp("MapVar29", 5) then
		if evt.Cmp("QBits", 249) then         -- Don't get ambushed
			evt.Set("MapVar29", 5)
		else
			evt.Add("QBits", 249)         -- Don't get ambushed
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 10, X = 19336, Y = -13040, Z = 2464, NPCGroup = 15, unk = 0}         -- "Group walkers in the Tularean forest"
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 10, X = 17150, Y = -13555, Z = 2464, NPCGroup = 15, unk = 0}         -- "Group walkers in the Tularean forest"
			evt.SetMonGroupBit{NPCGroup = 15, Bit = const.MonsterBits.Hostile, On = true}         -- "Group walkers in the Tularean forest"
			evt.Set("MapVar29", 5)
		end
	end
	evt.SetNPCTopic{NPC = 122, Index = 0, Event = 513}         -- "Lunius Shador" : "Pay 1000 Gold"
	evt.SetNPCTopic{NPC = 122, Index = 1, Event = 514}         -- "Lunius Shador" : "Don't Pay"
end

evt.hint[500] = evt.str[100]  -- ""
evt.map[500] = function()
	if not evt.CheckSeason(3) then
		if not evt.CheckSeason(2) then
			if not evt.CheckSeason(1) then
				evt.CheckSeason(0)
			end
		end
	end
end

evt.hint[501] = evt.str[30]  -- "Enter the Hall of the Pit"
evt.map[501] = function()
	evt.MoveToMap{X = 512, Y = -3156, Z = 1, Direction = 545, LookAngle = 0, SpeedZ = 0, HouseId = 199, Icon = 2, Name = "T04.blv"}         -- "Hall of the Pit"
end

evt.hint[502] = evt.str[31]  -- "Enter Watchtower 6"
evt.map[502] = function()
	evt.MoveToMap{X = -416, Y = -1033, Z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 200, Icon = 9, Name = "D15.blv"}         -- "Watchtower 6"
end

evt.map[503] = function()
	if evt.Cmp("QBits", 99) then         -- Chose the path of Light
		evt.MoveToMap{X = 442, Y = -1112, Z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 9, Name = "MDT10.blv"}
	else
		evt.SpeakNPC(18)         -- "William Setag"
	end
end

evt.hint[504] = evt.str[31]  -- "Enter Watchtower 6"
evt.map[504] = function()
	if not evt.Cmp("QBits", 196) then         -- Find second entrance to Watchtower6
		evt.Add("QBits", 196)         -- Find second entrance to Watchtower6
	end
	evt.MoveToMap{X = 190, Y = 4946, Z = -511, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 200, Icon = 9, Name = "d15.blv"}         -- "Watchtower 6"
end

