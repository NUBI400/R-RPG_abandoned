extends CardState
var mouse_exited = false
var queue_animation = false  # Variável para enfileirar a animação de entrada

var current_card: CardUI

var moving = false

var card_position = Vector2(95, 130)

var clicked_inside_enemy = false
var clicked_inside_cards = false
var clicked_inside_player = false


var clicked_in_nothing = false



func _exited():
	mouse_exited = true




func enter() -> void:
	# Enfileira a animação se outra estiver rodando
	if moving:
		queue_animation = true
		return


	moving = true
	current_card = get_parent().get_parent()
	Events.tooltip_hide_requested.emit()
	mouse_exited = false
	print("SELECT")
	
	$"../..".z_index = 1
	
	var tween = get_tree().create_tween()
	tween.tween_property($"../..", "position", Vector2.UP * 40, 0.1).as_relative().set_trans(Tween.TRANS_EXPO)
	tween.play()
	
	await get_tree().create_timer(0.1).timeout
	moving = false
	
	if current_card.card.type == 0:
		Events.card_to_enemy = true
	else:
		Events.card_to_enemy = false

	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)
	
	# Verifica se há uma animação enfileirada
	if queue_animation:
		queue_animation = false
		enter()

func _physics_process(delta):
	print(mouse_exited)
	
	if mouse_exited:
		Events.card_to_enemy = false

	if $"../..".position.y == -40 and mouse_exited and not moving:
		Events.tooltip_hide_requested.emit()
		mouse_exited = false
		moving = true
		var tween = get_tree().create_tween()
		tween.tween_property($"../..", "position", Vector2.UP * -40, 0.1).as_relative().set_trans(Tween.TRANS_EXPO)
		tween.play()
		
		await get_tree().create_timer(0.1).timeout
		transition_requested.emit(self, CardState.State.BASE)
		moving = false
		$"../..".z_index = 0

func _card_used(area):
	Events.tooltip_hide_requested.emit()
	
	if not current_card.targets.has(area):
		current_card.targets.append(area)
		
	transition_requested.emit(self, CardState.State.RELEASED)
	Events.card_to_enemy = false
	mouse_exited = true


func on_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.pressed:
		if moving == false:
			var click_position = event.position
			var enemy_area = get_tree().get_nodes_in_group("enemies")
			var card_area = get_tree().get_nodes_in_group("card_area")
			var PLayer_area = get_tree().get_nodes_in_group("CardDropArea")
			
			clicked_inside_enemy = false
			clicked_inside_cards = false
			clicked_inside_player = false
			
			# SELECIONAR A CARTA COM A CARTA JA SELECIONADA
			#_indentificar_area(card_area, click_position, 2)
			#
			# SELECIONAR INIMIGOS
			
			if current_card.card.type == 0:
				_indentificar_area(enemy_area, click_position, 1)
			
			# SELECIONAR O PLAYER
			if current_card.card.type == 1:
				_indentificar_area(PLayer_area, click_position, 3)
			
	
		if not clicked_inside_enemy and not clicked_inside_player:
			mouse_exited = true
			
		



func _indentificar_area(area_vista, click_position, clicked_inside):
	var single_targeted := card_ui.card.is_single_targeted()
	
	for area in area_vista:
		if area is Area2D:
			for shape_idx in range(area.shape_owner_get_shape_count(0)):
				var shape = area.shape_owner_get_shape(0, shape_idx)
				if shape is RectangleShape2D:
					var rect = Rect2(area.global_position - shape.extents, shape.extents * 2)
					if rect.has_point(click_position):
						match clicked_inside:
							1:
								clicked_inside_enemy = true
								_card_used(area)
								break
								
							2:
								clicked_inside_cards = true
								break
							3:
								clicked_inside_player = true
								_card_used(area)
								break
