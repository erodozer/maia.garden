extends Node

var stock = []

func replenish_stock():
	pass

func persist(data):
	var shop_data = data.get("shops", {})
	
	var item_stock = {}
	
	for i in stock:
		item_stock[i.ref.id] = i.stock
	
	shop_data[name.to_lower()] = item_stock
	return data

func restore(data):
	var loaded = data.get("shops", {}).get(name.to_lower(), {})
	
	if len(loaded) == 0:
		replenish_stock()
		return
	
	stock = []
	for i in loaded:
		var item = Content.get_item_reference(i)
		stock.append({
			"ref": item,
			"price": item.price,
			"stock": loaded[i],
		})
	
