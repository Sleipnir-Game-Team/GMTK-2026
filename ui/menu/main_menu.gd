extends Control

const ICARUS_POINT = preload("uid://y038335n03kj")
const ICARUS_GRAB = preload("uid://7flyn1q0nw1e")

@onready var gaveta = get_node("%gaveta")

func _ready() -> void:
	Input.set_custom_mouse_cursor(ICARUS_POINT, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(ICARUS_GRAB, Input.CURSOR_MOVE)

	UI_Controller.stack.screens.append(self)
	
	# se for a primeira vez entrando, se pa desnecessario 
	# mas eu nao lembro se o maestro tem guard pra isso fr
	SleipnirMaestro.load_song("mainmenu")
	SleipnirMaestro.play()


## Função que roda quando você aperta o botão de "jogar"
func _on_play_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/save_menu.tscn", get_tree().root, {"path":"res://ui/menu/save_menu.tscn"})


## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", gaveta)


## Função que roda quando você aperta o botão de "opções"
func _on_credits_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/credits_menu.tscn", get_tree().root)


## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	get_tree().quit() # Fecha a aplicação


func _on_play_button_mouse_entered() -> void:
	AudioManager.play_global("ui.button.hover")
