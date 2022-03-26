--up, right, forward, rotation
t = dofile("turtleMovement.lua")
r = dofile("recipes.lua")
i = dofile("ingredients.lua")

local c = {}

c.findfunction = function(x)
  print("in find function")
  assert(type(x) == "string")
  local f=r
  for v in x:gmatch("[^%.]+") do
    if type(f) ~= "table" then
       return nil, "looking for '"..v.."' expected table, not "..type(f)
    end
    f=f[v]
  end
  if type(f) == "function" then
    return f
  else
    return nil, "expected function, not "..type(f)
  end
end

c.loadLocation = function()
  file = io.open("coordinates.lua", "r+")
  io.input(file)
  coordinates = {}
  for i=1,4 do
    coordinates[i] = tonumber(io.read())
  end
  io.close(file)
  print("loaded coordinates are: ", coordinates[1], coordinates[2], coordinates[3], coordinates[4])
  return coordinates
end

c.parseOrder = function(order)
  result = {};
  for match in (order .. " "):gmatch("(.-)".." ") do
    table.insert(result, match)
  end
  return result[1], result[2]
end

c.orderFood = function(order)
  food, num = c.parseOrder(order)
  food = r.recipeList[tonumber(food)][2]
  print("food", food)
  print("num", num)
  print(assert(c.findfunction(food))(tonumber(num)))
end

turtle.refuel()
c.loadLocation()
t.goHome()
--printMenu()
--x=r.recipeList[1][2]
--print(arg[1])
--r.bakedSweetPotato(1)
--orderFood("2 1")
--print(assert(findfunction(x))(1))
--t.pickUp()

return c
