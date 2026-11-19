extends Control
@onready var title: Label = $Button/Label
@onready var description: RichTextLabel = $Button/RichTextLabel
@onready var texture: TextureRect = $Button/Label/TextureRect
@onready var button: Button = $Button
@onready var trash: Button = $Button/Button

signal pressed
signal trashed(button)

var data: UpgradeData

func setup(upgrade: UpgradeData) -> void:
	data = upgrade

func _ready() -> void:
	title.text = data.title
	description.text = data.description
	texture.texture = data.icon
	button.pressed.connect(func(): pressed.emit())
	trash.pressed.connect(func(): trashed.emit(self))
	return
