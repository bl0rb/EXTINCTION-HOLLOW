shader_type canvas_item;
// The overworld ground, painted from the world's parameters (GAME_SPEC §114, §150): jungle, steppe, floodplain, swamp,
// volcano and snowfields, the river with its fords, the cliff with its ramp, the creek, pond shore and paths,
// scattered grass, stones and leaves - dithered and posterized per world pixel like the rest of the pixel art.

uniform sampler2D noise_big : repeat_enable, filter_linear;
uniform sampler2D noise_fine : repeat_enable, filter_linear;
uniform vec2 world_size = vec2(3072.0, 1536.0);
uniform vec3 borders = vec3(1300.0, 2304.0, 820.0); // west, east, ridge
uniform vec4 river_a = vec4(1010.0, 28.0, 170.0, 0.0); // base, amplitude, length, phase
uniform vec3 river_b = vec3(12.0, 61.0, 1.3); // amplitude, length, phase
uniform vec2 fords = vec2(600.0, 1760.0);
uniform vec4 edge_a = vec4(250.0, 6.0, 53.0, 0.0); // plateau edge: base, amplitude, length, phase
uniform vec4 edge_b = vec4(4.0, 17.0, 1.0, 1330.0); // amplitude, length, phase, where the cliff ends
uniform vec2 ramp = vec2(990.0, 1130.0);
uniform vec4 pond = vec4(300.0, 372.0, 118.0, 56.0);
uniform vec2 creek[5];
uniform vec4 paths[48]; // segments: from.xy, to.xy
uniform float path_widths[48];
uniform int path_count = 0;
uniform float wash_x = 1900.0; // the dry riverbed across the steppe
uniform vec4 ice_ponds[3];

