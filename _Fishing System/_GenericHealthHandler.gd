class_name HealthHandler
extends Node

@export var health: int = 100
@export var is_enemy: bool = false
@export var is_player: bool = false
@export var ResistTypes: Array[String]

func apply_damage(damage_value: int, damage_type: int, is_player_owned: bool):
	print("Apply Damage triggered")
	if is_player_owned and is_enemy:
		var actual_damage := calculate_damage(damage_value, damage_type)
		health -= actual_damage
		print("enemy health: ", health)
		if health <= 0:
			print("enemy dead")
			#get_parent().queue_free()
			
			#add death state call for fish
			
	elif not is_player_owned and is_player:
		var actual_damage := calculate_damage(damage_value, damage_type)
		health -= actual_damage
		print("my health: ", health)
		if health <= 0:
			print("Player Dead")
			get_tree().change_scene_to_file("res://Scenes/Menus/StartMenuScene.tscn")

func calculate_damage(base_damage: int, damage_type: int) -> int:
	match damage_type:
		0: return base_damage * (0.7 if is_resistant("PHYSICAL") else 1.3)
		1: return base_damage * (0.7 if is_resistant("ARCANE") else 1.3)
		2: return base_damage * (0.7 if is_resistant("WATER") else 1.3)
		3: return base_damage * (0.7 if is_resistant("FIRE") else 1.3)
		4: return base_damage * (0.7 if is_resistant("WIND") else 1.3)
		5: return base_damage * (0.7 if is_resistant("ICE") else 1.3)
		6: return base_damage * (0.7 if is_resistant("POSION") else 1.3)
		7: return base_damage * (0.7 if is_resistant("ELECTRIC") else 1.3)
		8: return base_damage * (0.7 if is_resistant("BLAST") else 1.3)
		9: return base_damage
		_: return base_damage

func is_resistant(type: String) -> bool:
	return type in ResistTypes

func process_status_effects(effects: Array):
	for effect in effects:
		match effect:
			pass
