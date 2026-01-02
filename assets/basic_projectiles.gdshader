shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

uniform vec3 inner_color : source_color = vec3(0.3, 0.7, 1.0);
uniform vec3 outer_color : source_color = vec3(0.0, 0.2, 1.0);
uniform float glow_strength : hint_range(0.0, 10.0) = 4.0;

uniform float noise_scale = 3.0;
uniform float energy_speed = 1.0;
uniform float pulse_strength = 0.4;

float hash(vec3 p){
    return fract(sin(dot(p, vec3(12.9898, 78.233, 37.719))) * 43758.5453);
}

float noise(vec3 p){
    vec3 i = floor(p);
    vec3 f = fract(p);

    float n000 = hash(i + vec3(0,0,0));
    float n100 = hash(i + vec3(1,0,0));
    float n010 = hash(i + vec3(0,1,0));
    float n110 = hash(i + vec3(1,1,0));
    float n001 = hash(i + vec3(0,0,1));
    float n101 = hash(i + vec3(1,0,1));
    float n011 = hash(i + vec3(0,1,1));
    float n111 = hash(i + vec3(1,1,1));

    vec3 u = f*f*(3.0 - 2.0*f);

    return mix(
        mix(mix(n000, n100, u.x),
            mix(n010, n110, u.x), u.y),
        mix(mix(n001, n101, u.x),
            mix(n011, n111, u.x), u.y), u.z);
}

void fragment(){
    vec3 p = NORMAL * noise_scale + vec3(TIME * energy_speed);

    float n = noise(p);

    // pulso
    float pulse = sin(TIME * 4.0) * pulse_strength + 1.0;

    // intensidad del núcleo
    float core = pow(n, 3.0) * pulse;

    // borde de energía (fresnel)
    float rim = pow(1.0 - dot(NORMAL, VIEW), 3.0);

    // color combinado
    vec3 color = mix(inner_color * core, outer_color * rim, 0.5);

    ALBEDO = color;
    EMISSION = color * glow_strength;
}
