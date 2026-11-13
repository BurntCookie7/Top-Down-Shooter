extends Node2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var settings_menu_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#===Play Button===#
func _on_button_pressed() -> void:
	Global.map = preload("res://Lobby.tscn").instantiate()
	get_tree().change_scene_to_file("res://RootScene.tscn")
#===End===#


#==Settings Button==#
func _on_settings_pressed() -> void:
	var menu = settings_menu_scene.instantiate()
	canvas_layer.add_child(menu)
#==End==#


func _on_quit_pressed() -> void:
	get_tree().quit()
