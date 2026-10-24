extends Area2D
@onready var timer: Timer = $Timer
@export var bullet_hit_particles: PackedScene
@export var SPEED := 1000.0
@export var lifetime: float = 1.0
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var damage: int = 10

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
	collision.disabled = true
	if not body.is_in_group("Player"):
		if body.is_in_group("Light"):
			if body.light_out == false:
				body.audio.play()
				body.light.energy = 0
				body.light_out = true
	if "health" in body:
		body.health -= damage
	if body.has_method("hit"):
		body.hit()
	if "hit_color" in body:
		hide()
		collision.disabled = true
		var particle_instance = bullet_hit_particles.instantiate()
		get_tree().root.add_child(particle_instance)
		particle_instance.modulate = body.hit_color
		particle_instance.global_rotation = global_rotation
		particle_instance.global_position = global_position
		particle_instance.emitting = true
		await particle_instance.finished
		particle_instance.queue_free()
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
