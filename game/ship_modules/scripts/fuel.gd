extends Node2D

@export var aberta = false:
	set(valor):
		aberta = valor
		update_door()
		update_state('open', valor)
@export var cheia = true:
	set(valor):
		cheia = valor
		update_door()
		update_state('full', valor)
@export var cor = 'blue':
	set(valor):
		cor = valor
		update_door()
		update_state('color', valor)

@export var img_azul = Texture2D
@export var img_vermelha = Texture2D
@export var img_vazia = Texture2D
@export var img_cheia = Texture2D

@export var image : TextureRect

@export var screen_name: StringName

func _ready():
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var state = state_manager.fuel_states[screen_name]
	
	aberta = state.open
	cheia = state.full
	cor = state.color
	property_list_changed
	update_door()
	

func update_door():
	var img = Texture2D
	if aberta:
		image.position = Vector2(80,44.0)
		if cheia:
			img = img_cheia
		else:
			img = img_vazia
	else:
		image.position = Vector2(322.0,44.0)
		match(cor):
			'blue': img = img_azul
			'red': img = img_vermelha
	image.texture = img
	image.size = Vector2(0,0)

func update_state(slot, value):
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	state_manager.fuel_states[screen_name][slot] = value
