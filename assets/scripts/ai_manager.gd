extends Node2D

signal finished_choosing(cards)

onready var deck = $Deck
onready var calculator = $Simulator

var ai = null
var player_deck = null
var root_state = null

var human_ai = null
var agent_ai = null

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

var is_ai_first = false
var ai_move_sequence = []

var player_prediction = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_cur_state(s):
	cur_state = s

func prepare_ai(h, a):
#	player_deck = d
#	var bot = load(a).instance()
#	ai.add_child(bot)
#	ai = bot
	human_ai = h
	agent_ai = a

# Consider, AI has to choose 3 cards even if lose early.
func decide_cards():
	calculator.prep_sim(cur_state)
	
	# Add human and agent ai once final
	calculator.load_ai()
	
	# Fix this once sure na who goes first
	if is_ai_first: calculator.set_agent_first()
	else: calculator.set_human_first()
	
	calculator.prepare_tree()
	root_state = calculator.get_root()
	
	var path = calculator.alpha_beta_search(root_state)
	var human_prediction = []
	var agent_prediction = []
	
	var depth = 0
	for state in path:
		if depth==0: 
			depth += 1
			continue
		
		if depth % 2 != 0:
			if is_ai_first: agent_prediction.append(state.get_move())
			else: human_prediction.append(state.get_move())
		else:
			if is_ai_first: human_prediction.append(state.get_move())
			else: agent_prediction.append(state.get_move())
		
		depth += 1
	
	# Clean up
	calculator.clean_node_groups()
	root_state.queue_free()
	
	ai_move_sequence = agent_prediction
	player_prediction = human_prediction

func set_human_first(): is_ai_first = false
func set_agent_first(): is_ai_first = true

func get_moves_human(): return player_prediction
func get_moves_agent(): return ai_move_sequence

