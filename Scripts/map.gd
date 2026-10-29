extends Node

@export var enemies_container: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.map_container = self
	load_new_map.call_deferred(Global.map_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func load_new_map(map: PackedScene) -> void:
	Global.enemies_killed = 0
	Global.won_round = false

	for child in get_children():
		remove_child(child)  # leaves the tree immediately, so no overlap
		child.queue_free()

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
