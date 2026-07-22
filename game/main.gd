extends MarginContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		UI_Controller.managePauseMenu()
		
