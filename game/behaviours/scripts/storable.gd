@tool
extends BaseBehaviour

@export var store_image : Texture2D

## Store this tool
func act(use: Area2D) -> void:
	use.get_parent().store(get_parent(), store_image)
