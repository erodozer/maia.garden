extends Node2D

const PLANT_TEXTURE = {
	"Clover": {
		"seed": preload("res://scenes/garden/soil/seed.tres"),
		"young": preload("res://scenes/garden/soil/young_clover.tres"),
		"mature": preload("res://scenes/garden/soil/mature_clover.tres"),
	},
	"Daisy": {
		"seed": preload("res://scenes/garden/soil/seed.tres"),
		"young": preload("res://scenes/garden/soil/young_daisy.tres"),
		"mature": preload("res://scenes/garden/soil/mature_daisy.tres"),
	},
	"Tulip": {
		"seed": preload("res://scenes/garden/soil/seed.tres"),
		"young": preload("res://scenes/garden/soil/young_tulip.tres"),
		"mature": preload("res://scenes/garden/soil/mature_tulip.tres"),
	},
}

onready var seed_tool = get_tree().get_nodes_in_group("seed_tool").front()

onready var sprite = get_node("Sprite")
onready var water_sprite = get_node("Watered")

var plant = null setget set_plant
var cell = 0

func _ready():
	if not plant:
		return
	set_plant(plant)
	
func set_plant(p):
	plant = p
	
	if not p:
		water_sprite.visible = false
		sprite.visible = false
		return
	
	var tex = PLANT_TEXTURE[plant.ref.name]
	if plant.age == 0:
		sprite.texture = tex.seed
	elif plant.age >= plant.ref.mature:
		sprite.texture = tex.mature
	else:
		sprite.texture = tex.young
	
	sprite.visible = true	
	water_sprite.visible = plant.watered

func hint():
	if not plant:
		return "Plant Seed"
	
	if plant.age >= plant.ref.mature:
		return "Pick (%s)" % [plant.ref.name]
	
	return "Water (%s)" % [plant.ref.name]

func interact():
	if not plant:
		var result = seed_tool.plant(cell)
		if result:
			self.plant = result
		return
		
	if plant.age >= plant.ref.mature:
		seed_tool.harvest(plant)
		self.plant = null
		return
	if not plant.watered:
		plant.watered = true
		set_plant(plant)
