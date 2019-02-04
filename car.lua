local Car = {}
Car.__index = Car

local DIR_MAX = math.asin(.25) --angle de braquage max pour avoir un rayon de braquage égal à 4 fois l'empatement du véhicule

local function new(config)
	local x = config.x or 0 
	local y = config.y or 0
	local dir = config.dir or 0
	local w = config.w or 48
	local h = config.h or 32
	local rect = HC.rectangle(x - w, y - h / 2, w, h)
	rect:setRotation(dir, x, y)
	return setmetatable({
		x = x, --position x
		y = y, --position y
		dir = dir, --direction du véhicule
		w = w, --empatement du véhicule
		h = h, --largeur
		acc = config.acc or 1e3, --puissance
		ft = config.ft or 1, --résistance au roulement
		fn = config.fn or 5, --résistance au dérapage
		controls = config.controls or {
			left = 'left',
			up = 'up',
			right = 'right',
			down = 'down'
		},
		vt = 0, --vitesse tangentielle
		vn = 0, --vitesse normale
		radius = 0, --rayon de braquage (=empatement / sin(angle de braquage))
		positions = {}, --historique des positions
		rect = rect
	}, Car)
end

function Car:update(dt)
	--mise à jour de la direction
	local dDir = 0
	if love.keyboard.isDown(self.controls.right) then dDir = DIR_MAX
	elseif love.keyboard.isDown(self.controls.left) then dDir = -DIR_MAX end
	local nextDir = self.dir + dDir
	--mise à jour de l'accélération
	local dAcc = 0
	if love.keyboard.isDown(self.controls.up) then dAcc = self.acc
	elseif love.keyboard.isDown(self.controls.down) then dAcc = -self.acc end
	
	--mise à jour des vitesses
	self.vt = self.vt + (dAcc * math.cos(dDir) - self.vt * self.ft) * dt
	self.vn = self.vn + (dAcc * math.sin(dDir) - self.vn * self.fn) * dt
	--trajectoire
	if dDir ~= 0 then
		--trajectoire courbe
		self.radius = math.abs(self.w / math.sin(dDir))
		self.c_gamma = math.sign(math.uy(dDir))
		self.c_delta = math.sign(math.ux(dDir))
		self.a_gamma = self.c_delta * self.c_gamma
		self.a_delta = -math.sign(math.vx(dDir)) * self.c_delta * self.c_gamma
		--courbe tangentielle
		self:rotate(self.a_gamma * self.vt * dt / self.radius, math.v(nextDir, self.radius * self.c_gamma, self.x, self.y))
		--courbe normale
		self:rotate(self.a_delta * self.vn * dt / self.radius, math.u(nextDir, self.radius * self.c_delta, self.x, self.y))
	else
		--trajectoire rectiligne
		self.x = self.x + math.ux(nextDir, self.vt * dt) - math.vx(nextDir, self.vn * dt)
		self.y = self.y + math.uy(nextDir, self.vt * dt) - math.vy(nextDir, self.vn * dt)
		self.rect:move(
			math.ux(nextDir, self.vt * dt) - math.vx(nextDir, self.vn * dt),
			math.uy(nextDir, self.vt * dt) - math.vy(nextDir, self.vn * dt)
		)
	end

	--mise à jour de l'historique
	if #self.positions == 1000 then table.remove(self.positions, 1) end
	table.insert(self.positions, {
		self.x + math.vx(self.dir, .5 * self.h),
		self.y + math.vy(self.dir, .5 * self.h),
		self.x - math.vx(self.dir, .5 * self.h),
		self.y - math.vy(self.dir, .5 * self.h),
		self.x - math.ux(self.dir, self.w) - math.vx(self.dir, .5 * self.h),
		self.y - math.uy(self.dir, self.w) - math.vy(self.dir, .5 * self.h),
		self.x - math.ux(self.dir, self.w) + math.vx(self.dir, .5 * self.h),
		self.y - math.uy(self.dir, self.w) + math.vy(self.dir, .5 * self.h)
	})
end

function Car:rotate(r, cx, cy)
	self.x, self.y = math.rotate(self.x, self.y, r, cx, cy)
	self.vt, self.vn = math.rotate(self.vt, self.vn, r)
	self.dir = self.dir + r
	self.rect:rotate(r, cx, cy)
end

function Car:draw()
	for i, pos in ipairs(self.positions) do
		if i == #self.positions then
			setRed()
		else
			setGrey((#self.positions - i) / #self.positions)
		end
		love.graphics.polygon('fill', pos[1], pos[2], pos[3], pos[4], pos[5], pos[6], pos[7], pos[8])
	end
	setBlue()
	self.rect:draw('fill')
end

function Car:getPosition()
	return self.x, self.y
end

-- the module
return setmetatable({new = new}, {__call = function(_, ...) return new(...) end})