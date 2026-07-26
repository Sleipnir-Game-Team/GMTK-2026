extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@export var pivot_dict:Dictionary[StringName, Vector2] = {}

func _ready() -> void:
	UI_Controller.stack.screens.append(self)
	anim_player.play("fade_in")
	
	# se for a primeira vez entrando, se pa desnecessario 
	# mas eu nao lembro se o maestro tem guard pra isso fr
	SleipnirMaestro.load_song("mainmenu")
	SleipnirMaestro.play()

## Função que roda quando você aperta o botão de "jogar"
func _on_play_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/save_menu.tscn", get_tree().root)


## Função que roda quando você aperta o botão de "opções"
func _on_options_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/options_menu.tscn", get_tree().root)


## Função que roda quando você aperta o botão de "opções"
func _on_credits_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	UI_Controller.openScreen("res://ui/menu/credits_menu.tscn", get_tree().root)


## Função que roda quando você aperta o botão de "sair"
func _on_quit_button_pressed() -> void:
	AudioManager.play_global("ui.button.click")
	get_tree().quit() # Fecha a aplicação
