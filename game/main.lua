HC = require "HC"

white = { 255, 255, 255, 255 }
grey = { 128, 128, 128, 255 }
red = { 255, 0, 0, 255 }
green = { 0, 255, 0, 255 }
blue = { 0, 0, 255, 255 }
gold = { 255, 215, 0, 255 }

base_size = 20
x_grid_max = 20
y_grid_max = 20

width  = base_size*(x_grid_max+1)
height = base_size*(y_grid_max+1)

WATER = 2
WALL = 1
OPEN = 0


function generate_maze()
	map = {}
	for i=0, y_grid_max do
		map[i] = {}
		for j=0, x_grid_max do
			map[i][j] = WALL
		end
	end

	for i=0, y_grid_max do
		for j=0, x_grid_max do
			map[0][j] = WATER
			map[y_grid_max][j] = WATER
		end
	  map[i][x_grid_max] = WATER
	  map[i][0] = WATER
	end

  map[maze.start.grid_y][maze.start.grid_x] = OPEN
  walls = {
    ["0102"] = { y=1, x=2 },
    ["0201"] = { y=2, x=1 }
  }

  seen =  { ["0101"] = { x=1, y=1 } }

  while next(walls) ~= nil do
    key = rand_key(walls)

    wall = walls[key]
    walls[key] = nil
    seen[key] = wall

    y = wall.y
    x = wall.x

    north      = is_open(map, y-1, x)
    south      = is_open(map, y+1, x)
    west       = is_open(map, y,   x-1)
    east       = is_open(map, y,   x+1)

    is_center = (north and south) or (north and west) or (north and east) or
          (south and west) or (south and east) or (east and west)

    if not is_center then
      map[y][x] = OPEN
      add_wall(walls, seen, map, y-1, x) -- north
      add_wall(walls, seen, map, y+1, x) -- south
      add_wall(walls, seen, map, y, x-1) -- east
      add_wall(walls, seen, map, y, x+1) -- west
    end
  end

  for i=1, y_grid_max-1 do
    if map[i][x_grid_max-1] == OPEN then
      maze.exit.grid_y = i
    end
  end
  return map
end

function add_wall(walls, seen, map, y, x)
  key = string.format("%.2d%.2d", y, x)
  if (map[y][x] == WALL) and (seen[key] == nil) then
    walls[key] = { y=y, x=x }
  end
end

function rand_key(hash)
  ks = {}
  for k,v in pairs(hash) do table.insert(ks, k) end
  return ks[math.random(1, #ks)]
end

function is_open(map, y, x)
  if map[y][x] == OPEN then
    return true
  else
    return false
  end
end

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

  for x = 0, x_grid_max do
	  for y = 0, y_grid_max do
		  if map[x][y] == WALL then
			  table.insert(hcs, HC.rectangle(x*base_size, y*base_size, base_size, base_size))
		  end
		end
	end
end

function playerPlayerStop()
  -- local collisions = HC.collisions(p1.box)
  -- for other, v_d in pairs(collisions) do
  local collide, dx, dy = p1.collidesWith(p2.box)
  if collide then
    p1.box:move(-dx/2, -dy/2)
    p2.box:move(dx/2, dy/2)
    return true
  end
  return false
end

function playerWallStop(p)
  --b = true
  --while b do
    for wall in hcs do
      local collide, dx, dy = wall.collidesWith(p.box)
      if collide then
        p.box:move(dx, dy)
        break
      end
    end
    b = playerPlayerStop()
  --end
end


function shoot(p)
    local bullet = {}
    bullet.x, bullet.y = p.box:center()
    b_speed = 500
    -- bullet.angle = p.angle
    bullet.vx = b_speed * math.sin( p.box:rotation() )
    bullet.vy = - b_speed * math.cos( p.box:rotation() )
    bullet.hitcircle = HC.point(bullet.x, bullet.y)
    bullet.reflectcount = 10
    table.insert( bullets,bullet )
end

function updateBullets(dt)
    for i=1,#bullets do
        local bullet = bullets[i]
        --[[if bullet.reflectcount <1 then 
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
        else ]]
            bullet.x = bullet.x + bullet.vx * dt
            bullet.y = bullet.y + bullet.vy * dt
        --end
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
  love.graphics.setColor(0, 0, 0)
  for i=1, #bullets do
    local bullet = bullets[i]
	love.graphics.circle('fill', bullet.x, bullet.y, 1)
  end
end

-- self.x = clamp(self.x + vx * dt, 0 + self.radius, nativeCanvasWidth - self.radius)
function love.draw()
  if gamegoingon then
    for x=0, x_grid_max do
		  for y=0, y_grid_max do
			  if map[y][x] == OPEN then

				  love.graphics.setColor( white )
				  love.graphics.rectangle("fill", x * base_size, y * base_size, base_size, base_size)

			  elseif map[y][x] == WALL then

				  love.graphics.setColor( grey )
				  love.graphics.rectangle("line", x * base_size, y * base_size, base_size, base_size)

			  elseif map[y][x] == WATER then

				  love.graphics.setColor( blue )
				  love.graphics.rectangle("fill", x * base_size, y * base_size, base_size, base_size)

			  end
		  end
	  end

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