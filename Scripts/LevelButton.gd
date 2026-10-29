@tool
extends Control
@onready var button: Button = $Button

@export var Icon: Texture2D
@export var Text: String
@export var Map: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	button.icon = Icon
	button.text = Text


func _on_button_pressed() -> void:
	if not Engine.is_editor_hint():
		Global.map_scene = Map
		get_tree().change_scene_to_file("res://RootScene.tscn")
