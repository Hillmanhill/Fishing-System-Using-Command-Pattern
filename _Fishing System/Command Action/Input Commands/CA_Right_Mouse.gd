class_name RightMouseReelAction
extends CommandAction

func get_id()-> Dictionary:
	attackTimeElapse =2
	avalibleAttackSubWindow =0
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _init(_cmd: String, _target: String) -> void:
	pass

func execute(_Target: String, _Player: Node3D, castPullController: inputHandlerController)-> void:
	pass
