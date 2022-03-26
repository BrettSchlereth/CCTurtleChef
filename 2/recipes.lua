t = dofile("turtleMovement.lua")
i = dofile("ingredients.lua")

local r = {}

r.recipeList = {{"Hamburger", 'hamburger'}, {"Cheeseburger", 'cheeseburger'}, {"French Fries", 'frenchFries'},
 {"Sweet Potato Fries", 'sweetPotatoFries'}, {"Potato Chips", 'potatoChips'}, {"Pizza", 'pizza'}, {"Cheese Pizza", 'cheesePizza'},
{"Supreme Pizza", 'supremePizza'}, {"Bredd", 'bread'}, {"Baked Sweet Potato", 'bakedSweetPotato'},
 {"Figgy Pudding", 'figgyPudding'}, {"Doughnut", 'doughnut'}, {"Chocolate", 'chocolate'}, {"Turtle Soup", 'turtleSoup'}}


r.setCoords = function(coordinates)
  coords = coordinates
  print("recipe coordinates", coords[1], coords[2], coords[3], coords[4])
end

r.cookFood = function(num, slot)
  num = num or 1
  slot = slot or 1
  turtle.select(slot)
  turtle.craft(num)
  turtle.select(1)
end

r.bakedSweetPotato = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making baked sweet potato")
  i.get("sweet potato", num, 1)
  i.bakeInFurnace(1, num * 10)
  t.deliver()
end

r.bread = function(num, slot, ingOrMain)
  print("making bread")
  slot = slot or 1
  i.get("wheat", num, 10)
  i.get("wheat", num, 11)
  i.get("wheat", num, 12)
  r.cookFood(num, slot)
  t.deliver(ingOrMain)
end

r.butter = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making butter")
  r.salt(num, 10, "ing")
  i.get("cooking pot", 1, 5)
  i.get("food press", 1, 6)
  for j=1,num do
    i.fillContainer("milk", 9)
    r.cookFood(num, slot)
    t.dropTempChest(slot)
  end
  t.emptyExtras(1 + slot)
  t.pickUp({slot})
  t.deliver(ingOrMain)
end

r.caramel = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making caramel")
  r.sugar(num)
  i.bakeInFurnace(1, 10*num)
  if (ingOrMain == "main") then
    t.deliver()
  end
end

r.cheese = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  subOrIng = subOrIng or "main"
  --make salt
    --check for water bottles
      --if there are no water bottles, make more
        --if there are no buckets, make more
        --if there is no glass, make more
    --blast water bottles for salt
  for j=1,num do
    i.get("water bottle", 1, 1)
    i.bakeInFurnace(10, 20, "blast")
    i.fillContainer("milk", 7)
    i.get("cooking pot", 1, 6)
    --t.pickUp()
    r.cookFood(1, slot)
    t.emptyExtras(slot+1)
    if (ingOrMain == "ing" or num > 1) then
      t.dropTempChest(slot)
    end
  end
  t.deliver(ingOrMain)
end

r.cheeseburger = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making cheeseburger")
  r.cheese(num, 1, "ing")
  t.dropTempChest()
  r.bread(num, 1, "ing")
  i.get("raw beef", num, 6)
  i.get("pan", 1, 5)
  t.pickUp({2})
  r.cookFood(num, slot)
  t.deliver()
end

r.cheesePizza = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making cheese pizza")
  r.dough(num, 2, "ing")
  t.dropTempChest(2)
  r.cheese(num * 2, 2, "ing")
  t.pickUp({5, 6})
  turtle.select(6)
  turtle.transferTo(9, num)
  turtle.select(1)
  i.get("tomato", num, 7)
  i.get("pan", 1, 10)
  t.pickUp()
  r.cookFood(num, slot)
  t.deliver()
end

r.chocolate = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making chocolate")
  r.butter(num, 2, "ing")
  i.get("cooking pot", 1, 5)
  i.get("cocoa beans", num)
  r.cookFood(num, slot)
  t.deliver(ingOrMain)
end

r.dough = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  subOrIng = subOrIng or "ing"
  print("making dough")
  for j=1,num do
    r.flour(1, 10)
    i.fillContainer("water", 7)
    i.get("cooking pot", 1, 6)
    r.cookFood(1, slot)
    t.emptyExtras(1+slot)
    if (ingOrMain == "ing" or num > 1) then
      t.dropTempChest(slot)
    end
  end
  t.deliver(ingOrMain)
end

r.doughnut = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  r.sugar(num, 1)
  t.dropTempChest(1)
  r.flour(num * 2, 5, "ing")
  turtle.select(5)
  turtle.transferTo(10, num)
  turtle.select(1)
  t.pickUp({9})
  for j=1,num do
    i.fillContainer("milk", 6)
    r.cookFood()
    if (ingOrMain == "ing" or num > 1) then t.dropTempChest() end
  end
  t.deliver()
end

r.figgyPudding = function(num, slot)
  print("making figgy pudding")
  num = num or 1
  slot = slot or 1
  for j=1,num do
    r.sugar(1, 2)
    t.dropTempChest(2)
    r.whippingCream(1, 1)
    t.dropTempChest(1)
    i.fillContainer("water", 6)
    i.get("egg", 1, 5)
    i.get("fig", 1, 2)
    i.get("date", 1, 1)
    t.pickUp({3, 7})
    r.cookFood(1, slot)
    t.emptyExtras(2)
    t.dropTempChest(1)
    t.deliver()
  end
  if (slot == 1) then
    t.deliver()
  end
