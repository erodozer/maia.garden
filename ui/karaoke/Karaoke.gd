extends Control

const godash = preload("res://addons/godash/godash.gd")

const Note = preload("./Note.tscn")

onready var game = get_node("Game")
onready var difficulty_selector = get_node("Difficulty")
onready var difficulty_list = get_node("Difficulty/PanelContainer/ItemList")
onready var results = get_node("Results")
onready var camera = get_node("Game/HBoxContainer/Panel/ViewportContainer/Viewport/Camera2D")
onready var combo_label = get_node("Game/HBoxContainer/Panel/Combo")
onready var count_label = get_node("Game/HBoxContainer/VBoxContainer/Container/VBoxContainer/Count")
onready var song_progress = get_node("Game/ProgressBar")

var scroll_speed
var combo = 0
var highest_combo = 0
var note_count = 0
var notes_hit = 0
var score = 0

export var demo = false
signal add_note(note)
signal start
signal end
signal update_note_count

const DIFFICULTY = [
	{
		"bpm": 120.0,
		"notes": 50,
		"scale": 1.0,
		"freq": [1.0, 1.0 / 2.0],
	},
	{
		"bpm": 120.0,
		"notes": 100,
		"scale": 1.0,
		"freq": [1.0, 1.0 / 2.0, 1.0 / 4.0],
	},
	{
		"bpm": 150.0,
		"notes": 150,
		"scale": 1.5,
		"freq": [1.0, 1.0 / 2.0, 1.0 / 4.0],
	}
]
const MEASURE_SCALE = 48.0

func _ready():
	set_process(false)
	if demo:
		play()

func play():
	visible = true
	difficulty_selector.visible = true
	difficulty_list.grab_focus()
	difficulty_list.select(0)
	var difficulty = yield(difficulty_list, "item_activated")
	difficulty_selector.visible = false
	
	note_count = DIFFICULTY[difficulty].notes
	var bpm = DIFFICULTY[difficulty].bpm
	scroll_speed = MEASURE_SCALE * (bpm / 60.0)
	var note = 0
	notes_hit = 0
	combo = 0
	highest_combo = 0
	var beat = 3.0
	
	# generate notes randomly
	while note < note_count:
		var step = godash.rand_choice(DIFFICULTY[difficulty].freq)
		beat += step
		
		var lane = godash.rand_choice([-1, 0, 1, 2, 3])
		if lane < 0:
			continue
		
		var n = Note.instance()
		n.position.y = beat * MEASURE_SCALE
		n.set_meta("direction", lane)
		emit_signal("add_note", n)
		note += 1
	
	beat += 3.0
		
	var song_length = (beat / bpm) * 60
	song_progress.max_value = song_length
	song_progress.value = 0
	count_label.text = "  %d/%d" % [notes_hit, note_count]
	game.visible = true
	emit_signal("start")
	set_process(true)
	yield(get_tree().create_timer(song_length), "timeout")
	set_process(false)
	game.visible = false
	
	var payout = (notes_hit * DIFFICULTY[difficulty].scale) + highest_combo
	
	results.visible = true
	results.get_node("PanelContainer/VBoxContainer/Accuracy/Value").text = "%2d%%" % (notes_hit / note_count)
	results.get_node("PanelContainer/VBoxContainer/Combo/Value").text = "%d" % highest_combo
	results.get_node("PanelContainer/VBoxContainer/Payout/Value").text = "%d" % payout
	yield(get_tree().create_timer(7.0), "timeout")
	results.visible = false
	
	visible = false
	emit_signal("end")
			
	return payout
	
func _process(delta):
	song_progress.value += delta
	camera.position.y += scroll_speed * delta

func _on_hit():
	combo += 1
	notes_hit += 1
	highest_combo = max(highest_combo, combo)
	count_label.text = "  %d/%d" % [notes_hit, note_count]
	
	if combo > 5:
		combo_label.text = "%d Combo" % combo
	else:
		combo_label.text = ""
		
func _on_miss():
	combo = 0
	combo_label.text = "MISS"
