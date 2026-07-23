@tool
extends Node

signal drag_start() # TALVEZ ADICIONAR UNS PARAMETROS AQUI?
signal drag_end() # TALVEZ ADICIONAR UNS PARAMETROS AQUI?
signal drop_on_use_area(use: Area2D, group: StringName)

## Whether or not the parent Area2D is currently being dragged.
var _dragging: bool = false

## Use area the tool is inside of (or null)
var _intersecting_use_area: Area2D

## Use group of the area (or null)
var _intersecting_use_group: StringName

## Whether the mouse cursor is ALSO inside the _intersecting_use_area
var _mouse_in_use_area: bool = false

## Distance of mouse click from parent's origin.
## Used to avoid "jumps" when starting a drag from the parent's edge.
var _drag_offset: Vector2 = Vector2.ZERO

var _parent_node: BaseTool:
	set(new_parent):
		if _parent_node:
			_disconnect_signals()
		_parent_node = new_parent
		_connect_signals()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			if Engine.is_editor_hint():
				update_configuration_warnings()
			_parent_node = get_parent()


func _get_configuration_warnings() -> PackedStringArray:
	if not Engine.is_editor_hint():
		return []
	
	var parent := get_parent()
	if not parent or not parent is BaseTool:
		return ['The parent Node must be a BaseTool.']
	
	return []


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _dragging:
		var mouse_position: Vector2 = _parent_node.get_global_mouse_position()
		
		_parent_node.global_position = mouse_position - _drag_offset
		
		if _intersecting_use_area:
			var query := PhysicsPointQueryParameters2D.new()
			query.collide_with_areas = true
			query.collide_with_bodies = false
			query.collision_mask = 1 << 16 - 1 # Camada 16 é onde tem os Uses
			query.position = mouse_position
			var res = _parent_node.get_world_2d().direct_space_state.intersect_point(query, 1).pop_back()
			_mouse_in_use_area = res != null and res.collider == _intersecting_use_area
			


## Responsible for starting the drag event using the parent's area collision
func drag_input_handler(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_drag_offset = _parent_node.get_local_mouse_position() * _parent_node.get_screen_transform().get_scale()
		_dragging = !_dragging
		
		if _dragging:
			drag_start.emit()
		elif _mouse_in_use_area:
			drag_end.emit()
			drop_on_use_area.emit(_intersecting_use_area, _intersecting_use_group)
			_mouse_in_use_area = false
		else:
			drag_end.emit()


func use_area_entered(use: Area2D) -> void:
	for group in use.get_groups():
		if _parent_node.group_matches(group):
			_intersecting_use_area = use
			_intersecting_use_group = group
			return 


func use_area_exited(use: Area2D) -> void:
	if _intersecting_use_area == use:
		_intersecting_use_area = null
		_intersecting_use_group = &""


func _connect_signals() -> void:
	_parent_node.input_event.connect(drag_input_handler)
	_parent_node.area_entered.connect(use_area_entered)
	_parent_node.area_exited.connect(use_area_exited)


func _disconnect_signals() -> void:
	if _parent_node.input_event.is_connected(drag_input_handler):
		_parent_node.input_event.disconnect(drag_input_handler)
		
	if _parent_node.area_entered.is_connected(use_area_entered):
		_parent_node.area_entered.disconnect(use_area_entered)
		
	if _parent_node.area_exited.is_connected(use_area_exited):
		_parent_node.area_exited.disconnect(use_area_exited)
