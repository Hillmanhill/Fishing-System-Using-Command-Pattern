class_name UpReelInAction
extends CommandAction

@export var commandHandler: CommandActionHandler

func get_id() -> Dictionary:
	attackTimeElapse = 3
	avalibleAttackSubWindow = 0
	return {"ACID": "RightMouse", "attackTime": attackTimeElapse, "avalibleTime": avalibleAttackSubWindow}

func _ready() -> void:
	commandHandler.register_combo(["PlayerForward"], self)
	#nextComboBranch = {}

func execute(Target: String, Player: Node3D, castPullController: CastPullSystem) -> void:
	var direction = (castPullController.hookedFish.global_position - Player.global_position).cross(Vector3.RIGHT).normalized() * -10
	castPullController.hookedFish.linear_velocity = direction
	print("!!!! UP reel combo 01 !!!! @: ")
