class_name fishingBobber
extends RigidBody3D

@export var castPullController: CastPullSystem
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("releaseBobber") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.reparent(get_tree().root)
		freeze = false
		custom_integrator = false

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if castPullController.isCast == true:
		if body.get_script() == enemyFish:
			print("body name: ", body.name, " cauth")
			var hasFish: RigidBody3D = body
			freeze = true
			custom_integrator = true
			#collision_shape_3d.disabled = true
			self.reparent(hasFish)
