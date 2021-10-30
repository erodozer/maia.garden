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
