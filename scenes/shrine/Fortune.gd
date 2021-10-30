extends Control

const Fortunes = preload("res://core/fortune.gd").Fortunes

signal end

onready var title = get_node("Panel/VBoxContainer/Luck")
onready var desc = get_node("Panel/VBoxContainer/Description")

func open(fortune):
	match fortune:
		Fortunes.NEUTRAL_LUCK:
			title.text = "Neutral Luck"
			desc.text = "Nothing Good will come unto you\nNothing Bad will come unto you\nA normal day with normal bliss, something many wish they could enjoy"
		Fortunes.GOOD_LUCK_STREAM_BONUS:
			title.text = "Good Luck"
			desc.text = "Your future looks to take shape of a whale.\nPerhaps an exceptional day to stream"
		Fortunes.GOOD_LUCK_PLANT:
			title.text = "Good Luck"
			desc.text = "The spirits are in your favor\nYour garden may appear lusher than ever"
		Fortunes.GOOD_LUCK_ENERGY:
			title.text = "Good Luck"
			desc.text = "A surge of energy will overtake your body\nA wonderful time to be productive"
		Fortunes.GOOD_LUCK_BIG_FISH:
			title.text = "Good Luck"
			desc.text = "The dice are in your favor\nBig winnings are likely to happen where chance is required"
		Fortunes.BAD_LUCK_DEAD_PLANTS:
			title.text = "Bad Luck"
			desc.text = "Visions of your future look dry like a desert\nMisfortune may befall your garden"
		Fortunes.BAD_LUCK_EXCLUSIVE_FISH:
			title.text = "Bad Luck"
			desc.text = "The waters mock you in your attempts to find what you're looking for"
		Fortunes.BAD_LUCK_LESS_FISH:
			title.text = "Bad Luck"
			desc.text = "The waters of tomorrow look clear, but devoid of life\nAvoid fishing lest you wish to waste your time"
		Fortunes.BAD_LUCK_TIRED:
			title.text = "Bad Luck"
			desc.text = "A bleak tomorrow awaits you, tiredness and frustration taking hold on your body\nIt will be harder to do anything"
			
	visible = true
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	visible = false
	
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		emit_signal("end")
