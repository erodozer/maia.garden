extends Control

const DataRecord = preload("res://ui/journal/DataRecord.tscn")

signal end
signal confirm(choice)

onready var list = get_node("PanelContainer/ScrollContainer/VBoxContainer")
onready var button_group = ButtonGroup.new()
onready var confirmation = get_node("Confirm")

func _ready():
	button_group.connect("pressed", self, "_on_item_activated")
	set_process_input(false)
	build()
	
func open():
	visible = true
	list.get_child(0).grab_focus()
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	visible = false
	
func build():
	var button_group = ButtonGroup.new()
	button_group.connect("pressed", self, "_on_item_activated")
	
	for i in list.get_children():
		i.group = null
		i.queue_free()
	
	for s in ["auto", "00", "01", "02"]:
		var header = GameState.load_headers(s)
		var button = DataRecord.instance()
		list.add_child(button)
		button.data = header
		button.group = button_group
		
	var clear_button = Button.new()
	clear_button.text = "Clear Save Data"
	clear_button.rect_min_size = Vector2(0, 26)
	clear_button.size_flags_horizontal = SIZE_EXPAND_FILL
	clear_button.size_flags_vertical = SIZE_FILL
	clear_button.connect("pressed", self, "_on_clear_save_data")
	list.add_child(clear_button)
	
func _on_item_activated(button):
	if not button.data.updated_at:
		return
		
	var slot = button.data.slot
	emit_signal("end")
	GameState.load_game(slot)
	
func _on_clear_save_data():
	confirmation.visible = true
	get_node("Confirm/VBoxContainer/HBoxContainer/Cancel").grab_focus()
	var choice = yield(self, "confirm")
	if choice:
		GameState.delete_game()
		build()
	confirmation.visible = false
	list.get_child(0).grab_focus()
	
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
