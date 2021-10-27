extends Node

const godash = preload("res://addons/godash/godash.gd")

const REQUESTS = [
	preload("res://content/request/catgrass.gd"),
	preload("res://content/request/vegetables.gd"),
	preload("res://content/request/proller_collection_1.gd"),
	preload("res://content/request/proller_collection_2.gd"),
]

const MAIAS_BIRTHDAY = 1637038800
const PROLLER_DAY = 1635048000

var day = 1634616000 # day as unix timestamp, so we can leverage OS Date features
var konpeto = 100 setget update_balance

class Inventory:
	signal changed(item, record)
	
	var data = []
	
	func insert_item(entry):
		var item = get_item(entry.id)
		var amount = entry.amount
		if item:
			amount += item.amount
		
		if amount < 0:
			return false
		
		if not item:
			item = entry
			data.append(entry)
		
		item.amount = amount
		emit_signal("changed", item.id, item)
		return true
	
	func get_item(id):
		for i in data:
			if i.id == id:
				return i
		return null

var inventory = Inventory.new()
var garden = {}
var fishing_records = {}
var inbox = {}
var requests = []

var outfit = "default" setget set_outfit

var flags = {
	"outfit.default": true,
	"outfit.hat": false,
	"outfit.tiny": false,
	# introductions
	"introduce.chie": true,
	"introduce.clover": true,
	"introduce.yuuki": true,
	"introduce.proller": false,
	"introduce.tazzle": false,
	"maia_birthday": false,
}

# daily vars
var has_streamed = false
var delivered_mail = false
var stamina = 100 setget update_stamina

var total_spent_stamina = 0
var total_konpeto_earned = 0
var total_fish_caught = 0
var total_flowers_planted = 0

onready var Content = get_tree().get_nodes_in_group("content").front()

signal new_record(fish)
signal balance_changed(amount)
signal stamina_changed(amount)
signal change_outfit(outfit)

func _ready():
	for f in Content.Items:
		if f.type == "tool" and f.starting > 0:
			inventory.insert_item({
				"id": f.id,
				"ref": f,
				"amount": f.starting
			})
		if f.type == "fish":
			fishing_records[f.id] = {
				"id": f.id,
				"size": 0,
			}
	
	for r in REQUESTS:
		var request = r.new()
		add_child(request)
		requests.append(request)
	
	deliver_mail()

func flag(f):
	return f in flags and flags[f]

func toggle_flag(f):
	flags[f] = true

func deliver_mail():
	for m in Content.MAIL:
		if m.id in inbox:
			continue
		
		var delivered = false
		match typeof(m.sendAt):
			TYPE_INT:
				delivered = day >= m.sendAt
			TYPE_STRING:
				delivered = flag(m.sendAt)
			_:
				continue
		if delivered:
			inbox[m.id] = {
				"id": m.id,
				"delivered": day,
				"unread": true,
				"ref": m
			}

func advance_day():
	day += 86400 # add a day in unix seconds
	for p in garden.values():
		# only mature watered flowers
		if p.watered:
			p.age += 1
		
		p.watered = false
	stamina = 100
	
	if total_spent_stamina > 250:
		toggle_flag("introduce.yuuki")
		
	if total_flowers_planted > 5:
		toggle_flag("introduce.clover")
	
	if total_fish_caught > 8:
		toggle_flag("introduce.tazzle")
		
	if day >= PROLLER_DAY:
		toggle_flag("introduce.proller")
		
	if day >= MAIAS_BIRTHDAY:
		toggle_flag("maia_birthday")
	
	# deliver mail
	deliver_mail()

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	var diff = amount - konpeto
	if diff > 0:
		total_konpeto_earned += diff
	konpeto = amount
	emit_signal("balance_changed", amount)
	
func update_stamina(amount):
	var diff = amount - stamina
	if diff < 0:
		total_spent_stamina += abs(diff)
	stamina = amount
	emit_signal("stamina_changed", amount)
		
func catch_fish(fish):
	var size = fish.size
	var prev = fishing_records[fish.ref.id].size
	var new_record = false
	
	if size > prev:
		fishing_records[fish.ref.id].size = size
		new_record = true
		emit_signal("new_record", fish)
	
	var key = "%s:big" % fish.ref.id \
		if inverse_lerp(fish.ref.min_size, fish.ref.max_size, size) > .8 \
		else fish.ref.id
		
	inventory.insert_item({
		"id": key,
		"ref": fish.ref,
		"amount": 1
	})
	
	total_fish_caught += 1
	return new_record

func plant(seed_tool, cell):
	# do not allow planting where there is already a plant
	if cell in garden:
		return null

	var flower = seed_tool.ref.flower
	if not flower:
		return null

	var planted = inventory.insert_item({
		"id": seed_tool.id,
		"amount": -1
	})
	
	if not planted:
		return null
	
	var plant = {
		"ref": flower,
		"age": 0,
		"watered": false,
		"cell": cell,
	}
	garden[cell] = plant
	total_flowers_planted += 1
	
	return plant
