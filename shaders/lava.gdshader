shader_type canvas_item;
render_mode unshaded;
// Glowing, slowly churning lava; the heat comes from the texture (red channel).

uniform sampler2D noise : repeat_enable, filter_linear;
uniform float activity = 1.0; // brighter while the volcano is restless

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 px = floor(UV / TEXTURE_PIXEL_SIZE);
	float n = texture(noise, px / 96.0 + vec2(TIME * 0.004, -TIME * 0.02)).r;
	float heat = clamp(tex.r * (0.7 + 0.6 * n) * activity, 0.0, 1.2);
	vec3 col = mix(vec3(0.35, 0.05, 0.02), vec3(0.95, 0.35, 0.06), smoothstep(0.1, 0.6, heat));
	col = mix(col, vec3(1.0, 0.86, 0.42), smoothstep(0.7, 1.05, heat));
	COLOR = vec4(floor(col * 7.0) / 7.0, tex.a);
}
