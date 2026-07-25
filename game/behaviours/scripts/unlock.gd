@tool
extends BaseBehaviour

@export var color: StringName = ""

## Use this tool to open the target door
func act(door: Area2D) -> void:
	if color == door.cor:
		door.aberta = !door.aberta
		door.update_door()
		
