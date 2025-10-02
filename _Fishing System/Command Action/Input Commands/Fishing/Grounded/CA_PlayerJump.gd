class_name PlayerJumpAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "PlayerJump", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "PlayerJump"
	Player.velocity.y = 20
	Player.animation_player.play("General_Player/Grounded_Jump")
	print("Type: ",commandType, " Target: ", Target)
