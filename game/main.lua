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

  bullets = {}
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

function shoot(p)
    local bullet = {}
    bullet.x = p.x
    bullet.y = p.y
    bullet.speed = 500
    bullet.angle = p.angle
    bullet.vx = v*math.sin( p.angle )
    bullet.vy = v*math.cos( p.angle )
    bullet.hitcircle = HC.point(bullet.x, bullet.y)
    bullet.reflectcount = 10
    table.insert( bullets,bullet )
end

function updateBullets(dt)
    for i=1,#bullets do
        local bullet = bullets[i]
        if bullet.reflectcount <1 then 
            table.remove(bullets, i)
        end
        if map[math.floor(bullet.y + bullet.vy*dt)/20][ math.floor(bullet.x/20)] ~=OPEN then 
            bullet.vy = - bullet.vy
            bullet.x = bullet.x + vx*dt
            bullet.reflectcount = bullet.reflectcount - 1 
        elseif map[math.floor(bullet.y/20)][math.floor(bullet.x + bullet.vx*dt)/20] ~=OPEN then 
            bullet.vx = - bullet.vx
            bullet.y = bullet.y + vx*dt
            bullet.reflectcount = bullet.reflectcount -1
        else 
            bullet.x = bullet.x + vx*dt
            bullet.y = bullet.y + vx*dt
        end
    end
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
    if love.keyboard.isDown('space') then 
      shoot (p)
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
    if love.keyboard.isDown('kp0') then 
      shoot(p)
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
  updateBullets(dt)
end

function drawPlayer(p)
  local W, H = p.image:getDimensions()
  local x, y = p.box:center()
  love.graphics.draw(p.image, x, y, p.box:rotation(), 1, 1, W/2, H/2)
end

function drawBullets()
    for i=1,#bullets do
    local bullet = bullets[i]
	love.graphics.circle('fill',bullet.x, bullet.y, 1)
end

end

-- self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
function love.draw()
  if gamegoingon then
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)
    drawPlayer(p1)
    drawPlayer(p2)
    drawBullets()
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