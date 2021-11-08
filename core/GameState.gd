extends Node

const godash = preload("res://addons/godash/godash.gd")

onready var inventory = get_node("Inventory")
onready var garden = get_node("Garden")
onready var mail = get_node("Mail")
onready var calendar = get_node("Calendar")
onready var fishing = get_node("Fishing")
onready var fortune = get_node("Fortune")
onready var player = get_node("Player")
var shops = {}

var requests = []
var achievements = {}
var stats = {}

# these are flags that persist
# once these are toggled they should never go back except on new/load data
var flags = {}

# temporary world state data that gets cleared each day
var temp = {}
var time_played = 0

var world_seed = 0

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
		achievement.add_to_group("Persist")
		achievements[achievement.id] = achievement
	
	for s in godash.load_dir("res://content/stats", ["gd", "gdc"], true).values():
		var stat = s.new()
		connect("stat", stat, "_on_stat")
		stat.name = stat.id
		get_node("Stats").add_child(stat)
		stats[stat.id] = stat
	
	for s in get_node("Shops").get_children():
		shops[s.name.to_lower()] = s
	
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
	
func load_headers(slot):
	var path = "user://garden.%s.save" % slot
	var f = File.new()
	if not f.file_exists(path):
		return {
			"slot": slot,
			"updated_at": null,
		}
		
	f.open(path, File.READ)
	var data = parse_json(f.get_line())
	f.close()
	
	return {
		"slot": slot,
		"updated_at": data.updatedAt,
		"game_time": data.get("calendar", {}).get("date", 1634616000),
		"time_played": data.get("timePlayed", 0),
		"outfit": data.get("player", {}).get("outfit", "default"),
	}

func reset_game():
	time_played = 0
	temp = {}
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
	
	randomize() # new world seed every time the game starts
	world_seed = randi()
	seed(world_seed)
	
	for v in get_tree().get_nodes_in_group("Persist"):
		if v.has_method("reset"):
			v.reset()

func save_game(slot):
	var data = {
		"seed": world_seed,
		"updatedAt": OS.get_unix_time(),
		"timePlayed": time_played,
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
	world_seed = data.get("seed", randi())
	seed(world_seed)
	time_played = data.get("timePlayed", 0)
	
	SceneManager.change_scene("loading", [data])
	
func delete_game():
	var dir = Directory.new()
	for d in godash.enumerate_dir("user://", "save"):
		dir.remove(d)

func _on_Calendar_advance(_day):
	temp = {}

func _process(delta):
	time_played += delta
	
