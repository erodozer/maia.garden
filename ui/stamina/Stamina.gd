extends PanelContainer

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var label = get_node("HBoxContainer/Label")
onready var tween = get_node("Tween")

var amount = 0 setget update_text

func _ready():
	if not game_state:
		return
		
	self.amount = game_state.stamina
	game_state.connect("stamina_changed", self, "update_balance")

func update_text(v):
	amount = v
	label.text = "%d" % amount

func update_balance(v):
	tween.remove_all()
	tween.interpolate_property(self, "amount", amount, v, .3)
	tween.start()
