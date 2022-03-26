local t = {}

t.loadLocation = function()
  file = io.open("coordinates.lua", "r+")
  io.input(file)
  coordinates = {}
  for i=1,4 do
    coordinates[i] = tonumber(io.read())
  end
  io.close(file)
  return coordinates
end


t.updateLocation = function(up, right, forward, rotation)
  local coordinates = t.loadLocation()
  up = up or 0
  right = right or 0
  forward = forward or 0
  rotation = rotation or 0
  --print("in update location, rotation is: ", rotation)
  local changes = {up, right, forward, rotation}
  file = io.open("coordinates.lua", "w")
  io.output(file)
  for i=1,4 do
    coordinates[i] = coordinates[i] + changes[i]
    io.write(coordinates[i], '\n')
  end
  --print("new coordinates", coordinates[1], coordinates[2], coordinates[3], coordinates[4])
  io.close()
end

t.moveUpDown = function(upDown)
  for i=1,math.abs(upDown) do
    if (upDown > 0) then
      if not turtle.up() then upDown = upDown - 1 end
    else
      if not turtle.down(math.abs(upDown)) then upDown = upDown + 1 end
    end
  end
  return upDown
end

t.moveLeftRight = function(leftRight)
  if (leftRight > 0) then
    turtle.turnRight()
    posOrNeg = -1
  elseif (leftRight < 0) then
    turtle.turnLeft()
    posOrNeg = 1
  else
    posOrNeg = 0
  end

  for i=1,math.abs(leftRight) do
    if not turtle.forward() then leftRight = leftRight + posOrNeg end
  end
  if (posOrNeg < 0) then turtle.turnLeft()
  elseif (posOrNeg > 0) then
    turtle.turnRight()
  end
  return leftRight
end

t.moveForwardBack = function(forwardBack)
  for i=1,math.abs(forwardBack) do
    if (forwardBack > 0) then
      if not turtle.forward() then
        forwardBack = forwardBack - 1
        print("turtle blocked")
      end
    elseif (forwardBack < 0) then
      if not turtle.back() then
        forwardBack = forwardBack + 1
        print("turtle blocked")
      end
    end
  end
  return forwardBack
end

t.rotation = function(rotateAmount)
  local coords = t.loadLocation()
  --print("coords[4]", coords[4])
  --print("rotateAmount before: ", rotateAmount)
  for i=1,rotateAmount do
    turtle.turnRight()
  end
  rotateAmount = (coords[4] + rotateAmount) % 4
  --print("rotateAmount after: ", rotateAmount)
  return rotateAmount
end

t.faceFront = function()
  local coords = t.loadLocation()
  t.rotation((4 - coords[4]) % 4)
  t.updateLocation(0, 0, 0, -coords[4])
end

t.move = function(upDown, leftRight, forwardBack, rotate)
  upDown = upDown or 0
  leftRight = leftRight or 0
  forwardBack = forwardBack or 0

  t.faceFront(upDown, leftRight, forwardBack, rotate)
  upDown = t.moveUpDown(upDown)
  leftRight = t.moveLeftRight(leftRight)
  forwardBack = t.moveForwardBack(forwardBack)
  rotate = t.rotation(rotate)
  --print("in move, rotate is now", rotate)
  t.updateLocation(upDown, leftRight, forwardBack, rotate)
end

t.goHome = function()
  --c = t.loadLocation()
  --r = (4 - c[4]) % 4
  --t.move(c[1]*-1, c[2]*-1, c[3]*-1, r)
  t.moveTo({0, 0, 0, 0})
end

t.moveTo = function(toc)
  tc = t.loadLocation()
  local moveCommand = {}
  for i=1,3 do
    moveCommand[i-1] = toc[i] - tc[i]
  end
  --moveCommand[3] = (4 + (toc[4] - tc[4])) % 4
  moveCommand[3] = toc[4]
  t.move(moveCommand[0], moveCommand[1], moveCommand[2], moveCommand[3])
end

t.turnAround = function()
  turtle.turnLeft()
  turtle.turnLeft()
end

t.emptyExtras = function(skipNumSlots)
  skipNumSlots = skipNumSlots or 1
  t.moveTo({0, 0, 2, 0})
  for i=skipNumSlots,16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.select(1)
  t.goHome()
end

t.dropTempChest = function(slot, num)
  slot = slot or 1
  t.goHome()
  turtle.select(slot)
  turtle.dropDown()
  turtle.select(1)
end

t.pickUp = function(slots)
  slots = slots or {}
  t.goHome()
  if (table.getn(slots) > 0) then
    turtle.select(16)
  end
  j = 1
  while (turtle.suckDown()) do
    if (table.getn(slots) >= j) then
      turtle.transferTo(slots[j])
      j = j + 1
    end
  end
  turtle.select(1)
end

t.deliver = function(ingOrMain, num)
  ingOrMain = ingOrMain or "main"
  if (ingOrMain == "main") then
    print("delivering")
    num = num or 1
    t.pickUp()
    t.moveTo({0, 0, -2, 2})
    for i=1,num do
      turtle.select(i)
      turtle.drop()
    end
    turtle.select(1)
    t.emptyExtras()
    t.goHome()
    rednet.send(5, "order complete")
  end
end





return t
