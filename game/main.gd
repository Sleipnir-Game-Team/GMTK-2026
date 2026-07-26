extends MarginContainer

func _ready() -> void:
	if SleipnirMaestro.current_song != "none": 
		SleipnirMaestro.load_song("level",true,0)
	else:
		SleipnirMaestro.load_song("level")
		SleipnirMaestro.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		UI_Controller.managePauseMenu()
