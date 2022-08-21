extends Node2D

var shiba_fight_cards = {
	rasengan = "res://scenes/cards/shiba/rasengan.tscn",
	senpu = "res://scenes/cards/shiba/senpu.tscn",
	sudoku = "res://scenes/cards/shiba/sudoku.tscn",
	bamboom = "res://scenes/cards/shiba/bamboom.tscn"
}

var basic_cards = {
	regen = "res://scenes/cards/regen_mana.tscn"
}

var move_cards = {
	up = "res://scenes/cards/move_up.tscn",
	right = "res://scenes/cards/move_right.tscn",
	down = "res://scenes/cards/move_down.tscn",
	left = "res://scenes/cards/move_left.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_shiba_cards():
	var cards = []
	for moves in move_cards:
		var card = load(move_cards[moves]).instance()
		cards.append(card.get_child(0))
		self.add_child(card)
	
	for basic_card in basic_cards:
		var card = load(basic_cards[basic_card]).instance()
		cards.append(card.get_child(0))
		self.add_child(card)
	
	for shiba_moves in shiba_fight_cards:
		var card = load(shiba_fight_cards[shiba_moves]).instance()
		cards.append(card.get_child(0))
		self.add_child(card)
	
	return cards


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
