extends Node2D


const CARD_WIDTH = 190
const HAND_COUNT = 15
const HAND_Y_POSITION =1500
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
var player_hand = []
var center_screen_x = 2880 / 2



func _ready() -> void:
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range (HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManeger".add_child(new_card)
		var new_card_name = "card"
		player_hand.insert(0, new_card)
	update_hand_position()

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_position()	

	else:
		animate_card_to_position(card,card.card_position_in_hand,)
		update_hand_position()
		
		
func update_hand_position():
	for i in range(player_hand.size()):
		var card = player_hand[i]
		card.z_index = i + 80
		var center_index = (player_hand.size() - 1) / 2.0
		var distance_from_center = abs(i - center_index)
		var new_position = Vector2(calculate_card_position(i),HAND_Y_POSITION + distance_from_center * 20.0)
		card.rotation_degrees = (i - center_index) * 5.0


		# get the new position of every card,
		#based on the index and the total number of cards in hand
		#var new_position = Vector2(calculate_card_position(i),HAND_Y_POSITION)
		#card.card_position_in_hand = new_position
		
		
		animate_card_to_position(card,new_position)
		
		

func calculate_card_position(index):
	var x_offset = (player_hand.size() -1) * CARD_WIDTH
	var x_position = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return x_position
	
	
func animate_card_to_position(card,new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)



func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position()
