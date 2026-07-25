extends Node2D

@export var slider_1: VSlider 
@export var slider_2: VSlider 
@export var slider_3: VSlider 
@export var label_oxi: Label 
@export var label_temp: Label 

var low_oxi_slider: VSlider
var mid_oxi_slider: VSlider
var high_oxi_slider: VSlider

var low_temp_slider: VSlider
var mid_temp_slider: VSlider
var high_temp_slider: VSlider

var _sliding: bool = false
var _min_tick_distance: int = 10 # quantos pixels pra tocar um som de tick
var _moved: int = 0

@onready var jogo: Node = get_tree().get_first_node_in_group("Jogo")
@onready var state_manager: Node = jogo.state_manager


func _ready() -> void:
	var state: Dictionary = state_manager.equalizer_state
	
	slider_1.drag_started.connect(_toggle_sliding.bind(false))
	slider_2.drag_started.connect(_toggle_sliding.bind(false))
	slider_3.drag_started.connect(_toggle_sliding.bind(false))
	slider_1.drag_ended.connect(_toggle_sliding)
	slider_2.drag_ended.connect(_toggle_sliding)
	slider_3.drag_ended.connect(_toggle_sliding)
	
	var sliders: Array[VSlider] = [slider_1, slider_2, slider_3]
	
	low_oxi_slider = sliders[state['low_oxi_slider']]
	mid_oxi_slider = sliders[state['mid_oxi_slider']]
	high_oxi_slider = sliders[state['high_oxi_slider']]
	
	
	low_oxi_slider.drag_ended.connect(update_values.unbind(1))
	mid_oxi_slider.drag_ended.connect(update_values.unbind(1))
	high_oxi_slider.drag_ended.connect(update_values.unbind(1))
	
	low_oxi_slider.value = state_manager.equalizer_state.low_oxi_value
	mid_oxi_slider.value = state_manager.equalizer_state.mid_oxi_value
	high_oxi_slider.value = state_manager.equalizer_state.high_oxi_value
	
	
	low_temp_slider = sliders[state['low_temp_slider']]
	mid_temp_slider = sliders[state['mid_temp_slider']]
	high_temp_slider = sliders[state['high_temp_slider']]
	
	low_temp_slider.value = state_manager.equalizer_state.low_temp_value
	mid_temp_slider.value = state_manager.equalizer_state.mid_temp_value
	high_temp_slider.value = state_manager.equalizer_state.high_temp_value
	
	change_labels()


func _input(event: InputEvent) -> void:
	if _sliding and event is InputEventMouseMotion:
		_moved += event.relative.y
		if abs(_moved) > _min_tick_distance:
			_moved = 0
			AudioManager.play_global("indicator.slider")
			return
		


func update_values() -> void:
	state_manager.equalizer_state.low_oxi_value = low_oxi_slider.value
	state_manager.equalizer_state.mid_oxi_value = mid_oxi_slider.value
	state_manager.equalizer_state.high_oxi_value = high_oxi_slider.value
	
	state_manager.equalizer_state.low_temp_value = low_temp_slider.value
	state_manager.equalizer_state.mid_temp_value = mid_temp_slider.value
	state_manager.equalizer_state.high_temp_value = high_temp_slider.value
	
	change_labels()


func change_labels() -> void:
	label_oxi.text = "Oxigenio: "+str(snapped(jogo.oxigen, 0.01))+"%"
	label_temp.text = "Temperatura: "+str(snapped(jogo.temp, 1))+"°C"

## Recebe um value e não usa pra encaixar no signal de drag
func _toggle_sliding(_value: bool) -> void:
	_sliding = not _sliding
