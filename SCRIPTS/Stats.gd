class_name Stats
extends Resource

signal stats_changed

@export var name: String
@export var art: Texture

#@export var max_health := 1
#var block: int : set = set_block


var max_pv : int
var max_pa : int

@export var PV : int #34
@export var PA : int #27

@export var Força : int #18 (+4)
@export var Destreza : int#12 (+2)
@export var Carisma : int #10
@export var Constituição : int #15 (+3)
@export var Sabedoria : int  #8 (-1)


@export var Ability_deck: Array[Ability] = [] : set = set_ability_deck

var turn_count: int = 0



func set_stats(value : int) -> void:
	PV = clampi(value, 0, max_pv)
	PV = clampi(value, 0, max_pa)
	stats_changed.emit()
	
	

func set_ability_deck(value: Array[Ability]):
	if value.size() > 4:
		Ability_deck = value.slice(0, 3)  # Limita ao máximo de 3 itens
	else:
		Ability_deck = value


func increment_turn_count() -> void:
	turn_count += 1

func reset_turn_count() -> void:
	turn_count = 0


func take_damage(damage : int) -> void:
	if damage <= 0:
		return
	var initial_damage = damage
	#damage = clampi(damage - block, 0, damage)
	#self.block = clampi(block - initial_damage, 0, block)
	self.PV -= damage


func heal(amount : int) -> void:
	self.PV += amount


func can_play_ability(ability: Ability) -> bool:
	return PA >= ability.cost


func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.max_pv = PV
	instance.max_pa = PA
	return instance
