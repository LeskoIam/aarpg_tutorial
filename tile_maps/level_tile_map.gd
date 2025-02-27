class_name LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())


func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	bounds.append(
		# get_used_rect().position is in tiles! rendering_quadrant_size = 32 set for tileset
		Vector2(get_used_rect().position * rendering_quadrant_size)  # get_used_rect always returns top left corner!!
	)
	bounds.append(
		Vector2(get_used_rect().end * rendering_quadrant_size)  # .end returns bottom right corner!!
	)
	return bounds
