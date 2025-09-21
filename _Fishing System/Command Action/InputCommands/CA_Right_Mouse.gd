class_name RightMouseAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =1
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	if castPullController.isCast:
		print("Valid reel attempt")
		var CASTOBJECT = castPullController.CastObject
		var CASTORIGIN = castPullController.castObjectLocation.global_transform.origin
		var CASTPOS = CASTOBJECT.global_transform.origin
		if CASTPOS.distance_to(CASTORIGIN) < 3:
			CASTOBJECT.linear_velocity = Vector3.ZERO
			castPullController.isCast = false
		else: 
			var direction = (CASTORIGIN - CASTPOS).normalized()
			var reelSpeed = 15
			CASTOBJECT.linear_velocity = direction * reelSpeed
	else:
		print("NO Valid reel attempt")
