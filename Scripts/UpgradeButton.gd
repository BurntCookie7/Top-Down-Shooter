extends Control
@onready var title: Label = $Button/Label
@onready var description: RichTextLabel = $Button/RichTextLabel
@onready var texture: TextureRect = $Button/Label/TextureRect
@onready var button: Button = $Button

signal selected(upgrade, button)

var data: UpgradeData

func setup(upgrade: UpgradeData) -> void:
	data = upgrade

func _ready() -> void:
	title.text = data.title
	description.text = data.description
	texture.texture = data.icon
	return


func _on_button_pressed() -> void:
	print("pressed")
	selected.emit(data, self)
	print("emmited")
