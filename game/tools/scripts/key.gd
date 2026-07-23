extends Area2D

@onready var use_unlock: BaseBehaviour = %use_unlock

@export var password: StringName = "":
	set(new_value):
		password = new_value
		use_unlock.password = new_value


func _on_use(door: Area2D) -> void:
	if use_unlock.can_unlock(door):
		var player: AnimationPlayer = door.get_node("%AnimationPlayer")
		player.play("uses.door/open")
