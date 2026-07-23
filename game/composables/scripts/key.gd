extends Node2D


@export var passkey: String = ""

var _parent_node: Node2D:
	set(new_parent):
		if _parent_node:
			_parent_node.remove_from_group("tool_unlockable")
		_parent_node = new_parent
		_parent_node.add_to_group("tool_unlockable")


func tool_unlockable(door: Area2D, password: String) -> bool:
	return not password or passkey == password
	
