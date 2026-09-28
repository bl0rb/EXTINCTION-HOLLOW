shader_type canvas_item;
// Plants lean slowly in the wind; the base stays in place.

uniform float amount = 1.2;
global uniform float wind; // raised by bad weather and earthquakes

void vertex() {
	vec2 world = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	VERTEX.x += sin(TIME * 1.4 + world.x * 0.05 + world.y * 0.02) * amount * wind * (1.0 - UV.y) * 2.0; // x2: the HD sprites are drawn at half size
}
