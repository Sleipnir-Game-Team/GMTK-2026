extends Node

var current_slot := 0
var blank_save := {}

var game_scene := "res://game/main.tscn"

func new_game(slot: int) -> void:
	GameManager.pause()
	
	UI_Controller.changeScreen(game_scene, get_tree().root)
	await get_tree().process_frame
	
	current_slot = slot
	
	load_game(blank_save)

func load_slot() -> void:
	GameManager.pause()
	UI_Controller.changeScreen(game_scene, get_tree().root)
	await get_tree().process_frame
	var file_path := "user://save_"+str(current_slot)+".res"
	if ResourceLoader.exists(file_path):
		load_game(ResourceLoader.load(file_path).load())
	else:
		load_game(blank_save)


func save_game() -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	if jogo == null:
		SLogger.error("Tentativa de salvar o jogo sem o jogo estar rodando")
	else:
		var data :Dictionary = jogo.save()
		var save_res := Save.new()
		save_res.save(data)
		ResourceSaver.save(save_res, "user://save_"+str(current_slot)+".res")
		SLogger.info("Jogo salvo no slot "+str(current_slot))

func load_game(data: Dictionary) -> void:
	var jogo := get_tree().get_first_node_in_group("Jogo")
	jogo.setup(data)
	SLogger.info("Jogo carregado no slot "+str(current_slot))
	GameManager.resume()

func check_save(slot: int) -> Dictionary:
	var file_path := "user://save_"+str(slot)+".res"
	if ResourceLoader.exists(file_path):
		return ResourceLoader.load(file_path).load()
	else:
		return {}

func delete_save(slot: int) -> void:
	var file_path := "user://save_"+str(slot)+".res"
	if ResourceLoader.exists(file_path):
		DirAccess.remove_absolute(file_path)
		SLogger.info("Save deletado no slot "+str(slot))
	else:
		SLogger.error("Tentando deletar um save inexistente")
