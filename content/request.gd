extends Node

var accepted setget ,is_accepted
var completed setget ,is_completed

var id setget ,get_id

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
			return "Tazzle wants to cook some fish over a campfire"
		"chie":
			return "Chie needs help to maintain the shrine"
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
	
func build_transaction():
	var transaction = []
	for requirement in get_requirements():
		var select = get_matching_items(requirement)
		var claim = requirement.amount
		for s in select:
			var record = GameState.inventory.get_item(s)
			if record.amount > 0:
				var amount = min(record.amount, claim)
				claim = claim - amount
				transaction.append({
					"id": record.id,
					"amount": -amount,
				})
				if claim == 0:
					break
		if claim > 0:
			return false
	return transaction

func complete():
	var transaction = build_transaction()
	assert(GameState.inventory.can_insert(transaction))
	GameState.inventory.insert_item(transaction)
	GameState.toggle_flag("%s:completed" % key())
	GameState.emit_signal("stat", "request.completed", {
		"request": self,
		"timestamp": OS.get_unix_time(),
	})

func show_requirements():
	var requests_ui = get_tree().get_nodes_in_group("requests").front()
	var submitted = yield(requests_ui.open(self), "completed")
	
	if submitted:
		var state = complete()
		if state and state is GDScriptFunctionState:
			yield(state, "completed")
		
func get_matching_items(requirement):
	var select = []
	if "type" in requirement:
		for i in Content.Items:
			if i.type != requirement.type:
				continue

			if requirement.type == "fish":
				if "location" in requirement and i.location != requirement.location:
					continue
				
				select.append("%s:rare" % i.id)
				
				# if explicitly requires rare, do not include the normal id
				if "rare" in requirement and requirement.rare:
					continue
			
			select.append(i.id)
	elif "id" in requirement:
		select = [requirement.id]
	return select

func requirements_met():
	var transaction = build_transaction()
	return transaction is Array
