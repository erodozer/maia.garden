extends KinematicBody2D

const MOVEMENT_SPEED = 1

onready var sprite_container = get_node("Sprite")
onready var walk_sprite = get_node("Sprite/Walking")
onready var stand_sprite = get_node("Sprite/Stand")
onready var highlight = get_node("Highlight")
onready var tween = get_node("Tween")
onready var bubble = get_node("Bubble")

var selected_cell
var interactable_npc

signal perform_action(cell)

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		walk_sprite.visible = false
		stand_sprite.visible = true
		if selected_cell:
			emit_signal("perform_action", selected_cell)
		elif interactable_npc:
			emit_signal("perform_action", interactable_npc)
		return
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
		sprite_container.scale = Vector2(1, 1)
	elif Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
		sprite_container.scale = Vector2(-1, 1)
		
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
		
	direction = direction.normalized()
		
	if direction != Vector2.ZERO:
		move_and_collide(direction * MOVEMENT_SPEED)
		walk_sprite.visible = true
		stand_sprite.visible = false
	else:
		walk_sprite.visible = false
		stand_sprite.visible = true
		return
		
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var selected = space_state.intersect_point(
		global_position + (direction * 8) + Vector2(0, 4),
		1, [],
		2
	)
	
	if len(selected) <= 0:
		selected_cell = null
		highlight.visible = false
		return
		
	# tilemap collision
	selected = selected[0]
	var tilemap = selected.collider as TileMap
	var cell = tilemap.map_to_world(Vector2(selected.metadata.x, selected.metadata.y))
	highlight.global_position = cell
	highlight.visible = true
	selected_cell = cell

func _on_Interact_body_entered(body):
	interactable_npc = body
	bubble.visible = true
	tween.interpolate_property(bubble, "position", Vector2(0, -10), Vector2(0, -12), .05)
	tween.start()

func _on_Interact_body_exited(body):
	if body == interactable_npc:
		interactable_npc = null
		tween.interpolate_property(bubble, "position", Vector2(0, -12), Vector2(0, -10), .05)
		tween.start()
		yield(tween, "tween_all_completed")
		bubble.visible = false
