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

@onready var closed_drag_box: CollisionShape2D = %ClosedDragBox
@onready var open_drag_box: CollisionShape2D = %OpenDragBox

var pages: Array[Dictionary] = [{
	"left": """Welcome to Icarus Inc. My name is Manuel, and my manual will teach you everything you need to hit your quota and then some.
In case you’ve forgotten your job (which seems like a serious problem, though it wouldn't be the first time) your task is to ensure that a good number of""",
	"right": """Icarus's space buses depart intact and complete their journeys successfully.

To ensure this, keep an eye on the vehicle's indicators and fix any problems you find as quickly as possible.""",
	"_editable": false
	},
	{
	"left": """The indicator is located at the front of the vehicle; if it’s all clear, meaning oxygen and temperature levels are within range and the engines are running, then your job is done.
You’ll find everything you need for the job inside the locker; if one tool doesn't work, try using another.""",
	"right": """If at least half of the vehicles don't burn up, you'll probably get hired!

If you discover something I didn't (unlikely), feel free to jot down notes in the blank spaces; you might even find notes left by former employees in this manual.""",
	"_editable": false
	},
	{
	"left": "If you're ready just pull the cord",
	"right": "",
	"_editable": false
	}
]


func _ready() -> void:
	var page: Dictionary = {
		"left": "",
		"right": "",
		"_editable": false
	}
	
	for index in 17:
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


func _set_sprite_open(_open: bool) -> void:
	open.visible = _open
	open_drag_box.disabled = not _open
	
	closed.visible = not _open
	closed_drag_box.disabled = _open


func _on_left_page_text_changed() -> void:
	var max_lines: int = 11
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
	var max_lines: int = 11
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
	var shape := Control.CURSOR_IBEAM if pages[current_page]._editable else Control.CURSOR_MOVE 
	left_page.text = pages[current_page].left
	left_page.editable = pages[current_page]._editable
	left_page.mouse_default_cursor_shape = shape
	
	right_page.text = pages[current_page].right
	right_page.editable = pages[current_page]._editable
	right_page.mouse_default_cursor_shape = shape



func _on_edit_button_pressed() -> void:
	use_draggable._dragging = false
	pages[current_page]._editable = not pages[current_page]._editable
	_update_pages()
	if left_page.editable:
		left_page.grab_focus()


func _on_use_draggable_drag_start() -> void:
	if current_page != -1 and (left_page.editable or right_page.editable):
		use_draggable._dragging = false
