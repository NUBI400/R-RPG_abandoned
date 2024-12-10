class_name Player
extends Node2D



@onready var ability_1: CardUI = $"../../Abilitys/VBoxContainer/Ability_UI"
@onready var ability_2: CardUI = $"../../Abilitys/VBoxContainer/Ability_UI2"
@onready var ability_3: CardUI = $"../../Abilitys/VBoxContainer/Ability_UI3"
@onready var ability_4: CardUI = $"../../Abilitys/VBoxContainer/Ability_UI4"

@onready var abilities_ui: Array[CardUI] = [ability_1, ability_2 ,ability_3 , ability_4]


@onready var stats_ui: StatsUI = $"../../StatsUI"


func _abilitys_start():
	#stats.set_ability_deck(stats.Ability_deck)
	Events.ativate_move_UI.emit()
	set_ability_deck(atual_stats.Ability_deck)
	update_player()


@export var atual_stats: Stats : set = set_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var abilitys: Control = $"../../Abilitys"




func set_ability_deck(value: Array[Ability]) -> void:
	atual_stats.Ability_deck = value
	
	# Atribuir habilidades para os nós `CardUI`
	for i in range(abilities_ui.size()):
		if i < atual_stats.Ability_deck.size():
			var card = abilities_ui[i]
			card.card = atual_stats.Ability_deck[i]   # Atribuir a habilidade
			card.char_stats = atual_stats       # Atribuir o char_stats
			card.disabled = false      # Ativar o card
		else:
			abilities_ui[i]._disable_card()
			


func get_atual_stats() -> Stats:
	return atual_stats


func set_stats(value: Stats) -> void:
	atual_stats = value
	
	for card in abilities_ui:
		card.char_stats = atual_stats
	
	if not atual_stats.stats_changed.is_connected(update_stats):
		atual_stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player() -> void:
	if not atual_stats is Stats: 
		return
	if not is_inside_tree(): 
		await ready

	sprite_2d.texture = atual_stats.art
	set_ability_deck(atual_stats.Ability_deck)
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(atual_stats)


func take_damage(damage: int) -> void:
	if atual_stats.PV <= 0:
		return
	
	atual_stats.take_damage(damage)
	
	#if stats.PV <= 0:
		#Events.player_died.emit()
		#queue_free()
