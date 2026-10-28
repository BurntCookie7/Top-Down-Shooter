extends Node

@export var enemies_container: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_instance = Global.map.instantiate()
	add_child(map_instance)
	map_instance.z_index = -10
	Global.enemies_killed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
