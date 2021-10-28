extends Control

const godash = preload("res://addons/godash/godash.gd")

const KEY_MAP = {
	"ui_up": "Up",
	"ui_down": "Down",
	"ui_left": "Left",
	"ui_right": "Right"
}


var input_queue = []
var key = 0
var attempts = 3

signal end(miss)

func _ready():
	set_process_input(false)

func _input(event):
	
	for i in KEY_MAP.keys():
		if event.is_action_pressed(i):
			if input_queue[key] != i:
				emit_signal("end", true)
			else:
				key += 1
				if key >= len(input_queue):
					emit_signal("end", false)
	
func start(difficulty):
	visible = true
	attempts = 3
	
	for i in range(difficulty):
		input_queue = []
		for _n in range(i + 3):
			# pick key
			var k = godash.rand_choice(KEY_MAP.keys())
			for c in get_node("Control").get_children():
				c.visible = false
			get_node("Control").get_node(KEY_MAP[k]).visible = true
			input_queue.append(k)
			yield(get_tree().create_timer(0.5), "timeout")
			get_node("Control").get_node(KEY_MAP[k]).visible = false
			yield(get_tree().create_timer(0.2), "timeout")
		
		while attempts > 0:
			key = 0
			set_process_input(true)
			var miss = yield(self, "end")
			set_process_input(false)
		
			if not miss:
				break
				
		if attempts <= 0:
			break
		
	visible = false
	
	return attempts > 0
