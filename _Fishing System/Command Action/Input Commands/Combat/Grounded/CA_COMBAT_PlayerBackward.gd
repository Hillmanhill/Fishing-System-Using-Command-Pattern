class_name COMBAT_PlayerBackwardAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_PlayerBackward", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "COMBAT_PlayerBackward"
	print("Type: ",commandType, " Target: ", Target)
