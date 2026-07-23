extends Node2D

@export var module_models : Dictionary[Node, PackedScene]
var modules : Dictionary[Node, Node2D]

func _ready() -> void:
	for panel in module_models:
		panel.toggled.connect(_on_texture_button_toggled.bind(module_models[panel],panel))

func _on_texture_button_toggled(toggled_on: bool, module_model: PackedScene, panel: Node) -> void:
	if(toggled_on):
		modules[panel] = module_model.instantiate()
		get_parent().add_child(modules[panel])
	else:
		if modules[panel]:
			modules[panel].queue_free()

func _exit_tree() -> void:
	for module in modules:
		if modules[module]:
			modules[module].queue_free()
