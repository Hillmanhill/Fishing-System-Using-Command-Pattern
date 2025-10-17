class_name PlayerJumpAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 3
	avalibleAttackSubWindow = .0
	
	return {"ACID": "PlayerJump", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "PlayerJump"
	Player.velocity.y = 20
	print("Type: ",commandType, " Target: ", Target)
