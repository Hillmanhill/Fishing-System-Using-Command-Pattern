class_name enemyFish
extends RigidBody3D

@export var weight: float = 1
@export var health: int = 100
@export var size: float = 1
@export var normalDamage: int = 10
@export var highDamage: int = 30

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
	print("Active timer TICK")
