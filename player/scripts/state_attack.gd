class_name StateAttack extends State


var attacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var acceleration_speed: float = 5

# States to transition to
@onready var idle: State = $"../idle"
@onready var walk: State = $"../walk"

# Animations / Audio
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var hurt_box: HurtBox = %AttackHurtBox



## What happens when player enteres this State
func enter() -> void:
	# Animation/s
	player.update_animation("attack")
	attack_animation_player.play("attack_" + player.animation_direction())
	animation_player.animation_finished.connect(end_attack)
	
	# Audio / Sounds
	audio.pitch_scale = randf_range(1.2, 1.3)  # Change pitch of a sound to introduce small difference
	audio.stream = attack_sound
	audio.play()
	
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true


## What happens when player exites this State
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false


## What happens during proces update in this State
func process(_delta: float) -> State:
	# player.velocity = Vector2.ZERO  # Player not moving in attack state
	player.velocity -= player.velocity * acceleration_speed * _delta
	
	# When attack is over, change state according to ...
	if not attacking:  # Wait for attack animation to complete
		if player.movement_direction == Vector2.ZERO:
			return idle
		else:
			return walk
	
	return null


## What happens during physics update in this State
func physics(_delta: float) -> State:
	return null


## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null
	
func end_attack(_animation_name: String) -> void:
	attacking = false
