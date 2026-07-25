extends BaseTool

## -1 = closed
var current_page: int = -1:
	set(new_page):
		if new_page > pages.size() - 1:
			return
		current_page = new_page
		if current_page != -1:
			_update_pages()

@onready var closed: Sprite2D = %closed
@onready var open: Sprite2D = %open

@onready var next_page: Area2D = %next_page
@onready var open_book: Area2D = %open_book
@onready var previous_page: Area2D = %previous_page

@onready var left_page: TextEdit = %LeftPage
@onready var right_page: TextEdit = %RightPage
@onready var edit_button: Button = %EditButton

@onready var use_draggable: Node = %use_draggable

var pages: Array[Dictionary] = []


func _ready() -> void:
	var page: Dictionary = {
		"left": "",
		"right": "",
		"editable": false
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
		use_draggable._dragging = false
		open_book.process_mode = Node.PROCESS_MODE_DISABLED
		next_page.process_mode = Node.PROCESS_MODE_INHERIT
		previous_page.process_mode = Node.PROCESS_MODE_INHERIT


func _set_sprite_open(new: bool) -> void:
	open.visible = new
	closed.visible = not new


func _on_left_page_text_changed() -> void:
	var max_lines: int = 9
	var row_count: int = 0
	var valid_text: String = ""
	var text_line_count: int = left_page.get_line_count()
	
	for i in range(text_line_count):
		var next_row_count: int = 1 + left_page.get_line_wrap_count(i)
		if row_count + next_row_count > max_lines:
			var caret_line: int = left_page.get_caret_line()
			var caret_col: int = left_page.get_caret_column()
			left_page.text = pages[current_page].left
			
			# reset caret to previous position
			if caret_line >= left_page.get_line_count():
				caret_line = left_page.get_line_count()-1
				caret_col = left_page.get_line(caret_line).length()
			
			left_page.set_caret_line(caret_line, false)
			left_page.set_caret_column(caret_col, false)
			break
		else:
			# add the entire line
			row_count += next_row_count
			if valid_text != "":
				valid_text += "\n"
			valid_text += left_page.get_line(i)

	pages[current_page].left = left_page.text


func _on_right_page_text_changed() -> void:
	var max_lines: int = 9
	var row_count: int = 0
	var valid_text: String = ""
	var text_line_count: int = right_page.get_line_count()
	
	for i in range(text_line_count):
		var next_row_count: int = 1 + right_page.get_line_wrap_count(i)
		if row_count + next_row_count > max_lines:
			var caret_line: int = right_page.get_caret_line()
			var caret_col: int = right_page.get_caret_column()
			right_page.text = pages[current_page].right
			
			# reset caret to previous position
			if caret_line >= right_page.get_line_count():
				caret_line = right_page.get_line_count()-1
				caret_col = right_page.get_line(caret_line).length()
			
			right_page.set_caret_line(caret_line, false)
			right_page.set_caret_column(caret_col, false)
			break
		else:
			# add the entire line
			row_count += next_row_count
			if valid_text != "":
				valid_text += "\n"
			valid_text += right_page.get_line(i)

	pages[current_page].right = right_page.text


func _update_pages() -> void:
	left_page.text = pages[current_page].left
	left_page.editable = pages[current_page].editable
	
	right_page.text = pages[current_page].right
	right_page.editable = pages[current_page].editable


func _on_edit_button_pressed() -> void:
	use_draggable._dragging = false
	left_page.editable = not left_page.editable
	right_page.editable = not right_page.editable
	if left_page.editable:
		left_page.grab_focus()


func _on_use_draggable_drag_start() -> void:
	if left_page.editable or right_page.editable:
		use_draggable._dragging = false
