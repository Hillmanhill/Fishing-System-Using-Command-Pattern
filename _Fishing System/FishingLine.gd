class_name ropeVisual
extends Node3D

var castObject : Node3D
@export var maxLength : float = 15
@export var slackLength : float = 5

var segmentLengthDivide: int = 8
var springStiffnessWeight: int = 0

var isObjectCast : bool = false

var ropeSegments: Array[RigidBody3D] = []
var segmentcount: int
var mesh : ImmediateMesh

func _ready() -> void:
	mesh = ImmediateMesh.new()
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1,0,0)
	var meshInstance: MeshInstance3D = MeshInstance3D.new()
	meshInstance.mesh = mesh
	get_tree().current_scene.add_child.call_deferred(meshInstance)

func _process(delta):
	if isObjectCast and ropeSegments.size() == segmentcount: 
		var im = mesh as ImmediateMesh
		im.clear_surfaces()
		im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
		im.surface_add_vertex(castObject.global_position)
		
		if ropeSegments.size() > 0:
			for segment in ropeSegments:
				if is_instance_valid(segment):
					im.surface_add_vertex(segment.global_position)
		im.surface_end()

func create_rope(Bobber: Node3D, castPoint: Node3D, segmentCount: int):
	
	castObject = Bobber
	isObjectCast = true
	
	var last = Bobber
	var ropeVector = castPoint.global_position - Bobber.global_position
	var lengthPerSegment = ropeVector.length() / segmentCount
	
	for i in segmentCount:
		await get_tree().create_timer(.1).timeout
		var segment: RigidBody3D = preload("res://_Fishing System/ropeSegment.tscn").instantiate()
		var segmentPosition = ropeVector + castPoint.global_position * lengthPerSegment * (i + 1)
		segment.global_position = castPoint.global_position #segmentPosition
		
		get_tree().current_scene.add_child(segment)
		ropeSegments.append(segment)
		
		var joint = Generic6DOFJoint3D.new()
		
		joint.node_a = last.get_path()
		joint.node_b = segment.get_path()
		joint.global_position = segment.global_position
		
		for axis in [Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING]:
			joint.set_flag_x(axis, true)
			joint.set_flag_y(axis, true)
			joint.set_flag_z(axis, true)
		
		var limit = lengthPerSegment * .1
		
		for axis in  [Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT, Generic6DOFJoint3D.PARAM_LINEAR_UPPER_LIMIT]:
			joint.set_param_x(axis, -lengthPerSegment if axis == Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT else lengthPerSegment)
			joint.set_param_y(axis, -lengthPerSegment if axis == Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT else lengthPerSegment)
			joint.set_param_z(axis, -lengthPerSegment if axis == Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT else lengthPerSegment)#
			
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		get_tree().current_scene.add_child(joint)
		last = segment
		segmentcount += 1
	
	last.global_position = castPoint.global_position
	
	var final_joint = Generic6DOFJoint3D.new()
	final_joint.node_a = ropeSegments[-1].get_path()
	final_joint.node_b = castPoint.get_path()
	add_child(final_joint)

func reel_in(amount: float):
	slackLength = max(slackLength - amount, 0.0)
	var segmentCount: int = ropeSegments.size()
	if segmentCount == 0:return
	
	var Bobber_pos = global_position
	var end_pos = castObject.global_position
	var effective_length = slackLength
	
	for i in range(segmentCount):
		var t = float(i) / float(segmentCount)
		var segment_pos = end_pos.lerp(Bobber_pos, t + (effective_length / maxLength))
		var segment = ropeSegments[i]
		if is_instance_valid(segment):
			segment.global_position = segment_pos

func destroy_rope():
	for i in ropeSegments:
		i.queue_free()
	segmentcount = 0
	ropeSegments.clear()
	isObjectCast = false
