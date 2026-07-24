extends Node2D

@export var label :Label

func _ready():
	var jogo := get_tree().get_first_node_in_group("Jogo")
	var temp :float =  jogo.temp
	var max_temp :float =  jogo.ship_conditions['max_temp']
	var min_temp :float =  jogo.ship_conditions['min_temp']
	if temp > max_temp or temp < min_temp:
		label.label_settings.font_color = Color.RED
	else:
		label.label_settings.font_color = Color.GREEN
	label.text = 'Temperature is: '+str(temp)+'°C'
