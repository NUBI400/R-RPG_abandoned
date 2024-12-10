extends EnemyAction

@export var block := 15
@export var hp_threshold := 19

var already_used := false


func is_performable() -> bool:
	if not enemy or already_used:
		return false
	
	var is_low := enemy.atual_stats.PV <= hp_threshold
	already_used = is_low
	
	return is_low


func perform_action() -> void:
	if not enemy or not target:
		return
	
	print("MEGABLOCK")
	#var block_effect := BlockEffect.new()
	#block_effect.amount = block
	##block_effect.sound = sound
	#block_effect.execute([enemy])
	#
	#get_tree().create_timer(0.6, false).timeout.connect(
		#func():
			#Events.enemy_action_completed.emit(enemy)
	#)
