extends TextureRect

var item
var find_item_num
signal take_item
signal discard_item

func _ready():
	item = get_node("Item")
	item.get_node("Button").set_disabled(true)
	item.position.x = 560
	item.position.y = 130

func set_item(item_num):
	#TODO: Homogenize numbers
	if item_num == globals.TILE_KNIFE:
		item.initialize(globals.ITEM_KNIFE)
		find_item_num = globals.ITEM_KNIFE
	get_node("Title").set_text(item.title)
	get_node("Description").set_text(item.description)


func _on_Button_pressed():
	hide()


func _on_Discard_pressed():
	emit_signal("discard_item")
	hide()


func _on_Take_pressed():
	emit_signal("take_item", find_item_num)
	hide()
			
