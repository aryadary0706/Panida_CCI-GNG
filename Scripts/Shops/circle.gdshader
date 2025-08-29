shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.48;   // radius lingkaran
uniform float outline_thickness : hint_range(0.0, 0.2) = 0.008; // tebal outline
uniform float inside_alpha : hint_range(0.0, 1.0) = 0.2; // transparansi dalam

void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));

    // dalam lingkaran → alpha 0.1
    if (dist <= radius) {
        COLOR.a = inside_alpha;
    }
    // outline → alpha 1
    else if (dist > radius && dist <= radius + outline_thickness) {
        COLOR.a = 1.0;
    }
    // luar → transparan
    else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
