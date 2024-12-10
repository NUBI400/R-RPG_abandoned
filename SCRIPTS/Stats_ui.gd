class_name StatsUI
extends Control


@onready var NAME: Label = $VBoxContainer/HBoxContainer2/Name

@onready var PV: Label = $VBoxContainer/HBoxContainer/PV/int
@onready var PA: Label = $VBoxContainer/HBoxContainer/PA/int

@onready var Força: Label = $"VBoxContainer/Força/int"
@onready var Destreza: Label = $VBoxContainer/Destreza/int
@onready var Carisma: Label = $VBoxContainer/Carisma/int
@onready var Constituição: Label = $"VBoxContainer/Constituição/int"
@onready var Sabedoria: Label = $VBoxContainer/Sabedoria/int

func update_stats(stats: Stats) -> void:
	
	NAME.text = str(stats.name)
	
	PV.text = str(stats.PV)
	PA.text = str(stats.PA)
	
	Força.text = str(stats.Força)
	Destreza.text = str(stats.Destreza)
	Carisma.text = str(stats.Carisma)
	Constituição.text = str(stats.Constituição)
	Sabedoria.text = str(stats.Sabedoria)
