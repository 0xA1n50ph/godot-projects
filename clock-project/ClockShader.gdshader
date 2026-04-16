shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float radius = 2.0 * length(UV - vec2(0.5));
	float mixer = smoothstep(0.5, 0.6, radius);
	COLOR = vec4(1.0);
	COLOR.rgb = mix(COLOR.rgb, vec3(0.0, 0.5, 0.0), mixer);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
