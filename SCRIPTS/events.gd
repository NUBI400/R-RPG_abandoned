extends Node

#CODIGO PRA INDICAR QUAL O EFEITO DA CARTE PLAYER OU INIMIGO OU TODOS 
var card_to_enemy = false
var card_to_player = false

enum turn_ {enemy, player}

var turn: turn_


signal abilit_play(PackedScene)
signal player_turn_ended
signal enemy_turn_ended



signal ativate_move_UI

signal desativate_abilitys_UI

signal enemy_action_completed(enemy: Enemy)



## Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Ability)
signal card_tooltip_requested(card: Ability)
signal tooltip_hide_requested
#
