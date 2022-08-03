extends Node2D

onready var map = $Map
onready var challengers_node = $Challengers
onready var camera = $Camera2D

var tile_size = {
	x = 16,
	y = 16
}

var arena_size = {
	x = 4,
	y = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_tile_size(x=0,y=0):
	if y==0: y = x
	
	tile_size.x = x
	tile_size.y = y

func change_arena_size(x=0,y=0):
	if x !=0: arena_size.x = x
	if y !=0: arena_size.y = y

func set_camera_center():
	var camera_x = (tile_size.x * arena_size.x) / 2
	var camera_y = (tile_size.y * arena_size.y) / 2
	
	camera.position.x = camera_x
	camera.position.y = camera_y

# 0 = player
# 1 = enemy
func prepare_fighter(side=0):
	var fighter = load("res://scenes/arena/fighter.tscn").instance()
	challengers_node.add_child(fighter)
	if side==0: fighter.set_name('Player')
	else: fighter.set_name('Enemy')
	

