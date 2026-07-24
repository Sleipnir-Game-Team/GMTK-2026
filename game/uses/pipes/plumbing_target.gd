extends Area2D

@export var necessary: bool = false

@onready var sprite_2d: Sprite2D = %Sprite2D


func _ready() -> void:
	input_event.connect(_on_input_event)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		pass


func _physics_process(delta: float) -> void:
	sprite_2d.look_at(get_global_mouse_position())
	sprite_2d.rotation += 3*PI/2
	#sprite_2d.rotation = clamp(sprite_2d.rotation, 75, 180)
