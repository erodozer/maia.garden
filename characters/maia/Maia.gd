extends KinematicBody2D

const MOVEMENT_SPEED = 64

export var sidescrolling_mode = false
export var fishing = false setget toggle_fishing
export var half_height = false setget slice

onready var sprite_container = get_node("Sprite")
onready var walk_sprite = get_node("Sprite/Walking")
onready var stand_sprite = get_node("Sprite/Stand")
onready var fish_sprite = get_node("Sprite/Fishing")
onready var interact_collider = get_node("Interact")
onready var bubble = get_node("Bubble")
onready var journal = get_node("CanvasLayer/Journal")

var interactable_npc = []

signal can_interact(npc)
signal interact_start
signal interact_end

func _ready():
	set_physics_process(true)
	change_outfit(GameState.player.outfit)
	slice(half_height)
	GameState.player.connect("change_outfit", self, "change_outfit")
	
func pause():
	set_physics_process(false)
	set_process_input(false)

func resume():
	set_physics_process(true)
	set_process_input(true)
	
func toggle_fishing(v):
	fishing = v
	if fish_sprite:
		fish_sprite.visible = v
		
func slice(v):
	half_height = v
	if sprite_container:
		sprite_container.material.set_shader_param("half_height", v)
		
func change_outfit(outfit):
	stand_sprite.frames = load("res://characters/maia/outfits/%s/standing.tres" % outfit)
	walk_sprite.frames = load("res://characters/maia/outfits/%s/walking.tres" % outfit)
	
func perform_action():
	if interactable_npc.empty():
		return
		
	var npc = interactable_npc.front()
		
	walk_sprite.visible = false
	stand_sprite.visible = true
	emit_signal("interact_start")
	pause()
	if npc.has_method("interact"):
		var state = npc.interact()
		if state and state is GDScriptFunctionState:
			yield(state, "completed")
	resume()
	emit_signal("interact_end")
	reevaluate()

func open_journal():
	emit_signal("interact_start")
	pause()
	yield(journal.open(), "completed")
	resume()
	emit_signal("interact_end")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		perform_action()
	
	if event.is_action_pressed("ui_select"):
		open_journal()
		
func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
		sprite_container.scale = Vector2(1, 1)
	elif Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
		sprite_container.scale = Vector2(-1, 1)
		
	if not sidescrolling_mode:
		if Input.is_action_pressed("ui_up"):
			direction += Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			direction += Vector2.DOWN
		
	direction = direction.normalized()
		
	if direction != Vector2.ZERO:
		move_and_collide(direction * MOVEMENT_SPEED * delta)
		walk_sprite.visible = true
		stand_sprite.visible = false
		interact_collider.rotation = direction.angle()
	else:
		walk_sprite.visible = false
		stand_sprite.visible = true
		return

func reevaluate():
	if interactable_npc.empty():
		return
		
	while not interactable_npc.empty():
		var npc = interactable_npc.front()
		if npc.has_method("can_interact"):
			if not npc.can_interact():
				interactable_npc.pop_front()
				continue
		emit_signal("can_interact", npc)
		return
		
	emit_signal("can_interact", null)

func _on_Interact_body_entered(body):
	if body.has_method("can_interact"):
		if not body.can_interact():
			return
	
	interactable_npc.push_front(body)
	emit_signal("can_interact", interactable_npc.front())
	
func _on_Interact_body_exited(body):
	var idx = interactable_npc.find(body)
	if idx != -1:
		interactable_npc.remove(idx)
	if interactable_npc.empty():
		emit_signal("can_interact", null)
	else:
		var f = interactable_npc.front()
		emit_signal("can_interact", f)

var overlay = []
func _on_overlay_body_entered(b):
	overlay.append(b)
	self.half_height = true

func _on_overlay_body_exited(body):
	var idx = overlay.find(body)
	if idx != -1:
		overlay.remove(idx)
	if overlay.empty():
		self.half_height = false
