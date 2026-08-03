extends Node

@export var time_limit: float = 0.0
@export var time_interval: float = 0.0
@export var panel_dict: Dictionary[Node, PackedScene] = {}
@export var state_manager: Node
@export var animation_player: AnimationPlayer
@export var animation_player_extra: AnimationPlayer
@export var animation_player_bus: AnimationPlayer

@export var screen_2: Node2D
@export var manual: BaseTool

@export var teste: Label

var current_panel: Node
var current_segment: Node

var ship_timer: Timer
var interval_timer: Timer

var screen_on := false

var ship_attributes := {
	'oxigen': 21.5,
	'temp': 30
}

var fixed_ships := 0
var blown_ships := 0

var oxigen: float:
	get:
		var oxigen_final: float = ship_attributes['oxigen']
		oxigen_final += state_manager.get_equalizer_oxi_value()
		oxigen_final += state_manager.get_oxigen_tube()
		oxigen_final += state_manager.get_oxigen_screws()
		return clampf(oxigen_final, 0, 100)

var temp: float:
	get:
		var temp_final: float = ship_attributes['temp']
		temp_final += state_manager.get_equalizer_temp_value()
		temp_final += state_manager.get_temp_pipe()
		return temp_final

var propulsor_1: bool:
	get:
		var total_screws:int = state_manager.get_screw_total()
		var total_pipes:int = state_manager.get_pipe_total()
		var okay: bool = state_manager.get_thruster_1_screws() <= total_screws * 0.5
		okay = okay and state_manager.get_thruster_1_fuel()
		okay = okay and  state_manager.get_thruster_1_pipes() <= total_pipes * 0.5
		return okay

var propulsor_2: bool:
	get:
		var total_screws:int = state_manager.get_screw_total()
		var total_pipes:int = state_manager.get_pipe_total()
		var okay: bool = state_manager.get_thruster_2_screws() <= total_screws * 0.5
		okay = okay and state_manager.get_thruster_2_fuel()
		okay = okay and  state_manager.get_thruster_2_pipes() <= total_pipes * 0.5
		return okay

var ship_conditions := {
	'min_oxigen': 19.5,
	'max_oxigen': 23.5,
	'min_temp': 20,
	'max_temp': 40
}


func _ready() -> void:
	for panel in panel_dict:
		panel.pressed.connect(_on_ship_panel_pressed.bind(panel))



func setup(_save_data: Dictionary) -> void:
	if _save_data:
		manual.pages = _save_data.pages

func start_run() -> void:
	configure_run()
	animation_player.play("turn_on_screen")
	animation_player.queue("open_curtains")
	animation_player_bus.play("arrive")
	start_timer()

func configure_run() -> void:
	state_manager.setup()


func save() -> Dictionary:
	var data:Dictionary = {}
	data["pages"] = manual.pages
	print(manual.pages)
	data["save_time"] = Time.get_datetime_dict_from_system()
	data["perfect_run"] = false #TODO modificar para ser uma variável do sistema
	
	return data


func start_timer() -> void:
	ship_timer = Timer.new()
	ship_timer.wait_time = time_limit
	ship_timer.timeout.connect(evaluate_ship)
	ship_timer.one_shot = true
	
	add_child(ship_timer)
	ship_timer.start()
	
	interval_timer = Timer.new()
	interval_timer.wait_time = time_interval
	interval_timer.timeout.connect(start_run)
	interval_timer.one_shot = true
	
	add_child(interval_timer)


func evaluate_ship() -> void:
	if check_conditions():
		fix_ship()
	else:
		blow_ship()
	
	if fixed_ships + blown_ships >= 10:
		if blown_ships >= 7:
			Game_Manager.game_over()
		else:
			Game_Manager.win_game()
	else:
		animation_player.play_backwards("turn_on_screen")
		animation_player_extra.play_backwards("open_curtains")
		interval_timer.start()


func fix_ship() -> void:
	fixed_ships += 1 
	animation_player_bus.play("happy_departure")


func blow_ship() -> void:
	blown_ships += 1 
	AudioManager.play_global("game.failure.scream")
	animation_player_bus.play("sad_departure")


func check_conditions() -> bool:
	var passable: bool = (
			oxigen < ship_conditions['max_oxigen'] 
			and oxigen > ship_conditions['min_oxigen']
			and temp < ship_conditions['max_temp'] 
			and temp > ship_conditions['min_temp']
			and propulsor_1
			and propulsor_2
	)
	
	#for condition:String in ship_conditions.keys():
		#if(
			#condition.begins_with("min_") and ship_attributes[condition.right(-4)] < ship_conditions[condition] 
			#or condition.begins_with("max_") and ship_attributes[condition.right(-4)] > ship_conditions[condition] 
			#or !(condition.begins_with("min_") or condition.begins_with("max_")) and ship_attributes[condition] != ship_conditions[condition]
			#):
			#passable = false
			#break
	return passable


func _process(_delta: float) -> void:
	if ship_timer and !ship_timer.is_stopped():
		teste.text = "%02d until launch" % ship_timer.time_left
	elif interval_timer and !interval_timer.is_stopped():
		teste.text = "%02d until next" % interval_timer.time_left
	else:
		teste.text = "Waiting for start (Pull the cord)"


func _on_ship_panel_pressed(panel: Node) -> void:
	var changing := current_panel != panel
	
	if current_panel:
		if !current_segment.visible:
			changing = true
		current_segment.queue_free()
		current_panel = null
	
	if changing:
		current_segment = panel_dict[panel].instantiate()
		screen_2.add_child(current_segment)
		current_panel = panel
	
	if screen_on and current_panel == null:
		animation_player.speed_scale = 5
		animation_player.play_backwards("bring_screen_2")
		screen_on = false
	elif !screen_on and current_panel != null:
		animation_player.speed_scale = 5
		animation_player.play("bring_screen_2")
		screen_on = true
	
	#if current_segments.has(panel):
		#current_segments[panel].queue_free()
		#current_segments.erase(panel)
	#else:
		#current_segments[panel] = panel_dict[panel].instantiate()
		#add_child(current_segments[panel])
