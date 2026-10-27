extends Control

signal pressed

@onready var button: Button = $Button

var data: UpgradeData

func setup(upgrade: UpgradeData) -> void:
	data = upgrade

func _ready() -> void:
	button.text = data.title + "\n" + data.description
	button.icon = data.icon
	button.pressed.connect(func(): pressed.emit())
