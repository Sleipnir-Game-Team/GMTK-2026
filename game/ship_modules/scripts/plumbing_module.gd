extends Area2D

var leaky_pipes: int = 0

@onready var pipes: Array[Area2D] = [%Pipe1, %Pipe2, %Pipe3, %Pipe4]

func _ready() -> void:
	for pipe in pipes:
		if pipe.necessary:
			leaky_pipes += 1
			AudioManager.play_global("gas.leak")
			pipe.plumbing_finished.connect()


func _stop_sfx() -> void:
	leaky_pipes -= 1
	if leaky_pipes > 0: return
	AudioManager.stop_global("gas.leak")
