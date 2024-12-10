class_name Battle
extends Node2D
@onready var label: Label = $Label

@export var player : Group

@export var enemy : Group

@export var group_all_stats: Array[Stats] = []  # Grupo completo do jogador
@export var enemy_team: Array[Stats] = []  # Grupo completo dos inimigos (a ser preenchido)

# Classe para armazenar os valores de iniciativa
class TurnOrder:
	var stats: Stats
	var initiative: int

# Variáveis para armazenar a ordem dos turnos
var turn_queue: Array[TurnOrder] = []
var current_turn_index: int = -1


var user_atual = null

func _ready() -> void:
	Events.enemy_turn_ended.connect(next_turn)
	Events.player_turn_ended.connect(next_turn)
	Events.abilit_play.connect(_abilitplay)
	
	
	group_all_stats = player.group_all_stats
	enemy_team = enemy.group_all_stats

	# Calcular a ordem de turnos assim que o jogo começar
	calculate_turn_order()

# Função para calcular a ordem de turnos
func calculate_turn_order() -> void:
	turn_queue.clear()
	# Calcular a iniciativa para todos os membros do grupo do jogador
	
	for stats in group_all_stats:
		turn_queue.append(calculate_initiative(stats))

	# Calcular a iniciativa para todos os inimigos
	for stats in enemy_team:
		turn_queue.append(calculate_initiative(stats))
	
	# Ordenar a lista pela iniciativa (maior para menor)
	turn_queue.sort_custom(_sort_by_initiative)
	
	for turn in turn_queue:
		print(turn.stats.name, "-> Iniciativa:", turn.initiative)
	
	next_turn()  



# Função para calcular a iniciativa (d20 + destreza)
func calculate_initiative(stats: Stats) -> TurnOrder:
	var roll = randi_range(1, 20)  # Rola um d20
	var initiative = roll + stats.Destreza  # Soma o resultado com a destreza do personagem
	
	var turn_order = TurnOrder.new()
	turn_order.stats = stats
	turn_order.initiative = initiative
	return turn_order

# Função de ordenação personalizada
func _sort_by_initiative(a: TurnOrder, b: TurnOrder) -> bool:
	return a.initiative > b.initiative



func next_turn() -> void:
	
	if turn_queue.size() == 0:
		return

	current_turn_index = (current_turn_index + 1) % turn_queue.size()
	var current_stats = turn_queue[current_turn_index].stats
	# Incrementar o contador de turnos do personagem
	current_stats.increment_turn_count()
	label.text = "Turnos de " + str(current_stats.name) + ": " + str(current_stats.turn_count)

	# Verifica se o personagem é do grupo do jogador ou inimigo
	if current_stats in group_all_stats:
		for child in player.get_children():
			if child.atual_stats.name == current_stats.name:
				child._abilitys_start()  # Chama o método _abilitys_start para o jogador correspondente
				user_atual = child
				break  # Para o loop após encontrar o jogador corresponden

		
		Events.turn = Events.turn_.player
	else:
		Events.turn = Events.turn_.enemy



	## Aqui você pode adicionar lógica adicional para efeitos como dano por veneno
	#apply_status_effects(current_stats)
#
#func apply_status_effects(stats: Stats) -> void:
	## Exemplo: aplicar dano de veneno a cada 3 turnos
	#if stats.turn_count % 3 == 0:
		#var poison_damage = 5
		#print(stats.name, "sofreu", poison_damage, "de dano de veneno!")
		#stats.take_damage(poison_damage)
		#player.update_stats()  # Atualizar a interface do jogador, se necessário



# Teste: chamar a função `next_turn()` repetidamente para ver a ordem dos turnos
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		next_turn()



func _abilitplay(visual : PackedScene):
	# Instancia a cena passada como parâmetro
	var instance = visual.instantiate()
	add_child(instance)
	instance.position = user_atual.position
	
	
