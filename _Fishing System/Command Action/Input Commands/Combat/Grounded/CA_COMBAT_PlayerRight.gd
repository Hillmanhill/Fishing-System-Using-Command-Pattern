class_name COMBAT_PlayerRightAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_PlayerRight", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	commandType = cmd

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem)-> void:
	commandType = "COMBAT_PlayerRight"
	print("Type: ",commandType, " Target: ", Target)
