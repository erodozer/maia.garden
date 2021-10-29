extends KinematicBody2D

const MOVEMENT_SPEED = 1

export var sidescrolling_mode = false
export var fishing = false setget toggle_fishing

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
	change_outfit(GameState.outfit)
	GameState.connect("change_outfit", self, "change_outfit")
	
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
		
func change_outfit(outfit):
	stand_sprite.frames = load("res://characters/maia/outfits/%s/standing.tres" % outfit)
	walk_sprite.frames = load("res://characters/maia/outfits/%s/walking.tres" % outfit)
	
func perform_action():
	var npc = interactable_npc.front()
	if not npc:
		return
		
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

func open_journal():
	emit_signal("interact_start")
	pause()
	yield(journal.open(), "completed")
	resume()
	emit_signal("interact_end")

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		perform_action()
	
	if Input.is_action_pressed("ui_select"):
		open_journal()
		
func _physics_process(_delta):
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
		move_and_collide(direction * MOVEMENT_SPEED)
		walk_sprite.visible = true
		stand_sprite.visible = false
		interact_collider.rotation = direction.angle()
	else:
		walk_sprite.visible = false
		stand_sprite.visible = true
		return

func _on_Interact_body_entered(body):
	interactable_npc.push_front(body)
	emit_signal("can_interact", interactable_npc[0])
	
func _on_Interact_body_exited(body):
	var idx = interactable_npc.find(body)
	if idx != -1:
		interactable_npc.remove(idx)
		var f = interactable_npc.front()
		emit_signal("can_interact", f)
