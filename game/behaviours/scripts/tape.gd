@tool
extends BaseBehaviour


func act(crack: Area2D) -> void:
	var tool: BaseTool = get_parent()
	
	tool.process_mode = Node.PROCESS_MODE_DISABLED
	tool.visible = false
	await crack.start_taping()
	tool.process_mode = Node.PROCESS_MODE_INHERIT
	tool.visible = true
	tool.grab()
