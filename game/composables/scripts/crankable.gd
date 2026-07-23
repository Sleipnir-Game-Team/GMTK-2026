extends Node2D

## Component to add rotation through mouse cranking to a parent Area2D.
## Supports dynamically transferring the component.

## Whether or not the parent Area2D is currently being dragged.
var _cranking: bool = false

## Angle between parent's origin and mouse click.
## Used to measure crankage.
var _crank_start_angle: float = 0

var _parent_node: Node2D:
	set(new_parent):
		if _parent_node:
			_parent_node.remove_from_group("tool_crankable")
		_parent_node = new_parent
		_parent_node.add_to_group("tool_crankable")

## Event Handler for [signal CollisionObject2D.input_event].
## Responsible for starting the crank event using the parent's area collision
func drag_input_handler(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_crank_start_angle = _parent_node.get_angle_to(get_global_mouse_position())
		_cranking = true

## Event Handler for cranking.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		_cranking = false
	elif event is InputEventMouseMotion and _cranking:
		_parent_node.rotate(_parent_node.get_angle_to(get_global_mouse_position()) + PI)


## Event Handler for NOTIFICATION_PARENTED (when this component gets a new parent)
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			_parent_node = get_parent()
