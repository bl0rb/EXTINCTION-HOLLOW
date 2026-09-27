-- Tile based collision against the world tilemap.
local M = {}

local TILEMAP = "/world#tilemap"
local LAYER = "ground"
local TILE_SIZE = 32
local BLOCKING_TILES = { [4] = true } -- rock

-- True if a square footprint with the given half size at (x, y) overlaps a blocking tile or leaves the map.
function M.is_blocked(x, y, radius)
	local bx, by, bw, bh = tilemap.get_bounds(TILEMAP)
	for _, ox in ipairs({ -radius, radius }) do
		for _, oy in ipairs({ -radius, radius }) do
			local cx = math.floor((x + ox) / TILE_SIZE) + 1
			local cy = math.floor((y + oy) / TILE_SIZE) + 1
			if cx < bx or cy < by or cx >= bx + bw or cy >= by + bh then
				return true
			end
			if BLOCKING_TILES[tilemap.get_tile(TILEMAP, LAYER, cx, cy)] then
				return true
			end
		end
	end
	return false
end

return M
