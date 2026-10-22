extends StaticBody2D
@onready var area_2d: Area2D = $Area2D
@onready var sitting_pos: Node2D = $SittingPos


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = true
		SignalBus.player_entered_bench.emit(self, sitting_pos.global_position)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.can_sit = false
