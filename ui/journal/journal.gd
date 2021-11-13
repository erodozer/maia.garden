extends Control

onready var views = get_node("Window/View")
onready var tab_group = get_node("Window/Tabs/Inventory").group
onready var tween = get_node("Tween")

var active_view

signal opened
signal closed
signal end

func _ready():
	var tabs = preload("res://ui/journal/TabGroup.tres")
	tabs.connect("pressed", self, "_on_tab_toggled")
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		get_tree().set_input_as_handled()
		var button = tab_group.get_pressed_button()
		var next = button.focus_next
		button.get_node(next).pressed = true
	if event.is_action_pressed("ui_focus_prev"):
		get_tree().set_input_as_handled()
		var button = tab_group.get_pressed_button()
		var prev = button.focus_previous
		button.get_node(prev).pressed = true
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		emit_signal("end")
		
	if event.is_action_pressed("ui_down"):
		if not active_view.follow_focus:
			get_tree().set_input_as_handled()
			(active_view as ScrollContainer).scroll_vertical += event.get_action_strength("ui_down") * 16
	if event.is_action_pressed("ui_up"):
		if not active_view.follow_focus:
			get_tree().set_input_as_handled()
			(active_view as ScrollContainer).scroll_vertical -= event.get_action_strength("ui_up") * 16
	
func open():
	emit_signal("opened")
	
	# populate with most recent data
	for v in views.get_children():
		if v.has_method("build"):
			v.build()
	
	get_node("InventoryCounter/Label").text = "%d/%d" % [len(GameState.inventory.data), GameState.inventory.bag_size]
	visible = true
	active_view = views.get_child(0)
	get_node("Window/Tabs/Inventory").pressed = true
	yield(get_tree(), "idle_frame")
	
	var cal = OS.get_datetime_from_unix_time(GameState.calendar.day)
	get_node("Window/Tabs/Calendar/HBoxContainer/Date").text = "%d/%d" % [cal.month, cal.day]
	
	# show 
	tween.interpolate_property(self, "rect_position:y", -150, 0, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -150, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	
	for v in views.get_children():
		if v.has_method("destroy"):
			v.destroy()
			
	emit_signal("closed")
	visible = false

func _on_tab_toggled(button_pressed):
	for c in views.get_children():
		c.visible = false
		
	active_view = views.get_node(button_pressed.name)
	active_view.visible = true
	active_view.grab_focus()
	active_view.grab_click_focus()

	get_node("InventoryCounter").visible = active_view.name == "Inventory"
	get_node("Cursor").play()
	
