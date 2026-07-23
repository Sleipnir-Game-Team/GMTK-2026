@tool
extends BaseBehaviour

@export var password: String = ""

func unlock(door: Area2D) -> bool:
	return not door.extra_args.password or password == door.extra_args.password
