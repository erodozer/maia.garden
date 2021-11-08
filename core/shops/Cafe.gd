extends "res://core/Shop.gd"

func replenish_stock():
	stock = []
	
	for i in Content.Items:
		if i.type != "cafe":
			continue
			
		stock.append({
			"ref": i,
			"price": i.price,
			"stock": i.daily_stock,
		})
