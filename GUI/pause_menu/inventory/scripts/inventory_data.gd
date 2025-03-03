class_name InventoryData extends Resource

@export var slots: Array[SlotData]


func _init() -> void:
	connect_slots()


func add_item(item: ItemData, amount: int = 1) -> bool:
	# @return: can player pick up item (inventory full?)
	# ideas: 
	#   - is item stackable
	#   - max item stack
	for slot in slots:
		if slot:
			if slot.item_data == item:
				slot.quantity += amount
				return true
		
	# my for loop implementation
	# does not work!!!
	#for slot in slots:
		#print(slot)
		#if slot == null:
			#print(slot, " == null")
			#var new_slot_data := SlotData.new()
			#new_slot_data.item_data = item
			#new_slot_data.quantity = amount
			#slot = new_slot_data
			#return true
	
	for i in slots.size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = amount
			slots[ i ] = new
			new.changed.connect(slot_changed)
			return true
			
	# Inventory was full, no item added
	print("Inventory was full, no item added")
	return false


func connect_slots() -> void:
	for slot in slots:
		if slot:
			slot.changed.connect(slot_changed)


func slot_changed() -> void:
	for slot in slots:
		if slot:
			if slot.quantity < 1:
				slot.changed.disconnect(slot_changed)
				var slot_index = slots.find(slot)
				slots[slot_index] = null
				emit_changed()


# Gather the inventory into an array
func get_save_data() -> Array:
	var item_save: Array = []
	for slot_index in slots.size():
		item_save.append(item_to_save(slots[slot_index]))
	return item_save
	


# Convert each inventory item into a dictionary
func item_to_save(slot: SlotData) -> Dictionary:
	var result = {item_resource_path = "", quantity = 0}
	
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item_resource_path = slot.item_data.resource_path
	
	return result


func parse_save_data(saved_data: Array) -> void:
	var inventory_array_size = slots.size()
	slots.clear()
	slots.resize(inventory_array_size)
	for item_index in saved_data.size():
		slots[item_index] = item_from_save(saved_data[item_index])
	connect_slots()
	

func item_from_save(save_object: Dictionary) -> SlotData:
	if save_object.item_resource_path == "":
		return null
		
	var new_slot: SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item_resource_path)
	new_slot.quantity = int(save_object.quantity)
	return new_slot
