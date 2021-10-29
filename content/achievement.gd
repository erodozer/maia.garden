extends Node

var completed = false

var id setget ,get_id

func get_id():
	return filename.get_basename().to_lower()

func get_title():
	return ""
	
func get_description():
	return ""

func update_progress():
	var state = get_progress()
	if state.progress >= state.required:
		completed = true
		# no need to listen to stats anymore
		GameState.disconnect("stat", self, "handle_stat")
		GameState.toggle_flag("achievement:%d:completed" % get_id())
		GameState.emit_signal("stat", "achievement.complete", {
			"achievement": self,
			"timestamp": OS.get_unix_time(),
		})
			
func get_progress():
	return {
		"progress": 0,
		"required": 0,
	}

func _on_stat(_id, _params):
	pass

func handle_stat(id, params):
	var handled = _on_stat(id, params)
	if handled:
		update_progress()
