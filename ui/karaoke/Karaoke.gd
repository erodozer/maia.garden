extends Control

const godash = preload("res://addons/godash/godash.gd")
const Fortunes = preload("res://core/fortune.gd").Fortunes
const Note = preload("./Note.tscn")

onready var game = get_node("Game")
onready var difficulty_selector = get_node("Difficulty")
onready var difficulty_list = get_node("Difficulty/PanelContainer/ItemList")
onready var results = get_node("Results")
onready var camera = get_node("Game/LaneView/ViewportContainer/Viewport/Camera2D")
onready var combo_label = get_node("Game/LaneView/Combo")
onready var count_label = get_node("Game/ComboCounter/VBoxContainer/Count")
onready var song_progress = get_node("Game/ProgressBar")
onready var audio = get_node("AudioStreamPlayer")
onready var hit_sfx = get_node("Game/HitSfx")

onready var anim = get_node("AnimationPlayer")

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

const DIFFICULTY = [
	{
		"bpm": 80.0,
		"scale": 0.3,
		"freq": [1.0, 1.0 / 2.0],
		"song": preload("res://ui/karaoke/songs/Baka Mitai.ogg")
	},
	{
		"bpm": 100.0,
		"scale": 0.5,
		"freq": [1.0, 1.0 / 2.0],
		"song": preload("res://ui/karaoke/songs/LONELY_ROLLING_STAR.ogg")
	},
	{
		"bpm": 120.0,
		"scale": 0.6,
		"freq": [1.0, 1.0 / 2.0, 1.0 / 4.0],
		"song": preload("res://ui/karaoke/songs/Bad_Apple.ogg")
	},
	{
		"bpm": 150.0,
		"scale": 0.7,
		"freq": [1.0, 1.0 / 2.0, 1.0 / 4.0],
		"song": preload("res://ui/karaoke/songs/Rolling Girl.ogg")
	}
]
const MEASURE_SCALE = 48.0

func _ready():
	set_process(false)
	if demo:
		play()

func play():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	visible = true
	anim.play("difficulty")
	yield(anim, "animation_finished")
	difficulty_list.grab_focus()
	difficulty_list.select(0)
	var difficulty = yield(difficulty_list, "item_activated")
	if difficulty >= len(DIFFICULTY):
		visible = false
		emit_signal("end")
		return -1
	get_node("Difficulty/PanelContainer/Select").play()
	anim.play_backwards("difficulty")
	yield(anim, "animation_finished")
	difficulty_selector.visible = false
	Bgm.fadeout(1.0)
	
	note_count = 0
	var bpm = DIFFICULTY[difficulty].bpm
	scroll_speed = MEASURE_SCALE * (bpm / 60.0)
	var beat = 3.0
	
	audio.stream = DIFFICULTY[difficulty].song
	var song_length = DIFFICULTY[difficulty].song.get_length()
	
	# generate notes randomly
	note_count = 0
	var beats = song_length * bpm / 60.0
	beat += 3.0
	while beat < beats:
		var step = godash.rand_choice(DIFFICULTY[difficulty].freq, rand)
		beat += step
		
		var lane = godash.rand_choice([
			-1, 
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2, 3,
			0, 1, 2, 3,
		], rand)
		if lane < 0:
			continue
		
		var n = Note.instance()
		n.position.y = beat * MEASURE_SCALE
		n.set_meta("direction", lane)
		emit_signal("add_note", n)
		note_count += 1
		
	song_progress.max_value = song_length
	song_progress.value = 0
	count_label.text = "  %d/%d" % [notes_hit, note_count]
	
	notes_hit = 0
	combo = 0
	highest_combo = 0
	
	anim.play("karaoke")
	yield(anim, "animation_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("start")
	set_process(true)
	audio.play(0)
	yield(get_tree().create_timer(song_length + 3.0), "timeout")
	set_process(false)
	
	var payout = (notes_hit * DIFFICULTY[difficulty].scale) + highest_combo
	if GameState.fortune.current_fortune == Fortunes.GOOD_LUCK_STREAM_BONUS:
		payout *= 2
	
	results.get_node("PanelContainer/VBoxContainer/Accuracy/Value").text = "%2d%%" % ((float(notes_hit) / float(note_count) * 100))
	results.get_node("PanelContainer/VBoxContainer/Combo/Value").text = "%d" % highest_combo
	results.get_node("PanelContainer/VBoxContainer/Payout/Value").text = "%d" % payout
	anim.play("results")
	yield(anim, "animation_finished")
	
	visible = false
	emit_signal("end")
			
	Bgm.fadein(1.0)
	
	GameState.emit_signal("stat", "karaoke", {
		"difficulty": difficulty,
		"notes_hit": notes_hit,
		"note_count": note_count,
		"combo": highest_combo
	})
	
	return payout
	
func _process(delta):
	song_progress.value = audio.get_playback_position()
	camera.position.y += delta * scroll_speed

func _on_hit():
	combo += 1
	notes_hit += 1
	highest_combo = max(highest_combo, combo)
	count_label.text = "%d/%d" % [notes_hit, note_count]
	
	if combo > 5:
		combo_label.text = "%d Combo" % combo
	else:
		combo_label.text = ""
		
	hit_sfx.play()
		
func _on_miss():
	combo = 0
	combo_label.text = "MISS"


func _on_ItemList_item_selected(_index):
	get_node("Difficulty/PanelContainer/Cursor").play()
