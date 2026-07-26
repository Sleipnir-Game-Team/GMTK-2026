extends Node2D

@export var label :Label

@export var danger_icon: Texture2D
@export var safe_icon: Texture2D
@export var danger_status: Texture2D
@export var safe_status: Texture2D

@export var sprite_icon: Sprite2D
@export var sprite_status: Sprite2D

func _ready() -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	var temp :float =  jogo.temp
	var max_temp :float =  jogo.ship_conditions['max_temp']
	var min_temp :float =  jogo.ship_conditions['min_temp']
	if temp > max_temp or temp < min_temp:
		label.label_settings.font_color = Color.RED
		sprite_icon.texture = danger_icon
		sprite_status.texture = danger_status
	else:
		label.label_settings.font_color = Color.GREEN
		sprite_icon.texture = safe_icon
		sprite_status.texture = safe_status
	label.text = str(snapped(temp,1))+' °C'
