extends Node2D


onready var cur_scene_node = $CurrentScene

var cur_scene = null
var scenes = {
	menu = "res://scenes/menu_scene.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_scene(s):
	var loaded_scene = load(s).instance()
	cur_scene_node.add_child(loaded_scene)
