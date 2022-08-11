extends Node2D

onready var arena_manager = $ArenaManager
onready var deck_manager = $DeckManager
onready var screen = $StrategyScreen

var round_num = 0

var max_turn = 3
var cur_turn = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen.set_deck(deck_manager.get_shiba_cards())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_battle_begin():
	screen.visible = false


func _on_StrategyScreen_begin():
	screen.visible = false
