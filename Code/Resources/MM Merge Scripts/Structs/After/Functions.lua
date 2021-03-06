local abs, floor, ceil, round, max, min = math.abs, math.floor, math.ceil, math.round, math.max, math.min
local mmver = Game.Version

local function mmv(...)
	local ret = select(mmver - 5, ...)
	assert(ret ~= nil)
	return ret
end

local _KNOWNGLOBALS_F = SimpleMessage, curry


function SplitSkill(val)
	local n = val % 0x40
	local mast
	if val >= 0x100 then
		mast = 4
	elseif val >= 0x80 then
		mast = 3
	elseif val >= 0x40 then
		mast = 2
	elseif val >= 1 then
		mast = 1
	else
		mast = 0
	end
	return n, mast
end

local ConvertMastery = {[0] = 0, [1] = 0, [2] = 0x40, [3] = 0x80, [4] = 0x100}

--!(skill, mastery:const.*)
function JoinSkill(skill, mastery)
	return skill + (ConvertMastery[mastery] or 0)
end

-- Get X,Y,Z, fields:
--   local x, y, z = XYZ(Party)
-- Set X,Y,Z, fields:
--   XYZ(Party, x, y, z)
-- Enumerate "X", "Y", "Z" strings:
--   for X in XYZ do
--     print(Party[X])
--   end
function XYZ(t, x, y, z)
	if z then
		t.X, t.Y, t.Z = x, y, z
	elseif t then
		return t.X, t.Y, t.Z
	elseif not x then  -- act as enumerator
		return "X"
	elseif x == "X" then
		return "Y"
	elseif x == "Y" then
		return "Z"
	end
end



local function LastMessage(text, forceGlobal)
	local t, i
	if evt.InGlobal() then
		t = Game.NPCText
		i = t.high
	else
		t = evt.str
		i = 499
	end
	t[i] = text
	return i
end

function Message(text)
	evt.SetMessage(LastMessage(text))
	if Game.CurrentScreen == 0 then
		evt.SimpleMessage()
	end
end
-- for backward compatibility
SimpleMessage = Message

-- Returns the reply. 'text' is shown as message, 'qtext' is shown at the beginning of reply field.
-- Doesn't work in houses in MM7.
function Question(text, qtext)
	text = (mmver == 8 and qtext and text.."\n\n"..qtext or text)
	if mmver < 8 then
		evt.SetMessage(LastMessage(text))
		evt.str[498] = qtext or ""
		evt.Question(498, 0, 0)
		if mmver == 7 then
			local r = Game.StatusMessage
			Game.ShowStatusText("", 0)
			return r
		end
	elseif Game.CurrentScreen == 0 then
		local old1, old2 = Game.Paused, Game.Paused2
		Game.CurrentScreen = const.Screens.SimpleMessage
		evt.Question(LastMessage(text), 0, 0)
		if not old1 then
			mem.call(offsets.ResumeTime, 1, offsets.TimeStruct1)
		end
		if not old2 then
			mem.call(offsets.ResumeTime, 1, offsets.TimeStruct2)
		end
	else
		evt.Question(LastMessage(text), 0, 0)
	end
	return Game.StatusMessage
end

-- searches through all NPC topics and replaces one topic with another
function ReplaceNPCTopic(old, new)
	for i,npc in Game.NPC do
		for j, ev in npc.Events do
			if ev == old then
				npc.Events[j] = new
			end
		end
	end
end

function AddGoldExp(gold, exp)
	if gold and gold ~= 0 then
		-- Rod: seems evt[] does not have field "Sub", set it to "Subtract" instead.
		--evt[0][gold > 0 and "Add" or "Sub"]("Gold", abs(gold))
		evt[0][gold > 0 and "Add" or "Subtract"]("Gold", abs(gold))
		-- Rod.
	end
	if exp and exp ~= 0 then
		evt.All.Add("Experience", exp)
	end
end

