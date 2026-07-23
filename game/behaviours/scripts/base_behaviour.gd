@abstract
class_name BaseBehaviour extends Node


@export var group: StringName = ""


func _enter_tree() -> void:
	name = group


@abstract
func act(use: Area2D) -> void
