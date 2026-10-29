extends Area2D
@onready var timer: Timer = $Timer
@export var bullet_hit_particles: PackedScene
@export var SPEED := 1000.0
@export var lifetime: float = 1.0
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var damage: int = 10

var shot_by_enemy: bool = false
var hit_done: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = lifetime
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(global_rotation) * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if hit_done:
		return
	if shot_by_enemy and body.is_in_group("Enemy"):
		return
	if not shot_by_enemy and body.is_in_group("Player"):
		return
	hit_done = true

	set_physics_process(false)  # stop moving
	collision.set_deferred("disabled", true)

	if body.is_in_group("Light") and body.light_out == false:
		body.audio.play()
		body.light.energy = 0
		body.light_out = true
	if "health" in body:
		body.health -= damage
	if body.has_method("hit"):
		body.hit()

	if "hit_color" in body:
		var particle_instance = bullet_hit_particles.instantiate()
		get_tree().root.add_child(particle_instance)
		particle_instance.modulate = body.hit_color
		particle_instance.global_rotation = global_rotation
		particle_instance.global_position = global_position
		particle_instance.emitting = true
		particle_instance.finished.connect(particle_instance.queue_free)

	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
