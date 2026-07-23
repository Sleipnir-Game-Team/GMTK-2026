extends Area2D

var item : Node2D
@export var textura : TextureRect

func add_item(new_item: Node2D):
	item = new_item
	add_child(item)
	var sprite: Sprite2D = item.get_node("Sprite2D")
	item.visible = false
	textura.texture = sprite.texture
	

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		item.visible = true
		var draggable = item.get_node("Draggable")
		draggable._drag_offset = Vector2.ZERO #item.get_local_mouse_position() * item.get_screen_transform().get_scale()
		draggable._dragging = true
		item.reparent(get_tree().get_first_node_in_group("Jogo"))
		queue_free()
