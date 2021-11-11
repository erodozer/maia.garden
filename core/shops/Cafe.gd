extends "res://core/Shop.gd"

func replenish_stock(_day = null):
	stock = []
	
	for i in Content.Items:
		if i.type != "cafe":
			continue
			
		stock.append({
			"id": i.id,
			"icon": i.icon,
			"ref": i,
			"price": i.price,
			"stock": i.daily_stock,
		})
