extends Area2D


#signal drag_start(mouse_position: Vector2, parent_position: Vector2)
#signal drag_end(mouse_position: Vector2, parent_position: Vector2)
#@onready var draggable: Draggable = %Draggable

#func  _ready() -> void:
	# Bubble up child events
	#draggable.drag_start.connect(drag_start.emit)
	#draggable.drag_end.connect(drag_end.emit)
