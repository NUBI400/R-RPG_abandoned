class_name Ability
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE, RANDOW}

@export_group("Ability Attributes")
@export var name: String
@export var type: Type
@export var target: Target
@export var cost: int

@export_group("Ability Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String

@export var visual_game: PackedScene

#@export var sound: AudioStream


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], char_stats: Stats) -> void:
	#Events.card_played.emit(self)
	char_stats.PA -= cost
	
	char_stats.stats_changed.emit() #apagar depois
	
	if is_single_targeted():
		apply_effects(targets)
		
	else:
		apply_effects(_get_targets(targets))
	
	print("emit")
	Events.abilit_play.emit(visual_game)
	
func apply_effects(_targets: Array[Node]) -> void:
	pass
	
