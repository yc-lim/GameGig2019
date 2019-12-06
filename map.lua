white = { 255, 255, 255, 255 }
grey = { 128, 128, 128, 255 }
red = { 255, 0, 0, 255 }
green = { 0, 255, 0, 255 }
blue = { 0, 0, 255, 255 }
gold = { 255, 215, 0, 255 }

x_grid_max = 130
y_grid_max = 99
base_size = 50
cursor_size=25

width  = base_size*(x_grid_max+1)
height = base_size*(y_grid_max+1)
--love.window.setMode(0, 0)

WATER = 2
WALL = 1
OPEN = 0

function love.load()
	love.graphics.newCanvas(width,height)

	player = {grid_x = 1,grid_y = 1,}

	maze = {
	["exit"] = {
	grid_x = x_grid_max - 1,
	grid_y = y_grid_max - 1
	},
	["start"] = {
	grid_x = 1,
	grid_y = 1
	}
	}

	time = os.time()
	math.randomseed( time )
	map = generate_maze()
end


function love.draw()
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

	love.graphics.setColor( red )

	love.graphics.rectangle("fill", maze.exit.grid_x*base_size, maze.exit.grid_y*base_size, base_size, base_size)

	love.graphics.setColor( green )

	love.graphics.rectangle("fill", maze.start.grid_x*base_size, maze.start.grid_y*base_size, base_size, base_size)

	love.graphics.setColor( gold )

	love.graphics.rectangle("fill", player.grid_x*base_size, player.grid_y*base_size, cursor_size, cursor_size)
end

--function love.keypressed(key)
function love.update(dt)
	if (love.keyboard.isDown('up')) then
		if collide(-dt-cursor_size, 0) and collide (-dt-cursor_size/base_size,cursor_size/base_size) then
		player.grid_y = player.grid_y - dt
		end
	elseif (love.keyboard.isDown('down')) then
		if collide(dt+cursor_size/base_size, 0) and collide(dt+cursor_size/base_size,cursor_size/base_size) then
		player.grid_y = player.grid_y + dt
		end
	elseif (love.keyboard.isDown('left')) then
		if collide(0, -dt) and collide(cursor_size/base_size,-dt) then
		player.grid_x = player.grid_x - dt
		end
	elseif (love.keyboard.isDown('right')) then
		if collide(0, dt+cursor_size/base_size) and collide (cursor_size/base_size,dt+cursor_size/base_size) then
		player.grid_x = player.grid_x + dt
		end
	elseif (love.keyboard.isDown('escape')) then
		love.event.push('quit')
	end
end
-- if key == "up" then
-- 	if collide(-1, 0) then
-- 	player.grid_y = player.grid_y - 0.5
-- 	end

-- 	elseif key == "down" then
-- 		if collide(1, 0) then
-- 		player.grid_y = player.grid_y + 0.5
-- 	end

-- 	elseif key == "left" then
-- 		if collide(0, -1) then
-- 		player.grid_x = player.grid_x - 0.5
-- 	end

-- 	elseif key == "right" then
-- 		if collide(0, 1) then
-- 		player.grid_x = player.grid_x + 0.5
-- 	end

-- 	elseif key == 'escape' then
-- 		love.event.push('quit')
-- 	end
--end

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


function collide(y, x)
if map[math.floor(player.grid_y + y)][math.floor(player.grid_x + x)] ~= OPEN then
	return false
end
return true
end


