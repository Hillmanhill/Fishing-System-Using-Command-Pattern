class_name fishingBobber
extends RigidBody3D

@export var castPullController: CastPullSystem
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var hasFish: RigidBody3D
var isAttached: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("releaseBobber") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.reparent(get_tree().root)
		self.freeze = false
		self.custom_integrator = false
		collision_shape_3d.disabled = false
		#self.collision_layer = 1
		#self.collision_mask = 1

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if castPullController.isCast == true and body.get_script() == enemyFish:
		print("body name: ", body.name, " cauth")
		hasFish = body
		castPullController.hookedFish = hasFish
		#self.linear_velocity = Vector3.ZERO
		#self.angular_velocity = Vector3.ZERO
		#hasFish.linear_velocity = Vector3.ZERO
		#hasFish.angular_velocity = Vector3.ZERO
		collision_shape_3d.disabled = true
		self.freeze = true
		self.custom_integrator = true
		#self.collision_layer = 1
		#self.collision_mask = 1
		isAttached = true
		self.reparent(hasFish)
