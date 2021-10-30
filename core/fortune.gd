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

var next_fortune = null
var current_fortune = Fortunes.NEUTRAL_LUCK

signal changed(fortune)

func get_new_fortune():
	if next_fortune != null:
		return next_fortune
	
	next_fortune = godash.rand_choice(Fortunes.values())
	return next_fortune
	
func _on_calendar_advance(_day):
	current_fortune = next_fortune
	next_fortune = null
	emit_signal("changed", current_fortune)
	
