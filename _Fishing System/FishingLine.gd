class_name ropeVisual
extends Node3D

@export var castObject : Node3D
@export var maxLength : float = 1
@export var slackLength : float = 1

var ropeSegments: Array[RigidBody3D] = []
var mesh : ImmediateMesh

func _ready() -> void:
	mesh = ImmediateMesh.new()
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1,0,0)
	var meshInstance: MeshInstance3D = MeshInstance3D.new()
	meshInstance.mesh = mesh
	get_tree().current_scene.add_child.call_deferred(meshInstance)
	#create_rope(self, target, 5)
	#set_surface_override_material(0, mat)

func _process(delta):
	var im = mesh as ImmediateMesh
	im.clear_surfaces()
	im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	im.surface_add_vertex(castObject.global_position)
	
	if ropeSegments.size() > 0:
		for segment in ropeSegments:
			if is_instance_valid(segment):
				im.surface_add_vertex(segment.global_position)
				#im.surface_add_vertex(segment.global_position + Vector3(1,0,0))
	#im.surface_add_vertex(global_position)
	im.surface_end()

func create_rope(start: Node3D, end: Node3D, segmentCount: int):
	var last = start
	#target = end
	await get_tree().create_timer(.2).timeout
	for i in segmentCount:
		
		var t = float(i) / float(segmentCount)
		var segmentPos = start.global_position.lerp(end.global_position, t)
		
		var segment = preload("res://_Fishing System/ropeSegment.tscn").instantiate()
		segment.linear_velocity.y = 10
		segment.linear_velocity.x = 5
		segment.global_position = segmentPos
		get_tree().current_scene.add_child(segment)
		ropeSegments.append(segment)
		
		var joint = Generic6DOFJoint3D.new()
		get_tree().current_scene.add_child(joint)
		
		joint.node_a = last.get_path()
		joint.node_b = segment.get_path()
		
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, 0)
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, .2)
		
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, 0)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, .2)
		
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, 0)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, .2)
		
		last = segment
	
	var final_joint = PinJoint3D.new()
	final_joint.node_a = last.get_path()
	final_joint.node_b = end.get_path()
	add_child(final_joint)
	
	print(end)
	print("Segments:", ropeSegments.size())
	print("Is inside tree:", is_inside_tree())

func destroy_rope():
	for i in ropeSegments:
		i.queue_free()
	ropeSegments.clear()

func reel_in(amount: float):
	slackLength = max(slackLength - amount, 0.0)
	var segmentCount = ropeSegments.size()
	if segmentCount == 0:
		return
	
	var start_pos = global_position
	var end_pos = castObject.global_position
	var effective_length = slackLength
	
	for i in range(segmentCount):
		var t = float(i) / float(segmentCount)
		var segment_pos = start_pos.lerp(end_pos, t * (effective_length / maxLength))
		var segment = ropeSegments[i]
		if is_instance_valid(segment):
			segment.global_position = segment_pos
