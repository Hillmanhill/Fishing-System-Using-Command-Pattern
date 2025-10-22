class_name EHWall
extends enviromentalHazzard

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	currentMeshInstance = meshInstance[0]

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.get_script() == enemyFish: #or body.get_parent().get_script() == PlayerController:
		var healthNode: HealthHandler = body.get_node_or_null("HealthHandler")
		print("wall hit with: ", healthNode)
		if healthNode and healthNode.has_method("apply_damage"):
			print("im a wall with: ", enviromentCollisionDamage, " damage ")
			healthNode.apply_damage(enviromentCollisionDamage, 0, true)
			#damage_value: int, damage_type: int, is_player_owned: bool
			health -= 10
			if health >= 30:
				currentMeshInstance.mesh = meshInstance[1].mesh
			elif health >= 20:
				currentMeshInstance.mesh = meshInstance[2].mesh
			elif health >= 10:
				currentMeshInstance.mesh = meshInstance[3].mesh
