class_name COMBAT_PlayerJumpAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse = .1
	avalibleAttackSubWindow = .05
	
	return {"ACID": "COMBAT_PlayerJump", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(cmd: String, target: String) -> void:
	pass

func execute(Target: String, Player: CharacterBody3D, castPullController: CastPullSystem)-> void:
	commandType = "COMBAT_PlayerJump"
	Player.velocity.y = 20
	print("Type: ",commandType, " Target: ", Target)
