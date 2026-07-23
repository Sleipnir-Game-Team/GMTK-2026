@tool
extends BaseBehaviour

@export var password: StringName = ""

## Use this tool to open the target door
func act(door: Area2D) -> void:
	if not door.password or password == door.password:
		var player: AnimationPlayer = door.get_node("%AnimationPlayer")
		player.play("uses.door/open")
