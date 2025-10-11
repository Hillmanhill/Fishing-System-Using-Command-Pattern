class_name ropeVisual
extends Node3D

var castObject : RigidBody3D
@export var reelPoint: Node3D
var castedPoint: Node3D
var mesh : ImmediateMesh

var ropeSegments: Array[RigidBody3D] = []
var segmentcount: int
@export var maxLength : float = 5
@export var slackLength : float = 5
var springStiffnessWeight: int = 0.12
var ropeJoints : Array[Generic6DOFJoint3D] = []
var isObjectCast : bool = false

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

func _physics_process(delta: float) -> void:
	for i in ropeSegments.size():
		if i == 0 or i - 1 >= ropeJoints.size(): continue
		var segA = ropeSegments[i - 1]
		var segB = ropeSegments[i]
		var joint = ropeJoints[i - 1]
		
		if joint == null or not is_instance_valid(joint): continue
		var dist = segA.global_position.distance_to(segB.global_position)
		
		if dist > maxLength / segmentcount:
			var tension = clamp((dist - (maxLength / segmentcount)) * 10, 0, 100)
			joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, tension)
			joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, tension)
			joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, tension)
		
		if castObject.global_position.distance_to(reelPoint.global_position) > segmentcount * 1.5 + 5:
			reel_in(1)
			pull_in_by_distance(6)

func create_rope(Bobber: Node3D, castPoint: Node3D, segmentCount: int):
	castObject = Bobber
	castedPoint = castPoint
	isObjectCast = true
	segmentcount = 0
	var last = Bobber
	var ropeVector = castPoint.global_position - Bobber.global_position
	var lengthPerSegment = ropeVector.length() / segmentCount
	
	for i in segmentCount:
		await get_tree().create_timer(.1).timeout
		var segment: RigidBody3D = preload("res://_Fishing System/Line And Bobber/ropeSegment.tscn").instantiate()
		var t : float = float(i + 1) / float(segmentcount +1)
		segment.global_position = Bobber.global_position.lerp(castPoint.global_position, t)
		ropeSegments.append(segment)
		get_tree().current_scene.add_child(segment)
		
		var joint = Generic6DOFJoint3D.new()
		joint.name = "JointTo_" + str(i)
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
			joint.set_param_z(axis, -lengthPerSegment if axis == Generic6DOFJoint3D.PARAM_LINEAR_LOWER_LIMIT else lengthPerSegment)
		
		joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		ropeJoints.append(joint)
		get_tree().current_scene.add_child(joint)
		last = segment
		segmentcount += 1
	
	var final_joint = Generic6DOFJoint3D.new()
	final_joint.node_a = ropeSegments.back().get_path()
	final_joint.node_b = castPoint.get_path()
	
	final_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	final_joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	final_joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	
	ropeJoints.append(final_joint)
	add_child(final_joint)

func pull_in_by_distance(pullStrength):
	var pullDir = (reelPoint.global_position - castObject.global_position).normalized()
	castObject.apply_central_force(pullDir * pullStrength)

func reel_in(amount: float):
	slackLength = max(slackLength - amount, 0.0)
	var segmentCount: int = ropeSegments.size()
	if segmentCount == 0 : return
	var reelPOS = reelPoint.global_position
	var bobberPOS = castObject.global_position
	var effective_length = slackLength
	
	for i in range(segmentCount):
		var t = float(i) / float(segmentCount)
		var segment_pos = bobberPOS.lerp(reelPOS, t + (effective_length / maxLength))
		var segment = ropeSegments[i]
		segment.linear_velocity = Vector3.ZERO
		if is_instance_valid(segment):
			segment.global_position = segment_pos

func append_segments_to_current(count: int):
	if ropeSegments.size() == 0 or castObject == null: return
	var lastSegment = ropeSegments.back()
	var ropeVector = castedPoint.global_position - lastSegment.global_position
	var lengthPerSegment = ropeVector.length() / count
	
	if ropeJoints.size() > 0:
		var old_finalJoint = ropeJoints.pop_back()
		if is_instance_valid(old_finalJoint):
			old_finalJoint.queue_free()
	
	if ropeSegments.size() >= 2:
		var firstLast = ropeSegments.back()
		var secondLast = ropeSegments[ropeSegments.size() - 2]
		var seperationDir = (secondLast.global_position - firstLast.global_position).normalized()
		var spacing = (secondLast.global_position.distance_to(firstLast.global_position))
		firstLast.global_position = secondLast.global_position + seperationDir * spacing
	
	for i in count:
		await get_tree().create_timer(0.15).timeout
		var segment: RigidBody3D = preload("res://_Fishing System/Line And Bobber/ropeSegment.tscn").instantiate()
		var segmentPosition = ropeVector.normalized() * lengthPerSegment * (i + 1)
		segment.global_position = lastSegment.global_position + segmentPosition
		ropeSegments.append(segment)
		get_tree().current_scene.add_child(segment)
		var joint = Generic6DOFJoint3D.new()
		joint.name = "JointTo_" + str(i)
		joint.node_a = lastSegment.get_path()
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
		
		joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 2)
		joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
		
		ropeJoints.append(joint)
		get_tree().current_scene.add_child(joint)
		lastSegment = segment
		segmentcount += 1
	
	var final_joint = Generic6DOFJoint3D.new()
	final_joint.node_a = ropeSegments.back().get_path()
	final_joint.node_b = castedPoint.get_path()
	
	final_joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
	final_joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	final_joint.set_param_y(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	final_joint.set_param_z(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, springStiffnessWeight)
	
	ropeJoints.append(final_joint)
	add_child(final_joint)

func remove_last_segment():
	if ropeSegments.size() == 1:
		destroy_rope()
	
	if ropeSegments.size() > 0:
		var lastSegment = ropeSegments.pop_back()
		var lastJoint = ropeJoints.pop_back()
		for child in get_tree().current_scene.get_children():
			if child is Generic6DOFJoint3D:
				if child.node_b == lastSegment.get_path():
					child.queue_free()
					break
		lastSegment.queue_free()
		segmentcount = ropeSegments.size()
		
		var newJoint = Generic6DOFJoint3D.new()
		ropeSegments.back().global_position = castedPoint.global_position
		newJoint.node_a = ropeSegments.back().get_path()
		newJoint.node_b = castedPoint.get_path()
		add_child(newJoint)
		pull_in_by_distance(50)

func destroy_rope():
	for i in ropeSegments:
		i.queue_free()
	ropeSegments.clear()
	isObjectCast = false
	mesh.clear_surfaces()
