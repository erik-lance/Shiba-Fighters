extends Node2D

export (int) var dmge
export (int) var mana
export (int) var heal
export (int) var prot


export (String) var card_name
export (String) var card_desc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_dmg(d): dmge = d
func set_mana(m): mana = m
func set_heal(h): heal = h
func set_prot(p): prot = p

func get_dmg(): return dmge
func get_mana(): return mana
func get_heal(): return heal
func get_prot(): return prot

# Card Aesthetic

func set_card_name(n): card_name = n
func set_card_desc(d): card_desc = d

func get_card_name(): return card_name
func get_card_desc(): return card_desc

