extends Node2D

@export var enemy_amount: int
@export var enemy_spawn_interval: float
@export var enemies: Array[PackedScene]
@export var spawn_points_node: Node
@export var bench: PackedScene
@export var bench_location: Node2D
var spawn_points: Array[Node2D]
var enemies_spawned: int = 0
@onready var enemies_container = get_parent().enemies_container
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bench_location.hide()
	for child in spawn_points_node.get_children():
		spawn_points.append(child)
	setup_timer()
	print(spawn_points)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.enemies_killed >= enemy_amount:
		spawn_bench()


func setup_timer():
	var spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = enemy_spawn_interval
	spawn_timer.timeout.connect(timer_out)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
func timer_out():
	if enemies_spawned < enemy_amount:
		if is_instance_valid(enemies_container):
			var spawn_point = spawn_points.pick_random()
			spawn_enemy(spawn_point)
		
func spawn_enemy(point):
	var enemy: CharacterBody2D = enemies.pick_random().instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = point.global_position
	enemies_spawned += 1
	
func spawn_bench():
	var bench_instance: StaticBody2D = bench.instantiate()
	add_child(bench_instance)
	bench_instance.global_transform = bench_location.global_transform
