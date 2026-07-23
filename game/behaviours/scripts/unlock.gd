extends BaseBehaviour

@export var passkey: String = ""

func unlock(door: Variant, password: Variant) -> bool:
	return not password or passkey == password
