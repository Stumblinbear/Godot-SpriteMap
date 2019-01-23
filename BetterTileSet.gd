class_name BetterTileSet

var texture: Texture

var tile_size: int = 32

var last_i = -1
var tiles : = {}
var tile_names : = {}

func _init(tile_size: int):
	self.tile_size = tile_size

func get_last_unused_tile_id():
	last_i += 1
	return last_i

func create_tile(i: int):
	tiles[i] = {
		"texture": null,
		"rect": null
	}

func tile_set_texture(i: int, texture: Texture):
	if not i in tiles:
		printerr(i, " does not exist in TileSet.")
		return

	var tile = tiles[i]
	
	tile.texture = texture

	if tile.rect == null:
		tile.rect = Rect2(0, 0, texture.get_width(), texture.get_height())

func tile_set_region(i: int, rect: Rect2):
	if not i in tiles:
		printerr(i, " does not exist in TileSet.")
		return

	var tile = tiles[i]

	tile.rect = rect

func tile_set_name(i: int, name):
	if not i in tiles:
		printerr(i, " does not exist in TileSet.")
		return

	tile_names[name] = i

func tile_by_name(name) -> int:
	return tile_names[name]

func finalize():
	var img = Image.new()
	img.create((self.last_i + 1) * self.tile_size, self.tile_size, false, Image.FORMAT_RGB8)
	img.fill(Color(0, 0, 0))
	
	img.lock()

	# Stitch the individual textures into one image.
	for i in tiles:
		var tile = tiles[i]
		
		var tex : Image = tile.texture.get_data()
		
		if tile.rect != null:
			tex = tex.get_rect(tile.rect)
			tex.resize(tile.rect.size.x, tile.rect.size.y)
		
		tex.lock()
		
		for x in self.tile_size:
			for y in self.tile_size:
				img.set_pixel(i * self.tile_size + x, y, tex.get_pixel(x, y))
		
		tex.unlock()
	
	img.unlock()

	self.texture = ImageTexture.new()
	self.texture.create_from_image(img)
	self.texture.flags = 0