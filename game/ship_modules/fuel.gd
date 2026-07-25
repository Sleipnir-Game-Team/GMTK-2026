extends Node2D

@export var aberta = false
@export var cheia = true
@export var cor = 'azul'

@export var img_azul = Texture2D
@export var img_vermelha = Texture2D
@export var img_vazia = Texture2D
@export var img_cheia = Texture2D

@export var screen_name: StringName

func _ready():
	var state_manager = get_tree().get_first_node_in_group("Jogo").state_manager
	var state = state_manager.fuel_states[screen_name]
	
	aberta = state.open
	cheia = state.full
	cor = state.color
	

func update_door():
	var img = Texture2D
	if aberta:
		if cheia:
			img = img_cheia
		else:
			img = img_vazia
	else:
		match(cor):
			'azul': img_azul
			'vermelha': img_vermelha
