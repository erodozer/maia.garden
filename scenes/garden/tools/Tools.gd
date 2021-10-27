extends Control

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var icon = get_node("ActiveSeed")
onready var count = get_node("ActiveSeed/Count")

var current_seed = null setget set_current_seed

var planting_stamina_cost = 5
var watering_stamina_cost = 2

var seeds = []

func _ready():
	if not game_state:
		return
		
	if game_state.flag("request.proller_1.complete"):
		planting_stamina_cost = 3
		watering_stamina_cost = 1
	
	game_state.inventory.connect("changed", self, "update_count")
	
	for f in game_state.inventory.data:
		if f.ref.type == "tool":
			seeds.append(f)
	set_current_seed(seeds[0])

func set_current_seed(item):
	if null:
		return
		
	current_seed = item
	icon.texture = current_seed.ref.icon
	
	update_count(current_seed.id, {
		"id": current_seed.id,
		"amount": current_seed.amount,
	})

func update_count(_id, item):
	count.text = "%d" % item.amount

func plant(cell):
	if not game_state:
		return null
		
	if game_state.stamina < planting_stamina_cost:
		return null
	
	var plant = game_state.plant(current_seed, cell)
	
	if plant:
		game_state.stamina -= planting_stamina_cost  # planting costs some stamina
	
	return plant
	
func harvest(plant):
	if not game_state:
		return
		
	# reaping costs no stamina
	game_state.inventory.insert_item({
		"id": plant.ref.id,
		"ref": plant.ref,
		"amount": 1,
	})
	
func water(plant):
	if not game_state:
		return
		
	if game_state.stamina < watering_stamina_cost:
		return 
		
	game_state.stamina -= 1  # watering costs a little stamina
	plant.watered = true
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next") and game_state:
		self.current_seed = seeds[wrapi(seeds.find(current_seed) + 1, 0, len(seeds))]
		return
		
	if Input.is_action_just_pressed("ui_focus_prev") and game_state:
		self.current_seed = seeds[wrapi(seeds.find(current_seed) - 1, 0, len(seeds))]
		return
		
func pause():
	set_process(false)

func resume():
	set_process(true)
