shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0, 5) = 1;

void fragment() {
    vec2 pixel_size = outline_width / TEXTURE_PIXEL_SIZE;
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (tex_color.a < 0.5) {
        // Cek 4 arah utama (lebih efisien)
        float alpha = 0.0;
        alpha = max(alpha, texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a);
        alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a);
        
        if (alpha > 0.5) {
            COLOR = outline_color;
        } else {
            discard;
        }
    } else {
        COLOR = tex_color;
    }
}