extends Area2D

var leaky_pipes: int = 0
var necessary_leaky_pipes: int = 0

@onready var pipes: Array[Area2D] = [%Pipe1, %Pipe2, %Pipe3, %Pipe4]

@export var screen_name: StringName

func _ready() -> void:
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var necessary_pipes := pipes.filter(func filt(p): return p.necessary)
	for i in range(necessary_pipes.size()):
		pipes[i].leaky = state_manager.pipe_states[screen_name][i]
	for pipe in pipes:
		if pipe.leaky:
			if pipe.necessary:
				necessary_leaky_pipes += 1
			leaky_pipes += 1
			AudioManager.play_global("gas.leak")
			pipe.plumbing_finished.connect(_stop_sfx)


func _stop_sfx() -> void:
	leaky_pipes -= 1
	check_pipes()
	if leaky_pipes > 0: return
	AudioManager.stop_global("gas.leak")

func check_pipes() -> int:
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var nes_leaky = 0
	for i in range(pipes.filter(func filt(p): return p.necessary).size()):
		state_manager.pipe_states[screen_name][i] = pipes[i].leaky
		if pipes[i].leaky: nes_leaky += 1
	return nes_leaky
		
	
