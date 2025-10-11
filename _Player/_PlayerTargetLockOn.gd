class_name PlayerTargetLockOn
extends Node3D

@export var player : PlayerController
@export var playerCamera : Camera3D
@export var LockOnVisual : Node3D = null

var targetClass : enemyFish
@export var currentTarget : RigidBody3D
var AvalibeTargets : Array[RigidBody3D] = []
var targetIndex : int = -1
@export var maxLockDistance : float = 30

@export var enemyContainer : Node

func _ready() -> void:
	LockOnVisual = preload("res://_Player/LockOnVisual.tscn").instantiate()
	LockOnVisual.scale = Vector3(0.1,0.1,0.1)
	add_child(LockOnVisual)

func find_targetable_nodes(root: Node) -> Array[RigidBody3D]:
	var found : Array[RigidBody3D] = []
	for child in root.get_children(false):
		if child is enemyFish :
			found.append(child)
		found += find_targetable_nodes(child)
	return found

func is_occluded(from: Vector3, to: Vector3) -> bool:
	var physicParm : PhysicsRayQueryParameters3D= PhysicsRayQueryParameters3D.new()
	physicParm.from = from
	physicParm.to = to
	physicParm.exclude = [self, playerCamera]
	physicParm.collision_mask = 1
	var space_state = playerCamera.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(physicParm)
	
	if result.is_empty():
		return false
	var hitPosition = result.position
	var targetDistance = from.distance_to(to)
	var hitDistance = from.distance_to(hitPosition)
	return hitDistance < targetDistance - 0.1

func update_targets():
	AvalibeTargets.clear()
	var spaceState = playerCamera.get_world_3d().direct_space_state
	var frustum = playerCamera.get_frustum()
	var all_nodes = find_targetable_nodes(enemyContainer)
	for node in all_nodes:
		var pos = node.global_position
		if playerCamera.is_position_behind(pos):
			continue
		if not playerCamera.is_position_in_frustum(pos):
			continue
		#if is_occluded(player.global_position, pos):
		#	print("bhjkadfsbhjkads")
		#	continue
		var dist = global_position.distance_to(pos)
		if dist <= maxLockDistance:
			AvalibeTargets.append(node)
	AvalibeTargets.sort_custom(func(a, b):return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))

func lock_onto_closest():
	update_targets()
	if AvalibeTargets.is_empty():
		currentTarget = null
		targetIndex = -1
		return
	currentTarget = AvalibeTargets[0]
	targetIndex = 0
	highlight_target(currentTarget)

func cycle_target(forward:= true):
	update_targets()
	if AvalibeTargets.is_empty():
		return
	targetIndex += (1 if forward else -1)
	targetIndex = wrapi(targetIndex, 0, AvalibeTargets.size())
	currentTarget = AvalibeTargets[targetIndex]
	highlight_target(currentTarget)

func highlight_target(target: Node3D):
	LockOnVisual.global_position = target.global_position
	LockOnVisual.reparent(target)
	LockOnVisual.scale = Vector3(1,1,1)
	print("Target Lock: ", target.name)

func unlock_Target():
	LockOnVisual.global_position = player.global_position
	#LockOnVisual.global_rotation = player.global_rotation
	LockOnVisual.reparent(player)
	LockOnVisual.scale = Vector3(0.1,0.1,0.1)
	currentTarget = null
