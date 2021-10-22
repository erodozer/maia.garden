extends Control

const godash = preload("res://addons/godash/godash.gd")

const Note = preload("./Note.tscn")

const dirtex = [
	preload("res://ui/karaoke/left.png"),
	preload("res://ui/karaoke/up.png"),
	preload("res://ui/karaoke/down.png"),
	preload("res://ui/karaoke/right.png")
]

onready var lanes = [
	get_node("ViewportContainer/Viewport/Left"),
	get_node("ViewportContainer/Viewport/Up"),
	get_node("ViewportContainer/Viewport/Down"),
	get_node("ViewportContainer/Viewport/Right")
]

onready var camera = get_node("ViewportContainer/Viewport/Camera2D")
onready var combo_label = get_node("ViewportContainer/Viewport/CanvasLayer2/Combo")

var scroll_speed
var combo = 0
var highest_combo = 0
var note_count = 0
var notes_hit = 0
var score = 0

export var demo = false

func _ready():
	set_process(false)
	if demo:
		play()

func play():
	# generate notes randomly
	var song_length = lerp(30.0, 45.0, randf())
	
	var bpm = godash.rand_choice([120, 140, 160, 180, 200, 300])
	scroll_speed = 160.0 * (60.0 / bpm)
	var beats = (song_length / 60.0) * bpm
	var beat = 0
	note_count = 0
	notes_hit = 0
	combo = 0
	highest_combo = 0
	while beat < beats:
		var note = godash.rand_choice([1.0 / 2.0, 1.0 / 4.0, 1.0 / 8.0, 1.0 / 16.0])
		beat += note
		
		var lane = godash.rand_choice([-1, 0, 1, 2, 3])
		if lane < 0:
			continue
		
		var n = Note.instance()
		n.position.y = beat * 160 + (scroll_speed * 3.0)
		lanes[lane].add_child(n)
		n.get_node("Sprite").texture = dirtex[lane]
		note_count += 1
	
	visible = true
	set_process(true)
	yield(get_tree().create_timer(song_length), "timeout")
	set_process(false)
	yield(get_tree().create_timer(3.0), "timeout")
	visible = false
	
	for lane in lanes:
		for c in lane.get_children():
			c.queue_free()
			
	return notes_hit + highest_combo
	
func _process(delta):
	camera.position.y += scroll_speed * delta

func _on_hit():
	combo += 1
	notes_hit += 1
	highest_combo = max(highest_combo, combo)
	
	if combo > 5:
		combo_label.text = "%d Combo" % combo
	else:
		combo_label.text = ""
		
func _on_miss():
	combo = 0
	combo_label.text = "MISS"
