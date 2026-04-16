shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 fog_color : source_color = vec3(0.6, 0.65, 0.7);
uniform float density = 0.8;
uniform float speed = 0.02;
uniform vec2 scale = vec2(5.0, 5.0);

// Noise simplex 2D
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                       -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
                    + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void fragment() {
    vec2 uv = UV * scale;
    float time = TIME * speed;

    // Múltiplas camadas de noise para efeito volumétrico
    float noise1 = snoise(uv + vec2(time, time * 0.5)) * 0.5 + 0.5;
    float noise2 = snoise(uv * 2.0 - vec2(time * 0.7, time * 0.3)) * 0.5 + 0.5;
    float noise3 = snoise(uv * 4.0 + vec2(time * 0.5, -time * 0.8)) * 0.5 + 0.5;

    float combined_noise = (noise1 * 0.5 + noise2 * 0.3 + noise3 * 0.2);
    float alpha = combined_noise * density;

    ALBEDO = fog_color;
    ALPHA = alpha;
}