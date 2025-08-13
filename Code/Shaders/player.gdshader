shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 color_picker : source_color;
uniform float flastState : hint_range(0,1) = 0.5;

	//vec4 pixelcolor = texture(TEXTURE, UV);
	//float brightness = (pixelcolor.r + pixelcolor.g + pixelcolor.b + pixelcolor.a) / 3.0;
	//vec4 grayscale = vec4(brightness, brightness, brightness, pixelcolor.a);
	//COLOR = mix(pixelcolor, color_picker, flastState);
	//COLOR.rgb = COLOR.ggg;

//void vertex() {
//
//}
void fragment() {
	vec4 pixelcolor = texture(TEXTURE, UV);
	float brightness = (pixelcolor.r + pixelcolor.g + pixelcolor.b + pixelcolor.a) / 3.0;
	COLOR = mix(pixelcolor, color_picker, flastState);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
