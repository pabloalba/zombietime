extends TextureRect


var timeout = 1.5

func _ready():
	pass

func _process(delta):	
	timeout -= delta
	if timeout <=0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://MainMenu.tscn")
