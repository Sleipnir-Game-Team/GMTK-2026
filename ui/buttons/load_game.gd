extends MarginContainer

@export var slot := 0
var menu_pathing: String


func manage_attributes(attributes: Variant) -> void:
	menu_pathing = attributes["path"]

func _on_load_game_button_pressed() -> void:
	SaveManager.current_slot = slot
	SaveManager.load_slot()


func _on_download_button_pressed() -> void:
	SaveManager.delete_save(slot)
	UI_Controller.freeScreen()
	UI_Controller.openScreen(menu_pathing, get_tree().root)
