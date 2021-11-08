extends ToolButton

var data setget set_data_reference

func set_data_reference(d):
	data = d
	if not d:
		return
		
	get_node("HBoxContainer/VBoxContainer/HBoxContainer/Slot").text = "Slot: %s" % [d.slot]
		
	if not d.updated_at:
		return
		
	var game_time = OS.get_datetime_from_unix_time(d.game_time)
	get_node("HBoxContainer/VBoxContainer/HBoxContainer/GameTime").text = "Game Time: %d/%d" % [game_time.month, game_time.day]
	get_node("HBoxContainer/VBoxContainer/TimePlayed").text = "Time Played: %d:%02d:%02d" % [
		int(d.time_played / 360),
		int(d.time_played / 60) % 60,
		int(d.time_played) % 60
	]
	get_node("HBoxContainer/TextureRect").texture = load("res://characters/maia/outfits/%s/icon.tres" % d.outfit)
	
