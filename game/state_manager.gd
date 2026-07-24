extends Node

var rng := RandomNumberGenerator.new()

var equalizer_state := {
	'low_position' = 0.0,
	'mid_position' = 0.0,
	'high_position' = 0.0,
	'low_oxi_slider' = 0,
	'mid_oxi_slider' = 1,
	'high_oxi_slider' = 2,
	'low_oxi_value' = 50,
	'mid_oxi_value' = 50,
	'high_oxi_value' = 50,
	'low_temp_slider' = 0,
	'mid_temp_slider' = 1,
	'high_temp_slider' = 2,
	'low_temp_value' = 50,
	'mid_temp_value' = 50,
	'high_temp_value' = 50
}



var break_functions := [
	break_equalizer
]

func _ready():
	roll_equalizer()
	break_things(1)

func break_things(number):
	while number > 0 or break_functions.size() > 0:
		var selecionado = rng.randi_range(0, break_functions.size() -1)
		break_functions[selecionado].call()
		break_functions.remove_at(selecionado)
		number -= 1

func roll_equalizer():
	equalizer_state['low_position'] = rng.randf_range(0,100)
	equalizer_state['mid_position'] = rng.randf_range(0,100)
	equalizer_state['high_position'] = rng.randf_range(0,100)
	var sliders := [0, 1, 2]
	var chosen = rng.randi_range(0,2)
	equalizer_state['low_oxi_slider'] = sliders[chosen]
	sliders.remove_at(chosen)
	chosen = rng.randi_range(0, 1)
	equalizer_state['mid_oxi_slider'] = sliders[chosen]
	sliders.remove_at(chosen)
	equalizer_state['high_oxi_slider'] = sliders[0]
	equalizer_state['low_oxi_value'] = equalizer_state['low_position']
	equalizer_state['mid_oxi_value'] = equalizer_state['mid_position']
	equalizer_state['high_oxi_value'] = equalizer_state['high_position']
	
	sliders = [0, 1, 2]
	chosen = rng.randi_range(0,2)
	equalizer_state['low_temp_slider'] = sliders[chosen]
	sliders.remove_at(chosen)
	chosen = rng.randi_range(0, 1)
	equalizer_state['mid_temp_slider'] = sliders[chosen]
	sliders.remove_at(chosen)
	equalizer_state['high_temp_slider'] = sliders[0]
	equalizer_state['low_temp_value'] = equalizer_state['low_position']
	equalizer_state['mid_temp_value'] = equalizer_state['mid_position']
	equalizer_state['high_temp_value'] = equalizer_state['high_position']

func get_equalizer_oxi_value():
	return (
		(equalizer_state['low_oxi_value'] - equalizer_state['low_position']) * 0.1 + 
		(equalizer_state['mid_oxi_value'] - equalizer_state['mid_position']) * 0.5 + 
		(equalizer_state['high_oxi_value'] - equalizer_state['high_position']) * 1
		)

func get_equalizer_temp_value():
	return (
		(equalizer_state['low_temp_value'] - equalizer_state['low_position']) * 0.1 + 
		(equalizer_state['mid_temp_value'] - equalizer_state['mid_position']) * 0.5 + 
		(equalizer_state['high_temp_value'] - equalizer_state['high_position']) * 1
		)

func break_equalizer():
	var values = [rng.randf_range(0,100), rng.randf_range(0,100), rng.randf_range(0,100)]
	equalizer_state['low_oxi_value'] = values[equalizer_state['low_oxi_slider']]
	equalizer_state['mid_oxi_value'] = values[equalizer_state['mid_oxi_slider']]
	equalizer_state['high_oxi_value'] = values[equalizer_state['high_oxi_slider']]
	equalizer_state['low_temp_value'] = values[equalizer_state['low_temp_slider']]
	equalizer_state['mid_temp_value'] = values[equalizer_state['mid_temp_slider']]
	equalizer_state['high_temp_value'] = values[equalizer_state['high_temp_slider']]
