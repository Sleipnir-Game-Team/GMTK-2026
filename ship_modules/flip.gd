extends Node2D

func _ready():
	get_child(0).button_pressed = get_tree().get_first_node_in_group("Jogo").ship_attributes['light_color'] == 'green'

func _on_check_button_toggled(toggled_on: bool) -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	if toggled_on:
		jogo.ship_attributes['light_color'] = 'green'
	else:
		jogo.ship_attributes['light_color'] = 'red'
