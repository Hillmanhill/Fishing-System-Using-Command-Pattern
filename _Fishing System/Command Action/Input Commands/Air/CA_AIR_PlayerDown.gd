class_name AIRPlayerDownAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "AIRPlayerDown", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: PlayerController, castPullController: CastPullSystem)-> void:
	commandType = "AIRPlayerDown"
	print("Type: ",commandType, " Target: ", Target)
	Player.velocity.y = -25
