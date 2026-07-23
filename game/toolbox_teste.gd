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


func _on_tool_box_area_trigger(this, args):
	print("entrou")
	var stored_item = stored_item_model.instantiate()
	stored_item.add_item(args[0])
	add_child(stored_item)
