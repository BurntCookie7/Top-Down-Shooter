extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var SPEED = 150.0
var TURN_SPEED = 0.01
const JUMP_VELOCITY = -400.0
var turn_amount = 0.0
enum State{WALKING, RUNNING, SITTING, STANDING}
var state = State.STANDING
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		turn_amount += event.relative.x
		
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	rotation += turn_amount * TURN_SPEED
	turn_amount = 0.0
	var input_direction := Input.get_vector( "Down", "Up", "Left", "Right")
	if input_direction:
		if Input.is_action_pressed("Shift"):
			state = State.RUNNING
		else:
			state = State.WALKING
		velocity = input_direction.rotated(rotation) * SPEED
	else:
		state = State.STANDING
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	state_handler()
	
	move_and_slide()
	
func state_handler():
	match state:
		State.STANDING:
			sprite.play("Standing")
		State.WALKING:
			sprite.play("Walking")
			SPEED = 150
			TURN_SPEED = 0.01
		State.RUNNING:
			sprite.play("Running")
			SPEED = 250
			TURN_SPEED = 0.02
		State.SITTING:
			sprite.play("Sitting")