end

r.flour = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making flour")
  i.get("wheat", num, 10)
  i.get("wheat", num, 11)
  r.cookFood(num, slot)
  if (ingOrMain == "main") then
    t.deliver()
  end
end

r.frenchFries = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making french fries")
  r.oliveOil(num, 1, "ing")
  t.dropTempChest(1)
  r.salt(num, 9, "ing")
  t.pickUp({10})
  i.get("potato", num, 5)
  i.get("cooking pot", 1, 6)
  r.cookFood(num, slot)
  t.deliver(ingOrMain)
end

r.hamburger = function(num, slot)
  slot = slot or 1
  print("making hamburger")
  r.bread(num, 6, "ing")
  i.get("raw beef", num, 10)
  i.get("pan", 1, 11)
  r.cookFood(num, slot)
  t.deliver()
end

r.molasses = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or 1
  i.get("sugar cane", num)
  i.bakeInFurnace(slot, 10 * num)
  t.deliver(ingOrMain)
end

r.noodle = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making noodle")
  r.salt(num)
  t.dropTempChest()
  r.flour(num, 10)
  t.pickUp({9})
  i.get("cooking pot", 1, 5)
  for j=1,num do
    i.fillContainer("water", 6)
    r.cookFood(num, 1)
    t.dropTempChest()
  end
  t.emptyExtras()
  t.pickUp()
  t.deliver(ingOrMain)
end

r.oliveOil = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making olive oil")
  i.get("olive", num, 1)
  i.get("olive", num, 2)
  i.get("food press", 1, 5)
  r.cookFood(num)
  t.emptyExtras(2)
  turtle.select(slot)
  turtle.transferTo(slot, num)
  turtle.select(1)
  t.deliver(ingOrMain)
end

r.pizza = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making pizza")
  r.dough(num, 2, "ing")
  t.dropTempChest(2)
  r.cheese(num, 2, "ing")
  t.pickUp({5, 6})
  i.get("tomato", num, 9)
  i.get("pan", 1, 10)
  t.pickUp()
  r.cookFood(num, slot)
  t.deliver()
end

r.potatoChips = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  rednet.send(5, "Making Potato Chips")
  r.salt(num, 1, "ing")
  t.dropTempChest()
  r.oliveOil(num, 10, "ing")
  turtle.select(1)
  turtle.transferTo(10, num)
  turtle.select(1)
  t.pickUp{9}
  i.get("potato", num, 5)
  i.get("pan", 1, 6)
  r.cookFood(num)
  t.deliver(ingOrMain)
end

r.salt = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making salt")
  i.get("water bottle", num, 1)
  i.bakeInFurnace(10, 20 * num, "blast")
  turtle.transferTo(slot)
  t.deliver(ingOrMain)
end

r.sugar = function(num, slot, ingOrMain)
  print("making sugar")
  slot = slot or 1
  i.get("sugar cane", num, 1)
  r.cookFood(num, slot)
  if (ingOrMain == "main") then
    t.deliver()
  end
end

r.supremePizza = function(num, slot)
  slot = slot or 1
  print("making supreme pizza")
  r.dough(num, 2, "ing")
  r.cheese(num, 2, "ing")
  i.get("tomato", num, 3)
  i.get("bell pepper", num, 5)
  i.get("olive", num, 6)
  i.get("raw porkchop", num, 7)
  i.get("pan", 1, 9)
  t.pickUp()
  r.cookFood(num, slot)
  t.deliver()
end

r.sweetPotatoFries = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "main"
  print("making sweet potato fries")
  r.oliveOil(num, 1, "ing")
  t.dropTempChest(1)
  r.salt(num, 9, "ing")
  t.pickUp({10})
  i.get("sweet potato", num, 5)
  i.get("cooking pot", 1, 6)
  r.cookFood(num, slot)
  t.deliver(ingOrMain)
end

r.tofu = function(num, slot, ingOrMain)
  num = num or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making tofu")
  i.get("soybeans", num, 9)
  i.get("cooking pot", 1, 5)
  for j=1,num do
    i.fillContainer("water", 6)
    r.cookFood()
    t.dropTempChest()
  end
  t.emptyExtras()
  t.pickUp()
  t.deliver()
end

r.tortilla = function(num, slot, ingOrMain)
  num = math.floor((num + 1) / 2) or 1
  slot = slot or 1
  ingOrMain = ingOrMain or "ing"
  print("making tortilla")
  r.flour(num, 5, "ing")
  i.get("pan", 1, 6)
  for j=1,num do
    i.fillContainer("water", 9)
    r.cookFood(num, 1)
    t.dropTempChest(1)
  end
  t.pickUp()
  t.deliver(ingOrMain)
end

r.turtleSoup = function(num, slot, ingOrMain)
  slot = slot or 1
  print("making turtle soup")
  for j=1,num do
    i.fillContainer("water", 7)
    i.get("turtle", 1, 6)
    i.get("bowl", 1, 10)
    r.cookFood(num, slot)
    t.dropTempChest(1)
  end
  t.emptyExtras()
  t.pickUp()
  t.deliver(ingOrMain)
end

r.whippingCream = function(num, slot)
  slot = slot or 1
  print("making whipping cream")
  for j=1,num do
    r.sugar(1, 7)
    i.fillContainer("milk", 6)
    i.get("vanilla", 1, 10)
    r.cookFood()
    t.dropTempChest()
    t.emptyExtras()
  end
end


return r
