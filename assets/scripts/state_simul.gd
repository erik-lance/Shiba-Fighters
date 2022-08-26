extends Node2D

var cur_state = {
	player_pos_x = 0,
	player_pos_y = 0,
	self_pos_x = 0,
	self_pos_y = 0,
	player_hp = 0,
	player_mp = 0,
	self_hp = 0,
	self_mp = 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_dets(dets):
	cur_state.player_pos_x = dets.player_pos_x
	cur_state.player_pos_y = dets.player_pos_y
	cur_state.self_pos_x = dets.self_pos_x
	cur_state.self_pos_y = dets.self_pos_y
	cur_state.player_hp = dets.player_hp
	cur_state.player_mp = dets.player_mp
	cur_state.self_hp = dets.self_hp
	cur_state.self_mp = dets.self_mp
