extends Node

const Fortunes = preload("res://core/fortune.gd").Fortunes

var balance = 100 setget update_balance
var stamina = 100 setget update_stamina
var outfit = "default" setget set_outfit
var has_streamed = false

signal balance_changed(new_amount, old_amount)
signal stamina_changed(new_amount, old_amount)
signal change_outfit(outfit)

func persist(data):
	data["player"] = {
		"balance": balance,
		"stamina": stamina,
		"outfit": outfit,
		"streamed": has_streamed,
	}

func restore(data):
	balance = data.player.balance
	stamina = data.player.stamina
	outfit = data.player.outfit
	has_streamed = data.player.streamed
	
func reset():
	balance = 100
	stamina = 100
	has_streamed = false
	outfit = "default"

func set_outfit(v):
	outfit = v
	emit_signal("change_outfit", v)

func update_balance(amount):
	var old = balance
	balance = amount
	emit_signal("balance_changed", amount, old)
	GameState.emit_signal("stat", "konpeto", {
		"new_value": amount,
		"old_value": old,
	})
	
func update_stamina(amount):
	var old = stamina
	stamina = clamp(amount, 0, 100)
	emit_signal("stamina_changed", stamina, old)
	GameState.emit_signal("stat", "stamina", {
		"new_value": stamina,
		"old_value": old,
	})
	
func can_perform_action(cost):
	if cost > 0 and GameState.fortune.current_fortune == Fortunes.BAD_LUCK_TIRED:
		cost *= 2
		
	return stamina >= cost
	
func perform_action(cost):
	if cost > 0 and GameState.fortune.current_fortune == Fortunes.BAD_LUCK_TIRED:
		cost *= 2
		
	if stamina >= cost:
		self.stamina -= cost
		return true
	return false

func _on_Calendar_advance(_day):
	self.stamina = 100
	has_streamed = false
