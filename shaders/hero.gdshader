shader_type canvas_item;
// The player's dino (GAME_SPEC §150): a worn set tints its crest of spines in the set's colour,
// the whole set makes the spines glitter, and they flash when they bite back. Its body can be painted in the primary colour.

uniform vec4 crest_color : source_color = vec4(0.36, 0.76, 0.69, 1.0);
uniform float tint = 0.0; // 0 its own teal .. 1 the set's colour
uniform float shimmer = 0.0; // 0 still .. 1 glittering
uniform float flash = 0.0;
uniform vec4 body_color : source_color = vec4(0.77, 0.4, 0.17, 1.0);
uniform float recolor = 0.0; // 0 its own rust orange .. 1 the chosen colour

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

vec3 rgb2hsv(vec3 c) {
	vec4 k = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, k.wz), vec4(c.gb, k.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + 1e-10)), d / (q.x + 1e-10), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(1.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
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
	} else if (recolor > 0.0) {
		vec3 hsv = rgb2hsv(raw.rgb);
		if (hsv.y > 0.5 && hsv.x < 0.1 && hsv.z > 0.13) { // the orange body, not the belly, eyes, claws or outline
			vec3 target = rgb2hsv(body_color.rgb);
			vec3 painted = hsv2rgb(vec3(fract(target.x + (hsv.x - 0.06) * 0.6), clamp(target.y * hsv.y / 0.75, 0.0, 1.0),
				clamp(hsv.z * pow(target.z / 0.77, 0.7), 0.0, 1.0)));
			c = mix(c, painted, recolor);
		}
	}
	COLOR = vec4(c, raw.a) * modulate;
}
