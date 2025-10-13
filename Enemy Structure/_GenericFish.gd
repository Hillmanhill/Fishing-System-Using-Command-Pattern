class_name enemyFish
extends RigidBody3D

@export var weight: float = 1
@export var health: int = 100
@export var size: float = 1
@export var normalDamage: int = 10
@export var highDamage: int = 30
@export var fishCollisionDamage: int = 5

var activeTimer: Timer = Timer.new()

@export var targetLockPoints: Array[Node3D] = []

func _ready() -> void:
	self.mass = weight
	print("Fish Weight: ",mass)
	
	add_child(activeTimer)
	activeTimer.wait_time = randi_range(10, 30)
	activeTimer.one_shot = false
	activeTimer.autostart = true
	activeTimer.connect("timeout", Callable(self, "_on_active_timeout"))
	activeTimer.start()

func _on_active_timeout():
	health_check()

func health_check():
	print(name, " health: ", health)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	#check fish velocity
	#check if fish had collided with enviromantal hazzard
	#apply enviromental damage to fish and apply fish collision damage to enviroment
	
	#check if fish has collided with another fish
	#if fish has hit shich check fish collision damage 
	#apply highest damage to the fish who has lowest collision damage 


	pass # Replace with function body.
