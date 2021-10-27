extends KinematicBody2D

const MOVEMENT_SPEED = 1

export var sidescrolling_mode = false
export var fishing = false setget toggle_fishing

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var sprite_container = get_node("Sprite")
onready var walk_sprite = get_node("Sprite/Walking")
onready var stand_sprite = get_node("Sprite/Stand")
onready var fish_sprite = get_node("Sprite/Fishing")
onready var interact_collider = get_node("Interact")
onready var bubble = get_node("Bubble")

var interactable_npc

signal can_interact(npc)
signal interact_start
signal interact_end

func _ready():
	set_physics_process(true)
	if game_state:
		change_outfit(game_state.outfit)
		game_state.connect("change_outfit", self, "change_outfit")
	
func pause():
	set_physics_process(false)

func resume():
	set_physics_process(true)
	
func toggle_fishing(v):
	fishing = v
	if fish_sprite:
		fish_sprite.visible = v
		
func change_outfit(outfit):
	stand_sprite.frames = load("res://characters/maia/outfits/%s/standing.tres" % outfit)
	walk_sprite.frames = load("res://characters/maia/outfits/%s/walking.tres" % outfit)
	
func perform_action():
	if not interactable_npc:
		return
		
	emit_signal("interact_start")
	pause()
	if interactable_npc.has_method("interact"):
		var state = interactable_npc.interact()
		if state and state is GDScriptFunctionState:
			yield(state, "completed")
	resume()
	emit_signal("interact_end")

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		walk_sprite.visible = false
		stand_sprite.visible = true
		perform_action()
		return
	
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
	interactable_npc = body
	emit_signal("can_interact", interactable_npc)
	
func _on_Interact_body_exited(body):
	if body == interactable_npc:
		interactable_npc = null
		emit_signal("can_interact", interactable_npc)
