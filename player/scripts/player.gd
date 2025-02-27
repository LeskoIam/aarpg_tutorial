class_name Player extends CharacterBody2D

# Movement
var cardinal_direction: Vector2 = Vector2.DOWN  # Direction in which character is facing
var movement_direction: Vector2 = Vector2.ZERO  # Current movement direction (what player is pressing)
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var invulnerable: bool = false
var hp: int = 6
var hp_max: int = 6

# Nodes interaction
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effects_animation_player: AnimationPlayer = $EffectsAnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var hit_box: HitBox = $HitBox


signal player_direction_changed_sig(new_direction: Vector2)
signal player_damaged_sig(hurt_box: HurtBox)

func _ready() -> void:
	PlayerManager.player = self
	player_state_machine.initialize(self)
	hit_box.damaged_sig.connect(_on_take_damage)
	update_hp(99)
	print("Player ready")


func _process(_delta: float) -> void:
	movement_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down"),
	).normalized()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func update_animation(state: String) -> void:
	# Create animation "name" as is defined in AnimationPlayer -> Animation
	animation_player.play(state + "_" + animation_direction())


func set_cardinal_direction() -> bool:
	# set_direction
	# Figure out and animate direction in which player is facing or moving and
	# update the animation variables accordingally
	
	# If no input (no button press) then no update
	if movement_direction == Vector2.ZERO:
		return false
	
	# Be smart about Player facing direction
	var direction_index: int = int(round((movement_direction + cardinal_direction*0.1).angle()/TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_index]
	
	# Does Player animation needs updating?
	if new_direction == cardinal_direction:
		return false
	
	# Update variables
	cardinal_direction = new_direction
	# signal all listeners that player changed direction it's facing
	player_direction_changed_sig.emit(new_direction)
	# Flip player sprite left/right if neccessary.
	# Be smart and use scale (https://youtu.be/rKQrp2U11Ag?list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa&t=1701)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true


func animation_direction() -> String:
	match cardinal_direction:
		Vector2.DOWN:
			return "down"
		Vector2.UP:
			return "up"
		_:
			return "side"


func _on_take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged_sig.emit(hurt_box)
	else:
		player_damaged_sig.emit(hurt_box)
		printerr("Player died, giving player 99 hp ... ha, ha, ha,...")
		update_hp(99)


func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, hp_max)
	PlayerHud.update_hp(hp, hp_max)


func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hit_box.monitoring = true
