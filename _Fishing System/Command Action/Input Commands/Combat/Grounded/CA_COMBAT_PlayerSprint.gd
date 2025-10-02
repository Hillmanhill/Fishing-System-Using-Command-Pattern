class_name COMBAT_PlayerSprintAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 1
	avalibleAttackSubWindow = .5
	
	return {"ACID": "COMBAT_PlayerSprint", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	commandType = "COMBAT_PlayerSprint"
	print("Type: ",commandType, " Target: ", Target)
