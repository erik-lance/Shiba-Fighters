extends Node2D

# Responsible for calculating best route at a certain state.
# Calculates all possible moves
onready var state = []
var heuristics = []
# Remove the first state in case there are no valid moves in the future.

var state_link = "res://scenes/state.tscn"

var cur_calc_state = 0

var ai_player = null
var ai_self = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func prep_state(dets, m=-1):
	var new_state = load(state_link).instance()
	
	state[cur_calc_state].prep_dets(dets, self,m)

func load_ai(p,s):
	ai_player = p
	ai_self = s

func _on_finish_calculating():
	pass
