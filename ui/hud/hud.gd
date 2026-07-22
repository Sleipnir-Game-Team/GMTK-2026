extends Control

@export var node_dict:Dictionary[StringName, Node]

func _ready() -> void:
	UI_Controller.ui_node_dict = node_dict
