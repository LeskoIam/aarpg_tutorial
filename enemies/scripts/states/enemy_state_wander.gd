class_name EnemyStateWander extends EnemyState


@export var animation_name: String = "walk"
@export var wander_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5  # 0.7 set in inspector, taken from walk animation duration
@export var animation_cycles_min: int = 1  # state_cycle_min
@export var animation_cycles_max: int = 3
@export var next_state: EnemyState

var _timer: float = 0.0
var _direction: Vector2



## What happens when we initialize this State
func init() -> void:
	pass

## What happens when enemy enteres this State
func enter() -> void:
	_timer = randi_range(animation_cycles_min, animation_cycles_max) * state_animation_duration
	var random_direction_index = randi_range(0, 3)
	_direction = enemy.DIR_4[random_direction_index]
	
	enemy.velocity = _direction * wander_speed
	enemy.set_cardinal_direction(_direction)
	enemy.update_animation(animation_name)


## What happens when enemy exites this State
func exit() -> void:
	pass


## What happens during proces update in this State
func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null


## What happens during physics update in this State
func physics(_delta: float) -> EnemyState:
	return null
