class_name CommandActionHandler extends Node

@export var player: PlayerController
@export var castPullController: inputHandlerController

var commandQueue : Array = []
var undoStack : Array = []

var comboBuffer: Array[String] = []
var comboDefinitions: Dictionary = {}
var comboReady: bool = false
var pendingCombo: CommandAction

var clearTimer: Timer = Timer.new()

@export var AttackTimeEplase: float = 0.5
@export var attackTimeWindow: float = .25

var canAttackBetweenTime: bool = false

func _ready() -> void:
	add_child(clearTimer)
	clearTimer.wait_time = AttackTimeEplase
	clearTimer.one_shot = true
	clearTimer.connect("timeout", Callable(self, "_on_combo_timeout"))

func _process(delta: float) -> void:
	if clearTimer.time_left >= attackTimeWindow:
		canAttackBetweenTime = true

func register_combo(sequence: Array[String], combo_action: CommandAction) -> void:
	comboDefinitions[sequence] = combo_action
	#print("callback: ",combo_action)

func add_command(cmd: CommandAction, target: String)-> void: 
	var id_data = cmd.get_id()
	comboBuffer.append(id_data["ACID"])
	_Update_attack_timer(id_data)
	
	if comboReady and pendingCombo != null and cmd.get_id()["ACID"] == pendingCombo.get_id()["ACID"]:
		commandQueue.append({"cmd": pendingCombo, "target": target})
		comboReady = false
		pendingCombo = null
		comboBuffer.clear()
		restart_combo_timer()
		return
	else:
		comboReady = false
		pendingCombo = null
	
	if undoStack.size() > 0:
		var lastCmd: CommandAction = undoStack[-1]["cmd"]
		for sequence in lastCmd.nextComboBranch.keys():
			if comboBuffer.size() >= sequence.size():
				var recent := comboBuffer.slice(comboBuffer.size() - sequence.size(), comboBuffer.size())
				if recent == sequence:
					var nextComboAction = lastCmd.nextComboBranch[sequence].new()
					pendingCombo = nextComboAction
					comboReady = true
					#print("Matched continuation branch:", sequence)
					break
	commandQueue.append({"cmd": cmd, "target": target})
	if not comboReady:
		check_combos()
	restart_combo_timer()

func check_combos():
	for sequence in comboDefinitions.keys():
		if comboBuffer.size() >= sequence.size():
			var recent := comboBuffer.slice(comboBuffer.size() - sequence.size(), comboBuffer.size())
			if recent == sequence:
				pendingCombo = comboDefinitions[sequence]
				comboReady = true
				comboBuffer.clear()
				return

func execute_next() -> void:
	if commandQueue.is_empty():
		return
	var current = commandQueue.pop_front()
	var cmd = current["cmd"]
	current["cmd"].execute(current["target"], player, castPullController)
	undoStack.append(current)
	
	for sequence in cmd.nextComboBranch.keys():
		if comboBuffer.size() >= sequence.size():
			var recent := comboBuffer.slice(comboBuffer.size() - sequence.size(), comboBuffer.size())
			if recent == sequence:
				var nextComboAction = cmd.nextComboBranch[sequence].new()
				pendingCombo = nextComboAction
				comboReady = true
				#print("Matched continuation branch:", sequence)
				break
		comboBuffer.clear()
		restart_combo_timer()

func  undo_Last() -> void:
	if undoStack.is_empty():
		return
	var current = undoStack.pop_back()
	current["cmd"].execute(current["target"])

func _is_combo_trigger_input(cmd: CommandAction) -> bool:
	if cmd.get_id()["ACID"] == pendingCombo.get_id()["ACID"]:
		return true
	return false

func _Update_attack_timer(id_data: Dictionary) -> void:
	if id_data.has("attackTime"):
		AttackTimeEplase = id_data["attackTime"]
	if id_data.has("avalibleTime"):
		attackTimeWindow = id_data["avalibleTime"]

func restart_combo_timer():
	clearTimer.stop()
	clearTimer.wait_time = AttackTimeEplase
	canAttackBetweenTime = false
	clearTimer.start()

func _on_combo_timeout() -> void:
	canAttackBetweenTime = false
	comboBuffer.clear()

func _on_temp_ececute_handler_timeout() -> void:
	execute_next()
