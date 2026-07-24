extends Area2D

signal finished

@export var percentage_completed: float = 0.6
@export var segment_rows: int = 5
@export var segment_columns: int = 5
@export var line_texture: Texture2D

var _taping: bool = false:
	set(taping):
		if taping:
			_current_tape = Line2D.new()
			_current_tape.width = 30
			_current_tape.texture = line_texture
			_current_tape.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
			_current_tape.texture_mode = Line2D.LINE_TEXTURE_TILE
			_current_tape.add_point(get_local_mouse_position())
			_current_tape.add_point(get_local_mouse_position())
			add_child(_current_tape)
		
		elif _taping: # was taping and is no longer
			finished.emit()
		
		_taping = taping

var _current_tape: Line2D

@onready var total_segments: int = segment_rows * segment_columns
@onready var crack: Sprite2D = $Crack

func _ready() -> void:
	var area: Rect2 = crack.get_rect() * crack.transform
	
	var rectangle := RectangleShape2D.new()
	rectangle.size.x = area.size.x / float(segment_columns)
	rectangle.size.y = area.size.y / float(segment_rows)
	
	for row in segment_rows:
		for column in segment_columns:
			var shape := CollisionShape2D.new()
			 
			shape.position.x = crack.position.x + (rectangle.size.x * row) + (rectangle.size.x / 2)
			shape.position.y = crack.position.y + (rectangle.size.y * column) + (rectangle.size.y / 2)
			shape.shape = rectangle
			add_child(shape)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not _taping:
		return
	
	var points: int = _current_tape.points.size()
	if event is InputEventMouseMotion and points == 2:
		_current_tape.points[1] = get_local_mouse_position()
	
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and points == 2:
		_taping = false


func _on_mouse_exited() -> void:
	if not _taping: return
	
	_taping = false
	remove_child(_current_tape)
	_current_tape.queue_free()


func start_taping() -> void:
	# Wait a frame to make sure the first call to _on_input_frame
	# comes before we change _taping to true
	await get_tree().process_frame
	_taping = true
	await finished
