--up, right, forward, rotation
t = dofile("turtleMovement.lua")
r = dofile("recipes.lua")
i = dofile("ingredients.lua")

function findfunction(x)
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

function loadLocation()
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

function printMenu()
  print("TYPE THE CORRESPONDING NUMBER FOR THE FOOD YOU WANT, FOLLOWED BY THE QUANTITY")
  for j=1,table.getn(r.recipeList) do
    print(j, r.recipeList[j][1])
  end
end

turtle.refuel()
loadLocation()
t.goHome()
printMenu()
x=r.recipeList[1][2]
print(arg[1])
--print(assert(findfunction(x))(1))
t.goHome()
--t.pickUp()
