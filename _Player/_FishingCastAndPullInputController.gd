class_name CastPullSystem
extends Node

@export var commandHandler: CommandActionHandler

@export var Player : CharacterBody3D
@export var HokkedEnemy : Node3D
@export var CastObject : RigidBody3D

var isHooked : bool = false

var castObjectLocation: Vector3

func _ready() -> void: 
	castObjectLocation  = CastObject.position

#casting system which throws an object 

#collided cobject will be parented with bobber 

# child object will be pulled closer to player on input

# if statement to allow pull when true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var Left = LeftMouseAction.new("LeftMouseAction", "$CurrentTarget")
				commandHandler.add_command(Left, "$CurrentTarget")
			MOUSE_BUTTON_RIGHT:
				var Right = RightMouseAction.new("RightMouseAction", "$CurrentTarget")
				commandHandler.add_command(Right, "$CurrentTarget")
