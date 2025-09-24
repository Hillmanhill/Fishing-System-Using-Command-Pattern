class_name CastPullSystem
extends Node

@export var commandHandler: CommandActionHandler

@export var Player : CharacterBody3D
@export var HokkedEnemy : Node3D
@export var CastObject : RigidBody3D
var hookedFish: RigidBody3D

var isCast : bool = false

var inAir : bool = false

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
				var LeftMouse = LeftMouseAction.new("LeftMouseAction", "$CurrentTarget")
				commandHandler.add_command(LeftMouse, "$CurrentTarget")
			MOUSE_BUTTON_RIGHT:
				var RightMouse = RightMouseAction.new("RightMouseAction", "$CurrentTarget")
				commandHandler.add_command(RightMouse, "$CurrentTarget")
	elif event.is_pressed():
			for action in ["PlayerForward", "PlayerBackward", "PlayerLeft", "PlayerRight"]:
				if Input.is_action_just_pressed(action):
					if not inAir:
						match action:
								"PlayerForward":
									var Forward = PlayerForwardAction.new("PlayerForwardAction", "$Player")
									commandHandler.add_command(Forward, "$Player")
								"PlayerBackward":
									var Backward = PlayerBackwardAction.new("PlayerBackwardAction", "$Player")
									commandHandler.add_command(Backward, "$Player")
								"PlayerLeft":
									var Left = PlayerLeftAction.new("PlayerLeftAction", "$Player")
									commandHandler.add_command(Left, "$Player")
								"PlayerRight":
									var Right = PlayerRightAction.new("PlayerRightAction", "$Player")
									commandHandler.add_command(Right, "$Player")
								_:
									pass
					else: 
							match action:
								"PlayerForward":
									var Forward = AIRPlayerForwardAction.new("AIRPlayerForwardAction", "$Player")
									commandHandler.add_command(Forward, "$Player")
								"PlayerBackward":
									var Backward = AIRPlayerBackwardAction.new("AIRPlayerBackwardAction", "$Player")
									commandHandler.add_command(Backward, "$Player")
								"PlayerLeft":
									var Left = AIRPlayerLeftAction.new("AIRPlayerLeftAction", "$Player")
									commandHandler.add_command(Left, "$Player")
								"PlayerRight":
									var Right = AIRPlayerRightAction.new("AIRPlayerRightAction", "$Player")
									commandHandler.add_command(Right, "$Player")
								_:
									pass
