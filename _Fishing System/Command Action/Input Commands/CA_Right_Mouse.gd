class_name RightMouseReelAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =0
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(_cmd: String, _target: String) -> void:
	pass

#func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
#	castPullController.ropeVisualizer.reel_in(.01)

func execute(_Target: String, _Player: Node3D, castPullController: inputHandlerController)-> void:
	if castPullController.isCast:
		print("Valid reel attempt")
		var CASTOBJECT = castPullController.CastObject
		var CASTORIGIN = castPullController.castObjectLocation.global_transform.origin
		var CASTPOS = CASTOBJECT.global_transform.origin
		if CASTPOS.distance_to(CASTORIGIN) < 3:
			CASTOBJECT.linear_velocity = Vector3.ZERO
			castPullController.ropeVisualizer.destroy_rope()
			castPullController.isCast = false
		else: 
			if castPullController.hookedFish and castPullController.hookedFish.get_script() == enemyFish:
				var direction = (CASTORIGIN - CASTPOS).normalized()
				var reelSpeed = 10
				direction.y = max(direction.y, 0.0)
				var force = direction * reelSpeed
				castPullController.hookedFish.linear_velocity = force
				CASTOBJECT.linear_velocity = force
				#CASTOBJECT.apply_central_impulse(force * 30)
				castPullController.ropeVisualizer.reel_in(.01)
				print("fish reeled ")
			else:
				var direction = (CASTORIGIN - CASTPOS).normalized()
				var reelSpeed = 15
				CASTOBJECT.linear_velocity = direction * reelSpeed
				castPullController.ropeVisualizer.reel_in(0.01)
	else:
		print("NO Valid reel attempt")
