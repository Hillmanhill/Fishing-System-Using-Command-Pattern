extends Node3D

@export var terrainChunksScene: Array[PackedScene] = []
@export var chunkSpacing: Vector3 = Vector3(30,0,30)
@export var scrollSpeed: float = 5
@export var spawnDistance: float = 200
@export var cullDistance: float =205
var scrollOrigin: Vector3
var terrainChunk := {}

func _ready() -> void:
	scrollOrigin = global_position

func _process(delta: float) -> void:
	scrollOrigin -= Vector3(scrollSpeed * delta,0,0)
	var scrollOffset = Vector3(scrollSpeed * delta,0,0)
	var chunksToRemove: Array = []
	
	for pos in terrainChunk.keys():
		var chunk = terrainChunk[pos]
		chunk.global_position -= scrollOffset
		if chunk.global_position.distance_to(global_position) > cullDistance:
			chunksToRemove.append(pos)
	
	for pos in chunksToRemove:
		terrainChunk[pos].queue_free()
		terrainChunk.erase(pos)
	
	_spawn_chunks()

func _spawn_chunks():
	var halfX = int(spawnDistance / chunkSpacing.x) +1
	var halfZ = int(spawnDistance / chunkSpacing.z) +1
	
	for x in range(-halfX, halfX +1):
		for z in range(-halfZ, halfZ +1):
			var worldPos = Vector3(x * chunkSpacing.x, 0, z * chunkSpacing.z)
			var gridPos = get_snapped_key(worldPos)
			
			if worldPos.distance_to(global_position) > spawnDistance: continue
			if not terrainChunk.has(gridPos):
				var chunk = terrainChunksScene.pick_random().instantiate()
				add_child(chunk)
				chunk.global_position = worldPos
				terrainChunk[gridPos] = chunk

func get_snapped_key(world_pos: Vector3) -> Vector3:
	var reletivePos = world_pos - scrollOrigin
	return Vector3(
	floor(reletivePos.x / chunkSpacing.x),
	floor(reletivePos.y / chunkSpacing.y),
	floor(reletivePos.z / chunkSpacing.z))
