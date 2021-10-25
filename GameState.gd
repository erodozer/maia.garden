extends Node

const godash = preload("res://addons/godash/godash.gd")
const Content = preload("res://content/content.gd")

const MAIAS_BIRTHDAY = 1637038800
const PROLLER_DAY = 1635048000

var day = 1634616000 # day as unix timestamp, so we can leverage OS Date features
var konpeto = 100 setget update_balance

var inventory = {}
var garden = {}
var fishing_records = {}
var inbox = {}

var outfit = "default" setget set_outfit

var flags = {
	"outfit.default": true,
	"outfit.hat": false,
	"outfit.tiny": false,
	# introductions
	"introduce.chie": true,
	"introduce.clover": false,
	"introduce.yuuki": false,
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

signal new_record(fish)
signal balance_changed(amount)
signal stamina_changed(amount)
signal change_outfit(outfit)
signal inventory_changed(item, amount)

func _ready():
	for f in Content.FLOWERS.values():
		inventory[f.id] = 0
		inventory["seed:%s" % f.id] = f.starting
	
	for f in Content.FISHING:
		inventory[f.id] = 0
		inventory["%s:big" % f.id] = 0
		fishing_records[f.id] = {
			"id": f.id,
			"size": 0
		}
		
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
	var diff = amount - konpeto
	if diff < 0:
		total_spent_stamina += abs(diff)
	stamina = amount
	emit_signal("stamina_changed", amount)
	
func catch_fish(fish):
	var size = fish.size
	var prev = 0
	var new_record = false
	if fish.ref.name in fishing_records:
		prev = fishing_records[fish.ref.name]
	if size > prev:
		fishing_records[fish.ref.name] = size
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
