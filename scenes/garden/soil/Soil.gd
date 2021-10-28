extends Node2D

const Plant = preload("./Plant.tscn")

onready var maia = get_tree().get_nodes_in_group("player").front()

onready var soil = get_node("TileMap")
onready var plants = get_node("Plants")
onready var highlight = get_node("Highlight")

var selected = null
var plots = []

func _ready():
	for c in soil.get_used_cells():
		var xy = soil.map_to_world(c)
		var p = Plant.instance()
		p.cell = c
		p.global_position = xy
		plants.add_child(p)
		if c in GameState.garden.plots:
			p.plant = GameState.garden.plots[c]
		plots.append(p)
		
	if maia:
		maia.connect("can_interact", self, "update_highlight")
			
func update_highlight(cell):
	if cell in plots:
		highlight.global_position = cell.global_position
		highlight.visible = true
	else:
		highlight.visible = false
