extends Node2D

signal begin(cards)

onready var deck = $CanvasLayer/TextureRect/DeckWrapper/DeckPadder/Deck
onready var selection = $CanvasLayer/TextureRect/SetCardWrapper/SelectedCards
onready var card_wrapper = $CanvasLayer/TextureRect/CardDataWrapper
var cur_card = null

var card_selection = []

var orig_hp = 0
var orig_mp = 0

var cur_hp = -1
var cur_mp = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func empty_deck():
	print(deck.get_children().size())
	for deck_child in deck.get_children():
		deck_child.queue_free()

func empty_selection():
	for selection_child in selection.get_children():
		selection_child.reset_card()

func set_deck(cards):
	empty_deck()
	empty_selection()
	
	for card in cards:
		var card_obj = load("res://scenes/ui/card.tscn").instance()
		print(card.get_card_name())
		deck.add_child(card_obj)
		card_obj.set_card_data(card)
		
		card_obj.connect("card_selected",self,"_on_Card_Selected")

func prep_cur_stats(h,m):
	orig_hp = h
	orig_mp = m
	cur_hp = h
	cur_mp = m

# Simply changes the text written on t he right.
func _on_Card_Selected(ref):
	card_wrapper.get_child(0).text = ref.get_card_name()
	
	# Figure out the stats thing later i guess
	
	card_wrapper.get_child(2).text = ref.get_card_desc()
	cur_card = ref

func _on_AddCard_button_up():
	if card_selection.size() < 3:
		selection.get_child(card_selection.size()).set_card_data(cur_card)
		card_selection.append(cur_card)



func _on_Start_button_up():
	emit_signal("begin", card_selection)


func _on_Remove_button_up():
	empty_selection()
	card_selection = []


