extends Control

@export var group_all_abilitys: Array[CardUI] = []
var current_index = 0

@onready var v_box_container: HBoxContainer = $VBoxContainer

func _ready() -> void:
	Events.desativate_abilitys_UI.connect(_visible)
	save_group_abilitys()

func save_group_abilitys():
	group_all_abilitys.clear()  # Limpa a lista antes de salvar
	for child in v_box_container.get_children():
		if child is CardUI:
			group_all_abilitys.append(child)
			print(group_all_abilitys)



func _visible():
	visible = not visible
	if group_all_abilitys.size() > 0:
		current_index = 0
		group_all_abilitys[current_index].base_state._selectState()


func _unhandled_input(event: InputEvent) -> void:
	if group_all_abilitys.size() == 0 or not visible:
		return  # Evita erros se a lista estiver vazia

	if event.is_action_pressed("esquerda"):
		# Verifica se existe uma habilidade anterior e se ela não está desabilitada
		if current_index > 0 and not group_all_abilitys[current_index - 1].disabled:
			group_all_abilitys[current_index].select_state._exited()
			current_index -= 1  # Move para a habilidade anterior
			group_all_abilitys[current_index].base_state._selectState()

	if event.is_action_pressed("direita"):
		# Verifica se existe uma próxima habilidade e se ela não está desabilitada
		if current_index < group_all_abilitys.size() - 1 and not group_all_abilitys[current_index + 1].disabled:
			group_all_abilitys[current_index].select_state._exited()
			current_index += 1  # Move para a próxima habilidade
			group_all_abilitys[current_index].base_state._selectState()
