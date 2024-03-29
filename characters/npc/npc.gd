extends StaticBody2D

onready var talk_indicator = get_node("Talk")

func _ready():
	can_talk()

func requests_prompt():
	return ""

func get_id():
	return name.to_lower()

func can_talk():
	var say = false
	for request in GameState.requests:
		if request.is_completed():
			continue
			
		if request.is_accepted():
			if request.get_owner() == get_id():
				say = true
				break
			else:
				var method_name = "can_talk_to_%s" % get_id()
				if request.has_method(method_name):
					say = request.call(method_name)
		elif request.get_owner() == get_id() and request.can_accept():
			say = true
			break
		
	talk_indicator.visible = say
		
	return say

func check_requests():
	for request in GameState.requests:
		if request.is_completed():
			continue
			
		if request.is_accepted():
			if request.get_owner() == get_id():
				yield(request.show_requirements(), "completed")
				break
			if request.has_method("can_talk_to_%s" % get_id()) and request.call("can_talk_to_%s" % get_id()):
				var state = request.call("talk_to_%s" % get_id())
				if state and state is GDScriptFunctionState:
					yield(state, "completed")
				break
		elif request.can_accept() and request.get_owner() == get_id():
				var state = request.accept()
				if state and state is GDScriptFunctionState:
					yield(state, "completed")
				yield(request.show_requirements(), "completed")
				break
	
	yield(get_tree(), "idle_frame")
	
	can_talk()  # refresh the indicator
