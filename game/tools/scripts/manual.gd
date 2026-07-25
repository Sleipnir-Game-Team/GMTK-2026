extends BaseTool

## -1 = closed
var current_page: int = -1:
	set(new_page):
		current_page = new_page
		_update_pages()

@onready var closed: Sprite2D = %closed
@onready var open: Sprite2D = %open

@onready var next_page: Area2D = %next_page
@onready var open_book: Area2D = %open_book
@onready var previous_page: Area2D = %previous_page

@onready var left_page: TextEdit = %LeftPage
@onready var right_page: TextEdit = %RightPage

var pages: Array[Dictionary] = []


func _ready() -> void:
	var page: Dictionary = {
		"left": "",
		"right": "",
		"editable": true
	}
	
	for index in 10:
		pages.append(page.duplicate())


func _on_next_page_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		current_page += 1


func _on_previous_page_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		current_page -= 1
		
		if current_page < 0:
			_set_sprite_open(false)
			open_book.process_mode = Node.PROCESS_MODE_INHERIT
			next_page.process_mode = Node.PROCESS_MODE_DISABLED
			previous_page.process_mode = Node.PROCESS_MODE_DISABLED


func _on_open_book_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		current_page = 0
		_set_sprite_open(true)
		open_book.process_mode = Node.PROCESS_MODE_DISABLED
		next_page.process_mode = Node.PROCESS_MODE_INHERIT
		previous_page.process_mode = Node.PROCESS_MODE_INHERIT


func _set_sprite_open(new: bool) -> void:
	open.visible = new
	closed.visible = not new


func _on_left_page_text_changed() -> void:
	pages[current_page].left = left_page.text


func _on_right_page_text_changed() -> void:
	pages[current_page].right = right_page.text


func _update_pages() -> void:
	left_page.text = pages[current_page].left
	left_page.editable = pages[current_page].editable
	
	right_page.text = pages[current_page].right
	right_page.editable = pages[current_page].editable
