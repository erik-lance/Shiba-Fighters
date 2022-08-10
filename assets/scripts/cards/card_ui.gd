extends Node2D

onready var card_title = $Title
onready var hp = $Numbers/HPLabel
onready var mp = $Numbers/MPLabel

onready var grid = $Grid

var grid_space = {
	0: $Grid/TOP_LEFT,
	1: $Grid/TOP_CENTER,
	2: $Grid/TOP_RIGHT,
	3: $Grid/MID_LEFT,
	4: $Grid/MID_CENTER,
	5: $Grid/MID_RIGHT,
	6: $Grid/BOT_LEFT,
	7: $Grid/BOT_CENTER,
	8: $Grid/BOT_RIGHT
}

func set_card_data(card_data):
	hp.text = str(card_data.get_dmg())
	mp.text = str(card_data.get_mana())
	
	card_title.text = card_data.get_card_name()
	
	# Check for move tiles
	for tile in card_data.get_child(0).get_tiles():
		grid_space[tile].color = Color('#6eff00')
	
	pass
