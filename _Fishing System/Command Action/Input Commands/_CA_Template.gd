class_name GenericAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 1
	avalibleAttackSubWindow = 1
	
	return {"ACID": "Generic", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	print("Type: ",commandType, " Target: ", Target)
