class_name CastPullSystem
extends Node

@export var commandHandler: CommandActionHandler

@export var Player : CharacterBody3D
@export var HokkedEnemy : Node3D
@export var CastObject : RigidBody3D

var isHooked : bool = false

@export var castObjectLocation: Node3D
@export var player_mesh: Node3D

func _ready() -> void: 
	CastObject.position = castObjectLocation.global_position 

func _physics_process(delta: float) -> void:
	if isHooked:
		pass
	else:
		print("Player Mesh: ", player_mesh.rotation)
		CastObject.position = castObjectLocation.global_position
	
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
