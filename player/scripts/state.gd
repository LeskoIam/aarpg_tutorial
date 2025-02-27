class_name State extends Node


static  var player: Player
static var state_machine: PlayerStateMachine


func _ready() -> void:
	pass


func init() -> void:
	pass

## What happens when player enteres this State
func enter() -> void:
	pass


## What happens when player exites this State
func exit() -> void:
	pass


## What happens during proces update in this State
func process(_delta: float) -> State:
	return null


## What happens during physics update in this State
func physics(_delta: float) -> State:
	return null


## What happens with input events in this State
func handle_input(_event: InputEvent) -> State:
	return null
