extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer


@export var AB_UI : Control



func _visible():
	visible = true
	_focus()


func _ready() -> void:
	Events.ativate_move_UI.connect(_visible)
	_focus()

func _focus():
	for child in v_box_container.get_children():
		if child.get_index() == 0:
			child.grab_focus()
			




func _on_atack_button_down() -> void:
	pass # Replace with function body.


func _on_abilitys_button_down() -> void:
	AB_UI._visible()
	visible = false
