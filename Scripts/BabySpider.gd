extends RigidBody2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var sprite: LitSprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var range: Sprite2D = $Area2D/Sprite2D2
@onready var collision: CollisionShape2D = $CollisionShape2D

const friction = 0
var damage: int = 10
var thrower: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	linear_velocity = linear_velocity.move_toward(Vector2.ZERO, friction)
	#angular_velocity = move_toward(angular_velocity, 0, 1)

func throw(direction: Vector2, speed: float, thrower: String):
	linear_velocity = direction.normalized() * speed
	#angular_velocity = randf()*50


func _on_body_entered(body: Node) -> void:
	match thrower:
		"Enemy":
			if not body.is_in_group("Enemy"):
				if "health" in body:
					body.health -= damage
				if body.is_in_group("Player"):
					Global.player_health -= damage
				else:
					pass
		"Player":
			if not body.is_in_group("Player"):
				if "health" in body:
					body.health -= damage
	particles.emitting = true
	collision.disabled = true
	linear_velocity = Vector2.ZERO
	sprite.hide()
	await particles.finished
	queue_free()
