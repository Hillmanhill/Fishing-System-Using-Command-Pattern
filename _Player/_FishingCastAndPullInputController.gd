class_name CastPullSystem
extends Node

@export var commandHandler: CommandActionHandler

@export var Player : CharacterBody3D
@export var HokkedEnemy : Node3D
@export var CastObject : RigidBody3D
var hookedFish: RigidBody3D

var isCast : bool = false

@export var castObjectLocation: Node3D
@export var player_mesh: Node3D

func _ready() -> void: 
	CastObject.position = castObjectLocation.global_position 

func _physics_process(delta: float) -> void:
	if !isCast:
		CastObject.global_position = castObjectLocation.global_position
		hookedFish = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var Left = LeftMouseAction.new("LeftMouseAction", "$CurrentTarget")
				commandHandler.add_command(Left, "$CurrentTarget")
			MOUSE_BUTTON_RIGHT:
				var Right = RightMouseAction.new("RightMouseAction", "$CurrentTarget")
				commandHandler.add_command(Right, "$CurrentTarget")
