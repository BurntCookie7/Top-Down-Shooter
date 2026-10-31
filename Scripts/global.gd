extends Node

enum State{WALKING, RUNNING, SITTING, STANDING}
var can_sit: bool = false
var upgrade_menu
var enemy_drop_chance: Vector2 = Vector2(1,3)
var map_scene: PackedScene
var enemies_killed: int = 0
var won_round: bool = false
var player_health: int = 90
var player_max_health: int = 100
var player: Node2D
var map_container: Node
var map: Node2D
var wins: int = 0
var cycle: int = 0
var rounds: int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wait(frames: int):
	for i in range(frames):
		await get_tree().physics_frame

func _physics_process(delta: float) -> void:
	pass
