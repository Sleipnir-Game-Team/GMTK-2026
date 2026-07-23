@abstract
class_name BaseBehaviour extends Node


@export var group: String = ""


func _enter_tree() -> void:
	name = group


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			_add_parent_groups()


func _add_parent_groups() -> void:
	var parent := get_parent()
	parent.add_to_group(group)


func _remove_parent_groups() -> void:
	var parent := get_parent()
	parent.remove_from_group(group)
