extends BaseTool

@onready var use_unlock: BaseBehaviour = %use_unlock

@export var color: StringName = "":
	set(new_value):
		color = new_value
		use_unlock.color = new_value