const float DENSITY = 2.0; // HD pixel art: two painted pixels per world pixel
const float BAYER[16] = { 0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0 };
const vec3 COLORS[86] = {
	vec3(0.0941, 0.1490, 0.1098),
	vec3(0.1176, 0.1843, 0.1333),
	vec3(0.1451, 0.2235, 0.1569),
	vec3(0.1765, 0.2667, 0.1882),
	vec3(0.2118, 0.3176, 0.2196),
	vec3(0.2588, 0.3725, 0.2510),
	vec3(0.3059, 0.4275, 0.2824),
	vec3(0.1373, 0.1216, 0.1020),
	vec3(0.1686, 0.1490, 0.1216),
	vec3(0.2039, 0.1765, 0.1451),
	vec3(0.2392, 0.2078, 0.1686),
	vec3(0.2784, 0.2431, 0.2000),
	vec3(0.0824, 0.0902, 0.1059),
	vec3(0.1137, 0.1255, 0.1451),
	vec3(0.1490, 0.1647, 0.1882),
	vec3(0.1882, 0.2078, 0.2392),
	vec3(0.2314, 0.2549, 0.2902),
	vec3(0.2824, 0.3137, 0.3529),
	vec3(0.1725, 0.2706, 0.1529),
	vec3(0.2275, 0.3529, 0.1922),
	vec3(0.2941, 0.4392, 0.2510),
	vec3(0.3686, 0.5373, 0.3137),
	vec3(0.1725, 0.1647, 0.1137),
	vec3(0.2118, 0.2000, 0.1216),
	vec3(0.2549, 0.2353, 0.1412),
	vec3(0.2980, 0.2745, 0.1608),
	vec3(0.3451, 0.3137, 0.1843),
	vec3(0.3882, 0.3529, 0.2039),
	vec3(0.4314, 0.3922, 0.2314),
	vec3(0.2039, 0.1686, 0.1294),
	vec3(0.2431, 0.2039, 0.1529),
	vec3(0.2902, 0.2431, 0.1804),
	vec3(0.3333, 0.2824, 0.2039),
	vec3(0.2471, 0.2196, 0.1686),
	vec3(0.2941, 0.2627, 0.2000),
	vec3(0.3451, 0.3098, 0.2353),
	vec3(0.3961, 0.3569, 0.2706),
	vec3(0.1098, 0.0980, 0.0784),
	vec3(0.1451, 0.1255, 0.0980),
	vec3(0.1843, 0.1569, 0.1216),
	vec3(0.0902, 0.1529, 0.1216),
	vec3(0.1137, 0.1922, 0.1490),
	vec3(0.1412, 0.2353, 0.1765),
	vec3(0.1725, 0.2824, 0.2039),
	vec3(0.2078, 0.3333, 0.2353),
	vec3(0.2510, 0.3922, 0.2706),
	vec3(0.0745, 0.0745, 0.0353),
	vec3(0.0980, 0.0980, 0.0549),
	vec3(0.1255, 0.1294, 0.0745),
	vec3(0.1569, 0.1647, 0.0941),
	vec3(0.1922, 0.2039, 0.1176),
	vec3(0.1098, 0.1647, 0.0902),
	vec3(0.1373, 0.2039, 0.1098),
	vec3(0.1686, 0.2471, 0.1333),
	vec3(0.2039, 0.2941, 0.1569),
	vec3(0.2078, 0.1882, 0.1647),
	vec3(0.2627, 0.2353, 0.1961),
	vec3(0.3216, 0.2902, 0.2392),
	vec3(0.3843, 0.3451, 0.2784),
	vec3(0.4471, 0.4039, 0.3216),
	vec3(0.0784, 0.0706, 0.0706),
	vec3(0.1059, 0.0941, 0.0902),
	vec3(0.1333, 0.1176, 0.1098),
	vec3(0.1647, 0.1451, 0.1373),
	vec3(0.2000, 0.1765, 0.1647),
	vec3(0.1686, 0.1608, 0.1608),
	vec3(0.2078, 0.1961, 0.1961),
	vec3(0.2510, 0.2353, 0.2314),
	vec3(0.2941, 0.2745, 0.2706),
	vec3(0.3020, 0.3373, 0.4157),
	vec3(0.3686, 0.4078, 0.4902),
	vec3(0.4471, 0.4902, 0.5725),
	vec3(0.5333, 0.5765, 0.6588),
	vec3(0.6275, 0.6706, 0.7451),
	vec3(0.7373, 0.7765, 0.8392),
	vec3(0.8392, 0.8667, 0.9098),
	vec3(0.1608, 0.1765, 0.1961),
	vec3(0.2039, 0.2235, 0.2471),
	vec3(0.2549, 0.2784, 0.3059),
	vec3(0.3137, 0.3412, 0.3765),
	vec3(0.3843, 0.4157, 0.4510),
	vec3(0.2431, 0.3529, 0.4392),
	vec3(0.3020, 0.4275, 0.5176),
	vec3(0.3725, 0.5098, 0.6000),
	vec3(0.4784, 0.6275, 0.7098),
	vec3(0.6118, 0.7529, 0.8157)
};
const int GROUND = 0;
const int GROUND_N = 7;
const int PATH = 7;
const int PATH_N = 5;
const int CLIFF = 12;
const int CLIFF_N = 6;
const int MOSS = 18;
const int MOSS_N = 4;
const int STEPPE = 22;
const int STEPPE_N = 7;
const int CLAY = 29;
const int CLAY_N = 4;
const int WASH = 33;
const int WASH_N = 4;
const int SHORE = 37;
const int SHORE_N = 3;
const int MEADOW = 40;
const int MEADOW_N = 6;
const int MUD = 46;
const int MUD_N = 5;
const int SMOSS = 51;
const int SMOSS_N = 4;
const int SAND = 55;
const int SAND_N = 5;
const int BASALT = 60;
const int BASALT_N = 5;
const int ASH = 65;
const int ASH_N = 4;
const int SNOW = 69;
const int SNOW_N = 7;
const int ROCKS = 76;
const int ROCKS_N = 5;
const int ICE = 81;
const int ICE_N = 5;

