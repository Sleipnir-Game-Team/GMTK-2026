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
	var o2 :float =  jogo.oxigen
	var max_o2 :float =  jogo.ship_conditions['max_oxigen']
	var min_o2 :float =  jogo.ship_conditions['min_oxigen']
	if o2 > max_o2 or o2 < min_o2:
		label.label_settings.font_color = Color.RED
		sprite_icon.texture = danger_icon
		sprite_status.texture = danger_status
	else:
		label.label_settings.font_color = Color.GREEN
		sprite_icon.texture = safe_icon
		sprite_status.texture = safe_status
	label.text = str(snapped(o2,0.01))+'%'
