extends Area2D

@export var extra_args: Array[Variant]

signal trigger(this: Area2D, args: Array[Variant])

var _parent_node: Node2D

func _on_area_entered(tool: Area2D) -> void:
	for group in _parent_node.get_groups():
		if not tool.is_in_group(group):
			continue
		
		var args: Array = [_parent_node]
		args.append_array(extra_args)
		var FODASE = tool.get_node(str(group))
		if FODASE.callv(group, args):
			trigger.emit(_parent_node, extra_args)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			_parent_node = get_parent()
