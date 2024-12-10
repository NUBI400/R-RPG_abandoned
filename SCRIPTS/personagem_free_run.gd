extends CharacterBody2D


@onready var Sprite = $Sprite

const PARADO = 1
const ANDANDO = 2
const CORRENDO = 3
var estado_movimento


const lado = 1
const cima = 2
const baixo = 3
const diag_cima = 4
const diag_baixo = 5
var direction_position


var velocidade = 200

func _ready() -> void:
	estado_movimento = PARADO
	
	
	
	

func _physics_process(delta: float) -> void:
	if velocity.x != 0 and velocity.y == 0:  direction_position = lado
	if velocity.y > 0 and velocity.x == 0: direction_position = baixo
	if velocity.y < 0 and velocity.x == 0: direction_position = cima
	if velocity.y > 0 and velocity.x != 0: direction_position = diag_baixo
	if velocity.y < 0 and velocity.x != 0: direction_position = diag_cima
	#atualizador de direção
	
	
	if velocity.x < 0: Sprite.flip_h = false
	if velocity.x > 0: Sprite.flip_h = true
	var direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	velocity = direcao * velocidade
	$CanvasLayer/Label.text = "direcão " + str(direction_position)
	$CanvasLayer/Label2.text = "estado_mov " + str(estado_movimento)
	if estado_movimento == PARADO:
		parado()
	if estado_movimento == ANDANDO:
		andando()
	if estado_movimento == CORRENDO:
		correndo()
	
	
	move_and_slide()

func parado():
	
	#andar
	if velocity.x != 0 and not Input.is_action_pressed("Run") and direction_position == lado:
		estado_movimento = ANDANDO
		Sprite.play("Lado")
	if velocity.y < 0 and not Input.is_action_pressed("Run"):
		if direction_position == cima:
			estado_movimento = ANDANDO
			Sprite.play("Baixo")
		if direction_position == diag_baixo:
			estado_movimento = ANDANDO
			Sprite.play("DiagonalBaixo")
	
	if velocity.y > 0 and not Input.is_action_pressed("Run"):
		if direction_position == baixo:
			estado_movimento = ANDANDO
			Sprite.play("Cima")
		if direction_position == diag_baixo:
			estado_movimento = ANDANDO
			Sprite.play("DiagonalCima")
	
	if velocity.y < 0 and not Input.is_action_pressed("Run") and direction_position == diag_baixo:
		estado_movimento = ANDANDO
		Sprite.play("DiagonalBaixo")
	
	if velocity.y > 0 and not Input.is_action_pressed("Run") and direction_position == diag_cima:
		estado_movimento = ANDANDO
		Sprite.play("DiagonalCima")
	#correr
	if velocity.x != 0 and Input.is_action_pressed("Run"):
		estado_movimento = CORRENDO
		Sprite.play("Lado_RUN")
		velocidade = 300
	if velocity.y > 0 and Input.is_action_pressed("Run"):
		estado_movimento = CORRENDO
		Sprite.play("Baixo_RUN")
		velocidade = 300
	if velocity.y < 0 and Input.is_action_pressed("Run"):
		estado_movimento = CORRENDO
		Sprite.play("Cima_RUN")
		velocidade = 300
		
	if velocity.y < 0 and Input.is_action_pressed("Run") and direction_position == diag_baixo:
		estado_movimento = CORRENDO
		Sprite.play("DiagonalBaixo_RUN")
	
	if velocity.y > 0 and Input.is_action_pressed("Run") and direction_position == diag_cima:
		estado_movimento = CORRENDO
		Sprite.play("DiagonalCima_RUN")
	
func andando():
		
		
	if velocity == Vector2.ZERO and direction_position == lado: 
		estado_movimento = PARADO
		Sprite.play("Lado_STOP")
	
	if velocity == Vector2.ZERO and direction_position == cima: 
		estado_movimento = PARADO
		Sprite.play("Cima_STOP")
	
	if velocity == Vector2.ZERO and direction_position == baixo: 
		estado_movimento = PARADO
		Sprite.play("Baixo_STOP")
		
	if velocity == Vector2.ZERO and direction_position == diag_baixo: 
		estado_movimento = PARADO
		Sprite.play("DiagonalBaixo_STOP")
		
	if velocity == Vector2.ZERO and direction_position == diag_cima: 
		estado_movimento = PARADO
		Sprite.play("DiagonalCima_STOP")
		
	if Input.is_action_pressed("Run") and velocity.x != 0:
		estado_movimento = CORRENDO
		velocidade = 300
		Sprite.play("Lado_RUN")
	if Input.is_action_pressed("Run") and velocity.y > 0:
		estado_movimento = CORRENDO
		velocidade = 300
		Sprite.play("Baixo_RUN")
	if Input.is_action_pressed("Run") and velocity.y < 0:
		estado_movimento = CORRENDO
		velocidade = 300
		Sprite.play("Cima_RUN")
		
		
	if direction_position == cima and velocity != Vector2.ZERO:
		Sprite.play("Cima")
	if direction_position == diag_cima and velocity != Vector2.ZERO:
		Sprite.play("DiagonalCima")
	if direction_position == baixo and velocity != Vector2.ZERO:
		Sprite.play("Baixo")
	if direction_position == diag_baixo and velocity != Vector2.ZERO:
		Sprite.play("DiagonalBaixo")
	if direction_position == lado and velocity != Vector2.ZERO:
		Sprite.play("Lado")
func correndo():
	if velocity == Vector2.ZERO and direction_position == lado: 
		estado_movimento = PARADO
		velocidade = 200
		Sprite.play("Lado_STOP")
	
	if velocity == Vector2.ZERO and direction_position == cima: 
		estado_movimento = PARADO
		velocidade = 200
		Sprite.play("Cima_STOP")
	
	if velocity == Vector2.ZERO and direction_position == baixo: 
		estado_movimento = PARADO
		velocidade = 200
		Sprite.play("Baixo_STOP")
		
		
	if Input.is_action_just_released("Run") and velocity != Vector2.ZERO:
		estado_movimento = ANDANDO
		velocidade = 200
	
	if velocity == Vector2.ZERO and direction_position == diag_baixo: 
		estado_movimento = PARADO
		Sprite.play("DiagonalBaixo_STOP")
		
	if velocity == Vector2.ZERO and direction_position == diag_cima: 
		estado_movimento = PARADO
		Sprite.play("DiagonalCima_STOP")
	
	
	
	if direction_position == cima and velocity != Vector2.ZERO:
		Sprite.play("Cima_RUN")
	if direction_position == diag_cima and velocity != Vector2.ZERO:
		Sprite.play("DiagonalCima_RUN")
	if direction_position == baixo and velocity != Vector2.ZERO:
		Sprite.play("Baixo_RUN")
	if direction_position == diag_baixo and velocity != Vector2.ZERO:
		Sprite.play("DiagonalBaixo_RUN")
	if direction_position == lado and velocity != Vector2.ZERO:
		Sprite.play("Lado_RUN")
	
