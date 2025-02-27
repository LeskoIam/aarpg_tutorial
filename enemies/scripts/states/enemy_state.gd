class_name EnemyState extends Node


## Stores a reference to the enemy that this state belongs to
var enemy: Enemy
var state_machine: EnemyStateMachine

## What happens when we initialize this State
func init() -> void:
	pass

## What happens when enemy enteres this State
func enter() -> void:
	pass


## What happens when enemy exites this State
func exit() -> void:
	pass


## What happens during proces update in this State
func process(_delta: float) -> EnemyState:
	return null


## What happens during physics update in this State
func physics(_delta: float) -> EnemyState:
	return null
