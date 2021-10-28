extends Node

var day = 1634616000 # day as unix timestamp, so we can leverage OS Date features

# private vars
var total_spent_stamina = 0
var total_flowers_planted = 0
var total_fish_caught = 0

const MAIAS_BIRTHDAY = 1637038800
const PROLLER_DAY = 1635048000

signal advance(day)

func _on_stat(id, params):
	if id == "stamina":
		if params.new_value < params.old_value:
			total_spent_stamina += params.old_value - params.new_value
	if id == "garden.plant":
		total_flowers_planted += 1
	if id == "fish.caught":
		total_fish_caught += 1

func advance_day():
	day += 86400 # add a day in unix seconds

	GameState.stamina = 100
	GameState.has_streamed = false
	
	if total_spent_stamina > 250:
		GameState.toggle_flag("introduce.yuuki")
		
	if total_flowers_planted > 5:
		GameState.toggle_flag("introduce.clover")
	
	if total_fish_caught > 8:
		GameState.toggle_flag("introduce.tazzle")
		
	if day >= PROLLER_DAY:
		GameState.toggle_flag("introduce.proller")
		
	if day >= MAIAS_BIRTHDAY:
		GameState.toggle_flag("maia_birthday")
	
	emit_signal("advance", day)
	
