@tool
extends BaseBehaviour

func act(tank: Area2D):
	if tank.aberta and !tank.cheia:
		tank.cheia = true
		get_parent().queue_free()
