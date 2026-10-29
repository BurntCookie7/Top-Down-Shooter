extends Area2D
@export var Health_Amount: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if "health" in body:
			if body.health + Global.player_health < Global.player_max_health:
				body.health += Health_Amount
				queue_free()
			else:
				if Global.player_health + Health_Amount > Global.player_max_health:
					body.health += Global.player_max_health - Global.player_health
