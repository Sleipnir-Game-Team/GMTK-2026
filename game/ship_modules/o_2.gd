extends Node2D

@export var label :Label

func _ready():
	var jogo := get_tree().get_first_node_in_group("Jogo")
	var o2 :float =  jogo.oxigen
	var max_o2 :float =  jogo.ship_conditions['max_oxigen']
	var min_o2 :float =  jogo.ship_conditions['min_oxigen']
	if o2 > max_o2 or o2 < min_o2:
		label.label_settings.font_color = Color.RED
	else:
		label.label_settings.font_color = Color.GREEN
	label.text = 'Oxygen in the air is: '+str(o2)+'%'
