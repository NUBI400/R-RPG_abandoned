class_name Group
extends Node2D

@export var group_all_stats: Array[Stats] = []

func _ready():
	save_group_stats()


func save_group_stats():
	group_all_stats.clear()  # Limpa a lista antes de salvar
	for child in get_children():
		if child is Player or Enemy and child.has_method("get_atual_stats"):
			group_all_stats.append(child.get_atual_stats())
