extends Node2D

# Using 'as Node2D' prevents a hard crash if the parent isn't a Node2D
var bench: Node2D = null

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(bench):
		bench = get_tree().get_first_node_in_group("Bench") as Node2D
		if bench:
			print("Bench found: ", bench.name)

	if is_instance_valid(bench):
		show()
		var bench_screen_pos = get_viewport().get_canvas_transform() * bench.global_position
		look_at(bench_screen_pos)
	else:
		hide()
