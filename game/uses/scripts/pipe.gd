extends Area2D

signal plumbing_finished

const MIN_ROTATION: float = deg_to_rad(75)
const MAX_ROTATION: float = PI

@export var necessary: bool = false
@export var leaky: bool = false
@export_range(0.1, 5, 0.1) var min_duration: float = 1

var _pushing: bool = false
var _wrench_in_position: bool = false:
	set(in_position):
		_wrench_in_position = in_position
		wrench.visible = in_position

@onready var wrench: Sprite2D = %Sprite2D
@onready var wrench_handle: Area2D = %Area2D
@onready var _max_angular_velocity: float = (MAX_ROTATION - MIN_ROTATION) * (1 / min_duration)


func _ready() -> void:
	wrench_handle.input_event.connect(_push_handle)


## When the left mouse button is released, stop pushing the wrench
## The reason this is here instead of on the _push_handle method is
## because I THINK (might be wrong tho) that the input_event signal only
## emits when the cursor is inside the area (and if you move fast enough you wont be)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		_pushing = false


func _physics_process(delta: float) -> void:
	if !_wrench_in_position: return
	if is_equal_approx(wrench.rotation, MIN_ROTATION):
		# FINISHED
		_pushing = false
		_wrench_in_position = false
		leaky = false
		plumbing_finished.emit()
	
	elif _pushing:
		var target: float = wrench.rotation + wrench.get_angle_to(get_global_mouse_position()) + 3*PI/2
		
		# It's a circle dumbass, look it up
		target = fmod(target, 2*PI)
		
		# Can't go back up
		if target > wrench.rotation:
			return
		
		var how_much_are_we_moving: float = absf(target - wrench.rotation)
		var angular_velocity: float = min(how_much_are_we_moving * (1 / delta), _max_angular_velocity)
		target = wrench.rotation - (angular_velocity * delta)
		
		wrench.rotation = clampf(target, MIN_ROTATION, MAX_ROTATION)


func start_plumbing() -> void:
	if !leaky: return
	_wrench_in_position = true
	await plumbing_finished
	


## After the wrench is positioned, left clicking the handle allows pushing
func _push_handle(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_pushing = true
