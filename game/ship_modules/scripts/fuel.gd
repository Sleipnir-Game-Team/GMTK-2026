extends Node2D

const DOOR_POSITION_OPEN := Vector2(80, 44.0)
const DOOR_POSITION_CLOSED := Vector2(322.0, 44.0)

@export var aberta: bool = false:
	set(valor):
		aberta = valor
		update_door()
		update_state('open', valor)

@export var cheia: bool = true:
	set(valor):
		cheia = valor
		update_door()
		update_state('full', valor)

@export var cor: String = 'blue':
	set(valor):
		cor = valor
		update_door()
		update_state('color', valor)

@export var img_azul: Texture2D
@export var img_vermelha: Texture2D
@export var img_vazia: Texture2D
@export var img_cheia: Texture2D

@export var image: TextureRect
@export var screen_name: StringName

@onready var state_manager: StateManager = get_tree().get_first_node_in_group("Jogo").state_manager


func _ready() -> void:
	var state: Dictionary = state_manager.fuel_states[screen_name]
	
	aberta = state.open
	cheia = state.full
	cor = state.color
	update_door()


func update_door() -> void:
	match [aberta, cor, cheia]:
		[true, _, true]:
			image.position = DOOR_POSITION_OPEN
			image.texture = img_cheia
		[true, _, false]:
			image.position = DOOR_POSITION_OPEN
			image.texture = img_vazia
		[false, 'blue', _]:
			image.position = DOOR_POSITION_CLOSED
			image.texture = img_azul
		[false, 'red', _]:
			image.position = DOOR_POSITION_CLOSED
			image.texture = img_vermelha
	
	image.size = Vector2(0, 0)

func update_state(slot, value) -> void:
	state_manager.fuel_states[screen_name][slot] = value
