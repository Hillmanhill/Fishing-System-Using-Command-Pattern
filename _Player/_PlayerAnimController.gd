class_name playerAnimStates
extends Node

@export var PlayerAnimationPlayer: AnimationPlayer
@export var playerInputHandler: inputHandlerController

enum animStates {
	idle, walk, sprint, jump,
	
	cast,
	castLeft, castRight,
	castForwrd, castBackward,
	
	lightAttack, heavyAttack,
}

func execute_animation_state(animStateinput: animStates, _command: String):
	#match animStateinput:
	#	animStates.idle:
	#		print("Player IDLE" if playerInputHandler.inCombat == false else "COMBAT Player IDLE")
	#	
	#	animStates.cast:
	#		print("Player CAST" if playerInputHandler.inCombat == false else "COMBAT Player CAST")
	#	animStates.castLeft:
	#		print("Player cast LEFT" if playerInputHandler.inCombat == false else "COMBAT Player cast LEFT")
	#	animStates.castRight:
	#		print("Player cast RIGHT" if playerInputHandler.inCombat == false else "COMBAT Player cast RIGHT")
	#	animStates.castForwrd:
	#		print("Player cast FORWARD" if playerInputHandler.inCombat == false else "COMBAT Player cast FORWARD")
	#	animStates.castBackward:
	#		print("Player cast Backward" if playerInputHandler.inCombat == false else "COMBAT Player cast Backward")
	#	
	#	animStates.sprint:
	#		print("Player SPRINTING" if playerInputHandler.inCombat == false else "COMBAT Player SPRINTING")
	#		PlayerAnimationPlayer.play("General_Player/Grounded_Run")
	#	animStates.walk:
	#		print("Player WALKING" if playerInputHandler.inCombat == false else "COMBAT Player WALKING")
	#		PlayerAnimationPlayer.play("General_Player/Grounded_Walk")
	#	animStates.jump:
	#		print("Player JUMP")
	#	
	#	_:
	#		print("Player IDLE" if playerInputHandler.inCombat == false else "COMBAT Player IDLE")
	pass
