extends Control

const godash = preload("res://addons/godash/godash.gd")

const KEY_MAP = {
	"ui_up": "Up",
	"ui_down": "Down",
	"ui_left": "Left",
	"ui_right": "Right"
}

const MAX_ATTEMPTS = 3

var input_queue = []
var key = 0

onready var controls = get_node("Control")
onready var start_prompt = get_node("Prompt1")
onready var begin_prompt = get_node("Prompt2")
onready var attempt_counter = get_node("Tries")
onready var attempt_label = get_node("Tries/Label")

signal end(miss)

func _ready():
	set_process_input(false)

func _input(event):
	for i in KEY_MAP.keys():
		if event.is_action_pressed(i):
			controls.get_node(KEY_MAP[i]).visible = true
			set_process_input(false)
			yield(get_tree().create_timer(0.3), "timeout")
			controls.get_node(KEY_MAP[i]).visible = false
			if input_queue[key] != i:
				emit_signal("end", true)
			else:
				key += 1
				if key >= len(input_queue):
					emit_signal("end", false)
				else:
					set_process_input(true)
	
func start(difficulty):
	visible = true
	var attempts = 0
	
	yield(get_tree().create_timer(0.5), "timeout")
	start_prompt.visible = true
	yield(get_tree().create_timer(3.0), "timeout")
	start_prompt.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
		
	input_queue = []
	for _i in range(2):
		input_queue.append(godash.rand_choice(KEY_MAP.keys()))
		
	for _i in range(difficulty + 1):
		attempts = 0
		input_queue.append(godash.rand_choice(KEY_MAP.keys()))
		
		controls.visible = true
		yield(get_tree().create_timer(0.3), "timeout")
		for k in input_queue:
			# pick key
			for c in controls.get_children():
				c.visible = false
			controls.get_node(KEY_MAP[k]).visible = true
			yield(get_tree().create_timer(1.0), "timeout")
			get_node("Control").get_node(KEY_MAP[k]).visible = false
			yield(get_tree().create_timer(0.2), "timeout")
		controls.visible = false
	
		yield(get_tree().create_timer(0.3), "timeout")
		begin_prompt.visible = true
		yield(get_tree().create_timer(2.0), "timeout")
		begin_prompt.visible = false
		yield(get_tree().create_timer(0.3), "timeout")
		
		attempt_counter.visible = true
		controls.visible = true
		while attempts < MAX_ATTEMPTS:
			attempt_label.text = "Attempt %d/%d" % [attempts + 1, MAX_ATTEMPTS]
			key = 0
			set_process_input(true)
			var miss = yield(self, "end")
			set_process_input(false)
		
			if not miss:
				break
			
			controls.visible = false
			attempt_counter.visible = false
			attempts += 1
			if attempts < MAX_ATTEMPTS:
				yield(get_tree().create_timer(0.5), "timeout")
				attempt_counter.visible = true
				controls.visible = true
		
		controls.visible = false
		attempt_counter.visible = false
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		if attempts >= MAX_ATTEMPTS:
			break
		
	visible = false
	set_process_input(false)
	
	return attempts < MAX_ATTEMPTS
