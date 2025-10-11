class_name playerAnimStates
extends Node

@export var PlayerAnimationPlayer: AnimationPlayer
@export var playerInputHandler: inputHandlerController
@export var animationTree: AnimationTree
@export var animtionStatePath: String = "parameters/playback"

enum animStates {
	idle, walk, sprint, jump,
	
	cast,
	castLeft, castRight,
	castForwrd, castBackward,
	
	lightAttack, heavyAttack,
}

var allconditions : = ["isIdle","isRunning","isWalking","isJump", "isLightAttack","isHeavyAttack", "isCast","isCastLEFT","isCastRIGHT","isCastFORWARD","isCasBACKWARD"]

func _ready() -> void:
	animationTree.active = true

func transition_to(state_name: String):
	for cond in allconditions:
		animationTree.set("parameters/conditions/"+ cond, cond == state_name)
	
func execute_animation_state(animStateinput: animStates, _command: String):
	match animStateinput:
		animStates.idle:
			#print("Player IDLE" if playerInputHandler.inCombat == false else "COMBAT Player IDLE")
			transition_to("isIdle")
		animStates.cast:
			#print("Player CAST" if playerInputHandler.inCombat == false else "COMBAT Player CAST")
			transition_to("isCast")
		animStates.castLeft:
			#print("Player cast LEFT" if playerInputHandler.inCombat == false else "COMBAT Player cast LEFT")
			transition_to("isCastLEFT")
		animStates.castRight:
			#print("Player cast RIGHT" if playerInputHandler.inCombat == false else "COMBAT Player cast RIGHT")
			transition_to("isCastRIGHT")
		animStates.castForwrd:
			#print("Player cast FORWARD" if playerInputHandler.inCombat == false else "COMBAT Player cast FORWARD")#
			transition_to("isCastFORWARD")
		animStates.castBackward:
			#print("Player cast Backward" if playerInputHandler.inCombat == false else "COMBAT Player cast Backward")
			transition_to("isCastBACKWARD")
		
		animStates.lightAttack:
			#transition_to("isLightAttack")
			print("light attack")
		animStates.heavyAttack:
			#transition_to("isHeavyAttack")
			print("heavy attack")
		
		animStates.sprint:
			#print("Player SPRINTING" if playerInputHandler.inCombat == false else "COMBAT Player SPRINTING")
			transition_to("isRunning")
		animStates.walk:
			#print("Player WALKING" if playerInputHandler.inCombat == false else "COMBAT Player WALKING")
			transition_to("isWalking")
		animStates.jump:
			#print("Player JUMP")
			transition_to("isJump")
		_:
			#print("Player IDLE" if playerInputHandler.inCombat == false else "COMBAT Player IDLE")
			transition_to("isIdle")
