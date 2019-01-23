extends Sprite

class_name SpriteMap

const SHADER = preload("./tilemap.shader")

var _tile_set : SpriteSet
var tile_set : SpriteSet setget set_tileset, get_tileset

# Currently, tile_size must equal the size of tiles in the TileSet. This may be fixed in the future.
export (int) var tile_size : int = 32

export (int) var width : int = 16
export (int) var height : int = 16

# If Godot ever adds support for passing float or int arrays to shaders, then this can be refactored out
var cells_changed : = true
var cells : Image
var cells_tex : ImageTexture

func _ready():
	self.texture = ImageTexture.new()
	self.texture.create(self.width * self.tile_size, self.height * self.tile_size, Image.FORMAT_RGBA8)

	self.cells = Image.new()
	self.cells.create(self.width, self.height, false, Image.FORMAT_R8)
	self.cells.fill(Color(0, 0, 0))
	
	self.cells_tex = ImageTexture.new()
	self.cells_tex.create_from_image(self.cells)
	self.cells_tex.flags = 0

	self.material = ShaderMaterial.new()
	self.material.shader = SHADER
	
	self.material.set_shader_param("cells", self.cells_tex)
	self.material.set_shader_param("spriteSize", self.tile_size)
	self.material.set_shader_param("tileSize", self.tile_size)

func _process(delta):
	if self.cells_changed:
		self.cells_changed = false

		self.cells_tex.set_data(self.cells)

func set_tileset(ts: SpriteSet):
	if ts.texture == null:
		printerr("SpriteSet has not been finalized, yet!")
		return

	self._tile_set = ts

	self.material.set_shader_param("tiles", ts.texture)
	self.material.set_shader_param("spriteSize", ts.tile_size)

func get_tileset():
	return self._tile_set

# If Godot ever adds support for passing float or int arrays to shaders, then this can be refactored to be much cleaner
func set_cell(x: int, y: int, i: int):
	self.cells_changed = true

	self.cells.lock()

	# Store the tile ID in the red channel
	self.cells.set_pixel(x, y, Color(i / 255.0, 0, 0))

	self.cells.unlock()
