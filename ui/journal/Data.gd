extends ScrollContainer

const DataRecord = preload("res://ui/data_record/DataRecord.tscn")

onready var list = get_node("VBoxContainer")
onready var button_group = ButtonGroup.new()

func _ready():
	button_group.connect("pressed", self, "_on_item_activated")

func build():
	for s in ["00", "01", "02"]:
		var header = GameState.load_headers(s)
		var button = DataRecord.instance()
		list.add_child(button)
		button.group = button_group
		button.data = header
		
	var exit_button = Button.new()
	exit_button.text = "Exit to Title"
	exit_button.rect_min_size = Vector2(0, 26)
	exit_button.size_flags_horizontal = SIZE_EXPAND_FILL
	exit_button.size_flags_vertical = SIZE_FILL
	exit_button.connect("pressed", self, "_on_exit_game")
	list.add_child(exit_button)
	
func destroy():
	for f in list.get_children():
		f.group = null
		f.queue_free()
	
func _on_exit_game():
	get_tree().paused = true
	yield(Bgm.fadeout(0.3), "completed")
	SceneManager.change_scene("title")
	return

func _on_item_activated(button):
	var slot = button.data.slot
	GameState.save_game(slot)
	
	destroy()
	yield(get_tree(), "idle_frame")
	build()

func _on_Data_focus_entered():
	list.get_child(0).grab_focus()
	
