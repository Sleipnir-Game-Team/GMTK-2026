@tool
extends BaseBehaviour

## Store this tool
func act(use: Area2D) -> void:
	use.get_parent().store(get_parent())
