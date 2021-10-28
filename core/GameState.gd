extends Node

const godash = preload("res://addons/godash/godash.gd")

var konpeto = 100 setget update_balance

onready var inventory = get_node("Inventory")
onready var garden = get_node("Garden")
onready var mail = get_node("Mail")
onready var calendar = get_node("Calendar")
onready var fishing = get_node("Fishing")

var requests = []
var achievements = []
var stats = []

var outfit = "default" setget set_outfit

var flags = {
	"outfit.default": true,
	"outfit.hat": false,
	"outfit.tiny": false,
	# introductions
	"introduce.chie": true,
	"introduce.clover": true,
	"introduce.yuuki": true,
	"introduce.proller": true,
	"introduce.tazzle": true,
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

signal new_record(fish)
signal balance_changed(new_amount, old_amount)
signal stamina_changed(new_amount, old_amount)
signal change_outfit(outfit)
signal stat(id, params)

func _ready():
	for r in godash.load_dir("res://content/request", "request.gd", true).values():
		var request = r.new()
		get_node("Requests").add_child(request)
		requests.append(request)
		
	for a in godash.load_dir("res://content/achievements", "achievement.gd", true).values():
		var achievement = a.new()
		connect("stat", achievement, "handle_stat")
		get_node("Achievements").add_child(achievement)
		achievements.append(achievement)
	
	for a in godash.load_dir("res://content/stats", "stat.gd", true).values():
		var stat = a.new()
		connect("stat", stat, "_on_stat")
		get_node("Stats").add_child(stat)
		stats.append(stat)
	
	mail.deliver_mail(calendar.day)

func flag(f):
	return f in flags and flags[f]

func toggle_flag(f):
	flags[f] = true

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	var diff = amount - konpeto
	if diff > 0:
		total_konpeto_earned += diff
	var old = konpeto
	konpeto = amount
	emit_signal("balance_changed", amount, old)
	emit_signal("stat", "konpeto", {
		"new_value": amount,
		"old_value": old,
	})
	
func update_stamina(amount):
	var diff = amount - stamina
	if diff < 0:
		total_spent_stamina += abs(diff)
	var old = stamina
	stamina = clamp(amount, 0, 100)
	emit_signal("stamina_changed", stamina, old)
	emit_signal("stat", "stamina", {
		"new_value": stamina,
		"old_value": old,
	})

