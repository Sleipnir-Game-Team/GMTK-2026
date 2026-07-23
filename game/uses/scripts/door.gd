extends Area2D


@export var password: StringName = ""

## Triggered when fully opened by the AnimationPlayer
func _fucking_kill_myself() -> void:
	queue_free()
