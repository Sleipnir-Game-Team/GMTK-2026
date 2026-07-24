extends Node2D

@export var label_1 :Label
@export var label_2 :Label
@export var label_3 :Label

func _ready():
	var jogo := get_tree().get_first_node_in_group("Jogo")
	var thruster_1 :bool =  jogo.propulsor_1
	var thruster_2 :bool =  jogo.propulsor_2
	var thruster_3 :bool =  jogo.propulsor_3
	
	if thruster_1:
		label_1.label_settings.font_color = Color.GREEN
	else:
		label_1.label_settings.font_color = Color.RED
		
	if thruster_2:
		label_2.label_settings.font_color = Color.GREEN
	else:
		label_2.label_settings.font_color = Color.RED
		
	if thruster_3:
		label_3.label_settings.font_color = Color.GREEN
	else:
		label_3.label_settings.font_color = Color.RED
	label_1.text = 'Thruster 1 is '+ ('operant' if thruster_1 else 'inoperant')
	label_2.text = 'Thruster 2 is '+ ('operant' if thruster_2 else 'inoperant')
	label_3.text = 'Thruster 3 is '+ ('operant' if thruster_3 else 'inoperant')
