class_name inputHandlerController
extends Node
@onready var progress_bar: ProgressBar = $"../CameraMountOrbit/CameraMountPitch/Camera3D/ProgressBar"

@export var Player : PlayerController
@export var player_mesh: Node3D
@export var commandHandler: CommandActionHandler
@export var animation_state: playerAnimStates
@export var TargetLockOn : PlayerTargetLockOn
@export var HokkedEnemy : Node3D
@export var CastObject : RigidBody3D
@export var castObjectLocation: StaticBody3D

@export var ropeVisualizer: ropeVisual
var hookedFish: RigidBody3D

var isCast : bool = false
var inAir : bool = false
var inCombat: bool = false

var fishingLineLength: int = 10

func _ready() -> void: 
	CastObject.position = castObjectLocation.global_position 
	progress_bar.value = fishingLineLength

func _physics_process(delta: float) -> void:
	if !isCast:
		CastObject.global_position = castObjectLocation.global_position
		hookedFish = null
	elif hookedFish:
			ropeVisualizer.reel_in(.1)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_1):
		if fishingLineLength < 15:
			fishingLineLength += 1
			progress_bar.value +=1
	elif Input.is_key_pressed(KEY_2):
		if fishingLineLength > 5:
			fishingLineLength -= 1
			progress_bar.value -=1
	if isCast: 
		if Input.is_key_pressed(KEY_0):
			if fishingLineLength >= 5:
				ropeVisualizer.remove_last_segment()
				progress_bar.value -=1
		elif Input.is_key_pressed(KEY_9):
			if fishingLineLength <= 15:
				ropeVisualizer.append_segments_to_current(1)
				progress_bar.value +=1
	
	if Input.is_action_just_pressed("PlayerTargetLockOn") and TargetLockOn.currentTarget == null:
		TargetLockOn.lock_onto_closest()
	elif Input.is_action_just_pressed("PlayerTargetLockOn") and TargetLockOn.currentTarget:
		TargetLockOn.unlock_Target()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP) or Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		TargetLockOn.cycle_target(true)
	
	if Input.is_action_just_pressed("SetCombatState"):
		if inCombat:
			inCombat = false
		else:
			inCombat = true
	
	if !inCombat:
		if event.is_action_pressed("PlayerSprint"):
			var sprint = PlayerSprintAction.new("PlayerSprintAction", "$Player")
			commandHandler.add_command(sprint, "$Player") 
		
		if event.is_action_pressed("ReelInBobber"):
			var reelIn = ReelInAction.new("ReelInAction", "$CurrentTarget")
			commandHandler.add_command(reelIn, "$Player")
			animation_state.execute_animation_state(animation_state.animStates.castForwrd, Vector2(0,0))
			
		if event is InputEventMouseButton and event.is_pressed():
			if !inAir:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						var LeftMouse = LeftMouseCastAction.new("LeftMouseCastAction", "$CurrentTarget")
						commandHandler.add_command(LeftMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.cast, Vector2(0,-1))
					MOUSE_BUTTON_RIGHT:
						var RightMouse = RightMouseReelAction.new("RightMouseReelAction", "$CurrentTarget")
						commandHandler.add_command(RightMouse, "$CurrentTarget")
						#animation_state.execute_animation_state(animation_state.animStates.castForwrd, Vector2(0, 1))
			else:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						var LeftMouse = LeftMouseCastAction.new("LeftMouseCastAction", "$CurrentTarget")
						commandHandler.add_command(LeftMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.cast, Vector2(0,-1))
					MOUSE_BUTTON_RIGHT:
						var RightMouse = RightMouseReelAction.new("RightMouseReelAction", "$CurrentTarget")
						commandHandler.add_command(RightMouse, "$CurrentTarget")
						#animation_state.execute_animation_state(animation_state.animStates.castForwrd, Vector2(0, 1))
		
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
		
		if Input.is_action_just_pressed("PlayerJump") and Player.is_on_floor():
			animation_state.execute_animation_state(animation_state.animStates.jump,Vector2(0,0))
			var jump = PlayerJumpAction.new("PlayerJumpAction", "$Player")
			commandHandler.add_command(jump, "$Player")
		elif Input.is_action_just_pressed("PlayerDown") and inAir:
			var down = AIRPlayerDownAction.new("AIRPlayerDownAction", "$Player")
			commandHandler.add_command(down, "$Player")
		elif Input.is_action_just_pressed("PlayerDown") and !inAir:
			var down = PlayerDownAction.new("PlayerDownAction", "$Player")
			commandHandler.add_command(down, "$Player")
	
	else:
		if event.is_action_pressed("PlayerSprint"):
			var combatSprint = COMBAT_PlayerSprintAction.new("COMBAT_PlayerSprintAction", "$Player")
			commandHandler.add_command(combatSprint, "$Player")

		if event.is_action_pressed("ReelInBobber"):
			var reelIn = ReelInAction.new("ReelInAction", "$Player")
			commandHandler.add_command(reelIn, "$Player")
			animation_state.execute_animation_state(animation_state.animStates.castForwrd, Vector2(0,0))
		
		if event is InputEventMouseButton and event.is_pressed():
			if !inAir:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						var LeftMouse = LeftMouseCastAction.new("LeftMouseCastAction", "$CurrentTarget")
						commandHandler.add_command(LeftMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.lightAttack, Vector2(0,-1))
					MOUSE_BUTTON_RIGHT:
						var RightMouse = RightMouseReelAction.new("RightMouseReelAction", "$CurrentTarget")
						commandHandler.add_command(RightMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.heavyAttack,Vector2(0,1))
			else:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						var LeftMouse = LeftMouseCastAction.new("LeftMouseCastAction", "$CurrentTarget")
						commandHandler.add_command(LeftMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.lightAttack, Vector2(0,-1))
					MOUSE_BUTTON_RIGHT:
						var RightMouse = RightMouseReelAction.new("RightMouseReelAction", "$CurrentTarget")
						commandHandler.add_command(RightMouse, "$CurrentTarget")
						animation_state.execute_animation_state(animation_state.animStates.heavyAttack, Vector2(0, 1))
		
		elif event.is_pressed():
				for action in ["PlayerForward", "PlayerBackward", "PlayerLeft", "PlayerRight"]:
					if Input.is_action_just_pressed(action):
						if not inAir:
							match action:
									"PlayerForward":
										var Forward = COMBAT_PlayerForwardAction.new("COMBAT_PlayerForwardAction", "$Player")
										commandHandler.add_command(Forward, "$Player")
									"PlayerBackward":
										var Backward = COMBAT_PlayerBackwardAction.new("COMBAT_PlayerBackwardAction", "$Player")
										commandHandler.add_command(Backward, "$Player")
									"PlayerLeft":
										var Left = COMBAT_PlayerLeftAction.new("COMBAT_PlayerLeftAction", "$Player")
										commandHandler.add_command(Left, "$Player")
									"PlayerRight":
										var Right = COMBAT_PlayerRightAction.new("COMBAT_PlayerRightAction", "$Player")
										commandHandler.add_command(Right, "$Player")
									_:
										pass
						else: 
								match action:
									"PlayerForward":
										var Forward = COMBAT_AIRPlayerForwardAction.new("COMBAT_AIRPlayerForwardAction", "$Player")
										commandHandler.add_command(Forward, "$Player")
									"PlayerBackward":
										var Backward = COMBAT_AIRPlayerBackwardAction.new("COMBAT_AIRPlayerBackwardAction", "$Player")
										commandHandler.add_command(Backward, "$Player")
									"PlayerLeft":
										var Left = COMBAT_AIRPlayerLeftAction.new("COMBAT_AIRPlayerLeftAction", "$Player")
										commandHandler.add_command(Left, "$Player")
									"PlayerRight":
										var Right = COMBAT_AIRPlayerRightAction.new("COMBAT_AIRPlayerRightAction", "$Player")
										commandHandler.add_command(Right, "$Player")
									_:
										pass
		
		if Input.is_action_just_pressed("PlayerJump") and Player.is_on_floor():
			animation_state.execute_animation_state(animation_state.animStates.jump,Vector2(0,0))
			var jump = COMBAT_PlayerJumpAction.new("COMBAT_PlayerJumpAction", "$Player")
			commandHandler.add_command(jump, "$Player")
		elif Input.is_action_just_pressed("PlayerDown") and inAir:
			var down = COMBAT_AIRPlayerDownAction.new("COMBAT_AIRPlayerDownAction", "$Player")
			commandHandler.add_command(down, "$Player")
		elif Input.is_action_just_pressed("PlayerDown") and !inAir:
			var down = COMBAT_PlayerDownAction.new("COMBAT_PlayerDownAction", "$Player")
			commandHandler.add_command(down, "$Player")
