extends PanelContainer

onready var label = get_node("HBoxContainer/Label")
onready var tween = get_node("Tween")

var amount = 0 setget update_text

func _ready():
	self.amount = GameState.player.balance
	GameState.player.connect("balance_changed", self, "update_balance")

func update_text(v):
	amount = v
	label.text = "%d" % amount

func update_balance(v, _o):
	tween.remove_all()
	tween.interpolate_property(self, "amount", amount, v, .3)
	tween.start()
