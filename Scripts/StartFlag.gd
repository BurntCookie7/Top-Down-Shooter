extends StaticBody2D
@onready var input_display: Sprite2D = $Sprite2D2

@export var map: PackedScene

var can_start: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("E") and can_start:
		Global.map_container.load_new_map(map)
		Global.enemies_active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_start = true
		input_display.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_start = false
		input_display.hide()
