extends Node2D

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
	
	if plant.age == 0:
		sprite.texture = preload("res://scenes/garden/soil/seed.tres")
	elif plant.age >= plant.ref.mature:
		sprite.texture = load("res://content/flowers/%d/mature.tres")
	else:
		sprite.texture = load("res://content/flowers/%d/young.tres")
	
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
