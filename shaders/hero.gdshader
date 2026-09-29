shader_type canvas_item;
// The player's dino (GAME_SPEC §150): a worn set tints its crest of spines in the set's colour,
// the whole set makes the spines glitter, and they flash when they bite back.

uniform vec4 crest_color : source_color = vec4(0.36, 0.76, 0.69, 1.0);
uniform float tint = 0.0; // 0 its own teal .. 1 the set's colour
uniform float shimmer = 0.0; // 0 still .. 1 glittering
uniform float flash = 0.0;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 raw = texture(TEXTURE, UV);
	vec3 c = raw.rgb;
	// the spines are the only blue-green pixels of the sprite
	if (raw.g - raw.r > 0.1 && raw.b - raw.r > 0.08) {
		float lum = dot(raw.rgb, vec3(0.3, 0.55, 0.15));
		c = mix(c, crest_color.rgb * (0.55 + lum * 1.1), tint);
		vec2 px = floor(UV / TEXTURE_PIXEL_SIZE);
		float across = fract(UV.x * 10.0); // across one frame of the sheet
		float band = smoothstep(0.07, 0.0, abs(fract(across * 1.4 - px.y * 0.006 - TIME * 0.9) - 0.5));
		float twinkle = step(0.9, fract(sin(dot(px, vec2(12.9898, 78.233)) + floor(TIME * 7.0)) * 43758.5453));
		c += (band * 1.2 + twinkle * 0.7) * shimmer;
		c = mix(c, vec3(1.0), flash);
	}
	COLOR = vec4(c, raw.a) * modulate;
}
