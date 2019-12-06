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
end

function bulletmove(bul)
    if map[bullet.y + bullet.vy*dt, bullet.x] ~=OPEN then 
        bullet.vy = - bullet.vy
        bullet.x = bullet.x + vx*dt
    elseif map[bullet.y, bullet.x+ bullet.vx*dt] ~=OPEN then 
        bullet.vx = - bullet.vx
        bullet.y = bullet.y + vx*dt
    else 
        bullet.x = bullet.x + vx*dt
        bullet.y = bullet.y + vx*dt
    end
end

function bulletsMove()
    for i=1,#bullets do
        local bullet = bullets[i]
        if map[bullet.y + bullet.vy*dt, bullet.x] ~=OPEN then 
            bullet.vy = - bullet.vy
            bullet.x = bullet.x + vx*dt
        elseif map[bullet.y, bullet.x+ bullet.vx*dt] ~=OPEN then 
            bullet.vx = - bullet.vx
            bullet.y = bullet.y + vx*dt
        else 
            bullet.x = bullet.x + vx*dt
            bullet.y = bullet.y + vx*dt
        end

    end
end


