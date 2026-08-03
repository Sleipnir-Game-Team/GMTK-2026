@tool
extends BaseBehaviour

func act(tank: Area2D) -> void:
	if tank.aberta and not tank.cheia:
		tank.cheia = true
		get_parent().queue_free()
