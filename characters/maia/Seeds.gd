extends Control

const TEX = {
	"clover": preload("res://ui/seeds/clover.png"),
	"daisy": preload("res://ui/seeds/daisy.png"),
	"tulip": preload("res://ui/seeds/tulip.png"),
}

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var icon = get_node("ActiveSeed")
onready var count = get_node("ActiveSeed/Count")

var current_seed = 0 setget set_current_seed,get_current_seed

func set_current_seed(idx):
	current_seed = idx
	var active = self.current_seed
	icon.texture = TEX[active]
	if game_state:
		update_count(active, game_state.seeds[active])

func get_current_seed():
	if not game_state:
		return "clover"
	return game_state.seeds.keys()[current_seed]
	
func _ready():
	set_current_seed(current_seed)

	if game_state:
		game_state.connect("seed_balance_changed", self, "update_count")
		
func update_count(plant, amount):
	count.text = "%d" % amount

func plant(cell):
	if not game_state:
		return null
	return game_state.plant(self.current_seed, cell)
	
func harvest(plant):
	if game_state:
		game_state.inventory.append({
			"ref": plant.ref
		})

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next") and game_state:
		self.current_seed = wrapi(current_seed + 1, 0, len(game_state.seeds))
		return
		
	if Input.is_action_just_pressed("ui_focus_prev") and game_state:
		self.current_seed = wrapi(current_seed - 1, 0, len(game_state.seeds))
		return
		
func _on_Maia_interact_start():
	set_process(false)

func _on_Maia_interact_end():
	set_process(true)
