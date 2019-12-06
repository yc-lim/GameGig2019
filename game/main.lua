local class = require 'middleclass'
local class = require 'Player'

function love.load()
  screenW = 1280
  screenH = 720
  love.window.setMode(screenW, screenH)
  -- canvas = love.graphics.newCanvas(screenW, screenH)
  -- love.graphics.setCanvas(canvas)

  startX = 20
  
  p1 = Player:new("P1")
  p2 = Player:new("P2")

  --images = {}
  --images["P1"] =  love.graphics.newImage("assets/tank.png")
  --images["P2"] = love.graphics.newImage("assets/tank.png")

  --[[p1 = {}
  p1.name = "P1"
  p1.image = love.graphics.newImage("assets/tank.png")
  p1.w , p1.h = p1.image:getDimensions()
  p1.x = startX + p1.h/2
  p1.y = screenH/2
  p1.angle = math.pi/2 ]]

  --[[p2 = {}
  p2.name = "P2"
  p2.image = love.graphics.newImage("assets/tank.png")
  p2.w , p2.h = p2.image:getDimensions()
  p2.x = screenW - p2.h/2 - startX
  p2.y = screenH/2
  p2.angle =  - math.pi/2]]

end

function love.update(dt)

end

function drawPlayer(p)
  love.graphics.draw(p.image, p.x, p.y, p.angle, 1, 1, p.w/2, p.h/2)
end

-- self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
function love.draw()
  love.graphics.setColor(200, 200, 200)
  love.graphics.rectangle("fill", 0, 0, screenW, screenH)
  
  p1.draw()
  p2.draw()
  --drawPlayer(p2)
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle("fill", screenW/2, screenH/2, 2, 2)
end



