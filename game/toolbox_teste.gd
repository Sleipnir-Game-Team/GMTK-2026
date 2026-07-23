extends Node2D

@export var anim_player : AnimationPlayer
@export var toggle_button : TextureButton

func _ready():
	toggle_button.toggled.connect(on_toggle)
	
func on_toggle(value):
	if value:
		anim_player.play("open")
	else:
		anim_player.play_backwards("open")
