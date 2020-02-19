extends ColorRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	globals.load_settings()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_continue_pressed():
	get_tree().change_scene("res://SelectLevel.tscn")


func _on_options_pressed():
	pass # replace with function body


func _on_new_game_pressed():
	globals.settings.max_level = 1
	globals.settings.tips_shown.empty()
	globals.save_settings()
	get_tree().change_scene("res://SelectLevel.tscn")
