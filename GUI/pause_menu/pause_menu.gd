extends CanvasLayer


signal pause_menu_shown_sig
signal pause_menu_hidden_sig

@onready var button_save: Button = $Control/VBoxContainer/Button_save
@onready var button_load: Button = $Control/VBoxContainer/Button_load
@onready var item_description: Label = $Control/ItemDescription

var is_paused: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	pause_menu_shown_sig.emit()
	

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	pause_menu_hidden_sig.emit()


func _on_save_pressed() -> void:
	if not is_paused:
		return
	SaveManager.save_game()
	hide_pause_menu()


func _on_load_pressed() -> void:
	if not is_paused:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started_sig
	hide_pause_menu()


func update_item_description(new_description: String) -> void:
	item_description.text = new_description
