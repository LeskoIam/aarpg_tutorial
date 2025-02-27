class_name Enemy extends CharacterBody2D

signal enemy_direction_changed_sig(new_direction: Vector2)
signal enemy_damaged_sig(hurt_box: HurtBox)
signal enemy_destroyed_sig(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var movement_direction: Vector2 = Vector2.ZERO
var player = Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var hit_box: HitBox = $HitBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.damaged_sig.connect(_on_take_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()
	

func set_cardinal_direction(_new_direction: Vector2) -> bool:
	# set_direction
	# Figure out and animate direction in which enemy is facing or moving and
	# update the animation variables accordingally
	
	movement_direction = _new_direction
	# If no input (no button press) then no update
	if movement_direction == Vector2.ZERO:
		return false
	
	# Be smart about enemy facing direction
	var direction_index: int = int(round((movement_direction + cardinal_direction*0.1).angle()/TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_index]
	
	# Does enemy animation needs updating?
	if new_direction == cardinal_direction:
		return false
	
	# Update variables
	cardinal_direction = new_direction
	# signal all listeners that enemy changed direction it's facing
	enemy_direction_changed_sig.emit(new_direction)
	# Flip enemy sprite left/right if neccessary.
	# Be smart and use scale (https://youtu.be/rKQrp2U11Ag?list=PLfcCiyd_V9GH8M9xd_QKlyU8jryGcy3Xa&t=1701)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true


func update_animation(state: String) -> void:
	# Create animation "name" as is defined in AnimationPlayer -> Animation
	animation_player.play(state + "_" + animation_direction())


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
		
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged_sig.emit(hurt_box)
	else:
		enemy_destroyed_sig.emit(hurt_box)
