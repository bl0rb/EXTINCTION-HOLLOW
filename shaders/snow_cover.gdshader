shader_type canvas_item;
// Snow settling on the ground: white patches grow with the coverage, dithered per world pixel.

uniform sampler2D noise : repeat_enable, filter_linear;
uniform float coverage = 0.0;
uniform vec2 world_size = vec2(2304.0, 960.0);

const float BAYER[16] = { 0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0 };

void fragment() {
	vec2 px = floor(UV * world_size);
	float n = texture(noise, px / vec2(420.0, 300.0)).r;
	float amount = smoothstep(1.0 - coverage - 0.12, 1.0 - coverage + 0.12, n * 0.9 + 0.1);
	float b = BAYER[int(mod(px.y, 4.0)) * 4 + int(mod(px.x, 4.0))] / 16.0;
	COLOR = vec4(0.84, 0.88, 0.94, float(amount > b) * 0.92);
}
