class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn")  # Single inventory slot

var focus_index: int = 0

@export var inventory_data: InventoryData  # Player inventory


func _ready() -> void:
	PauseMenu.pause_menu_shown_sig.connect(update_inventory)  # PauseMenu is autoload script!!
	PauseMenu.pause_menu_hidden_sig.connect(clear_inventory)
	clear_inventory()
	inventory_data.changed.connect(on_inventory_changed)


func clear_inventory() -> void:
	for child in get_children():
		child.queue_free()


func update_inventory() -> void:
	for slot in inventory_data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = slot
		new_slot.focus_entered.connect(item_focused)
		
	await get_tree().process_frame
	get_child(focus_index).grab_focus()


func item_focused() -> void:
	for child_index in get_child_count():
		if get_child(child_index).has_focus():
			focus_index = child_index
			return


func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
	
