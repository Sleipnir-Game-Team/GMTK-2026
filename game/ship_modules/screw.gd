extends Node2D

@export var screws: Array[Node]
@export var screen_name: StringName

func _ready():
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var remaining = screws.size()
	while remaining > 0:
		remaining -= 1
		screws[remaining].loose = state_manager.screw_states[screen_name][remaining]
		screws[remaining].changed.connect(on_screw_changed.bind(remaining))

func on_screw_changed(state, screw):
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	state_manager.screw_states[screen_name][screw] = state

func get_unscrewed():
	var amount = 0
	for screw in screws:
		if screw.loose:
			amount += 1
	return amount
