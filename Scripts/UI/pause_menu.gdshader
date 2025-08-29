shader_type canvas_item;

uniform float opacity : hint_range(0.0, 1.0) = 0.25; // tingkat transparansi

void fragment() {
    // warna hitam dengan alpha sesuai uniform
    COLOR = vec4(0.0, 0.0, 0.0, opacity);
}
