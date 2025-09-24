class_name AIRPlayerRightAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "AIRPlayerRight", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: CastPullSystem)-> void:
	commandType = "AIRPlayerRight"
	print("Type: ",commandType, " Target: ", Target)
