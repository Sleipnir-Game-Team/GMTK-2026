extends MarginContainer

@onready var keybinding_list: VBoxContainer = get_node("%keybinding_list")
@onready var input_button_scene: = preload("res://ui/buttons/input_button.tscn")
var is_remapping: = false
var action_to_remap: Variant = null
var remapping_button: Variant = null
var saved_keybinding_settings: Dictionary = Config_Handler.load_all_keybinding_settings()
var action_translated_dict: Dictionary = format_actions(InputMap.get_actions())

func _ready() -> void:
	#Verifica se está tudo certo com o mapping na inicialização
	var recreate_initial_inputs: bool = !verify_initial_input_mapping()
	verify_action_list(recreate_initial_inputs)

# Formata as labels de keybindings para transformar/traduzir para português de forma legível
func format_actions(actions: Array) -> Dictionary:
	var action_dict := {}
	for item: String in actions:
		if item in saved_keybinding_settings.keys():
			match item:
				"pause":
					action_dict[item] = "Pause"
				"win":
					action_dict[item] = "Win the game"
				"lose":
					action_dict[item] = "Lose the game"
				"reset_configs":
					action_dict[item] = "Reset configs (debug only)"
	return action_dict

# Verifica se o input inicial está de acordo dos 2 lados 
# 	(dados do mapa do jogo e do mapa dos arquivos salvos existem)
func verify_initial_input_mapping() -> bool:
	var equal: bool = true
	var count: int = 0
	while (equal && count < action_translated_dict.keys().size()):
		var new_action: String = action_translated_dict.keys()[count]
		if typeof(InputMap.action_get_events(new_action)[0]) != typeof(saved_keybinding_settings[new_action]):
			equal = false
		count += 1
	return equal

# Verifica se a lista de keybindings precisa de atualização e atualiza
func verify_action_list(must_recreate: bool) -> void:
	if must_recreate:
		InputMap.load_from_project_settings()
	
	for item in keybinding_list.get_children():
		item.queue_free()
	
	for action: String in action_translated_dict:
		var button := input_button_scene.instantiate()
		var action_label := button.find_child("action_label")
		var input_label := button.find_child("input_label")
		action_label.text = action_translated_dict[action]
		if !must_recreate:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, saved_keybinding_settings[action])
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix("- Physical")
			Config_Handler.save_keybinding_settings(action, events[0])
		else:
			input_label.text = ""
		
		keybinding_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

# Chamado quando um dos botões de remap é pressionado
func _on_input_button_pressed(button: Node, action: String) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("input_label").text = "Escolha a tecla..."

# Chamado quando a tecla para remapear é selecionada
func _input(event: InputEvent) -> void:
	if is_remapping:
		if (event is InputEventKey && event.pressed) || (event is InputEventMouseButton && event.pressed):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			var is_key_already_binded: Variant = check_bind(event)
			if !is_key_already_binded:
				InputMap.action_erase_events(action_to_remap)
				InputMap.action_add_event(action_to_remap, event)
				_update_input_button(remapping_button, event)
			else:
				var input_label: Label = remapping_button.find_child("input_label")
				var events: = InputMap.action_get_events(action_to_remap)
				if events.size() > 0:
					print(events[0].as_text().trim_suffix(" (Physical)"))
					input_label.text = events[0].as_text().trim_suffix(" (Physical)")
				var type: String = "Erro de mapeamento"
				var msg: String = "Erro no mapeamento, a tecla '%s' já está mapeada para a 
					função '%s'"%[
						OS.get_keycode_string(event.physical_keycode), 
						action_translated_dict[is_key_already_binded]
					]
				SLogger.load_error_screen(type, msg)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()

# Checa se a ação já está linkada em alguma key e devolve:
# 	a ação caso já esteja linkada
# 	false caso não esteja linkada 
func check_bind(event: InputEvent) -> Variant:
	for action:String in saved_keybinding_settings.keys():
		if InputMap.action_has_event(action, event) and action_to_remap != action:
			return action
	return false

# atualiza o botão na tela e manda a nova tecla para salvar
func _update_input_button(button: Node, event: InputEvent) -> void:
	button.find_child("input_label").text = OS.get_keycode_string(event.physical_keycode)
	Config_Handler.save_keybinding_settings(action_to_remap, event)

# Reseta as keybindings
func _on_reset_button_pressed() -> void:
	saved_keybinding_settings = Config_Handler.load_all_keybinding_settings()
	verify_action_list(true)
