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


func _on_launch_button_pressed() -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	if jogo.ship_timer and not jogo.ship_timer.is_stopped():
		jogo.ship_timer.stop()
		jogo.evaluate_ship()
