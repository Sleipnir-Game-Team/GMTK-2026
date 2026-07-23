extends Area2D


signal trigger(this: Area2D, args: Array[Variant])

@export var extra_args: Array[Variant]

var _groups: Dictionary[String, bool] = {}
var _tools_in_area: Array[Area2D] = []

func _ready() -> void:
	for group in get_groups():
		_groups[group] = true

func _on_area_entered(tool: Area2D) -> void:
	if tool.get_groups().any(_matching_group):
		_tools_in_area.push_back(tool)
		
	#for group in get_groups():
		#if not tool.is_in_group(group):
			#continue
		#
		#var behaviour: BaseBehaviour = tool.get_node(NodePath(group))
		#await behaviour.callv(group, [self] + extra_args)
		#trigger.emit(_parent_node, extra_args)


func _on_area_exited(area: Area2D) -> void:
	_tools_in_area.erase(area)


func _matching_group(group: StringName) -> bool:
	return _groups.has(group)
