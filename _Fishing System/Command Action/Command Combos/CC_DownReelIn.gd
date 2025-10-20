class_name DownReelInAction
extends CommandAction

@export var commandHandler: CommandActionHandler

func get_id() -> Dictionary:
	attackTimeElapse = 3
	avalibleAttackSubWindow = 0
	return {"ACID": "ReelIn", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _ready() -> void:
	commandHandler.register_combo(["COMBAT_PlayerBackward"], self)
	#nextComboBranch = {}

func execute(Target: String, Player: Node3D, castPullController: inputHandlerController) -> void:
	if castPullController.hookedFish:
		#castPullController.Player.velocity.y = 20
		castPullController.animation_state.execute_animation_state(castPullController.animation_state.animStates.castForwrd, Vector2(1,0))
		var direction = (castPullController.hookedFish.global_position - Player.global_position).normalized() * -4
		castPullController.hookedFish.linear_velocity.y = -8
		castPullController.hookedFish.linear_velocity.x = direction.x
		castPullController.hookedFish.linear_velocity.z = direction.z
		print("!!!! Forward Down reel combo 01 !!!!")
