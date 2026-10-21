extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Control_Mode{Mouse_Turn, Key_Turn}
var SPEED = 150.0
var TURN_SPEED = 0.04
const JUMP_VELOCITY = -400.0
var turn_amount = 0.0
var state := Global.State.STANDING
var control_mode := Control_Mode.Mouse_Turn
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if control_mode == Control_Mode.Mouse_Turn:
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
	match control_mode:
		Control_Mode.Mouse_Turn:
			var input_direction := Input.get_vector( "Down", "Up", "Left", "Right")
			if input_direction:
				if Input.is_action_pressed("Shift"):
					state = Global.State.RUNNING
				else:
					state = Global.State.WALKING
				velocity = input_direction.rotated(rotation) * SPEED
			else:
				state = Global.State.STANDING
				velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		Control_Mode.Key_Turn:
			var turn := Input.get_axis("Left", "Right")
			var forward := Input.get_axis("Down", "Up")
			var directions := Vector2(forward, turn)
			if forward:
				if Input.is_action_pressed("Shift"):
					state = Global.State.RUNNING
				else:
					state = Global.State.WALKING
				velocity = transform.x * forward * SPEED
			else:
				state = Global.State.STANDING
				velocity = velocity.move_toward(Vector2.ZERO, SPEED)
			if turn:
				global_rotation += turn * TURN_SPEED

	state_handler()
	
	move_and_slide()
	
func state_handler():
	match state:
		Global.State.STANDING:
			sprite.play("Standing")
		Global.State.WALKING:
			sprite.play("Walking")
			SPEED = 150
			TURN_SPEED = 0.04
		Global.State.RUNNING:
			sprite.play("Running")
			SPEED = 250
			TURN_SPEED = 0.07
		Global.State.SITTING:
			sprite.play("Sitting")
