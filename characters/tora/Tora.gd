extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

const TORA_GRADUATION = 1637366400

const FEES = {
	"Fish": [
		{
			"duration": 86400,
			"cost": 50,
			"label": "1 Day",
		},
		{
			"duration": 259200,
			"cost": 125,
			"label": "3 Days",
		},
		{
			"duration": 604800,
			"cost": 275,
			"label": "1 Week",
		},
	],
	"Garden": [
		{
			"duration": 86400,
			"cost": 30,
			"label": "1 Day",
		},
		{
			"duration": 259200,
			"cost": 75,
			"label": "3 Days",
		},
		{
			"duration": 604800,
			"cost": 150,
			"label": "1 Week",
		},
	],
}

onready var fishing = get_node("Fishing")

func _ready():
	if GameState.calendar.day < TORA_GRADUATION:
		queue_free()
	
	if GameState.automate.is_hired and not GameState.calendar.day == GameState.automate.start:
		fishing.visible = GameState.automate.task == "Fish"
		global_position = get_node(GameState.automate.task).global_position
	else:
		fishing.visible = false
		
	can_talk()

func can_talk():
	var say = false
	if not GameState.flag("talked_to.tora"):
		say = true
	if not GameState.automate.collected:
		say = true
		
	talk_indicator.visible = say
		
	return say

func hint():
	return "Talk to Tora"
	
func hire():
	var choices = []
	var choice = yield(dialogue.open([
		"Are you looking for help?",
	], ["Fish", "Garden", "No Thanks"]), "completed")
	
	var help = choice
	var durations = []
	if help == "Fish":
		choice = yield(dialogue.open([
			"Sure I can help you fish!",
		], FEES[help]), "completed")
	elif help == "Garden":
		choice = yield(dialogue.open([
			"Helping around the garden?",
			"Sounds like fun!",
			"For whatever you plant",
			"I'll water and harvest it for you",
		], FEES[help]), "completed")
	else:
		return
		
	var cost = choice.cost
	var accept = yield(dialogue.open([
		"Okay! That'll be %d konpeto" % cost,
	], ["Ok", "Nevermind"]), "completed")
	
	if accept != "Ok":
		yield(dialogue.open([
			"Maybe some other time",
		]), "completed")
		return
		
	if GameState.player.balance >= cost:
		yield(dialogue.open([
			"Thank you!",
			"I'll drop by soon~",
		]), "completed")
		GameState.automate.start_task(help, choice.duration)
		GameState.player.balance -= cost
	else:
		yield(dialogue.open([
			"Sorry Maia",
			"You don't have enough to pay",
		]), "completed")
	
func collect():
	var dt = OS.get_datetime_from_unix_time(GameState.automate.until)
	
	yield(dialogue.open([
		"I'll be around until %d/%d" % [dt.month, dt.day], 
	]), "completed")

func interact():
	if not GameState.flag("talked_to.tora"):
		var text = [
			"Hi Maia!",
			"Since I graduated",
			"I've been looking around",
			"for someplace new to settle",
			"The forest is really nice",
			"So I'll stick around here!",
			"If you ever need help",
			"I'll gladly work for a fee",
		]
		yield(dialogue.open(text), "completed")
		GameState.toggle_flag("talked_to.tora")
	
	if not GameState.automate.collected:
		var items = GameState.automate.collect()
		var text = [
			"Hello Maia",
		]
		if GameState.automate.task == "Fish":
			text.append(
				"Here's your fish!"
			)
		elif GameState.automate.task == "Garden":
			text.append(
				"Here are your flowers~"
			)
		if items.empty():
			var amount = GameState.automate.sell()
			text.append_array([
				"Oh, your bag looks a bit full",
				"How about I save you some time",
				"I'll sell these right now",
				"[Got %d konpeito]" % [amount]
			])
		else:
			for i in items:
				text.append(
					"Got %dx %s" % [i.amount, i.ref.name]
				)
		yield(dialogue.open(text), "completed")
	
	if GameState.automate.is_hired:
		yield(collect(), "completed")
	else:
		yield(hire(), "completed")
	can_talk()
