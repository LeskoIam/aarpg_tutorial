@tool
class_name ItemPickup extends Node2D


@export var item_data: ItemData: set = _set_item_data

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	_update_texture()
	# Before Engine.is_editor_hint(), happens in editor (@tool)
	if Engine.is_editor_hint():
		return
	# After Engine.is_editor_hint(), happens only when game running
	area.body_entered.connect(_on_body_entered)
	

func  _on_body_entered(body) -> void:
	if body is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data):
				# So, item will be picked up only if inventory has space
				item_picked_up()


func item_picked_up() -> void:
	area.body_entered.disconnect(_on_body_entered)
	audio_stream_player.play()
	visible = false
	await audio_stream_player.finished
	queue_free()


func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update_texture()
	

func _update_texture() -> void:
	if item_data and sprite:
		sprite.texture = item_data.texture
	
