class_name LeftMouseAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =1
	
	return {"ACID": "LeftMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	if castPullController.isCast:
		print("is NOT Cast")
		castPullController.isCast = false
		castPullController.CastObject.freeze = true
		#castPullController.CastObject.collision_layer = 1
		#castPullController.CastObject.collision_mask = 1
	else:
		print("IS Cast")
		#print("Cast Object: ", castPullController.CastObject)
		castPullController.CastObject.freeze = false
		#castPullController.CastObject.global_rotation = castPullController.player_mesh.global_rotation
		var direction = castPullController.player_mesh.transform.basis.z
		direction.y = 1
		castPullController.CastObject.linear_velocity = direction * 15
		castPullController.isCast = true
