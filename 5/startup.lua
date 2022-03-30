

recipeList = {{"Fried Egg", 'friedEgg', 64}, {"Scrambled Eggs", 'scrambledEggs'}, {"Buttered Toast", 'butteredToast'}, {"Egg Sandwich", 'eggSandwich', 32}, {"Pancakes x3", 'pancakes', 16}, {"Grilled Cheese", 'grilledCheese', 64}, {"Hamburger", hamburger, 64}, {"Cheeseburger", 'cheeseburger', 64}, {"French Fries", 'frenchFries', 64},
 {"Onion rings", 'onionRings', 64}, {"Sweet Potato Fries", sweetPotatoFries, 64}, {"Potato Chips", 'potatoChips', 64}, {"Pizza", pizza, 64}, {"Cheese Pizza", 'cheesePizza', 64},
{"Supreme Pizza", supremePizza, 64}, {"Chicken and Dumplings", 'chickenAndDumplings', 64}, {"Leek Soup", 'leekSoup'}, {"Bredd", 'bread', 64}, {"Cucumber Salad", 'cucumberSalad', 64}, {"Baked Sweet Potato", 'bakedSweetPotato', 64},
 {"Figgy Pudding", 'figgyPudding', 64}, {"Brownies", 'brownies'}, {"Chocolate Ice Cream", 'chocolateIceCream', 16}, {"Doughnut", 'doughnut', 64}, {"Chocolate Bar x8", 'chocolate', 8}, {"Turtle Soup", turtleSoup, 9}}

function checkOrder(order)
  foodid, foodnum = parseOrder(order)
  if (type(foodid) == "number" and type(foodnum) == "number") then
    if (foodid > 0 and foodid < table.getn(recipeList)) then
      if (foodnum > 0 and foodnum <= recipeList[foodid][3]) then
        return true
      else
        print("Please enter a food quantity greater than 0 and less than", recipeList[foodid][3] + 1)
        return false
      end
    else
      print("Please enter a valid food id number")
      return false
    end
  else
    print("Please enter only numbers")
    return false
  end
end

function printMenu()
  --prints the menu to the monitor
  monitor.clear()
  monitor.setCursorPos(1, 1)
  print("TYPE THE CORRESPONDING NUMBER FOR THE FOOD YOU WANT, FOLLOWED BY THE QUANTITY i.e. '4 2'")
  col = 1
  row = 2
  for j=1,table.getn(recipeList) do
    monitor.write(tostring(j) .. ".")
    monitor.write(recipeList[j][1])
    monitor.setCursorPos(col, row)
    row = row + 1
    if (row > 19) then
      col = 24
      row = 1
    end
  end
end

function parseOrder(order)
  result = {};
  for match in (order .. " "):gmatch("(.-)".." ") do
    table.insert(result, match)
  end
  return tonumber(result[1]), tonumber(result[2])
end

monitor = peripheral.wrap("top")
rednet.open("back") --enable the modem attached to the right side of the PC

for j=1,1000 do
  printMenu()
  order = read()
  print("order:", order)
  if (checkOrder(order) == true) then
        rednet.send(2, order)
        message = ""
        monitor.clear()
        monitor.setCursorPos(1, 1)
        j = 1
        while (message ~= "order complete") do
          id,message = rednet.receive(999999) --wait until something is received over rednet
          monitor.setCursorPos(1, j)
          monitor.write(message)
          if (j > 18) then
            monitor.scroll(1)
          else
            j = j + 1
          end

        end
  end
end

print("disconnecting")
rednet.close("back") --disable modem on the right side of the PC
