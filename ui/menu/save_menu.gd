extends Control

@export var new_game_model : PackedScene
@export var load_game_model : PackedScene

@export var saves_ammount := 3

@onready var saves_list := %Saves

func _ready() -> void:
	var slots_done := 0
	while slots_done < saves_ammount:
		var slot_container: MarginContainer
		if SaveManager.check_save(slots_done) == {}:
			slot_container = new_game_model.instantiate()
		else:
			slot_container = load_game_model.instantiate()
		slot_container.slot = slots_done
		saves_list.add_child(slot_container)
		slots_done += 1
