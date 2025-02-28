class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn")  # Single inventory slot

@export var inventory_data: InventoryData  # Player inventory


func _ready() -> void:
	PauseMenu.pause_menu_shown_sig.connect(update_inventory)  # PauseMenu is autoload script!!
	PauseMenu.pause_menu_hidden_sig.connect(clear_inventory)
	clear_inventory()


func clear_inventory() -> void:
	for child in get_children():
		child.queue_free()


func update_inventory() -> void:
	for slot in inventory_data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = slot
		
		get_child(0).grab_focus()
		
