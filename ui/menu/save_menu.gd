extends Control

@export var new_game_model : PackedScene
@export var load_game_model : PackedScene

@export var saves_ammount := 3

@onready var saves_list := get_node("%Saves")

var path:Dictionary

func _ready() -> void:
	var slots_done := 0
	while slots_done < saves_ammount:
		var slot_container: MarginContainer
		var save_data: = SaveManager.check_save(slots_done)
		if save_data == {}:
			slot_container = new_game_model.instantiate()
		else:
			slot_container = load_game_model.instantiate()
			slot_container.find_child("Load Game Button").text = "%d/%d/%d %d:%d:%d" % [save_data.save_time.day, save_data.save_time.month, save_data.save_time.year, save_data.save_time.hour, save_data.save_time.minute, save_data.save_time.second]
			slot_container.manage_attributes(path)
		slot_container.slot = slots_done
		saves_list.add_child(slot_container)
		slots_done += 1

func manage_attributes(attributes: Dictionary) -> void:
	path = attributes

func _on_back_button_pressed() -> void:
	UI_Controller.freeScreen()
