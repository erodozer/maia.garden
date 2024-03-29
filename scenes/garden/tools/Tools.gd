extends Control

onready var icon = get_node("ActiveSeed")
onready var count = get_node("ActiveSeed/Count")
onready var player = get_tree().get_nodes_in_group("player").front()

var current_tool = null setget set_current_tool

var tools = []

signal change_tool(new_tool)

func _ready():	
	GameState.inventory.connect("changed", self, "update_count")
	
	for f in GameState.inventory.data:
		if f.ref.type == "tool" and f.ref.effect.type == "flower":
			tools.append(f)
			
	if tools.empty():
		visible = false
		return

	set_current_tool(tools.front())

func set_current_tool(item):
	if not item:
		return
		
	current_tool = item
	icon.texture = current_tool.ref.icon
	
	update_count(current_tool.id, {
		"id": current_tool.id,
		"amount": current_tool.amount,
	})
	emit_signal("change_tool", item)

func update_count(_id, item):
	if current_tool and _id != current_tool.id:
		return
	
	count.text = "%d" % item.amount
	player.reevaluate()
	
func _process(_delta):
	if len(tools) <= 0:
		return
	
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
