extends CanvasLayer

const button = preload("./ItemButton.tscn")

signal exchange(item, value)
signal end

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var items = get_node("Control/PanelContainer/MarginContainer/ScrollContainer/Items")
onready var panel = get_node("Control/PanelContainer")
onready var tween = get_node("Tween")
	
var group

func _ready():
	set_process_input(false)
	
func exchange(item, value):
	if not game_state:
		return
		
	# purchase an item
	if game_state.konpeto + value < 0:
		return
		
	# sell an item from inventory
	if value > 0 and game_state.inventory[item.id] <= 0:
		return
	
	game_state.konpeto += value
	emit_signal("exchange", item, value)
	
func open(item_list, exchange_mode):
	group = ButtonGroup.new()
	
	for i in item_list:
		var b = button.instance()
		items.add_child(b)
		b.exchange = exchange_mode
		b.item = i
		b.button.group = group
		b.button.set_meta("item", i)
		b.button.set_meta("value", i.sell if exchange_mode else -i.cost)
		b.button.grab_focus()
		
	group.get_buttons()[0].pressed = true
	tween.interpolate_property(panel, "rect_position:y", -64, 4, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(panel, "rect_position:y", 4, -64, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	
	for c in items.get_children():
		c.queue_free()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var button = group.get_pressed_button()
		exchange(button.get_meta("item"), button.get_meta("value"))
	
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
	
