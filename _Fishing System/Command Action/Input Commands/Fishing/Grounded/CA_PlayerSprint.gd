class_name PlayerSprintAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = 1
	avalibleAttackSubWindow = .5
	print("test")
	return {"ACID": "PlayerSprint", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	commandType = "PlayerSprint"
	print("Type: ",commandType, " Target: ", Target)
