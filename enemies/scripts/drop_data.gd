class_name DropData extends Resource

@export var item: ItemData
# Probability of an item drop
@export_range(0, 100, 1, "suffix:%") var drop_probability: float = 100.0
# How many items will it drop
@export_range(1, 10, 1, "suffix:items") var min_amount: int = 1
@export_range(1, 10, 1, "suffix:items") var max_amount: int = 1


func get_drop_count() -> int:
	if randf_range(0, 100) >= drop_probability:
		return 0
	
	return randi_range(min_amount, max_amount)
	
