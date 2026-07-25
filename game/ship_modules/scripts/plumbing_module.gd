extends Area2D

@export var screen_name: StringName

var leaky_pipes: int = 0
var necessary_leaky_pipes: int = 0

@onready var pipes: Array = [%Pipe1, %Pipe2, %Pipe3, %Pipe4]
@onready var state_manager: StateManager = get_tree().get_first_node_in_group("Jogo").state_manager


func _ready() -> void:
	var necessary_pipes: Array = pipes.filter(_filter_pipe)
	for i in range(necessary_pipes.size()):
		pipes[i].leaky = state_manager.pipe_states[screen_name][i]
	for pipe in pipes:
		if pipe.leaky:
			if pipe.necessary:
				necessary_leaky_pipes += 1
			leaky_pipes += 1
			AudioManager.play_global("gas.leak")
			pipe.plumbing_finished.connect(_on_plumbing_finished)


func _on_plumbing_finished() -> void:
	leaky_pipes -= 1
	check_pipes()
	if leaky_pipes > 0: return
	AudioManager.stop_global("gas.leak")


func check_pipes() -> int:
	var nes_leaky: int = 0
	for i in range(pipes.filter(_filter_pipe).size()):
		state_manager.pipe_states[screen_name][i] = pipes[i].leaky
		if pipes[i].leaky: nes_leaky += 1
	return nes_leaky


func _filter_pipe(pipe) -> bool:
	return pipe.necessary
