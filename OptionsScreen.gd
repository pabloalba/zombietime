extends TextureRect

signal restart
signal start_stop_music

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	if globals.music:
		get_node("VBoxContainer/Music").text = "Music ON"
	else:
		get_node("VBoxContainer/Music").text = "Music OFF"
		
	if globals.sound:
		get_node("VBoxContainer/Sound").text = "Sound ON"
	else:
		get_node("VBoxContainer/Sound").text = "Sound OFF"


func _on_Close_pressed():
	hide()


func _on_Music_pressed():
	globals.music = not globals.music
	update_buttons()
	emit_signal("start_stop_music")


func _on_Sound_pressed():
	globals.sound = not globals.sound
	update_buttons()


func _on_Restart_pressed():
	emit_signal("restart")
	hide()


func _on_Exit_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
