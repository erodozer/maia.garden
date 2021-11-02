extends Node

var inbox = {}
	
func deliver_mail(day):
	for m in Content.Mail:
		if m.id in inbox:
			continue
		
		var delivered = false
		if m.sendAt.is_valid_integer():
			var date = m.sendAt.to_int()
			delivered = day >= date and date >= 0
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
				GameState.toggle_flag(m.onDelivery)

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
		data.mail.append({
			"id": m.id,
			"delivered": m.delivered,
			"unread": m.unread,
			"ref": Content.get_mail_reference(m.id)
		})
