extends Node

const godash = preload("res://addons/godash/godash.gd")

onready var inventory = get_node("Inventory")
onready var garden = get_node("Garden")
onready var mail = get_node("Mail")
onready var calendar = get_node("Calendar")
onready var fishing = get_node("Fishing")
onready var fortune = get_node("Fortune")
onready var player = get_node("Player")

var requests = []
var achievements = {}
var stats = {}

# these are flags that persist
# once these are toggled they should never go back except on new/load data
var flags = {}

signal stat(id, params)

func _ready():
	reset_game()
	
	for r in godash.load_dir("res://content/request", ["gd", "gdc"], true).values():
		var request = r.new()
		request.name = request.id
		get_node("Requests").add_child(request)
		requests.append(request)
		
	for a in godash.load_dir("res://content/achievements", ["gd", "gdc"], true).values():
		var achievement = a.new()
		connect("stat", achievement, "handle_stat")
		achievement.name = achievement.id
		get_node("Achievements").add_child(achievement)
		achievements[achievement.id] = achievement
	
	for s in godash.load_dir("res://content/stats", ["gd", "gdc"], true).values():
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
	
func persist(data):
	data["flags"] = flags
	return data
	
func restore(data):
	flags = data["flags"]
	
func reset():
	flags = {
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
		# debug
		"unlock_bread": false
	}
	
func load_headers(slot):
	var path = "user://garden.%s.save" % slot
	var f = File.new()
	if not f.file_exists(path):
		return null
		
	f.open(path, File.READ)
	var data = parse_json(f.get_line())
	
	return {
		"updatedAt": data.updatedAt,
	}

func reset_game():
	for v in get_tree().get_nodes_in_group("Persist"):
		if v.has_method("reset"):
			v.reset()

func save_game(slot):
	var data = {
		"updatedAt": OS.get_unix_time(),
	}
	
	for v in get_tree().get_nodes_in_group("Persist"):
		if v.has_method("persist"):
			v.persist(data)
		
	var save_game = File.new()
	save_game.open("user://garden.%s.save" % slot, File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	
func load_game(slot):
	var path = "user://garden.%s.save" % slot
	var f = File.new()
	if not f.file_exists(path):
		return
	f.open(path, File.READ)
	var data = parse_json(f.get_line())
	
	SceneManager.change_scene("loading", [data])
	
func delete_game():
	var dir = Directory.new()
	for d in godash.enumerate_dir("user://", "save"):
		dir.remove(d)
