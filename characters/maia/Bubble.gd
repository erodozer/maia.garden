extends Sprite

onready var tween = get_node("Tween")

func _on_Maia_can_interact(npc):
	tween.stop_all()
	tween.remove_all()
	if not visible and npc:
		visible = true
		tween.interpolate_property(self, "position", Vector2(0, -10), Vector2(0, -14), .05)
		tween.start()
	elif not npc:
		tween.interpolate_property(self, "position", Vector2(0, -14), Vector2(0, -10), .05)
		tween.start()
		yield(tween, "tween_all_completed")
		visible = false

func _on_Maia_interact_start():
	visible = false

func _on_Maia_interact_end():
	visible = true
