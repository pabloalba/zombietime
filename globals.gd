extends Node

var hero = 0

const TYPE_WEAPON = 0
const TYPE_ARMOR = 1
const TYPE_USEABLE = 2

const SUBTYPE_BLADE = 0
const SUBTYPE_BULLET = 1
const SUBTYPE_BLUNT = 2

const ITEM_KNIFE = 0
const ITEM_GUN = 1
const ITEM_HOCKEY = 2
const ITEM_JACKET = 3
const ITEM_RIOT_GEAR = 4
const ITEM_RIFLE = 5
const ITEM_CROWBAR = 6

const TILE_HERO_START = 307
const TILE_TARGET = 297
const TILE_ZOMBIE_1 = 336
const TILE_ZOMBIE_2 = 337
const TILE_ZOMBIE_3 = 338
const TILE_KNIFE = 326


var texture_blunt = [
	null,
	preload("res://assets/img/play/hud/items/blunt1.png"),
	preload("res://assets/img/play/hud/items/blunt2.png"),
	preload("res://assets/img/play/hud/items/blunt3.png"),
	preload("res://assets/img/play/hud/items/blunt4.png"),
	preload("res://assets/img/play/hud/items/blunt5.png"),
]

var texture_blade = [
	null,
	preload("res://assets/img/play/hud/items/blade1.png"),
	preload("res://assets/img/play/hud/items/blade2.png"),
	preload("res://assets/img/play/hud/items/blade3.png"),
	preload("res://assets/img/play/hud/items/blade4.png"),
	preload("res://assets/img/play/hud/items/blade5.png"),
]

var texture_bullet = [
	null,
	preload("res://assets/img/play/hud/items/bullet1.png"),
	preload("res://assets/img/play/hud/items/bullet2.png"),
	preload("res://assets/img/play/hud/items/bullet3.png"),
	preload("res://assets/img/play/hud/items/bullet4.png"),
	preload("res://assets/img/play/hud/items/bullet5.png"),
]

var texture_shield = [
	null,
	preload("res://assets/img/play/hud/items/shield1.png"),
	preload("res://assets/img/play/hud/items/shield2.png"),
	preload("res://assets/img/play/hud/items/shield3.png")
]




var items_available = [
	{
		"title": "knife"	,
		"description": "Stabs. Cut. Kill zombies.",
		"texture": preload("res://assets/img/play/hud/items/knife.png"),
		"power": 2,
		"durability": 3,
		"weapon_range": 1,
		"type": TYPE_WEAPON,
		"subtype": SUBTYPE_BLADE
	},
	{
		"title": "gun",
		"description": "Pew, pew",
		"texture": preload("res://assets/img/play/hud/items/gun.png"),
		"power": 1,
		"durability": 5,
		"weapon_range": 2,
		"type": TYPE_WEAPON,
		"subtype": SUBTYPE_BULLET
	},
	{
		"title": "Hockey mask",
		"description": "Friday 13th armor",
		"texture": preload("res://assets/img/play/hud/items/hockey.png"),
		"power": 1,
		"durability": 1,
		"weapon_range": 0,
		"type": TYPE_ARMOR,
		"subtype": null
	},
	{
		"title": "Leather jacket",
		"description": "Armor with style",
		"texture": preload("res://assets/img/play/hud/items/jacket.png"),
		"power": 2,
		"durability": 2,
		"weapon_range": 0,
		"type": TYPE_ARMOR,
		"subtype": null
	},
	{
		"title": "Riot Gear",
		"description": "This is serious armor",
		"texture": preload("res://assets/img/play/hud/items/riot_gear.png"),
		"power": 3,
		"durability": 3,
		"weapon_range": 0,
		"type": TYPE_ARMOR,
		"subtype": null
	},
	{
		"title": "Assault rifle",
		"description": "Ratatatatata",
		"texture": preload("res://assets/img/play/hud/items/rifle.png"),
		"power": 3,
		"durability": 3,
		"weapon_range": 2,
		"type": TYPE_WEAPON,
		"subtype": SUBTYPE_BULLET
	},
	{
		"title": "Crowbar",
		"description": "Remember:\ngo for the head",
		"texture": preload("res://assets/img/play/hud/items/crowbar.png"),
		"power": 1,
		"durability": 4,
		"weapon_range": 1,
		"type": TYPE_WEAPON,
		"subtype": SUBTYPE_BLUNT
	}
]