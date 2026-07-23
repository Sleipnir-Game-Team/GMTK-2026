extends Area2D

@onready var use_unlock: Node = %use_unlock

@export var password: String = "":
	set(new_value):
		password = new_value
		use_unlock.password = new_value
