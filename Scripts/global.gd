extends Node

enum State{WALKING, RUNNING, SITTING, STANDING}
var can_sit: bool = false
var upgrade_menu
var enemy_drop_chance: Vector2 = Vector2(1,3)
var map_scene: PackedScene
var enemies_killed: int = 0
var won_round: bool = false
var player_health: int = 100
var player_max_health: int = 100
var player: Node2D
var map_container: Node
var map: Node2D
var wins: int = 1
var cycle: int = 0
var rounds: int = 5
var loops: int = 1
var player_max_grenades = 3
var player_control_mode: String = "Mouse_Turn"
var enemy_damage_mult = 1.0
var enemy_health_mult = 2.0
var arachnophobia: bool = false
var benches: int = 1
var upgrades: int = 6
var ammo_per_pickup: int = 5
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

func restart():
	can_sit = false
	upgrade_menu
	enemies_killed = 0
	won_round = false
	player_health = 100
	player_max_health = 100
	wins = 1
	cycle = 0
	rounds = 5
	loops = 1
	player_max_grenades = 5
	map_container.load_new_map(map_container.initial_map)
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()
	
