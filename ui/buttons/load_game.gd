extends MarginContainer

@export var slot := 0

func _on_load_game_button_pressed() -> void:
	SaveManager.current_slot = slot
	SaveManager.load_slot()


func _on_download_button_pressed() -> void:
	SaveManager.delete_save(slot)
	UI_Controller.changeScreen("res://ui/menu/save_menu.tscn", get_tree().root)
