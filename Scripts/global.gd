extends Node

enum State{WALKING, RUNNING, SITTING, STANDING}
var can_sit: bool = false
var upgrade_menu
var enemy_drop_chance: Vector2 = Vector2(1,3)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wait(frames: int):
	for i in range(frames):
		await get_tree().physics_frame
