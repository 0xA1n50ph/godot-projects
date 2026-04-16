shader_type spatial;
render_mode specular_toon;
uniform sampler2D noise;
uniform sampler2D normalmap;
uniform float height_scale = 10.0;
varying vec2 texture_vertex;

float wave(vec2 position){
  position += texture(noise, position / height_scale).x * 2.0 - 1.0;
  vec2 wave_pos = 1.0 - abs(sin(position));
  return pow(1.0 - pow(wave_pos.x * wave_pos.y, 0.65), 6.0);
}

float height_calc(vec2 position, float time){
  //vec2 offset = 0.01 * cos(position + time);
  //return texture(noise, (position / height_scale) - offset).x;
  float waves = wave((position + (time * 0.2)) * 0.4) * 0.3;
  waves += wave((position - (time * 0.2)) * 0.3) * 0.3;
  waves += wave((position + (time * 0.2)) * 0.5) * 0.2;
  waves += wave((position - (time * 0.2)) * 0.6) * 0.2;
  return waves;
}

void vertex() {
	// Called for every vertex the material is visible on.
  //VERTEX.y += cos(VERTEX.z * 4.0) * sin(VERTEX.x * 4.0);
  texture_vertex = VERTEX.xz;
  float height = height_calc(texture_vertex, TIME);
  NORMAL = normalize(vec3(height - height_calc(texture_vertex + vec2(0.1,0.0), TIME),0.1, height - height_calc(texture_vertex + vec2(0.0, 0.1), TIME)));
  VERTEX.y = height;
  //VERTEX.y += random_noise * height_scale;

}

void fragment() {
	// Called for every pixel the material is visible on.
  float fresnel_reflect = sqrt(1.0 - dot(NORMAL, VIEW));
  RIM = 0.2;
  //AO = 0.2;
  METALLIC = 0.0;
  ROUGHNESS = 0.01 * (1.0 - fresnel_reflect);
  NORMAL_MAP = texture(normalmap, texture_vertex).xyz;
  ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel_reflect);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
