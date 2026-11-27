extends Panel

@onready var title: Label = $InspectorTitle
@onready var description: RichTextLabel = $Panel/Description
var selected_data: Resource = null
var selected_button = null
var selected_type: String = "nothing"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button_selected(data: Resource, button, type):
	print(str(button) + ", " + str(data))
	title.text = data.title
	description.text = data.description
	selected_data = data
	selected_button = button
	selected_type = type


func _on_buy_pressed() -> void:
	match selected_type:
		"Upgrade":
			if selected_data != null and selected_button != null:
				if Global.gem_balance >= selected_button.price:
					Global.gem_balance -= selected_button.price
					Global.player.apply_upgrade(selected_data, selected_button)
					selected_button.update_price()
		"Consumable":
			if selected_data != null and selected_button != null:
				if Global.gem_balance >= selected_button.price:
					Global.gem_balance -= selected_button.price
					for item in Global.player_ui.consumables:
						if item.data == selected_data:
							item.quantity += 1
					selected_button.update_price()


func _on_continue_pressed() -> void:
	Global.player.finish_bench()
