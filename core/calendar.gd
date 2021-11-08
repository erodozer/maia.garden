extends Node

var day = 1634616000 # day as unix timestamp, so we can leverage OS Date features

const MAIAS_BIRTHDAY = 1637038800
const PROLLER_DAY = 1635048000
const CHIE_DAY = 1634616000

signal advance(day)

func is_maia_day():
	return day == MAIAS_BIRTHDAY

func reset():
	day = 1634616000
	emit_signal("advance", day)
	
func advance_day():
	day += 86400 # add a day in unix seconds

	# only introduce proller after a certain amount of time has passed
	# and you've been introduced to everyone else
	if day >= PROLLER_DAY and \
		GameState.flag("introduce.yuuki") and \
		GameState.flag("introduce.clover") and \
		GameState.flag("introduce.tazzle"):
		GameState.toggle_flag("introduce.proller")
		
	if day >= CHIE_DAY:
		GameState.toggle_flag("introduce.chie")
	
	if GameState.stats.stamina_used.value > 250:
		GameState.toggle_flag("introduce.yuuki")
		
	if GameState.stats.flowers_planted.value > 10:
		GameState.toggle_flag("introduce.clover")
	
	if GameState.stats.fish_caught.value > 5:
		GameState.toggle_flag("introduce.tazzle")
		
	if day >= MAIAS_BIRTHDAY:
		GameState.toggle_flag("maia_birthday")
	
	emit_signal("advance", day)
	
	GameState.save_game("auto")
	
func persist(data):
	data["calendar"] = {
		"date": day
	}
	
func restore(data):
	day = data["calendar"]["date"]
