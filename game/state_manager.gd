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

var screw_states = {
	'screw_screen_1' = [
		false,
		false,
		false,
		false
	]
}

var fuel_states = {
	'fuel_1' = {
		'color' : 'blue',
		'open' : true,
		'full' : false
	},
	'fuel_2' = {
		'color' : 'red',
		'open' : false,
		'full' : true
	}
}

var break_functions := [
#	break_equalizer
]

func _ready() -> void:
	roll_equalizer()
	break_things(1)

func break_things(number: int) -> void:
	while number > 0 and break_functions.size() > 0:
		var selecionado: int = rng.randi_range(0, break_functions.size() -1)
		break_functions[selecionado].call()
		break_functions.remove_at(selecionado)
		number -= 1

func roll_equalizer() -> void:
	equalizer_state['low_position'] = rng.randf_range(0,100)
	equalizer_state['mid_position'] = rng.randf_range(0,100)
	equalizer_state['high_position'] = rng.randf_range(0,100)
	var sliders := [0, 1, 2]
	var chosen: int = rng.randi_range(0,2)
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

func get_equalizer_oxi_value() -> float:
	return (
		(equalizer_state['low_oxi_value'] - equalizer_state['low_position']) * 0.1 + 
		(equalizer_state['mid_oxi_value'] - equalizer_state['mid_position']) * 0.5 + 
		(equalizer_state['high_oxi_value'] - equalizer_state['high_position']) * 1
		)

func get_equalizer_temp_value() -> float:
	return (
		(equalizer_state['low_temp_value'] - equalizer_state['low_position']) * 0.1 + 
		(equalizer_state['mid_temp_value'] - equalizer_state['mid_position']) * 0.5 + 
		(equalizer_state['high_temp_value'] - equalizer_state['high_position']) * 1
		)

func get_oxigen_screws() -> int:
	return 0

func get_thruster_1_screws() -> int:
	return count_screws('screw_screen_1')

func get_thruster_2_screws() -> int:
	return 0

func get_thruster_1_fuel() -> bool:
	return !fuel_states['fuel_1']['open'] and fuel_states['fuel_1']['full']

func get_thruster_2_fuel() -> bool:
	return !fuel_states['fuel_2']['open'] and fuel_states['fuel_2']['full']

func count_screws(screen_name) -> int:
	var loose_amount: int = 0
	for screw in screw_states[screen_name]:
		if screw:
			loose_amount += 1
	return loose_amount 

func break_equalizer() -> void:
	var values = [rng.randf_range(0,100), rng.randf_range(0,100), rng.randf_range(0,100)]
	equalizer_state['low_oxi_value'] = values[equalizer_state['low_oxi_slider']]
	equalizer_state['mid_oxi_value'] = values[equalizer_state['mid_oxi_slider']]
	equalizer_state['high_oxi_value'] = values[equalizer_state['high_oxi_slider']]
	equalizer_state['low_temp_value'] = values[equalizer_state['low_temp_slider']]
	equalizer_state['mid_temp_value'] = values[equalizer_state['mid_temp_slider']]
	equalizer_state['high_temp_value'] = values[equalizer_state['high_temp_slider']]
