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
		castPullController.CastObject.position = castPullController.castObjectLocation
	else:
		print("Cast is NOT hooked to fish")
		print("Cast Object: ", castPullController.CastObject)
		castPullController.CastObject.freeze = false
		castPullController.isHooked = true
