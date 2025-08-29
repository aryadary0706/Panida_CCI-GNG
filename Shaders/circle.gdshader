shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.49;
uniform float outline_thickness : hint_range(0.0, 0.2) = 0.008;
uniform float inside_alpha : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));

    // Isi lingkaran -> putih dengan alpha 0.2
    if (dist <= radius) {
        COLOR.a = inside_alpha;
    }
    // Outline -> putih dengan alpha 1
    else if (dist > radius && dist <= radius + outline_thickness) {

    }
    // Di luar -> transparan penuh
    else {
        COLOR.a = 0.0;
    }
}
