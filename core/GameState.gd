extends Node

const godash = preload("res://addons/godash/godash.gd")
const Fortunes = preload("res://core/fortune.gd").Fortunes

var konpeto = 100 setget update_balance

onready var inventory = get_node("Inventory")
onready var garden = get_node("Garden")
onready var mail = get_node("Mail")
onready var calendar = get_node("Calendar")
onready var fishing = get_node("Fishing")
onready var fortune = get_node("Fortune")

var requests = []
var achievements = {}
var stats = {}

var outfit = "default" setget set_outfit

# these are flags that persist
# once these are toggled they should never go back except on new/load data
var flags = {
	"outfit.default": true,
	"outfit.hat": false,
	"outfit.tiny": false,
	# introductions
	"introduce.chie": false,
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

signal new_record(fish)
signal balance_changed(new_amount, old_amount)
signal stamina_changed(new_amount, old_amount)
signal change_outfit(outfit)
signal stat(id, params)

func _ready():
	for r in godash.load_dir("res://content/request", "request.gd", true).values():
		var request = r.new()
		request.name = request.id
		get_node("Requests").add_child(request)
		requests.append(request)
		
	for a in godash.load_dir("res://content/achievements", "achievement.gd", true).values():
		var achievement = a.new()
		connect("stat", achievement, "handle_stat")
		achievement.name = achievement.id
		get_node("Achievements").add_child(achievement)
		achievements[achievement.id] = achievement
	
	for s in godash.load_dir("res://content/stats", "stat.gd", true).values():
		var stat = s.new()
		connect("stat", stat, "_on_stat")
		stat.name = stat.id
		get_node("Stats").add_child(stat)
		stats[stat.id] = stat
	
	mail.deliver_mail(calendar.day)

func flag(f):
	return f in flags and flags[f]

func toggle_flag(f):
	flags[f] = true
	emit_signal("stat", "flag", {
		"id": f
	})

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	var old = konpeto
	konpeto = amount
	emit_signal("balance_changed", amount, old)
	emit_signal("stat", "konpeto", {
		"new_value": amount,
		"old_value": old,
	})
	
func update_stamina(amount):
	var old = stamina
	stamina = clamp(amount, 0, 100)
	emit_signal("stamina_changed", stamina, old)
	emit_signal("stat", "stamina", {
		"new_value": stamina,
		"old_value": old,
	})
	
func can_perform_action(cost):
	if cost > 0 and fortune.current_fortune == Fortunes.BAD_LUCK_TIRED:
		cost *= 2
		
	return stamina >= cost
	
func perform_action(cost):
	if cost > 0 and fortune.current_fortune == Fortunes.BAD_LUCK_TIRED:
		cost *= 2
		
	if stamina >= cost:
		self.stamina -= cost
		return true
	return false
