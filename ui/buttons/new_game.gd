extends MarginContainer

@export var slot := 0

func _on_new_game_button_pressed() -> void:
	SaveManager.new_game(slot)
