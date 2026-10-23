extends Area2D
@onready var timer: Timer = $Timer

@export var SPEED := 1000.0
@export var lifetime: float = 1.0

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
	if not body.is_in_group("Player"):
		if body.is_in_group("Light"):
			if body.light_out == false:
				body.audio.play()
				body.light.energy = 0
				body.light_out = true
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
