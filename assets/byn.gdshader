shader_type canvas_item;

// Captura lo que hay detrás del ColorRect
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

void fragment() {
    // Obtenemos el color de la pantalla en esa posición
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    // Calculamos la luminosidad (Fórmula estándar de escala de grises)
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Aplicamos el resultado
    COLOR = vec4(vec3(gray), color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
