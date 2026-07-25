extends Area2D

@export var image: TextureRect
@export var loose_shader: Shader

@export var animation_player: AnimationPlayer

signal changed(new_value: bool)

@export var loose: bool: 
	set(new_value):
		image.material.set_shader_parameter('loose', new_value)
		if !new_value:
			monitoring = false
			monitorable = false
		changed.emit(new_value)
		return new_value

func screw() -> void:
	animation_player.speed_scale = 2
	animation_player.play("tight")
	await changed
