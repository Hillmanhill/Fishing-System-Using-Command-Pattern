class_name PlayerBackwardAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "PlayerBackward", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController)-> void:
	commandType = "PlayerBackward"
	Player.animation_player.play("General_Player/Grounded_Walk")
	print("Type: ",commandType, " Target: ", Target)
