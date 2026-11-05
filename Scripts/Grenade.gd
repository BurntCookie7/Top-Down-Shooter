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
var damage_to_enemy: int = 100
var damage_to_player: int = 10
var thrower: String

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
	angular_velocity = move_toward(angular_velocity, 0, 1)

func throw(direction: Vector2, speed: float, thrown_by: String):
	thrower = thrown_by
	linear_velocity = direction.normalized() * speed
	angular_velocity = randf()*50


func hit():
	explode()
	

func explode():
	if exploded:
		return
	exploded = true
	flash_tween.kill()
	range.hide()
	sprite.hide()
	match thrower:
		"Player":
			for target in targets:
				if is_instance_valid(target):
					if "health" in target and not target.is_in_group("Player"):
						if target.has_method("hit"):
							target.hit()
						target.health -= damage_to_enemy
		"Enemy":
			for target in targets:
				if is_instance_valid(target):
					if target.is_in_group("Player"):
						Global.player_health -= damage_to_player
						

	Global.player.camera_shake(4.0)
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
