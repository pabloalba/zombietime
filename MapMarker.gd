extends Button


export var num_level = 0
var texture_current = preload("res://assets/img/select_level/marker_current.png")
var texture_done = preload("res://assets/img/select_level/marker_done.png")

func _ready():
	get_node("Label").text = str(num_level)
	if globals.settings.max_level > num_level:
		icon = texture_done
		show()
	elif globals.settings.max_level == num_level:
		icon = texture_current
		show()
	else:
		hide()



func _on_MapMarker_pressed():	
	get_parent().select_level(num_level)
