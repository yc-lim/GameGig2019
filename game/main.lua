

function love.load()
  screenW = 1280
  screenH = 720
  love.window.setMode(screenW, screenH)
  -- canvas = love.graphics.newCanvas(screenW, screenH)
  -- love.graphics.setCanvas(canvas)

  startX = 20
  
  --images = {}
  --images["P1"] =  love.graphics.newImage("assets/tank.png")
  --images["P2"] = love.graphics.newImage("assets/tank.png")

  p1 = {}
  p1.name = "P1"
  p1.image = love.graphics.newImage("assets/tank.png")
  p1.w , p1.h = p1.image:getDimensions()
  p1.x = startX + p1.h/2
  p1.y = screenH/2
  p1.angle = math.pi/2

  p2 = {}
  p2.name = "P2"
  p2.image = love.graphics.newImage("assets/tank.png")
  p2.w , p2.h = p2.image:getDimensions()
  p2.x = screenW - p2.h/2 - startX
  p2.y = screenH/2
  p2.angle = - math.pi/2
end

function updatePlayer(p, dt)
    local speed = 30
    local v = 0
    local angularV = math.pi/6

    -- get input
    if p.name == "P1" then
      if love.keyboard.isDown('up') then
        v = speed
      elseif love.keyboard.isDown('down') then
        v = -speed
      end
      if love.keyboard.isDown('left') then
        p.angle = p.angle - angularV * dt
      elseif love.keyboard.isDown('right') then
        p.angle = p.angle + angularV * dt
      end
    else
      if love.keyboard.isDown('w') then
        v = speed
      elseif love.keyboard.isDown('s') then
        v = -speed
      end
      if love.keyboard.isDown('a') then
        p.angle = p.angle - angularV * dt
      elseif love.keyboard.isDown('d') then
        p.angle = p.angle + angularV * dt
      end
    end

    -- update position
    p.x = p.x + v * math.sin(p.angle) * dt
    p.y = p.y - v * math.cos(p.angle) * dt
end

function love.update(dt)
  updatePlayer(p1, dt)
  updatePlayer(p2, dt)
end

function drawPlayer(p)
  love.graphics.draw(p.image, p.x, p.y, p.angle, 1, 1, p.w/2, p.h/2)
end

-- self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
function love.draw()
  love.graphics.setColor(200, 200, 200)
  love.graphics.rectangle("fill", 0, 0, screenW, screenH)
  
  drawPlayer(p1)
  drawPlayer(p2)
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle("fill", screenW/2, screenH/2, 2, 2)
end



