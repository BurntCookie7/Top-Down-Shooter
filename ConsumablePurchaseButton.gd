extends Control
@onready var title: Label = $Button/Label
@onready var description: RichTextLabel = $Button/RichTextLabel
@onready var texture: TextureRect = $Button/Label/TextureRect
@onready var button: Button = $Button
@onready var price_label: Label = $Button/Gems/Price

signal selected(data, button)

var data: ConsumableData
var price: int

func setup(cdata: ConsumableData) -> void:
	data = cdata
	if cdata.title in Global.upgrade_prices:
		price = Global.upgrade_prices[cdata.title]
	else:
		price = cdata.price
		Global.upgrade_prices[cdata.title] = price
	

func _ready() -> void:
	title.text = data.title
	description.text = data.description
	texture.texture = data.icon
	price_label.text = str(price)
	return

func _on_button_pressed() -> void:
	selected.emit(data, self, "Consumable")

func update_price():
	Global.upgrade_prices[data.title] += Global.price_increase_interval
	price_label.text = str(Global.upgrade_prices[data.title])
