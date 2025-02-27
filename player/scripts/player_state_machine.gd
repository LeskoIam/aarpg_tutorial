class_name PlayerStateMachine extends Node


var states: Array[State]
var previous_state: State
var current_state: State


func _ready() -> void:
	# Disable this node for now, enabled in initialize
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func initialize(_player: Player) -> void:
	states = []
	
	# Collect nodes (State) in tree
	for c in get_children():
		if c is State:
			states.append(c)
			
	if states.size() == 0:
		return
		
	# Set player
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	# Change to the first state ("idle")
	change_state(states[0])
	# Enable this node
	process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		# Nothing changed
		return
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()
