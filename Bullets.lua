HC = require 'HC'
bullets = {}

function shoot()
    local bullet = {}
    bullet.x = self.x
    bullet.y = self.y
    bullet.speed = 500
    bullet.angle = self.angle
    bullet.vx = v*math.sin( self.angle )
    bullet.vy = v*math.cos( self.angle )
    table.insert( bullets,bullet )
    bullet.hitcircle = HC.circle(bullet.x, bullet.y, radius)
    bullet.reflectcount = 10
end

function bulletsMove()
    for i=1,#bullets do
        local bullet = bullets[i]
        if bullet.reflectcount <1 then 
            table.remove(bullets, i)
        end
        -- not usable anymore with HC
        if map[math.floor(bullet.y + bullet.vy*dt)/20, math.floor(bullet.x/20)] ~=OPEN then 
            bullet.vy = - bullet.vy
            bullet.x = bullet.x + vx*dt
            bullet.reflectcount = bullet.reflectcount - 1 
        elseif [math.floor(bullet.y/20), math.floor(bullet.x + bullet.vx*dt)/20, ] ~=OPEN then 
            bullet.vx = - bullet.vx
            bullet.y = bullet.y + vx*dt
            bullet.reflectcount = bullet.reflectcount -1
        else 
            bullet.x = bullet.x + vx*dt
            bullet.y = bullet.y + vx*dt
        end
    end
end


