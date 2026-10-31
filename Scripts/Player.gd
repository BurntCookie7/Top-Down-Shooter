extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var muzzle_flash: LitPointLight2D = $AnimatedSprite2D/LitDirectionalLight2D
@onready var camera: Camera2D = $Camera2D
@onready var bullet_spawn_position: Node2D = $AnimatedSprite2D/BulletSpawnPosition
@onready var gun_sounds: AudioStreamPlayer = $AnimatedSprite2D/GunSounds

@export var Stats: PlayerStats
@export var bullet_scene: PackedScene = null
@export var shake_strength = 0.0
enum Control_Mode{Mouse_Turn, Key_Turn}
@export var SPEED = 150.0
@export var TURN_SPEED = 0.04
var hit_color: Color = Color(1.0, 0.0, 0.0, 1.0)
var reserves: int = 0
var max_ammunition: int = 15
var ammunition_remaining: int = 15
const JUMP_VELOCITY = -400.0
var turn_amount = 0.0
var state := Global.State.STANDING
var control_mode := Control_Mode.Mouse_Turn
var sitting: bool = false
var current_bench: Node2D = null
var sitting_position = null
var aiming: bool = false
var reload_sound = preload("res://Audio/Reload.mp3")
var shot_sound = preload("res://Audio/Gunshot.mp3")
var bullets_shot: int = 1

func _ready() -> void:
	Global.player = self
	SignalBus.player_entered_bench.connect(bench_entered)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().physics_frame
	Global.can_sit = false

func _input(event: InputEvent) -> void:
	if control_mode == Control_Mode.Mouse_Turn:
			if event is InputEventMouseMotion:
				turn_amount += event.relative.x
				
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if event.is_action_pressed("RightClick") and sitting != true:
		aiming = true
	if event.is_action_released("RightClick"):
		aiming = false
	if event.is_action_pressed("LeftClick") and aiming and gun_sounds.stream != reload_sound:
		shoot()
	if event.is_action_pressed("R") and not (gun_sounds.playing and gun_sounds.stream == reload_sound) and reserves > 0:
		gun_sounds.stream = reload_sound
		gun_sounds.pitch_scale = 1.0
		gun_sounds.play()
		await gun_sounds.finished
		for i in range(max_ammunition - ammunition_remaining):
			if ammunition_remaining != max_ammunition and reserves > 0:
				reserves -= 1
				ammunition_remaining += 1
		gun_sounds.stream = shot_sound

func bench_entered(bench, sitting_pos):
	#print("entered bench")
	current_bench = bench
	sitting_position = sitting_pos
	
func bench_left():
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	shake_strength = move_toward(shake_strength, 0.0, 40.0 * delta)
	camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_strength
	if Input.is_action_just_pressed("E") and is_instance_valid(current_bench):
		match sitting:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				state = Global.State.STANDING
				sitting = false
				collision.disabled = false
				current_bench.unload_upgrades()
			false:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				state = Global.State.SITTING
				sitting = true
				rotation = current_bench.rotation - deg_to_rad(90)
				global_position = sitting_position
				current_bench.load_upgrades(current_bench.upgrade_options)
				collision.disabled = true

		
		
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

func shoot():
	if ammunition_remaining > 0:
		muzzle_flash.energy = 1.0
		await Global.wait(5)
		muzzle_flash.energy = 0.0
		gun_sounds.pitch_scale = randf_range(0.9, 1.1)
		gun_sounds.play()
		camera_shake(2.0)
		for i in range(bullets_shot):
			await Global.wait(1)
			spawn_bullet()
		ammunition_remaining -= 1
		
func camera_shake(amount):
	shake_strength = max(shake_strength, amount)

func spawn_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.rotation_degrees = rotation_degrees
	get_tree().root.add_child(bullet)
	bullet.global_position = bullet_spawn_position.global_position
		
	
func state_handler():
	match state:
		Global.State.STANDING:
			if aiming:
				sprite.play("StandingAiming")
			else:
				sprite.play("Standing")
			SPEED = 150
			TURN_SPEED = 0.04
		Global.State.WALKING:
			if aiming:
				sprite.play("WalkingAiming")
			else:
				sprite.play("Walking")
			SPEED = 150
			TURN_SPEED = 0.04
		Global.State.RUNNING:
			if aiming:
				sprite.play("RunningAiming")
			else:
				sprite.play("Running")
			SPEED = 250
			TURN_SPEED = 0.07
		Global.State.SITTING:
			aiming = false
			sprite.play("Sitting")
			SPEED = 0
			TURN_SPEED = 0
			velocity = Vector2.ZERO


func apply_upgrade(upgrade:UpgradeData):
	for mod in upgrade.modifiers:
		var target: Object = null
		if mod.stat in self:
			target = self
		elif mod.stat in Global:
			target = Global
		else:
			push_warning("Upgrade stat not found: " + str(mod.stat))
			continue
		target.set(mod.stat, target.get(mod.stat) + mod.amount)
	current_bench.remove_upgrades()
	state = Global.State.STANDING
	sitting = false
	collision.set_deferred("disabled", false)
	Global.can_sit = false
	current_bench.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.enemies_killed = 0
	if Global.wins > Global.rounds:
		if Global.cycle >= len(Global.map_container.map_cycle)-1:
			Global.cycle = 0
		else:
			Global.cycle += 1
		Global.wins = 0
		Global.map_container.load_new_map(Global.map_container.map_cycle[Global.cycle])
	else:
		Global.map_container.load_new_map(Global.map_container.map_cycle[Global.cycle])
