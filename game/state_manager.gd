class_name StateManager extends Node

var rng := RandomNumberGenerator.new()

var equalizer_state: Dictionary[String, Variant]

var screw_states: Dictionary[String, Array]

var fuel_states: Dictionary[String, Dictionary]

var pipe_states: Dictionary[String, Array]

var tube_states: Dictionary[String, Array]

var limited_break_functions := [
	break_equalizer,
	unload_fuel.bind("fuel_1"),
	unload_fuel.bind("fuel_2"),
]

func default_values():

	equalizer_state = {
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

	screw_states = {
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
			false,
			false
		], 
		'screw_screen_4' = [
			false,
			false,
			false,
			false
		]
	}
	fuel_states = {
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

	pipe_states = {
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
			false,
			false,
			false
		],
		'pipe_5' = [
			false,
			false
		]
	}

	tube_states = {
		'tube_1' = [
			false,
			false,
			false,
			false
		],
		'tube_2' = [
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
			false,
			false
		],
		'tube_5' = [
			false,
			false,
			false
		]
	}

func setup() -> void:
	default_values()
	roll_equalizer()
	break_things(15)


func break_things(number: int) -> void:
	var limited_breaks = rng.randi_range(0, 3)
	break_limited(limited_breaks)
	number -= limited_breaks
	var new_breaks = rng.randi_range(1, number-2)
	number -= new_breaks
	break_screws(new_breaks)
	new_breaks = rng.randi_range(1, number-1)
	number -= new_breaks
	break_tubes(new_breaks)
	break_pipes(number)
	
func break_limited(number: int):
	var functions = limited_break_functions.duplicate()
	while number > 0:
		var selecionado: int = rng.randi_range(0, functions.size() -1)
		functions[selecionado].call()
		functions.remove_at(selecionado)
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
		count_screws('screw_screen_4')
	)


func get_thruster_2_screws() -> int:
	return (
		count_screws('screw_screen_1') +
		count_screws('screw_screen_2') +
		count_screws('screw_screen_3') +
		count_screws('screw_screen_4')
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
			get_true_amount(tube_states['tube_5'])
	)


func get_temp_pipe() -> float:
	return (
			get_true_amount(pipe_states['pipe_1']) * 2.5 +
			get_true_amount(pipe_states['pipe_2']) * 2.5 +
			get_true_amount(pipe_states['pipe_5']) * 3.5
	)


func get_thruster_1_pipes() -> int:
	return (
			get_true_amount(pipe_states['pipe_1']) +
			get_true_amount(pipe_states['pipe_2']) +
			get_true_amount(pipe_states['pipe_3']) +
			get_true_amount(pipe_states['pipe_4']) +
			get_true_amount(pipe_states['pipe_5'])
	)


func get_thruster_2_pipes() -> int:
	return (
			get_true_amount(pipe_states['pipe_1']) +
			get_true_amount(pipe_states['pipe_2']) +
			get_true_amount(pipe_states['pipe_3']) +
			get_true_amount(pipe_states['pipe_4']) +
			get_true_amount(pipe_states['pipe_5'])
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

func break_tubes(ammount: int) -> void:
	var tube_list := tube_states.keys()
	while ammount > 0:
		var selected_panel = tube_list[rng.randi_range(0,tube_list.size() - 1)]
		var tubes = tube_states[selected_panel]
		var okay_tubes = []
		for i in range(tubes.size()):
			if !tubes[i]:
				okay_tubes.append(i)
		if okay_tubes.size() > 0:
			var selected_tube = okay_tubes[rng.randi_range(0,okay_tubes.size()  - 1)]
			tube_states[selected_panel][selected_tube] = true
			tube_list.append(selected_panel)
			ammount -= 1
		else:
			tube_list = tube_list.filter(func filter_finished(panel): return panel != selected_panel)

func break_pipes(ammount: int) -> void:
	var pipe_list := pipe_states.keys()
	while ammount > 0:
		var selected_panel = pipe_list[rng.randi_range(0,pipe_list.size() - 1)]
		var pipes = pipe_states[selected_panel]
		var okay_pipes = []
		for i in range(pipes.size()):
			if !pipes[i]:
				okay_pipes.append(i)
		if okay_pipes.size() > 0:
			var selected_pipe = okay_pipes[rng.randi_range(0,okay_pipes.size()  - 1)]
			pipe_states[selected_panel][selected_pipe] = true
			pipe_list.append(selected_panel)
			ammount -= 1
		else:
			pipe_list = pipe_list.filter(func filter_finished(panel): return panel != selected_panel)

func break_screws(ammount: int) -> void:
	var screw_list := screw_states.keys()
	while ammount > 0:
		var selected_panel = screw_list[rng.randi_range(0,screw_list.size() - 1)]
		var screws = screw_states[selected_panel]
		var okay_screws = []
		for i in range(screws.size()):
			if !screws[i]:
				okay_screws.append(i)
		if okay_screws.size() > 0:
			var selected_screw = okay_screws[rng.randi_range(0,okay_screws.size()  - 1)]
			screw_states[selected_panel][selected_screw] = true
			screw_list.append(selected_panel)
			ammount -= 1
		else:
			screw_list = screw_list.filter(func filter_finished(panel): return panel != selected_panel)

func unload_fuel(panel):
	fuel_states[panel]['full'] = false
