extends Node2D


const COLLUSION_MASK_CARD = 1
const COLLUSION_MASK_CARD_SLOT = 2
const COLLUSION_MASK_GRAVEYARD = 8
var screen_size
var card_being_dragged
#var is_hovering_over_card
var card_drag_offset = Vector2.ZERO
var player_hand_refrence
 


func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_refrence = $"../playerHand"

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x + card_drag_offset.x, 0, screen_size.x), 
		clamp(mouse_pos.y + card_drag_offset.y, 0, screen_size.y) )
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
				
		else: 
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card_being_dragged.rotation_degrees = 0
	card_drag_offset = card.position - get_global_mouse_position()
	card.scale = Vector2(1.10, 1.10)
	card_being_dragged.z_index = 100
	var card_slot_found = raycast_check_for_card_slot()
	var graveyard_found = raycast_check_for_graveyard()
	if card_slot_found and card_slot_found.card_in_slot == card:
		card_slot_found.card_in_slot = null
	if graveyard_found and graveyard_found.get_top_graveyard() == card:
		graveyard_found.graveyard_cards.pop_back()


	
func finish_drag():
		card_being_dragged.scale = Vector2(1,1)
		var card_slot_found = raycast_check_for_card_slot()
		var graveyard_found = raycast_check_for_graveyard()
		if card_slot_found and card_slot_found.card_in_slot == null:
			card_being_dragged.z_index = 0
			player_hand_refrence.remove_card_from_hand(card_being_dragged)
			card_being_dragged.position = card_slot_found.position
			card_slot_found.card_in_slot = card_being_dragged
			card_being_dragged = null   
		elif graveyard_found:
			card_being_dragged.z_index = graveyard_found.graveyard_cards.size() + 1
			player_hand_refrence.remove_card_from_hand(card_being_dragged)
			card_being_dragged.position = graveyard_found.position
			graveyard_found.graveyard_cards.append(card_being_dragged)
			card_being_dragged = null    
		else :
			player_hand_refrence.add_card_to_hand(card_being_dragged)
			card_being_dragged = null
		
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLUSION_MASK_CARD
	var result = space_state.intersect_point(parameters)	
	if result.size() > 0:
		
		return get_card_with_highest_z_index(result)
	return null

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLUSION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		
		return result[0].collider.get_parent()
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index

	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func raycast_check_for_graveyard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLUSION_MASK_GRAVEYARD
	var result = space_state.intersect_point(parameters)	
	if result.size() > 0:
		
		return result[0].collider.get_parent()
	return null


# func test free() -> void:
#func connect_card_signals(card):
	#card.connect("hovered", on_hoverd_over_card)
	#card.connect("hovered_off", on_hoverd_off_card)
#
#func on_hoverd_over_card(card):
	#if !is_hovering_over_card:
		#is_hovering_over_card = true
		#highlilght_card(card, true)
#
#func on_hoverd_off_card(card):
		#highlilght_card(card, false)
		#var new_card_hovered = raycast_check_for_card()
		#if new_card_hovered:
			#highlilght_card(new_card_hovered,true)
		#else:
			#is_hovering_over_card = false
#
#func highlilght_card(card, hovered):
	#if hovered:
		#card.scale = Vector2(1.10,1.10)
		#card.z_index = 2
	#else:
		#card.scale = Vector2(1,1)
		#card.z_index = 1
