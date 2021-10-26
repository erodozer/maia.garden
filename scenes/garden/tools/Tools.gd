extends Control

const Flowers = preload("res://content/content.gd").FLOWERS

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var icon = get_node("ActiveSeed")
onready var count = get_node("ActiveSeed/Count")

var current_seed = 0 setget set_current_seed,get_current_seed

var planting_stamina_cost = 5
var watering_stamina_cost = 2

var seeds = []

func _ready():
	if not game_state:
		return
		
	if game_state.flag("request.proller_1.complete"):
		planting_stamina_cost = 3
		watering_stamina_cost = 1
	
	game_state.connect("inventory_changed", self, "update_count")
	
	for f in Flowers.values():
		if not ("unlock" in f) or game_state.flag(f.unlock):
			seeds.append(f)
	set_current_seed(current_seed)

func set_current_seed(idx):
	current_seed = seeds[idx]
	icon.texture = load("res://content/flower/%s/tool.tres" % [current_seed.id])
	if game_state:
		update_count("seed:%s" % current_seed.id, game_state.inventory["seed:%s" % current_seed.id])

func get_current_seed():
	if not game_state:
		return Flowers["clover"]
	return current_seed
			
func update_count(item, amount):
	if item == "seed:%s" % self.current_seed.id:
		count.text = "%d" % amount

func plant(cell):
	if not game_state:
		return null
	if game_state.stamina < planting_stamina_cost:
		return null
	var flower = self.current_seed
	var plant = game_state.plant(flower, cell)
	if plant:
		game_state.stamina -= planting_stamina_cost  # planting costs some stamina
	return plant
	
func harvest(plant):
	if not game_state:
		return
		
	# reaping costs no stamina
	game_state.inventory[plant.ref.id] += 1
	
func water(plant):
	if not game_state:
		return
		
	if game_state.stamina < watering_stamina_cost:
		return 
		
	game_state.stamina -= 1  # watering costs a little stamina
	plant.watered = true
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next") and game_state:
		self.current_seed = wrapi(seeds.find(current_seed) + 1, 0, len(seeds))
		return
		
	if Input.is_action_just_pressed("ui_focus_prev") and game_state:
		self.current_seed = wrapi(seeds.find(current_seed) - 1, 0, len(seeds))
		return
		
func _on_Maia_interact_start():
	set_process(false)

func _on_Maia_interact_end():
	set_process(true)
