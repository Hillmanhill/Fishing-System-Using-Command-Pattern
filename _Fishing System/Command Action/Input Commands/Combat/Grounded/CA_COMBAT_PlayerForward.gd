class_name COMBAT_PlayerForwardAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 1
	avalibleAttackSubWindow = .5
	
	return {"ACID": "COMBAT_PlayerForward", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "COMBAT_PlayerForward"
	print("Type: ",commandType, " Target: ", Target)
