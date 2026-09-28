shader_type canvas_item;
// Dungeon floor and walls from a cell grid (red = floor), in the 3/4 view: a wall above floor shows its rock face.
// Stone slabs, dithered shading and darker corners, posterized per world pixel.

uniform sampler2D grid : filter_nearest;
uniform sampler2D noise : repeat_enable, filter_linear;
uniform vec2 cells = vec2(60.0, 44.0);
uniform float cell = 16.0;
uniform vec4 floor_dark : source_color = vec4(0.1, 0.09, 0.08, 1.0);
uniform vec4 floor_light : source_color = vec4(0.24, 0.21, 0.18, 1.0);
uniform vec4 wall_top : source_color = vec4(0.07, 0.065, 0.06, 1.0);
uniform vec4 wall_face : source_color = vec4(0.3, 0.27, 0.24, 1.0);
uniform vec4 accent : source_color = vec4(0.3, 0.45, 0.25, 1.0); // moss, lava, ice

const float BAYER[16] = { 0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0 };

float floor_at(vec2 c) {
	if (c.x < 0.0 || c.y < 0.0 || c.x >= cells.x || c.y >= cells.y) {
		return 0.0;
	}
	return texture(grid, (c + 0.5) / cells).r;
}

void fragment() {
	vec2 px = floor(UV * cells * cell);
	vec2 c = floor(px / cell);
	vec2 f = px - c * cell;
	float b = BAYER[int(mod(px.y, 4.0)) * 4 + int(mod(px.x, 4.0))] / 16.0;
	float n = texture(noise, px / 96.0).r;
	float n2 = texture(noise, px / 19.0).r;
	vec3 col;
	if (floor_at(c) > 0.5) {
		// slabs in offset rows, grout between them
		float row = floor(px.y / 12.0);
		float sx = mod(px.x + mod(row, 2.0) * 9.0, 18.0);
		float sy = mod(px.y, 12.0);
		float grout = (sx < 1.0 || sy < 1.0) ? 1.0 : 0.0;
		float v = 0.35 + 0.45 * n + 0.3 * (n2 - 0.5);
		// the wall above casts a shadow, corners are darker
		float above = 1.0 - floor_at(c + vec2(0.0, -1.0));
		float left = 1.0 - floor_at(c + vec2(-1.0, 0.0));
		float right = 1.0 - floor_at(c + vec2(1.0, 0.0));
		v -= above * clamp(1.0 - f.y / 8.0, 0.0, 1.0) * 0.5;
		v -= left * clamp(1.0 - f.x / 5.0, 0.0, 1.0) * 0.3 + right * clamp((f.x - 10.0) / 5.0, 0.0, 1.0) * 0.3;
		v -= grout * 0.25;
		v = floor(clamp(v, 0.0, 1.0) * 4.0 + b) / 4.0;
		col = mix(floor_dark.rgb, floor_light.rgb, v);
		float speck = step(0.82, n2) * step(0.6, n);
		col = mix(col, accent.rgb, speck * 0.5);
	} else if (floor_at(c + vec2(0.0, 1.0)) > 0.5 && f.y >= 4.0) {
		// rock face seen from the front, lit from above, with a ledge on top
		float streak = texture(noise, vec2(px.x / 7.0, px.y / 38.0)).r;
		float v = 0.85 - (f.y - 4.0) / 12.0 * 0.55 + (streak - 0.5) * 0.5;
		v += (f.y < 5.0) ? 0.25 : 0.0;
		v = floor(clamp(v, 0.0, 1.0) * 4.0 + b) / 4.0;
		col = mix(wall_face.rgb * 0.35, wall_face.rgb, v);
		col = mix(col, accent.rgb, step(0.78, streak) * step(f.y, 9.0) * 0.6);
	} else {
		// the top of the rock, darker the further it is from open ground
		float near = max(max(floor_at(c + vec2(0.0, 1.0)), floor_at(c + vec2(0.0, 2.0))), max(floor_at(c + vec2(1.0, 0.0)), floor_at(c + vec2(-1.0, 0.0))));
		float v = 0.3 + 0.4 * n2 + 0.3 * near;
		v = floor(clamp(v, 0.0, 1.0) * 3.0 + b) / 3.0;
		col = wall_top.rgb * (0.5 + 0.8 * v);
	}
	COLOR = vec4(col, 1.0);
}
