class_name COMBAT_PlayerLeftAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_PlayerLeft", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	commandType = cmd

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	commandType = "COMBAT_PlayerLeft"
	print("Type: ",commandType, " Target: ", Target)
