extends StaticBody2D

export var flag: String

func _ready():
	if GameState.flag(flag):
		queue_free()
