extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Control_Mode{Mouse_Turn, Key_Turn}
var SPEED = 150.0
var TURN_SPEED = 0.04
const JUMP_VELOCITY = -400.0
var turn_amount = 0.0
var state := Global.State.STANDING
var control_mode := Control_Mode.Mouse_Turn
var sitting: bool = false
var current_bench: Node2D = null
var sitting_position = null
func _ready() -> void:
	SignalBus.player_entered_bench.connect(bench_entered)
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

func bench_entered(bench, sitting_pos):
	Global.can_sit = true
	print("entered bench")
	current_bench = bench
	sitting_position = sitting_pos

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("E"):
		state = Global.State.SITTING
		sitting = not sitting
		rotation = current_bench.rotation - 90
		global_position = sitting_position
		
	if not sitting:
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
			SPEED = 0
			TURN_SPEED = 0
