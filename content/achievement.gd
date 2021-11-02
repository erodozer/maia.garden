extends Node

var completed setget ,is_completed

var id setget ,get_id

func get_id():
	return ""

func get_title():
	return ""
	
func get_description():
	return ""

func is_completed():
	return GameState.flag("achievement:%s:completed" % get_id())

func update_progress():
	var state = get_progress()
	if state.progress >= state.required:
		GameState.toggle_flag("achievement:%s:completed" % get_id())
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

func handle_stat(key, params):
	if is_completed():
		return
		
	var handled = _on_stat(key, params)
	if handled:
		update_progress()
