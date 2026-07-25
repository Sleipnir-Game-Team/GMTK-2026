@tool
extends BaseBehaviour

func act(screw: Area2D):
	var tool: BaseTool = get_parent()
	
	tool.process_mode = Node.PROCESS_MODE_DISABLED
	tool.visible = false
	await screw.screw()
	tool.process_mode = Node.PROCESS_MODE_INHERIT
	tool.visible = true
	tool.grab()
