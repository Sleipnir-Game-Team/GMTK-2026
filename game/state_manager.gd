class_name StateManager extends Node

var rng := RandomNumberGenerator.new()

var equalizer_state: Dictionary[String, Variant]= {
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

var screw_states: Dictionary[String, Array] = {
	'screw_screen_1' = [
		false,
		false,
		false,
		false
	], 
	'screw_screen_2' = [
		false,
		false,
		false,
		false,
		false
	], 
	'screw_screen_3' = [
		false,
		false,
		false,
		false
	], 
	'screw_screen_4' = [
		false,
		false,
		false,
		false,
		false
	], 
	'screw_screen_5' = [
		false,
		false,
		false,
		false,
		false,
		false
	], 
	'screw_screen_6' = [
		false,
		false,
		false,
		false,
		false,
		false
	]
}

var fuel_states: Dictionary[String, Dictionary] = {
	'fuel_1' = {
		'color' : 'blue',
		'open' : false,
		'full' : true
	},
	'fuel_2' = {
		'color' : 'red',
		'open' : false,
		'full' : true
	}
}

var pipe_states: Dictionary[String, Array] = {
	'pipe_1' = [
		false,
		false,
		false
	],
	'pipe_2' = [
		false,
		false,
		false,
		false
	],
	'pipe_3' = [
		false,
		false
	],
	'pipe_4' = [
		false,
		false
	],
	'pipe_5' = [
		false,
		false,
		false,
		false
	],
	'pipe_6' = [
		false,
		false,
		false
	],
	'pipe_7' = [
		false,
		false,
		false,
		false
	]
}

var tube_states: Dictionary[String, Array]  = {
	'tube_1' = [
		false,
		true,
		true
	],
	'tube_2' = [
		false,
		false,
		false,
		false
	],
	'tube_3' = [
		false,
		false
	],
	'tube_4' = [
		false,
		false
	],
	'tube_5' = [
		false,
		false,
		false,
		false
	],
	'tube_6' = [
		false,
		false,
		false
	]
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


func get_true_amount(list: Array) -> int:
	var amount: int = 0
	for value: bool in list:
		amount += int(value)
	return amount


func get_oxigen_screws() -> int:
	return (
		count_screws('screw_screen_1') * -1 +
		count_screws('screw_screen_2') * -2 +
		count_screws('screw_screen_4') * -1
	)


func get_thruster_1_screws() -> int:
	return (
		count_screws('screw_screen_1') +
		count_screws('screw_screen_2') +
		count_screws('screw_screen_3') +
		count_screws('screw_screen_4') +
		count_screws('screw_screen_5') +
		count_screws('screw_screen_6')
	)


func get_thruster_2_screws() -> int:
	return (
		count_screws('screw_screen_1') +
		count_screws('screw_screen_2') +
		count_screws('screw_screen_3') +
		count_screws('screw_screen_4') +
		count_screws('screw_screen_5') +
		count_screws('screw_screen_6')
	)


func get_thruster_1_fuel() -> bool:
	return !fuel_states['fuel_1']['open'] and fuel_states['fuel_1']['full']


func get_thruster_2_fuel() -> bool:
	return !fuel_states['fuel_2']['open'] and fuel_states['fuel_2']['full']


func get_oxigen_tube() -> float:
	return (
			get_true_amount(tube_states['tube_1']) * -0.5 +
			get_true_amount(tube_states['tube_2']) * -0.5 +
			get_true_amount(tube_states['tube_3']) * -1.5 +
			get_true_amount(tube_states['tube_4']) * -1.0 +
			get_true_amount(tube_states['tube_5']) * -2.0 +
			get_true_amount(tube_states['tube_6']) * -2.5
	)


func get_temp_pipe() -> float:
	return (
			get_true_amount(pipe_states['pipe_1']) * 2.5 +
			get_true_amount(pipe_states['pipe_2']) * 2.5 +
			get_true_amount(pipe_states['pipe_5']) * 3.5 +
			get_true_amount(pipe_states['pipe_6']) * 3.5 +
			get_true_amount(pipe_states['pipe_7']) * 5
	)


func get_thruster_1_pipes() -> int:
	return (
			get_true_amount(pipe_states['pipe_1']) +
			get_true_amount(pipe_states['pipe_2']) +
			get_true_amount(pipe_states['pipe_3']) +
			get_true_amount(pipe_states['pipe_4']) +
			get_true_amount(pipe_states['pipe_5']) +
			get_true_amount(pipe_states['pipe_6']) +
			get_true_amount(pipe_states['pipe_7'])
	)


func get_thruster_2_pipes() -> int:
	return (
			get_true_amount(pipe_states['pipe_1']) +
			get_true_amount(pipe_states['pipe_2']) +
			get_true_amount(pipe_states['pipe_3']) +
			get_true_amount(pipe_states['pipe_4']) +
			get_true_amount(pipe_states['pipe_5']) +
			get_true_amount(pipe_states['pipe_6']) +
			get_true_amount(pipe_states['pipe_7'])
	)


func get_screw_total() -> int:
	var amount := 0
	for screw_state in screw_states:
		amount += screw_states[screw_state].size()
	return amount


func get_pipe_total() -> int:
	var amount := 0
	for pipe_state in pipe_states:
		amount += pipe_states[pipe_state].size()
	return amount


func get_tube_total() -> int:
	var amount := 0
	for tube_state in tube_states:
		amount += tube_states[tube_state].size()
	return amount


func count_screws(screen_name: String) -> int:
	var loose_amount: int = 0
	for screw: bool in screw_states[screen_name]:
		loose_amount += int(screw)
	return loose_amount 


func break_equalizer() -> void:
	var values: Array[float] = [rng.randf_range(0,100), rng.randf_range(0,100), rng.randf_range(0,100)]
	equalizer_state['low_oxi_value'] = values[equalizer_state['low_oxi_slider']]
	equalizer_state['mid_oxi_value'] = values[equalizer_state['mid_oxi_slider']]
	equalizer_state['high_oxi_value'] = values[equalizer_state['high_oxi_slider']]
	equalizer_state['low_temp_value'] = values[equalizer_state['low_temp_slider']]
	equalizer_state['mid_temp_value'] = values[equalizer_state['mid_temp_slider']]
	equalizer_state['high_temp_value'] = values[equalizer_state['high_temp_slider']]
