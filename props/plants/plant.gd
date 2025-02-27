class_name Plant extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.damaged_sig.connect(_on_take_damage)

	pass # Replace with function body.

func _on_take_damage(_hurt_box: HurtBox) -> void:
	queue_free()
