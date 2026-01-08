shader_type spatial;

uniform vec4 color_parpadeo : source_color = vec4(1.0, 0.3, 0.3, 1.0); // Rosa fuerte
uniform float velocidad : hint_range(0.0, 30.0) = 5.0;
uniform float intensidad : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Creamos una onda cuadrada basada en el tiempo para el parpadeo
    // Si quieres que sea suave, usa sin(TIME * velocidad)
    float onda = (sin(TIME * velocidad) * 0.5) + 0.5;
    
    // Mezclamos el rosa con la opacidad definida
    ALBEDO = color_parpadeo.rgb;
    // Aplicamos el parpadeo a la transparencia o a la fuerza del color
    ALPHA = onda * intensidad;
}