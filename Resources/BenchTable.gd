class_name BenchTable extends Resource


@export var table: Dictionary[UpgradeData, float]

func pick_random():
	var total = 0.0
	for weight in table.values():
		total += weight
	
	var roll: float = randf() * total
	
	for item in table:
		roll -= table[item]
		if roll <= 0.0:
			return item
	
	return null
