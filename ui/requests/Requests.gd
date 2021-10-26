extends Control

const Content = preload("res://content/content.gd")
onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var tween = get_node("Tween")
onready var requirements = get_node("VBoxContainer/Panel/MarginContainer/Requirements")
onready var submit_button = get_node("VBoxContainer/Buttons/Submit")
onready var buttons = get_node("VBoxContainer/Buttons")

signal end(submit)

func _ready():
	set_process_input(false)

func get_matching_items(requirement):
	var select = []
	if "type" in requirement:
		if requirement.type == "fish":
			for f in Content.FISHING:
				if not requirement.category or (requirement.category and f.type == requirement.category):
					if not ("big" in requirement) or ("big" in requirement and not requirement.big):
						select.append(f.id)
					if not ("big" in requirement) or ("big" in requirement and requirement.big):
						select.append("%s:big" % f.id)
		elif requirement.type == "flower":
			for f in Content.FLOWERS:
				if not ("category" in requirement):
					select.append(f.id)
				elif requirement.category == "seed":
					select.append("seed:%s" % f.id)
	elif "id" in requirement:
		select = [requirement.id]
	return select

func open(list, title):
	# build the hint
	var text = "[center]%s[/center]\n" % title
	for i in list:
		text += "\n[b]%s[/b]" % i.hint
	requirements.bbcode_text = text
	requirements.visible = true
	requirements.rect_position.y = -999
	
	# test the requirements
	var has_items = true
	for requirement in list:
		var select = get_matching_items(requirement)
		
		var sum = 0
		for i in select:
			sum += game_state.inventory[i]
		if sum < requirement.amount:
			has_items = false
			break
			
	buttons.visible = has_items
	submit_button.pressed = has_items
	if has_items:
		submit_button.grab_focus()
		
	yield(get_tree(), "idle_frame")
	tween.interpolate_property(self, "rect_position:y", -150, 0, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	var submit = yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -150, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	requirements.visible = false
	
	if not submit:
		return false
		
	# remove items from inventory
	for requirement in list:
		var select = get_matching_items(requirement)
		
		var claim = requirement.amount
		for s in select:
			var held = game_state.inventory[s]
			if held > 0:
				game_state.inventory[s] = max(0, held - claim)
				claim -= held
			if claim <= 0:
				break
		assert(claim <= 0)
		
	return true
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("end", submit_button.pressed)

	if event.is_action_pressed("ui_cancel"):
		emit_signal("end", false)
