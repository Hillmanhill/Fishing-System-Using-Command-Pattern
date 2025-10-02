class_name fishingBobber
extends RigidBody3D

@export var castPullController: inputHandlerController
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var hasFish: RigidBody3D
var isAttached: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("releaseBobber") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.reparent(get_tree().root)
		self.freeze = false
		self.custom_integrator = false
		collision_shape_3d.disabled = false

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if castPullController.isCast == true and body.get_script() == enemyFish:
		print("body name: ", body.name, " cauth")
		hasFish = body
		castPullController.hookedFish = hasFish
		collision_shape_3d.call_deferred("set_disabled", true)
		self.freeze = true
		self.custom_integrator = true
		isAttached = true
		reparent(hasFish)
