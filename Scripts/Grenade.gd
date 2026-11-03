extends RigidBody2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var sprite: LitSprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var range: Sprite2D = $Area2D/Sprite2D2

const friction = 45
var exploded = false
var flash_tween: Tween
var targets: Array
var damage: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	flash_tween = create_tween().set_loops()
	flash_tween.tween_property(sprite, "modulate", Color.RED, 0.15)
	flash_tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	linear_velocity = linear_velocity.move_toward(Vector2.ZERO, friction)
	

func throw(direction: Vector2, speed: float):
	linear_velocity = direction.normalized() * speed


func hit():
	explode()
	

func explode():
	if exploded:
		return
	exploded = true
	flash_tween.kill()
	range.hide()
	sprite.hide()
	for target in targets:
		if is_instance_valid(target):
			if "health" in target and not target.is_in_group("Player"):
				target.health -= damage
	particles.emitting = true
	audio.play()
	await particles.finished
	queue_free()

func _on_timer_timeout() -> void:
	explode()


func _on_area_2d_body_entered(body: Node2D) -> void:
	targets.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in targets:
		targets.erase(body)