function ShowQuestEffect()
	local id = 499
	local old = Party.QBits[id]
	evt.Add("QBits", id)
	evt.Sub("QBits", id)
	Party.QBits[id] = old
end

-- 'id' can also be a table or a table of tables. See "Quest Alchemy.lua" from quest examples
function TakeItemFromParty(id, keep)
	if type(id) ~= "table" then  -- take 1 item

		for i = 0, Party.Count - 1 do
			if evt[i].Cmp("Inventory", id) then
				if not keep then
					-- Rod: seems evt[] does not have field "Sub", set it to "Subtract" instead.
					--evt[i].Sub("Inventory", id)
					evt[i].Subtract("Inventory", id)
					-- Rod.
				end
				return true
			end
		end

	elseif id.Count or id.count then  -- count all items from the list and remove in given order

		local n = id.Count or id.count
		if Party.CountItems(id) < n then
			return
		end
		if not keep then
			local i = 1
			for _ = 1, n do
				while not TakeItemFromParty(id[i]) do
					i = i + 1
				end
			end
		end
		return true

	else  -- iterate individual items or tables with items

		for _, v in ipairs(id) do
			if not TakeItemFromParty(v, true) then
				return
			end
		end
		if not keep then
			for _, v in ipairs(id) do
				TakeItemFromParty(v)
			end
		end
		return true
	end
end

local CheckType = {"Group", "Monster", "MonsterIndex", "NameId"}
local CheckDelta = {0, -1, 0, 0}

--[[!a{
  Group
  Monster
  MonsterIndex
  NameId
} See "Quest Kill Monsters.lua" from quest examples]]
function CheckMonstersKilled(t)
	for i = #CheckType, 0, -1 do
		local id = t[CheckType[i]]
		if id or i == 0 then
			local t1 = {i, id, t.Count, t.InvisibleAsDead ~= false and 1 or 0}
			if type(id) ~= "table" then
				t1[2] = id + CheckDelta[i]
				return evt.CheckMonstersKilled(t1)
			end
			local b = true
			for j = 1, #id do
				t1[2] = id[j] + CheckDelta[i]
				b = b and evt.CheckMonstersKilled(t1)
			end
			return b
		end
	end
end

-----------------------------------------------------
-- Summon*
-----------------------------------------------------

local MonTxtProps = {
	TreasureItemPercent = true,
	TreasureDiceCount = true,
	TreasureDiceSides = true,
	TreasureItemLevel = true,
	TreasureItemType = true,
	Item = true,
}

function SummonMonster(id, x, y, z, treasure, place)
	local n = Map.Monsters.Count
	mem.call(offsets.SummonMonster, 2, id, x, y, z)
	if Map.Monsters.Count == n + 1 then
		local mon = Map.Monsters[n]
		mon.Hostile = false
		if treasure then
			local a = Game.MonstersTxt[id]
			for k in pairs(MonTxtProps) do
				mon[k] = a[k]
			end
		end
		if not place then
			for i = 0, n - 1 do
				if Map.Monsters[i].AIState == 11 then  -- const.AIState.Removed
					place = i
					break
				end
			end
		end
		if place then
			local a = Map.Monsters[place]
			mem.copy(a["?ptr"], mon["?ptr"], mon["?size"])
			Map.Monsters.Count = n
			return a, place
		end
		return mon, n
	end
end

function SummonItem(number, x, y, z, speed)
	local n = Map.Objects.Count
	for i,o in Map.Objects do
		if o.Id == 0 then
			n = i
			break
		end
	end
	evt.SummonObject(Game.ItemsTxt[number].SpriteIndex, x, y, z, speed)
	local obj = (n < Map.Objects.Count and Map.Objects[n])
	if obj and obj.Id ~= 0 then
		obj.Item.Number = number
		return obj
	end
end

local function IsSpriteSquare(sx, sy, x, y)
	x, y = (x - 64 + 0.5)*512, (64 - y + 0.5)*512
	x, y = sx - x, sy - y
	return x*x + y*y <= 1024*1024
