shader_type canvas_item;
// Pixel-art water: depth comes from the texture (red channel), glints drift over the surface.

uniform vec4 shallow : source_color = vec4(0.09, 0.2, 0.23, 1.0);
uniform vec4 deep : source_color = vec4(0.02, 0.05, 0.07, 1.0);
uniform vec4 glint : source_color = vec4(0.62, 0.86, 0.9, 1.0);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 px = floor(UV / TEXTURE_PIXEL_SIZE);
	vec3 col = mix(shallow.rgb, deep.rgb, tex.r);
	float wave = sin(px.y * 0.9 + sin(px.x * 0.13 + TIME * 0.8) * 2.5 - TIME * 1.2);
	float h = fract(sin(dot(floor(px / vec2(4.0, 1.0)), vec2(12.9898, 78.233))) * 43758.5453);
	float patch = step(0.25, sin(px.x * 0.045 + TIME * 0.25) * sin(px.y * 0.11 - TIME * 0.18));
	col = mix(col, glint.rgb, step(0.97, wave) * step(0.5, h) * patch * (1.0 - tex.r * 0.5));
	col = mix(col, shallow.rgb * 1.5, step(tex.r, 0.06) * 0.6);
	COLOR = vec4(col, tex.a);
}
