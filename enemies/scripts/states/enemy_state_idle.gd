class_name EnemyStateIdle extends EnemyState


@export var animation_name: String = "idle"
@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var next_state: EnemyState

var _timer: float = 0.0



## What happens when we initialize this State
func init() -> void:
	pass

## What happens when enemy enteres this State
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
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
