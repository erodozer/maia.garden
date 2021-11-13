extends Control

const godash = preload("res://addons/godash/godash.gd")

onready var joystick = get_node("Joystick")
onready var health = get_node("Health")
onready var timer = get_node("Timer")
onready var catch_anchor = get_node("Catch")
onready var catch_panel = get_node("Catch/PanelContainer")
onready var catch_dialog = get_node("Catch/PanelContainer/HBoxContainer/Label")
onready var catch_record = get_node("Catch/Label")
onready var rare_icon = get_node("Catch/PanelContainer/HBoxContainer/Rare")
onready var normal_icon = get_node("Catch/PanelContainer/HBoxContainer/Normal")
onready var tween = get_node("Tween")

onready var sfx_controller = get_node("SfxController")

const BASE_REEL_RATE = 20
var reel_rate = BASE_REEL_RATE

var rand = RandomNumberGenerator.new()

var direction = 0 setget set_direction

const direction_to_input = {
	0: "ui_up",
	1: "ui_down",
	2: "ui_right",
	3: "ui_left"
}

signal end(caught)
signal hook(success)

func _ready():
	set_process(false)
	set_process_input(false)
	
func open(type):
	rand.randomize()
	# can not fish if you do not have enough stamina
	var player = get_tree().get_nodes_in_group("player").front()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	
	if GameState.player.outfit == "hat":
		reel_rate = BASE_REEL_RATE * 2.5
	
	if GameState.inventory.is_full():
		yield(dialogue.open([
			"I can't hold any more fish",
		]), "completed")
		return
		
	visible = true
	player.fishing = true
	
	sfx_controller.play("waiting")
	
	var fish = GameState.fishing.get_fish(type)
	yield(get_tree().create_timer(rand.randf() * 3.0 + 2.0), "timeout")
		
	# handle empty fishing
	if not fish:
		player.fishing = false
		sfx_controller.stop()
		yield(dialogue.open([
			"No fish are biting",
			"Maybe some other time",
		]), "completed")
		return
	
	# first wait to hook the fish
	Input.start_joy_vibration(0, 0.3, 0.7)
	sfx_controller.play("fight")
	player.bubble.visible = true
	set_process_input(true)
	var wait = get_tree().create_timer(rand.randf() * 3.0 + 0.5)
	wait.connect("timeout", self, "emit_signal", ["hook", false])
	var hooked = yield(self, "hook")
	wait.disconnect("timeout", self, "emit_signal")
	set_process_input(false)
	Input.stop_joy_vibration(0)
	player.bubble.visible = false
	sfx_controller.stop()
	
	if not hooked:
		player.fishing = false
		yield(dialogue.open([
			"The fish got away",
		]), "completed")
		return
	# test if player has enough stamina to catch the fish
	if not GameState.player.can_perform_action(fish.stamina):
		player.fishing = false
		yield(dialogue.open([
			"The line broke!",
		]), "completed")
		return
		
	health.max_value = fish.ref.health
	health.value = health.max_value * 0.85
	pick_direction()
	joystick.visible = true
	health.visible = true
	Input.start_joy_vibration(0, 0.1, 0.4)
	set_process(true)
	var caught = yield(self, "end")
	set_process(false)
	Input.stop_joy_vibration(0)
	timer.stop()
	joystick.visible = false
	health.visible = false
	player.fishing = false
	sfx_controller.play("pull")
	
	if not caught:
		yield(dialogue.open([
			"The fish got away",
		]), "completed")
		GameState.player.perform_action(fish.stamina / 3)
	
		return
	
	var result = GameState.fishing.catch(fish)
	
	catch_record.visible = result.record
	catch_dialog.text = "%s\n%.02fin" % [fish.ref.name, fish.size]
	normal_icon.visible = not result.rare
	rare_icon.visible = result.rare
	yield(get_tree(), "idle_frame")
	tween.interpolate_property(catch_anchor, "rect_position:y", -50, 25, .3, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	var to = get_tree().create_timer(3.0)
	to.connect("timeout", self, "emit_signal", ["hook"])
	set_process_input(true)
	yield(self, "hook")
	set_process_input(false)
	to.disconnect("timeout", self, "emit_signal")
	tween.interpolate_property(catch_anchor, "rect_position:y", 25, -50, .3, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	sfx_controller.play("RESET")
	GameState.player.perform_action(fish.stamina)
	
func set_direction(v):
	for c in get_node("Joystick/Control").get_children():
		c.visible = false
	match v:
		0: # up
			get_node("Joystick/Control/Up").visible = true
		1: # down
			get_node("Joystick/Control/Down").visible = true
		2: # right
			get_node("Joystick/Control/Right").visible = true
		3: # left
			get_node("Joystick/Control/Left").visible = true
		_:
			return
	direction = v

func pick_direction():
	# use custom random so that fishing input is not predictable every time
	var r = direction
	while r == direction:
		r = rand.randi() % 4
	self.direction = r
	timer.start(lerp(1.0, 3.0, rand.randf()))

var reeling = false
func _process(delta):
	if health.value <= 0:
		emit_signal("end", true)
		return
	if health.value >= health.max_value:
		emit_signal("end", false)
		return
	
	var success = false
	if Input.is_action_pressed(direction_to_input[direction]):
		success = true
	
	for button in [0, 1, 2, 3]:
		var input = direction_to_input[button]
		if button != direction and Input.is_action_pressed(input):
			success = false
	
	if success and not reeling:
		reeling = true
		Input.start_joy_vibration(0, 0.5, 0.9)
		sfx_controller.play("reel")
	elif not success and reeling:
		reeling = false
		Input.start_joy_vibration(0, 0.1, 0.4)
		sfx_controller.play("RESET")
		
	if reeling:
		health.value -= reel_rate * delta
	else:
		health.value += (health.max_value / 10.0) * delta
	
func _on_Timer_timeout():
	pick_direction()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("hook", true)
		
