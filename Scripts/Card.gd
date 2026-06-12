extends Node2D
signal hovered
signal hovered_off
var card_position_in_hand

func _ready() -> void:
	pass		# get_parent().connect_card_signals(self)

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off",self)
