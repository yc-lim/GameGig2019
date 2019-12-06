local class = require 'middleclass'

Player = class('Player')

Damage1 = 32
Damage2 = 25
MaxFuel = 100

function Player:initialize(name)
  self.name = name
  self.image = love.graphics.newImage("assets/tank.png")
  self.w , self.h = self.image:getDimensions()
  self.x = startX + self.h/2
  self.y = screenH/2
  self.angle = math.pi/2
  print(30)
  -- self.FuelTime = 0
  -- self.HP = 100
  -- self.Speed = 15
end

function Player:update(dt)
    local speed = 200
    --the current
    local velocity
    --in radians per sec!
    local angularV = math.pi/6
    local vx = 0
    local vy = 0

    -- get input
    if love.keyboard.isDown('up') then
        velocity = speed
    elseif love.keyboard.isDown('down') then
        velocity = -speed
    end

    if love.keyboard.isDown('left') then
        angle = angle - angularV
    elseif love.keyboard.isDown('right') then
        angle = angle + angularV
    end

    -- calculate speed
    local v = math.sqrt(vx^2 + vy^2)
    if v > speed then
        vx = velocity*math.sin(angle)
        vy = velocity*math.cos(angle)
    end

    -- update position
    self.x = self.x + vx * dt
    self.y = self.y + vy * dt
end

function Player:draw()
  love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
end





