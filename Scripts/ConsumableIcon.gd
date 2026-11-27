@tool
extends Control
@onready var label: Label = $Background/Label
@onready var icon: TextureRect = $Background/Icon
@onready var background: Panel = $Background


var quantity: int = 1
var selected: bool = false

@export var data: ConsumableData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_instance_valid(background):
		label.text = str(quantity)
		icon.texture = data.icon
