extends "res://core/Shop.gd"

func replenish_stock():
	stock = []
	
	for i in Content.Items:
		if i.type != "tool":
			continue

		# only sell seeds
		if i.effect.type != "flower":
			continue

		stock.append({
			"ref": i,
			"price": i.price,
			"stock": -1,
		})
