extends Node2D

signal arena_finished(player, enemy)
signal player_finished(anim_name)
signal enemy_finished(anim_name)

onready var map = $Map
onready var challengers_node = $Challengers
onready var camera = $Camera2D

var fighter_node = {
	player = null,
	enemy = null
}

var tile_size = {
	x = 64,
	y = 64
}

var arena_size = {
	x = 4,
	y = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Starting call to arena scene.
func load_arena():
	if self.get_child(3).name == "Scenario":
		load_scenario(self.get_child(3))
	else:
		print("No scenario found. Loading tester...")
		prepare_tester()

# Loads arena based on scenario provided.
func load_scenario(scenario):
	prepare_arena()
	prepare_fighter(0, scenario.get_fighter_1)
	prepare_fighter(1, scenario.get_fighter_2)
	_on_loaded_arena()

func prepare_tester():
	prepare_arena()
	prepare_fighter(0)
	prepare_fighter(1)
	_on_loaded_arena()

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
func prepare_fighter(side=0, data="res://scenes/arena/fighters/shiba.tscn"):
	var fighter = load("res://scenes/arena/fighter.tscn").instance()
	challengers_node.add_child(fighter)
	if side==0: fighter.set_name('Player')
	else: fighter.set_name('Enemy')
	
	var fighter_data = load(data).instance()
	fighter.add_child(fighter_data)
	
	if side==0:
		fighter.position.x = tile_size.x * 0 + tile_size.x / 4
		fighter.position.y = tile_size.y * 1 + tile_size.y / 2
		fighter.ready_fighter(0)
		fighter_node.player = fighter
		fighter.connect('anim_done',self,'_on_player_unit_done')
	else:
		fighter.position.x = tile_size.x * 3 + tile_size.x - tile_size.x / 4
		fighter.position.y = tile_size.y * 1 + tile_size.y / 2
		fighter.get_child(0).scale.x = -1
		fighter.ready_fighter(1)
		fighter_node.enemy = fighter
		fighter.connect('anim_done',self,'_on_enemy_unit_done')

func prepare_arena():
	for y in arena_size.y:
		for x in arena_size.x:
			var new_tile = load("res://scenes/arena/tile.tscn").instance()
			map.add_child(new_tile)
			
			new_tile.position.x = x * tile_size.x
			new_tile.position.y = y * tile_size.y
	
	set_camera_center()

func _on_loaded_arena():
	emit_signal("arena_finished",fighter_node.player,fighter_node.enemy)

func _on_player_unit_done(anim_name):
	emit_signal("player_finished",anim_name)

func _on_enemy_unit_done(anim_name):
	emit_signal("enemy_finished",anim_name)
