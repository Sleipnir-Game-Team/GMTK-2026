extends BaseTool

@onready var use_unlock: BaseBehaviour = %use_unlock

@export var password: StringName = "":
	set(new_value):
		password = new_value
		use_unlock.password = new_value
