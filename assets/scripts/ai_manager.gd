extends Node2D

signal finished_choosing(cards)

onready var deck = $Deck
onready var calculator = $Simulator

var ai = null
var player_deck = null

var cur_state = {
	player_pos_x = 0,
	player_pos_y = 1,
	self_pos_x = 7,
	self_pos_y = 2,
	player_hp = 100,
	player_mp = 100,
	self_hp = 100,
	self_mp = 100
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prepare_ai(d, a):
	player_deck = d
	var bot = load(a).instance()
	ai.add_child(bot)
	ai = bot

func decide_cards():
	pass

func calculate_heuristic():
	pass

