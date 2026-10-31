extends Node

@export var initial_map: PackedScene
@export var enemies_container: Node
@export var map_cycle: Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.map_container = self
	load_new_map.call_deferred(initial_map)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func load_new_map(map: PackedScene) -> void:
	Global.enemies_killed = 0
	Global.won_round = false
	var prev_map = get_child(0)
	print(prev_map)
	if is_instance_valid(prev_map):
		for child in prev_map.get_children():
			remove_child(child)
			child.queue_free()
		remove_child(prev_map)

	if enemies_container:
		for enemy in enemies_container.get_children():
			enemy.queue_free()

	Global.map_scene = map
	var map_instance := map.instantiate()
	map_instance.z_index = -10
	add_child(map_instance)
	Global.map = map_instance
	if "enemy_amount" in map_instance:
		map_instance.enemy_amount += 2*Global.wins
	var spawn_point := map_instance.get_node_or_null("PlayerSpawn") as Node2D
	if spawn_point and is_instance_valid(Global.player):
		Global.player.global_position = spawn_point.global_position
