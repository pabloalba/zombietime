extends "res://Character.gd"

var movement = 1
var num_actions = 3
var lives = 3


func _ready():
	base_speed = 500
	speed = 500
	var texture = load("res://assets/img/hero/hero" + str(globals.hero) + ".png")
	get_node("TextureRect").set_texture(texture)
