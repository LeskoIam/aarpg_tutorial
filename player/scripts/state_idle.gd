class_name StateIdle extends State


@onready var walk: State = $"../walk"
@onready var attack: State = $"../attack"


## What happens when player enteres this State
func enter() -> void:
	player.update_animation("idle")


## What happens when player exites this State
func exit() -> void:
	pass


## What happens during proces update in this State
func process(_delta: float) -> State:
	if player.movement_direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null


## What happens during physics update in this State
func physics(_delta: float) -> State:
	return null


## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
