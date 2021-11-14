extends Node

var inbox = {}
	
func deliver_mail(day):
	# queue flags for exeuction after iteration
	# this prevents sending multiple mail for quests when introducing characters
	var delivered_flags = []
	
	for m in Content.Mail:
		if m.id in inbox:
			if m.onDelivery:  # add just in case, to help with migrating save data
				delivered_flags.append(m.onDelivery)
			continue
		
		var delivered = false
		if m.sendAt.is_valid_integer():
			var date = m.sendAt.to_int()
			delivered = day >= date and date >= 0
		elif m.sendAt.begins_with("quest:"):
			var quest_name = m.sendAt.substr(len("quest:"))
			var request = null
			for q in GameState.requests:
				if q.id == quest_name:
					request = q
					break
			if not request:
				continue
					
			delivered = request.can_accept() and not request.completed and not request.accepted
		else:
			delivered = GameState.flag(m.sendAt)

		if delivered:
			inbox[m.id] = {
				"id": m.id,
				"delivered": day,
				"unread": true,
				"ref": m
			}
			if m.onDelivery:
				delivered_flags.append(m.onDelivery)
	
	for f in delivered_flags:
		GameState.toggle_flag(f)

func _on_calendar_advance(day):
	deliver_mail(day)

func persist(data):
	data["mail"] = []
	for m in inbox.values():
		data.mail.append({
			"id": m.id,
			"delivered": m.delivered,
			"unread": m.unread
		})
	
func restore(data):
	inbox = {}

	for m in data.mail:
		inbox[m.id] = {
			"id": m.id,
			"delivered": m.delivered,
			"unread": m.unread,
			"ref": Content.get_mail_reference(m.id)
		}
