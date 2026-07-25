shader_type canvas_item;

uniform float r: hint_range(0.0, 1.0) = 1.0;
uniform float g: hint_range(0.0, 1.0) = 1.0;
uniform float b: hint_range(0.0, 1.0) = 1.0;
uniform float a: hint_range(0.0, 1.0) = 1.0;

void vertex() {
	COLOR = vec4(r,g,b,a);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
