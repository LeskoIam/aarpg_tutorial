class_name StateWalk extends State


@export var movement_speed: float = 100.0

@onready var idle: State = $"../idle"
@onready var attack: State = $"../attack"


## What happens when player enteres this State
func enter() -> void:
	player.update_animation("walk")


## What happens when player exites this State
func exit() -> void:
	pass


## What happens during proces update in this State
func process(_delta: float) -> State:
	if player.movement_direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.movement_direction * movement_speed
	if player.set_cardinal_direction():
		player.update_animation("walk")
	return null


## What happens during physics update in this State
func physics(_delta: float) -> State:
	return null


## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
