extends CSGBox3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("MoveLeftRight")

func _on_area_3d_body_entered(body: PlayerController) -> void:
	#if body.get_script() == PlayerController or enemyFish:
		body.reparent(self)
		print("collison to body")

#func _on_area_3d_body_exited(body: PlayerController) -> void:
#	if body.get_script() == PlayerController or enemyFish:
#		body.reparent(get_parent())
#		print("body removed")
