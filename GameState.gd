extends Node

const godash = preload("res://addons/godash/godash.gd")

const FISHING = [
	{
		"type": "pond",
		"name": "Goldfish",
		"sell": 3,
		"size": [4.7, 16.1],
		"rarity": 0.7,
		"health": 70,
	},
	{
		"type": "pond",
		"name": "Guppy",
		"sell": 3,
		"size": [0.6, 2.4],
		"rarity": .7,
		"health": 90
	},
	{
		"type": "pond",
		"name": "Koi",
		"sell": 40,
		"size": [20, 24],
		"rarity": .2,
		"health": 200
	}
]

const FLOWERS = [
	{
		"name": "Clover",
		"cost": 5,
		"sell": 10,
		"grow": 2
	},
	{
		"name": "Tulip",
		"cost": 15,
		"sell": 50,
		"grow": 6
	}
]

var day = 0
var konpeto = 100 setget update_balance
var inventory = []
var seeds = {
	"Clover": 5
}
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

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	konpeto = amount
	emit_signal("balance_changed", amount)

func get_fish(type):
	var selection = []
	for f in FISHING:
		if f.type == type:
			selection.append(f)
	if len(selection) <= 0:
		return null
	
	# TODO change to weighted selection based on fish rarity
	var fish = godash.rand_choice(selection)
	return fish
	
func catch_fish(fish):
	var size = fish.size
	var prev = 0
	var new_record = false
	if fish.name in records:
		prev = records[fish.name]
	if size > prev:
		records[fish.name] = size
		new_record = true
		emit_signal("new_record", fish)
	
	inventory.append(fish)
	return new_record

func buy_seeds(flower):
	var amount = 0
	if flower.name in seeds:
		amount = seeds[flower.name] 
	seeds[flower.name] = amount + 1
	konpeto -= flower.cost
	emit_signal("balance_changed", konpeto)
