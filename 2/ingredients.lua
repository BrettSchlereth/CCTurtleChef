--up, right, forward, rotation
t = dofile("turtleMovement.lua")
--r = dofile("recipes.lua")
SERVER = 5

local i = {}

--i.setCoords = function(coordinates)
--  coords = coordinates
--  print("ing coordinates", coords[1], coords[2], coords[3], coords[4])
--end

i.List = {"raw chicken", "turtle", "raw beef", "raw porkchop", "tomato", "soybeans",
"wheat", "storage drawer", "egg", "sugar cane", "bell pepper", "olive", "fig", "cocoa beans",
"date", "water bottle", "vanilla", "lemon", "chile pepper", "sweet potato", "potato", "lettuce",
"cucumber", "spinach", "hops", "sand", "iron"}

i["blastFurnaceInput"] = {1, -7, -2, 3}
i["blastFurnaceOutput"] = {0, -7, -2, 3}
i["bowl"] = {3, -7, 2, 3}
i["bucket"] = {2, -7, 2, 3}
i["cooking pot"] = {3, -7, 1, 3}
i["food press"] = {3, -7, 0, 3}
i["FurnaceInput"] = {1, -7, -1, 3}
i["FurnaceOutput"] = {0, -7, -1, 3}
i["milk"] = {0, -7, 1, 3}
i["mortarAndPestle"] = {2, -7, 0, 3}
i["pan"] = {2, -7, 1, 3}
i["water"] = {0, -7, 2, 3}

i.get = function(ing, num, slot)
  num = num or 1
  slot = slot or 1
  if (not ing) then
    print("ingredient name needed")
  end
  message = "Getting " .. ing
  rednet.send(SERVER, message)
  --print("getting", ing)
  t.moveTo(i.getCoordinates(ing))
  if (turtle.getItemCount(slot) == 0) then
    turtle.select(slot)
    turtle.suck(num)
    turtle.select(1)
  end
end

i.getCoordinates = function(name)
  columns = 15
  rows = 2
  index = -1
  for j=1,table.getn(i.List) do
    if (i.List[j] == name) then
      index = j
      c = -8 + (index % (columns))
      if (c == -8) then c = 7 end
      r = math.floor((index - 1) / columns)
      return {r, c, 2, 0}
    end
  end
  if (index == -1) then
    return i[name]
  end
end

i.fillContainer = function(liquid, slot)
  i.get("bucket", 1, slot)
  rednet.send(SERVER, "Getting " .. liquid)
  t.moveTo(i[liquid])
  turtle.select(slot)
  if (liquid == "water") then
    turtle.placeDown()
  else
    turtle.place()
  end
  turtle.select(1)
end

i.bakeInFurnace = function(slot, time, blast)
  blast = blast or ""
  t.moveTo(i[blast .. "FurnaceInput"])
  turtle.drop()
  t.moveTo(i[blast .. "FurnaceOutput"])
  rednet.send(SERVER, "Baking for " .. time .. " Seconds")
  os.sleep(time)
  turtle.select(slot)
  turtle.suckDown()
end




return i
