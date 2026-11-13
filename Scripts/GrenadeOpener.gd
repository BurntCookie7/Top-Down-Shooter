extends StaticBody2D
@onready var input_display: Sprite2D = $Sprite2D2

@export var Menu_scene: PackedScene

var can_open: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("E") and can_open and not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		var menu = Menu_scene.instantiate()
		Global.canvas_layer.add_child(menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_open = true
		input_display.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_open = false
		input_display.hide()
