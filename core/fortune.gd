extends Node

const godash = preload("res://addons/godash/godash.gd")

enum Fortunes {
	NEUTRAL_LUCK,
	GOOD_LUCK_BIG_FISH,
	GOOD_LUCK_ENERGY,
	GOOD_LUCK_PLANT,
	GOOD_LUCK_STREAM_BONUS,
	BAD_LUCK_EXCLUSIVE_FISH,
	BAD_LUCK_TIRED,
	BAD_LUCK_LESS_FISH,
	BAD_LUCK_DEAD_PLANTS
}

const all_fortunes = [
	Fortunes.NEUTRAL_LUCK,
	Fortunes.GOOD_LUCK_BIG_FISH,
	Fortunes.GOOD_LUCK_ENERGY,
	Fortunes.GOOD_LUCK_PLANT,
	Fortunes.GOOD_LUCK_STREAM_BONUS,
	Fortunes.BAD_LUCK_EXCLUSIVE_FISH,
	Fortunes.BAD_LUCK_TIRED,
	Fortunes.BAD_LUCK_LESS_FISH,
	Fortunes.BAD_LUCK_DEAD_PLANTS,
]

const good_fortunes = [
	Fortunes.GOOD_LUCK_BIG_FISH,
	Fortunes.GOOD_LUCK_ENERGY,
	Fortunes.GOOD_LUCK_PLANT,
	Fortunes.GOOD_LUCK_STREAM_BONUS,
]

var next_fortune = null
var current_fortune = Fortunes.NEUTRAL_LUCK

signal changed(fortune)

func get_new_fortune():
	if next_fortune != null:
		return next_fortune
	
	if GameState.flag("request:shrine_2:completed"):
		next_fortune = godash.rand_choice(good_fortunes)
	else:
		next_fortune = godash.rand_choice(all_fortunes)
	GameState.emit_signal("stat", "fortune.told", {
		"fortune": next_fortune,
	})
	return next_fortune
	
func _on_calendar_advance(_day):
	current_fortune = next_fortune
	next_fortune = null
	emit_signal("changed", current_fortune)
	
func persist(data):
	data["fortune"] = {
		"current": current_fortune,
		"next": next_fortune
	}
	return data
	
func restore(data):
	current_fortune = data.get("fortune", {}).get("current", Fortunes.NEUTRAL_LUCK)
	next_fortune = data.get("fortune", {}).get("next", null)
