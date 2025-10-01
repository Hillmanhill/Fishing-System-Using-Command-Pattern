class_name LeftMouseAction
extends CommandAction
#
@export var ropeVisualizer: ropeVisual
@onready var cast_object_pos: ropeVisual = $"Player/CollisionShape3D/Player Mesh/Cast Object POS"

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =0
	return {"ACID": "LeftMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	commandType = cmd

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	if castPullController.isCast:
		castPullController.isCast = false
		castPullController.CastObject.freeze = true
		castPullController.ropeVisualizer.destroy_rope()
	else:
		castPullController.CastObject.freeze = false
		#castPullController.CastObject.global_rotation = castPullController.player_mesh.global_rotation
		var direction = castPullController.player_mesh.transform.basis.z
		direction.y += .25
		castPullController.CastObject.linear_velocity = direction * 15
		castPullController.isCast = true
		#await get_tree().create_timer(.1).timeout
		castPullController.ropeVisualizer.create_rope(castPullController.CastObject, castPullController.castObjectLocation, 15)
	print("is cast: ", castPullController.isCast)
