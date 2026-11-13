extends Node2D

@export var enemy_amount: int
@export var nav_region: NavigationRegion2D
@export var enemy_spawn_interval: float
@export var enemies: Array[PackedScene]
@export var spawn_points_node: Node
@export var bench: PackedScene
@export var bench_location: Node2D
@export var resources: DropTable
var spawn_points: Array[Node2D]
var enemies_spawned: int = 0
@onready var enemies_container = get_parent().enemies_container
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_spawned = 0
	bench_location.hide()
	for child in spawn_points_node.get_children():
		spawn_points.append(child)
	setup_timers()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.enemies_killed >= enemy_amount:
		if Global.won_round:
			pass
		else:
			spawn_bench()
			Global.won_round = true


func setup_timers():
	var spawn_timer: Timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = enemy_spawn_interval
	spawn_timer.timeout.connect(spawn_timer_out)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	var resource_timer: Timer = Timer.new()
	resource_timer.name = "ResourceTimer"
	resource_timer.wait_time = 3.0
	resource_timer.timeout.connect(spawn_resources)
	resource_timer.autostart = true
	add_child(resource_timer)
	
func spawn_timer_out():
	if Global.enemies_active:
		if enemies_spawned < enemy_amount:
			if is_instance_valid(enemies_container):
				var spawn_point = spawn_points.pick_random()
				spawn_enemy(spawn_point)
			
func spawn_enemy(point):
	var enemy: CharacterBody2D = enemies.pick_random().instantiate()
	enemies_container.add_child(enemy)
	enemy.global_position = point.global_position
	enemies_spawned += 1

func spawn_resources():
	var resource: Node2D = resources.pick_item().instantiate()
	resource.global_position = get_random_free_location()
	resource.rotation = randf()
	Global.map.add_child(resource)

func get_random_free_location() -> Vector2:
	var pos := NavigationServer2D.region_get_random_point(
		nav_region.get_rid(), nav_region.navigation_layers, true)
	return pos if pos != Vector2.ZERO else Vector2.INF

func spawn_bench():
	var bench_instance: StaticBody2D = bench.instantiate()
	add_child(bench_instance)
	bench_instance.global_transform = bench_location.global_transform
