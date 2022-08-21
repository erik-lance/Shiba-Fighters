extends Node2D

onready var fx_tiles = [
	$FXTopLeft,
	$FXTop,
	$FXTopRight,
	$FXLeft,
	$FXMid,
	$FXRight,
	$FXBotLeft,
	$FXBot,
	$FXBotRight,
	$FXMain
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func place_on_tile(n=9,obj=null):
	if obj:
		print(obj)
		var instanced_obj = load(obj).instance()
		fx_tiles[n].add_child(instanced_obj)
	else:
		print('Tile is null!')

func clear_tile(n=-1):
	if n==-1:
		for tile in fx_tiles:
			if (tile.get_child_count() > 0):
				tile.get_child(0).queue_free()
	else:
		fx_tiles[n].get_child(0).queue_free()

func sp_sudoku_tile(n):
	if n < 0 or n > 8:
		print('Null sudoku tile! given:'+str(n))
	else:
		var r = randi() % 9 + 1
		var sudoku_num = load("res://scenes/arena/fx/sudoku_numbers/1.tscn").instance()
		fx_tiles[n].add_child(sudoku_num)
		sudoku_num.get_child(0).text = str(r)
	
