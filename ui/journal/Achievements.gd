extends ScrollContainer

const StatRecord = preload("./StatusRecord.tscn")
const AchievementRecord = preload("./AchievementRecord.tscn")

onready var record_list = get_node("VBoxContainer/Records")
onready var achievement_list = get_node("VBoxContainer/Achievements")

func sort_by_weight(a, b):
	return a.get_weight() < b.get_weight()

func build():
	var stats = GameState.stats.values()
	stats.sort_custom(self, "sort_by_weight")
	for i in stats:
		if not i.visible():
			continue
		var row = StatRecord.instance()
		record_list.add_child(row)
		row.get_node("Label").text = i.get_title()
		row.get_node("Count").text = "%s" % i.value()
			
	for i in GameState.achievements.values():
		var row = AchievementRecord.instance()
		achievement_list.add_child(row)
		row.get_node("VBoxContainer/Title").text = i.get_title()
		row.get_node("VBoxContainer/Description").text = i.get_description()
		var state = i.get_progress()
		if i.completed:
			row.get_node("Count").visible = false
			row.get_node("Complete").visible = true
		else:
			row.get_node("Count").visible = true
			row.get_node("Complete").visible = false
			row.get_node("Count").text = "%d/%d" % [state.progress, state.required]
		
func destroy():
	for i in record_list.get_children():
		i.queue_free()
	for i in achievement_list.get_children():
		i.queue_free()
