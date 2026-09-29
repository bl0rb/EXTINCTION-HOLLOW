shader_type canvas_item;
// Daylight grading (GAME_SPEC §142): in full daylight the dark palette is lifted like a camera's exposure,
// shadows and midtones brighten while bright colours keep their shading; at night it does nothing.

uniform sampler2D screen : hint_screen_texture, filter_nearest;
uniform float lift = 0.0; // 0 at night .. 1 at noon

void fragment() {
	vec3 c = texture(screen, SCREEN_UV).rgb;
	vec3 graded = pow(c, vec3(1.0 / (1.0 + 0.75 * lift)));
	float luma = dot(graded, vec3(0.299, 0.587, 0.114));
	graded = mix(vec3(luma), graded, 1.0 + 0.3 * lift); // keep the colours from washing out
	COLOR = vec4(clamp(graded, 0.0, 1.0), 1.0);
}
