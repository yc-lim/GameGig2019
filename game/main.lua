HC = require "HC"

function love.load()
  screenW = 1280
  screenH = 720
  love.window.setMode(screenW, screenH)
  
  startX = 35

  --game over or not
  gamegoingon = true;


  p1 = {}
  p1.name = "P1"
  p1.image = love.graphics.newImage("assets/tank.png")
  local w , h = p1.image:getDimensions()
  p1.box = HC.rectangle(startX, screenH/2, w, h)
  p1.box:setRotation(math.pi/2)
  p1.alive = true;

  p2 = {}
  p2.name = "P2"
  p2.image = love.graphics.newImage("assets/tank.png")
  p2.box = HC.rectangle(screenW - h - startX, screenH/2, w, h)
  p2.box:setRotation(- math.pi/2)
  p2.alive = true
end

function playerPlayerStop()
  local collisions = HC.collisions(p1.box)
  for other, v_d in pairs(collisions) do
    if other == p2.box then
      p1.box:move(v_d.x/2, v_d.y/2)
      p2.box:move(-v_d.x/2, -v_d.y/2)
      return true
    end
    return false
  end
end

function playerWallStop(p)
  --b = true
  --while b do
    local collisions = HC.collisions(p1.box)
    for other, v_d in pairs(collisions) do
      if false then
        p.box:move(v_d)
        break
      end
    end
    b = playerPlayerStop()
  --end
end

function updatePlayer(p, dt)
  local speed = 200
  local angularV = math.pi/6
  local v = 0
  local w = 0

  -- get input
  if p.name == "P1" then
    if love.keyboard.isDown('w') then
      v = speed
    elseif love.keyboard.isDown('s') then
      v = - speed
    end
    if love.keyboard.isDown('a') then
      w = - angularV
    elseif love.keyboard.isDown('d') then
      w = angularV
    end
  else
    if love.keyboard.isDown('up') then
      v = speed
    elseif love.keyboard.isDown('down') then
      v = - speed
    end
    if love.keyboard.isDown('left') then
      w = - angularV
    elseif love.keyboard.isDown('right') then
      w = angularV
    end
  end

  -- update position
  local W , H = p1.image:getDimensions()
  p.box:rotate(w * dt)
  p.box:move(v * math.sin(p.box:rotation()) * dt, - v * math.cos(p.box:rotation()) * dt)
  -- playerPlayerStop()
  playerWallStop(p)
end

function love.update(dt)
  updatePlayer(p1, dt)
  updatePlayer(p2, dt)
end

function drawPlayer(p)
  local W, H = p.image:getDimensions()
  local x, y = p.box:center()
  love.graphics.draw(p.image, x, y, p.box:rotation(), 1, 1, W/2, H/2)
end

-- self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
function love.draw()
  if gamegoingon then
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    drawPlayer(p1)
    drawPlayer(p2)
  else
    font = love.graphics.newFont(34) -- the number denotes the font size
    love.graphics.setFont( font )
    if p1.alive then
    --failed to print screedW/2
        love.graphics.printf("Game Over, P1 wins",100, 100, 200, 'center' )
    else
        love.graphics.printf("Game Over, p2 wins",100, 100, 200, 'center' )
    end
  end
end