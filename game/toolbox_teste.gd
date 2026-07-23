extends Node2D

@export var anim_player : AnimationPlayer
@export var toggle_button : TextureButton
@export var stored_item_model : PackedScene

@export var slots: Array[Node2D]
var stored_items: Dictionary[Node2D,Node2D]

@export var pre_store: Array[PackedScene]

func _ready() -> void:
	toggle_button.toggled.connect(on_toggle)
	for tool_model in pre_store:
		var tool = tool_model.instantiate()
		store(tool)
	
	
func on_toggle(value) -> void:
	if value:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")


func store(item) -> void:
	var last_slot := 0
	while slots.size() > last_slot and slots[last_slot].get_children().size() > 0:
		last_slot += 1
	if slots.size() > last_slot:
		stored_items[slots[last_slot]] = stored_item_model.instantiate()
		var stored_item :Node2D = stored_items[slots[last_slot]]
		stored_item.add_item(item)
		slots[last_slot].add_child(stored_item)
