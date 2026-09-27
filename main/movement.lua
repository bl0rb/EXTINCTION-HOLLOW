-- Click-to-move helpers without engine calls.
local M = {}

-- Moves (x, y) towards (tx, ty) by at most distance. Returns the new position and whether the target was reached.
function M.step(x, y, tx, ty, distance)
	local dx, dy = tx - x, ty - y
	local remaining = math.sqrt(dx * dx + dy * dy)
	if remaining <= distance then
		return tx, ty, true
	end
	local f = distance / remaining
	return x + dx * f, y + dy * f, false
end

-- Turns angle towards target (radians) by at most max_delta along the shortest way.
function M.turn(angle, target, max_delta)
	local diff = (target - angle + math.pi) % (2 * math.pi) - math.pi
	if math.abs(diff) <= max_delta then
		return target
	end
	return angle + (diff > 0 and max_delta or -max_delta)
end

return M
