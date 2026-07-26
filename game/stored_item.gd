extends Area2D

var item : Node2D
@export var textura : TextureRect
@export var colision : CollisionShape2D

func add_item(new_item: Node2D, image: Texture2D) -> void:
	item = new_item
	if item.get_parent():
		item.reparent(self)
	else:
		add_child(item)
	item.visible = false
	textura.texture = image
	textura.position.y = -image.get_size().y
	colision.position = Vector2(image.get_size().x * 0.5, image.get_size().y * - 0.5)
	colision.shape.size = image.get_size()
	print(colision.shape.size)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		item.visible = true
		var draggable: Node = item.get_node("use_draggable")
		draggable._drag_offset = Vector2.ZERO #item.get_local_mouse_position() * item.get_screen_transform().get_scale()
		draggable._dragging = true
		item.reparent(get_tree().get_first_node_in_group("Jogo"))
		if item.has_node("use_store"):
			queue_free()
		else:
			item = item.duplicate()
			add_child(item)
			item.visible = false
