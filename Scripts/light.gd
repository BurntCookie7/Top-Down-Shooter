@tool
extends StaticBody2D
@onready var light: LitPointLight2D = $LitDirectionalLight2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var hit_color: Color
@export var color: Color
var light_out: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light.color = color
