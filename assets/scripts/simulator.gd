extends Node2D

# Responsible for calculating best route at a certain state.
# Calculates all possible moves
onready var state = []
var heuristics = []
# Remove the first state in case there are no valid moves in the future.

var state_link = "res://scenes/state.tscn"

var cur_calc_state = 0
var cur_dets = null

var ai_player = null
var ai_self = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_sim(dets):
	cur_dets = dets

# Prepares a new move state in this direction
func prep_state(dets, m=-1):
	var new_state = load(state_link).instance()
	add_child(new_state)
	new_state.set_name('State '+state.size())
	
	state[cur_calc_state].prep_dets(dets, self,m)
	cur_calc_state += 1

# Feed Link
func load_ai(p="res://scenes/arena/ai/shiba_ai.tscn",a="res://scenes/arena/ai/shiba_ai.tscn"):
	var ai_p = load(p).instance()
	var ai_a = load(a).instance()
	
	$AIPlayer.add_child(ai_p)
	$AIAgent.add_child(ai_a)
	
	ai_player = ai_p
	ai_self = ai_a

# This is called after a state reaches depth 3 and finishes minmaxing the
# heuristic values.
func _on_finish_min_max_state():
	prep_state(cur_dets,cur_calc_state)

func _on_finish_calculating():
	pass
