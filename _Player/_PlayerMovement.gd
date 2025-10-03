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
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	RELETIVESPEED = SPEED
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_mount_orbit.rotate_y(deg_to_rad(-event.relative.x * sense_Horizontal))
		camera_mount_pitch.rotate_x(deg_to_rad(-event.relative.y * sense_Vertical))
		camera_mount_pitch.rotation_degrees.x = clamp(camera_mount_pitch.rotation_degrees.x, -80, 80)
	PlayerMover()

func _physics_process(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravityMultiplyer
		castPullController.inAir = true
		animation_player.play("General_Player/AIR_Falling")
	else: 
		velocity += get_gravity() * delta * gravityMultiplyer
		castPullController.inAir = false
	
	if Input.is_action_pressed("PlayerSprint"):
		isSprinting = true
	else:
		isSprinting = false
	
	move_and_slide()

func PlayerMover() -> void:
	var input_dir := Input.get_vector("PlayerLeft", "PlayerRight", "PlayerForward", "PlayerBackward")
	
	var cam_forward = camera_3d.global_transform.basis.z
	var cam_right = camera_3d.global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	
	var move_dir: Vector3 = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()
	
	if move_dir != Vector3.ZERO:
		move_dir.y = -0.1
		player_meshes.look_at(global_position + -move_dir, Vector3.UP)
		
		if is_on_floor():
			if !isSprinting and castPullController.inCombat:
				RELETIVESPEED = COMBATSPEED
				animation_player.play("General_Player/Grounded_Walk")
			elif !isSprinting and not castPullController.inCombat:
				RELETIVESPEED = SPEED
				animation_player.play("General_Player/Grounded_Walk")
			elif isSprinting and castPullController.inCombat:
				RELETIVESPEED = COMBATSPRINTSPEED
				animation_player.play("General_Player/Grounded_Run")
			elif isSprinting and not castPullController.inCombat:
				RELETIVESPEED = SPRINTSPEED
				animation_player.play("General_Player/Grounded_Run")
		
		velocity.x = move_dir.x * RELETIVESPEED
		velocity.z = move_dir.z * RELETIVESPEED
	else:
		animation_player.play("RESET")
		velocity.x = move_toward(velocity.x, 0, RELETIVESPEED)
		velocity.z = move_toward(velocity.z, 0, RELETIVESPEED)
	
