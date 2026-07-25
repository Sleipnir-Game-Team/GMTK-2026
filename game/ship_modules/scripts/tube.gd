extends Node2D

@export var cracks: Array[Node]
@export var screen_name: StringName

@onready var state_manager: Node = get_tree().get_first_node_in_group("Jogo").state_manager

func _ready() -> void:
	var remaining: int = cracks.size()
	while remaining > 0:
		remaining -= 1
		if !state_manager.tube_states[screen_name][remaining]:
			cracks[remaining].queue_free()
		else:
			cracks[remaining].finished.connect(on_crack_finished.bind(remaining))

func on_crack_finished(state: bool, crack: int) -> void:
	state_manager.tube_states[screen_name][crack] = state
	cracks[crack].queue_free()
