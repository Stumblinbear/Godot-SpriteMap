shader_type canvas_item;

uniform sampler2D tiles;
uniform int spriteSize;

uniform sampler2D cells;
uniform int tileSize;

void fragment() {
	vec2 spriteMapSize = vec2(textureSize(tiles, 0));
	float spriteSizeF = 1.0 / (spriteMapSize.x / float(spriteSize));
	
	float i = float(int(texture(cells, UV).r * 255.0));
	vec2 spriteX = vec2(i * spriteSizeF, 0.0);
	
	vec2 tileMapSize = vec2(textureSize(cells, 0));
	float tileSizeF = 1.0 / (tileMapSize.x / float(tileSize));
	vec2 tileUV = (UV * tileMapSize - floor(UV * tileMapSize));
	
	COLOR = texture(tiles, spriteX + vec2(tileUV.x / tileSizeF, tileUV.y));
}