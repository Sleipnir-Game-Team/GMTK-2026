extends Node

@export var time_limit := 0.0
@export var panel_dict : Dictionary[StringName, PackedScene] = {}

var ship_attributes := {
	'light_color': 'red',
	'door': 'closed'
}

var ship_conditions := {
	'light_color': 'green',
	'door': 'open'
}

var current_segments: Dictionary[StringName, Node2D]

func setup(save_data: Dictionary) -> void:
	start_timer()

func save() -> Dictionary:
	return {}

func start_timer() -> void:
	var ship_timer := Timer.new()
	ship_timer.wait_time = time_limit
	ship_timer.timeout.connect(evaluate_ship)
	
	add_child(ship_timer)
	ship_timer.start()

func evaluate_ship() -> void:
	if check_conditions():
		GameManager.win_game()
	else:
		GameManager.game_over()
	
func check_conditions() -> bool:
	var passable := true
	for condition:String in ship_conditions.keys():
		if ship_attributes[condition] != ship_conditions[condition]:
			passable = false
			break
	return passable

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_turn_green"):
		ship_attributes['light_color'] = 'green'
	if event.is_action_pressed("test_turn_red"):
		ship_attributes['light_color'] = 'red'


func _on_ship_panel_pressed(panel: StringName) -> void:
	if current_segments.has(panel):
		current_segments[panel].queue_free()
		current_segments.erase(panel)
	else:
		current_segments[panel] = panel_dict[panel].instantiate()
		add_child(current_segments[panel])