end

function RebildIDList()
	local cells = {}
	local sprites = Map.Sprites
	local max = math.max
	local min = math.min
	for i = 0, sprites.high do
		local sx, sy = sprites[i].X, sprites[i].Y
		local cx, cy = 64 + (sx / 512):floor(), 64 - (sy / 512):floor()
		for y = max(cy - 2, 0), min(cy + 2, 127) do
			for x = max(cx - 2, 0), min(cx + 2, 127) do
				if IsSpriteSquare(sx, sy, x, y) then
					local j = y*128 + x
					local t = cells[j] or {}
					cells[j] = t
					t[#t+1] = i*8 + 5
				end
			end
		end
	end
	local n = 128*128
	for i = 0, 128*128 - 1 do
		local t = cells[i]
		n = n + (t and #t or 0)
	end
	local list = mem.allocMM(n*2)
	local off = Map.IDOffsets
	n = 0
	for y = 0, 127 do
		for x = 0, 127 do
			off[y][x] = n
			local t = cells[y*128 + x]
			if t then
				for i = 1, #t do
					mem.u2[list + n*2] = t[i]
					n = n + 1
				end
			end
			mem.u2[list + n*2] = 0
			n = n + 1
		end
	end
	mem.freeMM(Map.IDList["?ptr"])
	Map.IDList["?ptr"] = list
	Map.IDList.Count = n
end

function ChangeSprite(n, name)
	Map.Sprites[n].DecName = name
	-- also need to do sound: 45E6EE (MM8)
end

--!a{name, x, y, z}
function CreateSprite(t)
	local n = Map.Sprites.Count
	if n < Map.Sprites.Limit then
		Map.Sprites.Count = n + 1
		local sp = Map.Sprites[n]
		mem.fill(sp)
		local name = t[1]
		t.X = t.X or t[2]
		t.Y = t.Y or t[3]
		t.Z = t.Z or t[4]
		t[1], t[2], t[3], t[4] = nil, nil, nil, nil
		local bits = t.Bits
		t.Bits = nil
		sp.Bits = bits or 0
		table.copy(t, sp, true)
		if name then
			ChangeSprite(n, name)
		end
		return sp, n
	end
end

-----------------------------------------------------
-- MoveModel
-----------------------------------------------------

-- local function MovePartyByModel(m, dx, dy, dz)
-- 	local px, py, pz = XYZ(Party)
-- 	if px >= m.MinX + min(dx, 0) - 1 and px <= m.MaxX + max(dx, 0) + 1 and
-- 		 py >= m.MinY + min(dy, 0) - 1 and py <= m.MaxY + max(dy, 0) + 1 and
-- 		 pz >= m.MinZ + min(dz, 0) - 1 and pz <= m.MaxZ + max(dz, 0) + 1 then
-- 	else
-- 		return
-- 	end
-- 	local fz, fid = Map.GetFloorLevel(px, py, pz)
-- 	-- print(px, py, pz, fz, fid)
-- 	-- ride check
-- 	if Map.Models[fid:div(64)] == m and fz <= pz and pz <= fz + max(dz, 0) + 1 then
-- 		local a = m.Facets[fid % 64]
-- 		local nx, ny, nz = a.NormalX, a.NormalY, a.NormalZ
-- 		print(nz, nx*dz + ny*dy + nz*dz)
-- 		if nz >= 0xB569 or nx*dz + ny*dy + nz*dz > 0 then
-- 			Party.X = px + dx
-- 			Party.Y = py + dy
-- 			Party.Z = fz + 1 + dz
-- 			return
-- 		end
-- 	end
-- 	-- Very primitive collision detection. May work only for rectangular facets.
-- 	for i, a in m.Facets do
-- 		if a.VertexesCount > 0 then
-- 			local v = m.Vertexes[a.VertexIds[0]]
-- 			local nx, ny, nz = a.NormalX, a.NormalY, a.NormalZ
-- 			local n = - (nx * v.X + ny * v.Y + nz * v.Z)  -- new normal distance
-- 			local oldn = a.NormalDistance
-- 			local px, py, pz = Party.X, Party.Y, Party.Z
-- 			local PartyDist = nx*px + ny*py + nz*pz + oldn
-- 			if PartyDist*(PartyDist - oldn + n) < 0
-- 					and px >= a.MinX + min(dx, 0) - 1 and px <= a.MaxX + max(dx, 0) + 1
-- 					and py >= a.MinY + min(dy, 0) - 1 and py <= a.MaxY + max(dy, 0) + 1
-- 					and pz >= a.MinZ + min(dz, 0) - 1 and pz <= a.MaxZ + max(dz, 0) + 1 then
-- 				-- push away
-- 				Party.X = px + dx*2
-- 				Party.Y = py + dy*2
-- 				Party.Z = pz + dz*2
-- 				return
-- 			end
-- 		end
-- 	end
-- end

local function MovePartyByModel(m, dx, dy, dz)
	local px, py, pz = XYZ(Party)
	if px >= m.MinX + min(dx, 0) - 1 and px <= m.MaxX + max(dx, 0) + 1 and
		 py >= m.MinY + min(dy, 0) - 1 and py <= m.MaxY + max(dy, 0) + 1 and
		 pz >= m.MinZ + min(dz, 0) - 1 and pz <= m.MaxZ + max(dz, 0) + 1 then
	else
		return
	end
	local fz, fid = Map.GetFloorLevel(px, py, pz)
	-- print(px, py, pz, fz, fid)
	-- ride check
	if Map.Models[fid:div(64)] == m and fz <= pz and pz <= fz + max(dz, 0) + 1 then
		local a = m.Facets[fid % 64]
		local nx, ny, nz = a.NormalX, a.NormalY, a.NormalZ
		-- print(nz, nx*dz + ny*dy + nz*dz)
		if nz >= 0xB569 or nx*dz + ny*dy + nz*dz > 0 then
			Party.X = px + dx
			Party.Y = py + dy
			Party.Z = fz + 1 + dz
			return
		end
	end
	-- Very primitive collision detection. May work only for rectangular facets.
	for i, a in m.Facets do
		if a.VertexesCount > 0 then
			local v = m.Vertexes[a.VertexIds[0]]
			local nx, ny, nz = a.NormalX, a.NormalY, a.NormalZ
			local n = - (nx * v.X + ny * v.Y + nz * v.Z)  -- new normal distance
			local oldn = a.NormalDistance
			local px, py, pz = Party.X, Party.Y, Party.Z
			local PartyDist = nx*px + ny*py + nz*pz + oldn
			if PartyDist*(PartyDist - oldn + n) < 0
					and px >= a.MinX + min(dx, 0) - 1 and px <= a.MaxX + max(dx, 0) + 1
					and py >= a.MinY + min(dy, 0) - 1 and py <= a.MaxY + max(dy, 0) + 1
					and pz >= a.MinZ + min(dz, 0) - 1 and pz <= a.MaxZ + max(dz, 0) + 1 then
				-- push away
				Party.X = px + dx*2
				Party.Y = py + dy*2
				Party.Z = pz + dz*2
				return
			end
		end
	end
end



-- local MoveModelProc = mem.dll[AppPath.."ExeMods/MMExtension/MMExtDialogs.dll"].MoveModel

local DoMoveModel = io.LoadString(AppPath.."Scripts/Structs/After/MoveModel.asm")
DoMoveModel = DoMoveModel:gsub("%%(%w*)%%", {[""] = "%", GetU = mmv(0x4790A0, 0x44C38E, 0x449AD7)})
DoMoveModel = mem.asmproc(DoMoveModel)
-- DoMoveModel = ffi.cast(

-- MoveParty isn't supported yet
function MoveModel(m, dx, dy, dz, MoveParty)
	dx = round(dx)
	dy = round(dy)
	dz = round(dz)
	if dx == 0 and dy == 0 and dz == 0 then
		return
	end
	local pm = m["?ptr"]
	if MoveParty then
		-- MovePartyByModel uses a rude approximation... and doesn't work yet :)
		MovePartyByModel(m, dx, dy, dz)
	end
	mem.call(DoMoveModel, 0, pm, dx, dy, dz, (mmver == 6 and 0 or 4))
	--MoveModelProc(pm, dx, dy, dz, (mmver == 6 and 0 or 4))
	Game.NeedRender = true
end

-----------------------------------------------------
-- partial functions application
-----------------------------------------------------

-- ^ : and
-- + : or
-- - : not
-- / : sequence
--
-- Examples:
-- L(f, "aaa") ^ -L(f2, "asdas") + L(f3, "SADD")
-- (L.vars.Quest == L("Done"))
-- L(GiveExp, 5000) / L(GiveMoney, 5000) / L(GiveItem, 5)
-- looks bad: L(nil, L(GiveExp, 5000), L(GiveMoney, 5000), L(GiveItem, 5))
-- if example (bad idea):  L(check) ^ L(true, L(GiveExp, 5000) / L(GiveMoney, 5000) / L(GiveItem, 5) ) + L(Message, "You failed")

local lmeta, AND, OR = {}, {}, {}

local function LM(par)
	return setmetatable({[lmeta] = par}, lmeta)
end
local function IsLM(t)
	return getmetatable(t) == lmeta
end
local function UnLM(t, ...)
	if IsLM(t) and t[lmeta].active then
		return t(...)
	end
	return t
end

local function Callable(t)
	local tp = type(t)
	if tp == "table" or tp == "userdata" then
		local meta = debug.getmetatable(t)
		return meta and rawget(meta, "__call")
	end
	return tp == "function"
end

local function lmake(active, blind, f, ...)
	return LM{[0] = f, n = select('#', ...), active = active, blind = blind, ...}
end

local function Combine(par, i, ...)
	if i == 0 then
		return par[0](...)
	end
	return Combine(par, i - 1, par[i], ...)
end

function lmeta:__call(...)
	local par = self[lmeta]
	local selfref = par.self
	if par[0] == AND then
		return UnLM(par[1], ...) and UnLM(par[2], ...)
	elseif par[0] == OR then
		return UnLM(par[1], ...) or UnLM(par[2], ...)
	end
	local par1 = par
	par1 = {}
	for i = 1, par.n do
		if selfref and par[i] == selfref then
			par1[i] = par.newself
		else
			par1[i] = UnLM(par[i], ...)
		end
	end
	par1[0] = par[0]
	if not Callable(par[0]) then
		return par[0]
	end
	if par.blind then
		return Combine(par1, par.n)
	else
		return Combine(par1, par.n, ...)
	end
end

local function c1(f)
	return function(a)
		return lmake(true, true, f, a)
	end
end

local function c2(f)
	return function(a, b)
		return lmake(true, true, f, a, b)
	end
end

lmeta.__pow = c2(AND)
lmeta.__add = c2(OR)

lmeta.__unm = c1(function(a)
	return not a
end)

lmeta.__div = c2(function(a, b)
	return b
end)

-- lmeta.__mod = c2(function(a, t)
-- 	if t[a] then
-- 		return a or true
-- 	end
-- end)

function lmeta:__index(k)
	local par = self[lmeta]
	return LM{active = true, blind = par.blind, [0] = function(a, b)
		if IsLM(a) and a[lmeta].self then
			a = UnLM(a)
		end
		local blind = par.newblind or par.blind
		b = a[b]
		local t = {active = true, blind = false, [0] = b, n = 0, self = self, newself = a, newblind = blind}
		if Callable(b) then
			t[0] = lmake
			t[1] = true
			t[2] = blind
			t[3] = b
			t.n = 3
		end
		return LM(t)
	end, self, k, n = 2}
end

-- local function DigIndex(t, ...)
-- 	if t.next then
-- 		return DigIndex(t.next, UnLM(t[1]), ...)
-- 	end
-- 	return t[0](UnLM(t[1]), ...)
-- end

-- local function IndexProc(t, ...)
-- 	return DigIndex(t)(...)
-- end

-- function lmeta:__index(k)
-- 	local par = self[lmeta]
-- 	local t = {[0] = self, k}
-- 	if par[0] == IndexProc then
-- 		t.next = par[1]
-- 	end
-- 	return lmake(true, false, IndexProc, t)
-- end

function lmeta.__newindex()
	error("attempt to assign a value to a curried function")
end

--[[!v(f, param1, ..., paramN)
A ^ B  :  return A(...) and B(...)
A + B  :  return A(...) or B(...)
-A  :  return not A(...)
A / B  :  A(...); return B(...)
A % {val1, val2, ...}  :  if A(...) is one of vals then  return A or true

Examples:
curry(f, a1, a2)(b1, b2)  <=>  f(a1, a2, b1, b2)
curry.blind(f, a1, a2)(b1, b2)  <=>  f(a1, a2)
curry(f).a1.a2(b1, b2)  <=>  f(a1, a2)(b1, b2)
curry[t].a1.a2(b1, b2)(c1, c2)  <=>  f.a1.a2(b1, b2, c1, c2)
curry.blind[t].a1.a2(b1, b2)(c1, c2)  <=>  f.a1.a2(b1, b2)

local _ = curry.blind[_G]

PrintPlayerName = _.Party[_.Party.CurrentPlayer].Name  -- this function will print current player's name

local P1 = curry(function(a)  return a  end)
local P2 = curry(function(_, a)  return a  end)

PrintLoves = _.print(P1, "loves", P2)
PrintLoves("Alice", "Bob")  ->  Alice	loves	Bob

local Q = curry(QCheck)
local Branch = curry(Branch)
local _ = curry.blind[_G]
local lambda = curry(function(...)  return ...  end)

CanShow = Q.Quest1.Given
CanShow = Q.Quest1.Done ^ Q.Quest2.Done  -- show if both quests are done
CanShow = Q("Quest1", "Done") ^ Q("Quest2", "Done")  -- show if both quests are done
CanShow = -Q.Quest1.Done  -- show if Quest1 is NOT done
CanShow = Q.Quest1.Done + Q.Quest2.Done  -- show if one of the quests is done
OnDone = _.evt.MoveNPC(QuestNPC, 15) / _.evt.SetNPCGroupNews(2, 15)

local  = curry(curry(curry.blind))
MoveNPC = L(evt.MoveNPC)

CanShow = -(Q.Quest1 % {"Done"})
L(GiveExp, 5000) / L(GiveMoney, 5000) / L(GiveItem, 5)
looks bad: L(nil, L(GiveExp, 5000), L(GiveMoney, 5000), L(GiveItem, 5))
if example (bad idea):  L(check) ^ L(true, L(GiveExp, 5000) / L(GiveMoney, 5000) / L(GiveItem, 5) ) + L(Message, "You failed")
]]
curry = {blind = {}}

local function fielder(make, t, k, ...)
	if k ~= nil then
		return fielder(make, t[k], ...)
	end
	if Callable(t) then
		return lmake(false, false, make, t)
	end
	return t
end

local function curry_index(self, t)
	return lmake(true, true, lmake, true, false, lmake(true, false, fielder, self, t))
end

local function MakeCurry(t, blind)
	t.static = function(...)
		return lmake(false, blind, ...)
	end
	setmetatable(t, {
		__call = function(_, ...)
			return lmake(true, blind, ...)
		end,
		__index = curry_index,
		__newindex = lmeta.__newindex,
	})
end

MakeCurry(curry, false)
MakeCurry(curry.blind, true)
