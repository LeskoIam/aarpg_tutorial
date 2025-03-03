class_name ItemEffectHeal extends ItemEffect

@export var heal_ammount: int = 1
@export var audio: AudioStream



func use() -> void:
	PlayerManager.player.update_hp(heal_ammount)
	# Play sound
	PauseMenu.play_audio(audio)
 
