extends Node2D

@export var cracks: Array[Node]
@export var screen_name: StringName

var unfixed: int = 0:
	set(value):
		unfixed = value
		if unfixed == 0:
			AudioManager.stop_global("gas.leak")

@onready var state_manager: Node = get_tree().get_first_node_in_group("Jogo").state_manager



func _ready() -> void:
	var remaining: int = cracks.size()
	while remaining > 0:
		remaining -= 1
		if !state_manager.tube_states[screen_name][remaining]:
			cracks[remaining].queue_free()
		else:
			unfixed += 1
			cracks[remaining].finished.connect(on_crack_finished.bind(remaining))
			AudioManager.play_global("gas.leak")


func on_crack_finished(state: bool, crack: int) -> void:
	state_manager.tube_states[screen_name][crack] = not state
	if state:
		unfixed -= 1
		cracks[crack].queue_free()
