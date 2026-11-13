extends CharacterBody2D
@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var attack_area: Area2D = $Area2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var SPEED: float = 100.0
@export var drops: DropTable
@export var total_health: int = 150.0
@onready var sprite: LitAnimatedSprite2D = $Sprite2D
@export var hit_color: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var damage: int = 5
@export var baby: PackedScene
@onready var health_bar: ProgressBar = $Node2D/ProgressBar
@onready var hit_timer: Timer = $HitTimer
@onready var particles: GPUParticles2D = $GPUParticles2D
var health: int
var health_bar_offset: Vector2 = Vector2(13, -20)
var can_attack = true
var stretch_tween: Tween
var babies_thrown: int = 6

func _ready() -> void:
	collision.disabled = false
	await get_tree().physics_frame
	update_target()
	health = total_health
	health_bar.top_level = true

func _physics_process(delta: float) -> void:
	manage_health()
	if Global.arachnophobia:
		sprite.play("arachnophobia")
	else:
		sprite.play("Eggs")
	if navigation.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	var next_position := navigation.get_next_path_position()
	var direction := global_position.direction_to(next_position)
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
		die()

func drop_item():
	var drop: Node2D = drops.pick_item().instantiate()
	Global.map.add_child(drop)
	drop.global_position = global_position
	drop.rotation = randf()

func die():
	drop_item()
	Global.enemies_killed += 1
	queue_free()

func throw_babies():
	var angle_step := TAU / babies_thrown
	for i in babies_thrown:
		var angle := rotation + i * angle_step
		var dir := Vector2.RIGHT.rotated(angle)

		var baby_instance: RigidBody2D = baby.instantiate()
		Global.map.add_child(baby_instance)
		baby_instance.global_position = global_position + dir * 40
		baby_instance.rotation = angle
		baby_instance.throw(dir, 300, "Enemy")

func attack():
	squash_stretch(Vector2(0.3, 0.155), 1.0)
	throw_babies()

#func _on_attack_range_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#can_attack = true
#
#func _on_attack_range_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#can_attack = false

func _on_hit_timer_timeout() -> void:
	if can_attack:
		attack()
