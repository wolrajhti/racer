function math.norm(x, y)
	return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

function math.normalized(x, y)
	if math.norm(x, y) == 0 then return 0, 0
	else return x / math.norm(x, y), y / math.norm(x, y) end
end

function math.normalize(x, y, n)
	local nx, ny = math.normalized(x, y)
	return n * nx, n * ny
end

function math.dot(x1, y1, x2, y2) return x1 * x2 + y1 * y2 end

function math.vec(x1, y1, x2, y2) return x1 * y2 - x2 * y1 end

function math.angle(x1, y1, x2, y2)
	if math.vec(x1, y1, x2, y2) < 0 then return -math.acos(math.dot(x1, y1, x2, y2))
	else return math.acos(math.dot(x1, y1, x2, y2)) end
end

function math.rotate(x, y, a, cx, cy)
	if cx and cy then return (x - cx) * math.cos(a) - (y - cy) * math.sin(a) + cx, (x - cx) * math.sin(a) + (y - cy) * math.cos(a) + cy
	else return x * math.cos(a) - y * math.sin(a), x * math.sin(a) + y * math.cos(a) end
end

function math.ux(a, n) if n then return n * math.cos(a) else return math.cos(a) end end
function math.uy(a, n) if n then return n * math.sin(a) else return math.sin(a) end end

function math.u(a, n, x, y) if n and x and y then return x + n * math.cos(a), y + n * math.sin(a)
							elseif n then return n * math.cos(a), n * math.sin(a)
							else return math.cos(a), math.sin(a) end
end

function math.vx(a, n) if n then return -n * math.sin(a) else return -math.sin(a) end end
function math.vy(a, n) if n then return n * math.cos(a) else return math.cos(a) end end

function math.v(a, n, x, y) if n and x and y then return x - n * math.sin(a), y + n * math.cos(a)
							elseif n then return -n * math.sin(a), n * math.cos(a)
							else return -math.sin(a), math.cos(a) end
end

function math.add(x1, y1, x2, y2) return x1 + x2, y1 + y2 end
function math.sub(x1, y1, x2, y2) return x1 - x2, y1 - y2 end

function math.sign(x) if x < 0 then return -1 else return 1 end end

function math.slope(dx, dy, x, y)
	if dx == 0 then return x else return {dy / dx, y - (dy / dx) * x} end
end

function math.inter(s1, s2)
	if type(s1) ~= 'table' and type(s2) == 'table' then
		return s1, s2[1] * s1 + s2[2]
	elseif type(s1) == 'table' and type(s2) ~= 'table' then
		return s2, s1[1] * s2 + s1[2]
	elseif type(s1) == 'table' and type(s2) == 'table' then
		return (s1[2] - s2[2]) / (s2[1] -s1[1]), s1[1] * (s1[2] - s2[2]) / (s2[1] -s1[1]) + s1[2] end
end

function math.boundingBox(objs)
	local x1, y1, x2, y2 = 9e9, 9e9, -9e9, -9e9
	local x, y
	for i, obj in ipairs(objs) do
		x, y = obj:getPosition()
		x1 = math.min(x1, x)
		y1 = math.min(y1, y)
		x2 = math.max(x2, x)
		y2 = math.max(y2, y)
	end
	return {x1, y1, x2, y2}
end

function math.boundingBoxOffset(boundingBox, offset)
	boundingBox[1] = boundingBox[1] - offset
	boundingBox[2] = boundingBox[2] - offset
	boundingBox[3] = boundingBox[3] + offset
	boundingBox[4] = boundingBox[4] + offset
end

function math.boundingBoxCenter(boundingBox)
	return (boundingBox[1] + boundingBox[3]) / 2, (boundingBox[2] + boundingBox[4]) / 2
end

function math.boundingBoxRatio(boundingBox)
	return (boundingBox[3] - boundingBox[1]) / (boundingBox[4] - boundingBox[2])
end

function math.boundingBoxWidth(boundingBox)
	return boundingBox[3] - boundingBox[1]
end

function math.boundingBoxHeight(boundingBox)
	return boundingBox[4] - boundingBox[2]
end