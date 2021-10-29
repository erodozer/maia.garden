extends Control

onready var icon = get_node("ActiveSeed")
onready var count = get_node("ActiveSeed/Count")

var current_tool = null setget set_current_tool

var tools = []

signal change_tool(new_tool)

func _ready():	
	GameState.inventory.connect("changed", self, "update_count")
	
	for f in GameState.inventory.data:
		if f.ref.type == "tool" and f.ref.effect.type == "flower":
			tools.append(f)
	set_current_tool(tools[0])

func set_current_tool(item):
	if null:
		return
		
	current_tool = item
	icon.texture = current_tool.ref.icon
	
	update_count(current_tool.id, {
		"id": current_tool.id,
		"amount": current_tool.amount,
	})
	emit_signal("change_tool", item)

func update_count(_id, item):
	count.text = "%d" % item.amount
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		self.current_tool = tools[wrapi(tools.find(current_tool) + 1, 0, len(tools))]
		return
		
	if Input.is_action_just_pressed("ui_focus_prev"):
		self.current_tool = tools[wrapi(tools.find(current_tool) - 1, 0, len(tools))]
		return
		
func pause():
	set_process(false)

func resume():
	set_process(true)
