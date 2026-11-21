class_name DropTable extends Resource


@export var table: Dictionary[PackedScene, float]
@export var min_gems: int = 3
@export var max_gems: int = 10


func pick_item():
	var total = 0.0
	for weight in table.values():
		total += weight
	
	var roll: float = randf() * total
	
	for item in table:
		roll -= table[item]
		if roll <= 0.0:
			return item
	
	return null

func drop_gems(position):
	for i in randi_range(min_gems, max_gems):
		var gem = Global.gem.instantiate()
		gem.global_position = position
		gem.global_position += Vector2(randf_range(-50, 50), randf_range(-50, 50))
		Global.map.add_child(gem)
