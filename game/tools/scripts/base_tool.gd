@abstract
class_name BaseTool extends Area2D


var behaviours: Dictionary[String, BaseBehaviour] = {}


func _init() -> void:
	for child in get_children():
		_register_behaviour(child)
	child_entered_tree.connect(_register_behaviour)
	child_exiting_tree.connect(_unregister_behaviour)


func _register_behaviour(child: Node) -> void:
	if child is BaseBehaviour:
		behaviours[child.group] = child
		add_to_group(child.group)


func _unregister_behaviour(child: Node) -> void:
		if child is BaseBehaviour:
			remove_from_group(child.group)
			behaviours.erase(child.group)


func _on_use(use: Area2D, group: StringName) -> void:
	var behaviour: BaseBehaviour = behaviours.get(group)
	if behaviour != null:
		behaviour.act(use)
	


func group_matches(group: StringName) -> bool:
	return behaviours.has(group)
