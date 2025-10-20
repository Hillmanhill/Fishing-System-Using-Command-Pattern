class_name LeftMouseAttackAction
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
		if castPullController.inCombat:
			print("Left Mouse Attack")
			#castPullController.Player.velocity.y = 20
			castPullController.animation_state.execute_animation_state(castPullController.animation_state.animStates.lightAttack, Vector2(0,-1))
