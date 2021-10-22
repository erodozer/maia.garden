extends Control

const godash = preload("res://addons/godash/godash.gd")

const Note = preload("./Note.tscn")

onready var camera = get_node("HBoxContainer/Panel/ViewportContainer/Viewport/Camera2D")
onready var combo_label = get_node("HBoxContainer/Panel/Combo")
onready var count_label = get_node("HBoxContainer/VBoxContainer/Container/MarginContainer/VBoxContainer/Count")
onready var song_progress = get_node("ProgressBar")

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

func _ready():
	set_process(false)
	if demo:
		play()

func play():
	# generate notes randomly
	var weight = randf()
	
	var bpm = godash.rand_choice([120.0, 140.0, 160.0, 180.0, 200.0, 300.0])
	var song_length = lerp(30.0, 60.0, weight)
	scroll_speed = 30.0 * (bpm / 60.0)
	var beat = 0
	var beats = song_length * (bpm / 60.0)
	note_count = 0
	notes_hit = 0
	combo = 0
	highest_combo = 0
	var measure = 0.0
	while measure * 4.0 < beats:
		var note = godash.rand_choice([1.0 / 2.0, 1.0 / 4.0, 1.0 / 8.0])
		measure += note
		
		var lane = godash.rand_choice([-1, 0, 1, 2, 3])
		if lane < 0:
			continue
		
		var n = Note.instance()
		n.position.y = measure * scroll_speed
		n.set_meta("direction", lane)
		emit_signal("add_note", n)
		note_count += 1
		
	song_progress.max_value = song_length
	song_progress.value = 0
	count_label.text = "  %d/%d" % [notes_hit, note_count]
	
	visible = true
	emit_signal("start")
	set_process(true)
	yield(get_tree().create_timer(song_length), "timeout")
	set_process(false)
	yield(get_tree().create_timer(3.0), "timeout")
	visible = false
	emit_signal("end")
			
	return notes_hit + highest_combo
	
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
