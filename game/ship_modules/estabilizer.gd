extends Node2D

@export var slider_1 : VSlider 
@export var slider_2 : VSlider 
@export var slider_3 : VSlider 
@export var label_oxi : Label 
@export var label_temp : Label 

var low_oxi_slider : VSlider
var mid_oxi_slider : VSlider
var high_oxi_slider : VSlider

var low_temp_slider : VSlider
var mid_temp_slider : VSlider
var high_temp_slider : VSlider

var state_manager : Node

func _ready():
	state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var state = state_manager.equalizer_state
	
	var sliders = [slider_1, slider_2, slider_3]
	
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

func update_values():
	state_manager.equalizer_state.low_oxi_value = low_oxi_slider.value
	state_manager.equalizer_state.mid_oxi_value = mid_oxi_slider.value
	state_manager.equalizer_state.high_oxi_value = high_oxi_slider.value
	
	state_manager.equalizer_state.low_temp_value = low_temp_slider.value
	state_manager.equalizer_state.mid_temp_value = mid_temp_slider.value
	state_manager.equalizer_state.high_temp_value = high_temp_slider.value
	change_labels()


func change_labels():
	var jogo = get_tree().get_first_node_in_group("Jogo")
	label_oxi.text = "Oxigenio: "+str(jogo.oxigen)+"%"
	label_temp.text = "Temperatura: "+str(jogo.temp)+"°C"
