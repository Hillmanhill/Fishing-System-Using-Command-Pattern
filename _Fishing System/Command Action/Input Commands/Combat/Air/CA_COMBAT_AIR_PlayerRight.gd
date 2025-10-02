class_name COMBAT_AIRPlayerRightAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_AIRPlayerRight", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, _castPullController: CastPullSystem)-> void:
	commandType = "COMBAT_AIRPlayerRight"
	print("Type: ",commandType, " Target: ", Target)
