extends Sprite

onready var tween = get_node("Tween")

func _on_Maia_can_interact(npc):
	tween.stop_all()
	if not visible and npc:
		visible = true
		tween.interpolate_property(self, "position", Vector2(0, -10), Vector2(0, -12), .05)
		tween.start()
	elif not npc:
		tween.interpolate_property(self, "position", Vector2(0, -12), Vector2(0, -10), .05)
		tween.start()
		yield(tween, "tween_all_completed")
		visible = false
