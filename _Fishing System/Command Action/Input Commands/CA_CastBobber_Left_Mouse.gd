class_name LeftMouseCastAction
extends CommandAction

@onready var cast_object_pos: ropeVisual = $"Player/CollisionShape3D/Player Mesh/Cast Object POS"

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =0
	return {"ACID": "LeftMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	commandType = cmd

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	if !castPullController.ropeVisualizer.currentlyCasting:
		if castPullController.inCombat == false:
			if castPullController.isCast:
				castPullController.isCast = false
				castPullController.CastObject.freeze = true
				castPullController.ropeVisualizer.destroy_rope()
			else:
				if castPullController.TargetLockOn.currentTarget != null:
					castPullController.player_mesh.look_at(castPullController.TargetLockOn.currentTarget.global_position)
				castPullController.CastObject.freeze = false
				#castPullController.CastObject.global_rotation = castPullController.player_mesh.global_rotation
				var direction = -castPullController.player_mesh.transform.basis.z
				direction.y += .25
				castPullController.CastObject.linear_velocity = direction * 15
				castPullController.isCast = true
				castPullController.ropeVisualizer.create_rope(castPullController.CastObject, castPullController.castObjectLocation, castPullController.fishingLineLength)
				castPullController.animation_state.execute_animation_state(castPullController.animation_state.animStates.cast, Vector2(0,-1))
			print("is cast: ", castPullController.isCast)
		else:
				print("Left Mouse Attack")
				#castPullController.Player.velocity.y = 20
				castPullController.animation_state.execute_animation_state(castPullController.animation_state.animStates.lightAttack, Vector2(0,-1))
