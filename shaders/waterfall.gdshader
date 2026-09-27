shader_type canvas_item;
// Falling water: per-column streaks scrolling down in whole pixels.

uniform vec4 dark : source_color = vec4(0.14, 0.3, 0.38, 1.0);
uniform vec4 mid : source_color = vec4(0.32, 0.54, 0.63, 1.0);
uniform vec4 foam : source_color = vec4(0.66, 0.82, 0.88, 1.0);
uniform float speed = 70.0; // pixels per second

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 px = floor(UV / TEXTURE_PIXEL_SIZE);
	float col_rand = fract(sin(px.x * 91.7) * 4375.85);
	float s = fract((px.y - floor(TIME * speed * (0.8 + col_rand * 0.4))) / (6.0 + col_rand * 10.0) + col_rand);
	vec3 col = s < 0.5 ? dark.rgb : (s < 0.85 ? mid.rgb : foam.rgb);
	COLOR = vec4(col, tex.a * 0.85);
}
