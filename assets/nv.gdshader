shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
// Ajusta estos valores desde el Inspector para calibrar tu escena
uniform float brightness : hint_range(0.0, 1.0) = 0.15; 
uniform float contrast : hint_range(0.0, 4.0) = 2.5;
uniform float noise_amount : hint_range(0.0, 1.0) = 0.1;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec4 scene_color = texture(screen_texture, SCREEN_UV);
    
    // 1. Luminosidad básica
    float gray = dot(scene_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // 2. AUMENTO DE CONTRASTE Y BRILLO (Nueva fórmula)
    // Primero aplicamos el brillo
    gray += brightness;
    // Luego aplicamos el contraste centrado en 0.5
    gray = (gray - 0.5) * contrast + 0.5;
    
    // 3. Limitar los valores para que no "quemen" la imagen
    gray = clamp(gray, 0.0, 1.0);
    
    // 4. Color verde "Matrix/CCTV"
    // El verde es el canal predominante, los otros casi a cero
    vec3 green_color = vec3(gray * 0.05, gray * 1.0, gray * 0.05);
    
    // 5. Ruido y Scanlines
    float noise = (rand(SCREEN_UV + TIME) - 0.5) * noise_amount;
    float scanline = sin(SCREEN_UV.y * 600.0) * 0.03;
    
    green_color += noise - scanline;

    COLOR = vec4(green_color, 1.0);
}