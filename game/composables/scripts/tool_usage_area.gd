extends Area2D

@export var extra_args: Array[Variant]

signal trigger(this: Area2D, )

func _on_area_entered(tool: Area2D) -> void:
	for group in get_groups():
		if not tool.is_in_group(group):
			continue
		
		var args: Array = [self]
		args.append_array(extra_args)
		if tool.callv(group, args):
			trigger.emit(self, args)
