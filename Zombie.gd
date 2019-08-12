extends "res://Character.gd"

var marked = false
var main_scene
var num = 1
var just_spawned = false

func _ready():
	base_speed = 250
	speed = 250

	
func inc_num(inc):
	num += inc
	if num > 1:
		get_node("ZombiesNum/Label").set_text(str(num))
		get_node("ZombiesNum").show()
	else:
		get_node("ZombiesNum").hide()
	
func set_num(new_num):
	num = new_num

	
func mark():
	get_node("BullsEye").show()
	marked = true
	
func unmark():
	get_node("BullsEye").hide()
	marked = false
	

func _on_BullsEye_gui_input( ev ):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				main_scene.attack_zombie(self)
