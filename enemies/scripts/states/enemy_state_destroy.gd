class_name EnemyStateDestroy extends EnemyState


@export var animation_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10

@export_category("AI")

var _damage_position: Vector2
var _direction: Vector2


## What happens when we initialize this State
func init() -> void:
	enemy.enemy_destroyed_sig.connect(_on_enemy_destroyed)
	pass

## What happens when enemy enteres this State
func enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_cardinal_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()


## What happens when enemy exites this State
func exit() -> void:
	enemy.invulnerable = false


## What happens during proces update in this State
func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


## What happens during physics update in this State
func physics(_delta: float) -> EnemyState:
	return null


func _on_enemy_destroyed(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)


func _on_animation_finished(_a: String) -> void:
	enemy.queue_free()
	

func disable_hurt_box() -> void:
	var hurt_box: HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false
