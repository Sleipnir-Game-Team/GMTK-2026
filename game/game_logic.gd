extends Node

@export var time_limit := 0.0
@export var panel_dict : Dictionary[Node, PackedScene] = {}
@export var state_manager : Node

var current_panel: Node
var current_segment: Node


var ship_attributes := {
	'oxigen': 21.5,
	'temp': 30,
	'propulsor_1': true,
	'propulsor_2': true,
	'propulsor_3': true
}

var oxigen: float:
	get:
		var oxigen_final = ship_attributes['oxigen']
		oxigen_final += state_manager.get_equalizer_oxi_value()
		return clamp(oxigen_final, 0, 100)
var temp: float:
	get:
		var temp_final = ship_attributes['temp']
		temp_final += state_manager.get_equalizer_temp_value()
		return temp_final
var propulsor_1: float:
	get:
		return ship_attributes['propulsor_1']
var propulsor_2: float:
	get:
		return ship_attributes['propulsor_2']
var propulsor_3: float:
	get:
		return ship_attributes['propulsor_3']

var ship_conditions := {
	'min_oxigen': 19.5,
	'max_oxigen': 23.5,
	'min_temp': 10,
	'max_temp': 50,
	'propulsor_1': true,
	'propulsor_2': true,
	'propulsor_3': true
}


func _ready() -> void:
	for panel in panel_dict:
		panel.pressed.connect(_on_ship_panel_pressed.bind(panel))

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
	if (oxigen > ship_conditions['max_oxigen'] or oxigen < ship_conditions['min_oxigen']
		or temp > ship_conditions['max_temp'] or temp < ship_conditions['min_temp']
		or !propulsor_1
		or !propulsor_2
		or !propulsor_3):
		passable = false
	#for condition:String in ship_conditions.keys():
		#if(
			#condition.begins_with("min_") and ship_attributes[condition.right(-4)] < ship_conditions[condition] 
			#or condition.begins_with("max_") and ship_attributes[condition.right(-4)] > ship_conditions[condition] 
			#or !(condition.begins_with("min_") or condition.begins_with("max_")) and ship_attributes[condition] != ship_conditions[condition]
			#):
			#passable = false
			#break
	return passable


func _on_ship_panel_pressed(panel: Node) -> void:
	var changing := current_panel != panel
	if current_panel:
		current_segment.queue_free()
		current_panel = null
	if changing:
		current_segment = panel_dict[panel].instantiate()
		get_parent().add_child(current_segment)
		current_panel = panel
		
	#if current_segments.has(panel):
		#current_segments[panel].queue_free()
		#current_segments.erase(panel)
	#else:
		#current_segments[panel] = panel_dict[panel].instantiate()
		#add_child(current_segments[panel])
