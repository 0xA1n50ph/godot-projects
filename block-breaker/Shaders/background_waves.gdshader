shader_type canvas_item;

uniform int emitter_count = 4;
uniform vec2 emitters[6];
uniform float frequencies[6];
uniform float speeds[6];
uniform float amplitudes[6];
uniform float phase_offsets[6];
uniform vec4 color_deep : source_color = vec4(0.02, 0.02, 0.12, 1.0);
uniform vec4 color_mid : source_color = vec4(0.05, 0.15, 0.35, 1.0);
uniform vec4 color_bright : source_color = vec4(0.15, 0.45, 0.65, 1.0);
uniform float aspect_ratio = 1.778;

void fragment() {
	vec2 uv = UV;
	uv.x *= aspect_ratio;

	float wave_sum = 0.0;
	float max_amp = 0.0;

	for (int i = 0; i < emitter_count; i++) {
		vec2 ep = vec2(emitters[i].x * aspect_ratio, emitters[i].y);
		float dist = distance(uv, ep);
		wave_sum += amplitudes[i] * sin(dist * frequencies[i] - TIME * speeds[i] + phase_offsets[i]);
		max_amp += amplitudes[i];
	}

	float normalized;
	if (max_amp > 0.0) {
		normalized = (wave_sum / max_amp) * 0.5 + 0.5;
	} else {
		normalized = 0.5;
	}
	normalized = clamp(normalized, 0.0, 1.0);

	vec4 color;
	if (normalized < 0.5) {
		color = mix(color_deep, color_mid, normalized * 2.0);
	} else {
		color = mix(color_mid, color_bright, (normalized - 0.5) * 2.0);
	}

	COLOR = color;
}
