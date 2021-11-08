extends Node

var stock = [] setget ,get_stock

func replenish_stock():
	pass
	
func get_stock():
	var select = []
	for s in stock:
		if s.ref.unlock and not GameState.flag(s.ref.unlock):
			continue
		
		if s.stock == 0:
			continue
		
		select.append(s)
	return select

func persist(data):
	var shop_data = data.get("shops", {})
	
	var item_stock = {}
	
	for i in stock:
		item_stock[i.ref.id] = i.stock
	
	shop_data[name.to_lower()] = item_stock
	data["shops"] = shop_data
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
	
