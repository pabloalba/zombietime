extends TextureRect

const texture_enabled = preload("res://assets/img/play/hud/action_enabled.png")
const texture_disabled = preload("res://assets/img/play/hud/action_disabled.png")


func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func enable():
	set_texture(texture_enabled)
	
func disable():
	set_texture(texture_disabled)