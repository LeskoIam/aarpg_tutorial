extends Node

const SAVE_PATH = "user://"

signal game_loaded_sig
signal game_saved_sig


var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		hp_max = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}


func save_game() -> void:
	print("Save Game")
	update_player_data()
	update_scene_path()
	
	var save_file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	save_file.store_line(save_json)
	game_saved_sig.emit()
	

func load_game() -> void:
	print("Load Game")
	var save_file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(save_file.get_line())
	var save_dict := json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started_sig
	# Level transition happening, screen is black
	
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.hp_max)
	await LevelManager.level_loaded_sig
	
	game_loaded_sig.emit()
	

func update_player_data() -> void:
	var player: Player = PlayerManager.player
	current_save.player.hp = player.hp
	current_save.player.hp_max = player.hp_max
	current_save.player.pos_x = player.global_position.x
	current_save.player.pos_y = player.global_position.y


func update_scene_path() -> void:
	var scene_path: String = ""
	
	for child in get_tree().root.get_children():
		if child is Level:
			scene_path = child.scene_file_path
		current_save.scene_path = scene_path
