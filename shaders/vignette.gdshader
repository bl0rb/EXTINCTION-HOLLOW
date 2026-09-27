shader_type canvas_item;
// Darkens the screen edges.

uniform vec4 tint : source_color = vec4(0.01, 0.02, 0.04, 1.0);
uniform float strength = 0.75;

void fragment() {
	float v = smoothstep(0.25, 0.62, length((UV - 0.5) * vec2(1.0, 0.75)));
	COLOR = vec4(tint.rgb, v * strength);
}
