extends Control

func _ready() -> void:
	if SleipnirMaestro.current_song != "none": 
		SleipnirMaestro.load_song("endgame",true)
	else:
		SleipnirMaestro.load_song("endgame")
		SleipnirMaestro.play()

func _on_restart_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	SaveManager.load_slot()


func _on_main_menu_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.changeScreen("res://ui/menu/main_menu.tscn", get_tree().root) 


func _on_quit_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	get_tree().quit()
