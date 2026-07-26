class_name Save extends Resource

# Variaveis salvas exportadas
# @export exemplo
@export var player_manual:Array[Dictionary]
@export var perfect_run:bool
@export var save_time:Dictionary

func save(_data: Dictionary) -> void:
	# Valores passados de data para as variaveis salvas
	# exemplo = data.exemplo
	player_manual = _data.pages
	perfect_run = _data.perfect_run
	save_time = _data.save_time

func load() -> Dictionary:
	# Retorno de um dicionario com as variaveis salvas
	# return {
	#     'exemplo' = exemplo
	# }
	
	return {
		'pages' = player_manual,
		'perfect_run' = perfect_run,
		'save_time' = save_time
	}
