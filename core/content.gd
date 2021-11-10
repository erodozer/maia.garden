extends Node

const godash = preload("res://addons/godash/godash.gd")

var Items = []
var Mail = []

func _ready():
	for item in godash.load_dir("res://content", "item.tres", true).values():
		Items.append(item)
	for mail in godash.load_dir("res://content", "mail.tres", true).values():
		Mail.append(mail)
	
	add_to_group("content")

func get_item_reference(id: String):
	if id.ends_with(":rare"): # handle fish type
		id = id.left(id.find(":rare"))
	for i in Items:
		if i.id == id:
			return i
	return null

func get_mail_reference(id):
	for i in Mail:
		if i.id == id:
			return i
	return null
