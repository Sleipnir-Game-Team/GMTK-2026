extends Node2D

@export var anim_player : AnimationPlayer
@export var toggle_button : TextureButton
@export var stored_item_model : PackedScene

func _ready():
	toggle_button.toggled.connect(on_toggle)
	
func on_toggle(value):
	if value:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")


func store(item):
	print("bingo")
	var stored_item = stored_item_model.instantiate()
	stored_item.add_item(item)
	add_child(stored_item)
