class_name PlayerForwardAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 1
	avalibleAttackSubWindow = .5
	
	return {"ACID": "PlayerForward", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	commandType = "PlayerForward"
	print("Type: ",commandType, " Target: ", Target)
