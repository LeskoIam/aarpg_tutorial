class_name HitBox extends Area2D

signal damaged_sig(hurt_box: HurtBox)



func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func take_damage(hurt_box: HurtBox) -> void:
	damaged_sig.emit(hurt_box)
