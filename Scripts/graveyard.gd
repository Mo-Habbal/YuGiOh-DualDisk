extends Node2D

var graveyard_cards = []


func _ready() -> void:
	z_index = 0
		# get_parent().connect_card_signals(self)


func get_top_graveyard():
	if graveyard_cards.size() > 0:
		return graveyard_cards.back()
	return null
