class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)


@export var card: Ability : set = _set_card
@export var char_stats: Stats : set = _set_char_stats

@export var player_handler : Node


@onready var fundo = $Fundo
@onready var cost: Label = $HBoxContainer/HBoxContainer/Icon/Cost
@onready var Name = $HBoxContainer/Label
@onready var icon: TextureRect = $HBoxContainer/HBoxContainer/Icon


@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []

var original_index := 0
var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false


#STATES

@onready var base_state: Node = $CardStateMachine/CardBaseState
@onready var select_state: Node = $CardStateMachine/CardSelectState
@onready var released_state: Node = $CardStateMachine/CardReleasedState
@onready var clicked_state: Node = $CardStateMachine/CardClickedState



func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	if disabled:
		return
	card_state_machine.on_input(event)
	
func _process(delta):
	if disabled:
		return
	
	_on_char_stats_changed()


func play() -> void:
	if not card or disabled:
		return
	
	card.play(targets, char_stats)
	Events.desativate_abilitys_UI.emit()
	#queue_free()

func _on_gui_input(event: InputEvent) -> void:
	
	
	card_state_machine.on_gui_input(event)



func _on_mouse_entered() -> void:

	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:

	
	card_state_machine.on_mouse_exited()

func _set_card(value: Ability) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	Name.text = card.name
	icon.texture = card.icon


func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)


func _set_char_stats(value: Stats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_char_stats_changed):
		char_stats.stats_changed.connect(_on_char_stats_changed)



func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if disabled:
		return
	
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	if disabled:
		return
	
	targets.erase(area)


func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if disabled or used_card == self:
		return
	
	disabled = true


func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	if disabled:
		return
	
	disabled = false
	self.playable = char_stats.can_play_ability(card)


func _on_char_stats_changed() -> void:
	if Events.turn == Events.turn_.enemy:
		_disable_card()
		return # Sai da função para evitar verificações desnecessárias

	if card:
		self.playable = char_stats.can_play_ability(card)
	else:
		_disable_card()




func _disable_card() -> void:
	disabled = true
	#visible = false
	playable = false
	cost.text = ""
	Name.text = ""
	icon.texture = null
