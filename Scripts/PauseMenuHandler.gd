extends Control

@export var settings_menu: PackedScene
@export var canvas_layer: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	hide()
	if Global.player.state == Global.State.SITTING:
		pass
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = not get_tree().paused


func _on_settings_pressed() -> void:
	var menu = settings_menu.instantiate()
	canvas_layer.add_child(menu)
	menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TitleScreen.tscn")
