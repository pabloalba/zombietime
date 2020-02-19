extends TextureRect

var item
var find_item_num
signal take_item
signal discard_item

func _ready():
	item = get_node("Item")
	item.position.x = 560
	item.position.y = 130

func set_item(item_num):
	#TODO: Homogenize numbers
	print("Num: " +str(item_num))
	if item_num == globals.TILE_KNIFE:
		item.initialize(globals.ITEM_KNIFE)
		find_item_num = globals.ITEM_KNIFE
	elif item_num == globals.TILE_JACKET:
		item.initialize(globals.ITEM_JACKET)
		find_item_num = globals.ITEM_JACKET
	elif item_num == globals.TILE_GUN:
		item.initialize(globals.ITEM_GUN)
		find_item_num = globals.ITEM_GUN
	elif item_num == globals.TILE_BAT:
		item.initialize(globals.ITEM_BAT)
		find_item_num = globals.ITEM_BAT
	elif item_num == globals.TILE_AXE:
		item.initialize(globals.ITEM_AXE)
		find_item_num = globals.ITEM_AXE
	elif item_num == globals.TILE_HOCKEY:
		item.initialize(globals.ITEM_HOCKEY)
		find_item_num = globals.ITEM_HOCKEY
		
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
			
