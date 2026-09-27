shader_type canvas_item;
// Slowly drifting fog, posterized and dithered per world pixel.

uniform sampler2D noise : repeat_enable, filter_linear;
uniform vec4 fog_color : source_color = vec4(0.6, 0.7, 0.85, 1.0);
uniform float density = 0.3;
uniform vec2 drift = vec2(0.004, 0.0015);
uniform vec2 world_size = vec2(1280.0, 960.0);

const float BAYER[16] = { 0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0 };

void fragment() {
	vec2 px = floor(UV * world_size);
	vec2 uv = px / world_size;
	float n = texture(noise, uv + drift * TIME).r * 0.6 + texture(noise, uv * 2.1 - drift * TIME * 1.6).r * 0.4;
	float f = smoothstep(0.4, 0.8, n);
	float b = BAYER[int(mod(px.y, 4.0)) * 4 + int(mod(px.x, 4.0))] / 16.0;
	f = floor(f * 3.0 + b) / 3.0;
	COLOR = vec4(fog_color.rgb, f * density);
}
