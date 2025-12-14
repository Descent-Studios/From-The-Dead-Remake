shader_type spatial;

uniform sampler2D albedo_texture : source_color, filter_nearest;

instance uniform vec3 color = vec3(1.0,1.0,1.0);
instance uniform float percentage: hint_range(0.0, 1.0) = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 curColor = texture(albedo_texture,UV);
	vec3 colorMix = mix(curColor.rgb, color, percentage);
	ALBEDO = colorMix;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
