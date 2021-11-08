extends Node

onready var load_list = get_node("LoadPanel")
onready var cursor_sfx = get_node("Cursor")

var done = false

func _setup(_params):
	yield(get_tree().create_timer(1.0), "timeout")
	match OS.get_name():
		"HTML5":
			get_node("TitleButtons/VBoxContainer/Exit/Button").queue_free()
	
func _start():
	get_node("TitleButtons/VBoxContainer/NewGame/Button").grab_focus()
	
	Bgm.change_song(preload("res://scenes/title/ontama_rensaku_05_watashinimo.ogg"))
	
	var anim = get_node("AnimationPlayer")
	anim.play("intro")
	yield(anim, "animation_finished")
	anim.play("float")
	
	get_node("TitleButtons/VBoxContainer/NewGame/Button").grab_focus()
	set_process_input(false)
	done = true

func _input(_event):
	get_tree().set_input_as_handled()

func _on_newgame_toggled(button_pressed):
	if not button_pressed:
		return
	cursor_sfx.play()
		
	GameState.reset_game()
	SceneManager.change_scene("garden", ["Home"])

func _on_loadgame_toggled(button_pressed):
	if not button_pressed:
		return
	cursor_sfx.play()	
	yield(load_list.open(), "completed")
	get_node("TitleButtons/VBoxContainer/LoadGame/Button").pressed = false
	get_node("TitleButtons/VBoxContainer/LoadGame/Button").grab_focus()
	
func _on_exit_toggled(button_pressed):
	if not button_pressed:
		return
	cursor_sfx.play()
	get_tree().quit()

func _teardown():
	yield(Bgm.fadeout(2.0), "completed")

func _on_ItemList_item_selected(index):
	if index >= 0:
		cursor_sfx.play()

func _on_Button_focus_entered():
	if done:
		cursor_sfx.play()

func _on_credits_toggled(button_pressed):
	if not button_pressed:
		return
	
	match OS.get_name():
		"HTML5":
			var f = File.new()
			f.open("res://credits.txt", File.READ)
			var credits = f.get_as_text()
			f.close()
			credits = credits.replace("\n", "<br>")
			var win = JavaScript.get_interface("window")
			var doc = win.open("", "_blank")
			doc.document.write(credits)
		_:
			OS.shell_open(ProjectSettings.globalize_path("res://credits.txt"))
			
