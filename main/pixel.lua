-- Pixel-perfect view math shared by the render script and gameplay scripts.
local M = {}

M.BASE_WIDTH = 640
M.BASE_HEIGHT = 360

-- Largest integer scale at which the base resolution fits the window, times camera zoom.
function M.get_scale(window_width, window_height, zoom)
	local base = math.floor(math.min(window_width / M.BASE_WIDTH, window_height / M.BASE_HEIGHT))
	return math.max(1, base) * zoom
end

-- Visible world rectangle (left, bottom, width, height), snapped to whole screen pixels
-- so the camera never renders at sub-pixel offsets.
function M.get_view(cam_x, cam_y, zoom, window_width, window_height)
	local scale = M.get_scale(window_width, window_height, zoom)
	local left = (math.floor(cam_x * scale + 0.5) - math.floor(window_width / 2)) / scale
	local bottom = (math.floor(cam_y * scale + 0.5) - math.floor(window_height / 2)) / scale
	return left, bottom, window_width / scale, window_height / scale
end

function M.screen_to_world(screen_x, screen_y, cam_x, cam_y, zoom, window_width, window_height)
	local left, bottom, width, height = M.get_view(cam_x, cam_y, zoom, window_width, window_height)
	return left + screen_x / window_width * width, bottom + screen_y / window_height * height
end

return M
