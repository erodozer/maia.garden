"""
godash.gd
@author Nicholas Hydock <nhydock@gmail.com>
@description |>
	Collection of basic utilities that I find useful for game development
	that overcomes some of the missing features of gdscript
	
	Library and name inspired by lodash for javascript
"""

extends Reference

enum SELECT_CHOICE { KEY, VALUE }

static func rand_choice(collection, select=SELECT_CHOICE.VALUE, rand = null):
	"""
	Pick randomly out of a collection.
	"""
	if len(collection) == 0:
		return null
	if rand == null:
		rand = RandomNumberGenerator.new()
		rand.randomize()
	if typeof(collection) == TYPE_DICTIONARY:
		match select:
			SELECT_CHOICE.KEY:
				return collection.keys()[rand.randi() % collection.keys().size()]
			_:
				return collection.values()[rand.randi() % collection.values().size()]
	elif select is RandomNumberGenerator:
		rand = select
	var idx = rand.randi() % collection.size()
	return collection[idx]

static func rand_chance(collection: Dictionary, rand = null):
	"""
	Select a random key from a dictionary based on percentage chances
	defined for each key.
	
	Can return null if chance does not fulfill any of the values
	
	the sum of weights must equal 1.0
	"""
	
	var keys = []
	var values = []
	
	if rand == null:
		rand = RandomNumberGenerator.new()
		rand.randomize()
	
	var total_weight = 0
	for key in collection.keys():
		var weight = collection[key]
		total_weight += weight
		keys.append(key)
		values.append(total_weight)
		
	var chance = rand.randf()
	var prev_value = 0
	for idx in range(len(values)):
		var value = values[idx]
		if chance >= prev_value and chance <= value:
			return keys[idx]
		prev_value = value
	return null
