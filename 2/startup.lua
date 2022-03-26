c = dofile("chef.lua")
r = dofile("recipes.lua")

function orderFood(order)
  r = dofile("recipes.lua")
  food, num = c.parseOrder(order)
  food = r.recipeList[tonumber(food)][2]
  print("food", food)
  print("num", num)
  print(assert(findfunction(food))(tonumber(num)))
end

function parseOrder(order)
  result = {};
  for match in (order .. " "):gmatch("(.-)".." ") do
    table.insert(result, match)
  end
  return result[1], result[2]
end

function findfunction(x)
  r = dofile("recipes.lua")
  print("in find function")
  assert(type(x) == "string")
  local f=r
  print("f: ", type(f))
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

rednet.open("left") --enable modem on the right side of the PC

for j=1,1000 do
  id,order = rednet.receive() --wait until a mesage is received
  if id == 5 then
    print("order received", order)
    orderFood(order)
  end
end
  --rednet.close("left") -- disable modem on the right side of the PC
