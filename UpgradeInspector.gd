extends Panel

@onready var title: Label = $InspectorTitle
@onready var description: RichTextLabel = $Panel/Description
var selected_data: UpgradeData = null
var selected_button = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button_selected(data: UpgradeData, button):
	print("selected")
	title.text = data.title
	description.text = data.description
	selected_data = data
	selected_button = button


func _on_buy_pressed() -> void:
	if selected_data != null and selected_button != null:
		Global.player.apply_upgrade(selected_data, selected_button)
