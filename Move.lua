--initialization

FuelTime = 0
HP = 100
Damage1 = 32
Damage2 = 25
MaxFuel = 100
Speed = 15
angle = 0

function damage(a)
  HP = HP - a
end

function move()
    local speed = 200
    --the current
    local velocity
    --in radians per sec!
    local angularV
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

function hit(bullet,tank)
    if bullet.hitcircle:collidesWith(tank.box) then
        tank.HP = tank.HP - Damage1
        if tank.HP<0 then tank.alive = false
        gamegoingon = false
        end
    end
end
