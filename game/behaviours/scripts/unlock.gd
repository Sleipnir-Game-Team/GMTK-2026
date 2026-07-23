@tool
extends BaseBehaviour

@export var password: StringName = ""

func can_unlock(door: Area2D) -> bool:
	return not door.password or password == door.password
