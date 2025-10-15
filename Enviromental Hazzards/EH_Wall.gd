class_name EHWall
extends enviromentalHazzard


func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.get_script() == enemyFish: #or body.get_parent().get_script() == PlayerController:
		print("wall hit")
		var healthNode: HealthHandler = body.get_node_or_null("HealthHandler")
		print(healthNode)
		if healthNode and healthNode.has_method("apply_damage"):
			print("im a wall with: ", enviromentCollisionDamage, " damage ")
			healthNode.apply_damage(enviromentCollisionDamage, 1, true)
			#damage_value: int, damage_type: int, is_player_owned: bool
		pass
