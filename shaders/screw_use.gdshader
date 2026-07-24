shader_type canvas_item;

uniform bool loose = false;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
	if(loose){
		VERTEX += vec2((rand(vec2(45,1) * TIME) * 2.0 - 1.0) * 10.0, (rand(vec2(1,45) * TIME) * 2.0 - 1.0) * 10.0);
	}
}