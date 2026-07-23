extends Node


@export var passkey: String = ""

var _parent_node: Node2D:
	set(new_parent):
		if _parent_node:
			_parent_node.remove_from_group("tool_key")
		_parent_node = new_parent
		_parent_node.add_to_group("tool_key")

func tool_key(_door: Variant, password: Variant) -> bool:
	return not password or passkey == password
	
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			_parent_node = get_parent()
