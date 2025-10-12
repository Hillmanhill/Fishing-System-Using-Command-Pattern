class_name playerAnimStates
extends Node

@export var PlayerAnimationPlayer: AnimationPlayer
@export var playerInputHandler: inputHandlerController
@onready var animationTree: AnimationTree = $AnimationTree

enum animStates {
	idle, walk, sprint, jump,
	
	cast,
	castLeft, castRight,
	castForwrd, castBackward,
	
	lightAttack, heavyAttack,
}

var allconditions : = ["isMoving", "isAttack", "isReelingFish", "isCast", "isJump"]
var allStates : = {"isReelingFish": "FISHING_Player_Grounded_reelSet", "isMoving": "General_Player_Walk_Run", "isAttack": "COMBAT_PlayerSword_AIR_Attacks" }

func _ready() -> void:
	animationTree.active = true

func transition_to(state_name: String, blendValue: Vector2):
	
	for cond in allconditions:
		animationTree.set("parameters/conditions/"+ cond, cond == state_name)
	
	var activeState = allStates.get(state_name)
	print("active state: ", activeState)
	
	if activeState != null:
		animationTree.set("parameters/" + activeState + "/blend_position", blendValue)
		print("blende pos: ",animationTree.get("parameters/" + activeState + "/blend_position"))
		
	else:
		print("Invalid state:", state_name)

func execute_animation_state(animStateinput: animStates, blendValue: Vector2):
	match animStateinput:
		animStates.idle:
			#print("Player IDLE" if playerInputHandler.inCombat == false else "COMBAT Player IDLE")
			transition_to("isMoving", blendValue)
		animStates.cast:
			transition_to("isCast", blendValue)
		animStates.castLeft:
			transition_to("isReelingFish", blendValue)
		animStates.castRight:
			transition_to("isReelingFish", blendValue)
		animStates.castForwrd:
			transition_to("isReelingFish", blendValue)
		animStates.castBackward:
			transition_to("isReelingFish", blendValue)
		
		animStates.lightAttack:
			transition_to("isAttack", blendValue)
		animStates.heavyAttack:
			transition_to("isAttack", blendValue)
		
		animStates.sprint:
			transition_to("isMoving",blendValue)
		animStates.walk:
			transition_to("isMoving",blendValue)
		animStates.jump:
			transition_to("isJump",blendValue)
		_:
			transition_to("isMoving",blendValue)
