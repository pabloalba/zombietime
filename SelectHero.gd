extends ColorRect

var texture_heroes = [
	preload("res://assets/img/hero/hero0.png"),
	preload("res://assets/img/hero/hero1.png"),
	preload("res://assets/img/hero/hero2.png"),
	preload("res://assets/img/hero/hero3.png"),
	preload("res://assets/img/hero/hero4.png"),
	preload("res://assets/img/hero/hero5.png")	
]

func _ready():
	for i in range(6):
		if globals.settings.heroes_enabled[i]:
			get_node("MarginContainer/VBoxContainer/CenterContainer2/GridContainer").get_child(i).set_texture(texture_heroes[i])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_hero_gui_input( ev, num ):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				if globals.settings.heroes_enabled[num]:
					globals.hero = num
					get_tree().change_scene("res://Main.tscn")
