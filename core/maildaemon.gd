extends Node

var inbox = {}
	
func deliver_mail(day):
	for m in Content.Mail:
		if m.id in inbox:
			continue
		
		var delivered = false
		if m.sendAt.is_valid_integer():
			delivered = day >= m.sendAt.to_int()
		else:
			delivered = GameState.flag(m.sendAt)

		if delivered:
			inbox[m.id] = {
				"id": m.id,
				"delivered": day,
				"unread": true,
				"ref": m
			}

func _on_calendar_advance(day):
	deliver_mail(day)
