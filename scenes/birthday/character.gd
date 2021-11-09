extends Sprite

export var flag: String

func _ready():
	if not GameState.flag(flag):
		queue_free()
