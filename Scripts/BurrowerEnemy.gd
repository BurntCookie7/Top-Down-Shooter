extends CharacterBody2D
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var attack_area: Area2D = $Area2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var burrow_particles: GPUParticles2D = $BurrowParticles
@export var SPEED: float = 100.0
@export var drops: DropTable
@export var total_health: int = 100.0
@onready var sprite: LitAnimatedSprite2D = $Sprite2D
@export var hit_color: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var damage: int = 5
@onready var health_bar: ProgressBar = $Node2D/ProgressBar
@onready var burrow_timer: Timer = $BurrowTimer
@onready var hit_timer: Timer = $HitTimer
var health: int
var health_bar_offset: Vector2 = Vector2(13, -20)
enum State{BURROWED, UNBURROWED, THREAT, ATTACK}
var state = State.UNBURROWED
var can_attack = false
var stretch_tween: Tween

func _ready() -> void:
	collision.disabled = false
	burrow_particles.emitting = false
	await get_tree().physics_frame
	update_target()
	health = total_health
	health_bar.top_level = true
	burrow()

func _physics_process(delta: float) -> void:
	manage_health()
	if Global.arachnophobia:
		sprite.play("arachnophobia")
	else:
		sprite.play("default")
	match state:
		State.UNBURROWED:
			if navigation.is_navigation_finished():
				velocity = Vector2.ZERO
				move_and_slide()
				return
			var next_position := navigation.get_next_path_position()
			var direction := global_position.direction_to(next_position)
			velocity = direction * SPEED
			rotation = direction.angle()
		State.BURROWED:
			var direction = global_position.direction_to(navigation.target_position)
			velocity = direction * SPEED
			rotation = direction.angle()
	health_bar.global_position = global_position + health_bar_offset
	move_and_slide()

func _on_timer_timeout() -> void:
	update_target()
	

func hit():
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	await Global.wait(3)
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func update_target():
	if is_instance_valid(player):
		navigation.target_position = player.global_position

func squash_stretch(stretch := Vector2(1.4, 0.7), time := 0.25):
	if stretch_tween:
		stretch_tween.kill()
	sprite.scale = stretch
	stretch_tween = create_tween()
	stretch_tween.tween_property(sprite, "scale", Vector2(0.155, 0.155), time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func manage_health():
	health_bar.value = health
	if health <= 0:
		var drop: Node2D = drop_item(drops.table).instantiate()
		Global.map.add_child(drop)
		drop.global_position = global_position
		drop.rotation = randf()
		Global.enemies_killed += 1
		queue_free()

func burrow():
	state = State.BURROWED
	burrow_particles.scale = Vector2.ONE
	collision.set_deferred("disabled", true)
	burrow_particles.emitting = true
	health_bar.hide()
	sprite.hide()
	SPEED = 200

func unburrow():
	state = State.UNBURROWED
	burrow_particles.scale = Vector2.ONE
	collision.set_deferred("disabled", false)
	burrow_particles.emitting = false
	health_bar.show()
	sprite.show()
	SPEED = 100

func drop_item(table: Dictionary):
	var total = 0.0
	for weight in table.values():
		total += weight
	
	var roll: float = randf() * total
	
	for item in table:
		roll -= table[item]
		if roll <= 0.0:
			return item
	
	return null

func attack():
	squash_stretch(Vector2(0.3, 0.155), 1.0)
	Global.player_health -= damage
	burrow_particles.scale = Vector2.ONE

func _on_player_detecion_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		burrow_timer.stop()
		unburrow()


func _on_player_detecion_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		burrow_timer.start()


func _on_burrow_timer_timeout() -> void:
	burrow()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_attack = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_attack = false


func _on_hit_timer_timeout() -> void:
	if can_attack:
		attack()
