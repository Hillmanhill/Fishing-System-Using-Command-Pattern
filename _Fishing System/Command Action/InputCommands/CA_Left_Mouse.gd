class_name LeftMouseAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =1
	
	return {"ACID": "LeftMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	if castPullController.isHooked:
		print("Cast is hooked to fish")
		castPullController.isHooked = false
		castPullController.CastObject.freeze = true
	else:
		print("Cast is NOT hooked to fish")
		print("Cast Object: ", castPullController.CastObject)
		castPullController.CastObject.freeze = false
		castPullController.CastObject.global_rotation = castPullController.player_mesh.global_rotation
		var direction = castPullController.player_mesh.transform.basis.z
		direction.y = 1
		castPullController.CastObject.linear_velocity = direction * 5
		castPullController.isHooked = true
