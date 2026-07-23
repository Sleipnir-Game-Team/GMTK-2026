extends BaseBehaviour


func be_stored(use: Area2D) -> void:
	use.get_parent().store(get_parent())
