extends Node2D

@export var screws: Array[Node]
@export var screen_name: StringName

@onready var state_manager: Node = get_tree().get_first_node_in_group("Jogo").state_manager

func _ready() -> void:
	var remaining: int = screws.size()
	while remaining > 0:
		remaining -= 1
		screws[remaining].loose = state_manager.screw_states[screen_name][remaining]
		screws[remaining].changed.connect(on_screw_changed.bind(remaining))
		
	if get_unscrewed() > 0:
		AudioManager.play_global("screw.loose")

func on_screw_changed(state: bool, screw: int) -> void:
	if get_unscrewed() == 0:
		AudioManager.stop_global("screw.loose")

	state_manager.screw_states[screen_name][screw] = state

func get_unscrewed() -> int:
	var amount: int = 0
	for screw in screws:
		if screw.loose:
			amount += 1
	return amount
