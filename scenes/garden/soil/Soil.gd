extends Node2D

const Plant = preload("./Plant.tscn")

onready var game_state = get_tree().get_nodes_in_group("game_state").front()
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
		if c in game_state.garden:
			p.plant = game_state.garden[c]
		plots.append(p)
		
		if maia:
			maia.connect("can_interact", self, "update_highlight")
		p.connect("area_entered", self, "cell_entered", [p])
		p.connect("area_exited", self, "cell_exited", [p])

func update_highlight(cell):
	if cell in plots:
		highlight.global_position = cell.global_position
		highlight.visible = true
	else:
		highlight.visible = false
