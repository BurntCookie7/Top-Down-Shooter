extends Panel

@onready var inspector_title: Label = $InspectorTitle
@onready var description: RichTextLabel = $Panel/Description

@export var options: Array[Control]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for option in options:
		if Global.grenade_scene == option.grenade_scene:
			inspector_title.text = option.Name
			description.text = option.Description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
