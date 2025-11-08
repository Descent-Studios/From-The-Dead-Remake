shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform bool enabled = true;

uniform float percentage: hint_range(0.0, 1.0) = 0;
uniform vec3 RgbValueOfTint = vec3(1.0, 1.0, 0.0);


void fragment() {
	// Called for every pixel the material is visible on.
	if(enabled){
		vec4 color_silhouette = vec4(RgbValueOfTint, COLOR.a);
		COLOR = mix(COLOR, color_silhouette, percentage); // lerp(1, 2, percentage)
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
