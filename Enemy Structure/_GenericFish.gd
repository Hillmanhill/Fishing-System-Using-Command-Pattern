class_name enemyFish
extends RigidBody3D

@export var weight: float = 1
@export var initalHealth: int = 100
@export var size: float = 1
@export var normalDamage: int = 10
@export var highDamage: int = 30
@export var fishCollisionDamage: int = 5

var activeTimer: Timer = Timer.new()
@export var healthHandler: HealthHandler

@export var targetLockPoints: Array[Node3D] = []

func _ready() -> void:
	self.mass = weight
	print("Fish Weight: ",mass)
	healthHandler.health = initalHealth
	add_child(activeTimer)
	activeTimer.wait_time = randi_range(10, 30)
	activeTimer.one_shot = false
	activeTimer.autostart = true
	activeTimer.connect("timeout", Callable(self, "_on_active_timeout"))
	activeTimer.start()

func _on_active_timeout():
	#health_check()
	pass

func health_check():
	print(name, " health: ", initalHealth)

	#check fish velocity
	#check if fish had collided with enviromantal hazzard
	#apply enviromental damage to fish and apply fish collision damage to enviroment
	
	#check if fish has collided with another fish
	#if fish has hit shich check fish collision damage 
	#apply highest damage to the fish who has lowest collision damage 
