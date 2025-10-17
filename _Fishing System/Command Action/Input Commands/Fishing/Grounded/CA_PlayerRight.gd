class_name PlayerRightAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "PlayerRight", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	commandType = cmd

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "PlayerRight"
	print("Type: ",commandType, " Target: ", Target)
