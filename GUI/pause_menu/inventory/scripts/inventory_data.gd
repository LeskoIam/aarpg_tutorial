class_name InventoryData extends Resource

@export var slots: Array[SlotData]



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
			return true
			
	# Inventory was full, no item added
	print("Inventory was full, no item added")
	return false
