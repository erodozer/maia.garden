extends Control

const DataRecord = preload("res://ui/data_record/DataRecord.tscn")

signal end
signal confirm(choice)

onready var scrollbox = get_node("PanelContainer/ScrollContainer")
onready var list = get_node("PanelContainer/ScrollContainer/VBoxContainer")
onready var button_group = ButtonGroup.new()
onready var confirmation = get_node("Confirm")
onready var cursor_sfx = get_node("Cursor")
onready var select_sfx = get_node("Select")
onready var tween = get_node("Tween")

func _ready():
	button_group.connect("pressed", self, "_on_item_activated")
	set_process_input(false)
	
func open():
	build()
	scrollbox.get_v_scrollbar().value = 0
	list.get_children().front().grab_focus()
	yield(get_tree(), "idle_frame")
	tween.interpolate_property(self, "rect_position:y", -150, 0, .3)
	tween.start()
	visible = true
	yield(tween, "tween_all_completed")
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -150, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	
	for i in list.get_children():
		i.group = null
		i.queue_free()
	
func build():
	for s in ["auto", "00", "01", "02"]:
		var header = GameState.load_headers(s)
		var button = DataRecord.instance()
		list.add_child(button)
		button.data = header
		button.group = button_group
		button.connect("focus_entered", self, "_on_button_focus")
		
	var clear_button = Button.new()
	clear_button.text = "Clear Save Data"
	clear_button.rect_min_size = Vector2(0, 26)
	clear_button.size_flags_horizontal = SIZE_EXPAND_FILL
	clear_button.size_flags_vertical = SIZE_FILL
	clear_button.connect("pressed", self, "_on_clear_save_data")
	clear_button.connect("focus_entered", self, "_on_button_focus")

	list.add_child(clear_button)
	
func _on_item_activated(button):
	if not button.data.updated_at:
		return
		
	select_sfx.play()
	var slot = button.data.slot
	emit_signal("end")
	GameState.load_game(slot)
	
func _on_clear_save_data():
	confirmation.visible = true
	get_node("Confirm/VBoxContainer/HBoxContainer/Cancel").grab_focus()
	var choice = yield(self, "confirm")
	confirmation.visible = false
	if choice:
		for slot in ["auto", "00", "01", "02"]:
			GameState.delete_game(slot)
		emit_signal("end")
	else:
		scrollbox.get_v_scrollbar().value = 0
		list.get_children().front().grab_focus()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if confirmation.visible:
			_on_cancel_delete()
		else:
			emit_signal("end")

func _on_confirm_delete():
	emit_signal("confirm", true)

func _on_cancel_delete():
	emit_signal("confirm", false)

func _on_button_focus():
	cursor_sfx.play()
