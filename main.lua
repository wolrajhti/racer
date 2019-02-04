require 'math_addon'
require 'color'
HC = require 'HC'
local Car = require 'car'
local Camera = require 'hump.camera'

local cars
local camera
local boundingBox

function love.load()
	love.graphics.setBackgroundColor(unpack(white))

	cars = {}
	table.insert(cars, Car({x = 150, y = 700, dir = -math.pi / 3, w = 48, h = 32, acc = 1e3, ft = 1, fn = 5, controls = {left = 'left', up = 'up', right = 'right', down = 'down'}}))
	table.insert(cars, Car({x = 150, y = 700, dir = -math.pi / 2, w = 48, h = 32, acc = 1e3, ft = 1, fn = 5, controls = {left = 'q', up = 'z', right = 'd', down = 's'}}))

	boundingBox = math.boundingBox(cars)
	math.boundingBoxOffset(boundingBox, 200)
	local cx, cy = math.boundingBoxCenter(boundingBox)
	local zoom = math.min(
		love.graphics.getWidth() / math.boundingBoxWidth(boundingBox),
		love.graphics.getHeight() / math.boundingBoxHeight(boundingBox)
	)
	print(cx, cy, zoom)
	camera = Camera(cx, cy, zoom)
	camera.smoother = Camera.smooth.damped(10)
end

local collisions, collide, cx, cy, dx, dy
function love.update(dt)
	for i, car in ipairs(cars) do
		car:update(dt)
	end
	collisions = {}
	for i = 1, #cars - 1 do
		for j = i + 1, #cars do
			collide, dx, dy = cars[i].rect:collidesWith(cars[j].rect)
			if collide then
				cx, cy = cars[j].rect:center()
				table.insert(collisions, {cx, cy, cx + dx, cy + dy})
				-- cars[i].rect:move(-.6 * dx, -.6 * dy)
				-- cars[i].x = cars[i].x + -.6 * dx
				-- cars[i].y = cars[i].y + -.6 * dy
				-- cars[j].rect:move(.6 * dx, .6 * dy)
				-- cars[j].x = cars[j].x + .6 * dx
				-- cars[j].y = cars[j].y + .6 * dy
			end
		end
	end
	boundingBox = math.boundingBox(cars)
	math.boundingBoxOffset(boundingBox, 200)
	camera:lockPosition(math.boundingBoxCenter(boundingBox))
	camera:zoomTo(math.min(
		love.graphics.getWidth() / math.boundingBoxWidth(boundingBox),
		love.graphics.getHeight() / math.boundingBoxHeight(boundingBox)
	))
end

function love.draw()
	camera:attach()
	for i, car in ipairs(cars) do
		car:draw()
	end
	setRed()
	for i, collision in ipairs(collisions) do
		love.graphics.line(collision[1], collision[2], collision[3], collision[4])
	end
	camera:detach()
	love.graphics.print(love.timer.getFPS(), 16, 584)
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end