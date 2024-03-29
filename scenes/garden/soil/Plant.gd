extends StaticBody2D

onready var seed_tool = get_tree().get_nodes_in_group("seed_tool").front()
onready var particles = get_node("Explosion")
onready var water_particles = get_node("Watering")
onready var sprite = get_node("Anchor/Sprite")
onready var water_sprite = get_node("Watered")

onready var seed_sfx = get_node("SeedSfx")
onready var harvest_sfx = get_node("HarvestSfx")
onready var water_sfx = get_node("WaterSfx")

var plant = null setget set_plant
var cell = 0

var planting_stamina_cost = 5
var watering_stamina_cost = 2

func _ready():
	if GameState.flag("garden_efficiency"):
		planting_stamina_cost = 3
		watering_stamina_cost = 1
		
	if not plant:
		return
	set_plant(plant)
	
func sow(c):
	if not GameState.player.can_perform_action(planting_stamina_cost):
		return null
	
	var p = GameState.garden.plant(seed_tool.current_tool, c)
	
	if p:
		GameState.player.perform_action(planting_stamina_cost)  # planting costs some stamina
	
	if p and GameState.automate.task == "Garden" and GameState.automate.is_hired:
		p.watered = true
	
	return p
	
func harvest(p):
	# reaping costs no stamina
	if GameState.garden.harvest(p):
		particles.emitting = true
		set_plant(null)
		harvest_sfx.play()
	
func water(p):
	var watered = GameState.player.perform_action(watering_stamina_cost)
	if watered:
		p.watered = true
		set_plant(p)
		water_sfx.play()
		water_particles.emitting = true 
		
func set_plant(p):
	plant = p
	
	if not plant:
		water_sprite.visible = false
		sprite.visible = false
		collision_layer = 4
		return
	
	collision_layer = 4
	if plant.age == 0:
		sprite.texture = preload("res://scenes/garden/soil/seed.tres")
	elif plant.age >= plant.ref.mature:
		sprite.texture = plant.ref.mature_sprite
		collision_layer = 12 if plant.ref.half_height else 4
	else:
		sprite.texture = plant.ref.young_sprite
	
	sprite.visible = true
	water_sprite.visible = plant.watered

func hint():
	if not plant:
		if not seed_tool.current_tool:
			return null
		if not seed_tool.current_tool.ref.effect:
			return null
		if seed_tool.current_tool.ref.effect.type != "flower":
			return null
		
		return "Plant (%s)" % seed_tool.current_tool.ref.effect.name
	
	if plant.age >= plant.ref.mature:
		return "Pick (%s)" % [plant.ref.name]
	
	return "Water (%s)" % [plant.ref.name]
	
func can_interact():
	if not plant:
		if not GameState.player.can_perform_action(planting_stamina_cost):
			return false
		if not seed_tool.current_tool:
			return false
		if not seed_tool.current_tool.ref.effect:
			return false
		if seed_tool.current_tool.ref.effect.type != "flower":
			return false
		if seed_tool.current_tool.amount <= 0:
			return false
		
		return true
	
	if plant.age >= plant.ref.mature:
		return true
	
	if not GameState.player.can_perform_action(watering_stamina_cost):
		return false
		
	return not plant.watered

func interact():
	if not plant:
		var result = sow(cell)
		if result:
			self.plant = result
			seed_sfx.play()
		return
		
	if plant.age >= plant.ref.mature:
		harvest(plant)
		return
	if not plant.watered:
		water(plant)
