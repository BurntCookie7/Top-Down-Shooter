extends Control

@export var retry_map: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	Global.restart()
	Global.map_container.load_new_map(retry_map)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://TitleScreen.tscn")
