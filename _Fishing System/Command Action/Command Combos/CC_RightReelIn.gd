class_name RightReelInAction
extends CommandAction

@export var commandHandler: CommandActionHandler

func get_id() -> Dictionary:
	attackTimeElapse = 3
	avalibleAttackSubWindow = 0
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _ready() -> void:
	commandHandler.register_combo(["COMBAT_PlayerRight"], self)
	#nextComboBranch = {}

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController) -> void:
	if  castPullController.hookedFish:
		castPullController.animation_state.execute_animation_state(castPullController.animation_state.animStates.castRight, "")
		var direction = (castPullController.hookedFish.global_position - Player.global_position).cross(Vector3.UP).normalized() * 20
		castPullController.hookedFish.linear_velocity = direction
		print("!!!! right reel combo 01 !!!! @: ")
