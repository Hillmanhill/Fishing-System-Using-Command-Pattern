class_name PlayerController
extends CharacterBody3D

@export var gravityMultiplyer: float
@export var SPEED: float = 5.0;
@export var SPRINTSPEED: float = 10
@export var COMBATSPEED: float = 6.5
@export var COMBATSPRINTSPEED: float = 13
var RELETIVESPEED: float
var isSprinting: bool = false

@export var camera_3d: Camera3D;
@onready var camera_mount_orbit: Node3D = $CameraMountOrbit
@onready var camera_mount_pitch: Node3D = $CameraMountOrbit/CameraMountPitch
@export var sense_Horizontal: float = 0.5
@export var sense_Vertical: float = 0.5

@export var player_meshes: Node3D

@export var castPullController : inputHandlerController
@onready var animation_state: playerAnimStates = $animationStateController
var lastAnimState
var newAnimState
var animInputVector: Vector2

@onready var animation_player: AnimationPlayer = $animationStateController/AnimationPlayer
var isAttacking: bool = false

func _ready() -> void:
	RELETIVESPEED = SPEED
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#animation_player.play("COMBAT_PlayerSword/AIR_lightAttack")
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_mount_orbit.rotate_y(deg_to_rad(-event.relative.x * sense_Horizontal))
		camera_mount_pitch.rotate_x(deg_to_rad(-event.relative.y * sense_Vertical))
		camera_mount_pitch.rotation_degrees.x = clamp(camera_mount_pitch.rotation_degrees.x, -80, 80)
	
	if is_on_floor():
		if !isSprinting and castPullController.inCombat:
			RELETIVESPEED = COMBATSPEED
		elif !isSprinting and not castPullController.inCombat:
			RELETIVESPEED = SPEED
		elif isSprinting and castPullController.inCombat:
			RELETIVESPEED = COMBATSPRINTSPEED
		elif isSprinting and not castPullController.inCombat:
			RELETIVESPEED = SPRINTSPEED
	
func _physics_process(delta: float):
	if is_on_floor():
		if velocity.length() > 0.1 and isAttacking == false:
			if isSprinting:
				newAnimState = animation_state.animStates.sprint
				animInputVector = Vector2(1,0)
			elif !isSprinting: 
				newAnimState = animation_state.animStates.walk
				animInputVector = Vector2(-1,0)
		if velocity.length() < 0.1 and isAttacking == false: 
			newAnimState = animation_state.animStates.idle
			animInputVector = Vector2(0,0)
	else:
		newAnimState = animation_state.animStates.jump
		velocity += get_gravity() * delta * gravityMultiplyer
		castPullController.inAir = false
	
	if newAnimState != lastAnimState:
		animation_state.execute_animation_state(newAnimState, animInputVector)
		lastAnimState = newAnimState
	
	if Input.is_action_pressed("PlayerSprint"):
		isSprinting = true
	else:
		isSprinting = false
	
	PlayerMover()
	move_and_slide()

func PlayerMover() -> void:
	var input_dir: Vector2 = Input.get_vector("PlayerLeft", "PlayerRight", "PlayerForward", "PlayerBackward")
	var cam_forward = camera_3d.global_transform.basis.z
	var cam_right = camera_3d.global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	var move_dir: Vector3 = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()
	
	if move_dir != Vector3.ZERO:
		move_dir.y = -0.1
		var targetRotation = atan2(-move_dir.x, -move_dir.z) 
		var currentRotation = player_meshes.rotation.y
		var smoothRotation = lerp_angle(currentRotation, targetRotation, get_process_delta_time() * 10)
		player_meshes.rotation.y = smoothRotation
		
		velocity.x = move_dir.x * RELETIVESPEED
		velocity.z = move_dir.z * RELETIVESPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RELETIVESPEED)
		velocity.z = move_toward(velocity.z, 0, RELETIVESPEED)

func _delay_switch_timer(seconds: float, initalBool: bool) -> bool:
	await get_tree().create_timer(seconds).timeout
	if initalBool == false:
		return true
	else: 
		return false
