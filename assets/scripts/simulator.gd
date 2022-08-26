extends Node2D

# Responsible for calculating best route at a certain state.
onready var state = [$Depth0, $Depth1, $Depth2]
var cur_calc_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_state(dets):
	state[cur_calc_state].prep_dets(dets)
