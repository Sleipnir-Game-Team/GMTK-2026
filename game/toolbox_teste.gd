extends Node2D

@export var anim_player : AnimationPlayer
@export var toggle_button : TextureButton
@export var stored_item_model : PackedScene

@export var slots: Array[Marker2D]
var last_slot:= 0

func _ready() -> void:
	toggle_button.toggled.connect(on_toggle)
	
func on_toggle(value) -> void:
	if value:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")


func store(item) -> void:
	if slots.size() > last_slot:
		var stored_item :Node2D = stored_item_model.instantiate()
		stored_item.add_item(item)
		stored_item.global_position = slots[last_slot].global_position
		add_child(stored_item)
		last_slot += 1
