extends Node

var id setget ,get_id
var value = 0 setget ,get_value

func _ready():
	add_to_group("Persist")

func get_id():
	return name.to_lower()

func get_title():
	return ""

func get_value():
	return value

func visible():
	return true

func get_weight():
	return 0

func persist(data):
	var s = data.get("stats", {})
	s[get_id()] = get_value()
	data["stats"] = s
	return data
	
func restore(data):
	value = 0
	if not ("stats" in data):
		return 
	if get_id() in data.stats:
		value = data.stats[get_id()]
