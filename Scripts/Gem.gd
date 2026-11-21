extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 50
var can_pickup: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprites: Array = animated_sprite_2d.sprite_frames.get_animation_names()
	animated_sprite_2d.play(sprites.pick_random())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if can_pickup:
		if body.is_in_group("Player"):
			Global.gem_balance += Global.pickup_amount
			Global.player.gems_pulling.erase(self)
			queue_free()


func _on_pickup_timer_timeout() -> void:
	can_pickup = true
