extends Node2D

signal begin()

onready var deck = $CanvasLayer/TextureRect/DeckWrapper/DeckPadder/Deck
onready var selection = $CanvasLayer/TextureRect/SetCardWrapper/SelectedCards
onready var card_wrapper = $CanvasLayer/TextureRect/CardDataWrapper
var cur_card = null

var card_selection = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func empty_deck():
	print(deck.get_children().size())
	for deck_child in deck.get_children():
		deck_child.queue_free()

func empty_selection():
	for selection_child in selection.get_children():
		selection_child.queue_free()

func set_deck(cards):
	empty_deck()
	empty_selection()
	
	for card in cards:
		var card_obj = load("res://scenes/ui/card.tscn").instance()
		print(card.get_card_name())
		card_obj.set_card_data(card)
		deck.add_child(card_obj)
		card_obj.connect("card_selected",self,"_on_Card_Selected")


func _on_Card_Selected(ref):
	card_wrapper.get_child(0).text = ref.get_card_name()
	
	# Figure out the stats thing later i guess
	
	card_wrapper.get_child(2).text = ref.get_card_desc()

func _on_AddCard_button_up():
	if card_selection.size() < 3:
		var card_obj = load("res://scenes/ui/card.tscn").instance()
		card_obj.set_card_data(cur_card)
		selection.add_child(card_obj)
		card_selection.append(cur_card)



func _on_Start_button_up():
	emit_signal("begin")


func _on_Remove_button_up():
	empty_selection()
	card_selection = null


