extends Node2D

onready var card_title = $TextureRect/Title
onready var hp = $TextureRect/Numbers/HPLabel
onready var mp = $TextureRect/Numbers/MPLabel

onready var grid = $TextureRect/Grid

var grid_space = {
	0: $TextureRect/Grid/TOP_LEFT,
	1: $TextureRect/Grid/TOP_CENTER,
	2: $TextureRect/Grid/TOP_RIGHT,
	3: $TextureRect/Grid/MID_LEFT,
	4: $TextureRect/Grid/MID_CENTER,
	5: $TextureRect/Grid/MID_RIGHT,
	6: $TextureRect/Grid/BOT_LEFT,
	7: $TextureRect/Grid/BOT_CENTER,
	8: $TextureRect/Grid/BOT_RIGHT
}

func set_card_data(card_data):
	hp.text = str(card_data.get_dmg())
	mp.text = str(card_data.get_mana())
	
	card_title.text = card_data.get_card_name()
	
	# Check for move tiles
	for tile in card_data.get_child(0).get_tiles():
		grid_space[tile].visible = true
		grid_space[tile].color = Color('#6eff00')
	
	pass
