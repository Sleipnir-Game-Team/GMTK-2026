@tool
extends BaseBehaviour

## Trigger the plumbing minigame on the target pipe
func act(pipe: Area2D) -> void:
	var tool: BaseTool = get_parent()
	
	tool.process_mode = Node.PROCESS_MODE_DISABLED
	tool.visible = false
	await pipe.start_plumbing()
	tool.visible = true
	tool.process_mode = Node.PROCESS_MODE_INHERIT
