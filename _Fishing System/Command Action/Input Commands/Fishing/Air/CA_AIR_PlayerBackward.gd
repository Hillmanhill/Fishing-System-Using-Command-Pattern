class_name AIRPlayerBackwardAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "AIRPlayerBackward", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	commandType = "AIRPlayerBackward"
	
	print("Type: ",commandType, " Target: ", Target)
