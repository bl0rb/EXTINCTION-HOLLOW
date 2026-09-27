-- Animal species data and the registry of living animals.
local M = {}

M.species = {
	[hash("lizard")] = {
		xp = 4,
		radius = 6, -- half size of the collision footprint in pixels
		speed = 30, -- wandering, pixels per second
		flee_speed = 75, -- slower than the player so it can be caught
		turn_speed = 10,
		fear_radius = 70,
		calm_radius = 140,
		wander_radius = 80,
		idle_time = 2,
	},
}

-- game object id -> species data
M.alive = {}

local PICK_TOLERANCE = 8 -- extra pixels so small animals are easy to click

-- Returns the id of the living animal closest to (x, y) within click range, or nil.
function M.find_at(x, y)
	local best, best_dist
	for id, data in pairs(M.alive) do
		local pos = go.get_position(id)
		local dist = math.sqrt((pos.x - x) ^ 2 + (pos.y - y) ^ 2)
		if dist <= data.radius + PICK_TOLERANCE and (not best or dist < best_dist) then
			best, best_dist = id, dist
		end
	end
	return best
end

return M
