

recipeList = {{"Hamburger", hamburger}, {"Cheeseburger", 'cheeseburger'}, {"French Fries", 'frenchFries'},
 {"Sweet Potato Fries", sweetPotatoFries}, {"Potato Chips", 'potatoChips'}, {"Pizza", pizza}, {"Cheese Pizza", 'cheesePizza'},
{"Supreme Pizza", supremePizza}, {"Bredd", 'bread'}, {"Baked Sweet Potato", 'bakedSweetPotato'},
 {"Figgy Pudding", 'figgyPudding'}, {"Doughnut", 'doughnut'}, {"Chocolate", 'chocolate'}, {"Turtle Soup", turtleSoup}}

function printMenu()
  --prints the menu to the screen
  monitor.clear()
  monitor.setCursorPos(1, 1)
  print("TYPE THE CORRESPONDING NUMBER FOR THE FOOD YOU WANT, FOLLOWED BY THE QUANTITY i.e. '4 2'")
  for j=1,table.getn(recipeList) do
    monitor.write(tostring(j) .. ".")
    monitor.write(recipeList[j][1])
    monitor.setCursorPos(1, j + 1)
  end
end

monitor = peripheral.wrap("top")
rednet.open("right") --enable the modem attached to the right side of the PC

for j=1,1000 do
  printMenu()
  order = read()
  print("order:", order)
  rednet.send(2, order)
  message = ""
  monitor.clear()
  monitor.setCursorPos(1, 1)
  j = 1
  while (message ~= "order complete") do
    id,message = rednet.receive(999999) --wait until something is received over rednet
    monitor.write(message)
    monitor.setCursorPos(1, j)
    j = j + 1
  end


end


if id == 2 then
   write("PC2 -")
   print(message)
   rednet.send(2,"How are you") --Send a message only to the PC with ID 2
   print("PC1 - How are you")
   id,message = rednet.receive(10) --Wait until a message arrives or 10 seconds pass
   if message == "Fine thanks" then
    print("PC2 - Fine thanks")
   end
end
print("disconnecting")
rednet.close("right") --disable modem on the right side of the PC
