extends TextureRect

onready var card_title = $Title
onready var hp = $Numbers/HPLabel
onready var mp = $Numbers/MPLabel

onready var grid = $Grid

var card_ref = null

signal card_selected(ref)

onready var grid_space = [
	$Grid/TOP_LEFT,
	$Grid/TOP_CENTER,
	$Grid/TOP_RIGHT,
	$Grid/MID_LEFT,
	$Grid/MID_CENTER,
	$Grid/MID_RIGHT,
	$Grid/BOT_LEFT,
	$Grid/BOT_CENTER,
	$Grid/BOT_RIGHT
]

func set_card_data(card_data):
	card_ref = card_data
	
	hp.text = str(card_data.get_dmg())
	mp.text = str(card_data.get_mana())
	
	card_title.text = card_data.get_card_name()
	self.name = card_title.text
	
	# Check for move tiles
	if card_data.get_child(0).get_tiles() != null:
		for tile in card_data.get_child(0).get_tiles():
			grid_space[tile].color = Color('#6eff00')

	if card_data.get_child(1).get_tiles() != null:
		for tile in card_data.get_child(1).get_tiles():
			grid_space[tile].color = Color.red

func reset_card():
	card_title.text = '?'
	hp.text = '?'
	mp.text = '?'
	card_ref = null
	
	for tile in grid_space:
		tile.color = Color('#006eff00')

func disable_button():
	$Button.disabled

func _on_Button_button_up():
	emit_signal("card_selected", card_ref)
