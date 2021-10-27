extends Node

var Content = preload("res://content/content.gd")

onready var game_state = get_tree().get_nodes_in_group("game_state").front()
onready var requests_ui = get_tree().get_nodes_in_group("requests").front()

var accepted setget ,is_accepted
var completed setget ,is_completed

func get_id():
	return null

func get_requirements():
	return []
	
func get_owner():
	return null
	
func key():
	return "request:%s" % get_id()
	
func prompt():
	return ""

func is_completed():
	var flag = "%s:completed" % key()
	return game_state.flag(flag)

func is_accepted():
	var flag = "%s:started" % key()
	return game_state.flag(flag)

func can_accept():
	return true
	
func accept():
	game_state.toggle_flag("%s:started" % key())
	
func complete():
	for requirement in get_requirements():
		var select = get_matching_items(requirement)
		
		var claim = requirement.amount
		for s in select:
			var record = game_state.inventory.get_item(s)
			if record and record.amount > 0:
				var amount = min(record.amount, claim)
				game_state.inventory.insert_item({
					"id": record.id,
					"ref": record.ref,
					"amount": -amount
				})
				claim -= amount
			if claim <= 0:
				break
		assert(claim == 0)
		
	game_state.toggle_flag("%s:completed" % key())

func show_requirements():
	var submitted = yield(requests_ui.open(self), "completed")
	
	if submitted:
		complete()
		
func get_matching_items(requirement):
	var select = []
	if "type" in requirement:
		for i in Content.ITEMS:
			if i.type != requirement.type:
				continue

			if requirement.type == "fish":
				if "location" in requirement and i.location != requirement.location:
					continue
				
				if "big" in requirement and requirement.big:
					select.append("%s:big" % i.id)
					continue
			
			select.append(i.id)
	elif "id" in requirement:
		select = [requirement.id]
	return select

func requirements_met():
	var has_items = true
	for requirement in get_requirements():
		var select = get_matching_items(requirement)
		
		var sum = 0
		for i in select:
			var item = game_state.inventory.get_item(i)
			if item:
				sum += item.amount
		if sum < requirement.amount:
			has_items = false
			break
	return has_items
