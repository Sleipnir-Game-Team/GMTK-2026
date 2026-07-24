extends Area2D


signal plumbing_finished

var plumbing_ongoing: bool = false:
	set(new_value): 
		plumbing_ongoing = new_value
		
		for target in targets:
			target.input_pickable = new_value

@onready var targets: Array[Area2D] = [%TargetA, %TargetB, %TargetC, %TargetD]


func _ready() -> void:
	targets.pick_random().necessary = true


func start_plumbing():
	plumbing_ongoing = true
	get_tree().create_timer(10).timeout.connect(plumbing_finished.emit)
	await plumbing_finished
