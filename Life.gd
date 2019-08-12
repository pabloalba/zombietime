extends TextureRect

const texture_full = preload("res://assets/img/play/hud/heart.png")
const texture_empty = preload("res://assets/img/play/hud/heart_empty.png")


func _ready():
	pass

func fill():
	set_texture(texture_full)
	
func empty():
	set_texture(texture_empty)