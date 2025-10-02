class_name COMBAT_AIRPlayerDownAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_AIRPlayerDown", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: inputHandlerController)-> void:
	commandType = "COMBAT_AIRPlayerDown"
	print("Type: ",commandType, " Target: ", Target)
	Player.velocity.y = -25
