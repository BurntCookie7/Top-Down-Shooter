extends RigidBody2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var sprite: LitSprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var range: Sprite2D = $Area2D/Sprite2D2

const friction = 45
var targets: Array
var damage_cap: int = 100
var damage_per_hit: int = 20
var total_damage_delt: int = 0
var thrower: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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

func damage():
	if total_damage_delt >= damage_cap:
		queue_free()
	match thrower:
		"Player":
			for target in targets:
				if is_instance_valid(target):
					if "health" in target and not target.is_in_group("Player"):
						if target.has_method("hit"):
							target.hit()
						target.health -= damage_per_hit
						total_damage_delt += damage_per_hit

func _on_timer_timeout() -> void:
	damage()


func _on_area_2d_body_entered(body: Node2D) -> void:
	targets.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in targets:
		targets.erase(body)
