class_name StateStun extends State


@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0
@export var invulnerable_duration: float = 1.0

var hurt_box: HurtBox
var direction: Vector2

var next_state: State = null

@onready var idle: State = $"../idle"


func init() -> void:
	player.player_damaged_sig.connect(_on_player_damaged)

## What happens when player enteres this State
func enter() -> void:
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_cardinal_direction()
	player.update_animation("stun")
	
	player.make_invulnerable(invulnerable_duration)
	
	player.effects_animation_player.play("damaged")
	

## What happens when player exites this State
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_on_animation_finished)


## What happens during proces update in this State
func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state


## What happens during physics update in this State
func physics(_delta: float) -> State:
	return null


## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null


func _on_player_damaged(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.change_state(self)


func _on_animation_finished(_a: String) -> void:
	next_state = idle
