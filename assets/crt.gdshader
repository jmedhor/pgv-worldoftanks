shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

uniform float curvature : hint_range(0.0, 1.0) = 0.1;
uniform float scanline_count : hint_range(0.0, 1000.0) = 300.0;
uniform float aberration : hint_range(0.0, 0.1) = 0.002;

// Función para curvar las coordenadas UV
vec2 curve(vec2 uv) {
    uv = (uv - 0.5) * 2.0;
    uv *= 1.1; // Pequeño margen para no ver los bordes cortados
    uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
    uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
    uv = (uv / 2.0) + 0.5;
    return uv;
}

void fragment() {
    vec2 uv = curve(SCREEN_UV);

    // 1. Aberración Cromática (separamos canales RGB)
    float r = texture(screen_texture, uv + vec2(aberration, 0.0)).r;
    float g = texture(screen_texture, uv).g;
    float b = texture(screen_texture, uv - vec2(aberration, 0.0)).b;

    vec3 color = vec3(r, g, b);

    // 2. Scanlines (líneas horizontales oscuras)
    float s = sin(uv.y * scanline_count);
    color *= 1.0 + s * 0.1;

    // 3. Viñeta (bordes oscuros)
    float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    vignette = clamp(pow(vignette * 15.0, 0.5), 0.0, 1.0);
    color *= vignette;

    // 4. Recorte de bordes negros (fuera de la curvatura)
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        color = vec3(0.0);
    }

    COLOR = vec4(color, 1.0);
}