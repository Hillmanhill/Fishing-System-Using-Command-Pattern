class_name RightMouseAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =1
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	if castPullController.isHooked:
		print("Valid reel attempt")
	else:
		print("NO Valid reel attempt")
