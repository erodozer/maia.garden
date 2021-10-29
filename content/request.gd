extends Node

var accepted setget ,is_accepted
var completed setget ,is_completed

func get_id():
	return filename.get_basename().to_lower()

func get_requirements():
	return []
	
func get_owner():
	return null
	
func key():
	return "request:%s" % get_id()
	
func prompt():
	match get_owner():
		"clover":
			return "Clover is in need of supplies for the Flower Shop"
		"yuuki":
			return "Yuuki is in need of supplies for the Catfe"
		"proller":
			return "Proller wants to add the following to his collection"
		"tazzle":
			return "Tazzle wants to cook up some fish"
	return ""

func is_completed():
	var flag = "%s:completed" % key()
	return GameState.flag(flag)

func is_accepted():
	var flag = "%s:started" % key()
	return GameState.flag(flag)

func can_accept():
	return true
	
func accept():
	GameState.toggle_flag("%s:started" % key())
	
func complete():
	for requirement in get_requirements():
		var select = get_matching_items(requirement)
		
		var claim = requirement.amount
		for s in select:
			var record = GameState.inventory.get_item(s)
			if record and record.amount > 0:
				var amount = min(record.amount, claim)
				GameState.inventory.insert_item({
					"id": record.id,
					"ref": record.ref,
					"amount": -amount
				})
				claim -= amount
			if claim <= 0:
				break
		assert(claim == 0)
		
	GameState.toggle_flag("%s:completed" % key())
	GameState.emit_signal("state", "request.completed", {
		"request": self,
		"timestamp": OS.get_unix_time(),
	})

func show_requirements():
	var requests_ui = get_tree().get_nodes_in_group("requests").front()
	var submitted = yield(requests_ui.open(self), "completed")
	
	if submitted:
		complete()
		
func get_matching_items(requirement):
	var select = []
	if "type" in requirement:
		for i in Content.Items:
			if i.type != requirement.type:
				continue

			if requirement.type == "fish":
				if "location" in requirement and i.location != requirement.location:
					continue
				
				if "rare" in requirement and requirement.big:
					select.append("%s:rare" % i.id)
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
			var item = GameState.inventory.get_item(i)
			if item:
				sum += item.amount
		if sum < requirement.amount:
			has_items = false
			break
	return has_items
