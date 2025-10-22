class_name enviromentalHazzard
extends Area3D

@export var health: int = 40
@export var enviromentCollisionDamage: int = 10
@export var currentMeshInstance: MeshInstance3D
@export var meshInstance: Array[MeshInstance3D]
@export var meshCollisionShape: CollisionShape3D
