shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Black outline

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE;
	vec4 tex_color = texture(TEXTURE, UV);
	
	// If the current pixel is transparent, check neighbors for an outline
	if (tex_color.a == 0.0) {
		float up = texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
		float down = texture(TEXTURE, UV + vec2(0.0, size.y)).a;
		float left = texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
		float right = texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
		
		if (up > 0.0 || down > 0.0 || left > 0.0 || right > 0.0) {
			COLOR = outline_color; // Draws the outline
		} else {
			discard; // Keeps the rest transparent
		}
	} else {
		COLOR = tex_color; // Keeps your original texture visible
	}
}