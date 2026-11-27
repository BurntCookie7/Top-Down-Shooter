class_name DropTable extends Resource


@export var table: Dictionary[PackedScene, float]
@export var min_gems: int = 1
@export var max_gems: int = 2


func pick_item():
	for i in range(Global.enemy_drop_mult):
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
	for i in range(Global.enemy_damage_mult):
		for j in randi_range(min_gems + Global.gem_drop_mult, max_gems + Global.gem_drop_mult):
			var gem = Global.gem.instantiate()
			gem.global_position = position
			gem.global_position += Vector2(randf_range(-50, 50), randf_range(-50, 50))
			Global.map.add_child(gem)
