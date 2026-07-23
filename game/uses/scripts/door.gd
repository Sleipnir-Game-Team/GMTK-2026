extends Area2D


@export var password: StringName = ""

func _ready():
	var jogo = get_tree().get_first_node_in_group("Jogo")
	if (jogo.ship_attributes['door'] == 'open'):
		queue_free()

## Triggered when fully opened by the AnimationPlayer
func _fucking_kill_myself() -> void:
	var jogo = get_tree().get_first_node_in_group("Jogo")
	jogo.ship_attributes['door'] = 'open'
	queue_free()
