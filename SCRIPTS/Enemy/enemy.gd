class_name Enemy
extends Node2D

const ARROW_OFFSET := 5


@export var atual_stats: Stats : set = set_enemy_stats
@export var group_all_stats: Array[Stats] = []




@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $arrow
@onready var stats_ui: StatsUI = $StatsUI

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction : set = set_current_action


func set_current_action(value: EnemyAction) -> void:
	current_action = value
	#if current_action:
		#intent_ui.update_intent(current_action.intent)


func _physics_process(delta: float) -> void:
	if Events.card_to_enemy:
		arrow.show()
	if Events.card_to_enemy == false:
		arrow.hide()



func get_atual_stats() -> Stats:
	return atual_stats


func set_enemy_stats(value: Stats) -> void:
	atual_stats = value.create_instance()
	
	if not atual_stats.stats_changed.is_connected(update_stats):
		atual_stats.stats_changed.connect(update_stats)
		atual_stats.stats_changed.connect(update_action)
	
	update_enemy()

func setup_ai() -> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
		
	var new_action_picker := atual_stats.ai.instantiate() as EnemyActionPicker
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self




func update_stats() -> void:
	stats_ui.update_stats(atual_stats)


func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action



func update_enemy() -> void:
	if not atual_stats is Stats: 
		return
	if not is_inside_tree(): 
		await ready
	
	sprite_2d.texture = atual_stats.art
	#arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	#setup_ai()
	update_stats()



func do_turn() -> void:
	#stats.block = 0
	
	if not current_action:
		return
	
	current_action.perform_action()



func take_damage(damage: int) -> void:
	if atual_stats.PV <= 0:
		return
	
	atual_stats.take_damage(damage)
	
	if atual_stats.PV <= 0:
		queue_free()
	
	update_stats()
