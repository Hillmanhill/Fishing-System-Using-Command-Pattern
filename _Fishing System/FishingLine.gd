class_name ropeVisual
extends Node3D

var castObject : Node3D
var castPoint: Node3D
@export var maxLength : float = 15
@export var slackLength : float = 5

var segmentLengthDivide: int = 8
var springStiffnessWeight: int = 50

var isObjectCast : bool = false

var ropeSegments: Array[RigidBody3D] = []
var mesh : ImmediateMesh

func _ready() -> void:
	mesh = ImmediateMesh.new()
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1,0,0)
	var meshInstance: MeshInstance3D = MeshInstance3D.new()
	meshInstance.mesh = mesh
	get_tree().current_scene.add_child.call_deferred(meshInstance)

func _process(delta):
	if isObjectCast: 
		var im = mesh as ImmediateMesh
		im.clear_surfaces()
		im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
		im.surface_add_vertex(castObject.global_position)
		
		if ropeSegments.size() > 0:
			for segment in ropeSegments:
				if is_instance_valid(segment):
					im.surface_add_vertex(segment.global_position)
		im.surface_end()

func create_rope(start: Node3D, end: Node3D, segmentCount: int):
	var last = start
	castObject = start
	castPoint = end
	isObjectCast = true
	for i in segmentCount:
		await get_tree().create_timer(.1).timeout
		var segment = preload("res://_Fishing System/ropeSegment.tscn").instantiate()
		var direction = end.global_position - start.global_position
		
		direction.y -= 1
		segment.linear_velocity = -direction.normalized() * 8
		segment.global_position = end.global_position
		get_tree().current_scene.add_child(segment)
		ropeSegments.append(segment)
		var joint = Generic6DOFJoint3D.new()
		
		var segmentVector = segment.global_position - last.global_position
		var segmentLength = segmentVector.length()
		var axis = segmentVector.normalized()
		
		joint.node_a = last.get_path()
		joint.node_b = segment.get_path()
		
		joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
		joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
		
		joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
		joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
		
		joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, true)
		joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
		
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -abs(axis.x * segmentLength)/ segmentLengthDivide)
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, abs(axis.x * segmentLength)/ segmentLengthDivide)
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -abs(axis.y * segmentLength)/ segmentLengthDivide)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, abs(axis.y * segmentLength)/ segmentLengthDivide)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, -abs(axis.z * segmentLength)/ segmentLengthDivide)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT, abs(axis.z * segmentLength)/ segmentLengthDivide)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		get_tree().current_scene.add_child(joint)
		last = segment
	
	last.global_position = end.global_position
	
	var final_joint = Generic6DOFJoint3D.new()
	final_joint.node_a = last.get_path()
	final_joint.node_b = end.get_path()
	add_child(final_joint)

func reel_in(amount: float):
	slackLength = max(slackLength - amount, 0.0)
	var segmentCount: int = ropeSegments.size()
	if segmentCount == 0:return
	
	var start_pos = global_position
	var end_pos = castObject.global_position
	var effective_length = slackLength
	
	for i in range(segmentCount):
		var t = float(i) / float(segmentCount)
		var segment_pos = end_pos.lerp(start_pos, t + (effective_length / maxLength))
		var segment = ropeSegments[i]
		if is_instance_valid(segment):
			segment.global_position = segment_pos

func destroy_rope():
	for i in ropeSegments:
		i.queue_free()
	ropeSegments.clear()
	isObjectCast = false
