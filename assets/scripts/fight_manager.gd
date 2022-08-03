extends Node2D

var arena_manager = null

var round_num = 0

var max_turn = 3
var cur_turn = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_arena_manager(am):
	arena_manager = am