const vec3 RIVER_SHALLOW = vec3(0.09, 0.2, 0.23);
const vec3 RIVER_DEEP = vec3(0.02, 0.05, 0.07);
const vec3 RIVER_GLINT = vec3(0.62, 0.86, 0.9);
const vec3 SWAMP_SHALLOW = vec3(0.09, 0.12, 0.07);
const vec3 SWAMP_DEEP = vec3(0.015, 0.02, 0.012);
const vec3 SWAMP_GLINT = vec3(0.35, 0.45, 0.3);

// a little more contrast than the noise textures have, like the hand-made noise of the other art
float st(float v) {
	return clamp((v - 0.5) * 1.15 + 0.5, 0.0, 1.0);
}

float hash(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

vec3 hex(float r, float g, float b) {
	return vec3(r, g, b) / 255.0;
}

vec3 pick(int start, int count, float v, float b) {
	return COLORS[start + clamp(int(floor(v * float(count) + b)), 0, count - 1)];
}

float seg_dist(vec2 p, vec2 a, vec2 b) {
	vec2 ab = b - a;
	float t = clamp(dot(p - a, ab) / max(dot(ab, ab), 0.0001), 0.0, 1.0);
	return length(p - (a + t * ab));
}

float river_y(float x) {
	return river_a.x + river_a.y * sin(x / river_a.z + river_a.w) + river_b.x * sin(x / river_b.y + river_b.z);
}

float river_half(float x) {
	return 20.0 + 10.0 * clamp((x - borders.x + 100.0) / 200.0, 0.0, 1.0) * clamp((borders.y - 54.0 - x) / 150.0, 0.0, 1.0);
}

float edge(float x) {
	return edge_a.x + edge_a.y * sin(x / edge_a.z + edge_a.w) + edge_b.x * sin(x / edge_b.y + edge_b.z);
}

// Small marks scattered over the ground, at most one per 12x12 cell of fine pixels: 1 = the mark, 2 = its shadow.
int mark(vec2 fp, float density, float seed, int shape) {
	vec2 cell = floor(fp / 12.0);
	if (hash(cell + seed) >= density) {
		return 0;
	}
	vec2 anchor = cell * 12.0 + floor(vec2(hash(cell + seed + 1.7), hash(cell + seed + 4.3)) * 6.0) + 3.0;
	vec2 o = fp - anchor;
	float h = hash(cell + seed + 9.1);
	if (shape == 0) { // tuft of grass: a stem and two blades
		if (o.x == 0.0 && o.y <= 0.0 && o.y >= -3.0) {
			return 1;
		}
		if (h < 0.6 && (o == vec2(-1.0, -2.0) || o == vec2(-2.0, -3.0))) {
			return 1;
		}
		if (h > 0.25 && (o == vec2(1.0, -1.0) || o == vec2(2.0, -2.0))) {
			return 1;
		}
		return (o.y == 1.0 && abs(o.x) <= 1.0) ? 2 : 0;
	} else if (shape == 1) { // pebble
		if ((o.y == 0.0 && o.x >= 0.0 && o.x <= 1.0) || (h < 0.5 && o == vec2(0.0, -1.0))) {
			return 1;
		}
		return (o.y == 1.0 && o.x >= 0.0 && o.x <= 1.0) ? 2 : 0;
	} else if (shape == 2) { // leaf
		float side = h < 0.5 ? 1.0 : -1.0;
		return (o == vec2(0.0, 0.0) || o == vec2(1.0, 0.0) || o == vec2(1.0, side) || o == vec2(2.0, side)) ? 1 : 0;
	} else if (shape == 3) { // twig
		return (o.x >= -2.0 && o.x < 3.0 + floor(h * 3.0) && o.y == floor(o.x * (h - 0.5) * 0.8)) ? 1 : 0;
	} else if (shape == 4) { // stone
		if (o.y >= -1.0 && o.y <= 0.0 && o.x >= 0.0 && o.x <= 2.0 && !(o.y == -1.0 && (o.x == 0.0 || o.x == 2.0))) {
			return 1;
		}
		return (o.y == 1.0 && o.x >= 0.0 && o.x <= 2.0) ? 2 : 0;
	}
	return (o == vec2(0.0, 0.0) || (h < 0.3 && o == vec2(1.0, 0.0)) || (h > 0.8 && o == vec2(0.0, -1.0))) ? 1 : 0; // glint of snow
}

vec3 three(vec3 a, vec3 b, vec3 c, vec2 fp, float seed) {
	float h = hash(floor(fp / 12.0) + seed + 5.5);
	return h < 0.34 ? a : (h < 0.67 ? b : c);
}

vec3 water(vec2 px, vec2 fp, float depth, vec3 shallow, vec3 deep, vec3 glint) {
	vec3 col = mix(shallow, deep, depth);
	float wave = sin(px.y * 0.9 + sin(px.x * 0.13 + TIME * 0.8) * 2.5 - TIME * 1.2);
	float h = hash(floor(fp / vec2(8.0, 1.0)));
	float glints = step(0.25, sin(px.x * 0.045 + TIME * 0.25) * sin(px.y * 0.11 - TIME * 0.18));
	col = mix(col, glint, step(0.97, wave) * step(0.5, h) * glints * (1.0 - depth * 0.5));
	return mix(col, shallow * 1.5, step(depth, 0.06) * 0.6);
}

void fragment() {
	vec2 fine = floor(UV * world_size * DENSITY);
	vec2 px = (fine + 0.5) / DENSITY - 0.5; // world position of this fine pixel
	float x = px.x;
	float y = px.y;
	float b = BAYER[int(mod(fine.y, 4.0)) * 4 + int(mod(fine.x, 4.0))] / 16.0 - 0.47;
	float n = st(texture(noise_big, px / 1024.0).r);
	float n2 = st(texture(noise_fine, px / 256.0).r);
	float n3 = st(texture(noise_fine, px / 96.0 + 0.37).r);
	float n4 = st(texture(noise_big, px / 700.0 + 0.61).r);
	float vn = st(texture(noise_big, px / 1400.0 + 0.23).r);
	float west = borders.x;

	// the cliff: plateau above, rock face in between, the low valley below
	float cliff_end = edge_b.w;
	float top_y = edge(x);
	float foot_y = top_y + (68.0 + 3.0 * sin(x / 29.0 + 2.0)) * clamp((cliff_end - x) / 90.0, 0.0, 1.0);
	bool plateau = y < top_y && x < cliff_end;
	bool band = y >= top_y && y < foot_y;
	bool ramp_x = x >= ramp.x && x < ramp.y;
	bool face = band && !ramp_x;
	bool low = y >= foot_y || x >= cliff_end;
	float pd = length((px - pond.xy) / pond.zw) + 0.14 * (vn - 0.5);

	// jungle floor
	float g = 0.2 + 0.38 * n + 0.42 * (n2 - 0.5) + 0.18 * (n3 - 0.5) + (plateau ? 0.1 : 0.0);
	vec3 col = pick(GROUND, GROUND_N, g, b);
	// steppe: dry grass, cracked clay, a dry riverbed
	float steppe_w = clamp((x + 70.0 * (vn - 0.5) - west + 60.0) / 160.0, 0.0, 1.0);
	bool steppe = b + 0.47 < steppe_w;
	bool clay = false;
	bool wash = false;
	if (steppe) {
		col = pick(STEPPE, STEPPE_N, 0.22 + 0.42 * n + 0.38 * (n2 - 0.5) + 0.15 * (n3 - 0.5), b);
		clay = n4 > 0.6;
		if (clay) {
			col = pick(CLAY, CLAY_N, 0.3 + 0.5 * n2, b);
			if (abs(texture(noise_fine, px / 160.0 + 0.71).r - 0.5) < 0.025) {
				col = hex(34.0, 28.0, 22.0);
			}
		}
		float wx = wash_x + 60.0 * sin(y / 110.0) + 25.0 * sin(y / 37.0);
		wash = abs(x - wx) < 16.0 + 6.0 * n2 && y > 300.0;
		if (wash) {
			col = pick(WASH, WASH_N, 0.3 + 0.55 * n3, b);
		}
	}

	// the regions beyond the valley
	float ry = river_y(x);
	float rh = river_half(x);
	float rd = abs(y - ry) - rh;
	float jit = 36.0 * (st(texture(noise_big, px / 1100.0 + 0.47).r) - 0.5);
	bool east_r = x + jit >= borders.y;
	bool volc = east_r && y + jit < borders.z;
	bool snowr = east_r && !volc;
	bool south = y > ry && !east_r;
	bool swamp = south && x + jit < west && rd > 12.0;
	bool delta = south && !swamp && rd > 12.0;
	bool banks = !east_r && rd >= -2.0 && rd < 10.0 + 6.0 * n2;
	bool ford = (abs(x - fords.x) < 26.0 + 4.0 * n3 || abs(x - fords.y) < 26.0 + 4.0 * n3) && rd < 12.0;
	bool wild = south || east_r || rd < 16.0;
	if (delta) {
		col = pick(MEADOW, MEADOW_N, 0.25 + 0.4 * n + 0.35 * (n2 - 0.5), b);
	}
	if (swamp) {
		col = pick(MUD, MUD_N, 0.32 + 0.45 * n + 0.35 * (n2 - 0.5), b);
		if (n4 + 0.25 * (n3 - 0.5) > 0.56) {
			col = pick(SMOSS, SMOSS_N, 0.3 + 0.5 * (n2 - 0.5), b);
		}
	}
	if (banks || ford) {
		col = pick(SAND, SAND_N, 0.3 + 0.5 * n2 + 0.2 * (n3 - 0.5), b);
	}
	if (volc) {
		col = pick(BASALT, BASALT_N, 0.25 + 0.5 * n2 + 0.2 * (n3 - 0.5), b);
		if (n4 > 0.58) {
			col = pick(ASH, ASH_N, 0.2 + 0.6 * n3, b);
		}
		if (abs(texture(noise_fine, px / 200.0 + 0.13).r - 0.5) < 0.018) {
			col = hex(10.0, 8.0, 8.0);
		}
		if (abs(texture(noise_fine, px / 300.0 + 0.53).r - 0.5) < 0.007 && n2 > 0.55) {
			col = hex(168.0, 56.0, 14.0);
		}
	}
	if (!east_r && x + jit > borders.y - 30.0 && y < borders.z && hash(fine) < 0.5) {
		col = COLORS[BASALT + 3];
	}
	bool icy = false;
	if (snowr) {
		col = pick(SNOW, SNOW_N, 0.45 + 0.4 * n + 0.3 * (n2 - 0.5) + 0.1 * (n3 - 0.5), b);
		if (n4 + 0.3 * (n3 - 0.5) > 0.74) {
			col = pick(ROCKS, ROCKS_N, 0.2 + 0.6 * n2, b);
		}
		icy = rd < 0.0;
		for (int i = 0; i < 3; i++) {
			icy = icy || length((px - ice_ponds[i].xy) / max(ice_ponds[i].zw, vec2(1.0))) + 0.15 * (n3 - 0.5) < 1.0;
		}
		if (icy) {
			col = pick(ICE, ICE_N, 0.3 + 0.5 * n2 + 0.3 * clamp(-rd / 30.0, 0.0, 1.0), b);
			if (abs(texture(noise_fine, px / 170.0 + 0.29).r - 0.5) < 0.02) {
				col = hex(200.0, 224.0, 236.0);
			}
		}
	}
	if (east_r && abs(y + jit - borders.z) < 16.0 + 8.0 * n2) {
		col = pick(ROCKS, ROCKS_N, 0.3 + 0.5 * n3, b);
	}

	// trodden paths
	float d = 1e9;
	float width = 10.0;
	for (int i = 0; i < path_count; i++) {
		float di = seg_dist(px, paths[i].xy, paths[i].zw) - path_widths[i];
		if (di < d) {
			d = di;
		}
	}
	width += 5.0 * vn;
	bool path = d < width && !face && rd > 8.0;
	if (path) {
		col = pick(PATH, PATH_N, 0.25 + 0.5 * n2 + 0.25 * (n - 0.5), b);
	} else if (d < width + 3.0 && !face && rd > 8.0 && hash(fine + 3.1) < 0.45) {
		col = COLORS[PATH];
	}
	// the ramp up the cliff, the rock face with ledges, cracks, moss and vines
	float t = clamp((y - top_y) / max(foot_y - top_y, 1.0), 0.0, 1.0);
	if (band && ramp_x) {
		col = pick(PATH, PATH_N, 0.45 + 0.35 * n2 - 0.3 * t, b);
	}
	bool side = ramp_x && band && (x < ramp.x + 18.0 || x >= ramp.y - 18.0);
	if (face || side) {
		float streak = texture(noise_fine, vec2(px.x / 40.0, px.y / 240.0) + 0.19).r;
		float cv = 0.72 - 0.42 * t + 0.35 * (streak - 0.5);
		float ledge = mod(y + 5.0 * sin(x / 23.0) + 3.0 * sin(x / 7.0), 15.0);
		cv += ledge < 0.5 ? 0.16 : (ledge < 2.0 ? -0.12 : 0.0);
		float column = x + 9.0 * sin(x * 0.037);
		float relx = fract(column / 19.0);
		cv += 0.2 * (0.5 - relx);
		if (relx < 0.06 && texture(noise_fine, vec2(px.x / 200.0, px.y / 50.0) + 0.83).r > 0.55) {
			cv -= 0.4;
		}
		col = pick(CLIFF, CLIFF_N, cv, b);
		float depth = y - top_y;
		float lip = 2.0 + floor(hash(vec2(x, 7.0)) * 4.0);
		float vine = hash(vec2(x, 13.0)) < 0.07 ? 8.0 + floor(hash(vec2(x, 29.0)) * 22.0) : 0.0;
		if (face && depth < lip) {
			col = pick(MOSS, MOSS_N, 0.3 + 0.6 * n2, b);
		} else if (face && depth < vine) {
			col = COLORS[MOSS];
		}
	}
	if (y >= top_y - 0.5 && y < top_y && !ramp_x && x < cliff_end) {
		col = COLORS[MOSS + 3];
	}
	// shade at the foot of the cliff, the pond's muddy shore
	float below = y - foot_y;
	bool ao = low && below >= 0.0 && below < 16.0 && x < cliff_end && !steppe;
	if (ao && !path) {
		col = pick(GROUND, GROUND_N, g - 0.28 * (1.0 - below / 16.0), b);
	}
	if (pd >= 0.96 && pd < 1.04 + 0.06 * n2 && !face) {
		col = pick(SHORE, SHORE_N, 0.2 + 0.6 * n2, b);
	}

	// scattered details
	bool grassy = (low || plateau) && !path && pd > 1.15 && !ao && !steppe && !wild;
	bool dry = steppe && !path && !clay && !wash && !wild;
	int m;
	if (dry) {
		m = mark(fine, 0.1, 11.0, 0);
		col = m == 1 ? three(hex(122.0, 109.0, 64.0), hex(138.0, 122.0, 72.0), hex(106.0, 94.0, 56.0), fine, 11.0) : (m == 2 ? hex(34.0, 31.0, 21.0) : col);
	}
	if ((wash || clay) && steppe && !wild) {
		m = mark(fine, 0.12, 23.0, 1);
		col = m == 1 ? three(hex(122.0, 110.0, 90.0), hex(106.0, 96.0, 78.0), hex(138.0, 126.0, 104.0), fine, 23.0) : (m == 2 ? hex(34.0, 28.0, 22.0) : col);
	}
	if (grassy) {
		m = mark(fine, 0.075, 37.0, 0);
		col = m == 1 ? three(hex(79.0, 116.0, 69.0), hex(93.0, 132.0, 80.0), hex(63.0, 96.0, 57.0), fine, 37.0) : (m == 2 ? hex(22.0, 34.0, 26.0) : col);
		if (mark(fine, 0.004, 41.0, 1) == 1) {
			col = three(hex(138.0, 134.0, 168.0), hex(163.0, 144.0, 112.0), hex(138.0, 134.0, 168.0), fine, 41.0);
		}
	}
	if ((low || plateau || path) && pd > 1.1 && !steppe && !wild && !face && mark(fine, 0.025, 53.0, 2) == 1) {
		col = three(hex(90.0, 61.0, 36.0), hex(107.0, 74.0, 44.0), hex(122.0, 58.0, 42.0), fine, 53.0);
	}
	if (path) {
		m = mark(fine, 0.15, 67.0, 1);
		col = m == 1 ? three(hex(110.0, 98.0, 82.0), hex(93.0, 82.0, 68.0), hex(110.0, 98.0, 82.0), fine, 67.0) : (m == 2 ? hex(31.0, 26.0, 20.0) : col);
	}
	if (delta && !path) {
		m = mark(fine, 0.2, 71.0, 0);
		col = m == 1 ? three(hex(79.0, 116.0, 69.0), hex(93.0, 132.0, 80.0), hex(63.0, 96.0, 57.0), fine, 71.0) : (m == 2 ? hex(16.0, 26.0, 20.0) : col);
	}
	if (swamp && mark(fine, 0.06, 79.0, 3) == 1) {
		col = three(hex(46.0, 38.0, 24.0), hex(58.0, 47.0, 30.0), hex(36.0, 29.0, 18.0), fine, 79.0);
	}
	if (banks || ford) {
		m = mark(fine, 0.36, 83.0, 4);
		col = m == 1 ? three(hex(138.0, 130.0, 114.0), hex(110.0, 103.0, 90.0), hex(154.0, 146.0, 130.0), fine, 83.0) : (m == 2 ? hex(28.0, 26.0, 22.0) : col);
	}
	if (volc && !path) {
		m = mark(fine, 0.05, 89.0, 1);
		col = m == 1 ? three(hex(90.0, 82.0, 80.0), hex(106.0, 58.0, 36.0), hex(58.0, 52.0, 50.0), fine, 89.0) : (m == 2 ? hex(12.0, 10.0, 10.0) : col);
	}
	if (snowr && !icy && !path && mark(fine, 0.08, 97.0, 5) == 1) {
		col = three(hex(232.0, 238.0, 246.0), hex(176.0, 188.0, 204.0), hex(86.0, 96.0, 110.0), fine, 97.0);
	}

	// water: the river (shallow and patchy at the fords), dark pools in the swamp, the creek on the plateau
	if (rd < 0.0 && !snowr) {
		float depth = pow(clamp(-rd / rh, 0.0, 1.0), 0.6);
		bool gravel = ford && b + 0.47 < 0.45 + 0.3 * (n3 - 0.5);
		if (!gravel) {
			col = water(px, fine, ford ? depth * 0.08 : depth, RIVER_SHALLOW, RIVER_DEEP, RIVER_GLINT);
		}
	}
	float pools = st(texture(noise_big, px / 600.0 + 0.9).r) - 0.04;
	if (swamp && pools > 0.6) {
		col = water(px, fine, pow(clamp((pools - 0.6) / 0.15, 0.0, 1.0), 0.7), SWAMP_SHALLOW, SWAMP_DEEP, SWAMP_GLINT);
	}
	if (plateau) {
		float cd = 1e9;
		for (int i = 0; i < 4; i++) {
			cd = min(cd, seg_dist(px, creek[i], creek[i + 1]));
		}
		float cw = 6.0 + 2.0 * vn;
		if (cd < cw) {
			col = water(px, fine, pow(1.0 - cd / cw, 0.7), RIVER_SHALLOW, RIVER_DEEP, RIVER_GLINT);
		}
	}
	COLOR = vec4(col, 1.0);
}
