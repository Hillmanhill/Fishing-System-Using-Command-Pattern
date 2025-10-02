class_name PlayerController
extends CharacterBody3D

@export var gravityMultiplyer: float
@export var SPEED: float = 5.0;
var RELETIVESPEED: float

@export var camera_3d: Camera3D;
@onready var camera_mount_orbit: Node3D = $CameraMountOrbit
@onready var camera_mount_pitch: Node3D = $CameraMountOrbit/CameraMountPitch
@export var sense_Horizontal: float = 0.5
@export var sense_Vertical: float = 0.5

@export var player_meshes: Node3D

@export var castPullController : CastPullSystem

func _ready() -> void:
	RELETIVESPEED = SPEED
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_mount_orbit.rotate_y(deg_to_rad(-event.relative.x * sense_Horizontal))
		camera_mount_pitch.rotate_x(deg_to_rad(-event.relative.y * sense_Vertical))
		camera_mount_pitch.rotation_degrees.x = clamp(camera_mount_pitch.rotation_degrees.x, -80, 80)

func _physics_process(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravityMultiplyer
		castPullController.inAir = true
	else: 
		velocity += get_gravity() * delta * gravityMultiplyer
		castPullController.inAir = false
	
	PlayerMover()
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
		move_dir.y = 0 
		player_meshes.look_at( global_transform.origin + -move_dir, Vector3.UP)
		
		velocity.x = move_dir.x * RELETIVESPEED
		velocity.z = move_dir.z * RELETIVESPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RELETIVESPEED)
		velocity.z = move_toward(velocity.z, 0, RELETIVESPEED)
	
