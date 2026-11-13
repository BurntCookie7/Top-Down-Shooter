@tool
extends Control

@onready var texture_rect: TextureRect = $Panel/TextureRect
@onready var label: Label = $Panel/Panel/Label
@onready var equip: Button = $Panel/Equip

@export var Name: StringName
@export var image: Texture2D
@export var grenade_scene: PackedScene
@export var Inspector: Control
@export_multiline var Description: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = Name
	texture_rect.texture = image
	
func _physics_process(delta: float) -> void:
	if Global.grenade_scene == grenade_scene:
		equip.text = "Equipped"
	else:
		equip.text = "Equip"
	


func _on_button_pressed() -> void:
	Global.grenade_scene = grenade_scene
	Inspector.inspector_title.text = Name
	Inspector.description.text = Description
