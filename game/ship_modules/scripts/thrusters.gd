extends Node2D

@export var thruster_inoperant: Texture2D
@export var thruster_operant: Texture2D

@export var thruster_1_inoperant: Texture2D
@export var thruster_1_operant: Texture2D
@export var thruster_2_inoperant: Texture2D
@export var thruster_2_operant: Texture2D

@export var thruster_1: Sprite2D
@export var thruster_2: Sprite2D
@export var thruster_1_operation: Sprite2D
@export var thruster_2_operation: Sprite2D

func _ready() -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	var thruster_1_status :bool =  jogo.propulsor_1
	var thruster_2_status :bool =  jogo.propulsor_2
	
	if thruster_1_status:
		thruster_1.texture = thruster_operant
		thruster_1_operation.texture = thruster_1_operant
	else:
		thruster_1.texture = thruster_inoperant
		thruster_1_operation.texture = thruster_1_inoperant
	
	if thruster_2_status:
		thruster_2.texture = thruster_operant
		thruster_2_operation.texture = thruster_2_operant
	else:
		thruster_2.texture = thruster_inoperant
		thruster_2_operation.texture = thruster_2_inoperant
