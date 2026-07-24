extends Node2D

@export var module_models : Dictionary[Node, PackedScene]
var modules : Dictionary[Node, Node2D]

var current_panel: Node

func _ready() -> void:
	for panel in module_models:
		panel.pressed.connect(_on_texture_button_toggled.bind(module_models[panel],panel))

func _on_texture_button_toggled(module_model: PackedScene, panel: Node) -> void:
	var changing := current_panel != panel
	if current_panel:
		modules[current_panel].queue_free()
		current_panel = null
	if changing:
		modules[panel] = module_model.instantiate()
		get_parent().add_child(modules[panel])
		current_panel = panel

func _exit_tree() -> void:
	for module in modules:
		if modules[module]:
			modules[module].queue_free()
