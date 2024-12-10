extends TextureButton

@export var player_stats: Node2D  # Certifique-se de atribuir isso no editor corretamente

const TESTE_ABILITY_2 = preload("res://PERSONAGENS/teste_ability2.tres")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_AB"):
		var stats = player_stats.atual_stats  # Ajuste conforme sua estrutura
		if stats.Ability_deck.size() < 4:
			stats.Ability_deck.append(TESTE_ABILITY_2)
			player_stats._abilitys_start()
			print("Habilidade adicionada!")
		else:
			print("Limite de habilidades atingido!")
