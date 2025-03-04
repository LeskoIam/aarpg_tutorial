@tool
class_name TreasureChest extends Node2D

@export var item_data: ItemData: set = _set_item_data
@export var quantity: int = 1: set = _set_item_quantity

var is_open: bool = false

@onready var item_sprite: Sprite2D = $ItemSprite2D
@onready var item_quantity_label: Label = $ItemSprite2D/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $InteractArea2D


func _ready() -> void:
	# happens in tool
	_update__item_texture()
	_update_item_quntity_label()
	if Engine.is_editor_hint():
		return
	# happens in game
	interact_area.area_entered.connect(_on_interact_area_enter)
	interact_area.area_exited.connect(_on_interact_area_exit)


func player_interact() -> void:
	# interaction button pressed (E)
	if is_open:
		return
	is_open = true
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data, quantity)
	else:
		# printerr("No items in chest")  # outputs to "Output" window
		push_error("No items in chest. Chest: ", name) # outputs to "Debugger" -> Errors window
	


func _on_interact_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed_sig.connect(player_interact)
	
	

func _on_interact_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed_sig.disconnect(player_interact)



func _set_item_data(value: ItemData) -> void:
	item_data = value
	_update__item_texture()


func _set_item_quantity(value: int) -> void:
	quantity = value
	_update_item_quntity_label()


func _update__item_texture() -> void:
	if item_data and item_sprite:
		item_sprite.texture = item_data.texture


func _update_item_quntity_label() -> void:
	if item_quantity_label:
		if quantity <= 1:
			item_quantity_label.text = ""
		else:
			item_quantity_label.text = "x" + str(quantity)
		
		
