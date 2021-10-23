extends Node

const godash = preload("res://addons/godash/godash.gd")
const Content = preload("res://content/content.gd")

var day = 0
var konpeto = 100 setget update_balance
var inventory = {
}

var garden = {}

var outfit = "default" setget set_outfit
var unlocked_outfits = {
	"default": true,
	"hat": true,
	"tiny": true
}

var records = {}

# daily vars
var has_streamed = false
var stamina = 100

signal new_record(fish)
signal balance_changed(amount)
signal change_outfit(outfit)
signal inventory_changed(item, amount)

func _ready():
	for f in Content.FLOWERS.values():
		inventory[f.id] = 0
		inventory["seed:%s" % f.id] = f.starting
	
	for f in Content.FISHING:
		inventory[f.id] = 0
		inventory["%s:big" % f.id] = 0

func advance_day():
	day += 1
	for p in garden.values():
		# only mature watered flowers
		if p.watered:
			p.age += 1
		
		p.watered = false
	stamina = 100

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	konpeto = amount
	emit_signal("balance_changed", amount)
	
func catch_fish(fish):
	var size = fish.size
	var prev = 0
	var new_record = false
	if fish.ref.name in records:
		prev = records[fish.ref.name]
	if size > prev:
		records[fish.ref.name] = size
		new_record = true
		emit_signal("new_record", fish)
	
	var key = "%s:big" % fish.ref.id \
		if inverse_lerp(fish.ref.size[0], fish.ref.size[1], size) > .8 \
		else fish.ref.id
	inventory[key] += 1
	emit_signal("inventory_changed", key, inventory[key])
	return new_record

func plant(flower, cell):
	var key = "seed:%s" % flower.id
	if inventory[key] <= 0:
		return null
		
	if cell in garden:
		return null

	var plant = {
		"ref": flower,
		"age": 0,
		"watered": false,
		"cell": cell,
	}
	garden[cell] = plant
	inventory[key] -= 1
	emit_signal("inventory_changed", key, inventory[key])
	return plant
