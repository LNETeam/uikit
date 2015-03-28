--Developed by LNETeam
--Please respect Open Source and due credit
--Object implemention credited to LYQYD

--Enumerations for dialog options
new = {}
col = nil

function write(stuff)
	local h = fs.open("temp",'w')
	h.write(stuff)
	h.close()
	error()
end

function inTable(tbl, item)
	for key, value in pairs(tbl) do
		if value == item then return key end
	end
	return false
end

function checkOverlapDependency(map)
local masterOccupiedZones = {}
for k,v in pairs(map.points) do
	masterOccupiedZones[""..k..""] = {}
	for startY = v.sY,v.eY do
		for startX = v.sX,v.eX do
			table.insert(masterOccupiedZones[""..k..""],startX..","..startY)
		end
	end
end
local errList = {}
for k,v in pairs(masterOccupiedZones) do
	for i,p in pairs(v) do
		local spot = p
		for l,m in pairs(masterOccupiedZones) do
			if m ~= v then
				for a,b in pairs(m) do
					if b == spot then
						if not inTable(errList,spot) then
							table.insert(errList,spot)
							break
						end
					end
				end
			end
		end
	end
end
local tMap = new.hotmap()
for k,v in pairs(errList) do
	t = {v:match("([^,]+),([^,]+)")}
	local a = new.hotpoint(t[1],t[2],nil,true,t[1],t[2],false)
	tMap:AddPoint(a)
end
if #tMap.points>0 then return false,tMap end
--if #tMap.points>0 then error(false,tMap) end
return true,{}
end



local hotmap = 
{
	CalcAction = function(self,x,y)
		for k,v in pairs(self.points) do
			if v.iRange then
				if (x >= v.sX and x <= v.eX) and (y >= v.sY and y <= v.eY ) then
					if v.enabled then
						v.func()
					end
				end
			else
				if (v.sX == x and v.sY == y) then
					if v.enabled then
						v.func()
					end
					break
				end
			end
		end
	end,
	AddPoint = function(self,point)
		table.insert(self.points,point)
	end,
}


function new.hotmap()
	local temp = 
	{
		points = {},
		overlapMap = {},
	}
	setmetatable(temp, {__index = hotmap})
	return temp
end

function new.hotpoint(startX,startY,action,isRanged,endX,endY,b)
if b == nil then b= true end
local temp = 
{
	sX = startX,
	sY = startY,
	iRange = isRanged or false,
	eX = endX or nil,
	eY = endY or nil,
	func = action,
	boundOkay = b,
	enabled = true,
}
return temp
end

function sketchZones(map,dNums,single)
	local cols = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384}

	term.setBackgroundColor(colors.black)
	--term.clear()
	local prev = 0
	local okay = true
	for k,v in pairs(map.points) do
		local num = math.random(1,15)
		okay = v.boundOkay
		while num == prev do
			num = math.random(1,15)
		end
		prev = num
		if single and not col then
			col = cols[num]
		end
		if not single and col ~= nil then
			col = nil
		end
		term.setBackgroundColor(col or cols[num])
		if (not v.iRange) then
			term.setCursorPos(v.sX,v.sY)
			if okay then term.write(" ")
			else
				term.write("X")
			end
		else
			for z=v.sY,v.eY do
				term.setCursorPos(v.sX,z)
				for i=v.sX,v.eX do
					term.setCursorPos(i,z)
					if not dNums then
						if okay then term.write(" ")
						else
							term.write("X")
						end
					else
						term.write(k)
					end
				end
			end
		end
	end
end 
